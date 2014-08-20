Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaHTRfH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 13:35:07 -0400
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Subject: [PATCH 00/15] xfstests: new btrfs stress test cases
Date: Thu, 21 Aug 2014 01:33:49 +0800
Message-Id: <1408556044-907-2-git-send-email-eguan@redhat.com>
In-Reply-To: <1408556044-907-1-git-send-email-eguan@redhat.com>
References: <1408556044-907-1-git-send-email-eguan@redhat.com>
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

	057: balance-subvolume
	058: balance-scrub
	059: balance-defrag
	060: balance-remount
	061: balance-replace
	062: subvolume-replace
	063: subvolume-scrub
	064: subvolume-defrag
	065: subvolume-remount
	066: replace-scrub
	067: replace-defrag
	068: replace-remount
	069: scrub-defrag
	070: scrub-remount
	071: defrag-remount

Some issues I've seen:

1. subvolume cannot be mounted with selinux context, so you'll see
   such logs in dmesg

   SELinux: mount invalid.  Same superblock, different security settings for (dev dm-8, type btrfs)

   I've reported the bug to btrfs list, see
   [BUG] cannot mount subvolume with selinux context

2. btrfs replace operation always returns ENOENT if balance is running
   So in 061.full you'll see

   ERROR: ioctl(DEV_REPLACE_START) failed on "/mnt/testarea/scratch": No such file or directory, no error

   Not sure if it's btrfs bug, at least I think the error code is misleading

3. replace operation hangs the kernel(3.16-rc4+) with fsstress running
   So case 062/066/067/068 will hang

This is my first attemp to add these tests, any comments are welcomed!

Thanks,
Eryu Guan

Eryu Guan (15):
  btrfs: new test to run btrfs balance and subvolume test simultaneously
  btrfs: new test to run btrfs balance and scrub simltaneously
  btrfs: new test to run btrfs balance and defrag operations simultaneously
  btrfs: new case to run btrfs balance and remount with different compress algorithms
  btrfs: new case to run btrfs balance and device replace simultaneously
  btrfs: new case to run btrfs subvolume create/delete operations and device replace simultaneously
  btrfs: new case to run btrfs subvolume create/delete operations and scrub simultaneously
  btrfs: new case to run btrfs subvolume create/delete and defrag operations simultaneously
  btrfs: new case to run subvolume create/delete and remount with different compress algorithms
  btrfs: new case to run device replace and scrub operations simultaneously
  btrfs: new case to run device replace and defrag operations simultaneously
  btrfs: new case to run device replace and remount with different compress algorithms simultaneously
  btrfs: new case to run btrfs scrub and defrag operations simultaneously
  btrfs: new case to run btrfs scrub and remount with different compress algorithms simultaneously
  btrfs: new case to run defrag and remount with different compress algorithms simultaneously

 common/rc           |  24 ++++++++
 tests/btrfs/057     | 147 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/057.out |   2 +
 tests/btrfs/058     | 141 +++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/058.out |   2 +
 tests/btrfs/059     | 150 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/059.out |   2 +
 tests/btrfs/060     | 142 +++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/060.out |   2 +
 tests/btrfs/061     | 161 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/061.out |   2 +
 tests/btrfs/062     | 167 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/062.out |   2 +
 tests/btrfs/063     | 146 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/063.out |   2 +
 tests/btrfs/064     | 155 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/064.out |   2 +
 tests/btrfs/065     | 148 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/065.out |   2 +
 tests/btrfs/066     | 161 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/066.out |   2 +
 tests/btrfs/067     | 171 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/067.out |   2 +
 tests/btrfs/068     | 163 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/068.out |   2 +
 tests/btrfs/069     | 150 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/069.out |   2 +
 tests/btrfs/070     | 142 +++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/070.out |   2 +
 tests/btrfs/071     | 152 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/071.out |   2 +
 tests/btrfs/group   |  15 +++++
 32 files changed, 2365 insertions(+)
 create mode 100755 tests/btrfs/057
 create mode 100644 tests/btrfs/057.out
 create mode 100755 tests/btrfs/058
 create mode 100644 tests/btrfs/058.out
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

-- 
1.8.3.1

