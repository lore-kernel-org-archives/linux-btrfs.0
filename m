Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49712 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbeIYKaH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 06:30:07 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/9] Fix _scratch_mkfs_sized() for btrfs
Date: Tue, 25 Sep 2018 12:24:13 +0800
Message-Id: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v1->v2: Fix the min size for _scratch_mkfs_sized() to 256MB for btrfs and
         add comment about its ref.
	Fix _scratch_mkfs_sized() options to use at least 256MB in each
	 test case.
        Update change long.

Currently _scratch_mkfs_sized() checks if the requested size is below 1G
for btrfs and forces the --mixed mkfs option. The 1G size cut off is too
larger where the actual size is ~256mb. The patch 1/9 fixes the
_scratch_mkfs_sized() to check for 256mb instead.

Also fix the test cases requesting to create FS below 256mb. And open
code the fssize computation where possible (that is the variable used
is only used once).

Further, there are test cases generic/250,252,256,416 which uses
_scratch_mkfs_sized with < 200mb but its fix isn't straight forward
and they are not yet ready for the review.

The affected testcases (which calls _scratch_mkfs_sized) [1] have
been tested on btrfs. And the test cases [2] which are being patches
here are tested on xfs ext4 and btrfs for no regression.

[1]
generic/015 generic/027 generic/077 generic/081 generic/083 generic/085 generic/096 generic/102 generic/171 generic/172 generic/173 generic/174 generic/204 generic/224 generic/226 generic/250 generic/252 generic/256 generic/269 generic/270 generic/273 generic/274 generic/275 generic/300 generic/312 generic/320 generic/333 generic/334 generic/361 generic/371 generic/387 generic/399 generic/416 generic/427 generic/449 generic/459 generic/466 generic/488 generic/505 btrfs/004 btrfs/007 btrfs/132 btrfs/170

[2]
generic/015 generic/077 generic/083 generic/387 generic/449

Anand Jain (9):
  fstests: btrfs: _scratch_mkfs_sized fix min size without mixed option
  generic/015 fix to test the default non-mixed mode
  geneirc/077 fix min size for btrfs
  generic/083 fix btrfs fs size for default mode
  generic/102 open code dev_size _scratch_mkfs_sized()
  generic/204 open code SIZE for _scratch_mkfs_sized()
  generic/312 open code fs_size _scratch_mkfs_sized()
  generic/449 fix fs size for _scratch_mkfs_sized for btrfs
  generic/387 fix _scratch_mkfs_sized option for btrfs

 common/rc         | 4 +++-
 tests/generic/015 | 8 +++-----
 tests/generic/077 | 3 +--
 tests/generic/083 | 2 +-
 tests/generic/102 | 3 +--
 tests/generic/204 | 3 +--
 tests/generic/312 | 7 +++----
 tests/generic/387 | 3 ++-
 tests/generic/449 | 4 ++--
 9 files changed, 17 insertions(+), 20 deletions(-)

-- 
1.8.3.1
