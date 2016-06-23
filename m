Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbcFWKz5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 06:55:57 -0400
From: David Sterba <dsterba@suse.com>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PULL] Btrfs updates for 4.7-rc5
Date: Thu, 23 Jun 2016 12:56:18 +0200
Message-Id: <cover.1466678869.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is hopefully the last pull for 4.7 from me. There are two fixes that
should finalize the changes introduced in this dev cycle, plus some minor
independent fixes.

The following changes since commit 33688abb2802ff3a230bd2441f765477b94cc89e:

  Linux 4.7-rc4 (2016-06-19 21:30:02 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris

for you to fetch changes up to 917b187d467d87ed8d75b3d2084d906845ed126a:

  Btrfs: Force stripesize to the value of sectorsize (2016-06-23 12:16:01 +0200)

----------------------------------------------------------------
Chandan Rajendra (1):
      Btrfs: Force stripesize to the value of sectorsize

Liu Bo (1):
      Btrfs: fix error handling in map_private_extent_buffer

Omar Sandoval (1):
      Btrfs: fix ->iterate_shared() by upgrading i_rwsem for delayed nodes

Wang Xiaoguang (1):
      btrfs: fix disk_i_size update bug when fallocate() fails

Wei Yongjun (1):
      Btrfs: fix error return code in btrfs_init_test_fs()

 fs/btrfs/ctree.c             |  6 +++++-
 fs/btrfs/delayed-inode.c     | 27 ++++++++++++++++++++++-----
 fs/btrfs/delayed-inode.h     | 10 ++++++----
 fs/btrfs/disk-io.c           |  6 ++----
 fs/btrfs/extent_io.c         |  7 ++++++-
 fs/btrfs/inode.c             |  8 +++++---
 fs/btrfs/ordered-data.c      |  3 ++-
 fs/btrfs/tests/btrfs-tests.c |  2 +-
 fs/btrfs/volumes.c           |  4 ++--
 9 files changed, 51 insertions(+), 22 deletions(-)
