From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/2] btrfs: implement super op contains_bdev
Date: Mon, 14 Mar 2011 11:37:40 -0400
Message-ID: <1300117060-13613-3-git-send-email-josef@redhat.com>
References: <1300117060-13613-1-git-send-email-josef@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	viro@ZenIV.linux.org.uk, hch@infradead.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1300117060-13613-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

This patch implements the super op contains_bdev.  We just loop through the
fs_devices on this super looking for the block device that was requested.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/super.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d39a989..1487bef 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1095,6 +1095,26 @@ static int btrfs_unfreeze(struct super_block *sb)
 	return 0;
 }
 
+static int btrfs_contains_bdev(struct super_block *sb,
+			       struct block_device *bdev)
+{
+	struct btrfs_root *root = btrfs_sb(sb);
+	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
+	struct btrfs_device *device;
+	int ret = 0;
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+		if (device->bdev == bdev) {
+			ret = 1;
+			break;
+		}
+	}
+	mutex_unlock(&fs_devices->device_list_mutex);
+
+	return ret;
+}
+
 static const struct super_operations btrfs_super_ops = {
 	.drop_inode	= btrfs_drop_inode,
 	.evict_inode	= btrfs_evict_inode,
@@ -1109,6 +1129,7 @@ static const struct super_operations btrfs_super_ops = {
 	.remount_fs	= btrfs_remount,
 	.freeze_fs	= btrfs_freeze,
 	.unfreeze_fs	= btrfs_unfreeze,
+	.contains_bdev	= btrfs_contains_bdev,
 };
 
 static const struct file_operations btrfs_ctl_fops = {
-- 
1.7.2.3

