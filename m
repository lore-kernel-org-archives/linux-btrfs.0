Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65120 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752413AbaAGUTl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jan 2014 15:19:41 -0500
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s07KJ9Ka011831
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Jan 2014 12:19:40 -0800
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1h8nty0s9p-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 07 Jan 2014 12:19:39 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: deal with invalid key orderings and bad orphan items V2
Date: Tue, 7 Jan 2014 15:19:35 -0500
Message-ID: <1389125975-29442-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user had a fs where the objectid of an orphan item was not the actual orphan
item objectid.  This screwed up fsck because the block has keys in the wrong
order, also the fs scanning stuff will freak out because we have an inode with
nlink 0 and no orphan item.  So this patch is pretty big but is all related.

1) Deal with bad key ordering.  We can easily fix this up, so fix the checking
stuff to tell us exactly what it found when it said there was a problem.  Then
if it's bad key ordering we can reorder the keys and restart the scan.

2) Deal with bad keys.  If we find an orphan item with the wrong objectid it's
likely to screw with stuff, so keep track of these sort of things with a
bad_item list and just run through and delete any objects that don't make sense.
So far we just do this for orphan items but we could extend this as new stuff
pops up.

3) Deal with missing orphan items.  This is easy, if we have a file with i_nlink
set to 0 and no orphan item we can just add an orphan item.

4) Add the infrastructure to corrupt actual key values.  Needed this to create a
test image to verify I was fixing things properly.

This patch fixes the corrupt image I'm adding and passes the other make test
tests.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V1->V2: Fix btrfs-corrupt-block so it will actually compile.

 btrfs-corrupt-block.c                   | 109 ++++++++++-
 cmds-check.c                            | 331 ++++++++++++++++++++++++++++----
 ctree.c                                 | 135 +++++++------
 ctree.h                                 |  32 ++-
 file-item.c                             |   2 +-
 tests/fsck-tests/003-bad-orphan-key.img | Bin 0 -> 4096 bytes
 6 files changed, 509 insertions(+), 100 deletions(-)
 create mode 100644 tests/fsck-tests/003-bad-orphan-key.img

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index f0c14a9..10cae00 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -105,6 +105,8 @@ static void print_usage(void)
 		"specify -i for the inode and -f for the field to corrupt)\n");
 	fprintf(stderr, "\t-m The metadata block to corrupt (must also "
 		"specify -f for the field to corrupt)\n");
+	fprintf(stderr, "\t-K The key to corrupt in the format "
+		"<num>,<num>,<num> (must also specify -f for the field)\n");
 	fprintf(stderr, "\t-f The field in the item to corrupt\n");
 	exit(1);
 }
@@ -306,6 +308,13 @@ enum btrfs_metadata_block_field {
 	BTRFS_METADATA_BLOCK_BAD,
 };
 
+enum btrfs_key_field {
+	BTRFS_KEY_OBJECTID,
+	BTRFS_KEY_TYPE,
+	BTRFS_KEY_OFFSET,
+	BTRFS_KEY_BAD,
+};
+
 static enum btrfs_inode_field convert_inode_field(char *field)
 {
 	if (!strncmp(field, "isize", FIELD_BUF_LEN))
@@ -328,6 +337,17 @@ convert_metadata_block_field(char *field)
 	return BTRFS_METADATA_BLOCK_BAD;
 }
 
+static enum btrfs_key_field convert_key_field(char *field)
+{
+	if (!strncmp(field, "objectid", FIELD_BUF_LEN))
+		return BTRFS_KEY_OBJECTID;
+	if (!strncmp(field, "type", FIELD_BUF_LEN))
+		return BTRFS_KEY_TYPE;
+	if (!strncmp(field, "offset", FIELD_BUF_LEN))
+		return BTRFS_KEY_OFFSET;
+	return BTRFS_KEY_BAD;
+}
+
 static u64 generate_u64(u64 orig)
 {
 	u64 ret;
@@ -337,6 +357,73 @@ static u64 generate_u64(u64 orig)
 	return ret;
 }
 
