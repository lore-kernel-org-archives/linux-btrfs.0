Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47825 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754179AbbGWUwG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 16:52:06 -0400
From: Omar Sandoval <osandov@fb.com>
To: <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>,
        Omar Sandoval <osandov@fb.com>
Subject: [PATCH 0/3] xfstests: test btrfs replace on RAID 5/6
Date: Thu, 23 Jul 2015 13:51:48 -0700
Message-ID: <cover.1437683940.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs has supported replace on RAID 5 and 6 since 3.19, but xfstests
hasn't been updated to reflect that. Patches 1 and 2 in this series fix
that.

Additionally, I'm including Wang Yanfeng's test for my patch series
"Btrfs: RAID 5/6 missing device scrub+replace", updated to use the
infrastructure added by patch 2.

Thanks!

Omar Sandoval (2):
  btrfs/011: test replace on RAID 5/6 now that it's supported
  btrfs: add replace missing and replace RAID 5/6 to profile configs

Wang Yanfeng (1):
  btrfs: add a test of replace missing dev in diff raid

 common/rc           | 96 +++++++++++++++++++++++++++--------------------------
 tests/btrfs/011     |  4 +--
 tests/btrfs/095     | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/095.out |  2 ++
 tests/btrfs/group   |  1 +
 5 files changed, 147 insertions(+), 49 deletions(-)
 create mode 100755 tests/btrfs/095
 create mode 100644 tests/btrfs/095.out

-- 
2.4.6

