Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbcFFPfX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jun 2016 11:35:23 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Self-tests updates for non-4k pages, for 4.7-rc3
Date: Mon,  6 Jun 2016 17:34:38 +0200
Message-Id: <cover.1465226346.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this patchset enhances the self-tests to work on non-4k architectures (ppc64,
arm64). The diffstat may appear big, but there are lots of call sites that just
get another parameter (nodesize), so we now also test all valid combinations of
pagesize and nodesize for a given arch.

The patchset is part of preparatory work of the subpage-blocksize patchset, and
it's updating only non-production code so it's IMO safe to merge in an rc. I
have tested it on x86_64 to verify that it does not break the default usecase.


The following changes since commit 56244ef151c3cd11f505020ab0b3f45454363bcc:

  Btrfs: fix handling of faults from btrfs_copy_from_user (2016-05-26 13:23:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.7-20160606

for you to fetch changes up to 34b3e6c92af1fa3f7067e4fa05ffa9d8bd41c96c:

  Btrfs: self-tests: Fix extent buffer bitmap test fail on BE system (2016-06-06 17:17:12 +0200)

----------------------------------------------------------------
Feifei Xu (8):
      Btrfs: test_check_exists: Fix infinite loop when searching for free space entries
      Btrfs: Fix integer overflow when calculating bytes_per_bitmap
      Btrfs: self-tests: Support non-4k page size
      Btrfs: self-tests: Execute page straddling test only when nodesize < PAGE_SIZE
      Btrfs: self-tests: Support testing all possible sectorsizes and nodesizes
      Btrfs: self-tests: Use macros instead of constants and add missing newline
      Btrfs: self-tests: Fix test_bitmaps fail on 64k sectorsize
      Btrfs: self-tests: Fix extent buffer bitmap test fail on BE system

 fs/btrfs/ctree.c                       |   6 +-
 fs/btrfs/disk-io.c                     |   9 +-
 fs/btrfs/disk-io.h                     |   2 +-
 fs/btrfs/extent_io.c                   |  10 +-
 fs/btrfs/extent_io.h                   |   4 +-
 fs/btrfs/free-space-cache.c            |  18 +-
 fs/btrfs/super.c                       |  52 +++--
 fs/btrfs/tests/btrfs-tests.c           |   6 +-
 fs/btrfs/tests/btrfs-tests.h           |  27 +--
 fs/btrfs/tests/extent-buffer-tests.c   |  13 +-
 fs/btrfs/tests/extent-io-tests.c       |  86 ++++++---
 fs/btrfs/tests/free-space-tests.c      |  76 +++++---
 fs/btrfs/tests/free-space-tree-tests.c |  30 +--
 fs/btrfs/tests/inode-tests.c           | 344 ++++++++++++++++++---------------
 fs/btrfs/tests/qgroup-tests.c          | 111 ++++++-----
 15 files changed, 454 insertions(+), 340 deletions(-)
