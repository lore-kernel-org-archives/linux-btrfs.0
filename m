Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59769 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbcB2IQD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Feb 2016 03:16:03 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/5] Btrfs in-band de-duplication tests cases
Date: Mon, 29 Feb 2016 16:15:18 +0800
Message-Id: <1456733723-27432-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we are push btrfs in-band de-duplication for v4.6, it's better to
add test cases for this new feature.

Except the first basic function test, the rest are all regression test
which we found during the development.
We also found some bugs from the generic test, but we need some fstests
option allowing us to enable dedup for any test case.
(We did it by hack _scratch_mount and _test_mount to enable dedup for
any test case)

Use the sequence number starts from 200 to avoid any possible conflicts.
The './new' script returns some hole number which is not proper for
such related test case set.
Hopes it's not too hard for maintainer to modify the sequence number.

v1:
  Btrfs mail list internal use only
v2:
  Add test case 203 to test balance race
v3:
  Follow Dave's comment to use more existing fstest infrastructure.
  Also fix a small bug in the 1st which forgot to remove old macros

Qu Wenruo (5):
  fstests: rename _require_btrfs to _require_btrfs_subcommand
  fstests: btrfs: Add basic test for btrfs in-band de-duplication
  fstests: btrfs: Add testcase for btrfs dedup enable disable race test
  fstests: btrfs: Add per inode dedup flag test
  fstests: btrfs: Test inband dedup with balance.

 common/defrag       |  13 +++++++
 common/rc           |   2 +-
 tests/btrfs/004     |   2 +-
 tests/btrfs/048     |   2 +-
 tests/btrfs/059     |   2 +-
 tests/btrfs/200     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/200.out |  21 ++++++++++
 tests/btrfs/201     |  98 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/201.out |   2 +
 tests/btrfs/202     | 108 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/202.out |  15 ++++++++
 tests/btrfs/203     |  99 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/203.out |   3 ++
 tests/btrfs/group   |   4 ++
 14 files changed, 476 insertions(+), 4 deletions(-)
 create mode 100755 tests/btrfs/200
 create mode 100644 tests/btrfs/200.out
 create mode 100755 tests/btrfs/201
 create mode 100644 tests/btrfs/201.out
 create mode 100755 tests/btrfs/202
 create mode 100644 tests/btrfs/202.out
 create mode 100755 tests/btrfs/203
 create mode 100644 tests/btrfs/203.out

-- 
2.7.2



