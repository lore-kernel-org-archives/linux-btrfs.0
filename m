Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbaIZDzc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 23:55:32 -0400
Date: Fri, 26 Sep 2014 11:55:30 +0800
From: Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 00/15] xfstests: new btrfs stress test cases
Message-ID: <20140926035529.GF13912@dhcp-13-216.nay.redhat.com>
References: <1411019379-8104-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1411019379-8104-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 18, 2014 at 01:49:24PM +0800, Eryu Guan wrote:
> This patchset add new stress test cases for btrfs by running two
> different btrfs operations simultaneously under fsstress to ensure
> btrfs doesn't hang or oops in such situations. btrfs scrub and
> btrfs check will be run after each test.
> 
> The test matrix is the combination of 6 btrfs operations:
> 
> 	balance
> 	create/mount/umount/delete subvolume
> 	replace device
> 	scrub
> 	defrag
> 	remount with different compress algorithms
> 	
> Short descriptions:
> 
> 	059: balance-subvolume
> 	060: balance-scrub
> 	061: balance-defrag
> 	062: balance-remount
> 	063: balance-replace
> 	064: subvolume-replace
> 	065: subvolume-scrub
> 	066: subvolume-defrag
> 	067: subvolume-remount
> 	068: replace-scrub
> 	069: replace-defrag
> 	070: replace-remount
> 	071: scrub-defrag
> 	072: scrub-remount
> 	073: defrag-remount
> 
> Some issues I've seen:
> 
> 1. subvolume cannot be mounted with selinux context, so you may see
>    such logs in dmesg
> 
>    SELinux: mount invalid.  Same superblock, different security settings for (dev dm-8, type btrfs)
> 
>    I've reported the bug to btrfs list, see
>    [BUG] cannot mount subvolume with selinux context
>    http://www.spinics.net/lists/linux-btrfs/msg36779.html
> 
> 2. btrfs replace operation always returns ENOENT if balance is running
>    So in 063.full you'll see
> 
>    ERROR: ioctl(DEV_REPLACE_START) failed on "/mnt/testarea/scratch": No such file or directory, no error
> 
>    Not sure if it's btrfs bug, at least I think the error code is misleading
> 
> 3. replace operation hangs the kernel(3.16-rc4+ and 3.17-rc2+) with fsstress running
>    So case 064/068/069/070 will hang

I found some bugs in 070 after applying the patch manually which fixes
the hang. And 070 exposes one more bug (scrub finds correctable and
uncorrectable errors), will state this issue in v4.

Also did minor update in the _btrfs_stress_replace() function. Will
send v4 out soon.

