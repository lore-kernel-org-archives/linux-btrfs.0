Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39000 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbbKYLEk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 06:04:40 -0500
Received: from localhost
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 25 Nov 2015 21:04:38 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, chandan@mykolab.com
Subject: [PATCH 00/12] Fix Btrfs tests to work on non-4k block sized fs instances
Date: Wed, 25 Nov 2015 16:32:54 +0530
Message-Id: <1448449386-4186-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset fixes Btrfs tests to work on variable block size. This
is based off the RFC patch sent during March of this year
(https://www.marc.info/?l=linux-btrfs&m=142736088310300&w=2).

Currently, some of the tests are written with the assumption that 4k
is the block size of the filesystem instance. On architectures
(e.g. ppc64) with a larger page size (and hence larger block size),
these tests fail because the block bondaries assumed by the the tests
are no longer true and hence btrfs_ioctl_clone() (which requires a
block aligned file offset range) returns -EINVAL.

To fix the issue, This patchset adds three new filter functions:
1. _filter_xfs_io_blocks_modified
2. _filter_xfs_io_pages_modified
3. _filter_od

P.S: Since the changes made are trivial, I could have clubbed all the
patches into two patches. First patch introducing the new filtering
functions and the second patch containing the changes to made to the
tests. If this approach sounds right, I can post version V2 with the
two patches containing the relevant changes.

Chandan Rajendra (12):
  Filter xfs_io and od's output in units of FS block size and the CPU's
    page size
  Fix btrfs/017 to work on non-4k block sized filesystems
  Fix btrfs/052 to work on non-4k block sized filesystems
  Fix btrfs/055 to work on non-4k block sized filesystems
  Fix btrfs/056 to work on non-4k block sized filesystems
  Fix btrfs/094 to work on non-4k block sized filesystems
  Fix btrfs/095 to work on non-4k block sized filesystems
  Fix btrfs/096 to work on non-4k block sized filesystems
  Fix btrfs/097 to work on non-4k block sized filesystems
  Fix btrfs/098 to work on non-4k block sized filesystems
  Fix btrfs/103 to work on non-4k block sized filesystems
  Fix btrfs/106 to work on non-4k block sized filesystems

 common/filter       |  52 +++++
 common/rc           |   5 +
 tests/btrfs/017     |  16 +-
 tests/btrfs/017.out |   3 +-
 tests/btrfs/052     | 127 +++++++-----
 tests/btrfs/052.out | 546 +++++++++++++++++++++++-----------------------------
 tests/btrfs/055     | 128 +++++++-----
 tests/btrfs/055.out | 378 ++++++++++++++++++------------------
 tests/btrfs/056     |  51 +++--
 tests/btrfs/056.out | 152 ++++++---------
 tests/btrfs/094     |  78 +++++---
 tests/btrfs/094.out |  17 +-
 tests/btrfs/095     | 113 ++++++-----
 tests/btrfs/095.out |  10 +-
 tests/btrfs/096     |  45 +++--
 tests/btrfs/096.out |  15 +-
 tests/btrfs/097     |  42 ++--
 tests/btrfs/097.out |   7 +-
 tests/btrfs/098     |  65 ++++---
 tests/btrfs/098.out |   7 +-
 tests/btrfs/103     |  47 +++--
 tests/btrfs/103.out |  48 ++---
 tests/btrfs/106     |  42 ++--
 tests/btrfs/106.out |  14 +-
 24 files changed, 1018 insertions(+), 990 deletions(-)

-- 
2.1.0

