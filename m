Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54388 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403799AbeHPQJK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Aug 2018 12:09:10 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 74A93AE78
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2018 13:10:38 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/8 V2] Add delayed-refs support to btrfs-progs
Date: Thu, 16 Aug 2018 16:10:27 +0300
Message-Id: <1534425035-323-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

Here is the second version of the delayed refs for progs support. The first 
version can be found here [1]. I've taken into account all the feedback from 
Misono and have verified the code is working and rebased it atop btrfs-progs
4.17.1.

Changes since v1: 
 * Removed num_entries variable from delayed ref root
 
 * Added a patch to refactor btrfs_write_dirty_block_groups and subsequently 
 changed when this function is called to fix an issue reported by Misono. I
 verified that 'make test-fsck TEST_ENABLE_OVERRIDE=true TEST_ARGS_CHECK=--mode=lowmem'
 produces no errors

 * Added 2 patches which remove the newly added adapter functions at the 
 beggining of the series, following the wiring up of the delayed refs 
 infrastructured. The first one (dealing with __free_extent2) is trivial, while
 the second one (for alloc_reserved_tree_block2) is a bit more involved, since
 I've opted to merge the two functions. 

 * Rebased atop latest btrfs-progs release - 4.17.1

 * Dropped patches which have been merged in the mean time


[1] https://www.spinics.net/lists/linux-btrfs/msg79173.html

Nikolay Borisov (8):
  btrfs-progs: Add __free_extent2 function
  btrfs-progs: Add alloc_reserved_tree_block2 function
  btrfs-progs: Add delayed refs infrastructure
  btrfs-progs: Make btrfs_write_dirty_block_groups take only trans
    argument
  btrfs-progs: Wire up delayed refs
  btrfs-progs: Remove old delayed refs infrastructure
  btrfs-progs: Remove __free_extent2
  btrfs-progs: Merge alloc_reserved_tree_block(2|)

 Makefile      |   3 +-
 check/main.c  |   3 +-
 ctree.h       |   8 +-
 delayed-ref.c | 607 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 delayed-ref.h | 208 ++++++++++++++++++++
 disk-io.c     |   2 -
 extent-tree.c | 575 +++++++++++++++++++++++++++++++-----------------------
 kerncompat.h  |   8 +
 transaction.c |  29 ++-
 transaction.h |   4 +
 10 files changed, 1199 insertions(+), 248 deletions(-)
 create mode 100644 delayed-ref.c
 create mode 100644 delayed-ref.h

-- 
2.7.4
