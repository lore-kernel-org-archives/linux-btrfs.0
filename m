Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from synology.com ([59.124.61.242]:44831 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754013AbcJMLE7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 07:04:59 -0400
From: robbieko <robbieko@synology.com>
To: linux-btrfs@vger.kernel.org
Cc: Robbie Ko <robbieko@synology.com>
Subject: [PATCH 0/4] Btrfs: add serval test case for incremental send
Date: Thu, 13 Oct 2016 19:04:09 +0800
Message-Id: <1476356653-22839-1-git-send-email-robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robbie Ko <robbieko@synology.com>

Patch for test btrfs incremental send. 

Robbie Ko (4):
  btrfs: add test for an incremental send don't skip overwrite ref for
    inode 256
  btrfs: add test for an incremental send add gen for is_waiting_for_rm
    when some corner case
  btrfs: add test for an incremental send add gen check in
    did_overwrite_ref
  btrfs: add test for an incremental send add gen check in
    will_overwrite_ref

 tests/btrfs/131     | 110 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/131.out |   2 +
 tests/btrfs/132     | 116 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/132.out |   2 +
 tests/btrfs/133     | 120 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/133.out |   2 +
 tests/btrfs/134     | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/134.out |   2 +
 tests/btrfs/group   |   4 ++
 9 files changed, 479 insertions(+)
 create mode 100755 tests/btrfs/131
 create mode 100644 tests/btrfs/131.out
 create mode 100755 tests/btrfs/132
 create mode 100644 tests/btrfs/132.out
 create mode 100755 tests/btrfs/133
 create mode 100644 tests/btrfs/133.out
 create mode 100755 tests/btrfs/134
 create mode 100644 tests/btrfs/134.out

-- 
1.9.1

