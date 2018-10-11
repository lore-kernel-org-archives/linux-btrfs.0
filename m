Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E35C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67B7C2075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:03:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67B7C2075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbeJKWbH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 18:31:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:49708 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727864AbeJKWbG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 18:31:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 57512B636
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 15:03:30 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 5/6] btrfs: Handle one more split-brain scenario during fsid change
Date:   Thu, 11 Oct 2018 18:03:25 +0300
Message-Id: <1539270206-27005-6-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1539270206-27005-1-git-send-email-nborisov@suse.com>
References: <1539270206-27005-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This commit continues hardening the scanning code to handle cases where
power loss could have caused disks in a multi-disk filesystem to be
in inconsistent state. Namely handle the situation that can occur when
some of the disks in multi-disk fs have completed their fsid change i.e
they have METADATA_UUID incompat flag set, have cleared the
FSID_CHANGING_V2 flag and their fsid/metadata_uuid are different. At
the same time the other half of the disks will have their
fsid/metadata_uuid unchanged and will only have FSID_CHANGING_V2 flag.

This is handled by adding additional code in the scan path which:

 a) In case first a device with FSID_CHANGING_V2 flag is scanned and
 btrfs_fs_devices is created with matching fsid/metdata_uuid then when
 a device with completed fsid change is scanned it will detect this
 via the new code in find_fsid i.e that such an fs_devices exist that
 fsid_change flag is set to true, it's metadata_uuid/fsid match and
 the metadata_uuid of the scanned device matches that of the fs_devices.
 In this case, it's important to note that the devices which has its
 fsid change completed will have a higher generation number than the
 device with FSID_CHANGING_V2 flag set, so its superblock block will
 be used during mount. To prevent an assertion triggering because
 the sb used for mounting will have differing fsid/metadata_uuid than
 the ones in the fs_devices struct also add code in device_list_add
 which overwrites the values in fs_devices.

 b) Alternatively we can end up with a device that completed its
 fsid change to be scanned first which will create the respective
 btrfs_fs_devices struct with differing fsid/metadata_uuid. In this
 case when a device with FSID_CHANGING_V2 flag set is scanned it will
 call the newly added find_fsid_inprogress function which will return
 the correct fs_devices.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 74 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c2b66d15e08d..2c9879a81884 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -382,6 +382,26 @@ find_fsid(const u8 *fsid, const u8 *metadata_fsid)
 
 	ASSERT(fsid);
 
+	if (metadata_fsid) {
+
+               /*
+                * Handle scanned device having completed its fsid change but
+                * belonging to a fs_devices that was created by first scanning
+                * a device which didn't have it's fsid/metadata_uuid changed
+                * at all and the CHANGING_FSID flag set. 4/a
+                */
+               list_for_each_entry(fs_devices, &fs_uuids, fs_list) {
+                       if (fs_devices->fsid_change &&
+                           memcmp(metadata_fsid, fs_devices->fsid,
+                                  BTRFS_FSID_SIZE) == 0 &&
+                           memcmp(fs_devices->fsid, fs_devices->metadata_uuid,
+                                  BTRFS_FSID_SIZE) == 0) {
+                               return fs_devices;
+                       }
+               }
+	}
+
+	/* Handle non-split brain cases */
 	list_for_each_entry(fs_devices, &fs_uuids, fs_list) {
 		if (metadata_fsid) {
 			if (memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE) == 0
@@ -768,6 +788,27 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 }
 
 /*
+ * Handle scanned device having its FSID_CHANGING flag set and the fs_devices
+ * being created with a disk that has already completed its fsid change.
+ */
+static struct btrfs_fs_devices *find_fsid_inprogress(
+					struct btrfs_super_block *disk_super)
+{
+	struct btrfs_fs_devices *fs_devices;
+
+	list_for_each_entry(fs_devices, &fs_uuids, fs_list) {
+		if (memcmp(fs_devices->metadata_uuid, fs_devices->fsid,
+			   BTRFS_FSID_SIZE) != 0 &&
+		    memcmp(fs_devices->metadata_uuid, disk_super->fsid,
+			   BTRFS_FSID_SIZE) == 0 && !fs_devices->fsid_change) {
+			return fs_devices;
+		}
+	}
+
+	return NULL;
+}
+
+/*
  * Add new device to list of registered devices
  *
  * Returns:
@@ -779,7 +820,7 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 			   bool *new_device_added)
 {
 	struct btrfs_device *device;
-	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_fs_devices *fs_devices = NULL;
 	struct rcu_string *name;
 	u64 found_transid = btrfs_super_generation(disk_super);
 	u64 devid = btrfs_stack_device_id(&disk_super->dev_item);
@@ -788,10 +829,24 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 	bool fsid_change_in_progress = (btrfs_super_flags(disk_super) &
 					BTRFS_SUPER_FLAG_CHANGING_FSID_v2);
 
-	if (has_metadata_uuid)
-		fs_devices = find_fsid(disk_super->fsid, disk_super->metadata_uuid);
-	else
+	if (fsid_change_in_progress && !has_metadata_uuid) {
+               /*
+                * When we have an image which has FSID_CHANGE set
+                * it might belong to either a filesystem which has
+                * disks with completed fsid change or it might belong
+                * to fs with no uuid changes in effect, handle both.
+                */
+		fs_devices = find_fsid_inprogress(disk_super);
+		if (!fs_devices)
+			fs_devices = find_fsid(disk_super->fsid, NULL);
+
+	} else if (has_metadata_uuid) {
+		fs_devices = find_fsid(disk_super->fsid,
+				       disk_super->metadata_uuid);
+	} else {
 		fs_devices = find_fsid(disk_super->fsid, NULL);
+	}
+
 
 	if (!fs_devices) {
 		if (has_metadata_uuid)
@@ -813,6 +868,21 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		mutex_lock(&fs_devices->device_list_mutex);
 		device = find_device(fs_devices, devid,
 				disk_super->dev_item.uuid);
+
+                /*
+                 * If this disk has been pulled into an fs devices created by
+                 * a device which had the FSID_CHANGING flag then replace the
+                 * metadata_uuid/fsid values of the fs_devices.
+                 */
+                if (has_metadata_uuid && fs_devices->fsid_change &&
+                    found_transid > fs_devices->latest_generation) {
+                        memcpy(fs_devices->fsid, disk_super->fsid,
+                               BTRFS_FSID_SIZE);
+                        memcpy(fs_devices->metadata_uuid,
+                               disk_super->metadata_uuid, BTRFS_FSID_SIZE);
+
+                        fs_devices->fsid_change = false;
+                }
 	}
 
 	if (!device) {
-- 
2.7.4

