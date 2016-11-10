Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47459 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964923AbcKJUSs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 15:18:48 -0500
Date: Thu, 10 Nov 2016 23:18:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: quwenruo@cn.fujitsu.com
Cc: linux-btrfs@vger.kernel.org
Subject: [bug report] btrfs: Expoert and move leaf/subtree qgroup helpers to
 qgroup.c
Message-ID: <20161110201826.GA29230@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Qu Wenruo,

The patch 4c98cc4b6d12: "btrfs: Expoert and move leaf/subtree qgroup
helpers to qgroup.c" from Oct 18, 2016, leads to the following static
checker warning:

	fs/btrfs/qgroup.c:1682 btrfs_qgroup_trace_subtree()
	error: buffer overflow 'path->nodes' 8 <= 8

fs/btrfs/qgroup.c
  1641  int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
  1642                                 struct btrfs_root *root,
  1643                                 struct extent_buffer *root_eb,
  1644                                 u64 root_gen, int root_level)
  1645  {
  1646          int ret = 0;
  1647          int level;
  1648          struct extent_buffer *eb = root_eb;
  1649          struct btrfs_path *path = NULL;
  1650  
  1651          BUG_ON(root_level < 0 || root_level > BTRFS_MAX_LEVEL);

You didn't really introduce the warning, just made it show up as a new
warning by moving the code around.  Still, this should be
>= BTRFS_MAX_LEVEL shouldn't it?


  1652          BUG_ON(root_eb == NULL);
  1653  
  1654          if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &root->fs_info->flags))
  1655                  return 0;
  1656  
  1657          if (!extent_buffer_uptodate(root_eb)) {
  1658                  ret = btrfs_read_buffer(root_eb, root_gen);
  1659                  if (ret)
  1660                          goto out;
  1661          }
  1662  
  1663          if (root_level == 0) {
  1664                  ret = btrfs_qgroup_trace_leaf_items(trans, root, root_eb);
  1665                  goto out;
  1666          }
  1667  
  1668          path = btrfs_alloc_path();
  1669          if (!path)
  1670                  return -ENOMEM;
  1671  
  1672          /*
  1673           * Walk down the tree.  Missing extent blocks are filled in as
  1674           * we go. Metadata is accounted every time we read a new
  1675           * extent block.
  1676           *
  1677           * When we reach a leaf, we account for file extent items in it,
  1678           * walk back up the tree (adjusting slot pointers as we go)
  1679           * and restart the search process.
  1680           */
  1681          extent_buffer_get(root_eb); /* For path */
  1682          path->nodes[root_level] = root_eb;

Otherwise, we're off by one.

  1683          path->slots[root_level] = 0;
  1684          path->locks[root_level] = 0; /* so release_path doesn't try to unlock */
  1685  walk_down:

regards,
dan carpenter