+static u8 generate_u8(u8 orig)
+{
+	u8 ret;
+	do {
+		ret = rand();
+	} while (ret == orig);
+	return ret;
+}
+
+static int corrupt_key(struct btrfs_root *root, struct btrfs_key *key,
+		       char *field)
+{
+	enum btrfs_key_field corrupt_field = convert_key_field(field);
+	struct btrfs_path *path;
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	root = root->fs_info->fs_root;
+	if (corrupt_field == BTRFS_KEY_BAD) {
+		fprintf(stderr, "Invalid field %s\n", field);
+		return -EINVAL;
+	}
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
+
+	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		fprintf(stderr, "Couldn't find the key to corrupt\n");
+		ret = -ENOENT;
+		goto out;
+	}
+
+	switch (corrupt_field) {
+	case BTRFS_KEY_OBJECTID:
+		key->objectid = generate_u64(key->objectid);
+		break;
+	case BTRFS_KEY_TYPE:
+		key->type = generate_u8(key->type);
+		break;
+	case BTRFS_KEY_OFFSET:
+		key->offset = generate_u64(key->objectid);
+		break;
+	default:
+		fprintf(stderr, "Invalid field %s, %d\n", field,
+			corrupt_field);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	btrfs_set_item_key_unsafe(root, path, key);
+out:
+	btrfs_free_path(path);
+	btrfs_commit_transaction(trans, root);
+	return ret;
+}
+
+
 static int corrupt_inode(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root, u64 inode, char *field)
 {
@@ -548,6 +635,7 @@ static struct option long_options[] = {
 	{ "file-extent", 1, NULL, 'x'},
 	{ "metadata-block", 1, NULL, 'm'},
 	{ "field", 1, NULL, 'f'},
+	{ "key", 1, NULL, 'K'},
 	{ 0, 0, 0, 0}
 };
 
@@ -696,6 +784,7 @@ out:
 int main(int ac, char **av)
 {
 	struct cache_tree root_cache;
+	struct btrfs_key key;
 	struct btrfs_root *root;
 	struct extent_buffer *eb;
 	char *dev;
@@ -717,10 +806,11 @@ int main(int ac, char **av)
 
 	field[0] = '\0';
 	srand(128);
+	memset(&key, 0, sizeof(key));
 
 	while(1) {
 		int c;
-		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:", long_options,
+		c = getopt_long(ac, av, "l:c:b:eEkuUi:f:x:m:K:", long_options,
 				&option_index);
 		if (c < 0)
 			break;
@@ -787,6 +877,17 @@ int main(int ac, char **av)
 					print_usage();
 				}
 				break;
+			case 'K':
+				ret = sscanf(optarg, "%llu,%u,%llu",
+					     &key.objectid,
+					     (unsigned int *)&key.type,
+					     &key.offset);
+				if (ret != 3) {
+					fprintf(stderr, "error reading key "
+						"%d\n", errno);
+					print_usage();
+				}
+				break;
 			default:
 				print_usage();
 		}
@@ -882,6 +983,12 @@ int main(int ac, char **av)
 		ret = corrupt_metadata_block(root, metadata_block, field);
 		goto out_close;
 	}
+	if (key.objectid || key.offset || key.type) {
+		if (!strlen(field))
+			print_usage();
+		ret = corrupt_key(root, &key, field);
+		goto out_close;
+	}
 	/*
 	 * If we made it here and we have extent set then we didn't specify
 	 * inode and we're screwed.
diff --git a/cmds-check.c b/cmds-check.c
index 7f07d3b..689fe6c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -49,6 +49,7 @@ static u64 data_bytes_allocated = 0;
 static u64 data_bytes_referenced = 0;
 static int found_old_backref = 0;
 static LIST_HEAD(duplicate_extents);
+static LIST_HEAD(delete_items);
 static int repair = 0;
 static int no_holes = 0;
 
@@ -224,6 +225,12 @@ struct walk_control {
 	int root_level;
 };
 
+struct bad_item {
+	struct btrfs_key key;
+	u64 root_id;
+	struct list_head list;
+};
+
 static void reset_cached_block_groups(struct btrfs_fs_info *fs_info);
 
 static u8 imode_to_type(u32 imode)
@@ -1221,6 +1228,8 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
 
 		if (key.objectid == BTRFS_FREE_SPACE_OBJECTID)
 			continue;
+		if (key.type == BTRFS_ORPHAN_ITEM_KEY)
+			continue;
 
 		if (active_node->current == NULL ||
 		    active_node->current->ino < key.objectid) {
@@ -1414,28 +1423,14 @@ out:
 	return ret;
 }
 
-static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
+static int repair_inode_isize(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root, struct btrfs_path *path,
+			      struct inode_record *rec)
 {
-	struct btrfs_trans_handle *trans;
-	struct btrfs_path *path;
 	struct btrfs_inode_item *ei;
 	struct btrfs_key key;
 	int ret;
 
-	/* So far we just fix dir isize wrong */
-	if (!(rec->errors & I_ERR_DIR_ISIZE_WRONG))
-		return 1;
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
-	trans = btrfs_start_transaction(root, 1);
-	if (IS_ERR(trans)) {
-		btrfs_free_path(path);
-		return PTR_ERR(trans);
-	}
-
 	key.objectid = rec->ino;
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = (u64)-1;
@@ -1465,6 +1460,53 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 	printf("reset isize for dir %Lu root %Lu\n", rec->ino,
 	       root->root_key.objectid);
 out:
+	btrfs_release_path(path);
+	return ret;
+}
+
+static int repair_inode_orphan_item(struct btrfs_trans_handle *trans,
+				    struct btrfs_root *root,
+				    struct btrfs_path *path,
+				    struct inode_record *rec)
+{
+	struct btrfs_key key;
+	int ret;
+
+	key.objectid = BTRFS_ORPHAN_OBJECTID;
+	key.type = BTRFS_ORPHAN_ITEM_KEY;
+	key.offset = rec->ino;
+
+	ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
+	btrfs_release_path(path);
+	if (!ret)
+		rec->errors &= ~I_ERR_NO_ORPHAN_ITEM;
+	return ret;
+}
+
+static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path *path;
+	int ret = 0;
+
+	/* So far we just fix dir isize wrong */
+	if (!(rec->errors & (I_ERR_DIR_ISIZE_WRONG | I_ERR_NO_ORPHAN_ITEM)))
+		return 1;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
+
+	if (rec->errors & I_ERR_DIR_ISIZE_WRONG)
+		ret = repair_inode_isize(trans, root, path, rec);
+	if (!ret && rec->errors & I_ERR_NO_ORPHAN_ITEM)
+		ret = repair_inode_orphan_item(trans, root, path, rec);
 	btrfs_commit_transaction(trans, root);
 	btrfs_free_path(path);
 	return ret;
