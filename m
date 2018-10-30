Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BEEECDE44
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 14:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 915842075D
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 14:43:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 915842075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbeJ3XhR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 19:37:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:42318 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725853AbeJ3XhR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 19:37:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0F797B0F5
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 14:43:32 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/6] btrfs: Add handling for disk split-brain scenario during fsid change
Date:   Tue, 30 Oct 2018 16:43:25 +0200
Message-Id: <1540910608-4121-4-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1540910608-4121-1-git-send-email-nborisov@suse.com>
References: <1540910608-4121-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Even though fsid change without rewrite is a very quick operations it's
still possible to experience a split brain scenario if power loss
occurs at the right time. This patch handle the case where power
failure occurs while the first transaction (the one setting
CHANGING_FSID_V2) flag is being persisted on disk. This can cause
the btrfs_fs_devices of this filesystem to be created by a device which:

 a) has the CHANGING_FSID_V2 flag set but its fsid value is intact

 b) or a device which doesn't have CHANGING_FSID_V2 flag set and its
 fsid value is intact

This situation is trivially handled by the current find_fsid code since
in both cases the devices are going to be treated like ordinary devices.
Since btrfs is always mounted using the superblock of the latest
device (the one with highest generation number), meaning it will have
the CHANGING_FSID_V2 flag set, ensure it's being cleared on mount. On
the first transaction commit following mount all disks will have it
cleared.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a458ef5b605e..6498434c2e06 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2831,10 +2831,10 @@ int open_ctree(struct super_block *sb,
 	 * the whole block of INFO_SIZE
 	 */
 	memcpy(fs_info->super_copy, bh->b_data, sizeof(*fs_info->super_copy));
-	memcpy(fs_info->super_for_commit, fs_info->super_copy,
-	       sizeof(*fs_info->super_for_commit));
 	brelse(bh);
 
+	disk_super = fs_info->super_copy;
+
 	ASSERT(!memcmp(fs_info->fs_devices->fsid, fs_info->super_copy->fsid,
 		       BTRFS_FSID_SIZE));
 
@@ -2844,6 +2844,15 @@ int open_ctree(struct super_block *sb,
 				BTRFS_FSID_SIZE));
 	}
 
+	features = btrfs_super_flags(disk_super);
+	if (features & BTRFS_SUPER_FLAG_CHANGING_FSID_V2) {
+		features &= ~BTRFS_SUPER_FLAG_CHANGING_FSID_V2;
+		btrfs_set_super_flags(disk_super, features);
+		btrfs_info(fs_info, "found metadata uuid in progress flag. Clearing");
+	}
+
+	memcpy(fs_info->super_for_commit, fs_info->super_copy,
+	       sizeof(*fs_info->super_for_commit));
 
 	ret = btrfs_validate_mount_super(fs_info);
 	if (ret) {
@@ -2852,7 +2861,6 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
-	disk_super = fs_info->super_copy;
 	if (!btrfs_super_root(disk_super))
 		goto fail_alloc;
 
-- 
2.7.4

