From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 11/11] Btrfs: fix possible deadlock when opening a seed device
Date: Wed, 11 Jan 2012 13:55:51 +0800
Message-ID: <4F0D2467.6090109@cn.fujitsu.com>
References: <4F0D236E.2010306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F0D236E.2010306@cn.fujitsu.com>
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
index 3f9d555..858ab34 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2270,9 +2270,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	   (unsigned long)btrfs_header_chunk_tree_uuid(chunk_root->node),
 	   BTRFS_UUID_SIZE);
 
-	mutex_lock(&fs_info->chunk_mutex);
 	ret = btrfs_read_chunk_tree(chunk_root);
-	mutex_unlock(&fs_info->chunk_mutex);
 	if (ret) {
 		printk(KERN_WARNING "btrfs: failed to read chunk tree on %s\n",
 		       sb->s_id);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 563ef65..fbb493b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3506,7 +3506,7 @@ static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
 	struct btrfs_fs_devices *fs_devices;
 	int ret;
 
-	mutex_lock(&uuid_mutex);
+	BUG_ON(!mutex_is_locked(&uuid_mutex));
 
 	fs_devices = root->fs_info->fs_devices->seed;
 	while (fs_devices) {
@@ -3544,7 +3544,6 @@ static int open_seed_devices(struct btrfs_root *root, u8 *fsid)
 	fs_devices->seed = root->fs_info->fs_devices->seed;
 	root->fs_info->fs_devices->seed = fs_devices;
 out:
-	mutex_unlock(&uuid_mutex);
 	return ret;
 }
 
@@ -3687,6 +3686,9 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
 	if (!path)
 		return -ENOMEM;
 
+	mutex_lock(&uuid_mutex);
+	lock_chunks(root);
+
 	/* first we search for all of the device items, and then we
 	 * read in all of the chunk items.  This way we can create chunk
 	 * mappings that reference all of the devices that are afound
@@ -3737,6 +3739,9 @@ again:
 	}
 	ret = 0;
 error:
+	unlock_chunks(root);
+	mutex_unlock(&uuid_mutex);
+
 	btrfs_free_path(path);
 	return ret;
 }
-- 
1.7.3.1
