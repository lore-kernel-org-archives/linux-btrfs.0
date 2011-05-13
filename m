From: Mark Fasheh <mfasheh@suse.com>
Subject: [RFC][PATCH 2/2] Subject: btrfs: Introduce btrfs_get_maps_dev()
Date: Fri, 13 May 2011 16:20:17 -0700
Message-ID: <1305328817-10067-2-git-send-email-mfasheh@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mark Fasheh <mfasheh@suse.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Use this to return the subvolume superblock in proc instead of the global
superblock which is automatically taken today. This fixes a userspace
breakage where discrepancies between the devices two would confuse software
such as lsof.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/super.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 58e7de9..d241fb0 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1115,6 +1115,11 @@ static int btrfs_unfreeze(struct super_block *sb)
 	return 0;
 }
 
+static dev_t btrfs_get_maps_dev(struct inode *inode)
+{
+	return BTRFS_I(inode)->root->anon_super.s_dev;
+}
+
 static const struct super_operations btrfs_super_ops = {
 	.drop_inode	= btrfs_drop_inode,
 	.evict_inode	= btrfs_evict_inode,
@@ -1129,6 +1134,7 @@ static const struct super_operations btrfs_super_ops = {
 	.remount_fs	= btrfs_remount,
 	.freeze_fs	= btrfs_freeze,
 	.unfreeze_fs	= btrfs_unfreeze,
+	.get_maps_dev	= btrfs_get_maps_dev,
 };
 
 static const struct file_operations btrfs_ctl_fops = {
-- 
1.6.4.2

