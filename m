Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58978 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754620AbdHVHhZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 03:37:25 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/3] Introduce comprehensive sanity check framework and
Date: Tue, 22 Aug 2017 16:37:14 +0900
Message-Id: <20170822073717.13081-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset introduce a new framework to do more comprehensive (if not
the most) sanity check when reading out a leaf.

The new sanity checker will include:

1) Key order
   Existing code

2) Item boundary
   Existing code with enhanced checker to ensure item pointer doesn't
   overlap with item itself.

3) Key type based sanity checker
   Only EXTENT_DATA checker is implemented yet.
   As each checker should go through review and tests, or it can easily
   make a valid btrfs failed to be mounted.
   So only one checker is implemented as an example.

   Existing checker like INODE_REF checker can be moved to this
   framework easily, and we can centralize all existing checkers, make
   the rest of codes more clean.

Performance wise, it's just iterating a leaf.
And it will only get triggered when read out a leaf, cached leaf will
not go through such checker.
So it won't be a performance breaker.

I tested with the patchset applied on v4.13-rc6 with fstests, no
regression is detected.

Qu Wenruo (3):
  btrfs: Refactor check_leaf function for later expansion.
  btrfs: Check if item pointer overlap with item itself
  btrfs: Add sanity check for EXTENT_DATA when reading out leaf

 fs/btrfs/disk-io.c              | 137 ++++++++++++++++++++++++++++++++++------
 include/uapi/linux/btrfs_tree.h |   1 +
 2 files changed, 119 insertions(+), 19 deletions(-)

-- 
2.14.1

