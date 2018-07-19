Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47650 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbeGSIxT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 04:53:19 -0400
Date: Thu, 19 Jul 2018 11:10:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: gujx@cn.fujitsu.com
Cc: linux-btrfs@vger.kernel.org
Subject: [bug report] btrfs: Add type check when reading a chunk
Message-ID: <20180719081053.f46f3pmrdoia64ws@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Gu Jinxiang,

The patch 72e75ed03c8d: "btrfs: Add type check when reading a chunk"
from Jul 4, 2018, leads to the following static checker warning:

	fs/btrfs/volumes.c:6388 btrfs_check_chunk_valid()
	warn: AND to zero '0x4 & 0x1'

fs/btrfs/volumes.c
  6356          if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {
  6357                  btrfs_err(fs_info, "invalid chunk stripe length: %llu",
  6358                            stripe_len);
  6359                  return -EIO;
  6360          }
  6361          if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
  6362              type) {
  6363                  btrfs_err(fs_info, "unrecognized chunk type: %llu",
  6364                            ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
  6365                              BTRFS_BLOCK_GROUP_PROFILE_MASK) &
  6366                            btrfs_chunk_type(leaf, chunk));
  6367                  return -EIO;
  6368          }
  6369  
  6370          if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
  6371                  btrfs_err(fs_info, "missing chunk type flag: %llu", type);
  6372                  return -EIO;
  6373          }
  6374  
  6375          if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
  6376              (type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
  6377                  btrfs_err(fs_info,
  6378                          "system chunk with data or metadata type: %llu", type);
  6379                  return -EIO;
  6380          }
  6381  
  6382          features = btrfs_super_incompat_flags(fs_info->super_copy);
  6383          if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
  6384                  mixed = 1;
  6385  
  6386          if (!mixed) {
  6387                  if (type &
  6388                      (BTRFS_BLOCK_GROUP_METADATA & BTRFS_BLOCK_GROUP_DATA)) {
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Was this supposed to be | or perhaps check that both are set?

  6389                          btrfs_err(fs_info,
  6390                          "mixed chunk type in non-mixed mode: %llu", type);
  6391                          return -EIO;
  6392                  }
  6393          }

regards,
dan carpenter
