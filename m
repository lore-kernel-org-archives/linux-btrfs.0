Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbaHUDm3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 23:42:29 -0400
Date: Thu, 21 Aug 2014 11:42:23 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/15] btrfs: new test to run btrfs balance and subvolume
 test simultaneously
Message-ID: <20140821034223.GY2977@dhcp-13-216.nay.redhat.com>
References: <1408556044-907-1-git-send-email-eguan@redhat.com>
 <1408556044-907-3-git-send-email-eguan@redhat.com>
 <53F553AE.5060707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <53F553AE.5060707@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 21, 2014 at 10:04:30AM +0800, Qu Wenruo wrote:
> 
> -------- Original Message --------
> Subject: [PATCH 01/15] btrfs: new test to run btrfs balance and subvolume
> test simultaneously
> From: Eryu Guan <eguan@redhat.com>
> To: <fstests@vger.kernel.org>
> Date: 2014年08月21日 01:33
> >Run btrfs balance and subvolume create/mount/umount/delete simultaneously,
> >with fsstress running in background.
> >
> >Signed-off-by: Eryu Guan <eguan@redhat.com>
> >---
> >  tests/btrfs/057     | 147 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/057.out |   2 +
> >  tests/btrfs/group   |   1 +
> >  3 files changed, 150 insertions(+)
> >  create mode 100755 tests/btrfs/057
> >  create mode 100644 tests/btrfs/057.out
> >
> >diff --git a/tests/btrfs/057 b/tests/btrfs/057
> >new file mode 100755
> >index 0000000..2f507a7
> >--- /dev/null
> >+++ b/tests/btrfs/057
> >@@ -0,0 +1,147 @@
> >+#! /bin/bash
> >+# FSQA Test No. btrfs/057
> >+#
> >+# Run btrfs balance and subvolume create/mount/umount/delete simultaneously,
> >+# with fsstress running in background.
> >+#
> >+#-----------------------------------------------------------------------
> >+# Copyright (C) 2014 Red Hat Inc. All rights reserved.
> >+#
> >+# This program is free software; you can redistribute it and/or
> >+# modify it under the terms of the GNU General Public License as
> >+# published by the Free Software Foundation.
> >+#
> >+# This program is distributed in the hope that it would be useful,
> >+# but WITHOUT ANY WARRANTY; without even the implied warranty of
> >+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >+# GNU General Public License for more details.
> >+#
> >+# You should have received a copy of the GNU General Public License
> >+# along with this program; if not, write the Free Software Foundation,
> >+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> >+#
> >+#-----------------------------------------------------------------------
> >+#
> >+
> >+seq=`basename $0`
> >+seqres=$RESULT_DIR/$seq
> >+echo "QA output created by $seq"
> >+
> >+here=`pwd`
> >+tmp=/tmp/$$
> >+status=1
> >+trap "_cleanup; exit \$status" 0 1 2 3 15
> >+
> >+_cleanup()
> >+{
> >+	cd /
> >+	rm -fr $tmp.*
> >+}
> >+
> >+# get standard environment, filters and checks
> >+. ./common/rc
> >+. ./common/filter
> >+
> >+# real QA test starts here
> >+_supported_fs btrfs
> >+_supported_os Linux
> >+_require_scratch
> >+_require_scratch_dev_pool 4
> >+
> >+rm -f $seqres.full
> >+
> >+# test case array
> >+tcs=(
> >+	"-m single -d single"
> >+	"-m dup -d single"
> >+	"-m raid0 -d raid0"
> >+	"-m raid1 -d raid0"
> >+	"-m raid1 -d raid1"
> >+	"-m raid10 -d raid10"
> >+	"-m raid5 -d raid5"
> >+	"-m raid6 -d raid6"
> >+)
> I wonder should we add the mkfs options there.
> Since xfstests already use environment MKFS_OPTIONS to do mkfs,
> if really need to test all mkfs options, IMO it is better to change
> MKFS_OPTIONS on each test round.

Most of the data/metadata profiles tested here require multiple
devices, so if you set MKFS_OPTIONS to, say "-m raid10 -d raid10",
other tests that only require a single scratch device will fail at
mkfs time. Unlike other mkfs options, these options are not working
for every test.

And btrfs/011 and btrfs/023 do the test in a similar way, so I just
followed this way :)

