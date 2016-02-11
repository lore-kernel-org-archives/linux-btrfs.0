Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbcBKQ4y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 11:56:54 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PULL][PATCH 0/9] GFP_NOFS flags cleanup, part 2
Date: Thu, 11 Feb 2016 17:56:52 +0100
Message-Id: <cover.1455208920.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

another portion of the NOFS -> KERNEL conversions, in ioctl handlers and
mount-time functions. Branch will be in my for-next. Please merge to 4.6.

Currently all the simple cases without refactoring seem to be covered. What next
is still going to be determined. There are several classes of functions that
would be fixed in a similar way, eg. the extent state bit wrappers, bios, ulist,
csum calculations.

----------------------------------------------------------------
The following changes since commit 388f7b1d6e8ca06762e2454d28d6c3c55ad0fe95:

  Linux 4.5-rc3 (2016-02-07 15:38:30 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/gfp-flags

for you to fetch changes up to 66722f7c059089ad7f11eaa3e27af2321ab1b0e6:

  btrfs: switch to kcalloc in btrfs_cmp_data_prepare (2016-02-11 15:19:39 +0100)

----------------------------------------------------------------
David Sterba (9):
  btrfs: send: use GFP_KERNEL everywhere
  btrfs: reada: use GFP_KERNEL everywhere
  btrfs: scrub: use GFP_KERNEL on the submission path
  btrfs: let callers of btrfs_alloc_root pass gfp flags
  btrfs: fallocate: use GFP_KERNEL
  btrfs: readdir: use GFP_KERNEL
  btrfs: device add and remove: use GFP_KERNEL
  btrfs: extent same: use GFP_KERNEL for page array allocations
  btrfs: switch to kcalloc in btrfs_cmp_data_prepare

 fs/btrfs/ctree.c       |  2 +-
 fs/btrfs/dev-replace.c |  2 +-
 fs/btrfs/disk-io.c     | 21 +++++++++++----------
 fs/btrfs/file.c        |  6 +++---
 fs/btrfs/inode.c       |  2 +-
 fs/btrfs/ioctl.c       |  4 ++--
 fs/btrfs/reada.c       | 10 +++++-----
 fs/btrfs/scrub.c       | 24 +++++++++++++-----------
 fs/btrfs/send.c        | 36 ++++++++++++++++++------------------
 fs/btrfs/volumes.c     |  9 +++++----
 10 files changed, 60 insertions(+), 56 deletions(-)

-- 
2.7.1