Thanks,
Eryu
> 
> 
> Changes since v2:
> - mount subvolume at $TEST_DIR/$seq.mnt not $tmp.mnt
> - don't rm -rf $tmp.* which is dangerous
> - remove unnecessary btrfs filesystem sync operation
> - update _scratch_pool_mkfs to deal with dup profile
> - add more comments for each stress operation
> - rename _btrfs_stress_remount to _btrfs_stress_remount_compress (hope it's better...)
> - add _btrfs_get_profile_configs to remove duplicated test case array in each case
> - use _require_scratch_nocheck and _check_scratch_fs after each loop
> 
> Changes since v1:
> - put common operations in common/rc as functions and share them across these tests
> - append mkfs options to _scratch_mkfs and _scratch_pool_mkfs instead of updating $MKFS_OPTIONS
> - rebase on top of master and re-number starting from btrfs/059
> 
> Thanks,
> Eryu Guan
> 
> Eryu Guan (15):
>   btrfs: new test to run btrfs balance and subvolume test simultaneously
>   btrfs: new test to run btrfs balance and scrub simultaneously
>   btrfs: new test to run btrfs balance and defrag operations simultaneously
>   btrfs: new case to run btrfs balance and remount with different compress algorithms
>   btrfs: new case to run btrfs balance and device replace operations simultaneously
>   btrfs: new case to run btrfs subvolume create/delete operations and device replace simultaneously
>   btrfs: new case to run btrfs subvolume create/delete operations and scrub simultaneously
>   btrfs: new case to run btrfs subvolume create/delete and defrag operations simultaneously
>   btrfs: new case to run subvolume create/delete and remount with defferent compress algorithms
>   btrfs: new case to run device replace and scrub operations simultaneously
>   btrfs: new case to run device replace and defrag operations simultaneously
>   btrfs: new case to run device replace and remount with different compress algorithms simultaneously
>   btrfs: new case to run btrfs scrub and defrag operations simultaneously
>   btrfs: new case to run btrfs scrub and remount with different compress algorithms simultaneously
>   btrfs: new case to run defrag and remount with different compress algorithms simultaneously
> 
>  common/rc           | 225 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  tests/btrfs/059     | 115 +++++++++++++++++++++++++++
>  tests/btrfs/059.out |   2 +
>  tests/btrfs/060     | 114 ++++++++++++++++++++++++++
>  tests/btrfs/060.out |   2 +
>  tests/btrfs/061     | 116 +++++++++++++++++++++++++++
>  tests/btrfs/061.out |   2 +
>  tests/btrfs/062     | 114 ++++++++++++++++++++++++++
>  tests/btrfs/062.out |   2 +
>  tests/btrfs/063     | 122 ++++++++++++++++++++++++++++
>  tests/btrfs/063.out |   2 +
>  tests/btrfs/064     | 123 ++++++++++++++++++++++++++++
>  tests/btrfs/064.out |   2 +
>  tests/btrfs/065     | 115 +++++++++++++++++++++++++++
>  tests/btrfs/065.out |   2 +
>  tests/btrfs/066     | 117 +++++++++++++++++++++++++++
>  tests/btrfs/066.out |   2 +
>  tests/btrfs/067     | 116 +++++++++++++++++++++++++++
>  tests/btrfs/067.out |   2 +
>  tests/btrfs/068     | 123 ++++++++++++++++++++++++++++
>  tests/btrfs/068.out |   2 +
>  tests/btrfs/069     | 125 +++++++++++++++++++++++++++++
>  tests/btrfs/069.out |   2 +
>  tests/btrfs/070     | 123 ++++++++++++++++++++++++++++
>  tests/btrfs/070.out |   2 +
>  tests/btrfs/071     | 116 +++++++++++++++++++++++++++
>  tests/btrfs/071.out |   2 +
>  tests/btrfs/072     | 114 ++++++++++++++++++++++++++
>  tests/btrfs/072.out |   2 +
>  tests/btrfs/073     | 116 +++++++++++++++++++++++++++
>  tests/btrfs/073.out |   2 +
>  tests/btrfs/group   |  15 ++++
>  32 files changed, 2035 insertions(+), 4 deletions(-)
>  create mode 100755 tests/btrfs/059
>  create mode 100644 tests/btrfs/059.out
>  create mode 100755 tests/btrfs/060
>  create mode 100644 tests/btrfs/060.out
>  create mode 100755 tests/btrfs/061
>  create mode 100644 tests/btrfs/061.out
>  create mode 100755 tests/btrfs/062
>  create mode 100644 tests/btrfs/062.out
>  create mode 100755 tests/btrfs/063
>  create mode 100644 tests/btrfs/063.out
>  create mode 100755 tests/btrfs/064
>  create mode 100644 tests/btrfs/064.out
>  create mode 100755 tests/btrfs/065
>  create mode 100644 tests/btrfs/065.out
>  create mode 100755 tests/btrfs/066
>  create mode 100644 tests/btrfs/066.out
>  create mode 100755 tests/btrfs/067
>  create mode 100644 tests/btrfs/067.out
>  create mode 100755 tests/btrfs/068
>  create mode 100644 tests/btrfs/068.out
>  create mode 100755 tests/btrfs/069
>  create mode 100644 tests/btrfs/069.out
>  create mode 100755 tests/btrfs/070
>  create mode 100644 tests/btrfs/070.out
>  create mode 100755 tests/btrfs/071
>  create mode 100644 tests/btrfs/071.out
>  create mode 100755 tests/btrfs/072
>  create mode 100644 tests/btrfs/072.out
>  create mode 100755 tests/btrfs/073
>  create mode 100644 tests/btrfs/073.out
> 
> -- 
> 1.8.3.1
> 
