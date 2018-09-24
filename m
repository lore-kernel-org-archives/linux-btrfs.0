Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36862 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727524AbeIXQSD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 12:18:03 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/9] Fix _scratch_mkfs_sized() for btrfs
Date: Mon, 24 Sep 2018 18:16:24 +0800
Message-Id: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently _scratch_mkfs_sized() checks if requested size for the fs
is below 1G for btrfs and forces the --mixed mkfs option. The 1G size
cut off is too larger where the actual size is 114294784 bytes. The
patch 1/9 fixes the _scratch_mkfs_sized() to check for 114294784
bytes instead. By this now we test the default config (non mixed).
And the mixed option may still be tested using the MKFS_OPTIONS.
This change only affect btrfs FS and test cases using the
_scratch_mkfs_sized() in generic and btrfs.


Also, to make sure btrfs is created in non-mixed mode, so in each individual test cases we need to make sure that _scratch_mkfs_sized()
been requested to create a FS of at least 200mb in size (114294784
bytes rounded off to the nearest 100). And there are few test
cases which does not do that, Patches [2,3,4,8,9]/9 fixes them.
These changes affects all FS as such.

And there are some test cases where we use local
variable as an option for the _scratch_mkfs_sized() is being used
and this local variable is not used anywhere else with in the test
case. So patches [5,6,7]/9 drops the local variable and open codes
it. This is a straight forward change as the fs size is kept same
as in the original.

Further, there are test cases generic/250,252,256 which uses
_scratch_mkfs_sized with < 200mb but its fix isn't straight forward
and they are not yet ready for the review.

The affected testcases (which calls _scratch_mkfs_sized) [1] have
been tested with xfs/ext4 and btrfs. And there are no regressions.

[1]
generic/015 generic/027 generic/077 generic/081 generic/083 generic/085 generic/096 generic/102 generic/171 generic/172 generic/173 generic/174 generic/204 generic/224 generic/226 generic/250 generic/252 generic/256 generic/269 generic/270 generic/273 generic/274 generic/275 generic/300 generic/312 generic/320 generic/333 generic/334 generic/361 generic/371 generic/387 generic/399 generic/416 generic/427 generic/449 generic/459 generic/466 generic/488 generic/505 btrfs/004 btrfs/007 btrfs/132 btrfs/170

Anand Jain (9):
  fstests: btrfs: _scratch_mkfs_sized fix min size without mixed option
  generic/015 fix to test the default non-mixed mode
  geneirc/077 fix min size for btrfs
  generic/083 create at least 200mb fs
  generic/102 open code dev_size _scratch_mkfs_sized()
  generic/204 open code SIZE for _scratch_mkfs_sized()
  generic/312 open code fs_size _scratch_mkfs_sized()
  generic/449 fix fs size for _scratch_mkfs_sized for btrfs
  generic/387 fix _scratch_mkfs_sized option for btrfs

 common/rc         | 4 +++-
 tests/generic/015 | 9 ++++-----
 tests/generic/077 | 3 +--
 tests/generic/083 | 2 +-
 tests/generic/102 | 3 +--
 tests/generic/204 | 3 +--
 tests/generic/312 | 7 +++----
 tests/generic/387 | 3 ++-
 tests/generic/449 | 4 ++--
 9 files changed, 18 insertions(+), 20 deletions(-)

-- 
1.8.3.1
