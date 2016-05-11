Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35800 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbcEKXur (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 19:50:47 -0400
Received: by mail-ig0-f172.google.com with SMTP id bi2so167138323igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 11 May 2016 16:50:46 -0700 (PDT)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nicholas D Steeves <nsteeves@gmail.com>
Subject: [PATCH 1/1] Typo review of strings and comments.
Date: Wed, 11 May 2016 19:50:36 -0400
Message-Id: <1463010636-18514-2-git-send-email-nsteeves@gmail.com>
In-Reply-To: <1463010636-18514-1-git-send-email-nsteeves@gmail.com>
References: <1463010636-18514-1-git-send-email-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nicholas D Steeves <nsteeves@gmail.com>
---
 CHANGES                                            | 12 ++++-----
 backref.c                                          |  4 +--
 btrfs-convert.c                                    |  4 +--
 btrfs-corrupt-block.c                              |  4 +--
 btrfs-debugfs                                      |  2 +-
 btrfs-image.c                                      | 22 ++++++++--------
 btrfs-list.c                                       |  4 +--
 chunk-recover.c                                    |  6 ++---
 cmds-balance.c                                     |  4 +--
 cmds-check.c                                       | 30 +++++++++++-----------
 cmds-fi-du.c                                       |  2 +-
 cmds-fi-usage.c                                    |  2 +-
 cmds-inspect-tree-stats.c                          |  2 +-
 cmds-inspect.c                                     |  2 +-
 cmds-receive.c                                     |  2 +-
 cmds-scrub.c                                       |  2 +-
 cmds-send.c                                        |  2 +-
 ctree.c                                            |  2 +-
 ctree.h                                            |  6 ++---
 dir-item.c                                         |  2 +-
 disk-io.h                                          |  4 +--
 extent-cache.h                                     |  2 +-
 file.c                                             |  4 +--
 inode.c                                            |  4 +--
 ioctl.h                                            |  6 ++---
 list_sort.c                                        |  2 +-
 mkfs.c                                             | 12 ++++-----
 send-utils.c                                       |  2 +-
 show-blocks                                        |  4 +--
 super-recover.c                                    |  4 +--
 tests/README.md                                    |  4 +--
 tests/common                                       |  2 +-
 tests/fsck-tests.sh                                |  2 +-
 tests/misc-tests.sh                                |  2 +-
 tests/misc-tests/007-subvolume-sync/test.sh        |  4 +--
 .../009-subvolume-sync-must-wait/test.sh           |  2 +-
 tests/misc-tests/013-subvolume-sync-crash/test.sh  |  2 +-
 tests/mkfs-tests.sh                                |  2 +-
 .../008-secorsize-nodesize-combination/test.sh     |  2 +-
 ulist.c                                            |  2 +-
 utils-lib.c                                        |  2 +-
 utils.c                                            |  2 +-
 volumes.c                                          |  2 +-
 43 files changed, 95 insertions(+), 95 deletions(-)

diff --git a/CHANGES b/CHANGES
index 6186808..aa13d48 100644
--- a/CHANGES
+++ b/CHANGES
@@ -82,8 +82,8 @@ btrfs-progs-4.4 (2016-01-18)
     * check: fix a false alert where extent record has wrong metadata flag
     * improved stability on fuzzed/crafted images when reading sys array in
       superblock
-    * build: the 'ar' tool is properly deteced during cross-compilation
-    * debug-tree: option -t understands ids for tree root and chnuk tree
+    * build: the 'ar' tool is properly detected during cross-compilation
+    * debug-tree: option -t understands ids for tree root and chunk tree
     * preparatory work for btrfs-convert rewrite
     * sparse, gcc warning fixes
     * more memory allocation failure handling
@@ -131,7 +131,7 @@ btrfs-progs-4.3 (2015-11-06)
       subvolume
   * other:
     * check: add progress indicator
-    * scrub: enahced error message
+    * scrub: enhanced error message
     * show-super: read superblock from a given offset
     * add README
     * docs: update manual page for mkfs.btrfs, btrfstune, balance,
@@ -155,7 +155,7 @@ btrfs-progs-4.3 (2015-11-06)
 
 btrfs-progs-4.2.3 (2015-10-19)
   * subvol sync: make it actually work again: it's been broken since 4.1.2,
-    due to a reversed condition it returned immediatelly instead of waiting
+    due to a reversed condition it returned immediately instead of waiting
   * scanning: do not scan already discovered filesystems (minor optimization)
   * convert: better error message in case the filesystem is not finalized
   * restore: off-by-one symlink path check fix
@@ -226,7 +226,7 @@ btrfs-progs-4.1.1 (2015-07-10) -- Do not use this version!
     * documentation updates
     * debug-tree: print nbytes
     * test: image for corrupted nbytes
-    * corupt-block: let it kill nbytes
+    * corrupt-block: let it kill nbytes
 
 btrfs-progs-4.1 (2015-06-22)
   Bugfixes:
@@ -267,7 +267,7 @@ btrfs-progs-4.1 (2015-06-22)
     * debug tree: print key names according to their C name
 
   New:
-    * rescure zero-log
+    * rescue zero-log
     * btrfsune:
       * rewrite uuid on a filesystem image
       * new option to turn on NO_HOLES incompat feature
diff --git a/backref.c b/backref.c
index 9d48a10..7b3b592 100644
--- a/backref.c
+++ b/backref.c
@@ -1578,8 +1578,8 @@ static int inode_to_path(u64 inum, u32 name_len, unsigned long name_off,
  * is has been created large enough. each path is zero-terminated and accessed
  * from ipath->fspath->val[i].
  * when it returns, there are ipath->fspath->elem_cnt number of paths available
- * in ipath->fspath->val[]. when the allocated space wasn't sufficient, the
- * number of missed paths in recored in ipath->fspath->elem_missed, otherwise,
+ * in ipath->fspath->val[]. When the allocated space wasn't sufficient, the
+ * number of missed paths is recorded in ipath->fspath->elem_missed, otherwise,
  * it's zero. ipath->fspath->bytes_missing holds the number of bytes that would
  * have been needed to return all paths.
  */
diff --git a/btrfs-convert.c b/btrfs-convert.c
index b49775c..51ef53d 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2656,7 +2656,7 @@ fail:
 		close(fd);
 	if (is_btrfs)
 		fprintf(stderr,
-			"WARNING: an error occured during chunk mapping fixup, filesystem mountable but not finalized\n");
+			"WARNING: an error occurred during chunk mapping fixup, filesystem mountable but not finalized\n");
 	else
 		fprintf(stderr, "conversion aborted\n");
 	return -1;
@@ -2957,7 +2957,7 @@ next_extent:
 		ret = pwrite(fd, buf, sectorsize, bytenr);
 		if (ret != sectorsize) {
 			fprintf(stderr,
-				"error during zeroing supreblock %d: %d\n",
+				"error during zeroing superblock %d: %d\n",
 				i, ret);
 			goto fail;
 		}
diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 66d93e5..d331f96 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -719,7 +719,7 @@ static int corrupt_metadata_block(struct btrfs_root *root, u64 block,
 
 	root = btrfs_read_fs_root(root->fs_info, &root_key);
 	if (IS_ERR(root)) {
-		fprintf(stderr, "Couldn't finde owner root %llu\n",
+		fprintf(stderr, "Couldn't find owner root %llu\n",
 			key.objectid);
 		return PTR_ERR(root);
 	}
@@ -871,7 +871,7 @@ static int delete_csum(struct btrfs_root *root, u64 bytenr, u64 bytes)
 }
 
 /* corrupt item using NO cow.
- * Because chunk recover will recover based on whole partition scaning,
+ * Because chunk recover will recover based on whole partition scanning,
  * If using COW, chunk recover will use the old item to recover,
  * which is still OK but we want to check the ability to rebuild chunk
  * not only restore the old ones */
diff --git a/btrfs-debugfs b/btrfs-debugfs
index 08e3ec6..0a654a6 100755
--- a/btrfs-debugfs
+++ b/btrfs-debugfs
@@ -96,7 +96,7 @@ class btrfs_ioctl_search_args(ctypes.Structure):
                  ("buf", ctypes.c_ubyte * args_buffer_size),
                ]
 
-# the search ioctl resturns one header for each item
+# the search ioctl returns one header for each item
 #
 class btrfs_ioctl_search_header(ctypes.Structure):
     _pack_ = 1
diff --git a/btrfs-image.c b/btrfs-image.c
index 5c4c6fa..8a1b799 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -657,7 +657,7 @@ static void *dump_worker(void *data)
 			async->bufsize = compressBound(async->size);
 			async->buffer = malloc(async->bufsize);
 			if (!async->buffer) {
-				fprintf(stderr, "Error allocing buffer\n");
+				fprintf(stderr, "Error allocating buffer\n");
 				pthread_mutex_lock(&md->mutex);
 				if (!md->error)
 					md->error = -ENOMEM;
@@ -1324,7 +1324,7 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 	ret = metadump_init(&metadump, root, out, num_threads,
 			    compress_level, sanitize);
 	if (ret) {
-		fprintf(stderr, "Error initing metadump %d\n", ret);
+		fprintf(stderr, "Error initializing metadump %d\n", ret);
 		close_ctree(root);
 		return ret;
 	}
@@ -1339,7 +1339,7 @@ static int create_metadump(const char *input, FILE *out, int num_threads,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		fprintf(stderr, "Out of memory allocing path\n");
+		fprintf(stderr, "Out of memory allocating path\n");
 		err = -ENOMEM;
 		goto out;
 	}
@@ -1671,7 +1671,7 @@ static void *restore_worker(void *data)
 	outfd = fileno(mdres->out);
 	buffer = malloc(compress_size);
 	if (!buffer) {
-		fprintf(stderr, "Error allocing buffer\n");
+		fprintf(stderr, "Error allocating buffer\n");
 		pthread_mutex_lock(&mdres->mutex);
 		if (!mdres->error)
 			mdres->error = -ENOMEM;
@@ -1913,7 +1913,7 @@ static int add_cluster(struct meta_cluster *cluster,
 		async->bufsize = le32_to_cpu(item->size);
 		async->buffer = malloc(async->bufsize);
 		if (!async->buffer) {
-			fprintf(stderr, "Error allocing async buffer\n");
+			fprintf(stderr, "Error allocating async buffer\n");
 			free(async);
 			return -ENOMEM;
 		}
@@ -2038,7 +2038,7 @@ static int read_chunk_block(struct mdrestore_struct *mdres, u8 *buffer,
 
 		fs_chunk = malloc(sizeof(struct fs_chunk));
 		if (!fs_chunk) {
-			fprintf(stderr, "Erorr allocating chunk\n");
+			fprintf(stderr, "Error allocating chunk\n");
 			ret = -ENOMEM;
 			break;
 		}
@@ -2090,7 +2090,7 @@ static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
 
 	buffer = malloc(max_size);
 	if (!buffer) {
-		fprintf(stderr, "Error allocing buffer\n");
+		fprintf(stderr, "Error allocating buffer\n");
 		free(cluster);
 		return -ENOMEM;
 	}
@@ -2098,7 +2098,7 @@ static int search_for_chunk_blocks(struct mdrestore_struct *mdres,
 	if (mdres->compress_method == COMPRESS_ZLIB) {
 		tmp = malloc(max_size);
 		if (!tmp) {
-			fprintf(stderr, "Error allocing tmp buffer\n");
+			fprintf(stderr, "Error allocating tmp buffer\n");
 			free(cluster);
 			free(buffer);
 			return -ENOMEM;
@@ -2264,7 +2264,7 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 
 	buffer = malloc(le32_to_cpu(item->size));
 	if (!buffer) {
-		fprintf(stderr, "Error allocing buffer\n");
+		fprintf(stderr, "Error allocating buffer\n");
 		return -ENOMEM;
 	}
 
@@ -2360,7 +2360,7 @@ static int fixup_devices(struct btrfs_fs_info *fs_info,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		fprintf(stderr, "Error alloc'ing path\n");
+		fprintf(stderr, "Error allocating path\n");
 		return -ENOMEM;
 	}
 
@@ -2490,7 +2490,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 	ret = mdrestore_init(&mdrestore, in, out, old_restore, num_threads,
 			     fixup_offset, info, multi_devices);
 	if (ret) {
-		fprintf(stderr, "Error initing mdrestore %d\n", ret);
+		fprintf(stderr, "Error initializing mdrestore %d\n", ret);
 		goto failed_cluster;
 	}
 
diff --git a/btrfs-list.c b/btrfs-list.c
index 2da54bf..1c0e1bd 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -564,7 +564,7 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 		int add_len;
 
 		/*
-		 * ref_tree = 0 indicates the subvolumes
+		 * ref_tree = 0 indicates the subvolume
 		 * has been deleted.
 		 */
 		if (!found->ref_tree) {
@@ -678,7 +678,7 @@ static int lookup_ino_path(int fd, struct root_info *ri)
 }
 
 /* finding the generation for a given path is a two step process.
- * First we use the inode loookup routine to find out the root id
+ * First we use the inode lookup routine to find out the root id
  *
  * Then we use the tree search ioctl to scan all the root items for a
  * given root id and spit out the latest generation we can find
diff --git a/chunk-recover.c b/chunk-recover.c
index 4ad337b..085e9a2 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -247,7 +247,7 @@ again:
 					      generation);
 			/*
 			 * According to the current kernel code, the following
-			 * case is impossble, or there is something wrong in
+			 * case is impossible, or there is something wrong in
 			 * the kernel code.
 			 */
 			if (memcmp(((void *)exist) + offset,
@@ -618,7 +618,7 @@ static int check_chunk_by_metadata(struct recover_control *rc,
 		    btrfs_dev_extent_chunk_offset(l, dev_extent)) {
 			if (rc->verbose)
 				fprintf(stderr,
-					"Device tree unmatch with chunks dev_extent[%llu, %llu], chunk[%llu, %llu]\n",
+					"Device tree mismatch with chunks dev_extent[%llu, %llu], chunk[%llu, %llu]\n",
 					btrfs_dev_extent_chunk_offset(l,
 								dev_extent),
 					btrfs_dev_extent_length(l, dev_extent),
@@ -654,7 +654,7 @@ bg_check:
 	if (chunk->type_flags != btrfs_disk_block_group_flags(l, bg_ptr)) {
 		if (rc->verbose)
 			fprintf(stderr,
-				"Chunk[%llu, %llu]'s type(%llu) is differemt with Block Group's type(%llu)\n",
+				"Chunk[%llu, %llu]'s type(%llu) is different with Block Group's type(%llu)\n",
 				chunk->offset, chunk->length, chunk->type_flags,
 				btrfs_disk_block_group_flags(l, bg_ptr));
 		btrfs_release_path(&path);
diff --git a/cmds-balance.c b/cmds-balance.c
index 5f05f60..efd51d2 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -160,7 +160,7 @@ static int parse_range_strict(const char *range, u64 *start, u64 *end)
 }
 
 /*
- * Convert 64bit range to 32bit with boundary checkso
+ * Convert 64bit range to 32bit with boundary checks
  */
 static int range_to_u32(u64 start, u64 end, u32 *start32, u32 *end32)
 {
@@ -876,7 +876,7 @@ static int cmd_balance_full(int argc, char **argv)
 }
 
 static const char balance_cmd_group_info[] =
-"balance data accross devices, or change block groups using filters";
+"balance data across devices, or change block groups using filters";
 
 const struct cmd_group balance_cmd_group = {
 	balance_cmd_group_usage, balance_cmd_group_info, {
diff --git a/cmds-check.c b/cmds-check.c
index 127ac97..7c8419a 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -476,7 +476,7 @@ static int del_file_extent_hole(struct rb_root *holes,
 		return -EEXIST;
 
 	/*
-	 * Now there will be no overflap, delete the hole and re-add the
+	 * Now there will be no overlap, delete the hole and re-add the
 	 * split(s) if they exists.
 	 */
 	if (start > hole->start) {
@@ -746,9 +746,9 @@ static void print_ref_error(int errors)
 	if (errors & REF_ERR_DUP_INODE_REF)
 		fprintf(stderr, ", dup inode ref");
 	if (errors & REF_ERR_INDEX_UNMATCH)
-		fprintf(stderr, ", index unmatch");
+		fprintf(stderr, ", index mismatch");
 	if (errors & REF_ERR_FILETYPE_UNMATCH)
-		fprintf(stderr, ", filetype unmatch");
+		fprintf(stderr, ", filetype mismatch");
 	if (errors & REF_ERR_NAME_TOO_LONG)
 		fprintf(stderr, ", name too long");
 	if (errors & REF_ERR_NO_ROOT_REF)
@@ -2689,7 +2689,7 @@ static int repair_inode_no_item(struct btrfs_trans_handle *trans,
 			type_recovered = 1;
 			filetype = BTRFS_FT_REG_FILE;
 		} else{
-			printf("Can't determint the filetype for inode %llu, assume it is a normal file\n",
+			printf("Can't determine the filetype for inode %llu, assume it is a normal file\n",
 			       rec->ino);
 			type_recovered = 1;
 			filetype = BTRFS_FT_REG_FILE;
@@ -2892,7 +2892,7 @@ static int check_inode_recs(struct btrfs_root *root,
 	/*
 	 * We need to record the highest inode number for later 'lost+found'
 	 * dir creation.
-	 * We must select a ino not used/refered by any existing inode, or
+	 * We must select an ino not used/referred by any existing inode, or
 	 * 'lost+found' ino may be a missing ino in a corrupted leaf,
 	 * this may cause 'lost+found' dir has wrong nlinks.
 	 */
@@ -4323,7 +4323,7 @@ static int check_block(struct btrfs_root *root,
 		} else {
 			/*
 			 * Signal to callers we need to start the scan over
-			 * again since we'll have cow'ed blocks.
+			 * again since we'll have cowed blocks.
 			 */
 			ret = -EAGAIN;
 		}
@@ -5539,7 +5539,7 @@ static int check_space_cache(struct btrfs_root *root)
 
 		ret = verify_space_cache(root, cache);
 		if (ret) {
-			fprintf(stderr, "cache appears valid but isnt %Lu\n",
+			fprintf(stderr, "cache appears valid but isn't %Lu\n",
 				cache->key.objectid);
 			error++;
 		}
@@ -5629,7 +5629,7 @@ static int check_extent_exists(struct btrfs_root *root, u64 bytenr,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		fprintf(stderr, "Error allocing path\n");
+		fprintf(stderr, "Error allocating path\n");
 		return -ENOMEM;
 	}
 
@@ -5662,7 +5662,7 @@ again:
 
 	/*
 	 * Block group items come before extent items if they have the same
-	 * bytenr, so walk back one more just in case.  Dear future traveler,
+	 * bytenr, so walk back one more just in case.  Dear future traveller,
 	 * first congrats on mastering time travel.  Now if it's not too much
 	 * trouble could you go back to 2006 and tell Chris to make the
 	 * BLOCK_GROUP_ITEM_KEY (and BTRFS_*_REF_KEY) lower than the
@@ -5871,7 +5871,7 @@ static int is_dropped_key(struct btrfs_key *key,
  * 1) If BTRFS_HEADER_FLAG_RELOC is set then we have FULL_BACKREF set.
  * 2) If btrfs_header_owner(buf) no longer points to buf then we have
  *	FULL_BACKREF set.
- * 3) We cow'ed the block walking down a reloc tree.  This is impossible to tell
+ * 3) We cowed the block walking down a reloc tree.  This is impossible to tell
  *    if it happened after the relocation occurred since we'll have dropped the
  *    reloc root, so it's entirely possible to have FULL_BACKREF set on buf and
  *    have no real way to know for sure.
@@ -7063,7 +7063,7 @@ static int delete_duplicate_records(struct btrfs_root *root,
 
 		if (tmp->start + tmp->nr < good->start + good->nr) {
 			fprintf(stderr, "Ok we have overlapping extents that "
-				"aren't completely covered by eachother, this "
+				"aren't completely covered by each other, this "
 				"is going to require more careful thought.  "
 				"The extents are [%Lu-%Lu] and [%Lu-%Lu]\n",
 				tmp->start, tmp->nr, good->start, good->nr);
@@ -8797,7 +8797,7 @@ static int reinit_extent_tree(struct btrfs_trans_handle *trans,
 
 	ret = reset_balance(trans, fs_info);
 	if (ret)
-		fprintf(stderr, "error reseting the pending balance\n");
+		fprintf(stderr, "error resetting the pending balance\n");
 
 	return ret;
 }
@@ -9479,8 +9479,8 @@ out:
 
 const char * const cmd_check_usage[] = {
 	"btrfs check [options] <device>",
-	"Check structural inegrity of a filesystem (unmounted).",
-	"Check structural inegrity of an unmounted filesystem. Verify internal",
+	"Check structural integrity of a filesystem (unmounted).",
+	"Check structural integrity of an unmounted filesystem. Verify internal",
 	"trees' consistency and item connectivity. In the repair mode try to",
 	"fix the problems found.",
 	"WARNING: the repair mode is considered dangerous",
@@ -9491,7 +9491,7 @@ const char * const cmd_check_usage[] = {
 	"--readonly                  run in read-only mode (default)",
 	"--init-csum-tree            create a new CRC tree",
 	"--init-extent-tree          create a new extent tree",
-	"--check-data-csum           verify checkums of data blocks",
+	"--check-data-csum           verify checksums of data blocks",
 	"-Q|--qgroup-report           print a report on qgroup consistency",
 	"-E|--subvol-extents <subvolid>",
 	"                            print subvolume extents and sharing state",
diff --git a/cmds-fi-du.c b/cmds-fi-du.c
index 168fc72..0fda400 100644
--- a/cmds-fi-du.c
+++ b/cmds-fi-du.c
@@ -153,7 +153,7 @@ static u64 count_unique_bytes(struct rb_root *root, struct shared_extent *n)
 
 /*
  * What we want to do here is get a count of shared bytes within the
- * set of extents we have collected. Specifcally, we don't want to
+ * set of extents we have collected. Specifically, we don't want to
  * count any byte more than once, so just adding them up doesn't
  * work.
  *
diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 33bf403..24d384e 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -280,7 +280,7 @@ static struct btrfs_ioctl_space_args *load_space_info(int fd, char *path)
 }
 
 /*
- * This function computes the space occuped by a *single* RAID5/RAID6 chunk.
+ * This function computes the space occupied by a *single* RAID5/RAID6 chunk.
  * The computation is performed on the basis of the number of stripes
  * which compose the chunk, which could be different from the number of devices
  * if a disk is added later.
diff --git a/cmds-inspect-tree-stats.c b/cmds-inspect-tree-stats.c
index e80041d..c35f588 100644
--- a/cmds-inspect-tree-stats.c
+++ b/cmds-inspect-tree-stats.c
@@ -496,7 +496,7 @@ int cmd_inspect_tree_stats(int argc, char **argv)
 
 	key.objectid = BTRFS_FS_TREE_OBJECTID;
 	key.offset = (u64)-1;
-	printf("Calculatin' size of fs tree\n");
+	printf("Calculating size of fs tree\n");
 	ret = calc_root_size(root, &key, 1);
 	if (ret)
 		goto out;
diff --git a/cmds-inspect.c b/cmds-inspect.c
index abe4edf..cc807e0 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -415,7 +415,7 @@ static void adjust_dev_min_size(struct list_head *extents,
 	/*
 	 * List of device extents is sorted by descending order of the extent's
 	 * end offset. If some extent goes beyond the computed minimum size,
-	 * which initially matches the sum of the lenghts of all extents,
+	 * which initially matches the sum of the lengths of all extents,
 	 * we need to check if the extent can be relocated to an hole in the
 	 * device between [0, *min_size[ (which is what the resize ioctl does).
 	 */
diff --git a/cmds-receive.c b/cmds-receive.c
index cbb1642..f4a3a4f 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -644,7 +644,7 @@ static int open_inode_for_write(struct btrfs_receive *r, const char *path)
 	r->write_fd = open(path, O_RDWR);
 	if (r->write_fd < 0) {
 		ret = -errno;
-		error("cannont open %s: %s", path, strerror(-ret));
+		error("cannot open %s: %s", path, strerror(-ret));
 		goto out;
 	}
 	strncpy_null(r->write_path, path);
diff --git a/cmds-scrub.c b/cmds-scrub.c
index de7005c..4a1d475 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -430,7 +430,7 @@ static int scrub_rename_file(const char *fn_base, const char *fn_local,
 /*
  * returns 0 if the key did not match (nothing was read)
  *         1 if the key did match (success)
- *        -1 if the key did match and an error occured
+ *        -1 if the key did match and an error occurred
  */
 static int scrub_kvread(int *i, int len, int avail, const char *buf,
 			const char *key, u64 *dest)
diff --git a/cmds-send.c b/cmds-send.c
index 4063475..07070ad 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -617,7 +617,7 @@ int cmd_send(int argc, char **argv)
 			goto out;
 		if (!ret) {
 			ret = -EINVAL;
-			error("subvolum %s is not read-only", subvol);
+			error("subvolume %s is not read-only", subvol);
 			goto out;
 		}
 	}
diff --git a/ctree.c b/ctree.c
index c60f609..933833b 100644
--- a/ctree.c
+++ b/ctree.c
@@ -142,7 +142,7 @@ static int btrfs_block_can_be_shared(struct btrfs_root *root,
 			             struct extent_buffer *buf)
 {
 	/*
-	 * Tree blocks not in refernece counted trees and tree roots
+	 * Tree blocks not in reference counted trees and tree roots
 	 * are never shared. If a block was allocated after the last
 	 * snapshot and the block was not allocated by tree relocation,
 	 * we know the block is not shared.
diff --git a/ctree.h b/ctree.h
index 2db5c87..4e49af8 100644
--- a/ctree.h
+++ b/ctree.h
@@ -173,7 +173,7 @@ static int btrfs_csum_sizes[] = { 4 };
 
 /*
  * the key defines the order in the tree, and so it also defines (optimal)
- * block layout.  objectid corresonds to the inode number.  The flags
+ * block layout.  objectid corresponds to the inode number.  The flags
  * tells us things about the object, and is a kind of stream selector.
  * so for a given inode, keys with flags of 1 might refer to the inode
  * data, flags of 2 may point to file data in the btree and flags == 3
@@ -229,7 +229,7 @@ struct btrfs_dev_item {
 
 	/*
 	 * starting byte of this partition on the device,
-	 * to allowr for stripe alignment in the future
+	 * to allow for stripe alignment in the future
 	 */
 	__le64 start_offset;
 
@@ -746,7 +746,7 @@ struct btrfs_root_item {
 
 	/*
 	 * This generation number is used to test if the new fields are valid
-	 * and up to date while reading the root item. Everytime the root item
+	 * and up to date while reading the root item. Every time the root item
 	 * is written out, the "generation" field is copied into this field. If
 	 * anyone ever mounted the fs with an older kernel, we will have
 	 * mismatching generation values here and thus must invalidate the
diff --git a/dir-item.c b/dir-item.c
index bc59d17..c2ae953 100644
--- a/dir-item.c
+++ b/dir-item.c
@@ -86,7 +86,7 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 					name, name_len);
 	/*
 	 * FIXME: at some point we should handle xattr's that are larger than
-	 * what we can fit in our leaf.  We set location to NULL b/c we arent
+	 * what we can fit in our leaf.  We set location to NULL b/c we aren't
 	 * pointing at anything else, that will change if we store the xattr
 	 * data in a separate inode.
 	 */
diff --git a/disk-io.h b/disk-io.h
index b97b90b..d860ff2 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -48,8 +48,8 @@ enum btrfs_open_ctree_flags {
 					  OPEN_CTREE_SUPPRESS_CHECK_BLOCK_ERRORS +
 					  __OPEN_CTREE_RETURN_CHUNK_ROOT,
 	/*
-	 * TODO: cleanup: Split the open_ctree_flags into more indepent
-	 * tree bits.
+	 * TODO: cleanup: Split the open_ctree_flags into more independent
+	 * Tree bits.
 	 * Like split PARTIAL into SKIP_CSUM/SKIP_EXTENT
 	 */
 
diff --git a/extent-cache.h b/extent-cache.h
index f031fbf..82db7fa 100644
--- a/extent-cache.h
+++ b/extent-cache.h
@@ -53,7 +53,7 @@ struct cache_extent *next_cache_extent(struct cache_extent *pe);
 struct cache_extent *search_cache_extent(struct cache_tree *tree, u64 start);
 
 /*
- * Find a cahce_extent which restrictly covers start.
+ * Find a cache_extent which restrictly covers start.
  *
  * If not found, return NULL.
  */
diff --git a/file.c b/file.c
index 0e9253e..dd0b04b 100644
--- a/file.c
+++ b/file.c
@@ -52,7 +52,7 @@ int btrfs_get_extent(struct btrfs_trans_handle *trans,
 	if (ret <= 0)
 		goto out;
 	if (ret > 0) {
-		/* Check preivous file extent */
+		/* Check previous file extent */
 		ret = btrfs_previous_item(root, path, ino,
 					  BTRFS_EXTENT_DATA_KEY);
 		if (ret < 0)
@@ -111,7 +111,7 @@ check_next:
 		not_found = 1;
 
 	/*
-	 * To keep the search hehavior consistent with search_slot(),
+	 * To keep the search behavior consistent with search_slot(),
 	 * we need to go back to the prev leaf's nritem slot if
 	 * we are at the first slot of the leaf.
 	 */
diff --git a/inode.c b/inode.c
index be03a52..ed6d529 100644
--- a/inode.c
+++ b/inode.c
@@ -20,7 +20,7 @@
  * Unlike inode.c in kernel, which can use most of the kernel infrastructure
  * like inode/dentry things, in user-land, we can only use inode number to
  * do directly operation on extent buffer, which may cause extra searching,
- * but should not be a huge problem since progs is less performence sensitive.
+ * but should not be a huge problem since progs is less performance sensitive.
  */
 #include <sys/stat.h>
 
@@ -262,7 +262,7 @@ int btrfs_add_orphan_item(struct btrfs_trans_handle *trans,
  * dir_item if any of them exists.
  *
  * If an inode's nlink is reduced to 0 and 'add_orphan' is true, it will be
- * added to orphan inode and wairing to be deleted by next kernel mount.
+ * added to orphan inode and waiting to be deleted by next kernel mount.
  */
 int btrfs_unlink(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		 u64 ino, u64 parent_ino, u64 index, const char *name,
diff --git a/ioctl.h b/ioctl.h
index 7c80807..5f18bcb 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -109,7 +109,7 @@ struct btrfs_scrub_progress {
 	__u64 tree_bytes_scrubbed;	/* # of tree bytes scrubbed */
 	__u64 read_errors;		/* # of read errors encountered (EIO) */
 	__u64 csum_errors;		/* # of failed csum checks */
-	__u64 verify_errors;		/* # of occurences, where the metadata
+	__u64 verify_errors;		/* # of occurrences, where the metadata
 					 * of a tree block did not match the
 					 * expected values, like generation or
 					 * logical */
@@ -129,7 +129,7 @@ struct btrfs_scrub_progress {
 	__u64 last_physical;		/* last physical address scrubbed. In
 					 * case a scrub was aborted, this can
 					 * be used to restart the scrub */
-	__u64 unverified_errors;	/* # of occurences where a read for a
+	__u64 unverified_errors;	/* # of occurrences where a read for a
 					 * full (64k) bio failed, but the re-
 					 * check succeeded for each 4k piece.
 					 * Intermittent error. */
@@ -271,7 +271,7 @@ struct btrfs_balance_args {
 /* report balance progress to userspace */
 struct btrfs_balance_progress {
 	__u64 expected;		/* estimated # of chunks that will be
-				 * relocated to fulfill the request */
+				 * relocated to fulfil the request */
 	__u64 considered;	/* # of chunks we have considered so far */
 	__u64 completed;	/* # of chunks relocated so far */
 };
diff --git a/list_sort.c b/list_sort.c
index f526b40..9e2c202 100644
--- a/list_sort.c
+++ b/list_sort.c
@@ -1,5 +1,5 @@
 /*
- * taken from linux kernel lib/list_sort.c, removed uneeded code and adapted
+ * taken from linux kernel lib/list_sort.c, removed unneeded code and adapted
  * for btrfsprogs
  */
 
diff --git a/mkfs.c b/mkfs.c
index 5e79e0b..cce3308 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -88,7 +88,7 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 					BTRFS_BLOCK_GROUP_DATA);
 		if (ret == -ENOSPC) {
 			fprintf(stderr,
-				"no space to alloc data/metadata chunk\n");
+				"no space to allocate data/metadata chunk\n");
 			goto err;
 		}
 		BUG_ON(ret);
@@ -104,7 +104,7 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
 					&chunk_start, &chunk_size,
 					BTRFS_BLOCK_GROUP_METADATA);
 		if (ret == -ENOSPC) {
-			fprintf(stderr, "no space to alloc metadata chunk\n");
+			fprintf(stderr, "no space to allocate metadata chunk\n");
 			goto err;
 		}
 		BUG_ON(ret);
@@ -136,7 +136,7 @@ static int create_data_block_groups(struct btrfs_trans_handle *trans,
 					&chunk_start, &chunk_size,
 					BTRFS_BLOCK_GROUP_DATA);
 		if (ret == -ENOSPC) {
-			fprintf(stderr, "no space to alloc data chunk\n");
+			fprintf(stderr, "no space to allocate data chunk\n");
 			goto err;
 		}
 		BUG_ON(ret);
@@ -1205,7 +1205,7 @@ static int is_temp_block_group(struct extent_buffer *node,
 	 * 1) Empty chunk
 	 * Temp chunk is always empty.
 	 *
-	 * 2) profile dismatch with mkfs profile.
+	 * 2) profile mismatch with mkfs profile.
 	 * Temp chunk is always in SINGLE
 	 *
 	 * 3) Size differs with mkfs_alloc
@@ -1663,7 +1663,7 @@ int main(int argc, char **argv)
 	if (group_profile_max_safe_loss(metadata_profile) <
 		group_profile_max_safe_loss(data_profile)){
 		fprintf(stderr,
-			"WARNING: metatdata has lower redundancy than data!\n\n");
+			"WARNING: metadata has lower redundancy than data!\n\n");
 	}
 
 	mkfs_cfg.label = label;
@@ -1829,7 +1829,7 @@ raid_groups:
 			pretty_size(allocation.system));
 		printf("SSD detected:       %s\n", ssd ? "yes" : "no");
 		btrfs_parse_features_to_string(features_buf, features);
-		printf("Incompat features:  %s", features_buf);
+		printf("Incompatible features:  %s", features_buf); /* Leave this one alone? -- Nicholas D Steeves */
 		printf("\n");
 
 		list_all_devices(root);
diff --git a/send-utils.c b/send-utils.c
index 3c369b8..d7aa154 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -401,7 +401,7 @@ static struct subvol_info *tree_search(struct rb_root *root,
 }
 
 /*
- * this function will be only called if kernel dosen't support uuid tree.
+ * this function will be only called if kernel doesn't support uuid tree.
  */
 static struct subvol_info *subvol_uuid_search_old(struct subvol_uuid_search *s,
 				       u64 root_id, const u8 *uuid, u64 transid,
diff --git a/show-blocks b/show-blocks
index 0164be9..49e1770 100755
--- a/show-blocks
+++ b/show-blocks
@@ -224,7 +224,7 @@ elif options.input_file:
 shapeit(data)
 
 # try to drop out the least common data points by creating
-# a historgram of the sectors seen.
+# a histogram of the sectors seen.
 sectors = data[:,0]
 sizes = data[:,1]
 datalen = len(data)
@@ -237,7 +237,7 @@ bytes_per_cell = byte_range / total_cells
 
 f = figure(figsize=(8,6))
 
-# Throughput goes at the botoom
+# Throughput goes at the bottom
 a = subplot(1, 1, 1)
 subplots_adjust(right=0.7)
 datai = 0
diff --git a/super-recover.c b/super-recover.c
index e2c3129..88ecdee 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -316,7 +316,7 @@ int btrfs_recover_superblocks(const char *dname,
 		ret = 3;
 		goto no_recover;
 	}
-	/* reset super_bytenr in order that we will rewite all supers */
+	/* reset super_bytenr in order that we will rewrite all supers */
 	root->fs_info->super_bytenr = BTRFS_SUPER_INFO_OFFSET;
 	ret = write_all_supers(root);
 	if (!ret)
@@ -328,7 +328,7 @@ int btrfs_recover_superblocks(const char *dname,
 no_recover:
 	recover_err_str(ret);
 	free_recover_superblock(&recover);
-	/* check if we have freed fs_deivces in close_ctree() */
+	/* check if we have freed fs_devices in close_ctree() */
 	if (!root)
 		btrfs_close_devices(recover.fs_devices);
 	return ret;
diff --git a/tests/README.md b/tests/README.md
index be3bda8..9ab37fa 100644
--- a/tests/README.md
+++ b/tests/README.md
@@ -20,7 +20,7 @@ category, eg. `fsck-tests-results.txt`.
 
 ## Selective testing
 
-The test are prefixed by a number for ordering and uniquenes. To run a
+The test are prefixed by a number for ordering and uniqueness. To run a
 particular test use:
 
 ```shell
@@ -120,7 +120,7 @@ close to the purpose of your new test.
 * Use the highest unused number in the sequence, write a short descriptive title
 and join by dashes `-`.
 
-* Write a short description of the bug and how it's teste to the comment at the
+* Write a short description of the bug and how it's teste [ I don't know what to change this to -- Nicholas D Steeves ] to the comment at the
 begining of `test.sh`.
 
 * Write the test commands, comment anything that's not obvious.
diff --git a/tests/common b/tests/common
index 91682ef..8a626b6 100644
--- a/tests/common
+++ b/tests/common
@@ -90,7 +90,7 @@ run_mustfail()
 check_prereq()
 {
 	if ! [ -f $TOP/$1 ]; then
-		_fail "Failed prerequisities: $1";
+		_fail "Failed prerequisites: $1";
 	fi
 }
 
diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
index 2aab4ff..fb86163 100755
--- a/tests/fsck-tests.sh
+++ b/tests/fsck-tests.sh
@@ -18,7 +18,7 @@ source $TOP/tests/common
 # Allow child test to use $TOP and $RESULTS
 export TOP
 export RESULTS
-# For custom script needs to verfiy recovery
+# For custom script needs to verify recovery
 export LANG
 
 rm -f $RESULTS
diff --git a/tests/misc-tests.sh b/tests/misc-tests.sh
index 2a7f57c..0cf8c4b 100755
--- a/tests/misc-tests.sh
+++ b/tests/misc-tests.sh
@@ -16,7 +16,7 @@ source $TOP/tests/common
 # Allow child test to use $TOP and $RESULTS
 export TOP
 export RESULTS
-# For custom script needs to verfiy recovery
+# For custom script needs to verify recovery
 export LANG
 # For tests that only use a loop device
 export IMAGE
diff --git a/tests/misc-tests/007-subvolume-sync/test.sh b/tests/misc-tests/007-subvolume-sync/test.sh
index a745fb5..243bb8c 100755
--- a/tests/misc-tests/007-subvolume-sync/test.sh
+++ b/tests/misc-tests/007-subvolume-sync/test.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # test btrfs subvolume run normally with more than one subvolume
 #
-# - btrfs subvolume must not loop indefinetelly
+# - btrfs subvolume must not loop indefinitely
 # - btrfs subvolume return 0 in normal case
 
 source $TOP/tests/common
@@ -16,7 +16,7 @@ run_check $SUDO_HELPER $TOP/mkfs.btrfs -f "$TEST_DEV"
 run_check_mount_test_dev
 
 # to check following thing in both 1 and multiple subvolume case:
-# 1: is subvolume sync loop indefinetelly
+# 1: is subvolume sync loop indefinitely
 # 2: is return value right
 #
 run_check $SUDO_HELPER $TOP/btrfs subvolume create "$TEST_MNT"/mysubvol1
diff --git a/tests/misc-tests/009-subvolume-sync-must-wait/test.sh b/tests/misc-tests/009-subvolume-sync-must-wait/test.sh
index 056584e..fdc2d49 100755
--- a/tests/misc-tests/009-subvolume-sync-must-wait/test.sh
+++ b/tests/misc-tests/009-subvolume-sync-must-wait/test.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 #
-# Verify that subovolume sync waits until the subvolume is cleaned
+# Verify that subovolume [ should this really be subovolume? --Nicholas D Steeves ] sync waits until the subvolume is cleaned
 
 source $TOP/tests/common
 
diff --git a/tests/misc-tests/013-subvolume-sync-crash/test.sh b/tests/misc-tests/013-subvolume-sync-crash/test.sh
index c795526..0a5ac11 100755
--- a/tests/misc-tests/013-subvolume-sync-crash/test.sh
+++ b/tests/misc-tests/013-subvolume-sync-crash/test.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 #
-# Verify that subovolume sync waits until the subvolume is cleaned and does not
+# Verify that subovolume [ should this really be subovolume? --Nicholas D Steeves ] sync waits until the subvolume is cleaned and does not
 # crash at the end
 
 source $TOP/tests/common
diff --git a/tests/mkfs-tests.sh b/tests/mkfs-tests.sh
index c0635ad..363a865 100755
--- a/tests/mkfs-tests.sh
+++ b/tests/mkfs-tests.sh
@@ -16,7 +16,7 @@ source $TOP/tests/common
 # Allow child test to use $TOP and $RESULTS
 export TOP
 export RESULTS
-# For custom script needs to verfiy recovery
+# For custom script needs to verify recovery
 export LANG
 # For tests that only use a loop device
 export IMAGE
diff --git a/tests/mkfs-tests/008-secorsize-nodesize-combination/test.sh b/tests/mkfs-tests/008-secorsize-nodesize-combination/test.sh
index 79cc2b2..151e7b7 100755
--- a/tests/mkfs-tests/008-secorsize-nodesize-combination/test.sh
+++ b/tests/mkfs-tests/008-secorsize-nodesize-combination/test.sh
@@ -34,7 +34,7 @@ do_test 8191 8191 && _fail
 # Invalid: Aligned sectorsize with unaligned nodesize
 do_test 4k 16385 && _fail
 
-# Invalid: Ungliend sectorsize with aligned nodesize
+# Invalid: Unaligned sectorsize with aligned nodesize
 do_test 8191 16k && _fail
 
 # Valid: Aligned sectorsize and nodesize
diff --git a/ulist.c b/ulist.c
index 60fdc09..c5eca45 100644
--- a/ulist.c
+++ b/ulist.c
@@ -30,7 +30,7 @@
  * }
  * ulist_free(ulist);
  *
- * This assumes the graph nodes are adressable by u64. This stems from the
+ * This assumes the graph nodes are addressable by u64. This stems from the
  * usage for tree enumeration in btrfs, where the logical addresses are
  * 64 bit.
  *
diff --git a/utils-lib.c b/utils-lib.c
index 79ef35e..6585020 100644
--- a/utils-lib.c
+++ b/utils-lib.c
@@ -24,7 +24,7 @@ u64 arg_strtou64(const char *str)
 	}
 
 	/*
-	 * if we pass a negative number to strtoull, it will return an
+	 * if we pass a negative number to strtoull [is strtoull correct? -- Nicholas D Steeves], it will return an
 	 * unexpected number to us, so let's do the check ourselves.
 	 */
 	if (str[0] == '-') {
diff --git a/utils.c b/utils.c
index 7e45702..2af10c4 100644
--- a/utils.c
+++ b/utils.c
@@ -1455,7 +1455,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 			return ret;
 	}
 
-	/* iterate over the list of currently mountes filesystems */
+	/* iterate over the list of currently mounted filesystems */
 	if ((f = setmntent ("/proc/self/mounts", "r")) == NULL)
 		return -errno;
 
diff --git a/volumes.c b/volumes.c
index 4d22db2..ae85844 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1587,7 +1587,7 @@ static struct btrfs_device *fill_missing_device(u64 devid)
 }
 
 /*
- * Slot is used to verfy the chunk item is valid
+ * Slot is used to verify the chunk item is valid
  *
  * For sys chunk in superblock, pass -1 to indicate sys chunk.
  */
-- 
2.1.4

