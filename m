Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 236E8C2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 14:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E89242075D
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 14:43:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E89242075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbeJ3XhW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 19:37:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:42348 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726537AbeJ3XhT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 19:37:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E7405B0F8
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 14:43:32 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 6/6] btrfs: Handle final split-brain possibility during fsid change
Date:   Tue, 30 Oct 2018 16:43:28 +0200
Message-Id: <1540910608-4121-7-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1540910608-4121-1-git-send-email-nborisov@suse.com>
References: <1540910608-4121-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch lands the last case which needs to be handled by the fsid
change code. Namely, this is the case where a multidisk filesystem has
already undergone at least one successful fsid change i.e all disks
have the METADATA_UUID incompat bit and power failure occurs as another
fsid change is in progress. When such an event occurs, disks could be
split in 2 groups. One of the groups will have both METADATA_UUID and
CHANGING_FSID_V2 flags set coupled with old fsid/metadata_uuid pairs.
The other group of disks will have only METADATA_UUID bit set and their
fsid will be different than the one in disks in the first group. Here
we look at the following cases:

  a) A disk from the first group is scanned first, so fs_devices is
  created with stale fsid/metdata_uuid. Then when a disk from the
  second group is scanned it needs to first check whether there exists
  such an fs_devices that has fsid_change set to true (because it was
  created with a disk having the CHANGING_FSID_V2 flag), the
  metadata_uuid and fsid of the fs_devices will be different (since it was
  created by a disk which already has had at least 1 successful fsid change)
  and finally the metadata_uuid of the fs_devices will equal that of the
  currently scanned disk (because metadata_uuid never really changes).
  When the correct fs_devices is found the information from the scanned
  disk will replace the current one in fs_devices since the scanned disk
  will have higher generation number.

  b) A disk from the second group is scanned so fs_devices is created
  as usual with differing fsid/metdata_uid. Then when a disk from the
  first group is scanned the code detects that it has both
  CHANGING_FSID_V2 and METADATA_UUID flags set and will search for
  fs_devices that has differing metadata_uuid/fsid and whose
  metadata_uuid is the same as that of the scanned device.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 65 ++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 53 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f967e995feff..0ce2600c63b8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -383,7 +383,6 @@ find_fsid(const u8 *fsid, const u8 *metadata_fsid)
 	ASSERT(fsid);
 
 	if (metadata_fsid) {
-
                /*
                 * Handle scanned device having completed its fsid change but
                 * belonging to a fs_devices that was created by first scanning
@@ -399,6 +398,21 @@ find_fsid(const u8 *fsid, const u8 *metadata_fsid)
                                return fs_devices;
                        }
                }
+		/*
+		 * Handle scanned device having completed its fsid change but
+		 * belonging to a fs_devices that was created by a device that
+		 * has an outdated pair of fsid/metadata_uuid and
+		 * CHANGING_FSID_V2 flag set.
+		 */
+		list_for_each_entry(fs_devices, &fs_uuids, fs_list) {
+			if (fs_devices->fsid_change &&
+			    memcmp(fs_devices->metadata_uuid,
+				   fs_devices->fsid, BTRFS_FSID_SIZE) != 0 &&
+			    memcmp(metadata_fsid, fs_devices->metadata_uuid,
+				   BTRFS_FSID_SIZE) == 0) {
+				return fs_devices;
+			}
+		}
 	}
 
 	/* Handle non-split brain cases */
@@ -808,6 +822,30 @@ static struct btrfs_fs_devices *find_fsid_inprogress(
 	return NULL;
 }
 
+
+static struct btrfs_fs_devices *find_fsid_changed(
+					struct btrfs_super_block *disk_super)
+{
+	struct btrfs_fs_devices *fs_devices;
+
+	/*
+	 * Handles the case where scanned device is part of an fs that had
+	 * multiple successful changes of FSID but curently device didn't
+	 * observe it. Meaning our fsid will be different than theirs.
+	 */
+	list_for_each_entry(fs_devices, &fs_uuids, fs_list) {
+		if (memcmp(fs_devices->metadata_uuid, fs_devices->fsid,
+			   BTRFS_FSID_SIZE) != 0 &&
+		    memcmp(fs_devices->metadata_uuid, disk_super->metadata_uuid,
+			   BTRFS_FSID_SIZE) == 0 &&
+		    memcmp(fs_devices->fsid, disk_super->fsid,
+			   BTRFS_FSID_SIZE) != 0) {
+			return fs_devices;
+		}
+	}
+
+	return NULL;
+}
 /*
  * Add new device to list of registered devices
  *
@@ -829,17 +867,20 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 	bool fsid_change_in_progress = (btrfs_super_flags(disk_super) &
 					BTRFS_SUPER_FLAG_CHANGING_FSID_V2);
 
-	if (fsid_change_in_progress && !has_metadata_uuid) {
-               /*
-                * When we have an image which has CHANGING_FSID_V2 set it might
-		* belong to either a filesystem which has disks with completed
-		* fsid change or it might belong to fs with no uuid changes in
-		* effect, handle both.
-                */
-		fs_devices = find_fsid_inprogress(disk_super);
-		if (!fs_devices)
-			fs_devices = find_fsid(disk_super->fsid, NULL);
-
+	if (fsid_change_in_progress) {
+		if (!has_metadata_uuid) {
+			/*
+			 * When we have an image which has CHANGING_FSID_V2 set
+			 * it might belong to either a filesystem which has
+			 * disks with completed fsid change or it might belong
+			 * to fs with no uuid changes in effect, handle both.
+			 */
+			fs_devices = find_fsid_inprogress(disk_super);
+			if (!fs_devices)
+				fs_devices = find_fsid(disk_super->fsid, NULL);
+		} else {
+			fs_devices = find_fsid_changed(disk_super);
+		}
 	} else if (has_metadata_uuid) {
 		fs_devices = find_fsid(disk_super->fsid,
 				       disk_super->metadata_uuid);
-- 
2.7.4