> 
> >+
> >+run_test()
> >+{
> >+	local mkfs_opts=$1
> >+	local saved_mkfs_opts=$MKFS_OPTIONS
> >+	local subvol_mnt=$tmp.mnt
> >+
> >+	echo "Test $mkfs_opts" >>$seqres.full
> >+
> >+	MKFS_OPTIONS="$MKFS_OPTIONS $mkfs_opts"
> >+	# dup only works on single device
> >+	if [[ "$mkfs_opts" =~ dup ]]; then
> >+		_scratch_mkfs >>$seqres.full 2>&1
> >+	else
> >+		_scratch_pool_mkfs >>$seqres.full 2>&1
> >+	fi
> >+	ret=$?
> >+	MKFS_OPTIONS=$saved_mkfs_opts
> >+	# make sure we created btrfs with desired options
> >+	if [ $ret -ne 0 ]; then
> >+		echo "mkfs $mkfs_opts failed"
> >+		return
> >+	fi
> >+
> >+	_scratch_mount >>$seqres.full 2>&1
> >+
> >+	args=`_scale_fsstress_args -p 20 -n 100 $FSSTRESS_AVOID -d $SCRATCH_MNT/stressdir`
> >+	echo "Run fsstress $args" >>$seqres.full
> >+	$FSSTRESS_PROG $args >/dev/null 2>&1 &
> >+	fsstress_pid=$!
> >+
> >+	echo -n "Start balance worker: " >>$seqres.full
> >+	(
> >+		while true; do
> >+			$BTRFS_UTIL_PROG balance start $SCRATCH_MNT
> >+		done
> >+	) >/dev/null 2>&1 &
> >+	balance_pid=$!
> >+	echo "$balance_pid" >>$seqres.full
> >+
> >+	echo -n "Start subvolume worker: " >>$seqres.full
> >+	mkdir -p $subvol_mnt
> >+	(
> >+		while true; do
> >+			$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/subvol_$$
> >+			$MOUNT_PROG -o subvol=subvol_$$ $SCRATCH_DEV $subvol_mnt
> >+			$UMOUNT_PROG $subvol_mnt
> >+			$BTRFS_UTIL_PROG subvolume delete $SCRATCH_MNT/subvol_$$
> >+		done
> >+	) >/dev/null 2>&1 &
> >+	subvol_pid=$!
> >+	echo "$subvol_pid" >>$seqres.full
> >+
> >+	echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
> >+	wait $fsstress_pid
> What about integrate this 'run in background; record PID; wait; kill' thing
> into one function or two?
> and then thing would be like this:
> add_test_background TEST_FUNC1 PID_RET1
> add_test_background TEST_FUNC2 PID_RET2
> ...
> stop_test_backgroupd PID_RET1
> stop_test_backgroupd PID_RET2
> 
> Which will be much cleaner.

Yes, that's a good idea, thanks!

> >+
> >+	kill $balance_pid $subvol_pid
> >+	wait
> >+	# the balance process might be still in D state and cannot be killed
> >+	# which could block umount, wait for it to finish
> >+	while ps aux | grep "balance start" | grep -qv grep; do
> >+		sleep 1
> >+	done
> >+
> >+	echo "Scrub the filesystem" >>$seqres.full
> >+	$BTRFS_UTIL_PROG scrub start -B $SCRATCH_MNT >>$seqres.full 2>&1
> >+	if [ $? -ne 0 ]; then
> >+		echo "Scrub find errors in \"$mkfs_opts\" test" | tee -a $seqres.full
> >+	fi
> All your testcases uses almost same scrub/replace/subvolume operations,
> it would be better move them to common operations in common/ like
> _scratch_mount in common/rc.
> (since all these are btrfs only operations, maybe common/btrfs is a good
> place for them?)

I'll share the functions in v2. There're already some btrfs specific
helper functions in common/rc, I'll just add my functions there
too. We can take them all out to commom/btrfs in a seperate patch if
in need, and update all affected test cases.

Thanks for the review!

Eryu
> 
> At least this should save some lines.
> 
> Thanks,
> Qu
> >+
> >+	$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT >/dev/null 2>&1
> >+	# in case the subvolume is still mounted
> >+	$UMOUNT_PROG $subvol_mnt >/dev/null 2>&1
> >+	_scratch_unmount
> >+	_check_scratch_fs
> >+}
> 
> >+
> >+echo "Silence is golden"
> >+for t in "${tcs[@]}"; do
> >+	run_test "$t"
> >+done
> >+
> >+status=0
> >+exit
> >diff --git a/tests/btrfs/057.out b/tests/btrfs/057.out
> >new file mode 100644
> >index 0000000..185023c
> >--- /dev/null
> >+++ b/tests/btrfs/057.out
> >@@ -0,0 +1,2 @@
> >+QA output created by 057
> >+Silence is golden
> >diff --git a/tests/btrfs/group b/tests/btrfs/group
> >index 2da7127..08fd54a 100644
> >--- a/tests/btrfs/group
> >+++ b/tests/btrfs/group
> >@@ -59,3 +59,4 @@
> >  054 auto quick
> >  055 auto quick
> >  056 auto quick
> >+057 auto stress balance subvol
> 
