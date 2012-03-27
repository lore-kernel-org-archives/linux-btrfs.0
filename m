From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 00/10] several fixes and cleanups
Date: Tue, 27 Mar 2012 14:44:28 +0800
Message-ID: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patchset consists of a bug fix from allocating chunk,
six bug fixes from autodefrag, and other cleanups.

I've tested it with xfstests plus autodefrag option.

Liu Bo (10):
  Btrfs: show useful info in space reservation tracepoint
  Btrfs: fix deadlock during allocating chunks
  Btrfs: fix race between direct io and autodefrag
  Btrfs: fix the mismatch of page->mapping
  Btrfs: fix recursive defragment with autodefrag option
  Btrfs: add a check to decide if we should defrag the range
  Btrfs: do not bother to defrag an extent if it is a big real extent
  Btrfs: update to the right index of defragment
  Btrfs: use PagePrivate2 to check ordered data
  Btrfs: drop cache with VACANCY em when we fail to start a transaction

 fs/btrfs/extent-tree.c |   79 ++++++++++++++++++++++++++++++++----------
 fs/btrfs/inode-map.c   |    6 +--
 fs/btrfs/inode.c       |   59 ++++++++++++-------------------
 fs/btrfs/ioctl.c       |   89 +++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/transaction.c |    3 +-
 5 files changed, 151 insertions(+), 85 deletions(-)

