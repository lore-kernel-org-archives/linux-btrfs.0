Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59074 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757019AbcBXGhj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 01:37:39 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/5] Btrfs in-band de-duplication tests cases
Date: Wed, 24 Feb 2016 14:35:10 +0800
Message-Id: <1456295716-9589-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we are push btrfs in-band de-duplication for v4.6, it's better to
add test cases for this new feature.

Except the first basic function test, the rest are all regression test
which we found during the development.
We also found some bugs from the generic test, but we need some xfstests
option allowing us to enable dedup for any test case.
(We did it by hack _scratch_mount and _test_mount to enable dedup for
any test case)

Use the sequence number starts from 200 to avoid any possible conflicts.
The new script returns some hole number which is not that proper for
such related test case set.
Hopes it's not too hard for maintainer to modify the sequence number.

Qu Wenruo (5):
  fstests: rename _require_btrfs to _require_btrfs_subcommand
  fstests: btrfs: Add basic test for btrfs in-band de-duplication
  fstests: btrfs: Add testcase for btrfs dedup enable disable race test
  fstests: btrfs: Add per inode dedup flag test
  fstests: btrfs: Test inband dedup with balance.

 common/defrag       |   8 ++++
 common/rc           |   2 +-
 tests/btrfs/004     |   2 +-
 tests/btrfs/048     |   1 +
 tests/btrfs/059     |   1 +
 tests/btrfs/200     | 125 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/200.out |  19 ++++++++
 tests/btrfs/201     | 100 +++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/201.out |   1 +
 tests/btrfs/202     | 116 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/202.out |  15 +++++++
 tests/btrfs/203     |  91 ++++++++++++++++++++++++++++++++++++++
 tests/btrfs/203.out |   3 ++
 tests/btrfs/group   |   4 ++
 14 files changed, 486 insertions(+), 2 deletions(-)
 create mode 100755 tests/btrfs/200
 create mode 100644 tests/btrfs/200.out
 create mode 100755 tests/btrfs/201
 create mode 100644 tests/btrfs/201.out
 create mode 100755 tests/btrfs/202
 create mode 100644 tests/btrfs/202.out
 create mode 100755 tests/btrfs/203
 create mode 100644 tests/btrfs/203.out

-- 
2.7.1



