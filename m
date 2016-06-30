Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:44769 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbcF3Jeb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 05:34:31 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 115224056403
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Jun 2016 17:24:40 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 0/4] Btrfs in-band de-duplication test cases
Date: Thu, 30 Jun 2016 17:24:35 +0800
Message-Id: <20160630092439.27693-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs in-band de-duplication test case for in-memory backend.

v5:
  Due to kernel ioctl change, add FORCE flag for "dedupe enable" ioctl call.
v4:
  Due to kernel patchset re-organization, remove on-disk backend test cases
v3:
  Add new test cases for on-disk backend with metadata balance
v2:
  Add new test cases for on-disk backend with full balance


Qu Wenruo (4):
  fstests: rename _require_btrfs to _require_btrfs_subcommand
  fstests: btrfs: Add basic test for btrfs in-band de-duplication
  fstests: btrfs: Add testcase for btrfs dedupe and metadata balance
    race test
  fstests: btrfs: Test inband dedupe with data balance.

 common/defrag       |  13 ++++++
 common/rc           |   2 +-
 tests/btrfs/004     |   2 +-
 tests/btrfs/048     |   2 +-
 tests/btrfs/059     |   2 +-
 tests/btrfs/200     | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/200.out |  22 ++++++++++
 tests/btrfs/201     | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/201.out |   2 +
 tests/btrfs/203     | 110 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/203.out |   3 ++
 tests/btrfs/group   |   3 ++
 12 files changed, 385 insertions(+), 4 deletions(-)
 create mode 100755 tests/btrfs/200
 create mode 100644 tests/btrfs/200.out
 create mode 100755 tests/btrfs/201
 create mode 100644 tests/btrfs/201.out
 create mode 100755 tests/btrfs/203
 create mode 100644 tests/btrfs/203.out

-- 
2.9.0



