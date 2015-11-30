Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:42397 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbbK3KRd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 05:17:33 -0500
Received: from localhost
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 30 Nov 2015 15:47:31 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, chandan@mykolab.com
Subject: [PATCH 0/8] PART 2: Fix Btrfs tests to work on non-4k block sized fs instances
Date: Mon, 30 Nov 2015 15:47:16 +0530
Message-Id: <1448878644-16503-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This represents the second part of the patchset to fix Btrfs specific
tests to work on variable block size. These patches now use the output
of "od" utility to verify the contents of the test files instead of
the md5sum utility.

The patchset also introduces the new filter function,
_filter_xfs_io_pages_modified(), to print the file I/O range in page
size units instead of file offsets.

Chandan Rajendra (8):
  Filter xfs_io's output in units of page size
  Fix btrfs/052 to work on non-4k block sized filesystems
  Fix btrfs/094 to work on non-4k block sized filesystems
  Fix btrfs/095 to work on non-4k block sized filesystems
  Fix btrfs/097 to work on non-4k block sized filesystems
  Fix btrfs/098 to work on non-4k block sized filesystems
  Fix btrfs/103 to work on non-4k block sized filesystems
  Fix btrfs/106 to work on non-4k page sized machines

 common/filter       |   8 +
 common/rc           |   6 +
 tests/btrfs/052     | 122 +++++----
 tests/btrfs/052.out | 744 +++++++++++++++++++++++++++++++---------------------
 tests/btrfs/094     |  75 +++---
 tests/btrfs/094.out |  71 ++++-
 tests/btrfs/095     | 110 ++++----
 tests/btrfs/095.out |  42 ++-
 tests/btrfs/097     |  41 +--
 tests/btrfs/097.out |  23 +-
 tests/btrfs/098     |  67 ++---
 tests/btrfs/098.out |  27 +-
 tests/btrfs/103     |  44 ++--
 tests/btrfs/103.out | 132 +++++++---
 tests/btrfs/106     |  36 +--
 tests/btrfs/106.out |  30 ++-
 16 files changed, 984 insertions(+), 594 deletions(-)

-- 
2.1.0

