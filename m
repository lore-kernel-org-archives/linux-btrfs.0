Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410A7C4161D
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 123A42075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:03:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 123A42075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbeJKWbF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 18:31:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:49700 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726071AbeJKWbE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 18:31:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 49FE3B635
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 15:03:30 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/6] btrfs: Introduce 2 more members to struct btrfs_fs_devices
Date:   Thu, 11 Oct 2018 18:03:24 +0300
Message-Id: <1539270206-27005-5-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1539270206-27005-1-git-send-email-nborisov@suse.com>
References: <1539270206-27005-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In order to gracefully handle split-brain scenario which are very
unlikely, yet still possible while performing the FSID change I'm
gonna need two more pieces of information:
 1. The highes generation number among all devices registered to a
 particular btrfs_fs_devices

 2. A boolean flag whether a given btrfs_fs_devices was created by a
 device which had the FSID_CHANGING_V2 flag set.

This is a preparatory patch and just introduces the variables as well
as code which sets, their actual use is going to happen in a later
patch.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 9 ++++++++-
 fs/btrfs/volumes.h | 5 +++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bf0aa900f22c..c2b66d15e08d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -785,6 +785,8 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 	u64 devid = btrfs_stack_device_id(&disk_super->dev_item);
 	bool has_metadata_uuid = (btrfs_super_incompat_flags(disk_super) &
 		BTRFS_FEATURE_INCOMPAT_METADATA_UUID);
+	bool fsid_change_in_progress = (btrfs_super_flags(disk_super) &
+					BTRFS_SUPER_FLAG_CHANGING_FSID_v2);
 
 	if (has_metadata_uuid)
 		fs_devices = find_fsid(disk_super->fsid, disk_super->metadata_uuid);
@@ -798,6 +800,8 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		else
 			fs_devices = alloc_fs_devices(disk_super->fsid, NULL);
 
+		fs_devices->fsid_change = fsid_change_in_progress;
+
 		if (IS_ERR(fs_devices))
 			return ERR_CAST(fs_devices);
 
@@ -904,8 +908,11 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 	 * it back. We need it to pick the disk with largest generation
 	 * (as above).
 	 */
-	if (!fs_devices->opened)
+	if (!fs_devices->opened) {
 		device->generation = found_transid;
+		fs_devices->latest_generation= max(found_transid,
+						fs_devices->latest_generation);
+	}
 
 	fs_devices->total_devices = btrfs_super_num_devices(disk_super);
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 04860497b33c..6b2a01c55426 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -211,6 +211,7 @@ BTRFS_DEVICE_GETSET_FUNCS(bytes_used);
 struct btrfs_fs_devices {
 	u8 fsid[BTRFS_FSID_SIZE]; /* FS specific uuid */
 	u8 metadata_uuid[BTRFS_FSID_SIZE];
+	bool fsid_change;
 	struct list_head fs_list;
 
 	u64 num_devices;
@@ -219,6 +220,10 @@ struct btrfs_fs_devices {
 	u64 missing_devices;
 	u64 total_rw_bytes;
 	u64 total_devices;
+
+	/* Highest generation number of seen devices */
+	u64 latest_generation;
+
 	struct block_device *latest_bdev;
 
 	/* all of the devices in the FS, protected by a mutex
-- 
2.7.4

