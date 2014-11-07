Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaKGQrE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 11:47:04 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id EC3DBACF9
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Nov 2014 16:47:03 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/4] btrfs: more superblock checks, lower bounds on devices and sectorsize/nodesize
Date: Fri,  7 Nov 2014 17:47:03 +0100
Message-Id: <e91b92d23dae162036675f0abda279a01ac72def.1415378049.git.dsterba@suse.cz>
In-Reply-To: <cover.1415378049.git.dsterba@suse.cz>
References: <cover.1415378049.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I received a few crafted images from Jiri, all got through the recently
added superblock checks. The lower bounds checks for num_devices and
sector/node -sizes were missing and caused a crash during mount.

Tools for symbolic code execution were used to prepare the images
contents.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/disk-io.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7af9a1978a2f..e97fa11488f1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3847,6 +3847,21 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 		printk(KERN_WARNING "BTRFS: log_root block unaligned: %llu\n",
 				btrfs_super_log_root(sb));
 
+	/*
+	 * Check the lower bound, the alignment and other constraints are
+	 * checked later.
+	 */
+	if (btrfs_super_nodesize(sb) < 4096) {
+		printk(KERN_ERR "BTRFS: nodesize too small: %llu < 4096\n",
+				btrfs_super_nodesize(sb));
+		ret = -EINVAL;
+	}
+	if (btrfs_super_sectorsize(sb) < 4096) {
+		printk(KERN_ERR "BTRFS: sectorsize too small: %llu < 4096\n",
+				btrfs_super_sectorsize(sb));
+		ret = -EINVAL;
+	}
+
 	if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_UUID_SIZE) != 0) {
 		printk(KERN_ERR "BTRFS: dev_item UUID does not match fsid: %pU != %pU\n",
 				fs_info->fsid, sb->dev_item.fsid);
@@ -3860,6 +3875,10 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	if (btrfs_super_num_devices(sb) > (1UL << 31))
 		printk(KERN_WARNING "BTRFS: suspicious number of devices: %llu\n",
 				btrfs_super_num_devices(sb));
+	if (btrfs_super_num_devices(sb) == 0) {
+		printk(KERN_ERR "BTRFS: number of devices is 0\n");
+		ret = -EINVAL;
+	}
 
 	if (btrfs_super_bytenr(sb) != BTRFS_SUPER_INFO_OFFSET) {
 		printk(KERN_ERR "BTRFS: super offset mismatch %llu != %u\n",
-- 
1.8.4.5

