Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11003 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760946AbbBIUD6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:03:58 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 13/16] Btrfs-progs: make restore update dev items
Date: Mon, 9 Feb 2015 15:03:16 -0500
Message-ID: <1423512199-16552-14-git-send-email-jbacik@fb.com>
In-Reply-To: <1423512199-16552-1-git-send-email-jbacik@fb.com>
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we restore a multi disk image onto a single disk we need to update the dev
items used and total bytes so that fsck doesn't freak out and that we get normal
results from stuff like btrfs fi show.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 btrfs-image.c | 150 ++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 131 insertions(+), 19 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index feb4a62..3c78388 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -133,6 +133,7 @@ struct mdrestore_struct {
 	size_t num_items;
 	u32 leafsize;
 	u64 devid;
+	u64 alloced_chunks;
 	u64 last_physical_offset;
 	u8 uuid[BTRFS_UUID_SIZE];
 	u8 fsid[BTRFS_FSID_SIZE];
@@ -1856,6 +1857,7 @@ static int mdrestore_init(struct mdrestore_struct *mdres,
 	mdres->multi_devices = multi_devices;
 	mdres->clear_space_cache = 0;
 	mdres->last_physical_offset = 0;
+	mdres->alloced_chunks = 0;
 
 	if (!num_threads)
 		return 0;
@@ -2087,6 +2089,7 @@ static int read_chunk_block(struct mdrestore_struct *mdres, u8 *buffer,
 		    mdres->last_physical_offset)
 			mdres->last_physical_offset = fs_chunk->physical +
 				fs_chunk->bytes;
+		mdres->alloced_chunks += fs_chunk->bytes;
 		tree_insert(&mdres->chunk_tree, &fs_chunk->l, chunk_cmp);
 	}
 out:
@@ -2372,9 +2375,107 @@ static void remap_overlapping_chunks(struct mdrestore_struct *mdres)
 	}
 }
 
-static int __restore_metadump(const char *input, FILE *out, int old_restore,
-			      int num_threads, int fixup_offset,
-			      const char *target, int multi_devices)
+static int fixup_devices(struct btrfs_fs_info *fs_info,
+			 struct mdrestore_struct *mdres, off_t dev_size)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_dev_item *dev_item;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_root *root = fs_info->chunk_root;
+	struct btrfs_key key;
+	u64 devid, cur_devid;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		fprintf(stderr, "Error alloc'ing path\n");
+		return -ENOMEM;
+	}
+
+	trans = btrfs_start_transaction(fs_info->tree_root, 1);
+	if (IS_ERR(trans)) {
+		fprintf(stderr, "Error starting transaction %ld\n",
+			PTR_ERR(trans));
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
+
+	dev_item = &fs_info->super_copy->dev_item;
+
+	devid = btrfs_stack_device_id(dev_item);
+
+	btrfs_set_stack_device_total_bytes(dev_item, dev_size);
+	btrfs_set_stack_device_bytes_used(dev_item, mdres->alloced_chunks);
+
+	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
+	key.type = BTRFS_DEV_ITEM_KEY;
+	key.offset = 0;
+
+again:
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret < 0) {
+		fprintf(stderr, "search failed %d\n", ret);
+		exit(1);
+	}
+
+	while (1) {
+		leaf = path->nodes[0];
+		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret < 0) {
+				fprintf(stderr, "Error going to next leaf "
+					"%d\n", ret);
+				exit(1);
+			}
+			if (ret > 0) {
+				ret = 0;
+				break;
+			}
+			leaf = path->nodes[0];
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		if (key.type > BTRFS_DEV_ITEM_KEY)
+			break;
+		if (key.type != BTRFS_DEV_ITEM_KEY) {
+			path->slots[0]++;
+			continue;
+		}
+
+		dev_item = btrfs_item_ptr(leaf, path->slots[0],
+					  struct btrfs_dev_item);
+		cur_devid = btrfs_device_id(leaf, dev_item);
+		if (devid != cur_devid) {
+			ret = btrfs_del_item(trans, root, path);
+			if (ret) {
+				fprintf(stderr, "Error deleting item %d\n",
+					ret);
+				exit(1);
+			}
+			btrfs_release_path(path);
+			goto again;
+		}
+
+		btrfs_set_device_total_bytes(leaf, dev_item, dev_size);
+		btrfs_set_device_bytes_used(leaf, dev_item,
+					    mdres->alloced_chunks);
+		btrfs_mark_buffer_dirty(leaf);
+		path->slots[0]++;
+	}
+
+	btrfs_free_path(path);
+	ret = btrfs_commit_transaction(trans, fs_info->tree_root);
+	if (ret) {
+		fprintf(stderr, "Commit failed %d\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int restore_metadump(const char *input, FILE *out, int old_restore,
+			    int num_threads, int fixup_offset,
+			    const char *target, int multi_devices)
 {
 	struct meta_cluster *cluster = NULL;
 	struct meta_cluster_header *header;
@@ -2454,6 +2555,30 @@ static int __restore_metadump(const char *input, FILE *out, int old_restore,
 		}
 	}
 	ret = wait_for_worker(&mdrestore);
+
+	if (!ret && !multi_devices && !old_restore) {
+		struct stat st;
+
+		info = open_ctree_fs_info(target, 0, 0,
+					  OPEN_CTREE_PARTIAL |
+					  OPEN_CTREE_WRITES);
+		if (!info) {
+			fprintf(stderr, "unable to open %s\n", target);
+			ret = -EIO;
+			goto out;
+		}
+
+		if (stat(target, &st)) {
+			fprintf(stderr, "statting %s failed\n", target);
+			close_ctree(info->chunk_root);
+			return 1;
+		}
+
+		ret = fixup_devices(info, &mdrestore, st.st_size);
+		close_ctree(info->chunk_root);
+		if (ret)
+			goto out;
+	}
 out:
 	mdrestore_destroy(&mdrestore, num_threads);
 failed_cluster:
@@ -2467,19 +2592,6 @@ failed_open:
 	return ret;
 }
 
-static int restore_metadump(const char *input, FILE *out, int old_restore,
-			    int num_threads, int multi_devices)
-{
-	return __restore_metadump(input, out, old_restore, num_threads, 0, NULL,
-				  multi_devices);
-}
-
-static int fixup_metadump(const char *input, FILE *out, int num_threads,
-			  const char *target)
-{
-	return __restore_metadump(input, out, 0, num_threads, 1, target, 1);
-}
-
 static int update_disk_super_on_device(struct btrfs_fs_info *info,
 				       const char *other_dev, u64 cur_devid)
 {
@@ -2705,7 +2817,7 @@ int main(int argc, char *argv[])
 				      compress_level, sanitize, walk_trees);
 	} else {
 		ret = restore_metadump(source, out, old_restore, num_threads,
-				       multi_devices);
+				       0, target, multi_devices);
 	}
 	if (ret) {
 		printk("%s failed (%s)\n", (create) ? "create" : "restore",
@@ -2752,14 +2864,14 @@ int main(int argc, char *argv[])
 		close_ctree(info->chunk_root);
 
 		/* fix metadata block to map correct chunk */
-		ret = fixup_metadump(source, out, 1, target);
+		ret = restore_metadump(source, out, 0, num_threads, 1,
+				       target, 1);
 		if (ret) {
 			fprintf(stderr, "fix metadump failed (error=%d)\n",
 				ret);
 			exit(1);
 		}
 	}
-
 out:
 	if (out == stdout) {
 		fflush(out);
-- 
1.8.3.1

