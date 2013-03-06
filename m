Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab3CFQcz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Mar 2013 11:32:55 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: separate super_copy out of fs_info
Date: Wed,  6 Mar 2013 17:32:51 +0100
Message-Id: <1362587571-14718-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1362585400-13379-1-git-send-email-dsterba@suse.cz>
References: <1362585400-13379-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allocate fs_info::super_copy dynamically of full BTRFS_SUPER_INFO_SIZE
and use it directly for saving superblock to disk.

This fixes incorrect superblock checksum after mkfs.

Signed-off-by: David Sterba <dsterba@suse.cz>
---

this is based on master 704a08cb8a so it could be merged asap

 btrfs-zero-log.c |    4 ++--
 btrfslabel.c     |    6 +++---
 btrfstune.c      |    4 ++--
 cmds-check.c     |    4 ++--
 convert.c        |   16 ++++++++--------
 ctree.h          |    2 +-
 debug-tree.c     |    8 ++++----
 disk-io.c        |   46 +++++++++++++++++++++++++---------------------
 extent-tree.c    |    8 ++++----
 file-item.c      |    8 ++++----
 find-root.c      |   16 ++++++++--------
 mkfs.c           |   12 ++++++------
 utils.c          |    6 +++---
 volumes.c        |   20 ++++++++++----------
 14 files changed, 82 insertions(+), 78 deletions(-)

diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
index 1ea867b..f249aec 100644
--- a/btrfs-zero-log.c
+++ b/btrfs-zero-log.c
@@ -64,8 +64,8 @@ int main(int ac, char **av)
 		return 1;
 
 	trans = btrfs_start_transaction(root, 1);
-	btrfs_set_super_log_root(&root->fs_info->super_copy, 0);
-	btrfs_set_super_log_root_level(&root->fs_info->super_copy, 0);
+	btrfs_set_super_log_root(root->fs_info->super_copy, 0);
+	btrfs_set_super_log_root_level(root->fs_info->super_copy, 0);
 	btrfs_commit_transaction(trans, root);
 	close_ctree(root);
 	return ret;
diff --git a/btrfslabel.c b/btrfslabel.c
index a421a8b..3e80b4c 100644
--- a/btrfslabel.c
+++ b/btrfslabel.c
@@ -59,8 +59,8 @@ static int change_label_unmounted(char *dev, char *nLabel)
 	       return -1;
 
        trans = btrfs_start_transaction(root, 1);
-       strncpy(root->fs_info->super_copy.label, nLabel, BTRFS_LABEL_SIZE);
-       root->fs_info->super_copy.label[BTRFS_LABEL_SIZE-1] = 0;
+       strncpy(root->fs_info->super_copy->label, nLabel, BTRFS_LABEL_SIZE);
+       root->fs_info->super_copy->label[BTRFS_LABEL_SIZE-1] = 0;
        btrfs_commit_transaction(trans, root);
 
        /* Now we close it since we are done. */
@@ -80,7 +80,7 @@ int get_label_unmounted(char *dev)
        if(!root)
          return -1;
 
-       fprintf(stdout, "%s\n", root->fs_info->super_copy.label);
+       fprintf(stdout, "%s\n", root->fs_info->super_copy->label);
 
        /* Now we close it since we are done. */
        close_ctree(root);
diff --git a/btrfstune.c b/btrfstune.c
index 6e68bda..2f3d087 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -40,7 +40,7 @@ int update_seeding_flag(struct btrfs_root *root, int set_flag)
 	struct btrfs_super_block *disk_super;
 	u64 super_flags;
 
