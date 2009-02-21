From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 3/3] reiserfs: convert string formatting to evprintk
Date: Fri, 20 Feb 2009 20:57:37 -0500
Message-ID: <499F5F91.5010502@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
	Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


 The reiserfs string formatting code bounces back and forth between its
 own internal formatting rules and those provided by vsnprintf. It's worked
 alright, but depends on undefined behavior - behavior that changed in a recent
 gcc release IIRC.

 This patch eliminates the reiserfs-internal string formatting and
 provides sprintf_type rules to allow reiserfs to use evprintk.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/dir.c             |    4 
 fs/reiserfs/do_balan.c        |   25 +-
 fs/reiserfs/fix_node.c        |   58 +++--
 fs/reiserfs/ibalance.c        |    4 
 fs/reiserfs/inode.c           |   23 +-
 fs/reiserfs/item_ops.c        |   11 -
 fs/reiserfs/lbalance.c        |   43 ++--
 fs/reiserfs/namei.c           |    9 
 fs/reiserfs/prints.c          |  413 +++++++++++++++++++-----------------------
 fs/reiserfs/stree.c           |  119 ++++++------
 fs/reiserfs/super.c           |   27 +-
 fs/reiserfs/tail_conversion.c |   19 -
 fs/reiserfs/xattr.c           |   10 -
 13 files changed, 385 insertions(+), 380 deletions(-)

--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -92,8 +92,8 @@ static int reiserfs_readdir(struct file
 
 		/* we must have found item, that is item of this directory, */
 		RFALSE(COMP_SHORT_KEYS(&(ih->ih_key), &pos_key),
-		       "vs-9000: found item %h does not match to dir we readdir %K",
-		       ih, &pos_key);
+		       "vs-9000: found item %peh does not match to dir "
+		       "we readdir %peK", ih, &pos_key);
 		RFALSE(item_num > B_NR_ITEMS(bh) - 1,
 		       "vs-9005 item_num == %d, item amount == %d",
 		       item_num, B_NR_ITEMS(bh));
--- a/fs/reiserfs/do_balan.c
+++ b/fs/reiserfs/do_balan.c
@@ -79,7 +79,7 @@ static int balance_leaf_when_delete(stru
 	struct item_head *ih;
 
 	RFALSE(tb->FR[0] && B_LEVEL(tb->FR[0]) != DISK_LEAF_NODE_LEVEL + 1,
-	       "vs- 12000: level: wrong FR %z", tb->FR[0]);
+	       "vs- 12000: level: wrong FR %pez", tb->FR[0]);
 	RFALSE(tb->blknum[0] > 1,
 	       "PAP-12005: tb->blknum == %d, can not be > 1", tb->blknum[0]);
 	RFALSE(!tb->blknum[0] && !PATH_H_PPARENT(tb->tb_path, 0),
@@ -93,8 +93,8 @@ static int balance_leaf_when_delete(stru
 	case M_DELETE:		/* delete item in S[0] */
 
 		RFALSE(ih_item_len(ih) + IH_SIZE != -tb->insert_size[0],
-		       "vs-12013: mode Delete, insert size %d, ih to be deleted %h",
-		       -tb->insert_size[0], ih);
+		       "vs-12013: mode Delete, insert size %d, ih to "
+		       "be deleted %peh", -tb->insert_size[0], ih);
 
 		bi.tb = tb;
 		bi.bi_bh = tbS0;
@@ -1549,8 +1549,8 @@ static int balance_leaf(struct tree_bala
 
 		RFALSE(!buffer_journaled(S_new[i])
 		       || buffer_journal_dirty(S_new[i])
-		       || buffer_dirty(S_new[i]), "PAP-12247: S_new[%d] : (%b)",
-		       i, S_new[i]);
+		       || buffer_dirty(S_new[i]),
+		       "PAP-12247: S_new[%d] : (%peb)", i, S_new[i]);
 	}
 
 	/* if the affected item was not wholly shifted then we perform all necessary operations on that part or whole of the
@@ -1804,8 +1804,8 @@ void replace_key(struct tree_balance *tb
 	       "vs-12305: source or destination buffer is 0 (src=%p, dest=%p)",
 	       src, dest);
 	RFALSE(!B_IS_KEYS_LEVEL(dest),
-	       "vs-12310: invalid level (%z) for destination buffer. dest must be leaf",
-	       dest);
+	       "vs-12310: invalid level (%pez) for destination buffer. "
+	       "dest must be leaf", dest);
 	RFALSE(n_dest < 0 || n_src < 0,
 	       "vs-12315: src(%d) or dest(%d) key number < 0", n_src, n_dest);
 	RFALSE(n_dest >= B_NR_ITEMS(dest) || n_src >= B_NR_ITEMS(src),
@@ -1867,14 +1867,15 @@ static void check_internal_node(struct s
 
 	RFALSE(!buffer_dirty(bh) &&
 	       !(buffer_journaled(bh) || buffer_journal_dirty(bh)),
-	       "PAP-12337: buffer (%b) must be dirty", bh);
+	       "PAP-12337: buffer (%peb) must be dirty", bh);
 	dc = B_N_CHILD(bh, 0);
 
 	for (i = 0; i <= B_NR_ITEMS(bh); i++, dc++) {
 		if (!is_reusable(s, dc_block_number(dc), 1)) {
 			print_cur_tb(mes);
 			reiserfs_panic(s,
-				       "PAP-12338: check_internal_node: invalid child pointer %y in %b",
+				       "PAP-12338: check_internal_node: "
+				       "invalid child pointer %pey in %peb",
 				       dc, bh);
 		}
 	}
@@ -1885,7 +1886,7 @@ static int locked_or_not_in_tree(struct
 	if ((!buffer_journal_prepared(bh) && buffer_locked(bh)) ||
 	    !B_IS_IN_TREE(bh)) {
 		reiserfs_warning(NULL,
-				 "vs-12339: locked_or_not_in_tree: %s (%b)",
+				 "vs-12339: locked_or_not_in_tree: %s (%peb)",
 				 which, bh);
 		return 1;
 	}
@@ -1956,8 +1957,8 @@ static void check_after_balance_leaf(str
 							       1))));
 		print_cur_tb("12223");
 		reiserfs_warning(tb->tb_sb,
-				 "B_FREE_SPACE (PATH_H_PBUFFER(tb->tb_path,0)) = %d; "
-				 "MAX_CHILD_SIZE (%d) - dc_size( %y, %d ) [%d] = %d",
+			 "B_FREE_SPACE (PATH_H_PBUFFER(tb->tb_path,0)) = %d; "
+			 "MAX_CHILD_SIZE (%d) - dc_size( %pey, %d ) [%d] = %d",
 				 left,
 				 MAX_CHILD_SIZE(PATH_H_PBUFFER(tb->tb_path, 0)),
 				 PATH_H_PBUFFER(tb->tb_path, 1),
--- a/fs/reiserfs/fix_node.c
+++ b/fs/reiserfs/fix_node.c
@@ -187,7 +187,9 @@ static void create_virtual_node(struct t
 				/* node contains more than 1 item, or item is not directory item, or this item contains more than 1 entry */
 				print_block(Sh, 0, -1, -1);
 				reiserfs_panic(tb->tb_sb,
-					       "vs-8045: create_virtual_node: rdkey %k, affected item==%d (mode==%c) Must be %c",
+					       "vs-8045: create_virtual_node: "
+					       "rdkey %pek, affected item==%d "
+					       "(mode==%c) Must be %c",
 					       key, vn->vn_affected_item_num,
 					       vn->vn_mode, M_DELETE);
 			}
