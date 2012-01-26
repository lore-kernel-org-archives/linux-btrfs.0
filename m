From: Jan Kara <jack@suse.cz>
Subject: [PATCH] mkfs: Handle creation of filesystem larger than the first device
Date: Thu, 26 Jan 2012 17:03:05 +0100
Message-ID: <1327593785-23466-1-git-send-email-jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
	David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

make_btrfs() function takes a size of filesystem as an argument. It uses this
value to set the size of the first device as well which is wrong for
filesystems larger than this device. It results in 'attemp to access beyond end
of device' messages from the kernel. So add size of the first device as an
argument to make_btrfs().

CC: David Sterba <dsterba@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 convert.c |    2 +-
 mkfs.c    |    6 ++++--
 utils.c   |    4 ++--
 utils.h   |    2 +-
 4 files changed, 8 insertions(+), 6 deletions(-)

  As a side note, I'd guess that creating filesystem larger than all given
devices (especially in case of single device) is usually not what sysadmin
wants (we've spotted this bug when xfstest were happily creating 1 GB
filesystem on 500 MB device and it took us a while to notice the problem).
Thus maybe it should require some --force switch?

diff --git a/convert.c b/convert.c
index 291dc27..7f1932c 100644
--- a/convert.c
+++ b/convert.c
@@ -2374,7 +2374,7 @@ int do_convert(const char *devname, int datacsum, int packing, int noxattr)
 		goto fail;
 	}
 	ret = make_btrfs(fd, devname, ext2_fs->super->s_volume_name,
-			 blocks, total_bytes, blocksize, blocksize,
+			 blocks, total_bytes, total_bytes, blocksize, blocksize,
 			 blocksize, blocksize);
 	if (ret) {
 		fprintf(stderr, "unable to create initial ctree\n");
diff --git a/mkfs.c b/mkfs.c
index e3ced19..f0d29bb 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1294,8 +1294,10 @@ int main(int ac, char **av)
 		first_file = file;
 		source_dir_size = size_sourcedir(source_dir, sectorsize,
 					     &num_of_meta_chunks, &size_of_data);
-		if(block_count < source_dir_size)
+		if (block_count < source_dir_size)
 			block_count = source_dir_size;
+		dev_block_count = block_count;
+
 		ret = zero_output_file(fd, block_count, sectorsize);
 		if (ret) {
 			fprintf(stderr, "unable to zero the output file\n");
@@ -1321,7 +1323,7 @@ int main(int ac, char **av)
 			leafsize * i;
 	}
 
-	ret = make_btrfs(fd, file, label, blocks, block_count,
+	ret = make_btrfs(fd, file, label, blocks, block_count, dev_block_count,
 			 nodesize, leafsize,
 			 sectorsize, stripesize);
 	if (ret) {
diff --git a/utils.c b/utils.c
index 178d1b9..f34da51 100644
--- a/utils.c
+++ b/utils.c
@@ -74,7 +74,7 @@ static u64 reference_root_table[] = {
 };
 
 int make_btrfs(int fd, const char *device, const char *label,
-	       u64 blocks[7], u64 num_bytes, u32 nodesize,
+	       u64 blocks[7], u64 num_bytes, u64 dev_num_bytes, u32 nodesize,
 	       u32 leafsize, u32 sectorsize, u32 stripesize)
 {
 	struct btrfs_super_block super;
@@ -276,7 +276,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	dev_item = btrfs_item_ptr(buf, nritems, struct btrfs_dev_item);
 	btrfs_set_device_id(buf, dev_item, 1);
 	btrfs_set_device_generation(buf, dev_item, 0);
-	btrfs_set_device_total_bytes(buf, dev_item, num_bytes);
+	btrfs_set_device_total_bytes(buf, dev_item, dev_num_bytes);
 	btrfs_set_device_bytes_used(buf, dev_item,
 				    BTRFS_MKFS_SYSTEM_GROUP_SIZE);
 	btrfs_set_device_io_align(buf, dev_item, sectorsize);
diff --git a/utils.h b/utils.h
index c5f55e1..bf2d5a4 100644
--- a/utils.h
+++ b/utils.h
@@ -22,7 +22,7 @@
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 
 int make_btrfs(int fd, const char *device, const char *label,
-	       u64 blocks[6], u64 num_bytes, u32 nodesize,
+	       u64 blocks[6], u64 num_bytes, u64 dev_num_bytes, u32 nodesize,
 	       u32 leafsize, u32 sectorsize, u32 stripesize);
 int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, u64 objectid);
-- 
1.7.1

