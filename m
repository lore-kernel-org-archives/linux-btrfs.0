Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64909 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751321AbdCPJI5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Mar 2017 05:08:57 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <fstests@vger.kernel.org>
Subject: [PATCH v2 0/3] Btrfs in-band de-duplication test cases
Date: Thu, 16 Mar 2017 17:08:48 +0800
Message-ID: <20170316090851.21608-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs in-band de-duplication test cases for in-memory backend, which covers
the bugs exposed during the development.

v2:
  Fix double disable and exit
  Use $KILLALL_PROG
  Use local variable in _count_extent_uniq()
  Update date of the test cases
  Move test case 203 to 202, to make up the numbering hole.

Qu Wenruo (3):
  fstests: btrfs: Add basic test for btrfs in-band de-duplication
  fstests: btrfs: Add testcase for btrfs dedupe and metadata balance
    race test
  fstests: btrfs: Test inband dedupe with data balance.

 common/defrag       |  14 +++++++
 tests/btrfs/200     | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/200.out |  22 ++++++++++
 tests/btrfs/201     | 113 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/201.out |   2 +
 tests/btrfs/202     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/202.out |   3 ++
 tests/btrfs/group   |   3 ++
 8 files changed, 376 insertions(+)
 create mode 100755 tests/btrfs/200
 create mode 100644 tests/btrfs/200.out
 create mode 100755 tests/btrfs/201
 create mode 100644 tests/btrfs/201.out
 create mode 100755 tests/btrfs/202
 create mode 100644 tests/btrfs/202.out

-- 
2.9.3



