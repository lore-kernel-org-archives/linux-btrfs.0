Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39655 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbbBAUvi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Feb 2015 15:51:38 -0500
Date: Sun, 1 Feb 2015 23:51:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mfasheh@suse.de
Cc: linux-btrfs@vger.kernel.org
Subject: re: btrfs: qgroup: account shared subtrees during snapshot delete
Message-ID: <20150201205119.GB29298@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Mark Fasheh,

The patch 1152651a0817: "btrfs: qgroup: account shared subtrees
during snapshot delete" from Jul 17, 2014, leads to the following
static checker warning:

	fs/btrfs/extent-tree.c:7642 account_shared_subtree()
	error: off-by-one overflow 'path->nodes' size 8.  index range = '1-8'

fs/btrfs/extent-tree.c
  7611          BUG_ON(root_level < 0 || root_level > BTRFS_MAX_LEVEL);

At first I thought that I could just change this > to >= to fix this
warning.

  7612          BUG_ON(root_eb == NULL);
  7613  
  7614          if (!root->fs_info->quota_enabled)
  7615                  return 0;
  7616  
  7617          if (!extent_buffer_uptodate(root_eb)) {
  7618                  ret = btrfs_read_buffer(root_eb, root_gen);
  7619                  if (ret)
  7620                          goto out;
  7621          }
  7622  
  7623          if (root_level == 0) {
  7624                  ret = account_leaf_items(trans, root, root_eb);
  7625                  goto out;
  7626          }
  7627  
  7628          path = btrfs_alloc_path();
  7629          if (!path)
  7630                  return -ENOMEM;
  7631  
  7632          /*
  7633           * Walk down the tree.  Missing extent blocks are filled in as
  7634           * we go. Metadata is accounted every time we read a new
  7635           * extent block.
  7636           *
  7637           * When we reach a leaf, we account for file extent items in it,
  7638           * walk back up the tree (adjusting slot pointers as we go)
  7639           * and restart the search process.
  7640           */
  7641          extent_buffer_get(root_eb); /* For path */
  7642          path->nodes[root_level] = root_eb;

->nodes[] has BTRFS_MAX_LEVEL elements.

  7643          path->slots[root_level] = 0;
  7644          path->locks[root_level] = 0; /* so release_path doesn't try to unlock */
  7645  walk_down:
  7646          level = root_level;
  7647          while (level >= 0) {
  7648                  if (path->nodes[level] == NULL) {
  7649                          int parent_slot;
  7650                          u64 child_gen;
  7651                          u64 child_bytenr;
  7652  
  7653                          /* We need to get child blockptr/gen from
  7654                           * parent before we can read it. */
  7655                          eb = path->nodes[level + 1];
                                         ^^^^^^^^^^^^^^^^^^
But when I changed that, then it introduced a warning here because we
add one.  I'm not sure what to do.

  7656                          parent_slot = path->slots[level + 1];
  7657                          child_bytenr = btrfs_node_blockptr(eb, parent_slot);
  7658                          child_gen = btrfs_node_ptr_generation(eb, parent_slot);
  7659  
  7660                          eb = read_tree_block(root, child_bytenr, child_gen);
  7661                          if (!eb || !extent_buffer_uptodate(eb)) {
  7662                                  ret = -EIO;
  7663                                  goto out;
  7664                          }
  7665  
  7666                          path->nodes[level] = eb;
  7667                          path->slots[level] = 0;
  7668  

regards,
dan carpenter
