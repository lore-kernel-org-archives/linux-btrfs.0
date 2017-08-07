Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29457 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751761AbdHGW4t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Aug 2017 18:56:49 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v77MumWE006224
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v77Mulne027529
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:48 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v77Mulv7009711
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:47 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/7] add sanity check for extent inline ref type
Date: Mon,  7 Aug 2017 15:55:24 -0600
Message-Id: <20170807215531.12423-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

An invalid extent inline ref type could be read from a btrfs image and
it ends up with a panic[1], this set is to deal with the insane value
gracefully in patch 1-2 and clean up BUG() in the code in patch 3-6.

Patch 7 adds one more check to see if the ref is a valid shared one.

I'm not sure in the real world what may result in this corruption, but
I've seen several reports on the ML about __btrfs_free_extent saying
something was missing (or simply wrong), while testing this set with
btrfs-corrupt-block, I found that switching ref type could end up that
situation as well, eg. a data extent's ref type
(BTRFS_EXTENT_DATA_REF_KEY) is switched to (BTRFS_TREE_BLOCK_REF_KEY).
Hopefully this can give people more sights next time when that
happens.

[1]:https://www.spinics.net/lists/linux-btrfs/msg65646.html

v2:
- add enum type and return BTRFS_REF_TYPE_INVALID instead of -EINVAL.
- remove one more BUG_ON which is in __add_tree_block.
- add validation check for shared refs.
- improve btrfs_print_leaf to show which refs has something wrong.

Liu Bo (7):
  Btrfs: add a helper to retrive extent inline ref type
  Btrfs: convert to use btrfs_get_extent_inline_ref_type
  Btrfs: remove BUG() in btrfs_extent_inline_ref_size
  Btrfs: remove BUG() in print_extent_item
  Btrfs: remove BUG() in add_data_reference
  Btrfs: remove BUG_ON in __add_tree_block
  Btrfs: add one more sanity check for shared ref type

 fs/btrfs/backref.c     | 11 ++++--
 fs/btrfs/ctree.h       | 12 ++++++-
 fs/btrfs/extent-tree.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/print-tree.c  | 28 ++++++++++++---
 fs/btrfs/relocation.c  | 29 +++++++++++++---
 5 files changed, 155 insertions(+), 18 deletions(-)

-- 
2.9.4

