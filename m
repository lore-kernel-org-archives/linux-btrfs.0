Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:32799 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbbCYKfB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 06:35:01 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1426797070-27463-4-git-send-email-jbacik@fb.com>
References: <1426797070-27463-1-git-send-email-jbacik@fb.com>
	<1426797070-27463-4-git-send-email-jbacik@fb.com>
Date: Wed, 25 Mar 2015 10:35:00 +0000
Message-ID: <CAL3q7H7Nh737M1QbReuGizXmS3xb4Cn65-udSucLMDNoufn0Qg@mail.gmail.com>
Subject: Re: [PATCH 3/3] fstests: btrfs balance with dm log writes test
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        Zach Brown <zab@redhat.com>, fstests@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 19, 2015 at 8:31 PM, Josef Bacik <jbacik@fb.com> wrote:
> This test runs fsstress+balance+defrag and then replays every FUA in the log and
> mounts, scrubs and then fscks the fs to make sure it does the balance recovery
> properly.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Looks good, only some minor comments below.
Thanks.

> ---
>  tests/btrfs/083     | 135 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/083.out |   1 +
>  tests/btrfs/group   |   1 +
>  3 files changed, 137 insertions(+)
>  create mode 100644 tests/btrfs/083
>  create mode 100644 tests/btrfs/083.out
>
> diff --git a/tests/btrfs/083 b/tests/btrfs/083
> new file mode 100644
> index 0000000..66118b9
> --- /dev/null
> +++ b/tests/btrfs/083
> @@ -0,0 +1,135 @@
> +#! /bin/bash
> +# FSQA Test No. btrfs/083
> +#
> +# Run btrfs balance and defrag operations simultaneously with fsstress
> +# running in background on top of dm-log-writes.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2015 Facebook. All rights reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +       cd /
> +       rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmlogwrites
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +# we check scratch dev after each loop
> +_need_to_be_root
> +_require_scratch_nocheck
> +_require_dm_log_writes
> +
> +rm -f $seqres.full
> +
> +_wait_balance()
> +{
> +       while [ 1 ]
> +       do

Generally the style used in fstests is:  while X; do

> +               $BTRFS_UTIL_PROG filesystem balance status $SCRATCH_MNT \
> +                       | grep "No balance" >> $seqres.full
> +               [ $? -eq 0 ] && break
> +               sleep 1
> +       done
> +}
> +
> +run_test()
> +{
> +       args=`_scale_fsstress_args -p 20 -n 100 $FSSTRESS_AVOID -d $SCRATCH_MNT/stressdir`
> +       echo "Run fsstress $args" >>$seqres.full
> +       $FSSTRESS_PROG $args >/dev/null 2>&1 &
> +       fsstress_pid=$!
> +
> +       echo -n "Start balance worker: " >>$seqres.full
> +       _btrfs_stress_balance $SCRATCH_MNT >/dev/null 2>&1 &
> +       balance_pid=$!
> +       echo "$balance_pid" >>$seqres.full
> +
> +       echo -n "Start defrag worker: " >>$seqres.full
> +       _btrfs_stress_defrag $SCRATCH_MNT $with_compress >/dev/null 2>&1 &
> +       defrag_pid=$!
> +       echo "$defrag_pid" >>$seqres.full
> +
> +       echo "Wait for fsstress to exit and kill all background workers" >>$seqres.full
> +       wait $fsstress_pid
> +       kill $balance_pid $defrag_pid
> +       wait
> +       # wait for the balance and defrag operations to finish
> +       while ps aux | grep "balance start" | grep -qv grep; do
> +               sleep 1
> +       done
> +       while ps aux | grep "btrfs filesystem defrag" | grep -qv grep; do
> +               sleep 1
> +       done
> +}
> +
> +_init_log_writes
> +
> +_log_writes_mkfs >> $seqres.full 2>&1
> +
> +_mount_log_writes
> +
> +run_test "$t" nocompress

The arguments passed to run_test don't seem to be used anywhere (nor
$t defined).

> +
> +_unmount_log_writes
> +_log_writes_remove
> +
> +# Get the number of entries in the log
> +NUM_ENTRIES=$($REPLAYLOG_PROG --log $LOGWRITES_DEV --num-entries)
> +
> +# Start at the first FUA after the mkfs
> +ENTRY=$($REPLAYLOG_PROG --log $LOGWRITES_DEV --start-mark mkfs \
> +       --find --next-fua)
> +
> +while [ $ENTRY -lt $NUM_ENTRIES ];
> +do

Same as above.

> +       echo "Replaying to $ENTRY" >> $seqres.full
> +       $REPLAYLOG_PROG --log $LOGWRITES_DEV --replay $SCRATCH_DEV --limit \
> +               $ENTRY > /dev/null 2>&1
> +       [ $? -ne 0 ] && _fatal "replay failed"
> +       btrfsck $SCRATCH_DEV >> $seqres.full 2>&1 || _fatal "btrfsck failed"

Any reason to not use _check_scratch_fs instead?

> +       _scratch_mount || _fatal "mount failed"
> +       _wait_balance
> +       $BTRFS_UTIL_PROG scrub start -B $SCRATCH_MNT >> $seqres.full 2>&1
> +       [ $? -ne 0 ] && _fatal "scrub failed"
> +       _scratch_unmount
> +       btrfsck $SCRATCH_DEV >> $seqres.full 2>&1 || _fatal "btrfsck failed"

Same as above.

> +       let ENTRY+=1
> +       ENTRY=$($REPLAYLOG_PROG --find --start-entry $ENTRY --log \
> +               $LOGWRITES_DEV --next-fua)
> +done
> +
> +status=0
> +exit
> +
> diff --git a/tests/btrfs/083.out b/tests/btrfs/083.out
> new file mode 100644
> index 0000000..b675a31
> --- /dev/null
> +++ b/tests/btrfs/083.out
> @@ -0,0 +1 @@
> +QA output created by 083
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index fd2fa76..88719ca 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -85,3 +85,4 @@
>  080 auto snapshot
>  081 auto quick clone
>  082 auto quick remount
> +083 auto log
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
