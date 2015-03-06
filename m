Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbbCFFGf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Mar 2015 00:06:35 -0500
Date: Fri, 6 Mar 2015 13:06:00 +0800
From: Eryu Guan <eguan@redhat.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstest: btrfs: add a test for quota number when deleting
 a subvol.
Message-ID: <20150306050600.GQ16974@dhcp-13-216.nay.redhat.com>
References: <54EEB798.1070105@cn.fujitsu.com>
 <1425381210-13661-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1425381210-13661-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 03, 2015 at 07:13:30PM +0800, Dongsheng Yang wrote:
> This regression is introduced by two commits:
> 
> e339a6b0 (Btrfs: __btrfs_mod_ref should always use no_quota)
> 1152651a (btrfs: qgroup: account shared subtrees during snapshot delete)

I think you should add more description about the issue you're going to
test. I see only failures like

[root@dhcp-66-86-11 xfstests]# diff -u tests/btrfs/084.out /root/xfstests/results//btrfs/084.out.bad                                                                  
--- tests/btrfs/084.out 2015-03-06 12:47:02.319000000 +0800
+++ /root/xfstests/results//btrfs/084.out.bad   2015-03-06
12:48:03.707000000 +0800
@@ -1,3 +1,3 @@
 QA output created by 084
 24576 24576
-0 0
+8192 0

but from the test I don't know why "8192 0" is expected result not "0 0"

> 
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>  tests/btrfs/084     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/084.out |  3 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 88 insertions(+)
>  create mode 100755 tests/btrfs/084
>  create mode 100644 tests/btrfs/084.out
> 
> diff --git a/tests/btrfs/084 b/tests/btrfs/084
> new file mode 100755
> index 0000000..7b7c7ac
> --- /dev/null
> +++ b/tests/btrfs/084
> @@ -0,0 +1,84 @@
> +#! /bin/bash
> +# FS QA Test No. 084
> +#
> +# This is a case for the regression introduced by
> +#
> +# e339a6b0 (Btrfs: __btrfs_mod_ref should always use no_quota)
> +# 1152651a (btrfs: qgroup: account shared subtrees during snapshot delete)
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2015 Fujitsu.  All Rights Reserved.
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
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*

Better to use a tab not 4 spaces, maybe "new" should be updated too (in
another patch)

> +}
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
> +_scratch_mount

_scratch_mkfs first before you mount it.

And you need to remove $seqres.full before test, since you called
_run_btrfs_util_prog and it will dump commands and outputs to
$seqres.full, the file will keep growing over runs if you don't remove
it first.

rm -f $seqres.full

> +
> +$XFS_IO_PROG -f -d -c "pwrite 0 8K" $SCRATCH_MNT/foo 2>&1 > /dev/null
> +
> +_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap
> +
> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
> +_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
> +
> +units=`_btrfs_qgroup_units`
> +orig_result=`$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $AWK_PROG 'NR==NF {print $3}'`
> +
> +_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/snap
> +
> +_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
> +
> +timeout=100
> +# There is a background thread doing the clean work
> +for ((i=0; i<$timeout; i++))
> +do
> +	result=`$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $AWK_PROG 'NR==NF {print $3}'`
> +	if (($orig_result != $result))
> +	then
> +		break
> +	fi
> +	sleep 1

I'm not sure if we need 100 iterations and sleeping 1 sec after each
iteration, that means we need 100s for a PASS run.

> +done

Please follow this code style, as Dave pointed before

for ; do
	# code
done

if ; then
	# code
fi
> +
> +$BTRFS_UTIL_PROG qgroup show $units $SCRATCH_MNT | $AWK_PROG '/[0-9]/ {print $2" "$3}'
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/084.out b/tests/btrfs/084.out
> new file mode 100644
> index 0000000..7bf6dbf
> --- /dev/null
> +++ b/tests/btrfs/084.out
> @@ -0,0 +1,3 @@
> +QA output created by 084
> +24576 24576
> +0 0
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index fe82a9c..1be7392 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -86,3 +86,4 @@
>  081 auto quick clone
>  082 auto quick remount
>  083 auto quick send
> +084 qgroup

Missed auto group?

Thanks,
Eryu
