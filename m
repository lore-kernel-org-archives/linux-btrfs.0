Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbaIZEVO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Sep 2014 00:21:14 -0400
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Subject: [PATCH v4 00/15] xfstests: new btrfs stress test cases
Date: Fri, 26 Sep 2014 12:14:46 +0800
Message-Id: <1411704901-12723-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset add new stress test cases for btrfs by running two
different btrfs operations simultaneously under fsstress to ensure
btrfs doesn't hang or oops in such situations. btrfs scrub and
btrfs check will be run after each test.

The test matrix is the combination of 6 btrfs operations:

	balance
	create/mount/umount/delete subvolume
	replace device
	scrub
	defrag
	remount with different compress algorithms
	
Short descriptions:

	059: balance-subvolume
	060: balance-scrub
	061: balance-defrag
	062: balance-remount
	063: balance-replace
	064: subvolume-replace
	065: subvolume-scrub
	066: subvolume-defrag
	067: subvolume-remount
	068: replace-scrub
	069: replace-defrag
	070: replace-remount
	071: scrub-defrag
	072: scrub-remount
	073: defrag-remount

Some issues I've seen:

1. subvolume cannot be mounted with selinux context, so you may see
   such logs in dmesg

   SELinux: mount invalid.  Same superblock, different security settings for (dev dm-8, type btrfs)

   I've reported the bug to btrfs list, see
   [BUG] cannot mount subvolume with selinux context
   http://www.spinics.net/lists/linux-btrfs/msg36779.html

2. btrfs replace operation always returns ENOENT if balance is running
   So in 063.full you'll see

   ERROR: ioctl(DEV_REPLACE_START) failed on "/mnt/testarea/scratch": No such file or directory, no error

   Not sure if it's btrfs bug, at least I think the error code is misleading

3. replace operation hangs the kernel(3.16-rc4+ and 3.17-rc2+) with fsstress running
   So case 064/068/069/070 will hang

4. scrub finds both correctable and uncorrectable errors in 070

   I applied the patch manually which fixes the replace hang issue and 070
   exposed this bug. RAID1 and RAID10 profile fail this test. single and
   RAID0 seem fine.

   070.full shows:

   Scrub find errors in "-m raid1 -d raid0" test
   scrub done for f4a0dd71-f738-454a-bcec-7f137927fda0
   	scrub started at Fri Sep 26 11:25:36 2014 and finished after 1 seconds
   	total bytes scrubbed: 56.00MiB with 2 errors
   	error details: csum=2
   	corrected errors: 0, uncorrectable errors: 2, unverified errors: 0

   Scrub find errors in "-m raid1 -d raid1" test
   scrub done for 2c6ee91f-926b-462b-a790-72c043ea260f
        scrub started at Fri Sep 26 11:26:24 2014 and finished after 2 seconds
	total bytes scrubbed: 114.58MiB with 8 errors
	error details: csum=8
	corrected errors: 8, uncorrectable errors: 0, unverified errors: 0

   Scrub find errors in "-m raid10 -d raid10" test
   scrub done for f3038bbd-5b0e-4651-9e0f-b9b7703fdf84
        scrub started at Fri Sep 26 11:26:52 2014 and finished after 2 seconds
	total bytes scrubbed: 104.90MiB with 7 errors
	error details: csum=7
	corrected errors: 7, uncorrectable errors: 0, unverified errors: 0


v4:
- do sanity check in _btrfs_stress_replace to check if the last device is free
- wait for replace operation to finish in 070 not defrag operation

