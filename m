Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbbBYSYd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Feb 2015 13:24:33 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, clm@fb.com
Subject: [PULL] [PATCH 00/11] Cleanups for 4.1
Date: Wed, 25 Feb 2015 19:24:31 +0100
Message-Id: <cover.1424880058.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a few cleanups that accumulated over time. No real fixes but there are changes
that may touch functionality (no fstests complaints though).

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git cleanups-for-4.1

all merged together, but are also available in the following topic branches
based on current for-linus branch.

cleanup/sched
cleanup/divs
cleanup/kmalloc-array
cleanup/shadow-vars
cleanup/initializers

David Sterba (11):
  btrfs: need_resched not needed with cond_resched
  btrfs: use cond_resched_lock where possible
  btrfs: cleanup 64bit/32bit divs, compile time constants
  btrfs: cleanup 64bit/32bit divs, provably bounded values
  btrfs: replace remaining do_div calls with div_u64 variants
  btrfs: cleanup, use correct type in div_u64_rem
  btrfs: cleanup, use kmalloc_array/kcalloc array helpers
  btrfs: remove shadowing variables in __btrfs_buffered_write
  btrfs: switch helper macros to static inlines in sysfs.h
  btrfs: remove shadowing variables in __btrfs_map_block
  btrfs: use explicit initializer for seq_elem

 fs/btrfs/backref.c          |  4 +--
 fs/btrfs/check-integrity.c  |  4 +--
 fs/btrfs/compression.c      |  2 +-
 fs/btrfs/ctree.c            |  9 +++--
 fs/btrfs/ctree.h            |  2 ++
 fs/btrfs/dev-replace.c      |  6 ++--
 fs/btrfs/disk-io.c          |  4 +--
 fs/btrfs/extent-tree.c      | 21 ++++++------
 fs/btrfs/file-item.c        |  4 +--
 fs/btrfs/file.c             | 12 +++----
 fs/btrfs/free-space-cache.c | 34 ++++++++-----------
 fs/btrfs/inode.c            |  2 +-
 fs/btrfs/ioctl.c            |  4 +--
 fs/btrfs/math.h             |  6 ++--
 fs/btrfs/qgroup.c           |  6 ++--
 fs/btrfs/raid56.c           |  3 +-
 fs/btrfs/scrub.c            | 23 ++++++-------
 fs/btrfs/super.c            |  2 +-
 fs/btrfs/sysfs.h            | 22 ++++++++++---
 fs/btrfs/transaction.c      |  7 ++--
 fs/btrfs/volumes.c          | 80 ++++++++++++++++++++++-----------------------
 21 files changed, 125 insertions(+), 132 deletions(-)

-- 
2.1.3