@@ -2001,8 +2043,8 @@ static int check_fs_roots(struct btrfs_root *root,
 		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
 		if (key.type == BTRFS_ROOT_ITEM_KEY &&
 		    fs_root_objectid(key.objectid)) {
-			tmp_root = btrfs_read_fs_root_no_cache(root->fs_info,
-							       &key);
+			key.offset = (u64)-1;
+			tmp_root = btrfs_read_fs_root(root->fs_info, &key);
 			if (IS_ERR(tmp_root)) {
 				err = 1;
 				goto next;
@@ -2010,7 +2052,6 @@ static int check_fs_roots(struct btrfs_root *root,
 			ret = check_fs_root(tmp_root, root_cache, &wc);
 			if (ret)
 				err = 1;
-			btrfs_free_fs_root(tmp_root);
 		} else if (key.type == BTRFS_ROOT_REF_KEY ||
 			   key.type == BTRFS_ROOT_BACKREF_KEY) {
 			process_root_ref(leaf, path.slots[0], &key,
@@ -2285,13 +2326,148 @@ static int record_bad_block_io(struct btrfs_fs_info *info,
 	return btrfs_add_corrupt_extent_record(info, &key, start, len, 0);
 }
 
-static int check_block(struct btrfs_root *root,
+static int swap_values(struct btrfs_root *root, struct btrfs_path *path,
+		       struct extent_buffer *buf, int slot)
+{
+	if (btrfs_header_level(buf)) {
+		struct btrfs_key_ptr ptr1, ptr2;
+
+		read_extent_buffer(buf, &ptr1, btrfs_node_key_ptr_offset(slot),
+				   sizeof(struct btrfs_key_ptr));
+		read_extent_buffer(buf, &ptr2,
+				   btrfs_node_key_ptr_offset(slot + 1),
+				   sizeof(struct btrfs_key_ptr));
+		write_extent_buffer(buf, &ptr1,
+				    btrfs_node_key_ptr_offset(slot + 1),
+				    sizeof(struct btrfs_key_ptr));
+		write_extent_buffer(buf, &ptr2,
+				    btrfs_node_key_ptr_offset(slot),
+				    sizeof(struct btrfs_key_ptr));
+		if (slot == 0) {
+			struct btrfs_disk_key key;
+			btrfs_node_key(buf, &key, 0);
+			btrfs_fixup_low_keys(root, path, &key,
+					     btrfs_header_level(buf) + 1);
+		}
+	} else {
+		struct btrfs_item *item1, *item2;
+		struct btrfs_key k1, k2;
+		char *item1_data, *item2_data;
+		u32 item1_offset, item2_offset, item1_size, item2_size;
+
+		item1 = btrfs_item_nr(slot);
+		item2 = btrfs_item_nr(slot + 1);
+		btrfs_item_key_to_cpu(buf, &k1, slot);
+		btrfs_item_key_to_cpu(buf, &k2, slot + 1);
+		item1_offset = btrfs_item_offset(buf, item1);
+		item2_offset = btrfs_item_offset(buf, item2);
+		item1_size = btrfs_item_size(buf, item1);
+		item2_size = btrfs_item_size(buf, item2);
+
+		item1_data = malloc(item1_size);
+		if (!item1_data)
+			return -ENOMEM;
+		item2_data = malloc(item2_size);
+		if (!item2_data) {
+			free(item2_data);
+			return -ENOMEM;
+		}
+
+		read_extent_buffer(buf, item1_data, item1_offset, item1_size);
+		read_extent_buffer(buf, item2_data, item2_offset, item2_size);
+
+		write_extent_buffer(buf, item1_data, item2_offset, item2_size);
+		write_extent_buffer(buf, item2_data, item1_offset, item1_size);
+		free(item1_data);
+		free(item2_data);
+
+		btrfs_set_item_offset(buf, item1, item2_offset);
+		btrfs_set_item_offset(buf, item2, item1_offset);
+		btrfs_set_item_size(buf, item1, item2_size);
+		btrfs_set_item_size(buf, item2, item1_size);
+
+		path->slots[0] = slot;
+		btrfs_set_item_key_unsafe(root, path, &k2);
+		path->slots[0] = slot + 1;
+		btrfs_set_item_key_unsafe(root, path, &k1);
+	}
+	return 0;
+}
+
+/*
+ * Attempt to fix basic block failures.  Currently we only handle bad key
+ * orders, we will cycle through the keys and swap them if necessary.
+ */
+static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct extent_buffer *buf,
+				struct btrfs_disk_key *parent_key,
+				enum btrfs_tree_block_status status)
+{
+	struct btrfs_path *path;
+	struct btrfs_key k1, k2;
+	int i;
+	int ret;
+
+	if (status != BTRFS_TREE_BLOCK_BAD_KEY_ORDER)
+		return -EIO;
+
+	k1.objectid = btrfs_header_owner(buf);
+	k1.type = BTRFS_ROOT_ITEM_KEY;
+	k1.offset = (u64)-1;
+
+	root = btrfs_read_fs_root(root->fs_info, &k1);
+	if (IS_ERR(root))
+		return -EIO;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -EIO;
+
+	path->lowest_level = btrfs_header_level(buf);
+	path->skip_check_block = 1;
+	if (btrfs_header_level(buf))
+		btrfs_node_key_to_cpu(buf, &k1, 0);
+	else
+		btrfs_item_key_to_cpu(buf, &k1, 0);
+
+	ret = btrfs_search_slot(trans, root, &k1, path, 0, 1);
+	if (ret) {
+		btrfs_free_path(path);
+		return -EIO;
+	}
+
+	buf = path->nodes[0];
+	for (i = 0; i < btrfs_header_nritems(buf) - 1; i++) {
+		if (btrfs_header_level(buf)) {
+			btrfs_node_key_to_cpu(buf, &k1, i);
+			btrfs_node_key_to_cpu(buf, &k2, i + 1);
+		} else {
+			btrfs_item_key_to_cpu(buf, &k1, i);
+			btrfs_item_key_to_cpu(buf, &k2, i + 1);
+		}
+		if (btrfs_comp_cpu_keys(&k1, &k2) < 0)
+			continue;
+		ret = swap_values(root, path, buf, i);
+		if (ret)
+			break;
+		btrfs_mark_buffer_dirty(buf);
+		i = 0;
+	}
+
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int check_block(struct btrfs_trans_handle *trans,
+		       struct btrfs_root *root,
 		       struct cache_tree *extent_cache,
 		       struct extent_buffer *buf, u64 flags)
 {
 	struct extent_record *rec;
 	struct cache_extent *cache;
 	struct btrfs_key key;
+	enum btrfs_tree_block_status status;
 	int ret = 1;
 	int level;
 
@@ -2314,13 +2490,26 @@ static int check_block(struct btrfs_root *root,
 	rec->info_level = level;
 
 	if (btrfs_is_leaf(buf))
-		ret = btrfs_check_leaf(root, &rec->parent_key, buf);
+		status = btrfs_check_leaf(root, &rec->parent_key, buf);
 	else
-		ret = btrfs_check_node(root, &rec->parent_key, buf);
-
-	if (ret) {
-		fprintf(stderr, "bad block %llu\n",
-			(unsigned long long)buf->start);
+		status = btrfs_check_node(root, &rec->parent_key, buf);
+
+	if (status != BTRFS_TREE_BLOCK_CLEAN) {
+		if (repair)
+			status = try_to_fix_bad_block(trans, root, buf,
+						      &rec->parent_key,
+						      status);
+		if (status != BTRFS_TREE_BLOCK_CLEAN) {
+			ret = -EIO;
+			fprintf(stderr, "bad block %llu\n",
+				(unsigned long long)buf->start);
+		} else {
+			/*
+			 * Signal to callers we need to start the scan over
+			 * again since we'll have cow'ed blocks.
+			 */
+			ret = -EAGAIN;
+		}
 	} else {
 		rec->content_checked = 1;
 		if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)
@@ -3602,7 +3791,8 @@ static int check_csums(struct btrfs_root *root)
 	return errors;
 }
 
-static int run_next_block(struct btrfs_root *root,
+static int run_next_block(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root,
 			  struct block_info *bits,
 			  int bits_nr,
 			  u64 *last,
@@ -3623,7 +3813,7 @@ static int run_next_block(struct btrfs_root *root,
 	u64 owner;
 	u64 flags;
 	u64 ptr;
-	int ret;
+	int ret = 0;
 	int i;
 	int nritems;
 	struct btrfs_key key;
@@ -3696,7 +3886,7 @@ static int run_next_block(struct btrfs_root *root,
 		owner = btrfs_header_owner(buf);
 	}
 
-	ret = check_block(root, extent_cache, buf, flags);
+	ret = check_block(trans, root, extent_cache, buf, flags);
 	if (ret)
 		goto out;
 
@@ -3782,6 +3972,23 @@ static int run_next_block(struct btrfs_root *root,
 					0, root->sectorsize);
 				continue;
 			}
+			if (key.type == BTRFS_ORPHAN_ITEM_KEY) {
+				struct bad_item *bad;
+
+				if (key.objectid == BTRFS_ORPHAN_OBJECTID)
+					continue;
+				if (!owner)
+					continue;
+				bad = malloc(sizeof(struct bad_item));
+				if (!bad)
+					continue;
+				INIT_LIST_HEAD(&bad->list);
+				memcpy(&bad->key, &key,
+				       sizeof(struct btrfs_key));
+				bad->root_id = owner;
+				list_add_tail(&bad->list, &delete_items);
+				continue;
+			}
 			if (key.type != BTRFS_EXTENT_DATA_KEY)
 				continue;
 			fi = btrfs_item_ptr(buf, i,
@@ -3847,7 +4054,7 @@ static int run_next_block(struct btrfs_root *root,
 		found_old_backref = 1;
 out:
 	free_extent_buffer(buf);
-	return 0;
+	return ret;
 }
 
 static int add_root_to_pending(struct extent_buffer *buf,
@@ -5527,15 +5734,16 @@ again:
 	}
 	btrfs_release_path(&path);
 	while(1) {
-		ret = run_next_block(root, bits, bits_nr, &last, &pending,
-				     &seen, &reada, &nodes, &extent_cache,
-				     &chunk_cache, &dev_cache,
+		ret = run_next_block(trans, root, bits, bits_nr, &last,
+				     &pending, &seen, &reada, &nodes,
+				     &extent_cache, &chunk_cache, &dev_cache,
 				     &block_group_cache, &dev_extent_cache);
 		if (ret != 0)
 			break;
 	}
 
-	ret = check_extent_refs(trans, root, &extent_cache);
+	if (ret >= 0)
+		ret = check_extent_refs(trans, root, &extent_cache);
 	if (ret == -EAGAIN) {
 		ret = btrfs_commit_transaction(trans, root);
 		if (ret)
@@ -6019,6 +6227,49 @@ static int recow_extent_buffer(struct btrfs_root *root, struct extent_buffer *eb
 	return ret;
 }
 
+static int delete_bad_item(struct btrfs_root *root, struct bad_item *bad)
+{
+	struct btrfs_path *path;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_key key;
+	int ret;
+
+	printf("Deleting bad item [%llu,%u,%llu]\n", bad->key.objectid,
+	       bad->key.type, bad->key.offset);
+	key.objectid = bad->root_id;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	root = btrfs_read_fs_root(root->fs_info, &key);
+	if (IS_ERR(root)) {
+		fprintf(stderr, "Couldn't find owner root %llu\n",
+			key.objectid);
+		return PTR_ERR(root);
+	}
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
+
+	ret = btrfs_search_slot(trans, root, &bad->key, path, -1, 1);
+	if (ret) {
+		if (ret > 0)
+			ret = 0;
+		goto out;
+	}
+	ret = btrfs_del_item(trans, root, path);
+out:
+	btrfs_commit_transaction(trans, root);
+	btrfs_free_path(path);
+	return ret;
+}
+
 static struct option long_options[] = {
 	{ "super", 1, NULL, 's' },
 	{ "repair", 0, NULL, 0 },
@@ -6199,6 +6450,16 @@ int cmd_check(int argc, char **argv)
 			break;
 	}
 
+	while (!list_empty(&delete_items)) {
+		struct bad_item *bad;
+
+		bad = list_first_entry(&delete_items, struct bad_item, list);
+		list_del_init(&bad->list);
+		if (repair)
+			ret = delete_bad_item(root, bad);
+		free(bad);
+	}
+
 	if (!list_empty(&root->fs_info->recow_ebs)) {
 		fprintf(stderr, "Transid errors in file system\n");
 		ret = 1;
diff --git a/ctree.c b/ctree.c
index fdb1bcb..6c87465 100644
--- a/ctree.c
+++ b/ctree.c
@@ -371,31 +371,35 @@ int btrfs_cow_block(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-/*
- * compare two keys in a memcmp fashion
- */
-static int btrfs_comp_keys(struct btrfs_disk_key *disk, struct btrfs_key *k2)
+int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2)
 {
-	struct btrfs_key k1;
-
-	btrfs_disk_key_to_cpu(&k1, disk);
-
-	if (k1.objectid > k2->objectid)
+	if (k1->objectid > k2->objectid)
 		return 1;
-	if (k1.objectid < k2->objectid)
+	if (k1->objectid < k2->objectid)
 		return -1;
-	if (k1.type > k2->type)
+	if (k1->type > k2->type)
 		return 1;
-	if (k1.type < k2->type)
+	if (k1->type < k2->type)
 		return -1;
-	if (k1.offset > k2->offset)
+	if (k1->offset > k2->offset)
 		return 1;
-	if (k1.offset < k2->offset)
+	if (k1->offset < k2->offset)
 		return -1;
 	return 0;
 }
 
 /*
+ * compare two keys in a memcmp fashion
+ */
+static int btrfs_comp_keys(struct btrfs_disk_key *disk, struct btrfs_key *k2)
+{
+	struct btrfs_key k1;
+
+	btrfs_disk_key_to_cpu(&k1, disk);
+	return btrfs_comp_cpu_keys(&k1, k2);
+}
+
+/*
  * The leaf data grows from end-to-front in the node.
  * this returns the address of the start of the last item,
  * which is the stop of the leaf data stack
@@ -409,30 +413,33 @@ static inline unsigned int leaf_data_end(struct btrfs_root *root,
 	return btrfs_item_offset_nr(leaf, nr - 1);
 }
 
-int btrfs_check_node(struct btrfs_root *root,
-		      struct btrfs_disk_key *parent_key,
-		      struct extent_buffer *buf)
+enum btrfs_tree_block_status
+btrfs_check_node(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
+		 struct extent_buffer *buf)
 {
 	int i;
 	struct btrfs_key cpukey;
 	struct btrfs_disk_key key;
 	u32 nritems = btrfs_header_nritems(buf);
+	enum btrfs_tree_block_status ret = BTRFS_TREE_BLOCK_INVALID_NRITEMS;
 
 	if (nritems == 0 || nritems > BTRFS_NODEPTRS_PER_BLOCK(root))
 		goto fail;
 
+	ret = BTRFS_TREE_BLOCK_INVALID_PARENT_KEY;
 	if (parent_key && parent_key->type) {
 		btrfs_node_key(buf, &key, 0);
 		if (memcmp(parent_key, &key, sizeof(key)))
 			goto fail;
 	}
+	ret = BTRFS_TREE_BLOCK_BAD_KEY_ORDER;
 	for (i = 0; nritems > 1 && i < nritems - 2; i++) {
 		btrfs_node_key(buf, &key, i);
 		btrfs_node_key_to_cpu(buf, &cpukey, i + 1);
 		if (btrfs_comp_keys(&key, &cpukey) >= 0)
 			goto fail;
 	}
-	return 0;
+	return BTRFS_TREE_BLOCK_CLEAN;
 fail:
 	if (btrfs_header_owner(buf) == BTRFS_EXTENT_TREE_OBJECTID) {
 		if (parent_key)
@@ -443,17 +450,18 @@ fail:
 						buf->start, buf->len,
 						btrfs_header_level(buf));
 	}
-	return -EIO;
+	return ret;
 }
 
-int btrfs_check_leaf(struct btrfs_root *root,
-		      struct btrfs_disk_key *parent_key,
-		      struct extent_buffer *buf)
+enum btrfs_tree_block_status
+btrfs_check_leaf(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
+		 struct extent_buffer *buf)
 {
 	int i;
 	struct btrfs_key cpukey;
 	struct btrfs_disk_key key;
 	u32 nritems = btrfs_header_nritems(buf);
+	enum btrfs_tree_block_status ret = BTRFS_TREE_BLOCK_INVALID_NRITEMS;
 
 	if (nritems * sizeof(struct btrfs_item) > buf->len)  {
 		fprintf(stderr, "invalid number of items %llu\n",
@@ -462,11 +470,13 @@ int btrfs_check_leaf(struct btrfs_root *root,
 	}
 
 	if (btrfs_header_level(buf) != 0) {
+		ret = BTRFS_TREE_BLOCK_INVALID_LEVEL;
 		fprintf(stderr, "leaf is not a leaf %llu\n",
 		       (unsigned long long)btrfs_header_bytenr(buf));
 		goto fail;
 	}
 	if (btrfs_leaf_free_space(root, buf) < 0) {
+		ret = BTRFS_TREE_BLOCK_INVALID_FREE_SPACE;
 		fprintf(stderr, "leaf free space incorrect %llu %d\n",
 			(unsigned long long)btrfs_header_bytenr(buf),
 			btrfs_leaf_free_space(root, buf));
@@ -474,11 +484,12 @@ int btrfs_check_leaf(struct btrfs_root *root,
 	}
 
 	if (nritems == 0)
-		return 0;
+		return BTRFS_TREE_BLOCK_CLEAN;
 
 	btrfs_item_key(buf, &key, 0);
 	if (parent_key && parent_key->type &&
 	    memcmp(parent_key, &key, sizeof(key))) {
+		ret = BTRFS_TREE_BLOCK_INVALID_PARENT_KEY;
 		fprintf(stderr, "leaf parent key incorrect %llu\n",
 		       (unsigned long long)btrfs_header_bytenr(buf));
 		goto fail;
@@ -487,11 +498,13 @@ int btrfs_check_leaf(struct btrfs_root *root,
 		btrfs_item_key(buf, &key, i);
 		btrfs_item_key_to_cpu(buf, &cpukey, i + 1);
 		if (btrfs_comp_keys(&key, &cpukey) >= 0) {
+			ret = BTRFS_TREE_BLOCK_BAD_KEY_ORDER;
 			fprintf(stderr, "bad key ordering %d %d\n", i, i+1);
 			goto fail;
 		}
 		if (btrfs_item_offset_nr(buf, i) !=
 			btrfs_item_end_nr(buf, i + 1)) {
+			ret = BTRFS_TREE_BLOCK_INVALID_OFFSETS;
 			fprintf(stderr, "incorrect offsets %u %u\n",
 				btrfs_item_offset_nr(buf, i),
 				btrfs_item_end_nr(buf, i + 1));
@@ -499,13 +512,14 @@ int btrfs_check_leaf(struct btrfs_root *root,
 		}
 		if (i == 0 && btrfs_item_end_nr(buf, i) !=
 		    BTRFS_LEAF_DATA_SIZE(root)) {
+			ret = BTRFS_TREE_BLOCK_INVALID_OFFSETS;
 			fprintf(stderr, "bad item end %u wanted %u\n",
 				btrfs_item_end_nr(buf, i),
 				(unsigned)BTRFS_LEAF_DATA_SIZE(root));
 			goto fail;
 		}
 	}
-	return 0;
+	return BTRFS_TREE_BLOCK_CLEAN;
 fail:
 	if (btrfs_header_owner(buf) == BTRFS_EXTENT_TREE_OBJECTID) {
 		if (parent_key)
@@ -516,7 +530,7 @@ fail:
 		btrfs_add_corrupt_extent_record(root->fs_info, &cpukey,
 						buf->start, buf->len, 0);
 	}
-	return -EIO;
+	return ret;
 }
 
 static int noinline check_block(struct btrfs_root *root,
@@ -525,15 +539,22 @@ static int noinline check_block(struct btrfs_root *root,
 	struct btrfs_disk_key key;
 	struct btrfs_disk_key *key_ptr = NULL;
 	struct extent_buffer *parent;
+	enum btrfs_tree_block_status ret;
 
+	if (path->skip_check_block)
+		return 0;
 	if (path->nodes[level + 1]) {
 		parent = path->nodes[level + 1];
 		btrfs_node_key(parent, &key, path->slots[level + 1]);
 		key_ptr = &key;
 	}
 	if (level == 0)
-		return btrfs_check_leaf(root, key_ptr, path->nodes[0]);
-	return btrfs_check_node(root, key_ptr, path->nodes[level]);
+		ret =  btrfs_check_leaf(root, key_ptr, path->nodes[0]);
+	else
+		ret = btrfs_check_node(root, key_ptr, path->nodes[level]);
+	if (ret == BTRFS_TREE_BLOCK_CLEAN)
+		return 0;
+	return -EIO;
 }
 
 /*
@@ -1114,16 +1135,11 @@ again:
  * This is used after shifting pointers to the left, so it stops
  * fixing up pointers when a given leaf/node is not in slot 0 of the
  * higher levels
- *
- * If this fails to write a tree block, it returns -1, but continues
- * fixing up the blocks in ram so the tree is consistent.
  */
-static int fixup_low_keys(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, struct btrfs_path *path,
+void btrfs_fixup_low_keys(struct btrfs_root *root, struct btrfs_path *path,
 			  struct btrfs_disk_key *key, int level)
 {
 	int i;
-	int ret = 0;
 	struct extent_buffer *t;
 
 	for (i = level; i < BTRFS_MAX_LEVEL; i++) {
@@ -1136,7 +1152,6 @@ static int fixup_low_keys(struct btrfs_trans_handle *trans,
 		if (tslot != 0)
 			break;
 	}
-	return ret;
 }
 
 /*
@@ -1145,8 +1160,7 @@ static int fixup_low_keys(struct btrfs_trans_handle *trans,
  * This function isn't completely safe. It's the caller's responsibility
  * that the new key won't break the order
  */
-int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, struct btrfs_path *path,
+int btrfs_set_item_key_safe(struct btrfs_root *root, struct btrfs_path *path,
 			    struct btrfs_key *new_key)
 {
 	struct btrfs_disk_key disk_key;
@@ -1170,11 +1184,33 @@ int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
 	btrfs_set_item_key(eb, &disk_key, slot);
 	btrfs_mark_buffer_dirty(eb);
 	if (slot == 0)
-		fixup_low_keys(trans, root, path, &disk_key, 1);
+		btrfs_fixup_low_keys(root, path, &disk_key, 1);
 	return 0;
 }
 
 /*
+ * update an item key without the safety checks.  This is meant to be called by
+ * fsck only.
+ */
+void btrfs_set_item_key_unsafe(struct btrfs_root *root,
+			       struct btrfs_path *path,
+			       struct btrfs_key *new_key)
+{
+	struct btrfs_disk_key disk_key;
+	struct extent_buffer *eb;
+	int slot;
+
+	eb = path->nodes[0];
+	slot = path->slots[0];
+
+	btrfs_cpu_key_to_disk(&disk_key, new_key);
+	btrfs_set_item_key(eb, &disk_key, slot);
+	btrfs_mark_buffer_dirty(eb);
+	if (slot == 0)
+		btrfs_fixup_low_keys(root, path, &disk_key, 1);
+}
+
+/*
  * try to push data from one node into the next node left in the
  * tree.
  *
@@ -1706,7 +1742,6 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 	u32 right_nritems;
 	u32 nr;
 	int ret = 0;
-	int wret;
 	u32 this_item_size;
 	u32 old_left_item_size;
 
@@ -1830,9 +1865,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 		btrfs_mark_buffer_dirty(right);
 
 	btrfs_item_key(right, &disk_key, 0);
-	wret = fixup_low_keys(trans, root, path, &disk_key, 1);
-	if (wret)
-		ret = wret;
+	btrfs_fixup_low_keys(root, path, &disk_key, 1);
 
 	/* then fixup the leaf pointer in the path */
 	if (path->slots[0] < push_items) {
@@ -2052,10 +2085,8 @@ again:
 			path->nodes[0] = right;
 			path->slots[0] = 0;
 			if (path->slots[1] == 0) {
-				wret = fixup_low_keys(trans, root,
-						path, &disk_key, 1);
-				if (wret)
-					ret = wret;
+				btrfs_fixup_low_keys(root, path,
+						     &disk_key, 1);
 			}
 		}
 		btrfs_mark_buffer_dirty(right);
@@ -2270,7 +2301,7 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
 		btrfs_set_disk_key_offset(&disk_key, offset + size_diff);
 		btrfs_set_item_key(leaf, &disk_key, slot);
 		if (slot == 0)
-			fixup_low_keys(trans, root, path, &disk_key, 1);
+			btrfs_fixup_low_keys(root, path, &disk_key, 1);
 	}
 
 	item = btrfs_item_nr(slot);
@@ -2448,7 +2479,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	ret = 0;
 	if (slot == 0) {
 		btrfs_cpu_key_to_disk(&disk_key, cpu_key);
-		ret = fixup_low_keys(trans, root, path, &disk_key, 1);
+		btrfs_fixup_low_keys(root, path, &disk_key, 1);
 	}
 
 	if (btrfs_leaf_free_space(root, leaf) < 0) {
@@ -2499,7 +2530,6 @@ int btrfs_del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	struct extent_buffer *parent = path->nodes[level];
 	u32 nritems;
 	int ret = 0;
-	int wret;
 
 	nritems = btrfs_header_nritems(parent);
 	if (slot != nritems -1) {
@@ -2519,9 +2549,7 @@ int btrfs_del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		struct btrfs_disk_key disk_key;
 
 		btrfs_node_key(parent, &disk_key, 0);
-		wret = fixup_low_keys(trans, root, path, &disk_key, level + 1);
-		if (wret)
-			ret = wret;
+		btrfs_fixup_low_keys(root, path, &disk_key, level + 1);
 	}
 	btrfs_mark_buffer_dirty(parent);
 	return ret;
@@ -2621,10 +2649,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			struct btrfs_disk_key disk_key;
 
 			btrfs_item_key(leaf, &disk_key, 0);
-			wret = fixup_low_keys(trans, root, path,
-					      &disk_key, 1);
-			if (wret)
-				ret = wret;
+			btrfs_fixup_low_keys(root, path, &disk_key, 1);
 		}
 
 		/* delete the leaf if it is mostly empty */
diff --git a/ctree.h b/ctree.h
index 761987a..51fdca4 100644
--- a/ctree.h
+++ b/ctree.h
@@ -548,6 +548,7 @@ struct btrfs_path {
 	unsigned int keep_locks:1;
 	unsigned int skip_locking:1;
 	unsigned int leave_spinning:1;
+	unsigned int skip_check_block:1;
 };
 
 /*
@@ -648,6 +649,16 @@ typedef enum {
 	BTRFS_ENCRYPTION_LAST = 1,
 } btrfs_encryption_type;
 
+enum btrfs_tree_block_status {
+	BTRFS_TREE_BLOCK_CLEAN,
+	BTRFS_TREE_BLOCK_INVALID_NRITEMS,
+	BTRFS_TREE_BLOCK_INVALID_PARENT_KEY,
+	BTRFS_TREE_BLOCK_BAD_KEY_ORDER,
+	BTRFS_TREE_BLOCK_INVALID_LEVEL,
+	BTRFS_TREE_BLOCK_INVALID_FREE_SPACE,
+	BTRFS_TREE_BLOCK_INVALID_OFFSETS,
+};
+
 struct btrfs_inode_item {
 	/* nfs style generation number */
 	__le64 generation;
@@ -2203,14 +2214,15 @@ int btrfs_record_file_extent(struct btrfs_trans_handle *trans,
 			      u64 file_pos, u64 disk_bytenr,
 			      u64 num_bytes);
 /* ctree.c */
+int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2);
 int btrfs_del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_path *path, int level, int slot);
-int btrfs_check_node(struct btrfs_root *root,
-		      struct btrfs_disk_key *parent_key,
-		      struct extent_buffer *buf);
-int btrfs_check_leaf(struct btrfs_root *root,
-		      struct btrfs_disk_key *parent_key,
-		      struct extent_buffer *buf);
+enum btrfs_tree_block_status
+btrfs_check_node(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
+		 struct extent_buffer *buf);
+enum btrfs_tree_block_status
+btrfs_check_leaf(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
+		 struct extent_buffer *buf);
 void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
 			     int level, int slot, u64 objectid);
 struct extent_buffer *read_node_slot(struct btrfs_root *root,
@@ -2280,9 +2292,13 @@ static inline int btrfs_insert_empty_item(struct btrfs_trans_handle *trans,
 int btrfs_next_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
 int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf);
-int btrfs_set_item_key_safe(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, struct btrfs_path *path,
+void btrfs_fixup_low_keys(struct btrfs_root *root, struct btrfs_path *path,
+			  struct btrfs_disk_key *key, int level);
+int btrfs_set_item_key_safe(struct btrfs_root *root, struct btrfs_path *path,
 			    struct btrfs_key *new_key);
+void btrfs_set_item_key_unsafe(struct btrfs_root *root,
+			       struct btrfs_path *path,
+			       struct btrfs_key *new_key);
 
 /* root-item.c */
 int btrfs_add_root_ref(struct btrfs_trans_handle *trans,
diff --git a/file-item.c b/file-item.c
index f53a5ca..6f3708b 100644
--- a/file-item.c
+++ b/file-item.c
@@ -367,7 +367,7 @@ static noinline int truncate_one_csum(struct btrfs_trans_handle *trans,
 		BUG_ON(ret);
 
 		key->offset = end_byte;
-		ret = btrfs_set_item_key_safe(trans, root, path, key);
+		ret = btrfs_set_item_key_safe(root, path, key);
 		BUG_ON(ret);
 	} else {
 		BUG();
diff --git a/tests/fsck-tests/003-bad-orphan-key.img b/tests/fsck-tests/003-bad-orphan-key.img
new file mode 100644
index 0000000000000000000000000000000000000000..2a9b60d95debb9fe1dd8620858e34671c84b86ed
GIT binary patch
literal 4096
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

literal 0
HcmV?d00001

-- 
1.8.3.1

