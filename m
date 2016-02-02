Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50902 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbcBBCoq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 21:44:46 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 09D094056401
	for <linux-btrfs@vger.kernel.org>; Tue,  2 Feb 2016 10:44:24 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 0/4] fstests for basic btrfs inband de-duplication
Date: Tue,  2 Feb 2016 10:44:15 +0800
Message-Id: <1454381059-27870-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Basic test for btrfs in-band de-duplication.
The comprehensive test should be enable dedup for every existing test
case (except some ENOSPC test, which need life time to fill it).

Dave is implementing the feature allowing us to execute such command
at mount time, but it's not implemented now.

Qu Wenruo (4):
  fstests: Add support to check btrfs sysfs features
  fstests: btrfs: Add basic test for btrfs in-band de-duplication
  fstests: btrfs: Add testcase for btrfs dedup enable disable race test
  fstests: btrfs: Add per inode dedup flag test

 common/defrag       |   8 ++++
 common/rc           |  12 +++++-
 tests/btrfs/004     |   2 +-
 tests/btrfs/048     |   2 +-
 tests/btrfs/059     |   2 +-
 tests/btrfs/200     | 112 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/200.out |  17 ++++++++
 tests/btrfs/201     |  97 +++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/201.out |   1 +
 tests/btrfs/202     | 117 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/202.out |  15 +++++++
 tests/btrfs/group   |   3 ++
 12 files changed, 384 insertions(+), 4 deletions(-)
 create mode 100755 tests/btrfs/200
 create mode 100644 tests/btrfs/200.out
 create mode 100755 tests/btrfs/201
 create mode 100644 tests/btrfs/201.out
 create mode 100755 tests/btrfs/202
 create mode 100644 tests/btrfs/202.out

-- 
2.7.0



