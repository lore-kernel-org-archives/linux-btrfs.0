Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57172 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757302AbcGKDF7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jul 2016 23:05:59 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 9EF2B4091CE7
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 11:05:43 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v12.1 00/15] Btrfs in-band de-duplication
Date: Mon, 11 Jul 2016 11:05:28 +0800
Message-Id: <20160711030543.30115-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset can be fetched from github:
https://github.com/adam900710/linux.git wang_dedupe_20160711

This version is just a small update, rebased to David's for-next-20160704
branch, and adds a small non-functional patch to co-ordinate dedupe and
subpage size patchset.

With this update, conflict for both dedupe and subpage patchset could be
solved quite easily.

Qu Wenruo (4):
  btrfs: delayed-ref: Add support for increasing data ref under spinlock
  btrfs: dedupe: Inband in-memory only de-duplication implement
  btrfs: relocation: Enhance error handling to avoid BUG_ON
  btrfs: dedupe: Introduce new reconfigure ioctl

Wang Xiaoguang (11):
  btrfs: expand cow_file_range() to support in-band dedup and
    subpage-blocksize
  btrfs: dedupe: Introduce dedupe framework and its header
  btrfs: dedupe: Introduce function to initialize dedupe info
  btrfs: dedupe: Introduce function to add hash into in-memory tree
  btrfs: dedupe: Introduce function to remove hash from in-memory tree
  btrfs: dedupe: Introduce function to search for an existing hash
  btrfs: dedupe: Implement btrfs_dedupe_calc_hash interface
  btrfs: ordered-extent: Add support for dedupe
  btrfs: dedupe: Add ioctl for inband dedupelication
  btrfs: improve inode's outstanding_extents computation
  btrfs: dedupe: fix false ENOSPC

 fs/btrfs/Makefile                |   2 +-
 fs/btrfs/ctree.h                 |  25 +-
 fs/btrfs/dedupe.c                | 820 +++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedupe.h                | 221 +++++++++++
 fs/btrfs/delayed-ref.c           |  30 +-
 fs/btrfs/delayed-ref.h           |   8 +
 fs/btrfs/disk-io.c               |   4 +
 fs/btrfs/extent-tree.c           |  83 +++-
 fs/btrfs/extent_io.c             |  63 ++-
 fs/btrfs/extent_io.h             |  15 +-
 fs/btrfs/file.c                  |  26 +-
 fs/btrfs/free-space-cache.c      |   5 +-
 fs/btrfs/inode-map.c             |   4 +-
 fs/btrfs/inode.c                 | 453 ++++++++++++++++-----
 fs/btrfs/ioctl.c                 |  93 ++++-
 fs/btrfs/ordered-data.c          |  46 ++-
 fs/btrfs/ordered-data.h          |  14 +
 fs/btrfs/relocation.c            |  46 ++-
 fs/btrfs/sysfs.c                 |   2 +
 fs/btrfs/tests/extent-io-tests.c |   6 +-
 fs/btrfs/tests/inode-tests.c     |  12 +-
 include/uapi/linux/btrfs.h       |  55 +++
 22 files changed, 1872 insertions(+), 161 deletions(-)
 create mode 100644 fs/btrfs/dedupe.c
 create mode 100644 fs/btrfs/dedupe.h

-- 
2.9.0



