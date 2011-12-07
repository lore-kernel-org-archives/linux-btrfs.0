From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] Btrfs: fix possible deadlock when opening a seed device
Date: Wed, 07 Dec 2011 13:13:26 +0800
Message-ID: <4EDEF5F6.7050700@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The correct lock order is uuid_mutex -> volume_mutex -> chunk_mutex,
but when we mount a filesystem which has backing seed devices, we have
this lock chain:

    open_ctree()
        lock(chunk_mutex);
        read_chunk_tree();
            read_one_dev();
                open_seed_devices();
                    lock(uuid_mutex);

and then we hit a lockdep splat.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |    2 --
 fs/btrfs/volumes.c |    9 +++++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 94abc25..b2d103f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2262,9 +2262,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	   (unsigned long)btrfs_header_chunk_tree_uuid(chunk_root->node),
 	   BTRFS_UUID_SIZE);
 
-	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_chunk_tree(chunk_root);
-	mutex_unlock(&fs_info->chunk_mutex);
 	if (ret) {
 		printk(KERN_WARNING "btrfs: failed to read chunk tree on %s\n",
 		       sb->s_id);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c37433d..51b8a8d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3562,7 +3562,7 @@ static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
 	struct btrfs_fs_devices *fs_devices;
 	int ret;
 
-	mutex_lock(&uuid_mutex);
+	BUG_ON(!mutex_is_locked(&uuid_mutex));
 
 	fs_devices = root->fs_info->fs_devices->seed;
 	while (fs_devices) {
@@ -3600,7 +3600,6 @@ static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
 	fs_devices->seed = root->fs_info->fs_devices->seed;
 	root->fs_info->fs_devices->seed = fs_devices;
 out:
-	mutex_unlock(&uuid_mutex);
 	return ret;
 }
 
@@ -3743,6 +3742,9 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
 	if (!path)
 		return -ENOMEM;
 
+	mutex_lock(&uuid_mutex);
+	lock_chunks(root);
+
 	/* first we search for all of the device items, and then we
 	 * read in all of the chunk items.  This way we can create chunk
 	 * mappings that reference all of the devices that are afound
@@ -3793,6 +3795,9 @@ again:
 	}
 	ret = 0;
 error:
+	unlock_chunks(root);
+	mutex_unlock(&uuid_mutex);
+
 	btrfs_free_path(path);
 	return ret;
 }
-- 1.7.3.1 
