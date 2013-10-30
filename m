Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:47218 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3J3LMO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Oct 2013 07:12:14 -0400
Received: by mail-pb0-f41.google.com with SMTP id um1so1275919pbc.28
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 04:12:14 -0700 (PDT)
Date: Wed, 30 Oct 2013 19:12:09 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: add regression test for running btrfs balance
 and defrag concurrently
Message-ID: <20131030111209.GD2708@dhcp-13-216.nay.redhat.com>
References: <1383129533-17043-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1383129533-17043-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 30, 2013 at 06:38:53PM +0800, Liu Bo wrote:
> The test aims to trigger snapshot-aware defrag path in write endio by
> running balance, which is not expected and leads to a crash.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  tests/btrfs/021     |   97 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/021.out |    2 +
>  tests/btrfs/group   |    1 +
>  3 files changed, 100 insertions(+), 0 deletions(-)
>  create mode 100755 tests/btrfs/021
>  create mode 100644 tests/btrfs/021.out
> 
> diff --git a/tests/btrfs/021 b/tests/btrfs/021
> new file mode 100755
> index 0000000..147ac29
> --- /dev/null
> +++ b/tests/btrfs/021
> @@ -0,0 +1,97 @@
> +#! /bin/bash
> +# FS QA Test No. 021
> +#
> +# A regression test of running btrfs balance and defrag concurrently.
> +#
> +# The test aims to trigger snapshot-aware defrag path in endio by
> +# running balance, which is not expected and leads to a crash.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Oracle.  All Rights Reserved.
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
> +run_test()
> +{
> +	$BTRFS_UTIL_PROG balance start $SCRATCH_MNT >> $seqres.full &
> +
> +	sleep 0.5
> +
> +	find $SCRATCH_MNT -type f -print0 | xargs -0 $BTRFS_UTIL_PROG filesystem defrag -f
> +
> +	sync
> +	wait
> +}
> +
> +# Modify as appropriate.
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +
> +
> +for ((j=0; j<100; j++))
> +do
> +	touch $SCRATCH_MNT/padding-$j
> +done
> +
> +for ((j=0; j<50; j++))
> +do
> +	for i in `seq 20 -1 1`
> +	do
> +		dd if=/dev/zero of=$SCRATCH_MNT/foo-$j bs=4k count=1 seek=$i oflag=direct conv=notrunc 2>/dev/null;
> +	done
> +done
> +
> +sync
> +
> +run_test
> +
> +# if error
> +#exit
> +
> +# optional stuff if your test has verbose output to help resolve problems
> +#echo
> +#echo "If failure, check $seqres.full (this) and $seqres.full.ok (reference)"

Please remove these useless comments. Otherwise looks good to me.

Thanks,
Eryu Guan
> +
> +# success, all done
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/btrfs/021.out b/tests/btrfs/021.out
> new file mode 100644
> index 0000000..09f4062
> --- /dev/null
> +++ b/tests/btrfs/021.out
> @@ -0,0 +1,2 @@
> +QA output created by 021
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 1159499..410f8ed 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -23,3 +23,4 @@
>  018 auto quick
>  019 auto quick
>  020 auto quick
> +021 auto quick
> -- 
> 1.7.7
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
