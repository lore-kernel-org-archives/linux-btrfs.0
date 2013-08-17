Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:46458 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab3HQNmT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Aug 2013 09:42:19 -0400
Received: by mail-we0-f180.google.com with SMTP id p61so2477288wes.39
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Aug 2013 06:42:18 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs-progs: mkfs can now create fs with skinny extents
Date: Sat, 17 Aug 2013 14:41:35 +0100
Message-Id: <1376746895-12177-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this change, passing -O skinny-metadata to mkfs.btrfs would
only set the skinny metadata incompat flag in the super block after
the filesystem was created. This change makes mkfs.btrfs directly
create a filesystem with only skinny extents for metadata.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

NOTE: this patch is based on top of David Sterba's integration
      branch integration-20130810.

 btrfs-convert.c |    2 +-
 mkfs.c          |   37 +++++++++++++++----------------------
 utils.c         |   27 ++++++++++++++++++++-------
 utils.h         |    2 +-
 4 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index a4608ec..e7eddd1 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2322,7 +2322,7 @@ static int do_convert(const char *devname, int datacsum, int packing,
 	}
 	ret = make_btrfs(fd, devname, ext2_fs->super->s_volume_name,
 			 blocks, total_bytes, blocksize, blocksize,
-			 blocksize, blocksize);
+			 blocksize, blocksize, 0);
 	if (ret) {
 		fprintf(stderr, "unable to create initial ctree: %s\n",
 			strerror(-ret));
diff --git a/mkfs.c b/mkfs.c
index 8183879..294aed6 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1301,8 +1301,6 @@ int main(int ac, char **av)
 	u64 num_of_meta_chunks = 0;
 	u64 size_of_data = 0;
 	u64 source_dir_size = 0;
-	struct btrfs_super_block *super;
-	u64 flags;
 	int dev_cnt = 0;
 	int saved_optind;
 	char estr[100];
@@ -1508,9 +1506,23 @@ int main(int ac, char **av)
 			leafsize * i;
 	}
 
+	/*
+	 * FS features that can be set by other means than -O
+	 * just set the bit here
+	 */
+	if (mixed)
+		features |= BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS;
+
+	if ((data_profile | metadata_profile) &
+	    (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)) {
+		features |= BTRFS_FEATURE_INCOMPAT_RAID56;
+	}
+
+	process_fs_features(features);
+
 	ret = make_btrfs(fd, file, label, blocks, dev_block_count,
 			 nodesize, leafsize,
-			 sectorsize, stripesize);
+			 sectorsize, stripesize, features);
 	if (ret) {
 		fprintf(stderr, "error during mkfs: %s\n", strerror(-ret));
 		exit(1);
@@ -1585,25 +1597,6 @@ raid_groups:
 	ret = create_data_reloc_tree(trans, root);
 	BUG_ON(ret);
 
-	super = root->fs_info->super_copy;
-	flags = btrfs_super_incompat_flags(super);
-
-	/*
-	 * FS features that can be set by other means than -O
-	 * just set the bit here
-	 */
-	if (mixed)
-		features |= BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS;
-
-	if ((data_profile | metadata_profile) &
-	    (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)) {
-		features |= BTRFS_FEATURE_INCOMPAT_RAID56;
-	}
-
-	process_fs_features(features);
-	flags |= features;
-	btrfs_set_super_incompat_flags(super, flags);
-
 	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
 	    "sectorsize %u size %s\n",
 	    label, first_file, nodesize, leafsize, sectorsize,
diff --git a/utils.c b/utils.c
index 86ee948..d65fae1 100644
--- a/utils.c
+++ b/utils.c
@@ -80,7 +80,7 @@ static u64 reference_root_table[] = {
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[7], u64 num_bytes, u32 nodesize,
-	       u32 leafsize, u32 sectorsize, u32 stripesize)
+	       u32 leafsize, u32 sectorsize, u32 stripesize, u64 features)
 {
 	struct btrfs_super_block super;
 	struct extent_buffer *buf;
@@ -101,6 +101,8 @@ int make_btrfs(int fd, const char *device, const char *label,
 	u64 ref_root;
 	u32 array_size;
 	u32 item_size;
+	int skinny_metadata = !!(features &
+				 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 
 	first_free = BTRFS_SUPER_INFO_OFFSET + sectorsize * 2 - 1;
 	first_free &= ~((u64)sectorsize - 1);
@@ -127,6 +129,7 @@ int make_btrfs(int fd, const char *device, const char *label,
 	btrfs_set_super_csum_type(&super, BTRFS_CSUM_TYPE_CRC32);
 	btrfs_set_super_chunk_root_generation(&super, 1);
 	btrfs_set_super_cache_generation(&super, -1);
+	btrfs_set_super_incompat_flags(&super, features);
 	if (label)
 		strncpy(super.label, label, BTRFS_LABEL_SIZE - 1);
 
@@ -225,21 +228,31 @@ int make_btrfs(int fd, const char *device, const char *label,
 	nritems = 0;
 	itemoff = __BTRFS_LEAF_DATA_SIZE(leafsize);
 	for (i = 1; i < 7; i++) {
+		unsigned long item_size = sizeof(struct btrfs_extent_item);
+
+		if (!skinny_metadata)
+			item_size += sizeof(struct btrfs_tree_block_info);
+
 		BUG_ON(blocks[i] < first_free);
 		BUG_ON(blocks[i] < blocks[i - 1]);
 
 		/* create extent item */
-		itemoff -= sizeof(struct btrfs_extent_item) +
-			   sizeof(struct btrfs_tree_block_info);
+		itemoff -= item_size;
 		btrfs_set_disk_key_objectid(&disk_key, blocks[i]);
-		btrfs_set_disk_key_offset(&disk_key, leafsize);
-		btrfs_set_disk_key_type(&disk_key, BTRFS_EXTENT_ITEM_KEY);
+		if (skinny_metadata) {
+			btrfs_set_disk_key_type(&disk_key,
+						BTRFS_METADATA_ITEM_KEY);
+			btrfs_set_disk_key_offset(&disk_key, 0);
+		} else {
+			btrfs_set_disk_key_type(&disk_key,
+						BTRFS_EXTENT_ITEM_KEY);
+			btrfs_set_disk_key_offset(&disk_key, leafsize);
+		}
 		btrfs_set_item_key(buf, &disk_key, nritems);
 		btrfs_set_item_offset(buf, btrfs_item_nr(buf, nritems),
 				      itemoff);
 		btrfs_set_item_size(buf, btrfs_item_nr(buf, nritems),
-				    sizeof(struct btrfs_extent_item) +
-				    sizeof(struct btrfs_tree_block_info));
+				    item_size);
 		extent_item = btrfs_item_ptr(buf, nritems,
 					     struct btrfs_extent_item);
 		btrfs_set_extent_refs(buf, extent_item, 1);
diff --git a/utils.h b/utils.h
index ec06a82..5dc1d98 100644
--- a/utils.h
+++ b/utils.h
@@ -30,7 +30,7 @@
 
 int make_btrfs(int fd, const char *device, const char *label,
 	       u64 blocks[6], u64 num_bytes, u32 nodesize,
-	       u32 leafsize, u32 sectorsize, u32 stripesize);
+	       u32 leafsize, u32 sectorsize, u32 stripesize, u64 features);
 int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, u64 objectid);
 int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
-- 
1.7.9.5

