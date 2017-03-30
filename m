Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65168 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752556AbdC3Gc4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Mar 2017 02:32:56 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <bo.li.liu@oracle.com>
Subject: [PATCH v4 0/5] raid56: scrub related fixes
Date: Thu, 30 Mar 2017 14:32:46 +0800
Message-ID: <20170330063251.16872-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from my github repo:
https://github.com/adam900710/linux.git raid56_fixes

It's based on v4.11-rc2, the last two patches get modified according to
the advice from Liu Bo.

The patchset fixes the following bugs:

1) False alert or wrong csum error number when scrubbing RAID5/6
   The bug itself won't cause any damage to fs, just pure race.

   This can be triggered by running scrub for 64K corrupted data stripe,
   Normally it will report 16 csum error recovered, but sometimes it
   will report more than 16 csum error recovered, under rare case, even
   unrecoverable error an be reported.

2) Corrupted data stripe rebuild corrupts P/Q
   So scrub makes one error into another, not really fixing anything

   Since kernel scrub doesn't report parity error, so either offline
   scrub or manual check is needed to expose such error.

3) Use-after-free caused by cancelling dev-replace 
   This is quite a deadly bug, since cancelling dev-replace can
   cause kernel panic.

   Can be triggered by btrfs/069.

v2:
  Use bio_counter to protect rbio against dev-replace cancel, instead of
  original btrfs_device refcount, which is too restrict and must disable
  rbio cache, suggested by Liu Bo.

v3:
  Add fix for another possible use-after-free when rechecking recovered
  full stripe
  Squashing two patches as they are fixing the same problem, to make
  bisect easier.
  Use mutex other than spinlock to protect full stripe locks tree, this
  allow us to allocate memory inside the critical section on demand.
  Encapsulate rb_root and mutex into btrfs_full_stripe_locks_tree.
  Rename scrub_full_stripe_lock to full_stripe_lock inside scrub.c.
  Rename related function to have unified naming.
  Code style change to follow the existing scrub code style.

v4:
  Variant gramma fixes for commit message and comment, suggested by
  Liu Bo.
  Use bullet-proof method to get full stripe logical start,
  suggested by Liu Bo
  Warn when we failed to get block group cache during
  lock_full_stripe(), suggested by Liu Bo.
  Add a shortcut to avoid searching block group cache unlocking full
  stripe, suggested by Liu Bo.

Qu Wenruo (5):
  btrfs: scrub: Introduce full stripe lock for RAID56
  btrfs: scrub: Fix RAID56 recovery race condition
  btrfs: scrub: Don't append on-disk pages for raid56 scrub
  btrfs: Wait flighting bio before freeing target device for raid56
  btrfs: Prevent scrub recheck from racing with dev replace

 fs/btrfs/ctree.h       |  17 ++++
 fs/btrfs/dev-replace.c |   2 +
 fs/btrfs/extent-tree.c |  11 +++
 fs/btrfs/raid56.c      |  14 +++
 fs/btrfs/scrub.c       | 262 +++++++++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 298 insertions(+), 8 deletions(-)

-- 
2.12.1



