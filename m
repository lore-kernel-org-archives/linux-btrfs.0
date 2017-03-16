Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31031 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751243AbdCPBuk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 21:50:40 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <fstests@vger.kernel.org>
Subject: [PATCH 0/3] Btrfs in-band de-duplication test cases
Date: Thu, 16 Mar 2017 09:50:24 +0800
Message-ID: <20170316015028.20020-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs in-band de-duplication test cases for in-memory backend, which covers
the bugs exposed during the development.

Qu Wenruo (3):
  fstests: btrfs: Add basic test for btrfs in-band de-duplication
  fstests: btrfs: Add testcase for btrfs dedupe and metadata balance
    race test
  fstests: btrfs: Test inband dedupe with data balance.

 common/defrag       |  13 ++++++
 tests/btrfs/200     | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/200.out |  22 ++++++++++
 tests/btrfs/201     | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/201.out |   2 +
 tests/btrfs/203     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/203.out |   3 ++
 tests/btrfs/group   |   4 ++
 8 files changed, 381 insertions(+)
 create mode 100755 tests/btrfs/200
 create mode 100644 tests/btrfs/200.out
 create mode 100755 tests/btrfs/201
 create mode 100644 tests/btrfs/201.out
 create mode 100755 tests/btrfs/203
 create mode 100644 tests/btrfs/203.out

-- 
2.12.0



