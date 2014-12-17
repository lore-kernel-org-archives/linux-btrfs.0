Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58181 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaLQKAY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 05:00:24 -0500
Message-ID: <5491542C.4000209@jp.fujitsu.com>
Date: Wed, 17 Dec 2014 19:00:12 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] xfstests: btrfs: add test case for qgroup account
 on shared extents
References: <1418723004-30543-1-git-send-email-bo.li.liu@oracle.com> <1418805047-24636-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1418805047-24636-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

(2014/12/17 17:30), Liu Bo wrote:
> This is a regression test of
> 'commit fcebe4562dec ("Btrfs: rework qgroup accounting")'
> 
> It can produce qgroup related warnings.
> 
> The fix is https://patchwork.kernel.org/patch/5499981/
> "Btrfs: fix a warning of qgroup account on shared extents"
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> Reviewed-by: Eryu Guan <eguan@redhat.com>

It looks good to me.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Tested-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

* Test result

** The latest upstream kernel without your patch

Failed as follows.

results/btrfs/017.out.bad
===============================================================================
QA output created by 017
-4096 4096
-12288 -4096
===============================================================================

** The latest upstream kernel with your patch

Succeeded.

Thanks,
Satoru

> ---
> v3: - remove trailing whilespace.
>      - add the fix link for more details of the problem.
> 
> v2: - use new seq number 017 instead 080
>      - use 'cloner' to get shared extents
>      - use XFS_IO_PROG instead
> 
>   tests/btrfs/017     | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/017.out |  3 +++
>   tests/btrfs/group   |  1 +
>   3 files changed, 81 insertions(+)
>   create mode 100755 tests/btrfs/017
>   create mode 100644 tests/btrfs/017.out
> 
> diff --git a/tests/btrfs/017 b/tests/btrfs/017
> new file mode 100755
> index 0000000..b0390d5
> --- /dev/null
> +++ b/tests/btrfs/017
> @@ -0,0 +1,77 @@
> +#! /bin/bash
> +# FS QA Test No. 017
> +#
> +# Regression of 'commit fcebe4562dec ("Btrfs: rework qgroup accounting")',
> +# this will throw a warning into dmesg.
> +#
> +# For more details, the fix is https://patchwork.kernel.org/patch/5499981/
> +# "Btrfs: fix a warning of qgroup account on shared extents"
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2014 Liu Bo.  All Rights Reserved.
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
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +
> +_need_to_be_root
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_require_cloner
> +
> +run_check _scratch_mkfs "--nodesize 4096"
> +run_check _scratch_mount
> +
> +run_check $XFS_IO_PROG -f -d -c "pwrite 0 8K" $SCRATCH_MNT/foo
> +
> +_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap
> +
> +run_check $CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo-reflink
> +run_check $CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo-reflink
> +run_check $CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo-reflink2
> +
> +_run_btrfs_util_prog quota enable $SCRATCH_MNT
> +_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
> +
> +rm -fr $SCRATCH_MNT/* >/dev/null 2>&1
> +
> +_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
> +
> +$BTRFS_UTIL_PROG qgroup show $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' | $AWK_PROG '{print $2" "$3}'
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/017.out b/tests/btrfs/017.out
> new file mode 100644
> index 0000000..e25e631
> --- /dev/null
> +++ b/tests/btrfs/017.out
> @@ -0,0 +1,3 @@
> +QA output created by 017
> +4096 4096
> +4096 4096
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index abb2fe4..e29999b 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -19,6 +19,7 @@
>   014 auto balance
>   015 auto quick snapshot
>   016 auto quick send
> +017 auto quick qgroup
>   018 auto quick subvol
>   019 auto quick send
>   020 auto quick replace
> 

