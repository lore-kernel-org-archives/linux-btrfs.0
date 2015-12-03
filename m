Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbbLCQ6K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 11:58:10 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PULL][PATCH 00/12] Minor cleanups and code simplifications
Date: Thu,  3 Dec 2015 17:56:19 +0100
Message-Id: <cover.1449161602.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A random set of changes that popped up during code reading. Separated for
easier review. For 4.5, please pull.

----------------------------------------------------------------
The following changes since commit 1ec218373b8ebda821aec00bb156a9c94fad9cd4:

  Linux 4.4-rc2 (2015-11-22 16:45:59 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git cleanup/misc-simplify

for you to fetch changes up to bb45445ab63fcd83950180c8d17833ca0216da64:

  btrfs: make set_range_writeback return void (2015-12-03 15:02:24 +0100)

----------------------------------------------------------------
David Sterba (12):
      btrfs: make btrfs_close_one_device static
      btrfs: sink parameter wait to btrfs_alloc_delalloc_work
      btrfs: remove wait from struct btrfs_delalloc_work
      btrfs: change how delay_iput is tracked in btrfs_delalloc_work
      btrfs: remove a trivial helper btrfs_set_buffer_uptodate
      btrfs: make set_extent_buffer_uptodate return void
      btrfs: make clear_extent_buffer_uptodate return void
      btrfs: make extent_clear_unlock_delalloc return void
      btrfs: make end_extent_writepage return void
      btrfs: make extent_range_clear_dirty_for_io return void
      btrfs: make extent_range_redirty_for_io return void
      btrfs: make set_range_writeback return void

 fs/btrfs/ctree.h       |  8 +++++---
 fs/btrfs/disk-io.c     |  5 -----
 fs/btrfs/disk-io.h     |  1 -
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/extent_io.c   | 27 +++++++++------------------
 fs/btrfs/extent_io.h   | 12 ++++++------
 fs/btrfs/inode.c       | 26 ++++++++++++++------------
 fs/btrfs/volumes.c     |  7 ++++---
 fs/btrfs/volumes.h     |  1 -
 9 files changed, 39 insertions(+), 50 deletions(-)
