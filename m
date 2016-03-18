Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26512 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbcCRFih (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 01:38:37 -0400
Date: Fri, 18 Mar 2016 08:38:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jbacik@fb.com
Cc: linux-btrfs@vger.kernel.org
Subject: re: Btrfs: remove empty block groups automatically
Message-ID: <20160318053828.GC2111@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef Bacik,

The patch 47ab2a6c6899: "Btrfs: remove empty block groups
automatically" from Sep 18, 2014, leads to the following static
checker warning:

	fs/btrfs/extent-tree.c:10584 btrfs_delete_unused_bgs()
	warn: 'ret' can be either negative or positive

The warning here is because we treat positives and negatives as error
codes where normally the kernel uses negative error codes.

fs/btrfs/volumes.c
  1450  static int btrfs_free_dev_extent(struct btrfs_trans_handle *trans,
  1451                            struct btrfs_device *device,
  1452                            u64 start, u64 *dev_extent_len)
  1453  {
  1454          int ret;
  1455          struct btrfs_path *path;
  1456          struct btrfs_root *root = device->dev_root;
  1457          struct btrfs_key key;
  1458          struct btrfs_key found_key;
  1459          struct extent_buffer *leaf = NULL;
  1460          struct btrfs_dev_extent *extent = NULL;
  1461  
  1462          path = btrfs_alloc_path();
  1463          if (!path)
  1464                  return -ENOMEM;
  1465  
  1466          key.objectid = device->devid;
  1467          key.offset = start;
  1468          key.type = BTRFS_DEV_EXTENT_KEY;
  1469  again:
  1470          ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
  1471          if (ret > 0) {
  1472                  ret = btrfs_previous_item(root, path, key.objectid,
  1473                                            BTRFS_DEV_EXTENT_KEY);


btrfs_previous_item() returns 0 if something is found, 1 if nothing was
found and < 0 on error.  We propogate the 1 to other callers who treat
it like an error code but it's not documented what the 1 means.

  1474                  if (ret)
  1475                          goto out;
  1476                  leaf = path->nodes[0];
  1477                  btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
  1478                  extent = btrfs_item_ptr(leaf, path->slots[0],

regards,
dan carpenter
