Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:27412 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1425048AbcBRG0j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 01:26:39 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id E225A4056401
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 14:26:28 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v2 0/5] Btrfs in-band de-duplication tests cases
Date: Thu, 18 Feb 2016 14:24:23 +0800
Message-Id: <1455776668-12306-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs in-band de-duplication test cases for btrfs internal use only.

Sequence number is not modified and uses number from 200 to avoid
possible conflicts.
Will modify sequence number and send to xfstests mail list after kernel
and btrfs-progs patches get merged.

Qu Wenruo (5):
  fstests: Add support to check btrfs sysfs features
  fstests: btrfs: Add basic test for btrfs in-band de-duplication
  fstests: btrfs: Add testcase for btrfs dedup enable disable race test
  fstests: btrfs: Add per inode dedup flag test
  fstests: btrfs: Test inband dedup with balance.

 common/defrag       |   8 ++++
 common/rc           |  12 +++++-
 tests/btrfs/004     |   2 +-
 tests/btrfs/048     |   2 +-
 tests/btrfs/059     |   2 +-
 tests/btrfs/200     | 112 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/200.out |  17 ++++++++
 tests/btrfs/201     | 101 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/201.out |   1 +
 tests/btrfs/202     | 117 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/202.out |  15 +++++++
 tests/btrfs/203     |  92 +++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/203.out |   3 ++
 tests/btrfs/group   |   4 ++
 14 files changed, 484 insertions(+), 4 deletions(-)
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



