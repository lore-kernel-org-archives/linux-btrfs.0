Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61479 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbcB2BRJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 20:17:09 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: clm@fb.com, linux-btrfs@vger.kernel.org
Subject: [PULL][v7 REBASED 00/20] Btrfs In-band de-duplication
Date: Mon, 29 Feb 2016 09:14:54 +0800
Message-Id: <1456708494-8852-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Would you please consider to merge the rebased version of btrfs in-band
de-duplication for 4.6 merge window?

The pull can be fetched from github:
https://github.com/adam900710/linux.git wang_dedup_20160229

We have tested previous v7 patchset for one week and found no new
in-band de-duplication bug.
The rebase itself can be done by git automatically without any manual
edit.
So we assume that's good enough for 4.6 merge window.

Main features:
1) 2 different backend for in-band de-duplication
   In-memory backend with more fine tuning and theoretically faster hash
   search.
   On-disk backend with persist hash storage.

2) Tunable in-band dedup block size
   Let user to determine the balance between fragmentation and
   performance.

3) Per inode dedup disable
   Make things more flex.

4) Re-use compression routine
   Which is much cleaner than old(v4 and older) version

We have ran the whole xfstests with dedup enabled, although most
regression test won't be able to trigger in-band dedup and fallback to
normal routine, but some stress test did expose some bugs for us to fix.

Also, we have submitted in-band dedup specific regression test case,
which we found during the development.

Personally I really hope this function can be merged so we can get
enough feedback to further polish the UI related minor design.

Thanks,
Qu

Qu Wenruo (7):
  btrfs: delayed-ref: Add support for increasing data ref under spinlock
  btrfs: dedup: Inband in-memory only de-duplication implement
  btrfs: dedup: Add basic tree structure for on-disk dedup method
  btrfs: dedup: Introduce interfaces to resume and cleanup dedup info
  btrfs: dedup: Add support for on-disk hash search
  btrfs: dedup: Add support to delete hash for on-disk backend
  btrfs: dedup: Add support for adding hash for on-disk backend

Wang Xiaoguang (13):
  btrfs: dedup: Introduce dedup framework and its header
  btrfs: dedup: Introduce function to initialize dedup info
  btrfs: dedup: Introduce function to add hash into in-memory tree
  btrfs: dedup: Introduce function to remove hash from in-memory tree
  btrfs: dedup: Introduce function to search for an existing hash
  btrfs: dedup: Implement btrfs_dedup_calc_hash interface
  btrfs: ordered-extent: Add support for dedup
  btrfs: dedup: Add ioctl for inband deduplication
  btrfs: dedup: add an inode nodedup flag
  btrfs: dedup: add a property handler for online dedup
  btrfs: dedup: add per-file online dedup control
  btrfs: try more times to alloc metadata reserve space
  btrfs: dedup: Fix a bug when running inband dedup with balance

 fs/btrfs/Makefile            |    2 +-
 fs/btrfs/ctree.h             |   73 ++-
 fs/btrfs/dedup.c             | 1146 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedup.h             |  167 ++++++
 fs/btrfs/delayed-ref.c       |   30 +-
 fs/btrfs/delayed-ref.h       |    8 +
 fs/btrfs/disk-io.c           |   23 +-
 fs/btrfs/disk-io.h           |    1 +
 fs/btrfs/extent-tree.c       |   41 +-
 fs/btrfs/inode.c             |  183 ++++++-
 fs/btrfs/ioctl.c             |   70 ++-
 fs/btrfs/ordered-data.c      |   43 +-
 fs/btrfs/ordered-data.h      |   13 +
 fs/btrfs/props.c             |   40 ++
 fs/btrfs/relocation.c        |   13 +
 fs/btrfs/sysfs.c             |    2 +
 include/trace/events/btrfs.h |    3 +-
 include/uapi/linux/btrfs.h   |   24 +
 18 files changed, 1839 insertions(+), 43 deletions(-)
 create mode 100644 fs/btrfs/dedup.c
 create mode 100644 fs/btrfs/dedup.h

-- 
2.7.2



