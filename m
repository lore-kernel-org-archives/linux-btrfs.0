Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33072 "EHLO
	mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbcEaJSP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 05:18:15 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <14be2210-cf79-56c1-d549-2fd5ccae86e2@cn.fujitsu.com>
References: <1464660234-14562-1-git-send-email-lufq.fnst@cn.fujitsu.com>
	<CAL3q7H7N029j8Vqqu+11j2PtVgS7zc+PCz8UdF3sHo1VSc9kRg@mail.gmail.com>
	<14be2210-cf79-56c1-d549-2fd5ccae86e2@cn.fujitsu.com>
Date: Tue, 31 May 2016 10:18:13 +0100
Message-ID: <CAL3q7H7NWCPxje8YyXTQmoteuUtCn7E7eiZt0O7JR3gbDSf0yw@mail.gmail.com>
Subject: Re: [PATCH] fstests: btrfs: add test for qgroup handle de-refer
From: Filipe Manana <fdmanana@gmail.com>
To: luke <lufq.fnst@cn.fujitsu.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 31, 2016 at 10:08 AM, luke <lufq.fnst@cn.fujitsu.com> wrote:
>
>
>
>
> At 05/31/2016 03:39 PM, Filipe Manana wrote:
>
> On Tue, May 31, 2016 at 3:03 AM, Lu Fengqi <lufq.fnst@cn.fujitsu.com> wrote:
>
> Test if qgroup can handle de-reference reallocation.
>
> What is "de-reference reallocation"?
>
>
>  Sorry, I'm not good at English. I mean "extent de-reference during
> reallocation".

Well that's still not clear. It's not so much an English problem but
rather what do you mean with that concept.
Is is reading an extent (as a result of read or pread syscall for
e.g.), freeing an extent, or what?

thanks

>
> Although current
> qgroup can handle it, we still need to prevent any regression which may
> break current qgroup.
>
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> ---
>  common/rc           |  4 +--
>  tests/btrfs/028     | 91
> +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/028.out |  2 ++
>  tests/btrfs/group   |  1 +
>  4 files changed, 96 insertions(+), 2 deletions(-)
>  create mode 100755 tests/btrfs/028
>  create mode 100644 tests/btrfs/028.out
>
> diff --git a/common/rc b/common/rc
> index 51092a0..650d198 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3284,9 +3284,9 @@ _btrfs_get_profile_configs()
>  # stress btrfs by running balance operation in a loop
>  _btrfs_stress_balance()
>  {
> -       local btrfs_mnt=$1
> +       local options=$@
>         while true; do
> -               $BTRFS_UTIL_PROG balance start $btrfs_mnt
> +               $BTRFS_UTIL_PROG balance start $options
>         done
>  }
>
> diff --git a/tests/btrfs/028 b/tests/btrfs/028
> new file mode 100755
> index 0000000..6e0ad36
> --- /dev/null
> +++ b/tests/btrfs/028
> @@ -0,0 +1,91 @@
> +#! /bin/bash
> +# FS QA Test 028
>
> Missing a short description here of what the test does (what it tests).
>
> OK, I'll add this description.
>
>
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Fujitsu. All Rights Reserved.
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
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1       # failure is the default!
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
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +# Currently in btrfs the node/leaf size can not be smaller than the page
> +# size (but it can be greater than the page size). So use the largest
> +# supported node/leaf size (64Kb) so that the test can run on any platform
> +# that Linux supports.
> +_scratch_mkfs "--nodesize 64k"
> +_scratch_mount
> +
> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
> +_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
> +
> +# Increase the probability of generating de-refer extent, and decrease
> +# other.
>
> Again, what is a "de-refer extent"? I've never seen this expression
> before (and I don't others will understand it).
>
> thanks
>
> Ditto.
>
>
> +args=`_scale_fsstress_args -z \
> +       -f write=10 -f unlink=10 \
> +       -f creat=10 -f fsync=10 \
> +       -f fsync=10 -n 100000 -p 2 \
> +       -d $SCRATCH_MNT/stress_dir`
> +echo "Run fsstress $args" >>$seqres.full
> +$FSSTRESS_PROG $args >/dev/null 2>&1 &
> +fsstress_pid=$!
> +
> +echo "Start balance" >>$seqres.full
> +_btrfs_stress_balance -d $SCRATCH_MNT >/dev/null 2>&1 &
> +balance_pid=$!
> +
> +# 30s is enough to trigger bug
> +sleep $((30*$TIME_FACTOR))
> +kill $fsstress_pid $balance_pid
> +wait
> +
> +# kill _btrfs_stress_balance can't end balance, so call btrfs balance
> cancel
> +# to cancel running or paused balance.
> +$BTRFS_UTIL_PROG balance cancel $SCRATCH_MNT &> /dev/null
> +
> +rm -rf $SCRATCH_MNT/*
> +_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
> +units=`_btrfs_qgroup_units`
> +$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p'
> | \
> +       $AWK_PROG '{print $2" "$3}'
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/028.out b/tests/btrfs/028.out
> new file mode 100644
> index 0000000..69b68bf
> --- /dev/null
> +++ b/tests/btrfs/028.out
> @@ -0,0 +1,2 @@
> +QA output created by 028
> +65536 65536
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index da0e27f..35ecf59 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -30,6 +30,7 @@
>  025 auto quick send clone
>  026 auto quick compress prealloc
>  027 auto replace
> +028 auto qgroup balance
>  029 auto quick clone
>  030 auto quick send
>  031 auto quick subvol clone
> --
> 2.5.5
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Thanks,
> Lu



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
