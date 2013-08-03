Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482Ab3HCAwp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Aug 2013 20:52:45 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r730qjGD018898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 2 Aug 2013 20:52:45 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r730qiSh011835
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 2 Aug 2013 20:52:44 -0400
Message-ID: <51FC545B.2010808@redhat.com>
Date: Fri, 02 Aug 2013 19:52:43 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs-progs: drop unused parameter from btrfs_release_path
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Port of commit b3b4aa7 to userspace.

parameter tree root it's not used since commit
5f39d397dfbe140a14edecd4e73c34ce23c4f9ee ("Btrfs: Create extent_buffer
interface for large blocksizes")

This gets userspace a tad closer to kernelspace by removing
this unused parameter that was all over the codebase...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(note, this is against kdave's integration tree)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index c500ddd..a9ac9a5 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -436,7 +436,7 @@ static int record_file_extent(struct btrfs_trans_handle *trans,
 	nbytes = btrfs_stack_inode_nbytes(inode) + num_bytes;
 	btrfs_set_stack_inode_nbytes(inode, nbytes);
 
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 
 	ins_key.objectid = disk_bytenr;
 	ins_key.offset = num_bytes;
@@ -471,7 +471,7 @@ static int record_file_extent(struct btrfs_trans_handle *trans,
 		goto fail;
 	ret = 0;
 fail:
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -1362,7 +1362,7 @@ next:
 		if (ret)
 			goto fail;
 		last_byte = bytenr + num_bytes;
-		btrfs_release_path(extent_root, &path);
+		btrfs_release_path(&path);
 
 		if (trans->blocks_used >= 4096) {
 			ret = btrfs_commit_transaction(trans, root);
@@ -1371,7 +1371,7 @@ next:
 			BUG_ON(!trans);
 		}
 	}
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	if (total_bytes > last_byte) {
 		ret = create_image_file_range(trans, root, objectid,
 					      &btrfs_inode, last_byte,
@@ -1410,11 +1410,11 @@ next:
 	btrfs_set_inode_size(leaf, inode_item, strlen(name) * 2 +
 			     btrfs_inode_size(leaf, inode_item));
 	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	ret = btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
 fail:
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -1451,7 +1451,7 @@ struct btrfs_root *link_subvol(struct btrfs_root *root, const char *base,
 		if (key.objectid == dirid && key.type == BTRFS_DIR_INDEX_KEY)
 			index = key.offset + 1;
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(!trans);
@@ -1484,7 +1484,7 @@ struct btrfs_root *link_subvol(struct btrfs_root *root, const char *base,
 	btrfs_set_inode_size(leaf, inode_item, strlen(buf) * 2 +
 			     btrfs_inode_size(leaf, inode_item));
 	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	/* add the backref first */
 	ret = btrfs_add_root_ref(trans, tree_root, root_objectid,
@@ -1549,7 +1549,7 @@ static int create_chunk_mapping(struct btrfs_trans_handle *trans,
 	ret = btrfs_del_item(trans, device->dev_root, &path);
 	if (ret)
 		goto err;
-	btrfs_release_path(device->dev_root, &path);
+	btrfs_release_path(&path);
 
 	/* delete chunk item created by make_btrfs */
 	key.objectid = chunk_objectid;
@@ -1563,7 +1563,7 @@ static int create_chunk_mapping(struct btrfs_trans_handle *trans,
 	ret = btrfs_del_item(trans, chunk_root, &path);
 	if (ret)
 		goto err;
-	btrfs_release_path(chunk_root, &path);
+	btrfs_release_path(&path);
 
 	/* for each block group, create device extent and chunk item */
 	cur_start = 0;
@@ -1595,7 +1595,7 @@ static int create_chunk_mapping(struct btrfs_trans_handle *trans,
 		    (unsigned long)btrfs_dev_extent_chunk_tree_uuid(extent),
 		    BTRFS_UUID_SIZE);
 		btrfs_mark_buffer_dirty(leaf);
-		btrfs_release_path(device->dev_root, &path);
+		btrfs_release_path(&path);
 
 		/* insert chunk item */
 		btrfs_set_stack_chunk_length(&chunk, cache->key.offset);
@@ -1628,7 +1628,7 @@ static int create_chunk_mapping(struct btrfs_trans_handle *trans,
 	device->bytes_used = total_bytes;
 	ret = btrfs_update_device(trans, device);
 err:
-	btrfs_release_path(device->dev_root, &path);
+	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -1897,7 +1897,7 @@ static int relocate_one_reference(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto fail;
 
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 
 	key.objectid = extent_key->objectid;
 	key.offset = 0;
@@ -1909,7 +1909,7 @@ static int relocate_one_reference(struct btrfs_trans_handle *trans,
 	leaf = path.nodes[0];
 	ptr = btrfs_item_ptr_offset(leaf, path.slots[0]);
 	read_extent_buffer(leaf, &inode, ptr, sizeof(inode));
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 
 	BUG_ON(num_bytes & (sectorsize - 1));
 	nbytes = btrfs_stack_inode_nbytes(&inode) - num_bytes;
@@ -1989,10 +1989,10 @@ static int relocate_one_reference(struct btrfs_trans_handle *trans,
 	ptr = btrfs_item_ptr_offset(leaf, path.slots[0]);
 	write_extent_buffer(leaf, &inode, ptr, sizeof(inode));
 	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 
 fail:
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -2042,7 +2042,7 @@ static int relocate_extents_range(struct btrfs_root *fs_root,
 				start_byte = key.objectid;
 		}
 	}
-	btrfs_release_path(extent_root, &path);
+	btrfs_release_path(&path);
 again:
 	cur_root = (pass % 2 == 0) ? ext2_root : fs_root;
 	num_extents = 0;
@@ -2124,7 +2124,7 @@ next:
 			goto fail;
 
 		cur_byte += num_bytes;
-		btrfs_release_path(extent_root, &path);
+		btrfs_release_path(&path);
 
 		if (trans->blocks_used >= 4096) {
 			ret = btrfs_commit_transaction(trans, cur_root);
@@ -2133,7 +2133,7 @@ next:
 			BUG_ON(!trans);
 		}
 	}
-	btrfs_release_path(cur_root, &path);
+	btrfs_release_path(&path);
 
 	ret = btrfs_commit_transaction(trans, cur_root);
 	BUG_ON(ret);
@@ -2143,7 +2143,7 @@ next:
 
 	ret = (num_extents > 0) ? -1 : 0;
 fail:
-	btrfs_release_path(cur_root, &path);
+	btrfs_release_path(&path);
 	extent_io_tree_cleanup(&reloc_tree);
 	return ret;
 }
@@ -2224,9 +2224,9 @@ static int fixup_chunk_mapping(struct btrfs_root *root)
 			break;
 
 		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
-		btrfs_release_path(chunk_root, &path);
+		btrfs_release_path(&path);
 	}
-	btrfs_release_path(chunk_root, &path);
+	btrfs_release_path(&path);
 
 	/* fixup the system chunk array in super block */
 	btrfs_set_super_sys_array_size(info->super_copy, 0);
@@ -2273,7 +2273,7 @@ next:
 	ret = btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
 err:
-	btrfs_release_path(chunk_root, &path);
+	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -2535,7 +2535,7 @@ int do_rollback(const char *devname, int force)
 	}
 	leaf = path.nodes[0];
 	btrfs_dir_item_key_to_cpu(leaf, dir, &key);
-	btrfs_release_path(ext2_root, &path);
+	btrfs_release_path(&path);
 
 	objectid = key.objectid;
 
@@ -2547,7 +2547,7 @@ int do_rollback(const char *devname, int force)
 	leaf = path.nodes[0];
 	inode = btrfs_item_ptr(leaf, path.slots[0], struct btrfs_inode_item);
 	total_bytes = btrfs_inode_size(leaf, inode);
-	btrfs_release_path(ext2_root, &path);
+	btrfs_release_path(&path);
 
 	key.objectid = objectid;
 	key.offset = 0;
@@ -2555,7 +2555,7 @@ int do_rollback(const char *devname, int force)
 	ret = btrfs_search_slot(NULL, ext2_root, &key, &path, 0, 0);
 	if (ret != 0) {
 		fprintf(stderr, "unable to find first file extent\n");
-		btrfs_release_path(ext2_root, &path);
+		btrfs_release_path(&path);
 		goto fail;
 	}
 
@@ -2606,7 +2606,7 @@ next_extent:
 		offset += btrfs_file_extent_num_bytes(leaf, fi);
 		path.slots[0]++;
 	}
-	btrfs_release_path(ext2_root, &path);
+	btrfs_release_path(&path);
 
 	if (offset < total_bytes) {
 		fprintf(stderr, "unable to build extent mapping\n");
@@ -2640,9 +2640,9 @@ next_extent:
 			break;
 
 		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
-		btrfs_release_path(chunk_root, &path);
+		btrfs_release_path(&path);
 	}
-	btrfs_release_path(chunk_root, &path);
+	btrfs_release_path(&path);
 
 	offset = 0;
 	num_bytes = 0;
diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 8176fad..4a50802 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -211,7 +211,7 @@ static int corrupt_extent(struct btrfs_trans_handle *trans,
 			btrfs_mark_buffer_dirty(leaf);
 		}
 next:
-		btrfs_release_path(NULL, path);
+		btrfs_release_path(path);
 
 		if (key.offset > 0)
 			key.offset--;
diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index bdd4022..078dac5 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -374,7 +374,7 @@ next:
 		path.slots[0]++;
 	}
 no_node:
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 
 	if (tree_root_scan == info->tree_root &&
 	    info->log_root_tree) {
diff --git a/btrfs-image.c b/btrfs-image.c
index 634a714..21ce84f 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1114,7 +1114,7 @@ static int copy_space_cache(struct btrfs_root *root,
 		if (ret) {
 			fprintf(stderr, "Error adding space cache blocks %d\n",
 				ret);
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			return ret;
 		}
 		path->slots[0]++;
@@ -1219,7 +1219,7 @@ static int copy_from_extent_tree(struct metadump_struct *metadump,
 		bytenr += num_bytes;
 	}
 
-	btrfs_release_path(extent_root, path);
+	btrfs_release_path(path);
 
 	return ret;
 }
@@ -2366,7 +2366,7 @@ static int update_disk_super_on_device(struct btrfs_fs_info *info,
 	read_extent_buffer(leaf, dev_uuid, (unsigned long)btrfs_device_uuid(dev_item), BTRFS_UUID_SIZE);
 	read_extent_buffer(leaf, fs_uuid, (unsigned long)btrfs_device_fsid(dev_item), BTRFS_UUID_SIZE);
 
-	btrfs_release_path(info->chunk_root, &path);
+	btrfs_release_path(&path);
 
 	printk("update disk super on %s devid=%llu\n", other_dev, devid);
 
diff --git a/cmds-check.c b/cmds-check.c
index 5349d4b..aa416f9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -410,7 +410,7 @@ static int check_orphan_item(struct btrfs_root *root, u64 ino)
 
 	btrfs_init_path(&path);
 	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	if (ret > 0)
 		ret = -ENOENT;
 	return ret;
@@ -794,7 +794,7 @@ static int is_child_root(struct btrfs_root *root, u64 parent_root_id,
 	ret = btrfs_search_slot(NULL, root->fs_info->tree_root, &key, &path,
 				0, 0);
 	BUG_ON(ret < 0);
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	if (!ret)
 		return 1;
 
@@ -824,14 +824,14 @@ static int is_child_root(struct btrfs_root *root, u64 parent_root_id,
 		has_parent = 1;
 
 		if (key.offset == parent_root_id) {
-			btrfs_release_path(root, &path);
+			btrfs_release_path(&path);
 			return 1;
 		}
 
 		path.slots[0]++;
 	}
 
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	return has_parent? 0 : -1;
 }
 
@@ -1045,7 +1045,7 @@ static u64 count_csum_range(struct btrfs_root *root, u64 start, u64 len)
 
 		path.slots[0]++;
 	}
-	btrfs_release_path(root->fs_info->csum_root, &path);
+	btrfs_release_path(&path);
 	return found;
 }
 
@@ -1801,7 +1801,7 @@ static int check_fs_root(struct btrfs_root *root,
 		if (wret != 0)
 			break;
 	}
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 
 	merge_root_recs(root, &root_node.root_cache, root_cache);
 
@@ -1876,7 +1876,7 @@ static int check_fs_roots(struct btrfs_root *root,
 next:
 		path.slots[0]++;
 	}
-	btrfs_release_path(tree_root, &path);
+	btrfs_release_path(&path);
 
 	if (!cache_tree_empty(&wc.shared))
 		fprintf(stderr, "warning line %d\n", __LINE__);
@@ -2096,7 +2096,7 @@ static int check_owner_ref(struct btrfs_root *root,
 							path.slots[level + 1]))
 		found = 1;
 
-	btrfs_release_path(ref_root, &path);
+	btrfs_release_path(&path);
 	return found ? 0 : 1;
 }
 
@@ -3357,7 +3357,7 @@ again:
 				 * in real life, but no harm in coding it up
 				 * anyway just in case.
 				 */
-				btrfs_release_path(root, path);
+				btrfs_release_path(path);
 				ret = check_extent_exists(root, new_start,
 							  new_bytes);
 				if (ret) {
@@ -3838,7 +3838,7 @@ static int delete_extent_records(struct btrfs_trans_handle *trans,
 		    found_key.type != BTRFS_EXTENT_REF_V0_KEY &&
 		    found_key.type != BTRFS_SHARED_BLOCK_REF_KEY &&
 		    found_key.type != BTRFS_SHARED_DATA_REF_KEY) {
-			btrfs_release_path(NULL, path);
+			btrfs_release_path(path);
 			if (found_key.type == 0) {
 				if (found_key.offset == 0)
 					break;
@@ -3856,7 +3856,7 @@ static int delete_extent_records(struct btrfs_trans_handle *trans,
 		ret = btrfs_del_item(trans, root->fs_info->extent_root, path);
 		if (ret)
 			break;
-		btrfs_release_path(NULL, path);
+		btrfs_release_path(path);
 
 		if (found_key.type == BTRFS_EXTENT_ITEM_KEY ||
 		    found_key.type == BTRFS_METADATA_ITEM_KEY) {
@@ -3870,7 +3870,7 @@ static int delete_extent_records(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	btrfs_release_path(NULL, path);
+	btrfs_release_path(path);
 	return ret;
 }
 
@@ -3945,7 +3945,7 @@ static int record_extent(struct btrfs_trans_handle *trans,
 					       rec->max_size, 1, 0);
 		if (ret)
 			goto fail;
-		btrfs_release_path(NULL, path);
+		btrfs_release_path(path);
 	}
 
 	if (back->is_data) {
@@ -4006,7 +4006,7 @@ static int record_extent(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto fail;
 fail:
-	btrfs_release_path(NULL, path);
+	btrfs_release_path(path);
 	return ret;
 }
 
@@ -4123,7 +4123,7 @@ static int repair_ref(struct btrfs_trans_handle *trans,
 		path->slots[0]++;
 	}
 
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	/*
 	 * Have to make sure that this root gets updated when we commit the
@@ -4213,7 +4213,7 @@ static int repair_ref(struct btrfs_trans_handle *trans,
 	else
 		printf("ram bytes may be wrong?\n");
 	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	return 0;
 }
 
@@ -4517,7 +4517,7 @@ static int delete_duplicate_records(struct btrfs_trans_handle *trans,
 		ret = btrfs_del_item(trans, root, path);
 		if (ret)
 			goto out;
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		nr_del++;
 	}
 
@@ -4669,7 +4669,7 @@ again:
 		goto out;
 	} else {
 		level++;
-		btrfs_release_path(NULL, &path);
+		btrfs_release_path(&path);
 		goto again;
 	}
 
@@ -4678,7 +4678,7 @@ del_ptr:
 	ret = btrfs_del_ptr(trans, info->extent_root, &path, level, slot);
 
 out:
-	btrfs_release_path(NULL, &path);
+	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -4725,7 +4725,7 @@ static int check_block_group(struct btrfs_trans_handle *trans,
 	btrfs_init_path(&path);
 	ret = btrfs_search_slot(NULL, info->extent_root,
 				&key, &path, 0, 0);
-	btrfs_release_path(NULL, &path);
+	btrfs_release_path(&path);
 	if (ret <= 0)
 		goto out;
 
@@ -5274,7 +5274,7 @@ again:
 		}
 		path.slots[0]++;
 	}
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	while(1) {
 		ret = run_next_block(root, bits, bits_nr, &last, &pending,
 				     &seen, &reada, &nodes, &extent_cache,
@@ -5558,7 +5558,7 @@ static int reset_balance(struct btrfs_trans_handle *trans,
 	ret = btrfs_del_item(trans, root, path);
 	if (ret)
 		goto out;
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	key.objectid = BTRFS_TREE_RELOC_OBJECTID;
 	key.type = BTRFS_ROOT_ITEM_KEY;
@@ -5580,7 +5580,7 @@ static int reset_balance(struct btrfs_trans_handle *trans,
 					goto out;
 			}
 			key.offset++;
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 
 			found = 0;
 			ret = btrfs_search_slot(trans, root, &key, path,
@@ -5612,7 +5612,7 @@ static int reset_balance(struct btrfs_trans_handle *trans,
 		if (ret)
 			goto out;
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	key.objectid = BTRFS_DATA_RELOC_TREE_OBJECTID;
 	key.type = BTRFS_ROOT_ITEM_KEY;
diff --git a/cmds-chunk.c b/cmds-chunk.c
index 03314de..c20234b 100644
--- a/cmds-chunk.c
+++ b/cmds-chunk.c
@@ -582,14 +582,14 @@ static int check_chunk_by_metadata(struct recover_control *rc,
 		if (ret < 0) {
 			fprintf(stderr, "Search device extent failed(%d)\n",
 				ret);
-			btrfs_release_path(root, &path);
+			btrfs_release_path(&path);
 			return ret;
 		} else if (ret > 0) {
 			if (rc->verbose)
 				fprintf(stderr,
 					"No device extent[%llu, %llu]\n",
 					stripe->devid, stripe->offset);
-			btrfs_release_path(root, &path);
+			btrfs_release_path(&path);
 			return -ENOENT;
 		}
 		l = path.nodes[0];
@@ -604,10 +604,10 @@ static int check_chunk_by_metadata(struct recover_control *rc,
 								dev_extent),
 					btrfs_dev_extent_length(l, dev_extent),
 					chunk->offset, chunk->length);
-			btrfs_release_path(root, &path);
+			btrfs_release_path(&path);
 			return -ENOENT;
 		}
-		btrfs_release_path(root, &path);
+		btrfs_release_path(&path);
 	}
 
 bg_check:
@@ -619,13 +619,13 @@ bg_check:
 				0, 0);
 	if (ret < 0) {
 		fprintf(stderr, "Search block group failed(%d)\n", ret);
-		btrfs_release_path(root, &path);
+		btrfs_release_path(&path);
 		return ret;
 	} else if (ret > 0) {
 		if (rc->verbose)
 			fprintf(stderr, "No block group[%llu, %llu]\n",
 				key.objectid, key.offset);
-		btrfs_release_path(root, &path);
+		btrfs_release_path(&path);
 		return -ENOENT;
 	}
 
@@ -638,10 +638,10 @@ bg_check:
 				"Chunk[%llu, %llu]'s type(%llu) is differemt with Block Group's type(%llu)\n",
 				chunk->offset, chunk->length, chunk->type_flags,
 				btrfs_disk_block_group_flags(l, bg_ptr));
-		btrfs_release_path(root, &path);
+		btrfs_release_path(&path);
 		return -ENOENT;
 	}
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	return 0;
 }
 
@@ -915,7 +915,7 @@ again:
 		btrfs_item_key_to_cpu(leaf, &key, 0);
 		if (key.objectid >= end)
 			goto err;
-		btrfs_release_path(root, &path);
+		btrfs_release_path(&path);
 		goto again;
 	}
 
@@ -960,11 +960,11 @@ again:
 			key.type = BTRFS_EXTENT_ITEM_KEY;
 			key.offset = 0;
 		}
-		btrfs_release_path(root, &path);
+		btrfs_release_path(&path);
 		goto again;
 	}
 err:
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	return ret;
 }
 
diff --git a/cmds-restore.c b/cmds-restore.c
index 34983f2..0871366 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -548,7 +548,7 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 				    struct btrfs_inode_item);
 		found_size = btrfs_inode_size(path->nodes[0], inode_item);
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	key->offset = 0;
 	key->type = BTRFS_EXTENT_DATA_KEY;
diff --git a/ctree.c b/ctree.c
index eb69b57..66b146b 100644
--- a/ctree.c
+++ b/ctree.c
@@ -48,11 +48,11 @@ struct btrfs_path *btrfs_alloc_path(void)
 
 void btrfs_free_path(struct btrfs_path *p)
 {
-	btrfs_release_path(NULL, p);
+	btrfs_release_path(p);
 	kfree(p);
 }
 
-void btrfs_release_path(struct btrfs_root *root, struct btrfs_path *p)
+void btrfs_release_path(struct btrfs_path *p)
 {
 	int i;
 	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
@@ -1072,7 +1072,7 @@ again:
 					return sret;
 				b = p->nodes[level];
 				if (!b) {
-					btrfs_release_path(NULL, p);
+					btrfs_release_path(p);
 					goto again;
 				}
 				slot = p->slots[level];
@@ -2113,7 +2113,7 @@ int btrfs_split_item(struct btrfs_trans_handle *trans,
 		goto split;
 
 	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	path->search_for_split = 1;
 
diff --git a/ctree.h b/ctree.h
index 4e7c1a7..d459733 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2213,7 +2213,7 @@ int btrfs_split_item(struct btrfs_trans_handle *trans,
 int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, struct btrfs_path *p, int
 		      ins_len, int cow);
-void btrfs_release_path(struct btrfs_root *root, struct btrfs_path *p);
+void btrfs_release_path(struct btrfs_path *p);
 void add_root_to_dirty_list(struct btrfs_root *root);
 struct btrfs_path *btrfs_alloc_path(void);
 void btrfs_free_path(struct btrfs_path *p);
diff --git a/dir-item.c b/dir-item.c
index f00485a..6558320 100644
--- a/dir-item.c
+++ b/dir-item.c
@@ -147,7 +147,7 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 		ret = 0;
 		goto out;
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	btrfs_set_key_type(&key, BTRFS_DIR_INDEX_KEY);
 	key.offset = index;
diff --git a/dir-test.c b/dir-test.c
index c7644d6..d95219a 100644
--- a/dir-test.c
+++ b/dir-test.c
@@ -133,11 +133,11 @@ error:
 		foundhash = btrfs_name_hash(found, found_len);
 		if (myhash != foundhash)
 			goto fatal_release;
-		btrfs_release_path(root, &path);
+		btrfs_release_path(&path);
 		return 0;
 	}
 fatal_release:
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 fatal:
 	printf("failed to insert %lu ret %d\n", oid, ret);
 	return -1;
@@ -189,7 +189,7 @@ static int del_dir_item(struct btrfs_trans_handle *trans,
 	ret = btrfs_del_item(trans, root, path);
 	if (ret)
 		goto out_release;
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	/* delete the inode */
 	btrfs_init_path(path);
@@ -199,7 +199,7 @@ static int del_dir_item(struct btrfs_trans_handle *trans,
 	ret = btrfs_del_item(trans, root, path);
 	if (ret)
 		goto out_release;
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	if (root->fs_info->last_inode_alloc > file_objectid)
 		root->fs_info->last_inode_alloc = file_objectid;
@@ -210,7 +210,7 @@ static int del_dir_item(struct btrfs_trans_handle *trans,
 	}
 	return 0;
 out_release:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 out:
 	printf("failed to delete %lu %d\n", radix_index, ret);
 	return -1;
@@ -239,7 +239,7 @@ static int del_one(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		goto out_release;
 	return ret;
 out_release:
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	printf("failed to delete %lu %d\n", oid, ret);
 	return -1;
 }
@@ -266,7 +266,7 @@ static int lookup_item(struct btrfs_trans_handle *trans, struct btrfs_root
 				    struct btrfs_dir_item);
 		objectid = btrfs_disk_key_objectid(&di->location);
 	}
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	if (ret) {
 		printf("unable to find key %lu\n", oid);
 		return -1;
@@ -289,7 +289,7 @@ static int lookup_enoent(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_init_path(&path);
 	ret = btrfs_lookup_dir_item(trans, root, &path, dir_oid, buf,
 				    strlen(buf), 0);
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	if (!ret) {
 		printf("able to find key that should not exist %lu\n", oid);
 		return -1;
@@ -318,12 +318,12 @@ static int empty_tree(struct btrfs_trans_handle *trans, struct btrfs_root
 		btrfs_init_path(&path);
 		ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
 		if (ret < 0) {
-			btrfs_release_path(root, &path);
+			btrfs_release_path(&path);
 			return ret;
 		}
 		if (ret != 0) {
 			if (path.slots[0] == 0) {
-				btrfs_release_path(root, &path);
+				btrfs_release_path(&path);
 				break;
 			}
 			path.slots[0] -= 1;
diff --git a/disk-io.c b/disk-io.c
index 9cfbea1..473f7c1 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -619,7 +619,7 @@ struct btrfs_root *btrfs_read_fs_root_no_cache(struct btrfs_fs_info *fs_info,
 	memcpy(&root->root_key, location, sizeof(*location));
 	ret = 0;
 out:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	btrfs_free_path(path);
 	if (ret) {
 		free(root);
diff --git a/extent-tree.c b/extent-tree.c
index c34ba14..828f7e3 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -560,7 +560,7 @@ static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
 			break;
 		}
 	}
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	if (owner < BTRFS_FIRST_FREE_OBJECTID)
 		new_size += sizeof(*bi);
@@ -667,7 +667,7 @@ again:
 			return 0;
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 		key.type = BTRFS_EXTENT_REF_V0_KEY;
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 		if (ret < 0) {
 			err = ret;
@@ -705,7 +705,7 @@ again:
 		if (match_extent_data_ref(leaf, ref, root_objectid,
 					  owner, offset)) {
 			if (recow) {
-				btrfs_release_path(root, path);
+				btrfs_release_path(path);
 				goto again;
 			}
 			err = 0;
@@ -766,7 +766,7 @@ static noinline int insert_extent_data_ref(struct btrfs_trans_handle *trans,
 			if (match_extent_data_ref(leaf, ref, root_objectid,
 						  owner, offset))
 				break;
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 
 			key.offset++;
 			ret = btrfs_insert_empty_item(trans, root, path, &key,
@@ -793,7 +793,7 @@ static noinline int insert_extent_data_ref(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	ret = 0;
 fail:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	return ret;
 }
 
@@ -919,7 +919,7 @@ static noinline int lookup_tree_block_ref(struct btrfs_trans_handle *trans,
 		ret = -ENOENT;
 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
 	if (ret == -ENOENT && parent) {
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		key.type = BTRFS_EXTENT_REF_V0_KEY;
 		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 		if (ret > 0)
@@ -949,7 +949,7 @@ static noinline int insert_tree_block_ref(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
 
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	return ret;
 }
 
@@ -1059,7 +1059,7 @@ again:
 		if (ret) {
 			key.type = BTRFS_EXTENT_ITEM_KEY;
 			key.offset = num_bytes;
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			goto again;
 		}
 	}
@@ -1259,7 +1259,7 @@ static int lookup_extent_backref(struct btrfs_trans_handle *trans,
 	if (ret != -ENOENT)
 		return ret;
 
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	*ref_ret = NULL;
 
 	if (owner < BTRFS_FIRST_FREE_OBJECTID) {
@@ -1435,7 +1435,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	btrfs_set_extent_refs(leaf, item, refs + 1);
 
 	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(root->fs_info->extent_root, path);
+	btrfs_release_path(path);
 
 	path->reada = 1;
 	path->leave_spinning = 1;
@@ -1516,7 +1516,7 @@ again:
 		}
 
 		if (ret) {
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			key.type = BTRFS_EXTENT_ITEM_KEY;
 			key.offset = root->leafsize;
 			metadata = 0;
@@ -1603,7 +1603,7 @@ again:
 				ret = 0;
 		}
 		if (ret) {
-			btrfs_release_path(root, path);
+			btrfs_release_path(path);
 			key.offset = root->leafsize;
 			key.type = BTRFS_EXTENT_ITEM_KEY;
 			goto again;
@@ -1749,7 +1749,7 @@ static int write_one_cache_group(struct btrfs_trans_handle *trans,
 	bi = btrfs_item_ptr_offset(leaf, path->slots[0]);
 	write_extent_buffer(leaf, &cache->item, bi, sizeof(cache->item));
 	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(extent_root, path);
+	btrfs_release_path(path);
 fail:
 	finish_current_insert(trans, extent_root);
 	pending_ret = del_pending_extents(trans, extent_root);
@@ -2254,7 +2254,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 						    NULL, refs_to_drop,
 						    is_data);
 			BUG_ON(ret);
-			btrfs_release_path(extent_root, path);
+			btrfs_release_path(path);
 			path->leave_spinning = 1;
 
 			key.objectid = bytenr;
@@ -2282,7 +2282,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 
 			if (ret > 0 && skinny_metadata) {
 				skinny_metadata = 0;
-				btrfs_release_path(extent_root, path);
+				btrfs_release_path(path);
 				key.type = BTRFS_EXTENT_ITEM_KEY;
 				key.offset = num_bytes;
 				ret = btrfs_search_slot(trans, extent_root,
@@ -2319,7 +2319,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 					     owner_objectid, 0);
 		BUG_ON(ret < 0);
 
-		btrfs_release_path(extent_root, path);
+		btrfs_release_path(path);
 		path->leave_spinning = 1;
 
 		key.objectid = bytenr;
@@ -2407,7 +2407,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 		ret = btrfs_del_items(trans, extent_root, path, path->slots[0],
 				      num_to_del);
 		BUG_ON(ret);
-		btrfs_release_path(extent_root, path);
+		btrfs_release_path(path);
 
 		if (is_data) {
 			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
@@ -3216,7 +3216,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		cache->cached = 0;
 		cache->pinned = 0;
 		key.objectid = found_key.objectid + found_key.offset;
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		cache->flags = btrfs_block_group_flags(&cache->item);
 		bit = 0;
 		if (cache->flags & BTRFS_BLOCK_GROUP_DATA) {
@@ -3462,7 +3462,7 @@ static int btrfs_count_extents_in_block_group(struct btrfs_root *root,
 		path->slots[0]++;
 	}
 	*total = bytes_used;
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	return 0;
 }
 
@@ -3580,6 +3580,6 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans,
 		path.slots[0]++;
 	}
 	btrfs_set_super_bytes_used(root->fs_info->super_copy, bytes_used);
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	return 0;
 }
diff --git a/file-item.c b/file-item.c
index 9c787f0..c2909dc 100644
--- a/file-item.c
+++ b/file-item.c
@@ -258,7 +258,7 @@ int btrfs_csum_file_block(struct btrfs_trans_handle *trans,
 	 * at this point, we know the tree has an item, but it isn't big
 	 * enough yet to put our csum in.  Grow it
 	 */
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	ret = btrfs_search_slot(trans, root, &file_key, path,
 				csum_size, 1);
 	if (ret < 0)
@@ -290,7 +290,7 @@ int btrfs_csum_file_block(struct btrfs_trans_handle *trans,
 	}
 
 insert:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	csum_offset = 0;
 	if (found_next) {
 		u64 tmp = min(alloc_end, next_offset);
@@ -328,7 +328,7 @@ found:
 			    csum_size);
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 fail:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -499,7 +499,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 						&key, bytenr, len);
 			BUG_ON(ret);
 		}
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 	}
 out:
 	btrfs_free_path(path);
diff --git a/free-space-cache.c b/free-space-cache.c
index a30438b..6c2e189 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -105,7 +105,7 @@ static int io_ctl_prepare_pages(struct io_ctl *io_ctl, struct btrfs_root *root,
 	if (ret) {
 		printf("Couldn't find file extent item for free space inode"
 		       " %Lu\n", ino);
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		return -EINVAL;
 	}
 
@@ -151,7 +151,7 @@ static int io_ctl_prepare_pages(struct io_ctl *io_ctl, struct btrfs_root *root,
 		path->slots[0]++;
 	}
 
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	return ret;
 }
 
@@ -287,7 +287,7 @@ int __load_free_space_cache(struct btrfs_root *root,
 	if (ret < 0) {
 		return 0;
 	} else if (ret > 0) {
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		return 0;
 	}
 
@@ -301,7 +301,7 @@ int __load_free_space_cache(struct btrfs_root *root,
 	generation = btrfs_free_space_generation(leaf, header);
 	btrfs_free_space_key(leaf, header, &disk_key);
 	btrfs_disk_key_to_cpu(&inode_location, &disk_key);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 
 	ret = btrfs_search_slot(NULL, root, &inode_location, path, 0, 0);
 	if (ret) {
@@ -318,12 +318,12 @@ int __load_free_space_cache(struct btrfs_root *root,
 		       (unsigned long long)btrfs_inode_generation(leaf,
 								  inode_item),
 		       (unsigned long long)generation);
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		return 0;
 	}
 
 	inode_size = btrfs_inode_size(leaf, inode_item);
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	if (inode_size == 0)
 		return 0;
 
diff --git a/inode-map.c b/inode-map.c
index d2970d4..f901109 100644
--- a/inode-map.c
+++ b/inode-map.c
@@ -122,12 +122,12 @@ int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
 	// FIXME -ENOSPC
 found:
 	root->last_inode_alloc = *objectid;
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	btrfs_free_path(path);
 	BUG_ON(*objectid < search_start);
 	return 0;
 error:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	btrfs_free_path(path);
 	return ret;
 }
diff --git a/mkfs.c b/mkfs.c
index 60f906c..b4607ae 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -704,7 +704,7 @@ static int record_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_file_extent_other_encoding(leaf, fi, 0);
 	btrfs_mark_buffer_dirty(leaf);
 
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 
 	ins_key.objectid = disk_bytenr;
 	ins_key.offset = num_bytes;
@@ -734,7 +734,7 @@ static int record_file_extent(struct btrfs_trans_handle *trans,
 				   root->root_key.objectid,
 				   objectid, 0);
 fail:
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	return ret;
 }
 
@@ -920,7 +920,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 	btrfs_set_inode_size(leaf, inode_item, root_dir_inode_size);
 	btrfs_mark_buffer_dirty(leaf);
 
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 
 	do {
 		parent_dir_entry = list_entry(dir_head->list.next,
diff --git a/quick-test.c b/quick-test.c
index 05d73fd..aaedd19 100644
--- a/quick-test.c
+++ b/quick-test.c
@@ -97,7 +97,7 @@ int main(int ac, char **av) {
 			printf("unable to find %d\n", num);
 			exit(1);
 		}
-		btrfs_release_path(root, &path);
+		btrfs_release_path(&path);
 	}
 	close_ctree(root);
 
@@ -128,7 +128,7 @@ int main(int ac, char **av) {
 				BUG();
 			tree_size--;
 		}
-		btrfs_release_path(root, &path);
+		btrfs_release_path(&path);
 	}
 	btrfs_commit_transaction(trans, root);
 	close_ctree(root);
@@ -172,7 +172,7 @@ int main(int ac, char **av) {
 			printf("unable to find %d\n", num);
 			exit(1);
 		}
-		btrfs_release_path(root, &path);
+		btrfs_release_path(&path);
 	}
 	printf("starting big long delete run\n");
 	trans = btrfs_start_transaction(root, 1);
@@ -205,7 +205,7 @@ int main(int ac, char **av) {
 			}
 			tree_size--;
 		}
-		btrfs_release_path(root, &path);
+		btrfs_release_path(&path);
 	}
 	/*
 	printf("previous tree:\n");
diff --git a/random-test.c b/random-test.c
index 3a07e6d..2f44593 100644
--- a/random-test.c
+++ b/random-test.c
@@ -118,7 +118,7 @@ static int del_one(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	if (ret)
 		goto error;
 	ret = btrfs_del_item(trans, root, &path);
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	if (ret != 0)
 		goto error;
 	ptr = radix_tree_delete(radix, key.objectid);
@@ -141,7 +141,7 @@ static int lookup_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	if (ret < 0)
 		return 0;
 	ret = btrfs_search_slot(trans, root, &key, &path, 0, 1);
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	if (ret)
 		goto error;
 	return 0;
@@ -161,7 +161,7 @@ static int lookup_enoent(struct btrfs_trans_handle *trans, struct btrfs_root
 	if (ret < 0)
 		return ret;
 	ret = btrfs_search_slot(trans, root, &key, &path, 0, 0);
-	btrfs_release_path(root, &path);
+	btrfs_release_path(&path);
 	if (ret <= 0)
 		goto error;
 	return 0;
@@ -190,12 +190,12 @@ static int empty_tree(struct btrfs_trans_handle *trans, struct btrfs_root
 		btrfs_init_path(&path);
 		ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
 		if (ret < 0) {
-			btrfs_release_path(root, &path);
+			btrfs_release_path(&path);
 			return ret;
 		}
 		if (ret != 0) {
 			if (path.slots[0] == 0) {
-				btrfs_release_path(root, &path);
+				btrfs_release_path(&path);
 				break;
 			}
 			path.slots[0] -= 1;
@@ -211,7 +211,7 @@ static int empty_tree(struct btrfs_trans_handle *trans, struct btrfs_root
 				found);
 			return -1;
 		}
-		btrfs_release_path(root, &path);
+		btrfs_release_path(&path);
 		ptr = radix_tree_delete(radix, found);
 		if (!ptr)
 			goto error;
@@ -294,13 +294,13 @@ static int fill_radix(struct btrfs_root *root, struct radix_tree_root *radix)
 		btrfs_init_path(&path);
 		ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 		if (ret < 0) {
-			btrfs_release_path(root, &path);
+			btrfs_release_path(&path);
 			return ret;
 		}
 		slot = path.slots[0];
 		if (ret != 0) {
 			if (slot == 0) {
-				btrfs_release_path(root, &path);
+				btrfs_release_path(&path);
 				break;
 			}
 			slot -= 1;
@@ -319,7 +319,7 @@ static int fill_radix(struct btrfs_root *root, struct radix_tree_root *radix)
 
 			radix_tree_preload_end();
 		}
-		btrfs_release_path(root, &path);
+		btrfs_release_path(&path);
 		key.objectid = found - 1;
 		if (key.objectid > found)
 			break;
diff --git a/root-tree.c b/root-tree.c
index c6b13dc..9e5f35f 100644
--- a/root-tree.c
+++ b/root-tree.c
@@ -55,7 +55,7 @@ int btrfs_find_last_root(struct btrfs_root *root, u64 objectid,
 	memcpy(key, &found_key, sizeof(found_key));
 	ret = 0;
 out:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -88,7 +88,7 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	 * for the added fields.
 	 */
 	if (old_len < sizeof(*item)) {
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		ret = btrfs_search_slot(trans, root, key, path,
 				-1, 1);
 		if (ret < 0) {
@@ -99,7 +99,7 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 		if (ret < 0) {
 			goto out;
 		}
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		ret = btrfs_insert_empty_item(trans, root, path,
 				key, sizeof(*item));
 		if (ret < 0) {
@@ -119,7 +119,7 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	write_extent_buffer(l, item, ptr, sizeof(*item));
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 out:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -160,7 +160,7 @@ int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	BUG_ON(refs != 0);
 	ret = btrfs_del_item(trans, root, path);
 out:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	btrfs_free_path(path);
 	return ret;
 }
diff --git a/utils.c b/utils.c
index ac6b4bb..e522361 100644
--- a/utils.c
+++ b/utils.c
@@ -683,7 +683,7 @@ int is_block_device(const char *path) {
  * On failure, returns -errno (not mounted yields -EINVAL)
  * Is noisy on failures, expects to be given a mounted device.
  */
-int get_btrfs_mount(const char *dev, char *mp, size_t mp_size) {
+static int get_btrfs_mount(const char *dev, char *mp, size_t mp_size) {
 	int ret;
 	int fd = -1;
 
diff --git a/utils.h b/utils.h
index 36fb591..d20f97f 100644
--- a/utils.h
+++ b/utils.h
@@ -66,7 +66,6 @@ int set_label(const char *btrfs_dev, const char *label);
 
 char *__strncpy__null(char *dest, const char *src, size_t n);
 int is_block_device(const char *file);
-int get_btrfs_mount(const char *path, char *mp, size_t mp_size);
 int open_path_or_dev_mnt(const char *path);
 int is_swap_device(const char *file);
 u64 btrfs_device_size(int fd, struct stat *st);
diff --git a/volumes.c b/volumes.c
index ddfa78a..afc0abc 100644
--- a/volumes.c
+++ b/volumes.c
@@ -364,7 +364,7 @@ check_pending:
 	/* we have to make sure we didn't find an extent that has already
 	 * been allocated by the map tree or the original allocation
 	 */
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	BUG_ON(*start < search_start);
 
 	if (*start + num_bytes > search_end) {
@@ -375,7 +375,7 @@ check_pending:
 	return 0;
 
 error:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	return ret;
 }
 
@@ -496,7 +496,7 @@ static int find_next_devid(struct btrfs_root *root, struct btrfs_path *path,
 	}
 	ret = 0;
 error:
-	btrfs_release_path(root, path);
+	btrfs_release_path(path);
 	return ret;
 }
 
@@ -1753,7 +1753,7 @@ again:
 	}
 	if (key.objectid == BTRFS_DEV_ITEMS_OBJECTID) {
 		key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
-		btrfs_release_path(root, path);
+		btrfs_release_path(path);
 		goto again;
 	}
 

