From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: Introduce option to rebalance only metadata
Date: Thu, 10 Nov 2011 17:40:56 -0200
Message-ID: <orr51fpxyv.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Experimental patch to be able to compact only the metadata after
clustered allocation allocated lots of unnecessary metadata block
groups.  It's also useful to measure performance differences between
-o cluster and -o nocluster.

I guess it should be implemented as a balance option rather than a
separate ioctl, but this was good enough for me to try it.

Signed-off-by: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
---
 fs/btrfs/ioctl.c   |    2 ++
 fs/btrfs/ioctl.h   |    3 +++
 fs/btrfs/volumes.c |   33 ++++++++++++++++++++++++++++-----
 fs/btrfs/volumes.h |    1 +
 4 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4a34c47..69bf6f2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3074,6 +3074,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_dev_info(root, argp);
 	case BTRFS_IOC_BALANCE:
 		return btrfs_balance(root->fs_info->dev_root);
+	case BTRFS_IOC_BALANCE_METADATA:
+		return btrfs_balance_metadata(root->fs_info->dev_root);
 	case BTRFS_IOC_CLONE:
 		return btrfs_ioctl_clone(file, arg, 0, 0, 0);
 	case BTRFS_IOC_CLONE_RANGE:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 252ae99..46bc428 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -277,4 +277,7 @@ struct btrfs_ioctl_logical_ino_args {
 #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
 					struct btrfs_ioctl_ino_path_args)
 
+#define BTRFS_IOC_BALANCE_METADATA _IOW(BTRFS_IOCTL_MAGIC, 37, \
+					struct btrfs_ioctl_vol_args)
+
 #endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f8e29431..4d5b29f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2077,7 +2077,7 @@ static u64 div_factor(u64 num, int factor)
 	return num;
 }
 
-int btrfs_balance(struct btrfs_root *dev_root)
+static int btrfs_balance_skip(struct btrfs_root *dev_root, u64 skip_type)
 {
 	int ret;
 	struct list_head *devices = &dev_root->fs_info->fs_devices->devices;
@@ -2089,6 +2089,9 @@ int btrfs_balance(struct btrfs_root *dev_root)
 	struct btrfs_root *chunk_root = dev_root->fs_info->chunk_root;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_key found_key;
+	struct btrfs_chunk *chunk;
+	u64 chunk_type;
+	bool skip;
 
 	if (dev_root->fs_info->sb->s_flags & MS_RDONLY)
 		return -EROFS;
@@ -2158,11 +2161,21 @@ int btrfs_balance(struct btrfs_root *dev_root)
 		if (found_key.offset == 0)
 			break;
 
+		if (skip_type) {
+			chunk = btrfs_item_ptr(path->nodes[0], path->slots[0],
+					       struct btrfs_chunk);
+			chunk_type = btrfs_chunk_type(path->nodes[0], chunk);
+			skip = (chunk_type & skip_type);
+		} else
+			skip = false;
+
 		btrfs_release_path(path);
-		ret = btrfs_relocate_chunk(chunk_root,
-					   chunk_root->root_key.objectid,
-					   found_key.objectid,
-					   found_key.offset);
+
+		ret = (skip ? 0 :
+		       btrfs_relocate_chunk(chunk_root,
+					    chunk_root->root_key.objectid,
+					    found_key.objectid,
+					    found_key.offset));
 		if (ret && ret != -ENOSPC)
 			goto error;
 		key.offset = found_key.offset - 1;
@@ -2174,6 +2187,16 @@ error:
 	return ret;
 }
 
+int btrfs_balance(struct btrfs_root *dev_root)
+{
+	return btrfs_balance_skip(dev_root, 0);
+}
+
+int btrfs_balance_metadata(struct btrfs_root *dev_root)
+{
+	return btrfs_balance_skip(dev_root, BTRFS_BLOCK_GROUP_DATA);
+}
+
 /*
  * shrinking a device means finding all of the device extents past
  * the new size, and then following the back refs to the chunks.
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index ab5b1c4..c467499 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -223,6 +223,7 @@ struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 devid,
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
 int btrfs_init_new_device(struct btrfs_root *root, char *path);
 int btrfs_balance(struct btrfs_root *dev_root);
+int btrfs_balance_metadata(struct btrfs_root *dev_root);
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset);
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
-- 
1.7.4.4


-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
