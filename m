Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50548 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728823AbeIGTge (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 15:36:34 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 12148AC1F
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 14:55:16 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 00/11] Cleanup dev-replace locking
Date: Fri,  7 Sep 2018 16:54:59 +0200
Message-Id: <cover.1536331604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The series peels off the custom locking that's used for dev-replace and
uses read-write semaphore in the end.

I've mainly focused on correctness and haven't measured the performance
effects. There should be none as the blocking and waiting was merely
open coding what the rw semaphore does, but without the fairness. The
overall number of locks taken is low, there's a lots of IO in between so
even if new scheme is slower, I don't expect any dramatic change.

  git://github.com/kdave/btrfs-devel.git dev/dev-replace-locking

David Sterba (11):
  btrfs: remove btrfs_dev_replace::read_locks
  btrfs: open code btrfs_dev_replace_clear_lock_blocking
  btrfs: open code btrfs_dev_replace_stats_inc
  btrfs: open code btrfs_after_dev_replace_commit
  btrfs: dev-replace: avoid useless lock on error handling path
  btrfs: dev-replace: move replace members out of fs_info
  btrfs: dev-replace: remove pointless assert in write unlock
  btrfs: reada: reorder dev-replace locks before radix tree preload
  btrfs: dev-replace: swich locking to rw semaphore
  btrfs: dev-replace: remove custom read/write blocking scheme
  btrfs: dev-replace: open code trivial locking helpers

 fs/btrfs/ctree.h       |  11 ++--
 fs/btrfs/dev-replace.c | 136 ++++++++++++-----------------------------
 fs/btrfs/dev-replace.h |  13 ----
 fs/btrfs/disk-io.c     |  14 ++---
 fs/btrfs/reada.c       |  16 ++---
 fs/btrfs/scrub.c       |  26 ++++----
 fs/btrfs/transaction.c |   5 +-
 fs/btrfs/volumes.c     |  23 ++++---
 8 files changed, 87 insertions(+), 157 deletions(-)

-- 
2.18.0
