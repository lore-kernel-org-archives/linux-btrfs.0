Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36830 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933182AbaFRIkY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 04:40:24 -0400
Message-ID: <53A14F86.9000506@cn.fujitsu.com>
Date: Wed, 18 Jun 2014 16:36:22 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] xfstests/btrfs: add qgroup rescan stress test
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1399615343-28544-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1399615343-28544-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef,

The lastest Qgroup code still break this test sometimes.

Ps: this test seems not merging into xfstests.

On 05/09/2014 02:02 PM, Wang Shilong wrote:
> Test flow is to run fsstress after triggering quota rescan.
> the ruler is simple, we just remove all files and directories,
> sync filesystem and see if qgroup's ref and excl are nodesize.
>
> Signed-off-by: Wang Shilong<wangsl.fnst@cn.fujitsu.com>
> ---
> v2->v3: addressed comments from josef:
> 	- remove unnecessary redirections
> 	- don't use _run_btrfs_util_prog() when capturing qgroup show output.
> 	- turn off inode_cache mount option explicitly.
>
> v1->v2: switch to _run_btrfs_util_prog()
> ---
>   tests/btrfs/050     | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/050.out |  3 ++
>   tests/btrfs/group   |  1 +
>   3 files changed, 85 insertions(+)
>   create mode 100644 tests/btrfs/050
>   create mode 100644 tests/btrfs/050.out
>
> diff --git a/tests/btrfs/050 b/tests/btrfs/050
> new file mode 100644
> index 0000000..81d953a
> --- /dev/null
> +++ b/tests/btrfs/050
> @@ -0,0 +1,81 @@
> +#! /bin/bash
> +# FSQA Test No. btrfs/050
> +#
> +# Quota rescan stress test, we run fsstress and quota rescan concurrently
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2014 Fujitsu.  All rights reserved.
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
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_need_to_be_root
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +rm -f $seqres.full
> +
> +# use small leaf size to get higher btree height.
> +run_check _scratch_mkfs "-b 1g --nodesize 4096"
> +
> +# inode cache is saved in the FS tree itself for every
> +# individual FS tree,that affects the sizes reported by qgroup show
> +# so we need to explicitly turn it off to get consistent values.
> +run_check _scratch_mount "-o noinode_cache"
> +
> +# -w ensures that the only ops are ones which cause write I/O
> +run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p 5 -n 1000 \
> +		$FSSTRESS_AVOID >&/dev/null
> +
> +_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT \
> +	$SCRATCH_MNT/snap1
> +
> +run_check $FSSTRESS_PROG -d $SCRATCH_MNT/snap1 -w -p 5 -n 1000 \
> +       $FSSTRESS_AVOID >&/dev/null
> +
> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
> +_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
> +
> +# ignore removing subvolume errors
> +rm -rf $SCRATCH_MNT/* >& /dev/null
> +
> +_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
> +$BTRFS_UTIL_PROG qgroup show $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' \
> +	| $AWK_PROG '{print $2" "$3}'
> +
> +status=0
> +exit
> diff --git a/tests/btrfs/050.out b/tests/btrfs/050.out
> new file mode 100644
> index 0000000..a388160
> --- /dev/null
> +++ b/tests/btrfs/050.out
> @@ -0,0 +1,3 @@
> +QA output created by 050
> +4096 4096
> +4096 4096
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 59b0c98..ee3e8a5 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -52,3 +52,4 @@
>   047 auto quick
>   048 auto quick
>   049 auto quick
> +050 auto quick

