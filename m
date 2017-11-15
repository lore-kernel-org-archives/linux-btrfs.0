Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43249 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933088AbdKORoF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 12:44:05 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1E01DACFC
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 17:44:04 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/6] Shrink some data structures
Date: Wed, 15 Nov 2017 18:41:52 +0100
Message-Id: <cover.1510767175.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unused members removed, other reordered.

struct btrfs_transaction:

-       /* size: 432, cachelines: 7, members: 27 */
-       /* sum members: 416, holes: 4, sum holes: 16 */
-       /* last cacheline: 48 bytes */
+       /* size: 416, cachelines: 7, members: 27 */
+       /* sum members: 412, holes: 1, sum holes: 4 */
+       /* last cacheline: 32 bytes */

struct btrfs_trans_handle:

-       /* size: 120, cachelines: 2, members: 20 */
-       /* sum members: 117, holes: 1, sum holes: 3 */
-       /* last cacheline: 56 bytes */
+       /* size: 104, cachelines: 2, members: 19 */
+       /* last cacheline: 40 bytes *

And incidentally the .text size goes down as well:

   text    data     bss     dec     hex filename
 985430   75100   18560 1079090  107732 pre/btrfs.ko
 985243   75100   18560 1078903  107677 post/btrfs.ko

David Sterba (6):
  btrfs: switch btrfs_trans_handle::adding_csums to bool
  btrfs: remove unused member of btrfs_trans_handle
  btrfs: switch to refcount_t type for btrfs_trans_handle::use_count
  btrfs: reoder btrfs_trans_handle members for better packing
  btrfs: use narrower type for btrfs_transaction::num_dirty_bgs
  btrfs: reoder btrfs_transaction members for better packing

 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/inode.c       |  4 ++--
 fs/btrfs/transaction.c | 12 ++++++------
 fs/btrfs/transaction.h | 11 +++++------
 4 files changed, 14 insertions(+), 15 deletions(-)

-- 
2.14.3