@@ -833,8 +835,8 @@ static int get_empty_nodes(struct tree_b
 		RFALSE(buffer_dirty(p_s_new_bh) ||
 		       buffer_journaled(p_s_new_bh) ||
 		       buffer_journal_dirty(p_s_new_bh),
-		       "PAP-8140: journlaled or dirty buffer %b for the new block",
-		       p_s_new_bh);
+		       "PAP-8140: journlaled or dirty buffer %peb for the "
+		       "new block", p_s_new_bh);
 
 		/* Put empty buffers into the array. */
 		RFALSE(p_s_tb->FEB[p_s_tb->cur_blknum],
@@ -913,7 +915,7 @@ static int is_left_neighbor_in_cache(str
 	       !B_IS_IN_TREE(p_s_tb->FL[n_h]) ||
 	       !buffer_uptodate(p_s_father) ||
 	       !buffer_uptodate(p_s_tb->FL[n_h]),
-	       "vs-8165: F[h] (%b) or FL[h] (%b) is invalid",
+	       "vs-8165: F[h] (%peb) or FL[h] (%peb) is invalid",
 	       p_s_father, p_s_tb->FL[n_h]);
 
 	/* Get position of the pointer to the left neighbor into the left father. */
@@ -926,7 +928,7 @@ static int is_left_neighbor_in_cache(str
 	if ((left = sb_find_get_block(p_s_sb, n_left_neighbor_blocknr))) {
 
 		RFALSE(buffer_uptodate(left) && !B_IS_IN_TREE(left),
-		       "vs-8170: left neighbor (%b %z) is not in the tree",
+		       "vs-8170: left neighbor (%peb %pez) is not in the tree",
 		       left, left);
 		put_bh(left);
 		return 1;
@@ -1014,7 +1016,7 @@ static int get_far_parent(struct tree_ba
 	}
 
 	RFALSE(B_LEVEL(*pp_s_com_father) <= DISK_LEAF_NODE_LEVEL,
-	       "PAP-8185: (%b %z) level too small",
+	       "PAP-8185: (%peb %pez) level too small",
 	       *pp_s_com_father, *pp_s_com_father);
 
 	/* Check whether the common parent is locked. */
@@ -1058,7 +1060,8 @@ static int get_far_parent(struct tree_ba
 	*pp_s_father = PATH_PLAST_BUFFER(&s_path_to_neighbor_father);
 
 	RFALSE(B_LEVEL(*pp_s_father) != n_h + 1,
-	       "PAP-8190: (%b %z) level too small", *pp_s_father, *pp_s_father);
+	       "PAP-8190: (%peb %pez) level too small",
+	       *pp_s_father, *pp_s_father);
 	RFALSE(s_path_to_neighbor_father.path_length <
 	       FIRST_PATH_ELEMENT_OFFSET, "PAP-8192: path length is too small");
 
@@ -1122,7 +1125,8 @@ static int get_parents(struct tree_balan
 
 	RFALSE((p_s_curf && !B_IS_IN_TREE(p_s_curf)) ||
 	       (p_s_curcf && !B_IS_IN_TREE(p_s_curcf)),
-	       "PAP-8195: FL (%b) or CFL (%b) is invalid", p_s_curf, p_s_curcf);
+	       "PAP-8195: FL (%peb) or CFL (%peb) is invalid",
+	       p_s_curf, p_s_curcf);
 
 /* Get parent FR[n_h] of R[n_h]. */
 
@@ -1153,7 +1157,8 @@ static int get_parents(struct tree_balan
 
 	RFALSE((p_s_curf && !B_IS_IN_TREE(p_s_curf)) ||
 	       (p_s_curcf && !B_IS_IN_TREE(p_s_curcf)),
-	       "PAP-8205: FR (%b) or CFR (%b) is invalid", p_s_curf, p_s_curcf);
+	       "PAP-8205: FR (%peb) or CFR (%peb) is invalid",
+	       p_s_curf, p_s_curcf);
 
 	return CARRY_ON;
 }
@@ -2096,38 +2101,45 @@ static void tb_buffer_sanity_check(struc
 		if (atomic_read(&(p_s_bh->b_count)) <= 0) {
 
 			reiserfs_panic(p_s_sb,
-				       "jmacd-1: tb_buffer_sanity_check(): negative or zero reference counter for buffer %s[%d] (%b)\n",
+				       "jmacd-1: tb_buffer_sanity_check(): "
+				       "negative or zero reference counter "
+				       "for buffer %s[%d] (%peb)\n",
 				       descr, level, p_s_bh);
 		}
 
 		if (!buffer_uptodate(p_s_bh)) {
 			reiserfs_panic(p_s_sb,
-				       "jmacd-2: tb_buffer_sanity_check(): buffer is not up to date %s[%d] (%b)\n",
-				       descr, level, p_s_bh);
+				       "jmacd-2: tb_buffer_sanity_check(): "
+				       "buffer is not up to date %s[%d] "
+				       "(%peb)\n", descr, level, p_s_bh);
 		}
 
 		if (!B_IS_IN_TREE(p_s_bh)) {
 			reiserfs_panic(p_s_sb,
-				       "jmacd-3: tb_buffer_sanity_check(): buffer is not in tree %s[%d] (%b)\n",
+				       "jmacd-3: tb_buffer_sanity_check(): "
+				       "buffer is not in tree %s[%d] (%peb)\n",
 				       descr, level, p_s_bh);
 		}
 
 		if (p_s_bh->b_bdev != p_s_sb->s_bdev) {
 			reiserfs_panic(p_s_sb,
-				       "jmacd-4: tb_buffer_sanity_check(): buffer has wrong device %s[%d] (%b)\n",
-				       descr, level, p_s_bh);
+				       "jmacd-4: tb_buffer_sanity_check(): "
+				       "buffer has wrong device %s[%d] "
+				       "(%peb)\n", descr, level, p_s_bh);
 		}
 
 		if (p_s_bh->b_size != p_s_sb->s_blocksize) {
 			reiserfs_panic(p_s_sb,
-				       "jmacd-5: tb_buffer_sanity_check(): buffer has wrong blocksize %s[%d] (%b)\n",
-				       descr, level, p_s_bh);
+				       "jmacd-5: tb_buffer_sanity_check(): "
+				       "buffer has wrong blocksize %s[%d] "
+				       "(%peb)\n", descr, level, p_s_bh);
 		}
 
 		if (p_s_bh->b_blocknr > SB_BLOCK_COUNT(p_s_sb)) {
 			reiserfs_panic(p_s_sb,
-				       "jmacd-6: tb_buffer_sanity_check(): buffer block number too high %s[%d] (%b)\n",
-				       descr, level, p_s_bh);
+				       "jmacd-6: tb_buffer_sanity_check(): "
+				       "buffer block number too high %s[%d] "
+				       "(%peb)\n", descr, level, p_s_bh);
 		}
 	}
 }
@@ -2271,7 +2283,7 @@ static int wait_tb_buffers_until_unlocke
 				reiserfs_warning(p_s_tb->tb_sb,
 						 "wait_tb_buffers_until_released(): too many "
 						 "iterations waiting for buffer to unlock "
-						 "(%b)", locked);
+						 "(%peb)", locked);
 
 				/* Don't loop forever.  Try to recover from possible error. */
 
@@ -2364,9 +2376,9 @@ int fix_nodes(int n_op_mode, struct tree
 
 	if (!buffer_uptodate(p_s_tbS0) || !B_IS_IN_TREE(p_s_tbS0)) {
 		reiserfs_panic(p_s_tb->tb_sb,
-			       "PAP-8320: fix_nodes: S[0] (%b %z) is not uptodate "
-			       "at the beginning of fix_nodes or not in tree (mode %c)",
-			       p_s_tbS0, p_s_tbS0, n_op_mode);
+		       "PAP-8320: fix_nodes: S[0] (%peb %pez) is not uptodate "
+		       "at the beginning of fix_nodes or not in tree (mode %c)",
+		       p_s_tbS0, p_s_tbS0, n_op_mode);
 	}
 
 	/* Check parameters. */
--- a/fs/reiserfs/ibalance.c
+++ b/fs/reiserfs/ibalance.c
@@ -226,7 +226,7 @@ static void internal_delete_pointers_ite
 
 	RFALSE(first_i + del_num > B_NR_ITEMS(cur),
 	       "first_i = %d del_num = %d "
-	       "no so many keys (%d) in the node (%b)(%z)",
+	       "no so many keys (%d) in the node (%peb)(%pez)",
 	       first_i, del_num, first_i + del_num, cur, cur);
 
 	/* deleting */