v3: http://www.spinics.net/lists/linux-btrfs/msg37619.html
- mount subvolume at $TEST_DIR/$seq.mnt not $tmp.mnt
- don't rm -rf $tmp.* which is dangerous
- remove unnecessary btrfs filesystem sync operation
- update _scratch_pool_mkfs to deal with dup profile
- add more comments for each stress operation
- rename _btrfs_stress_remount to _btrfs_stress_remount_compress (hope it's better...)
- add _btrfs_get_profile_configs to remove duplicated test case array in each case
- use _require_scratch_nocheck and _check_scratch_fs after each loop

v2: http://www.spinics.net/lists/linux-btrfs/msg37071.html
- put common operations in common/rc as functions and share them across these tests
- append mkfs options to _scratch_mkfs and _scratch_pool_mkfs instead of updating $MKFS_OPTIONS
- rebase on top of master and re-number starting from btrfs/059


v1: http://www.spinics.net/lists/linux-btrfs/msg36859.html

Thanks,
Eryu Guan

Eryu Guan (15):
  btrfs: new test to run btrfs balance and subvolume test simultaneously
  btrfs: new test to run btrfs balance and scrub simultaneously
  btrfs: new test to run btrfs balance and defrag operations simultaneously
  btrfs: new case to run btrfs balance and remount with different compress algorithms
  btrfs: new case to run btrfs balance and device replace operations simultaneously
  btrfs: new case to run btrfs subvolume create/delete operations and device replace simultaneously
  btrfs: new case to run btrfs subvolume create/delete operations and scrub simultaneously
  btrfs: new case to run btrfs subvolume create/delete and defrag operations simultaneously
  btrfs: new case to run subvolume create/delete and remount with defferent compress algorithms
  btrfs: new case to run device replace and scrub operations simultaneously
  btrfs: new case to run device replace and defrag operations simultaneously
  btrfs: new case to run device replace and remount with different compress algorithms simultaneously
  btrfs: new case to run btrfs scrub and defrag operations simultaneously
  btrfs: new case to run btrfs scrub and remount with different compress algorithms simultaneously
  btrfs: new case to run defrag and remount with different compress algorithms simultaneously

 common/rc           | 226 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 tests/btrfs/059     | 115 ++++++++++++++++++++++++++
 tests/btrfs/059.out |   2 +
 tests/btrfs/060     | 114 ++++++++++++++++++++++++++
 tests/btrfs/060.out |   2 +
 tests/btrfs/061     | 116 +++++++++++++++++++++++++++
 tests/btrfs/061.out |   2 +
 tests/btrfs/062     | 114 ++++++++++++++++++++++++++
 tests/btrfs/062.out |   2 +
 tests/btrfs/063     | 122 ++++++++++++++++++++++++++++
 tests/btrfs/063.out |   2 +
 tests/btrfs/064     | 123 ++++++++++++++++++++++++++++
 tests/btrfs/064.out |   2 +
 tests/btrfs/065     | 115 ++++++++++++++++++++++++++
 tests/btrfs/065.out |   2 +
 tests/btrfs/066     | 117 +++++++++++++++++++++++++++
 tests/btrfs/066.out |   2 +
 tests/btrfs/067     | 116 +++++++++++++++++++++++++++
 tests/btrfs/067.out |   2 +
 tests/btrfs/068     | 123 ++++++++++++++++++++++++++++
 tests/btrfs/068.out |   2 +
 tests/btrfs/069     | 125 +++++++++++++++++++++++++++++
 tests/btrfs/069.out |   2 +
 tests/btrfs/070     | 123 ++++++++++++++++++++++++++++
 tests/btrfs/070.out |   2 +
 tests/btrfs/071     | 116 +++++++++++++++++++++++++++
 tests/btrfs/071.out |   2 +
 tests/btrfs/072     | 114 ++++++++++++++++++++++++++
 tests/btrfs/072.out |   2 +
 tests/btrfs/073     | 116 +++++++++++++++++++++++++++
 tests/btrfs/073.out |   2 +
 tests/btrfs/group   |  15 ++++
 32 files changed, 2036 insertions(+), 4 deletions(-)
 create mode 100755 tests/btrfs/059
 create mode 100644 tests/btrfs/059.out
 create mode 100755 tests/btrfs/060
 create mode 100644 tests/btrfs/060.out
 create mode 100755 tests/btrfs/061
 create mode 100644 tests/btrfs/061.out
 create mode 100755 tests/btrfs/062
 create mode 100644 tests/btrfs/062.out
 create mode 100755 tests/btrfs/063
 create mode 100644 tests/btrfs/063.out
 create mode 100755 tests/btrfs/064
 create mode 100644 tests/btrfs/064.out
 create mode 100755 tests/btrfs/065
 create mode 100644 tests/btrfs/065.out
 create mode 100755 tests/btrfs/066
 create mode 100644 tests/btrfs/066.out
 create mode 100755 tests/btrfs/067
 create mode 100644 tests/btrfs/067.out
 create mode 100755 tests/btrfs/068
 create mode 100644 tests/btrfs/068.out
 create mode 100755 tests/btrfs/069
 create mode 100644 tests/btrfs/069.out
 create mode 100755 tests/btrfs/070
 create mode 100644 tests/btrfs/070.out
 create mode 100755 tests/btrfs/071
 create mode 100644 tests/btrfs/071.out
 create mode 100755 tests/btrfs/072
 create mode 100644 tests/btrfs/072.out
 create mode 100755 tests/btrfs/073
 create mode 100644 tests/btrfs/073.out

-- 
1.8.3.1

