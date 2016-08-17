Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbcHQPMM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Aug 2016 11:12:12 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs fixes for 4.8, part 2
Date: Wed, 17 Aug 2016 17:11:13 +0200
Message-Id: <cover.1471443105.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is a short series, mostly small fixes that did not make it to the first
round. Please pull, thanks.

----------------------------------------------------------------
The following changes since commit 10838816547a28696ca10e038b3b32f2efec5a42:

  Merge branch 'integration-4.8' of git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux into for-linus-4.8 (2016-08-05 12:25:05 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.8

for you to fetch changes up to 56ee3f62c2c78b2ec541283d39208683e8ce385f:

  btrfs: qgroup: Fix qgroup incorrectness caused by log replay (2016-08-17 15:41:05 +0200)

----------------------------------------------------------------
Alex Lyakas (1):
      btrfs: flush_space: treat return value of do_chunk_alloc properly

Jeff Mahoney (2):
      btrfs: properly track when rescan worker is running
      btrfs: waiting on qgroup rescan should not always be interruptible

Liu Bo (2):
      Btrfs: fix memory leak of reloc_root
      Btrfs: add ASSERT for block group's memory leak

Qu Wenruo (4):
      btrfs: backref: Fix soft lockup in __merge_refs function
      btrfs: qgroup: Refactor btrfs_qgroup_insert_dirty_extent()
      btrfs: relocation: Fix leaking qgroups numbers on data extents
      btrfs: qgroup: Fix qgroup incorrectness caused by log replay

 fs/btrfs/backref.c     |   1 +
 fs/btrfs/ctree.h       |   1 +
 fs/btrfs/delayed-ref.c |   7 +---
 fs/btrfs/disk-io.c     |  12 +++++-
 fs/btrfs/extent-tree.c |  44 +++++---------------
 fs/btrfs/ioctl.c       |   2 +-
 fs/btrfs/qgroup.c      |  62 +++++++++++++++++++++++-----
 fs/btrfs/qgroup.h      |  36 +++++++++++++---
 fs/btrfs/relocation.c  | 109 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/tree-log.c    |  16 ++++++++
 10 files changed, 228 insertions(+), 62 deletions(-)