@@ -1063,7 +1063,7 @@ int balance_internal(struct tree_balance
 		new_insert_ptr = S_new;
 
 		RFALSE(!buffer_journaled(S_new) || buffer_journal_dirty(S_new)
-		       || buffer_dirty(S_new), "cm-00001: bad S_new (%b)",
+		       || buffer_dirty(S_new), "cm-00001: bad S_new (%peb)",
 		       S_new);
 
 		// S_new is released in unfix_nodes
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1008,7 +1008,7 @@ int reiserfs_get_block(struct inode *ino
 		if (retval == POSITION_FOUND) {
 			reiserfs_warning(inode->i_sb,
 					 "vs-825: reiserfs_get_block: "
-					 "%K should not be found", &key);
+					 "%peK should not be found", &key);
 			retval = -EEXIST;
 			if (allocated_block_nr)
 				reiserfs_free_block(th, inode,
@@ -1300,8 +1300,8 @@ static void update_stat_data(struct tree
 
 	if (!is_statdata_le_ih(ih))
 		reiserfs_panic(inode->i_sb,
-			       "vs-13065: update_stat_data: key %k, found item %h",
-			       INODE_PKEY(inode), ih);
+		       "vs-13065: update_stat_data: key %pek, found item %peh",
+		       INODE_PKEY(inode), ih);
 
 	if (stat_data_v1(ih)) {
 		// path points to old stat data
@@ -1334,8 +1334,8 @@ void reiserfs_update_sd_size(struct reis
 		if (retval == IO_ERROR) {
 			reiserfs_warning(inode->i_sb,
 					 "vs-13050: reiserfs_update_sd: "
-					 "i/o failure occurred trying to update %K stat data",
-					 &key);
+					 "i/o failure occurred trying to "
+					 "update %peK stat data", &key);
 			return;
 		}
 		if (retval == ITEM_NOT_FOUND) {
@@ -1347,7 +1347,8 @@ void reiserfs_update_sd_size(struct reis
 			}
 			reiserfs_warning(inode->i_sb,
 					 "vs-13060: reiserfs_update_sd: "
-					 "stat data of object %k (nlink == %d) not found (pos %d)",
+					 "stat data of object %pek "
+					 "(nlink == %d) not found (pos %d)",
 					 INODE_PKEY(inode), inode->i_nlink,
 					 pos);
 			reiserfs_check_path(&path);
@@ -1426,8 +1427,8 @@ void reiserfs_read_locked_inode(struct i
 	if (retval == IO_ERROR) {
 		reiserfs_warning(inode->i_sb,
 				 "vs-13070: reiserfs_read_locked_inode: "
-				 "i/o failure occurred trying to find stat data of %K",
-				 &key);
+				 "i/o failure occurred trying to find "
+				 "stat data of %peK", &key);
 		reiserfs_make_bad_inode(inode);
 		return;
 	}
@@ -1459,7 +1460,7 @@ void reiserfs_read_locked_inode(struct i
 	    !REISERFS_SB(inode->i_sb)->s_is_unlinked_ok) {
 		reiserfs_warning(inode->i_sb,
 				 "vs-13075: reiserfs_read_locked_inode: "
-				 "dead inode read from disk %K. "
+				 "dead inode read from disk %peK. "
 				 "This is likely to be race with knfsd. Ignore",
 				 &key);
 		reiserfs_make_bad_inode(inode);
@@ -1687,7 +1688,7 @@ static int reiserfs_new_directory(struct
 	if (retval == ITEM_FOUND) {
 		pathrelse(path);
 		reiserfs_warning(sb, "vs-13070: reiserfs_new_directory: "
-				 "object with this key exists (%k)",
+				 "object with this key exists (%pek)",
 				 &(ih->ih_key));
 		return -EEXIST;
 	}
@@ -1727,7 +1728,7 @@ static int reiserfs_new_symlink(struct r
 	if (retval == ITEM_FOUND) {
 		pathrelse(path);
 		reiserfs_warning(sb, "vs-13080: reiserfs_new_symlink: "
-				 "object with this key exists (%k)",
+				 "object with this key exists (%pek)",
 				 &(ih->ih_key));
 		return -EEXIST;
 	}
--- a/fs/reiserfs/item_ops.c
+++ b/fs/reiserfs/item_ops.c
@@ -97,7 +97,7 @@ static int sd_unit_num(struct virtual_it
 
 static void sd_print_vi(struct virtual_item *vi)
 {
-	reiserfs_warning(NULL, "STATDATA, index %d, type 0x%x, %h",
+	reiserfs_warning(NULL, "STATDATA, index %d, type 0x%x, %peh",
 			 vi->vi_index, vi->vi_type, vi->vi_ih);
 }
 
@@ -190,7 +190,7 @@ static int direct_unit_num(struct virtua
 
 static void direct_print_vi(struct virtual_item *vi)
 {
-	reiserfs_warning(NULL, "DIRECT, index %d, type 0x%x, %h",
+	reiserfs_warning(NULL, "DIRECT, index %d, type 0x%x, %peh",
 			 vi->vi_index, vi->vi_type, vi->vi_ih);
 }
 
@@ -334,7 +334,7 @@ static int indirect_unit_num(struct virt
 
 static void indirect_print_vi(struct virtual_item *vi)
 {
-	reiserfs_warning(NULL, "INDIRECT, index %d, type 0x%x, %h",
+	reiserfs_warning(NULL, "INDIRECT, index %d, type 0x%x, %peh",
 			 vi->vi_index, vi->vi_type, vi->vi_ih);
 }
 
@@ -614,8 +614,9 @@ static void direntry_print_vi(struct vir
 	int i;
 	struct direntry_uarea *dir_u = vi->vi_uarea;
 
-	reiserfs_warning(NULL, "DIRENTRY, index %d, type 0x%x, %h, flags 0x%x",
-			 vi->vi_index, vi->vi_type, vi->vi_ih, dir_u->flags);
+	reiserfs_warning(NULL, "DIRENTRY, index %d, type 0x%x, %peh, "
+			 "flags 0x%x", vi->vi_index, vi->vi_type,
+			 vi->vi_ih, dir_u->flags);
 	printk("%d entries: ", dir_u->entry_count);
 	for (i = 0; i < dir_u->entry_count; i++)
 		printk("%d ", dir_u->entry_sizes[i]);
--- a/fs/reiserfs/lbalance.c
+++ b/fs/reiserfs/lbalance.c
@@ -168,10 +168,11 @@ static int leaf_copy_boundary_item(struc
 			if (bytes_or_entries == ih_item_len(ih)
 			    && is_indirect_le_ih(ih))
 				if (get_ih_free_space(ih))
-					reiserfs_panic(NULL,
-						       "vs-10020: leaf_copy_boundary_item: "
-						       "last unformatted node must be filled entirely (%h)",
-						       ih);
+					reiserfs_panic(NULL, "vs-10020: "
+						"leaf_copy_boundary_item: "
+						"last unformatted node must "
+						"be filled entirely (%peh)",
+						ih);
 		}
 #endif
 
@@ -183,8 +184,9 @@ static int leaf_copy_boundary_item(struc
 
 		if (is_indirect_le_ih(dih)) {
 			RFALSE(get_ih_free_space(dih),
-			       "vs-10030: merge to left: last unformatted node of non-last indirect item %h must have zerto free space",
-			       ih);
+			       "vs-10030: merge to left: last unformatted "
+			       "node of non-last indirect item %peh must "
+			       "have zero free space", ih);
 			if (bytes_or_entries == ih_item_len(ih))
 				set_ih_free_space(dih, get_ih_free_space(ih));
 		}
@@ -222,8 +224,8 @@ static int leaf_copy_boundary_item(struc
 	 */
 
 	RFALSE(is_indirect_le_ih(ih) && get_ih_free_space(ih),
-	       "vs-10040: merge to right: last unformatted node of non-last indirect item must be filled entirely (%h)",
-	       ih);
+	       "vs-10040: merge to right: last unformatted node of "
+	       "non-last indirect item must be filled entirely (%peh)", ih);
 
 	if (bytes_or_entries == -1) {
 		/* bytes_or_entries = length of last item body of SOURCE */
@@ -231,7 +233,7 @@ static int leaf_copy_boundary_item(struc
 
 		RFALSE(le_ih_k_offset(dih) !=
 		       le_ih_k_offset(ih) + op_bytes_number(ih, src->b_size),
-		       "vs-10050: items %h and %h do not match", ih, dih);
+		       "vs-10050: items %peh and %peh do not match", ih, dih);
 
 		/* change first item key of the DEST */
 		set_le_ih_k_offset(dih, le_ih_k_offset(ih));
@@ -250,7 +252,7 @@ static int leaf_copy_boundary_item(struc
 		if (is_direct_le_ih(dih)) {
 			RFALSE(le_ih_k_offset(dih) <=
 			       (unsigned long)bytes_or_entries,
-			       "vs-10070: dih %h, bytes_or_entries(%d)", dih,
+			       "vs-10070: dih %peh, bytes_or_entries(%d)", dih,
 			       bytes_or_entries);
 			set_le_ih_k_offset(dih,
 					   le_ih_k_offset(dih) -
@@ -258,7 +260,7 @@ static int leaf_copy_boundary_item(struc
 		} else {
 			RFALSE(le_ih_k_offset(dih) <=
 			       (bytes_or_entries / UNFM_P_SIZE) * dest->b_size,
-			       "vs-10080: dih %h, bytes_or_entries(%d)",
+			       "vs-10080: dih %peh, bytes_or_entries(%d)",
 			       dih,
 			       (bytes_or_entries / UNFM_P_SIZE) * dest->b_size);
 			set_le_ih_k_offset(dih,
@@ -410,7 +412,7 @@ static void leaf_item_bottle(struct buff
 			}
 
 			RFALSE(op_is_left_mergeable(&(ih->ih_key), src->b_size),
-			       "vs-10190: bad mergeability of item %h", ih);
+			       "vs-10190: bad mergeability of item %peh", ih);
 			n_ih.ih_version = ih->ih_version;	/* JDM Endian safe, both le */
 			leaf_insert_into_buf(dest_bi, B_NR_ITEMS(dest), &n_ih,
 					     B_N_PITEM(src, item_num), 0);
@@ -811,7 +813,7 @@ void leaf_insert_into_buf(struct buffer_
 
 	/* check free space */
 	RFALSE(free_space < ih_item_len(inserted_item_ih) + IH_SIZE,
-	       "vs-10170: not enough free space in block %z, new item %h",
+	       "vs-10170: not enough free space in block %pez, new item %peh",
 	       bh, inserted_item_ih);
 	RFALSE(zeros_number > ih_item_len(inserted_item_ih),
 	       "vs-10172: zero number == %d, item length == %d",
@@ -1078,7 +1080,8 @@ void leaf_cut_from_buffer(struct buffer_
 						   bh->b_size);
 				RFALSE(ih_item_len(ih) == cut_size
 				       && get_ih_free_space(ih),
-				       "10205: invalid ih_free_space (%h)", ih);
+				       "10205: invalid ih_free_space (%peh)",
+				       ih);
 			}
 		}
 	}
@@ -1288,12 +1291,16 @@ void leaf_paste_entries(struct buffer_he
 
 			if (prev && prev <= deh_location(&(deh[i])))
 				reiserfs_warning(NULL,
-						 "vs-10240: leaf_paste_entries: directory item (%h) corrupted (prev %a, cur(%d) %a)",
-						 ih, deh + i - 1, i, deh + i);
+					 "vs-10240: leaf_paste_entries: "
+					 "directory item (%peh) corrupted "
+					 "(prev %pea, cur(%d) %pea)",
+					 ih, deh + i - 1, i, deh + i);
 			if (next && next >= deh_location(&(deh[i])))
 				reiserfs_warning(NULL,
-						 "vs-10250: leaf_paste_entries: directory item (%h) corrupted (cur(%d) %a, next %a)",
-						 ih, i, deh + i, deh + i + 1);
+					 "vs-10250: leaf_paste_entries: "
+					 "directory item (%peh) corrupted "
+					 "(cur(%d) %pea, next %pea)",
+					 ih, i, deh + i, deh + i + 1);
 		}
 	}
 #endif
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -147,8 +147,9 @@ int search_by_entry_key(struct super_blo
 	    COMP_SHORT_KEYS(&(de->de_ih->ih_key), key)) {
 		print_block(de->de_bh, 0, -1, -1);
 		reiserfs_panic(sb,
-			       "vs-7005: search_by_entry_key: found item %h is not directory item or "
-			       "does not belong to the same directory as key %K",
+			       "vs-7005: search_by_entry_key: found item "
+			       "%peh is not directory item or does not "
+			       "belong to the same directory as key %peK",
 			       de->de_ih, key);
 	}
 #endif				/* CONFIG_REISERFS_CHECK */
@@ -517,8 +518,8 @@ static int reiserfs_add_entry(struct rei
 		    NAME_NOT_FOUND) {
 			reiserfs_warning(dir->i_sb,
 					 "vs-7032: reiserfs_add_entry: "
-					 "entry with this key (%K) already exists",
-					 &entry_key);
+					 "entry with this key (%peK) already "
+					 "exists", &entry_key);
 
 			if (buffer != small_buf)
 				kfree(buffer);
--- a/fs/reiserfs/prints.c
+++ b/fs/reiserfs/prints.c
@@ -10,42 +10,39 @@
 
 #include <stdarg.h>
 
-static char error_buf[1024];
-static char fmt_buf[1024];
-static char off_buf[80];
-
-static char *reiserfs_cpu_offset(struct cpu_key *key)
+static char *sprintf_cpu_offset(char *buf, char *end, const struct cpu_key *key)
 {
 	if (cpu_key_k_type(key) == TYPE_DIRENTRY)
-		sprintf(off_buf, "%Lu(%Lu)",
-			(unsigned long long)
-			GET_HASH_VALUE(cpu_key_k_offset(key)),
-			(unsigned long long)
-			GET_GENERATION_NUMBER(cpu_key_k_offset(key)));
+		buf += snprintf(buf, end - buf, "%llu(%llu)",
+			       (unsigned long long)
+			       GET_HASH_VALUE(cpu_key_k_offset(key)),
+			       (unsigned long long)
+			       GET_GENERATION_NUMBER(cpu_key_k_offset(key)));
 	else
-		sprintf(off_buf, "0x%Lx",
-			(unsigned long long)cpu_key_k_offset(key));
-	return off_buf;
+		buf += snprintf(buf, end - buf, "0x%llx",
+				(unsigned long long)cpu_key_k_offset(key));
+	return buf;
 }
 
-static char *le_offset(struct reiserfs_key *key)
+static char *sprintf_le_offset(char *buf, char *end,
+			       const struct reiserfs_key *key)
 {
 	int version;
 
 	version = le_key_version(key);
 	if (le_key_k_type(version, key) == TYPE_DIRENTRY)
-		sprintf(off_buf, "%Lu(%Lu)",
+		buf += snprintf(buf, end - buf, "%llu(%llu)",
 			(unsigned long long)
 			GET_HASH_VALUE(le_key_k_offset(version, key)),
 			(unsigned long long)
 			GET_GENERATION_NUMBER(le_key_k_offset(version, key)));
 	else
-		sprintf(off_buf, "0x%Lx",
+		buf += snprintf(buf, end - buf, "0x%Lx",
 			(unsigned long long)le_key_k_offset(version, key));
-	return off_buf;
+	return buf;
 }
 
-static char *cpu_type(struct cpu_key *key)
+static char *cpu_type(const struct cpu_key *key)
 {
 	if (cpu_key_k_type(key) == TYPE_STAT_DATA)
 		return "SD";
@@ -58,7 +55,7 @@ static char *cpu_type(struct cpu_key *ke
 	return "UNKNOWN";
 }
 
-static char *le_type(struct reiserfs_key *key)
+static char *le_type(const struct reiserfs_key *key)
 {
 	int version;
 
@@ -75,232 +72,206 @@ static char *le_type(struct reiserfs_key
 	return "UNKNOWN";
 }
 
-/* %k */
-static void sprintf_le_key(char *buf, struct reiserfs_key *key)
-{
-	if (key)
-		sprintf(buf, "[%d %d %s %s]", le32_to_cpu(key->k_dir_id),
-			le32_to_cpu(key->k_objectid), le_offset(key),
-			le_type(key));
-	else
-		sprintf(buf, "[NULL]");
+static char *sprintf_le_key(const char *fmt, char *buf, char *end,
+			    const void *ptr, int field_width, int precision,
+			    int flags)
+{
+	const struct reiserfs_key *key = ptr;
+	if (key) {
+		buf += snprintf(buf, end - buf, "[%d %d ",
+			       le32_to_cpu(key->k_dir_id),
+			       le32_to_cpu(key->k_objectid));
+		buf = sprintf_le_offset(buf, end, key);
+		buf += snprintf(buf, end - buf, " %s]", le_type(key));
+	} else
+		buf += snprintf(buf, end - buf, "[NULL]");
+	return buf;
 }
 
-/* %K */
-static void sprintf_cpu_key(char *buf, struct cpu_key *key)
-{
-	if (key)
-		sprintf(buf, "[%d %d %s %s]", key->on_disk_key.k_dir_id,
-			key->on_disk_key.k_objectid, reiserfs_cpu_offset(key),
-			cpu_type(key));
-	else
-		sprintf(buf, "[NULL]");
+static char *sprintf_cpu_key(const char *fmt, char *buf, char *end,
+			     const void *ptr, int field_width, int precision,
+			     int flags)
+{
+	const struct cpu_key *key = ptr;
+	if (key) {
+		buf += snprintf(buf, end - buf, "[%d %d ",
+				key->on_disk_key.k_dir_id,
+				key->on_disk_key.k_objectid);
+		buf = sprintf_cpu_offset(buf, end, key);
+		buf += snprintf(buf, end - buf, " %s]", cpu_type(key));
+	} else
+		buf += snprintf(buf, end - buf, "[NULL]");
+	return buf;
 }
 
-static void sprintf_de_head(char *buf, struct reiserfs_de_head *deh)
+static char *sprintf_de_head(const char *fmt, char *buf, char *end,
+			     const void *ptr, int field_width, int precision,
+			     int flags)
 {
+	const struct reiserfs_de_head *deh  = ptr;
 	if (deh)
-		sprintf(buf,
-			"[offset=%d dir_id=%d objectid=%d location=%d state=%04x]",
-			deh_offset(deh), deh_dir_id(deh), deh_objectid(deh),
-			deh_location(deh), deh_state(deh));
+		buf += snprintf(buf, end - buf, "[offset=%d dir_id=%d "
+				"objectid=%d location=%d state=%04x]",
+				deh_offset(deh), deh_dir_id(deh),
+				deh_objectid(deh), deh_location(deh),
+				deh_state(deh));
 	else
-		sprintf(buf, "[NULL]");
+		buf += snprintf(buf, end - buf, "[NULL]");
+
+	return buf;
 
 }
 
-static void sprintf_item_head(char *buf, struct item_head *ih)
+static char *sprintf_item_head(const char *fmt, char *buf, char *end,
+			       const void *ptr, int field_width, int precision,
+			       int flags)
 {
+	const struct item_head *ih = ptr;
 	if (ih) {
-		strcpy(buf,
-		       (ih_version(ih) == KEY_FORMAT_3_6) ? "*3.6* " : "*3.5*");
-		sprintf_le_key(buf + strlen(buf), &(ih->ih_key));
-		sprintf(buf + strlen(buf), ", item_len %d, item_location %d, "
-			"free_space(entry_count) %d",
-			ih_item_len(ih), ih_location(ih), ih_free_space(ih));
+		buf += snprintf(buf, end - buf, "[*3.%d* ", ih_version(ih) + 5);
+		buf = sprintf_le_key(fmt, buf, end, &ih->ih_key, field_width,
+				     precision, flags);
+		buf += snprintf(buf, end - buf, ", item_len %d, "
+				"item_location %d, free_space(entry_count) %d]",
+				ih_item_len(ih), ih_location(ih),
+				ih_free_space(ih));
 	} else
-		sprintf(buf, "[NULL]");
+		buf += snprintf(buf, end - buf, "[NULL]");
+
+	return buf;
 }
 
-static void sprintf_direntry(char *buf, struct reiserfs_dir_entry *de)
+static char *sprintf_direntry(const char *fmt, char *buf, char *end,
+			      const void *ptr, int field_width, int precision,
+			      int flags)
 {
+	const struct reiserfs_dir_entry *de = ptr;
 	char name[20];
 
 	memcpy(name, de->de_name, de->de_namelen > 19 ? 19 : de->de_namelen);
 	name[de->de_namelen > 19 ? 19 : de->de_namelen] = 0;
-	sprintf(buf, "\"%s\"==>[%d %d]", name, de->de_dir_id, de->de_objectid);
-}
-
-static void sprintf_block_head(char *buf, struct buffer_head *bh)
-{
-	sprintf(buf, "level=%d, nr_items=%d, free_space=%d rdkey ",
-		B_LEVEL(bh), B_NR_ITEMS(bh), B_FREE_SPACE(bh));
+	buf += snprintf(buf, end - buf, "\"%s\"==>[%d %d]",
+		       name, de->de_dir_id, de->de_objectid);
+	return buf;
 }
 
-static void sprintf_buffer_head(char *buf, struct buffer_head *bh)
+static char *sprintf_block_head(const char *fmt, char *buf, char *end,
+				const void *ptr, int field_width,
+				int precision, int flags)
 {
-	char b[BDEVNAME_SIZE];
-
-	sprintf(buf,
-		"dev %s, size %zd, blocknr %llu, count %d, state 0x%lx, page %p, (%s, %s, %s)",
-		bdevname(bh->b_bdev, b), bh->b_size,
-		(unsigned long long)bh->b_blocknr, atomic_read(&(bh->b_count)),
-		bh->b_state, bh->b_page,
-		buffer_uptodate(bh) ? "UPTODATE" : "!UPTODATE",
-		buffer_dirty(bh) ? "DIRTY" : "CLEAN",
-		buffer_locked(bh) ? "LOCKED" : "UNLOCKED");
-}
-
-static void sprintf_disk_child(char *buf, struct disk_child *dc)
-{
-	sprintf(buf, "[dc_number=%d, dc_size=%u]", dc_block_number(dc),
-		dc_size(dc));
-}
-
-static char *is_there_reiserfs_struct(char *fmt, int *what, int *skip)
-{
-	char *k = fmt;
-
-	*skip = 0;
+	const struct buffer_head *bh = ptr;
 
-	while ((k = strchr(k, '%')) != NULL) {
-		if (k[1] == 'k' || k[1] == 'K' || k[1] == 'h' || k[1] == 't' ||
-		    k[1] == 'z' || k[1] == 'b' || k[1] == 'y' || k[1] == 'a') {
-			*what = k[1];
-			break;
-		}
-		(*skip)++;
-		k++;
-	}
-	return k;
+	buf += snprintf(buf, end - buf,
+		       "[level=%d, nr_items=%d, free_space=%d rdkey ]",
+		       B_LEVEL(bh), B_NR_ITEMS(bh), B_FREE_SPACE(bh));
+	return buf;
 }
 
-/* debugging reiserfs we used to print out a lot of different
-   variables, like keys, item headers, buffer heads etc. Values of
-   most fields matter. So it took a long time just to write
-   appropriative printk. With this reiserfs_warning you can use format
-   specification for complex structures like you used to do with
-   printfs for integers, doubles and pointers. For instance, to print
-   out key structure you have to write just: 
-   reiserfs_warning ("bad key %k", key); 
-   instead of 
-   printk ("bad key %lu %lu %lu %lu", key->k_dir_id, key->k_objectid, 
-           key->k_offset, key->k_uniqueness); 
-*/
-
-static void prepare_error_buf(const char *fmt, va_list args)
+static char *sprintf_buffer_head(const char *fmt, char *buf, char *end,
+				 const void *ptr, int field_width,
+				 int precision, int flags)
 {
-	char *fmt1 = fmt_buf;
-	char *k;
-	char *p = error_buf;
-	int i, j, what, skip;
-
-	strcpy(fmt1, fmt);
-
-	while ((k = is_there_reiserfs_struct(fmt1, &what, &skip)) != NULL) {
-		*k = 0;
-
-		p += vsprintf(p, fmt1, args);
-
-		for (i = 0; i < skip; i++)
-			j = va_arg(args, int);
-
-		switch (what) {
-		case 'k':
-			sprintf_le_key(p, va_arg(args, struct reiserfs_key *));
-			break;
-		case 'K':
-			sprintf_cpu_key(p, va_arg(args, struct cpu_key *));
-			break;
-		case 'h':
-			sprintf_item_head(p, va_arg(args, struct item_head *));
-			break;
-		case 't':
-			sprintf_direntry(p,
-					 va_arg(args,
-						struct reiserfs_dir_entry *));
-			break;
-		case 'y':
-			sprintf_disk_child(p,
-					   va_arg(args, struct disk_child *));
-			break;
-		case 'z':
-			sprintf_block_head(p,
-					   va_arg(args, struct buffer_head *));
-			break;
-		case 'b':
-			sprintf_buffer_head(p,
-					    va_arg(args, struct buffer_head *));
-			break;
-		case 'a':
-			sprintf_de_head(p,
-					va_arg(args,
-					       struct reiserfs_de_head *));
-			break;
-		}
-
-		p += strlen(p);
-		fmt1 = k + 2;
-	}
-	vsprintf(p, fmt1, args);
+	const struct buffer_head *bh = ptr;
+	char b[BDEVNAME_SIZE];
 
-}
+	buf += snprintf(buf, end - buf,
+			"[dev %s, size %zd, blocknr %llu, count %d, "
+			"state 0x%lx, page %p, (%s, %s, %s)]",
+			bdevname(bh->b_bdev, b), bh->b_size,
+			(unsigned long long)bh->b_blocknr,
+			atomic_read(&(bh->b_count)),
+			bh->b_state, bh->b_page,
+			buffer_uptodate(bh) ? "UPTODATE" : "!UPTODATE",
+			buffer_dirty(bh) ? "DIRTY" : "CLEAN",
+			buffer_locked(bh) ? "LOCKED" : "UNLOCKED");
+	return buf;
+}
+
+static char *sprintf_disk_child(const char *fmt, char *buf, char *end,
+				const void *ptr, int width, int precision,
+				int flags)
+{
+	const struct disk_child *dc = ptr;
+
+	buf += snprintf(buf, end - buf, "[dc_number=%d, dc_size=%u]",
+			dc_block_number(dc), dc_size(dc));
+	return buf;
+}
+
+const static struct sprintf_type reiserfs_sprintf_types[] = {
+	{ .format_char = 'a', .formatter = sprintf_de_head, },
+	{ .format_char = 'b', .formatter = sprintf_buffer_head, },
+	{ .format_char = 'h', .formatter = sprintf_item_head, },
+	{ .format_char = 'K', .formatter = sprintf_cpu_key, },
+	{ .format_char = 'k', .formatter = sprintf_le_key, },
+	{ .format_char = 't', .formatter = sprintf_direntry, },
+	{ .format_char = 'y', .formatter = sprintf_disk_child, },
+	{ .format_char = 'z', .formatter = sprintf_block_head, },
+	{},
+};
 
 /* in addition to usual conversion specifiers this accepts reiserfs
-   specific conversion specifiers: 
-   %k to print little endian key, 
-   %K to print cpu key, 
-   %h to print item_head,
-   %t to print directory entry 
-   %z to print block head (arg must be struct buffer_head *
-   %b to print buffer_head
+   specific conversion specifiers:
+   %pea to print disk entry head,
+   %peb to print buffer_head
+   %peh to print item_head,
+   %peK to print cpu order key,
+   %pek to print disk order key,
+   %pet to print directory entry
+   %pey to print disk_child
+   %pez to print block head (arg must be struct buffer_head *)
 */
 
-#define do_reiserfs_warning(fmt)\
-{\
-    va_list args;\
-    va_start( args, fmt );\
-    prepare_error_buf( fmt, args );\
-    va_end( args );\
-}
-
 void reiserfs_warning(struct super_block *sb, const char *fmt, ...)
 {
-	do_reiserfs_warning(fmt);
+	va_list args;
+	va_start(args, fmt);
+
 	if (sb)
-		printk(KERN_WARNING "ReiserFS: %s: warning: %s\n",
-		       reiserfs_bdevname(sb), error_buf);
+		printk(KERN_WARNING "REISERFS warning (device %s): ",
+		       sb->s_id);
 	else
-		printk(KERN_WARNING "ReiserFS: warning: %s\n", error_buf);
+		printk(KERN_WARNING "REISERFS warning: ");
+
+	evprintk(reiserfs_sprintf_types, fmt, args);
+	va_end(args);
 }
 
 /* No newline.. reiserfs_info calls can be followed by printk's */
 void reiserfs_info(struct super_block *sb, const char *fmt, ...)
 {
-	do_reiserfs_warning(fmt);
+	va_list args;
+	va_start(args, fmt);
+
 	if (sb)
-		printk(KERN_NOTICE "ReiserFS: %s: %s",
-		       reiserfs_bdevname(sb), error_buf);
+		printk(KERN_INFO "REISERFS (device %s): ", sb->s_id);
 	else
-		printk(KERN_NOTICE "ReiserFS: %s", error_buf);
+		printk(KERN_INFO "REISERFS: ");
+
+	evprintk(reiserfs_sprintf_types, fmt, args);
+	va_end(args);
 }
 
 /* No newline.. reiserfs_printk calls can be followed by printk's */
 static void reiserfs_printk(const char *fmt, ...)
 {
-	do_reiserfs_warning(fmt);
-	printk(error_buf);
+	va_list args;
+	va_start(args, fmt);
+	evprintk(reiserfs_sprintf_types, fmt, args);
+	va_end(args);
 }
 
 void reiserfs_debug(struct super_block *s, int level, const char *fmt, ...)
 {
 #ifdef CONFIG_REISERFS_CHECK
-	do_reiserfs_warning(fmt);
+	va_list args;
+	va_start(args, fmt);
 	if (s)
-		printk(KERN_DEBUG "ReiserFS: %s: %s\n",
-		       reiserfs_bdevname(s), error_buf);
+		printk(KERN_DEBUG "REISERFS debug (device %s): ", s->s_id);
 	else
-		printk(KERN_DEBUG "ReiserFS: %s\n", error_buf);
+		printk(KERN_DEBUG "REISERFS debug: ");
+
+	evprintk(reiserfs_sprintf_types, fmt, args);
 #endif
 }
 
@@ -355,28 +326,34 @@ extern struct tree_balance *cur_tb;
 
 void reiserfs_panic(struct super_block *sb, const char *fmt, ...)
 {
-	do_reiserfs_warning(fmt);
+	va_list args;
+	va_start(args, fmt);
 
 	dump_stack();
 
-	panic(KERN_EMERG "REISERFS: panic (device %s): %s\n",
-	       reiserfs_bdevname(sb), error_buf);
+	if (sb)
+		printk(KERN_EMERG "REISERFS panic (device %s): ", sb->s_id);
+	else
+		printk(KERN_EMERG "REISERFS panic: ");
+
+	va_end(args);
+
+	panic("REISERFS panic from previous error\n");
 }
 
 void reiserfs_abort(struct super_block *sb, int errno, const char *fmt, ...)
 {
-	do_reiserfs_warning(fmt);
-
-	if (reiserfs_error_panic(sb)) {
-		panic(KERN_CRIT "REISERFS: panic (device %s): %s\n",
-		      reiserfs_bdevname(sb), error_buf);
-	}
+	va_list args;
+	va_start(args, fmt);
 
 	if (sb->s_flags & MS_RDONLY)
 		return;
 
-	printk(KERN_CRIT "REISERFS: abort (device %s): %s\n",
-	       reiserfs_bdevname(sb), error_buf);
+	printk(KERN_CRIT "REISERFS abort (device %s): ", sb->s_id);
+	evprintk(reiserfs_sprintf_types, fmt, args);
+	va_end(args);
+	if (reiserfs_error_panic(sb))
+		panic("REISERFS panic from previous error\n");
 
 	sb->s_flags |= MS_RDONLY;
 	reiserfs_journal_abort(sb, errno);
@@ -405,14 +382,16 @@ static int print_internal(struct buffer_
 		to = last < B_NR_ITEMS(bh) ? last : B_NR_ITEMS(bh);
 	}
 
-	reiserfs_printk("INTERNAL NODE (%ld) contains %z\n", bh->b_blocknr, bh);
+	reiserfs_printk("INTERNAL NODE (%ld) contains %pez\n",
+			bh->b_blocknr, bh);
 
 	dc = B_N_CHILD(bh, from);
-	reiserfs_printk("PTR %d: %y ", from, dc);
+	reiserfs_printk("PTR %d: %pey ", from, dc);
 
 	for (i = from, key = B_N_PDELIM_KEY(bh, from), dc++; i < to;
 	     i++, key++, dc++) {
-		reiserfs_printk("KEY %d: %k PTR %d: %y ", i, key, i + 1, dc);
+		reiserfs_printk("KEY %d: %pek PTR %d: %pey ",
+				i, key, i + 1, dc);
 		if (i && i % 4 == 0)
 			printk("\n");
 	}
@@ -439,10 +418,10 @@ static int print_leaf(struct buffer_head
 
 	printk
 	    ("\n===================================================================\n");
-	reiserfs_printk("LEAF NODE (%ld) contains %z\n", bh->b_blocknr, bh);
+	reiserfs_printk("LEAF NODE (%ld) contains %pez\n", bh->b_blocknr, bh);
 
 	if (!(print_mode & PRINT_LEAF_ITEMS)) {
-		reiserfs_printk("FIRST ITEM_KEY: %k, LAST ITEM KEY: %k\n",
+		reiserfs_printk("FIRST ITEM_KEY: %pek, LAST ITEM KEY: %pek\n",
 				&(ih->ih_key), &((ih + nr - 1)->ih_key));
 		return 0;
 	}
@@ -465,7 +444,7 @@ static int print_leaf(struct buffer_head
 	for (i = from; i < to; i++, ih++) {
 		printk
 		    ("-------------------------------------------------------------------------------\n");
-		reiserfs_printk("|%2d| %h |\n", i, ih);
+		reiserfs_printk("|%2d| %peh |\n", i, ih);
 		if (print_mode & PRINT_LEAF_ITEMS)
 			op_print_item(ih, B_I_PITEM(bh, ih));
 	}
@@ -682,12 +661,12 @@ static void check_leaf_block_head(struct
 	nr = blkh_nr_item(blkh);
 	if (nr > (bh->b_size - BLKH_SIZE) / IH_SIZE)
 		reiserfs_panic(NULL,
-			       "vs-6010: check_leaf_block_head: invalid item number %z",
-			       bh);
+			       "vs-6010: check_leaf_block_head: "
+			       "invalid item number %pez", bh);
 	if (blkh_free_space(blkh) > bh->b_size - BLKH_SIZE - IH_SIZE * nr)
 		reiserfs_panic(NULL,
-			       "vs-6020: check_leaf_block_head: invalid free space %z",
-			       bh);
+			       "vs-6020: check_leaf_block_head: "
+			       "invalid free space %pez", bh);
 
 }
 
@@ -698,20 +677,20 @@ static void check_internal_block_head(st
 	blkh = B_BLK_HEAD(bh);
 	if (!(B_LEVEL(bh) > DISK_LEAF_NODE_LEVEL && B_LEVEL(bh) <= MAX_HEIGHT))
 		reiserfs_panic(NULL,
-			       "vs-6025: check_internal_block_head: invalid level %z",
-			       bh);
+			       "vs-6025: check_internal_block_head: "
+			       " invalid level %pez", bh);
 
 	if (B_NR_ITEMS(bh) > (bh->b_size - BLKH_SIZE) / IH_SIZE)
 		reiserfs_panic(NULL,
-			       "vs-6030: check_internal_block_head: invalid item number %z",
-			       bh);
+			       "vs-6030: check_internal_block_head: "
+			       "invalid item number %pez", bh);
 
 	if (B_FREE_SPACE(bh) !=
 	    bh->b_size - BLKH_SIZE - KEY_SIZE * B_NR_ITEMS(bh) -
 	    DC_SIZE * (B_NR_ITEMS(bh) + 1))
 		reiserfs_panic(NULL,
-			       "vs-6040: check_internal_block_head: invalid free space %z",
-			       bh);
+			       "vs-6040: check_internal_block_head: "
+			       "invalid free space %pez", bh);
 
 }
 
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -61,7 +61,8 @@ inline int B_IS_IN_TREE(const struct buf
 {
 
 	RFALSE(B_LEVEL(p_s_bh) > MAX_HEIGHT,
-	       "PAP-1010: block (%b) has too big level (%z)", p_s_bh, p_s_bh);
+	       "PAP-1010: block (%peb) has too big level (%pez)",
+	       p_s_bh, p_s_bh);
 
 	return (B_LEVEL(p_s_bh) != FREE_LEVEL);
 }
@@ -366,9 +367,8 @@ inline void decrement_bcount(struct buff
 			put_bh(p_s_bh);
 			return;
 		}
-		reiserfs_panic(NULL,
-			       "PAP-5070: decrement_bcount: trying to free free buffer %b",
-			       p_s_bh);
+		reiserfs_panic(NULL, "PAP-5070: decrement_bcount: trying to "
+			       "free free buffer %peb", p_s_bh);
 	}
 }
 
@@ -452,14 +452,15 @@ static int is_leaf(char *buf, int blocks
 	nr = blkh_nr_item(blkh);
 	if (nr < 1 || nr > ((blocksize - BLKH_SIZE) / (IH_SIZE + MIN_ITEM_LEN))) {
 		/* item number is too big or too small */
-		reiserfs_warning(NULL, "is_leaf: nr_item seems wrong: %z", bh);
+		reiserfs_warning(NULL, "is_leaf: nr_item seems wrong: %pez",
+				 bh);
 		return 0;
 	}
 	ih = (struct item_head *)(buf + BLKH_SIZE) + nr - 1;
 	used_space = BLKH_SIZE + IH_SIZE * nr + (blocksize - ih_location(ih));
 	if (used_space != blocksize - blkh_free_space(blkh)) {
 		/* free space does not match to calculated amount of use space */
-		reiserfs_warning(NULL, "is_leaf: free space seems wrong: %z",
+		reiserfs_warning(NULL, "is_leaf: free space seems wrong: %pez",
 				 bh);
 		return 0;
 	}
@@ -471,29 +472,25 @@ static int is_leaf(char *buf, int blocks
 	prev_location = blocksize;
 	for (i = 0; i < nr; i++, ih++) {
 		if (le_ih_k_type(ih) == TYPE_ANY) {
-			reiserfs_warning(NULL,
-					 "is_leaf: wrong item type for item %h",
-					 ih);
+			reiserfs_warning(NULL, "is_leaf: wrong item type for "
+					 "item %peh", ih);
 			return 0;
 		}
 		if (ih_location(ih) >= blocksize
 		    || ih_location(ih) < IH_SIZE * nr) {
-			reiserfs_warning(NULL,
-					 "is_leaf: item location seems wrong: %h",
-					 ih);
+			reiserfs_warning(NULL, "is_leaf: item location seems "
+					 "wrong: %peh", ih);
 			return 0;
 		}
 		if (ih_item_len(ih) < 1
 		    || ih_item_len(ih) > MAX_ITEM_LEN(blocksize)) {
-			reiserfs_warning(NULL,
-					 "is_leaf: item length seems wrong: %h",
-					 ih);
+			reiserfs_warning(NULL, "is_leaf: item length seems "
+					 "wrong: %peh", ih);
 			return 0;
 		}
 		if (prev_location - ih_location(ih) != ih_item_len(ih)) {
-			reiserfs_warning(NULL,
-					 "is_leaf: item location seems wrong (second one): %h",
-					 ih);
+			reiserfs_warning(NULL, "is_leaf: item location seems "
+					 "wrong (second one): %peh", ih);
 			return 0;
 		}
 		prev_location = ih_location(ih);
@@ -523,15 +520,15 @@ static int is_internal(char *buf, int bl
 	if (nr > (blocksize - BLKH_SIZE - DC_SIZE) / (KEY_SIZE + DC_SIZE)) {
 		/* for internal which is not root we might check min number of keys */
 		reiserfs_warning(NULL,
-				 "is_internal: number of key seems wrong: %z",
+				 "is_internal: number of key seems wrong: %pez",
 				 bh);
 		return 0;
 	}
 
 	used_space = BLKH_SIZE + KEY_SIZE * nr + DC_SIZE * (nr + 1);
 	if (used_space != blocksize - blkh_free_space(blkh)) {
-		reiserfs_warning(NULL,
-				 "is_internal: free space seems wrong: %z", bh);
+		reiserfs_warning(NULL, "is_internal: free space seems wrong: "
+				 "%pez", bh);
 		return 0;
 	}
 	// one may imagine much more checks
@@ -543,8 +540,8 @@ static int is_internal(char *buf, int bl
 static int is_tree_node(struct buffer_head *bh, int level)
 {
 	if (B_LEVEL(bh) != level) {
-		reiserfs_warning(NULL,
-				 "is_tree_node: node level %d does not match to the expected one %d",
+		reiserfs_warning(NULL, "is_tree_node: node level %d does "
+				 "not match to the expected one %d",
 				 B_LEVEL(bh), level);
 		return 0;
 	}
@@ -647,7 +644,7 @@ int search_by_key(struct super_block *p_
 		if (!(++n_repeat_counter % 50000))
 			reiserfs_warning(p_s_sb, "PAP-5100: search_by_key: %s:"
 					 "there were %d iterations of while loop "
-					 "looking for key %K",
+					 "looking for key %peK",
 					 current->comm, n_repeat_counter,
 					 p_s_key);
 #endif
@@ -960,7 +957,8 @@ static inline int prepare_for_direntry_i
 	if (le_ih_k_offset(le_ih) == DOT_OFFSET &&
 	    new_file_length == max_reiserfs_offset(inode)) {
 		RFALSE(ih_entry_count(le_ih) != 2,
-		       "PAP-5220: incorrect empty directory item (%h)", le_ih);
+		       "PAP-5220: incorrect empty directory item (%peh)",
+		       le_ih);
 		*cut_size = -(IH_SIZE + ih_item_len(le_ih));
 		return M_DELETE;	/* Delete the directory item containing "." and ".." entry. */
 	}
@@ -1229,7 +1227,7 @@ int reiserfs_delete_item(struct reiserfs
 		if (n_ret_value == FILE_NOT_FOUND) {
 			reiserfs_warning(p_s_sb,
 					 "vs-5340: reiserfs_delete_item: "
-					 "no items of the file %K found",
+					 "no items of the file %peK found",
 					 p_s_item_key);
 			break;
 		}
@@ -1339,9 +1337,9 @@ void reiserfs_delete_solid_item(struct r
 		retval = search_item(th->t_super, &cpu_key, &path);
 		if (retval == IO_ERROR) {
 			reiserfs_warning(th->t_super,
-					 "vs-5350: reiserfs_delete_solid_item: "
-					 "i/o failure occurred trying to delete %K",
-					 &cpu_key);
+				 "vs-5350: reiserfs_delete_solid_item: "
+				 "i/o failure occurred trying to delete %peK",
+				 &cpu_key);
 			break;
 		}
 		if (retval != ITEM_FOUND) {
@@ -1355,9 +1353,9 @@ void reiserfs_delete_solid_item(struct r
 			     GET_GENERATION_NUMBER(le_key_k_offset
 						   (le_key_version(key),
 						    key)) == 1))
-				reiserfs_warning(th->t_super,
-						 "vs-5355: reiserfs_delete_solid_item: %k not found",
-						 key);
+				reiserfs_warning(th->t_super, "vs-5355: "
+					"reiserfs_delete_solid_item: "
+					"%pek not found", key);
 			break;
 		}
 		if (!tb_init) {
@@ -1391,8 +1389,8 @@ void reiserfs_delete_solid_item(struct r
 		// IO_ERROR, NO_DISK_SPACE, etc
 		reiserfs_warning(th->t_super,
 				 "vs-5360: reiserfs_delete_solid_item: "
-				 "could not delete %K due to fix_nodes failure",
-				 &cpu_key);
+				 "could not delete %peK due to fix_nodes "
+				 "failure", &cpu_key);
 		unfix_nodes(&tb);
 		break;
 	}
@@ -1615,9 +1613,10 @@ int reiserfs_cut_from_item(struct reiser
 				print_block(PATH_PLAST_BUFFER(p_s_path), 3,
 					    PATH_LAST_POSITION(p_s_path) - 1,
 					    PATH_LAST_POSITION(p_s_path) + 1);
-				reiserfs_panic(p_s_sb,
-					       "PAP-5580: reiserfs_cut_from_item: item to convert does not exist (%K)",
-					       p_s_item_key);
+				reiserfs_panic(p_s_sb, "PAP-5580: "
+					"reiserfs_cut_from_item: item to "
+					"convert does not exist (%peK)",
+					p_s_item_key);
 			}
 			continue;
 		}
@@ -1639,9 +1638,8 @@ int reiserfs_cut_from_item(struct reiser
 		if (n_ret_value == POSITION_FOUND)
 			continue;
 
-		reiserfs_warning(p_s_sb,
-				 "PAP-5610: reiserfs_cut_from_item: item %K not found",
-				 p_s_item_key);
+		reiserfs_warning(p_s_sb, "PAP-5610: reiserfs_cut_from_item: "
+				 "item %peK not found", p_s_item_key);
 		unfix_nodes(&s_cut_balance);
 		return (n_ret_value == IO_ERROR) ? -EIO : -ENOENT;
 	}			/* while */
@@ -1698,20 +1696,22 @@ int reiserfs_cut_from_item(struct reiser
 		if (!is_indirect_le_ih(le_ih))
 			reiserfs_panic(p_s_sb,
 				       "vs-5652: reiserfs_cut_from_item: "
-				       "item must be indirect %h", le_ih);
+				       "item must be indirect %peh", le_ih);
 
 		if (c_mode == M_DELETE && ih_item_len(le_ih) != UNFM_P_SIZE)
 			reiserfs_panic(p_s_sb,
 				       "vs-5653: reiserfs_cut_from_item: "
-				       "completing indirect2direct conversion indirect item %h "
-				       "being deleted must be of 4 byte long",
-				       le_ih);
+				       "completing indirect2direct conversion "
+				       "indirect item %peh being deleted must "
+				       "be of 4 byte long", le_ih);
 
 		if (c_mode == M_CUT
 		    && s_cut_balance.insert_size[0] != -UNFM_P_SIZE) {
 			reiserfs_panic(p_s_sb,
 				       "vs-5654: reiserfs_cut_from_item: "
-				       "can not complete indirect2direct conversion of %h (CUT, insert_size==%d)",
+				       "can not complete indirect2direct "
+				       "conversion of %peh "
+				       "(CUT, insert_size==%d)",
 				       le_ih, s_cut_balance.insert_size[0]);
 		}
 		/* it would be useful to make sure, that right neighboring
@@ -1799,7 +1799,7 @@ int reiserfs_do_truncate(struct reiserfs
 	if (retval == IO_ERROR) {
 		reiserfs_warning(p_s_inode->i_sb,
 				 "vs-5657: reiserfs_do_truncate: "
-				 "i/o failure occurred trying to truncate %K",
+				 "i/o failure occurred trying to truncate %peK",
 				 &s_item_key);
 		err = -EIO;
 		goto out;
@@ -1807,7 +1807,7 @@ int reiserfs_do_truncate(struct reiserfs
 	if (retval == POSITION_FOUND || retval == FILE_NOT_FOUND) {
 		reiserfs_warning(p_s_inode->i_sb,
 				 "PAP-5660: reiserfs_do_truncate: "
-				 "wrong result %d of search for %K", retval,
+				 "wrong result %d of search for %peK", retval,
 				 &s_item_key);
 
 		err = -EIO;
@@ -1857,7 +1857,8 @@ int reiserfs_do_truncate(struct reiserfs
 		}
 
 		RFALSE(n_deleted > n_file_size,
-		       "PAP-5670: reiserfs_cut_from_item: too many bytes deleted: deleted %d, file_size %lu, item_key %K",
+		       "PAP-5670: reiserfs_cut_from_item: too many bytes "
+		       "deleted: deleted %d, file_size %lu, item_key %peK",
 		       n_deleted, n_file_size, &s_item_key);
 
 		/* Change key to search the last file item. */
@@ -1929,9 +1930,10 @@ static void check_research_for_paste(str
 		    || op_bytes_number(found_ih,
 				       get_last_bh(path)->b_size) !=
 		    pos_in_item(path))
-			reiserfs_panic(NULL,
-				       "PAP-5720: check_research_for_paste: "
-				       "found direct item %h or position (%d) does not match to key %K",
+			reiserfs_panic(NULL, "PAP-5720: "
+				       "check_research_for_paste: found "
+				       "direct item %peh or position (%d) "
+				       "does not match to key %peK",
 				       found_ih, pos_in_item(path), p_s_key);
 	}
 	if (is_indirect_le_ih(found_ih)) {
@@ -1941,9 +1943,11 @@ static void check_research_for_paste(str
 		    cpu_key_k_offset(p_s_key)
 		    || I_UNFM_NUM(found_ih) != pos_in_item(path)
 		    || get_ih_free_space(found_ih) != 0)
-			reiserfs_panic(NULL,
-				       "PAP-5730: check_research_for_paste: "
-				       "found indirect item (%h) or position (%d) does not match to key (%K)",
+			reiserfs_panic(NULL, "PAP-5730: "
+				       "check_research_for_paste: "
+				       "found indirect item (%peh) or "
+				       "position (%d) does not match to "
+				       "key (%peK)",
 				       found_ih, pos_in_item(path), p_s_key);
 	}
 }
@@ -2000,8 +2004,9 @@ int reiserfs_paste_into_item(struct reis
 			goto error_out;
 		}
 		if (retval == POSITION_FOUND) {
-			reiserfs_warning(inode->i_sb,
-					 "PAP-5710: reiserfs_paste_into_item: entry or pasted byte (%K) exists",
+			reiserfs_warning(inode->i_sb, "PAP-5710: "
+					 "reiserfs_paste_into_item: "
+					 "entry or pasted byte (%peK) exists",
 					 p_s_key);
 			retval = -EEXIST;
 			goto error_out;
@@ -2089,7 +2094,7 @@ int reiserfs_insert_item(struct reiserfs
 		if (retval == ITEM_FOUND) {
 			reiserfs_warning(th->t_super,
 					 "PAP-5760: reiserfs_insert_item: "
-					 "key %K already exists in the tree",
+					 "key %peK already exists in the tree",
 					 key);
 			retval = -EEXIST;
 			goto error_out;
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -235,18 +235,16 @@ static int finish_unfinished(struct supe
 		if (!inode) {
 			/* the unlink almost completed, it just did not manage to remove
 			   "save" link and release objectid */
-			reiserfs_warning(s,
-					 "vs-2180: finish_unfinished: iget failed for %K",
-					 &obj_key);
+			reiserfs_warning(s, "vs-2180: finish_unfinished: "
+					 "iget failed for %peK", &obj_key);
 			retval = remove_save_link_only(s, &save_link_key, 1);
 			continue;
 		}
 
 		if (!truncate && inode->i_nlink) {
 			/* file is not unlinked */
-			reiserfs_warning(s,
-					 "vs-2185: finish_unfinished: file %K is not unlinked",
-					 &obj_key);
+			reiserfs_warning(s, "vs-2185: finish_unfinished: "
+					 "file %peK is not unlinked", &obj_key);
 			retval = remove_save_link_only(s, &save_link_key, 0);
 			continue;
 		}
@@ -257,8 +255,8 @@ static int finish_unfinished(struct supe
 			   The only imaginable way is to execute unfinished truncate request
 			   then boot into old kernel, remove the file and create dir with
 			   the same key. */
-			reiserfs_warning(s,
-					 "green-2101: impossible truncate on a directory %k. Please report",
+			reiserfs_warning(s, "green-2101: impossible truncate "
+					 "on a directory %pek. Please report",
 					 INODE_PKEY(inode));
 			retval = remove_save_link_only(s, &save_link_key, 0);
 			truncate = 0;
@@ -271,7 +269,7 @@ static int finish_unfinished(struct supe
 			    i_link_saved_truncate_mask;
 			/* not completed truncate found. New size was committed together
 			   with "save" link */
-			reiserfs_info(s, "Truncating %k to %Ld ..",
+			reiserfs_info(s, "Truncating %pek to %lld ..",
 				      INODE_PKEY(inode), inode->i_size);
 			reiserfs_truncate_file(inode,
 					       0
@@ -281,7 +279,7 @@ static int finish_unfinished(struct supe
 		} else {
 			REISERFS_I(inode)->i_flags |= i_link_saved_unlink_mask;
 			/* not completed unlink (rmdir) found */
-			reiserfs_info(s, "Removing %k..", INODE_PKEY(inode));
+			reiserfs_info(s, "Removing %pek..", INODE_PKEY(inode));
 			if (memcmp(&last_inode_key, INODE_PKEY(inode),
 					sizeof(last_inode_key))){
 				last_inode_key = *INODE_PKEY(inode);
@@ -360,8 +358,9 @@ void add_save_link(struct reiserfs_trans
 	} else {
 		/* truncate */
 		if (S_ISDIR(inode->i_mode))
-			reiserfs_warning(inode->i_sb,
-					 "green-2102: Adding a truncate savelink for a directory %k! Please report",
+			reiserfs_warning(inode->i_sb, "green-2102: Adding a "
+					 "truncate savelink for a directory "
+					 "%pek! Please report",
 					 INODE_PKEY(inode));
 		set_cpu_key_k_offset(&key, 1);
 		set_cpu_key_k_type(&key, TYPE_INDIRECT);
@@ -377,8 +376,8 @@ void add_save_link(struct reiserfs_trans
 	if (retval != ITEM_NOT_FOUND) {
 		if (retval != -ENOSPC)
 			reiserfs_warning(inode->i_sb, "vs-2100: add_save_link:"
-					 "search_by_key (%K) returned %d", &key,
-					 retval);
+					 "search_by_key (%peK) returned %d",
+					 &key, retval);
 		pathrelse(&path);
 		return;
 	}
--- a/fs/reiserfs/tail_conversion.c
+++ b/fs/reiserfs/tail_conversion.c
@@ -48,8 +48,8 @@ int direct2indirect(struct reiserfs_tran
 
 	// FIXME: we could avoid this 
 	if (search_for_position_by_key(sb, &end_key, path) == POSITION_FOUND) {
-		reiserfs_warning(sb, "PAP-14030: direct2indirect: "
-				 "pasted or inserted byte exists in the tree %K. "
+		reiserfs_warning(sb, "PAP-14030: direct2indirect: pasted or "
+				 "inserted byte exists in the tree %peK. "
 				 "Use fsck to repair.", &end_key);
 		pathrelse(path);
 		return -EIO;
@@ -92,12 +92,12 @@ int direct2indirect(struct reiserfs_tran
 		   last item of the file */
 		if (search_for_position_by_key(sb, &end_key, path) ==
 		    POSITION_FOUND)
-			reiserfs_panic(sb,
-				       "PAP-14050: direct2indirect: "
-				       "direct item (%K) not found", &end_key);
+			reiserfs_panic(sb, "PAP-14050: direct2indirect: "
+				       "direct item (%peK) not found",
+				       &end_key);
 		p_le_ih = PATH_PITEM_HEAD(path);
 		RFALSE(!is_direct_le_ih(p_le_ih),
-		       "vs-14055: direct item expected(%K), found %h",
+		       "vs-14055: direct item expected(%peK), found %peh",
 		       &end_key, p_le_ih);
 		tail_size = (le_ih_k_offset(p_le_ih) & (n_blk_size - 1))
 		    + ih_item_len(p_le_ih) - 1;
@@ -214,10 +214,9 @@ int indirect2direct(struct reiserfs_tran
 		/* re-search indirect item */
 		if (search_for_position_by_key(p_s_sb, p_s_item_key, p_s_path)
 		    == POSITION_NOT_FOUND)
-			reiserfs_panic(p_s_sb,
-				       "PAP-5520: indirect2direct: "
-				       "item to be converted %K does not exist",
-				       p_s_item_key);
+			reiserfs_panic(p_s_sb, "PAP-5520: indirect2direct: "
+				       "item to be converted %peK does not "
+				       "exist", p_s_item_key);
 		copy_item_head(&s_ih, PATH_PITEM_HEAD(p_s_path));
 #ifdef CONFIG_REISERFS_CHECK
 		pos = le_ih_k_offset(&s_ih) - 1 +
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -259,15 +259,15 @@ static int __xattr_readdir(struct inode
 		ih = de.de_ih;
 
 		if (!is_direntry_le_ih(ih)) {
-			reiserfs_warning(inode->i_sb, "not direntry %h", ih);
+			reiserfs_warning(inode->i_sb, "not direntry %peh", ih);
 			break;
 		}
 		copy_item_head(&tmp_ih, ih);
 
 		/* we must have found item, that is item of this directory, */
 		RFALSE(COMP_SHORT_KEYS(&(ih->ih_key), &pos_key),
-		       "vs-9000: found item %h does not match to dir we readdir %K",
-		       ih, &pos_key);
+		       "vs-9000: found item %peh does not match to "
+		       "dir we readdir %peK", ih, &pos_key);
 
 		if (deh_offset(deh) <= DOT_DOT_OFFSET) {
 			break;
@@ -600,7 +600,7 @@ reiserfs_xattr_get(const struct inode *i
 				reiserfs_put_page(page);
 				reiserfs_warning(inode->i_sb,
 						 "Invalid magic for xattr (%s) "
-						 "associated with %k", name,
+						 "associated with %pek", name,
 						 INODE_PKEY(inode));
 				err = -EIO;
 				goto out_dput;
@@ -620,7 +620,7 @@ reiserfs_xattr_get(const struct inode *i
 	    hash) {
 		reiserfs_warning(inode->i_sb,
 				 "Invalid hash for xattr (%s) associated "
-				 "with %k", name, INODE_PKEY(inode));
+				 "with %pek", name, INODE_PKEY(inode));
 		err = -EIO;
 	}
 
-- 
Jeff Mahoney
SUSE Labs
