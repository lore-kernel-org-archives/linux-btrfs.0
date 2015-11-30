Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:60841 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbbK3KRs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 05:17:48 -0500
Received: from localhost
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 30 Nov 2015 15:47:46 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, chandan@mykolab.com
Subject: [PATCH V2 0/5] Fix Btrfs tests to work on non-4k block sized fs instances
Date: Mon, 30 Nov 2015 15:46:55 +0530
Message-Id: <1448878620-16382-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset fixes Btrfs tests to work on variable block size. This
is based off the RFC patch sent during March of this year
(https://www.marc.info/?l=linux-btrfs&m=142736088310300&w=2).

Currently, some of the tests are written with the assumption that 4k
is the block size of the filesystem instance. On architectures
(e.g. ppc64) with a larger page size (and hence larger block size),
these tests fail because the block bondaries assumed by the the tests
are no longer true.

To fix the issue, This patchset adds two new filter functions:
1. _filter_xfs_io_blocks_modified
2. _filter_od

Changes from V1:
1. Remove faulty patches which incorrectly compared a file's md5sum
   output before and after performing file operations instead of
   echoing it to stdout.

Chandan Rajendra (5):
  Filter xfs_io and od's output in units of FS block size
  Fix btrfs/017 to work on non-4k block sized filesystems
  Fix btrfs/055 to work on non-4k block sized filesystems
  Fix btrfs/056 to work on non-4k block sized filesystems
  Fix btrfs/096 to work on non-4k block sized filesystems

 common/filter       |  45 +++++++
 tests/btrfs/017     |  16 ++-
 tests/btrfs/017.out |   3 +-
 tests/btrfs/055     | 128 ++++++++++--------
 tests/btrfs/055.out | 378 +++++++++++++++++++++++++---------------------------
 tests/btrfs/056     |  51 ++++---
 tests/btrfs/056.out | 152 +++++++++------------
 tests/btrfs/096     |  45 ++++---
 tests/btrfs/096.out |  15 +--
 9 files changed, 437 insertions(+), 396 deletions(-)

-- 
2.1.0

