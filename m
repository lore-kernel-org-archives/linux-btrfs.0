Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42210 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbdEIS54 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 May 2017 14:57:56 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@gmail.com>,
        Eryu Guan <eguan@redhat.com>
Subject: [PATCH 0/6] Regression test for btrfs read repair
Date: Tue,  9 May 2017 11:56:05 -0600
Message-Id: <1494352571-17199-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This set is adding four regression test case for btrfs read repair, and both
directIO read and buffered read are tested.

Patch 1 and 2 is adding two helpers to summarize the common code among the
following test cases in patch 3-6. 

Liu Bo (6):
  fstests: add _filter_filefrag
  fstests: add _get_current_dmesg
  fstests: regression test for btrfs dio read repair
  fstests: regression test for btrfs buffered read's repair
  fstests: regression test for nocsum dio read's repair
  fstests: regression test for nocsum buffered read's repair

 common/filter       |  19 +++++++
 common/rc           |   9 ++-
 tests/btrfs/140     | 115 ++++++++++++++++++++++++++++++++++++++
 tests/btrfs/140.out |  39 +++++++++++++
 tests/btrfs/141     | 116 +++++++++++++++++++++++++++++++++++++++
 tests/btrfs/141.out |  39 +++++++++++++
 tests/btrfs/142     | 137 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/142.out |  39 +++++++++++++
 tests/btrfs/143     | 155 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/143.out |  39 +++++++++++++
 tests/btrfs/group   |   4 ++
 11 files changed, 709 insertions(+), 2 deletions(-)
 create mode 100755 tests/btrfs/140
 create mode 100644 tests/btrfs/140.out
 create mode 100755 tests/btrfs/141
 create mode 100644 tests/btrfs/141.out
 create mode 100755 tests/btrfs/142
 create mode 100644 tests/btrfs/142.out
 create mode 100755 tests/btrfs/143
 create mode 100644 tests/btrfs/143.out

-- 
2.5.0