-	disk_super = &root->fs_info->super_copy;
+	disk_super = root->fs_info->super_copy;
 	super_flags = btrfs_super_flags(disk_super);
 	if (set_flag) {
 		if (super_flags & BTRFS_SUPER_FLAG_SEEDING) {
@@ -71,7 +71,7 @@ int enable_extrefs_flag(struct btrfs_root *root)
 	struct btrfs_super_block *disk_super;
 	u64 super_flags;
 
-	disk_super = &root->fs_info->super_copy;
+	disk_super = root->fs_info->super_copy;
 	super_flags = btrfs_super_incompat_flags(disk_super);
 	super_flags |= BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF;
 	trans = btrfs_start_transaction(root, 1);
diff --git a/cmds-check.c b/cmds-check.c
index d63e945..23da75b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -973,7 +973,7 @@ static u64 count_csum_range(struct btrfs_root *root, u64 start, u64 len)
 	size_t size;
 	u64 found = 0;
 	u64 csum_end;
-	u16 csum_size = btrfs_super_csum_size(&root->fs_info->super_copy);
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 
 	btrfs_init_path(&path);
 
@@ -3610,7 +3610,7 @@ int cmd_check(int argc, char **argv)
 	}
 
 	info = open_ctree_fs_info(argv[optind], bytenr, rw, 1);
-	uuid_unparse(info->super_copy.fsid, uuidbuf);
+	uuid_unparse(info->super_copy->fsid, uuidbuf);
 	printf("Checking filesystem on %s\nUUID: %s\n", argv[optind], uuidbuf);
 
 	if (info == NULL)
diff --git a/convert.c b/convert.c
index 2b3f42f..4ac2022 100644
--- a/convert.c
+++ b/convert.c
@@ -1261,7 +1261,7 @@ static int create_ext2_image(struct btrfs_root *root, ext2_filsys ext2_fs,
 	u64 total_bytes;
 	u32 sectorsize = root->sectorsize;
 
-	total_bytes = btrfs_super_total_bytes(&fs_info->super_copy);
+	total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
 	first_free =  BTRFS_SUPER_INFO_OFFSET + sectorsize * 2 - 1;
 	first_free &= ~((u64)sectorsize - 1);
 
@@ -1527,7 +1527,7 @@ static int create_chunk_mapping(struct btrfs_trans_handle *trans,
 
 	btrfs_init_path(&path);
 
-	total_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
+	total_bytes = btrfs_super_total_bytes(root->fs_info->super_copy);
 	chunk_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 
 	BUG_ON(list_empty(&info->fs_devices->devices));
@@ -1691,13 +1691,13 @@ static int init_btrfs(struct btrfs_root *root)
 	memcpy(&location, &root->root_key, sizeof(location));
 	location.offset = (u64)-1;
 	ret = btrfs_insert_dir_item(trans, fs_info->tree_root, "default", 7,
-				btrfs_super_root_dir(&fs_info->super_copy),
+				btrfs_super_root_dir(fs_info->super_copy),
 				&location, BTRFS_FT_DIR, 0);
 	if (ret)
 		goto err;
 	ret = btrfs_insert_inode_ref(trans, fs_info->tree_root, "default", 7,
 				location.objectid,
-				btrfs_super_root_dir(&fs_info->super_copy), 0);
+				btrfs_super_root_dir(fs_info->super_copy), 0);
 	if (ret)
 		goto err;
 	btrfs_set_root_dirid(&fs_info->fs_root->root_item,
@@ -2227,7 +2227,7 @@ static int fixup_chunk_mapping(struct btrfs_root *root)
 	btrfs_release_path(chunk_root, &path);
 
 	/* fixup the system chunk array in super block */
-	btrfs_set_super_sys_array_size(&info->super_copy, 0);
+	btrfs_set_super_sys_array_size(info->super_copy, 0);
 
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.offset = 0;
@@ -2422,11 +2422,11 @@ static int may_rollback(struct btrfs_root *root)
 	int num_stripes;
 	int ret;
 
-	if (btrfs_super_num_devices(&info->super_copy) != 1)
+	if (btrfs_super_num_devices(info->super_copy) != 1)
 		goto fail;
 
 	bytenr = BTRFS_SUPER_INFO_OFFSET;
-	total_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
+	total_bytes = btrfs_super_total_bytes(root->fs_info->super_copy);
 
 	while (1) {
 		ret = btrfs_map_block(&info->mapping_tree, WRITE, bytenr,
@@ -2656,7 +2656,7 @@ next_extent:
 		goto fail;
 	}
 	/* create a system chunk that maps the whole device */
-	ret = prepare_system_chunk_sb(&root->fs_info->super_copy);
+	ret = prepare_system_chunk_sb(root->fs_info->super_copy);
 	if (ret) {
 		fprintf(stderr, "unable to update system chunk\n");
 		goto fail;
diff --git a/ctree.h b/ctree.h
index 12f8fe3..969afa8 100644
--- a/ctree.h
+++ b/ctree.h
@@ -914,7 +914,7 @@ struct btrfs_fs_info {
 	u64 alloc_start;
 
 	struct btrfs_trans_handle *running_transaction;
-	struct btrfs_super_block super_copy;
+	struct btrfs_super_block *super_copy;
 	struct mutex fs_mutex;
 
 	u64 super_bytenr;
diff --git a/debug-tree.c b/debug-tree.c
index 02b0389..0fc0ecd 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -372,14 +372,14 @@ no_node:
 		return 0;
 
 	if (root_backups)
-		print_old_roots(&info->super_copy);
+		print_old_roots(info->super_copy);
 
 	printf("total bytes %llu\n",
-	       (unsigned long long)btrfs_super_total_bytes(&info->super_copy));
+	       (unsigned long long)btrfs_super_total_bytes(info->super_copy));
 	printf("bytes used %llu\n",
-	       (unsigned long long)btrfs_super_bytes_used(&info->super_copy));
+	       (unsigned long long)btrfs_super_bytes_used(info->super_copy));
 	uuidbuf[36] = '\0';
-	uuid_unparse(info->super_copy.fsid, uuidbuf);
+	uuid_unparse(info->super_copy->fsid, uuidbuf);
 	printf("uuid %s\n", uuidbuf);
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	return 0;
diff --git a/disk-io.c b/disk-io.c
index 5aa9aa3..cac23bd 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -106,7 +106,7 @@ int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		    int verify)
 {
 	u16 csum_size =
-		btrfs_super_csum_size(&root->fs_info->super_copy);
+		btrfs_super_csum_size(root->fs_info->super_copy);
 	return csum_tree_block_size(buf, csum_size, verify);
 }
 
@@ -835,6 +835,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	}
 
 	memset(fs_info, 0, sizeof(*fs_info));
+	fs_info->super_copy = calloc(1, BTRFS_SUPER_INFO_SIZE);
 	fs_info->tree_root = tree_root;
 	fs_info->extent_root = extent_root;
 	fs_info->chunk_root = chunk_root;
@@ -870,7 +871,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 		goto out_cleanup;
 
 	fs_info->super_bytenr = sb_bytenr;
-	disk_super = &fs_info->super_copy;
+	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
 				   disk_super, sb_bytenr);
 	if (ret) {
@@ -1159,10 +1160,6 @@ int write_dev_supers(struct btrfs_root *root, struct btrfs_super_block *sb,
 	u64 bytenr;
 	u32 crc;
 	int i, ret;
-	void *buf;
-
-	buf = calloc(1, BTRFS_SUPER_INFO_SIZE);
-	BUG_ON(!buf);
 
 	if (root->fs_info->super_bytenr != BTRFS_SUPER_INFO_OFFSET) {
 		btrfs_set_super_bytenr(sb, root->fs_info->super_bytenr);
@@ -1171,11 +1168,15 @@ int write_dev_supers(struct btrfs_root *root, struct btrfs_super_block *sb,
 				      BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
 		btrfs_csum_final(crc, (char *)&sb->csum[0]);
 
-		memcpy(buf, sb, sizeof(*sb));
-		ret = pwrite64(device->fd, buf, BTRFS_SUPER_INFO_SIZE,
-			       root->fs_info->super_bytenr);
+		/*
+		 * super_copy is BTRFS_SUPER_INFO_SIZE bytes and is
+		 * zero filled, we can use it directly
+		 */
+		ret = pwrite64(device->fd, root->fs_info->super_copy,
+				BTRFS_SUPER_INFO_SIZE,
+				root->fs_info->super_bytenr);
 		BUG_ON(ret != BTRFS_SUPER_INFO_SIZE);
-		goto out;
+		return 0;
 	}
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
@@ -1190,12 +1191,15 @@ int write_dev_supers(struct btrfs_root *root, struct btrfs_super_block *sb,
 				      BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
 		btrfs_csum_final(crc, (char *)&sb->csum[0]);
 
-		memcpy(buf, sb, sizeof(*sb));
-		ret = pwrite64(device->fd, buf, BTRFS_SUPER_INFO_SIZE, bytenr);
+		/*
+		 * super_copy is BTRFS_SUPER_INFO_SIZE bytes and is
+		 * zero filled, we can use it directly
+		 */
+		ret = pwrite64(device->fd, root->fs_info->super_copy,
+				BTRFS_SUPER_INFO_SIZE, bytenr);
 		BUG_ON(ret != BTRFS_SUPER_INFO_SIZE);
 	}
-out:
-	free(buf);
+
 	return 0;
 }
 
@@ -1209,7 +1213,7 @@ int write_all_supers(struct btrfs_root *root)
 	int ret;
 	u64 flags;
 
-	sb = &root->fs_info->super_copy;
+	sb = root->fs_info->super_copy;
 	dev_item = &sb->dev_item;
 	list_for_each(cur, head) {
 		dev = list_entry(cur, struct btrfs_device, dev_list);
@@ -1246,17 +1250,17 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 	if (root->fs_info->readonly)
 		return 0;
 
-	btrfs_set_super_generation(&root->fs_info->super_copy,
+	btrfs_set_super_generation(root->fs_info->super_copy,
 				   trans->transid);
-	btrfs_set_super_root(&root->fs_info->super_copy,
+	btrfs_set_super_root(root->fs_info->super_copy,
 			     tree_root->node->start);
-	btrfs_set_super_root_level(&root->fs_info->super_copy,
+	btrfs_set_super_root_level(root->fs_info->super_copy,
 				   btrfs_header_level(tree_root->node));
-	btrfs_set_super_chunk_root(&root->fs_info->super_copy,
+	btrfs_set_super_chunk_root(root->fs_info->super_copy,
 				   chunk_root->node->start);
-	btrfs_set_super_chunk_root_level(&root->fs_info->super_copy,
+	btrfs_set_super_chunk_root_level(root->fs_info->super_copy,
 					 btrfs_header_level(chunk_root->node));
-	btrfs_set_super_chunk_root_generation(&root->fs_info->super_copy,
+	btrfs_set_super_chunk_root_generation(root->fs_info->super_copy,
 				btrfs_header_generation(chunk_root->node));
 
 	ret = write_all_supers(root);
diff --git a/extent-tree.c b/extent-tree.c
index 85f5670..da93cb1 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1830,12 +1830,12 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 	u64 end;
 
 	/* block accounting for super block */
-	old_val = btrfs_super_bytes_used(&info->super_copy);
+	old_val = btrfs_super_bytes_used(info->super_copy);
 	if (alloc)
 		old_val += num_bytes;
 	else
 		old_val -= num_bytes;
-	btrfs_set_super_bytes_used(&info->super_copy, old_val);
+	btrfs_set_super_bytes_used(info->super_copy, old_val);
 
 	/* block accounting for root item */
 	old_val = btrfs_root_used(&root->root_item);
@@ -3216,7 +3216,7 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 	extent_root = root->fs_info->extent_root;
 	block_group_cache = &root->fs_info->block_group_cache;
 	chunk_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
-	total_bytes = btrfs_super_total_bytes(&root->fs_info->super_copy);
+	total_bytes = btrfs_super_total_bytes(root->fs_info->super_copy);
 	group_align = 64 * root->sectorsize;
 
 	cur_start = 0;
@@ -3451,7 +3451,7 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans,
 		}
 		path.slots[0]++;
 	}
-	btrfs_set_super_bytes_used(&root->fs_info->super_copy, bytes_used);
+	btrfs_set_super_bytes_used(root->fs_info->super_copy, bytes_used);
 	btrfs_release_path(root, &path);
 	return 0;
 }
diff --git a/file-item.c b/file-item.c
index c746b44..9c787f0 100644
--- a/file-item.c
+++ b/file-item.c
@@ -134,7 +134,7 @@ struct btrfs_csum_item *btrfs_lookup_csum(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	u64 csum_offset = 0;
 	u16 csum_size =
-		btrfs_super_csum_size(&root->fs_info->super_copy);
+		btrfs_super_csum_size(root->fs_info->super_copy);
 	int csums_in_item;
 
 	file_key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
@@ -206,7 +206,7 @@ int btrfs_csum_file_block(struct btrfs_trans_handle *trans,
 	u32 nritems;
 	u32 ins_size;
 	u16 csum_size =
-		btrfs_super_csum_size(&root->fs_info->super_copy);
+		btrfs_super_csum_size(root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
@@ -352,7 +352,7 @@ static noinline int truncate_one_csum(struct btrfs_trans_handle *trans,
 {
 	struct extent_buffer *leaf;
 	u16 csum_size =
-		btrfs_super_csum_size(&root->fs_info->super_copy);
+		btrfs_super_csum_size(root->fs_info->super_copy);
 	u64 csum_end;
 	u64 end_byte = bytenr + len;
 	u32 blocksize = root->sectorsize;
@@ -411,7 +411,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	int ret;
 	u16 csum_size =
-		btrfs_super_csum_size(&root->fs_info->super_copy);
+		btrfs_super_csum_size(root->fs_info->super_copy);
 	int blocksize = root->sectorsize;
 
 	root = root->fs_info->csum_root;
diff --git a/find-root.c b/find-root.c
index 20ff972..f99fb76 100644
--- a/find-root.c
+++ b/find-root.c
@@ -147,7 +147,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 		goto out_cleanup;
 
 	fs_info->super_bytenr = BTRFS_SUPER_INFO_OFFSET;
-	disk_super = &fs_info->super_copy;
+	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
 				   disk_super, BTRFS_SUPER_INFO_OFFSET);
 	if (ret) {
@@ -234,10 +234,10 @@ out:
 static int search_iobuf(struct btrfs_root *root, void *iobuf,
 			size_t iobuf_size, off_t offset)
 {
-	u64 gen = btrfs_super_generation(&root->fs_info->super_copy);
+	u64 gen = btrfs_super_generation(root->fs_info->super_copy);
 	u64 objectid = search_objectid;
-	u32 size = btrfs_super_nodesize(&root->fs_info->super_copy);
-	u8 level = root->fs_info->super_copy.root_level;
+	u32 size = btrfs_super_nodesize(root->fs_info->super_copy);
+	u8 level = root->fs_info->super_copy->root_level;
 	size_t block_off = 0;
 
 	while (block_off < iobuf_size) {
@@ -322,8 +322,8 @@ static int find_root(struct btrfs_root *root)
 	int ret = 1;
 
 	printf("Super think's the tree root is at %Lu, chunk root %Lu\n",
-	       btrfs_super_root(&root->fs_info->super_copy),
-	       btrfs_super_chunk_root(&root->fs_info->super_copy));
+	       btrfs_super_root(root->fs_info->super_copy),
+	       btrfs_super_chunk_root(root->fs_info->super_copy));
 
 	err = btrfs_next_metadata(&root->fs_info->mapping_tree,
 				  &metadata_offset, &metadata_size);
@@ -336,7 +336,7 @@ static int find_root(struct btrfs_root *root)
 		u64 type;
 
 		if (offset >
-		    btrfs_super_total_bytes(&root->fs_info->super_copy)) {
+		    btrfs_super_total_bytes(root->fs_info->super_copy)) {
 			printf("Went past the fs size, exiting");
 			break;
 		}
@@ -426,7 +426,7 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	csum_size = btrfs_super_csum_size(&root->fs_info->super_copy);
+	csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 	ret = find_root(root);
 	close_ctree(root);
 	return ret;
diff --git a/mkfs.c b/mkfs.c
index 5ece186..826f151 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -67,7 +67,7 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 	int ret;
 
 	trans = btrfs_start_transaction(root, 1);
-	bytes_used = btrfs_super_bytes_used(&root->fs_info->super_copy);
+	bytes_used = btrfs_super_bytes_used(root->fs_info->super_copy);
 
 	root->fs_info->system_allocs = 1;
 	ret = btrfs_make_block_group(trans, root, bytes_used,
@@ -129,7 +129,7 @@ static int make_root_dir(struct btrfs_root *root, int mixed)
 	location.offset = (u64)-1;
 	ret = btrfs_insert_dir_item(trans, root->fs_info->tree_root,
 			"default", 7,
-			btrfs_super_root_dir(&root->fs_info->super_copy),
+			btrfs_super_root_dir(root->fs_info->super_copy),
 			&location, BTRFS_FT_DIR, 0);
 	if (ret)
 		goto err;
@@ -208,7 +208,7 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 			      int data_profile_opt, u64 metadata_profile,
 			      int metadata_profile_opt, int mixed, int ssd)
 {
-	u64 num_devices = btrfs_super_num_devices(&root->fs_info->super_copy);
+	u64 num_devices = btrfs_super_num_devices(root->fs_info->super_copy);
 	u64 allowed = 0;
 	u64 devices_for_raid = num_devices;
 	int ret;
@@ -1650,7 +1650,7 @@ raid_groups:
 	ret = create_data_reloc_tree(trans, root);
 	BUG_ON(ret);
 
-	super = &root->fs_info->super_copy;
+	super = root->fs_info->super_copy;
 	flags = btrfs_super_incompat_flags(super);
 	flags |= BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF;
 
@@ -1661,7 +1661,7 @@ raid_groups:
 
 	if ((data_profile | metadata_profile) &
 	    (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)) {
-		struct btrfs_super_block *super = &root->fs_info->super_copy;
+		struct btrfs_super_block *super = root->fs_info->super_copy;
 		u64 flags = btrfs_super_incompat_flags(super);
 
 		flags |= BTRFS_FEATURE_INCOMPAT_RAID56;
@@ -1672,7 +1672,7 @@ raid_groups:
 	printf("fs created label %s on %s\n\tnodesize %u leafsize %u "
 	    "sectorsize %u size %s\n",
 	    label, first_file, nodesize, leafsize, sectorsize,
-	    pretty_buf = pretty_sizes(btrfs_super_total_bytes(&root->fs_info->super_copy)));
+	    pretty_buf = pretty_sizes(btrfs_super_total_bytes(root->fs_info->super_copy)));
 	free(pretty_buf);
 
 	printf("%s\n", BTRFS_BUILD_VERSION);
diff --git a/utils.c b/utils.c
index d660507..d4a176f 100644
--- a/utils.c
+++ b/utils.c
@@ -471,7 +471,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      u32 sectorsize)
 {
 	struct btrfs_super_block *disk_super;
-	struct btrfs_super_block *super = &root->fs_info->super_copy;
+	struct btrfs_super_block *super = root->fs_info->super_copy;
 	struct btrfs_device *device;
 	struct btrfs_dev_item *dev_item;
 	char *buf;
@@ -622,7 +622,7 @@ int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_timespec_nsec(&inode_item.otime, 0);
 
 	if (root->fs_info->tree_root == root)
-		btrfs_set_super_root_dir(&root->fs_info->super_copy, objectid);
+		btrfs_set_super_root_dir(root->fs_info->super_copy, objectid);
 
 	ret = btrfs_insert_inode(trans, root, objectid, &inode_item);
 	if (ret)
@@ -1086,7 +1086,7 @@ int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 	if (disk_super->magic != cpu_to_le64(BTRFS_MAGIC))
 		goto brelse;
 
-	if (!memcmp(disk_super->fsid, root->fs_info->super_copy.fsid,
+	if (!memcmp(disk_super->fsid, root->fs_info->super_copy->fsid,
 		    BTRFS_FSID_SIZE))
 		ret = 1;
 brelse:
diff --git a/volumes.c b/volumes.c
index c8fbde3..4b0b052 100644
--- a/volumes.c
+++ b/volumes.c
@@ -603,7 +603,7 @@ int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
 			   struct btrfs_key *key,
 			   struct btrfs_chunk *chunk, int item_size)
 {
-	struct btrfs_super_block *super_copy = &root->fs_info->super_copy;
+	struct btrfs_super_block *super_copy = root->fs_info->super_copy;
 	struct btrfs_disk_key disk_key;
 	u32 array_size;
 	u8 *ptr;
@@ -707,7 +707,7 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	}
 	if (type & BTRFS_BLOCK_GROUP_RAID1) {
 		num_stripes = min_t(u64, 2,
-				  btrfs_super_num_devices(&info->super_copy));
+				  btrfs_super_num_devices(info->super_copy));
 		if (num_stripes < 2)
 			return -ENOSPC;
 		min_stripes = 2;
@@ -717,11 +717,11 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		min_stripes = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID0)) {
-		num_stripes = btrfs_super_num_devices(&info->super_copy);
+		num_stripes = btrfs_super_num_devices(info->super_copy);
 		min_stripes = 2;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID10)) {
-		num_stripes = btrfs_super_num_devices(&info->super_copy);
+		num_stripes = btrfs_super_num_devices(info->super_copy);
 		if (num_stripes < 4)
 			return -ENOSPC;
 		num_stripes &= ~(u32)1;
@@ -729,24 +729,24 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		min_stripes = 4;
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID5)) {
-		num_stripes = btrfs_super_num_devices(&info->super_copy);
+		num_stripes = btrfs_super_num_devices(info->super_copy);
 		if (num_stripes < 2)
 			return -ENOSPC;
 		min_stripes = 2;
 		stripe_len = find_raid56_stripe_len(num_stripes - 1,
-				    btrfs_super_stripesize(&info->super_copy));
+				    btrfs_super_stripesize(info->super_copy));
 	}
 	if (type & (BTRFS_BLOCK_GROUP_RAID6)) {
-		num_stripes = btrfs_super_num_devices(&info->super_copy);
+		num_stripes = btrfs_super_num_devices(info->super_copy);
 		if (num_stripes < 3)
 			return -ENOSPC;
 		min_stripes = 3;
 		stripe_len = find_raid56_stripe_len(num_stripes - 2,
-				    btrfs_super_stripesize(&info->super_copy));
+				    btrfs_super_stripesize(info->super_copy));
 	}
 
 	/* we don't want a chunk larger than 10% of the FS */
-	percent_max = div_factor(btrfs_super_total_bytes(&info->super_copy), 1);
+	percent_max = div_factor(btrfs_super_total_bytes(info->super_copy), 1);
 	max_chunk_size = min(percent_max, max_chunk_size);
 
 again:
@@ -1650,7 +1650,7 @@ int btrfs_read_super_device(struct btrfs_root *root, struct extent_buffer *buf)
 
 int btrfs_read_sys_array(struct btrfs_root *root)
 {
-	struct btrfs_super_block *super_copy = &root->fs_info->super_copy;
+	struct btrfs_super_block *super_copy = root->fs_info->super_copy;
 	struct extent_buffer *sb;
 	struct btrfs_disk_key *disk_key;
 	struct btrfs_chunk *chunk;
-- 
1.7.9

