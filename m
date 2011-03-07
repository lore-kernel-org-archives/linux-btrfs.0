From: Chris Ball <cjb@laptop.org>
Subject: [PATCH -progs] Fix unused-but-set errors in gcc-4.6
Date: Mon, 07 Mar 2011 10:05:21 -0500
Message-ID: <m3d3m3dl8u.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

gcc-4.6 (as shipped in Fedora) turns on -Wunused-but-set-variable by
default, which breaks the build when combined with -Wall, e.g.:

debug-tree.c: In function =E2=80=98print_extent_leaf=E2=80=99:
debug-tree.c:45:13: error: variable =E2=80=98last_len=E2=80=99 set but =
not used [-Werror=3Dunused-but-set-variable]
debug-tree.c:44:13: error: variable =E2=80=98last=E2=80=99 set but not =
used [-Werror=3Dunused-but-set-variable]
debug-tree.c:41:21: error: variable =E2=80=98item=E2=80=99 set but not =
used [-Werror=3Dunused-but-set-variable]
cc1: all warnings being treated as errors

This patch fixes the errors by removing the unused variables.

Signed-off-by: Chris Ball <cjb@laptop.org>
---
This is a pretty big patch -- I'm happy to split it out per-file if
you'd prefer to review it that way.  It's against the "next" branch.
It removes some #if 0 blocks completely; seemed easier to let that
code live on in Git history than to add #if 0 blocks around the
declarations of all the variables only used inside those blocks.

 btrfs-map-logical.c |    2 --
 btrfsck.c           |   15 ++-------------
 ctree.c             |   16 ----------------
 debug-tree.c        |   43 +------------------------------------------
 dir-item.c          |    2 +-
 disk-io.c           |    4 ----
 extent-cache.c      |    6 ++----
 extent-tree.c       |   30 ------------------------------
 extent_io.c         |    4 ----
 mkfs.c              |    2 --
 print-tree.c        |    3 ---
 utils.c             |    3 +--
 volumes.c           |    4 ----
 13 files changed, 7 insertions(+), 127 deletions(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index a109c6a..8a12074 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -41,7 +41,6 @@ struct extent_buffer *debug_read_block(struct btrfs_r=
oot *root, u64 bytenr,
 				     u32 blocksize, int copy)
 {
 	int ret;
-	int dev_nr;
 	struct extent_buffer *eb;
 	u64 length;
 	struct btrfs_multi_bio *multi =3D NULL;
@@ -53,7 +52,6 @@ struct extent_buffer *debug_read_block(struct btrfs_r=
oot *root, u64 bytenr,
 	if (!eb)
 		return NULL;
=20
-	dev_nr =3D 0;
 	length =3D blocksize;
 	while (1) {
 		ret =3D btrfs_map_block(&root->fs_info->mapping_tree, READ,
diff --git a/btrfsck.c b/btrfsck.c
index 63e44d1..e3cd435 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -1037,7 +1037,7 @@ static int process_one_leaf(struct btrfs_root *ro=
ot, struct extent_buffer *eb,
 			break;
 		};
 	}
-	return 0;
+	return ret;
 }
=20
 static void reada_walk_down(struct btrfs_root *root,
@@ -1917,7 +1917,6 @@ static int check_owner_ref(struct btrfs_root *roo=
t,
 	struct btrfs_root *ref_root;
 	struct btrfs_key key;
 	struct btrfs_path path;
-	int ret;
 	int level;
 	int found =3D 0;
=20
@@ -1950,7 +1949,7 @@ static int check_owner_ref(struct btrfs_root *roo=
t,
 =09
 	btrfs_init_path(&path);
 	path.lowest_level =3D level + 1;
-	ret =3D btrfs_search_slot(NULL, ref_root, &key, &path, 0, 0);
+	btrfs_search_slot(NULL, ref_root, &key, &path, 0, 0);
=20
 	if (buf->start =3D=3D btrfs_node_blockptr(path.nodes[level + 1],
 					      path.slots[level + 1]))
@@ -2539,16 +2538,6 @@ static int run_next_block(struct btrfs_root *roo=
t,
 				continue;
 			}
 			if (key.type =3D=3D BTRFS_BLOCK_GROUP_ITEM_KEY) {
-				struct btrfs_block_group_item *bi;
-				bi =3D btrfs_item_ptr(buf, i,
-					    struct btrfs_block_group_item);
-#if 0
-				fprintf(stderr,"block group %Lu %Lu used %Lu ",
-					btrfs_disk_key_objectid(disk_key),
-					btrfs_disk_key_offset(disk_key),
-					btrfs_block_group_used(bi));
-				fprintf(stderr, "flags %x\n", bi->flags);
-#endif
 				continue;
 			}
 			if (key.type =3D=3D BTRFS_EXTENT_REF_V0_KEY) {
diff --git a/ctree.c b/ctree.c
index f70e10c..12f1a55 100644
--- a/ctree.c
+++ b/ctree.c
@@ -262,7 +262,6 @@ int __btrfs_cow_block(struct btrfs_trans_handle *tr=
ans,
 			     struct extent_buffer **cow_ret,
 			     u64 search_start, u64 empty_size)
 {
-	u64 generation;
 	struct extent_buffer *cow;
 	struct btrfs_disk_key disk_key;
 	int level;
@@ -272,7 +271,6 @@ int __btrfs_cow_block(struct btrfs_trans_handle *tr=
ans,
 	WARN_ON(root->ref_cows && trans->transid !=3D root->last_trans);
=20
 	level =3D btrfs_header_level(buf);
-	generation =3D btrfs_header_generation(buf);
=20
 	if (level =3D=3D 0)
 		btrfs_item_key(buf, &disk_key, 0);
@@ -795,7 +793,6 @@ static int balance_level(struct btrfs_trans_handle =
*trans,
 	int wret;
 	int pslot;
 	int orig_slot =3D path->slots[level];
-	int err_on_enospc =3D 0;
 	u64 orig_ptr;
=20
 	if (level =3D=3D 0)
@@ -845,9 +842,6 @@ static int balance_level(struct btrfs_trans_handle =
*trans,
 	    BTRFS_NODEPTRS_PER_BLOCK(root) / 4)
 		return 0;
=20
-	if (btrfs_header_nritems(mid) < 2)
-		err_on_enospc =3D 1;
-
 	left =3D read_node_slot(root, parent, pslot - 1);
 	if (left) {
 		wret =3D btrfs_cow_block(trans, root, left,
@@ -873,8 +867,6 @@ static int balance_level(struct btrfs_trans_handle =
*trans,
 		wret =3D push_node_left(trans, root, left, mid, 1);
 		if (wret < 0)
 			ret =3D wret;
-		if (btrfs_header_nritems(mid) < 2)
-			err_on_enospc =3D 1;
 	}
=20
 	/*
@@ -996,14 +988,12 @@ static int noinline push_nodes_for_insert(struct =
btrfs_trans_handle *trans,
 	int wret;
 	int pslot;
 	int orig_slot =3D path->slots[level];
-	u64 orig_ptr;
=20
 	if (level =3D=3D 0)
 		return 1;
=20
 	mid =3D path->nodes[level];
 	WARN_ON(btrfs_header_generation(mid) !=3D trans->transid);
-	orig_ptr =3D btrfs_node_blockptr(mid, orig_slot);
=20
 	if (level < BTRFS_MAX_LEVEL - 1)
 		parent =3D path->nodes[level + 1];
@@ -2370,7 +2360,6 @@ int btrfs_truncate_item(struct btrfs_trans_handle=
 *trans,
 {
 	int ret =3D 0;
 	int slot;
-	int slot_orig;
 	struct extent_buffer *leaf;
 	struct btrfs_item *item;
 	u32 nritems;
@@ -2380,7 +2369,6 @@ int btrfs_truncate_item(struct btrfs_trans_handle=
 *trans,
 	unsigned int size_diff;
 	int i;
=20
-	slot_orig =3D path->slots[0];
 	leaf =3D path->nodes[0];
 	slot =3D path->slots[0];
=20
@@ -2468,7 +2456,6 @@ int btrfs_extend_item(struct btrfs_trans_handle *=
trans,
 {
 	int ret =3D 0;
 	int slot;
-	int slot_orig;
 	struct extent_buffer *leaf;
 	struct btrfs_item *item;
 	u32 nritems;
@@ -2477,7 +2464,6 @@ int btrfs_extend_item(struct btrfs_trans_handle *=
trans,
 	unsigned int old_size;
 	int i;
=20
-	slot_orig =3D path->slots[0];
 	leaf =3D path->nodes[0];
=20
 	nritems =3D btrfs_header_nritems(leaf);
@@ -2541,7 +2527,6 @@ int btrfs_insert_empty_items(struct btrfs_trans_h=
andle *trans,
 	struct btrfs_item *item;
 	int ret =3D 0;
 	int slot;
-	int slot_orig;
 	int i;
 	u32 nritems;
 	u32 total_size =3D 0;
@@ -2565,7 +2550,6 @@ int btrfs_insert_empty_items(struct btrfs_trans_h=
andle *trans,
 	if (ret < 0)
 		goto out;
=20
-	slot_orig =3D path->slots[0];
 	leaf =3D path->nodes[0];
=20
 	nritems =3D btrfs_header_nritems(leaf);
diff --git a/debug-tree.c b/debug-tree.c
index 0525354..5938c73 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -35,44 +35,6 @@ static int print_usage(void)
 	exit(1);
 }
=20
-static void print_extent_leaf(struct btrfs_root *root, struct extent_b=
uffer *l)
-{
-	int i;
-	struct btrfs_item *item;
-//	struct btrfs_extent_ref *ref;
-	struct btrfs_key key;
-	static u64 last =3D 0;
-	static u64 last_len =3D 0;
-	u32 nr =3D btrfs_header_nritems(l);
-	u32 type;
-
-	for (i =3D 0 ; i < nr ; i++) {
-		item =3D btrfs_item_nr(l, i);
-		btrfs_item_key_to_cpu(l, &key, i);
-		type =3D btrfs_key_type(&key);
-		switch (type) {
-		case BTRFS_EXTENT_ITEM_KEY:
-			last_len =3D key.offset;
-			last =3D key.objectid;
-			break;
-#if 0
-		case BTRFS_EXTENT_REF_KEY:
-			ref =3D btrfs_item_ptr(l, i, struct btrfs_extent_ref);
-			printf("%llu %llu extent back ref root %llu gen %llu "
-			       "owner %llu num_refs %lu\n",
-			       (unsigned long long)last,
-			       (unsigned long long)last_len,
-			       (unsigned long long)btrfs_ref_root(l, ref),
-			       (unsigned long long)btrfs_ref_generation(l, ref),
-			       (unsigned long long)btrfs_ref_objectid(l, ref),
-			       (unsigned long)btrfs_ref_num_refs(l, ref));
-			break;
-#endif
-		};
-		fflush(stdout);
-	}
-}
-
 static void print_extents(struct btrfs_root *root, struct extent_buffe=
r *eb)
 {
 	int i;
@@ -81,10 +43,7 @@ static void print_extents(struct btrfs_root *root, s=
truct extent_buffer *eb)
=20
 	if (!eb)
 		return;
-	if (btrfs_is_leaf(eb)) {
-		print_extent_leaf(root, eb);
-		return;
-	}
+
 	size =3D btrfs_level_size(root, btrfs_header_level(eb) - 1);
 	nr =3D btrfs_header_nritems(eb);
 	for (i =3D 0; i < nr; i++) {
diff --git a/dir-item.c b/dir-item.c
index 71373b8..f00485a 100644
--- a/dir-item.c
+++ b/dir-item.c
@@ -332,5 +332,5 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_ha=
ndle *trans,
 		ret =3D btrfs_truncate_item(trans, root, path,
 					  item_len - sub_item_len, 1);
 	}
-	return 0;
+	return ret;
 }
diff --git a/disk-io.c b/disk-io.c
index 5bd9cfc..a57cb38 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -123,7 +123,6 @@ int readahead_tree_block(struct btrfs_root *root, u=
64 bytenr, u32 blocksize,
 			 u64 parent_transid)
 {
 	int ret;
-	int dev_nr;
 	struct extent_buffer *eb;
 	u64 length;
 	struct btrfs_multi_bio *multi =3D NULL;
@@ -135,7 +134,6 @@ int readahead_tree_block(struct btrfs_root *root, u=
64 bytenr, u32 blocksize,
 		return 0;
 	}
=20
-	dev_nr =3D 0;
 	length =3D blocksize;
 	ret =3D btrfs_map_block(&root->fs_info->mapping_tree, READ,
 			      bytenr, &length, &multi, 0);
@@ -177,7 +175,6 @@ struct extent_buffer *read_tree_block(struct btrfs_=
root *root, u64 bytenr,
 				     u32 blocksize, u64 parent_transid)
 {
 	int ret;
-	int dev_nr;
 	struct extent_buffer *eb;
 	u64 length;
 	struct btrfs_multi_bio *multi =3D NULL;
@@ -192,7 +189,6 @@ struct extent_buffer *read_tree_block(struct btrfs_=
root *root, u64 bytenr,
 	if (btrfs_buffer_uptodate(eb, parent_transid))
 		return eb;
=20
-	dev_nr =3D 0;
 	length =3D blocksize;
 	while (1) {
 		ret =3D btrfs_map_block(&root->fs_info->mapping_tree, READ,
diff --git a/extent-cache.c b/extent-cache.c
index b871e18..3dd6434 100644
--- a/extent-cache.c
+++ b/extent-cache.c
@@ -96,13 +96,11 @@ int insert_existing_cache_extent(struct cache_tree =
*tree,
 				 struct cache_extent *pe)
 {
 	struct rb_node *found;
-	struct cache_extent *entry;
=20
 	found =3D tree_insert(&tree->root, pe->start, pe->size, &pe->rb_node)=
;
-	if (found) {
-		entry =3D rb_entry(found, struct cache_extent, rb_node);
+	if (found)
 		return -EEXIST;
-	}
+
 	return 0;
 }
=20
diff --git a/extent-tree.c b/extent-tree.c
index b2f9bb2..d550854 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1549,7 +1549,6 @@ static int __btrfs_mod_ref(struct btrfs_trans_han=
dle *trans,
 	int i;
 	int level;
 	int ret =3D 0;
-	int faili =3D 0;
 	int (*process_func)(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
 			    u64, u64, u64, u64, u64, u64);
@@ -1592,7 +1591,6 @@ static int __btrfs_mod_ref(struct btrfs_trans_han=
dle *trans,
 					   parent, ref_root, key.objectid,
 					   key.offset);
 			if (ret) {
-				faili =3D i;
 				WARN_ON(1);
 				goto fail;
 			}
@@ -1602,7 +1600,6 @@ static int __btrfs_mod_ref(struct btrfs_trans_han=
dle *trans,
 			ret =3D process_func(trans, root, bytenr, num_bytes,
 					   parent, ref_root, level - 1, 0);
 			if (ret) {
-				faili =3D i;
 				WARN_ON(1);
 				goto fail;
 			}
@@ -1611,33 +1608,6 @@ static int __btrfs_mod_ref(struct btrfs_trans_ha=
ndle *trans,
 	return 0;
 fail:
 	WARN_ON(1);
-#if 0
-	for (i =3D0; i < faili; i++) {
-		if (level =3D=3D 0) {
-			u64 disk_bytenr;
-			btrfs_item_key_to_cpu(buf, &key, i);
-			if (btrfs_key_type(&key) !=3D BTRFS_EXTENT_DATA_KEY)
-				continue;
-			fi =3D btrfs_item_ptr(buf, i,
-					    struct btrfs_file_extent_item);
-			if (btrfs_file_extent_type(buf, fi) =3D=3D
-			    BTRFS_FILE_EXTENT_INLINE)
-				continue;
-			disk_bytenr =3D btrfs_file_extent_disk_bytenr(buf, fi);
-			if (disk_bytenr =3D=3D 0)
-				continue;
-			err =3D btrfs_free_extent(trans, root, disk_bytenr,
-				    btrfs_file_extent_disk_num_bytes(buf,
-								      fi), 0);
-			BUG_ON(err);
-		} else {
-			bytenr =3D btrfs_node_blockptr(buf, i);
-			err =3D btrfs_free_extent(trans, root, bytenr,
-					btrfs_level_size(root, level - 1), 0);
-			BUG_ON(err);
-		}
-	}
-#endif
 	return ret;
 }
=20
diff --git a/extent_io.c b/extent_io.c
index 069c199..70fecbb 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -296,7 +296,6 @@ int set_extent_bits(struct extent_io_tree *tree, u6=
4 start,
 	struct extent_state *prealloc =3D NULL;
 	struct cache_extent *node;
 	int err =3D 0;
-	int set;
 	u64 last_start;
 	u64 last_end;
 again:
@@ -327,7 +326,6 @@ again:
 	 * Just lock what we found and keep going
 	 */
 	if (state->start =3D=3D start && state->end <=3D end) {
-		set =3D state->state & bits;
 		state->state |=3D bits;
 		merge_state(tree, state);
 		if (last_end =3D=3D (u64)-1)
@@ -352,7 +350,6 @@ again:
 	 * desired bit on it.
 	 */
 	if (state->start < start) {
-		set =3D state->state & bits;
 		err =3D split_state(tree, state, prealloc, start);
 		BUG_ON(err =3D=3D -EEXIST);
 		prealloc =3D NULL;
@@ -398,7 +395,6 @@ again:
 	 * We need to split the extent, and set the bit
 	 * on the first half
 	 */
-	set =3D state->state & bits;
 	err =3D split_state(tree, state, prealloc, end + 1);
 	BUG_ON(err =3D=3D -EEXIST);
=20
diff --git a/mkfs.c b/mkfs.c
index 2e99b95..19c43c8 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -355,7 +355,6 @@ int main(int ac, char **av)
 	int zero_end =3D 1;
 	int option_index =3D 0;
 	int fd;
-	int first_fd;
 	int ret;
 	int i;
=20
@@ -437,7 +436,6 @@ int main(int ac, char **av)
 		fprintf(stderr, "unable to open %s\n", file);
 		exit(1);
 	}
-	first_fd =3D fd;
 	first_file =3D file;
 	ret =3D btrfs_prepare_device(fd, file, zero_end, &dev_block_count);
 	if (block_count =3D=3D 0)
diff --git a/print-tree.c b/print-tree.c
index ac575d5..ddcade1 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -444,7 +444,6 @@ void btrfs_print_leaf(struct btrfs_root *root, stru=
ct extent_buffer *l)
 	struct btrfs_dir_item *di;
 	struct btrfs_inode_item *ii;
 	struct btrfs_file_extent_item *fi;
-	struct btrfs_csum_item *ci;
 	struct btrfs_block_group_item *bi;
 	struct btrfs_extent_data_ref *dref;
 	struct btrfs_shared_data_ref *sref;
@@ -556,11 +555,9 @@ void btrfs_print_leaf(struct btrfs_root *root, str=
uct extent_buffer *l)
 #endif
 			break;
 		case BTRFS_CSUM_ITEM_KEY:
-			ci =3D btrfs_item_ptr(l, i, struct btrfs_csum_item);
 			printf("\t\tcsum item\n");
 			break;
 		case BTRFS_EXTENT_CSUM_KEY:
-			ci =3D btrfs_item_ptr(l, i, struct btrfs_csum_item);
 			printf("\t\textent csum item\n");
 			break;
 		case BTRFS_EXTENT_DATA_KEY:
diff --git a/utils.c b/utils.c
index fd894f3..399a662 100644
--- a/utils.c
+++ b/utils.c
@@ -820,7 +820,6 @@ void btrfs_register_one_device(char *fname)
 {
 	struct btrfs_ioctl_vol_args args;
 	int fd;
-	int ret;
=20
 	fd =3D open("/dev/btrfs-control", O_RDONLY);
 	if (fd < 0) {
@@ -829,7 +828,7 @@ void btrfs_register_one_device(char *fname)
 		return;
 	}
 	strcpy(args.name, fname);
-	ret =3D ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
+	ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
 	close(fd);
 }
=20
diff --git a/volumes.c b/volumes.c
index 7671855..de4a4d3 100644
--- a/volumes.c
+++ b/volumes.c
@@ -643,7 +643,6 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *tr=
ans,
 	struct list_head *cur;
 	struct map_lookup *map;
 	int min_stripe_size =3D 1 * 1024 * 1024;
-	u64 physical;
 	u64 calc_size =3D 8 * 1024 * 1024;
 	u64 min_free;
 	u64 max_chunk_size =3D 4 * calc_size;
@@ -811,7 +810,6 @@ again:
 		btrfs_set_stack_stripe_devid(stripe, device->devid);
 		btrfs_set_stack_stripe_offset(stripe, dev_offset);
 		memcpy(stripe->dev_uuid, device->uuid, BTRFS_UUID_SIZE);
-		physical =3D dev_offset;
 		index++;
 	}
 	BUG_ON(!list_empty(&private_devs));
@@ -867,14 +865,12 @@ int btrfs_num_copies(struct btrfs_mapping_tree *m=
ap_tree, u64 logical, u64 len)
 	struct cache_extent *ce;
 	struct map_lookup *map;
 	int ret;
-	u64 offset;
=20
 	ce =3D find_first_cache_extent(&map_tree->cache_tree, logical);
 	BUG_ON(!ce);
 	BUG_ON(ce->start > logical || ce->start + ce->size < logical);
 	map =3D container_of(ce, struct map_lookup, ce);
=20
-	offset =3D logical - ce->start;
 	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1))
 		ret =3D map->num_stripes;
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID10)
--=20
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
