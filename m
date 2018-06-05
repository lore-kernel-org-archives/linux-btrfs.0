Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:53632 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751786AbeFEKje (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2018 06:39:34 -0400
Subject: Re: [PATCH] fstests: btrfs: Test if btrfs will corrupt nodatasum
 compressed extent when replacing device
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org
References: <20180601013448.22450-1-wqu@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ab3e01d0-5171-eb6d-d7cc-a14ce1f55db3@oracle.com>
Date: Tue, 5 Jun 2018 18:42:16 +0800
MIME-Version: 1.0
In-Reply-To: <20180601013448.22450-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/01/2018 09:34 AM, Qu Wenruo wrote:
> This is a long existing bug (from 2012) but exposed by a reporter
> recently, that when compressed extent without data csum get written to
> device-replace target device, the written data is in fact uncompressed data
> other than the original compressed data.
> 
> And since btrfs still consider the data is compressed and will try to read it
> as compressed, it can cause read error.
> 
> The root cause is located, and one RFC patch already sent to fix it,
> titled "[PATCH RFC] btrfs: scrub: Don't use inode pages for device replace".
> (The RFC is only for the extra possible way to fix the bug, the fix
> itself should work without problem)
> 
> Reported-by: James Harvey <jamespharvey20@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   tests/btrfs/161     | 91 +++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/161.out |  2 +
>   tests/btrfs/group   |  1 +
>   3 files changed, 94 insertions(+)
>   create mode 100755 tests/btrfs/161
>   create mode 100644 tests/btrfs/161.out
> 
> diff --git a/tests/btrfs/161 b/tests/btrfs/161
> new file mode 100755
> index 00000000..d4a2b474
> --- /dev/null
> +++ b/tests/btrfs/161
> @@ -0,0 +1,91 @@
> +#! /bin/bash
> +# FS QA Test 161
> +#
> +# Test if btrfs will corrupt compressed data extent without data csum
> +# by replacing it with uncompressed data, when doing replacing device.
> +#
> +# This could be fixed by the following RFC patch:
> +# "[PATCH RFC] btrfs: scrub: Don't use inode pages for device replace"
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2018 SUSE Linux Products GmbH. All Rights Reserved.
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
> +	cd /
> +	rm -f $tmp.*
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
> +
> +# Modify as appropriate.
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_test
> +_require_scratch_dev_pool 2
> +_require_scratch_dev_pool_equal_size
> +
> +
> +_scratch_dev_pool_get 1
> +_spare_dev_get
> +_scratch_pool_mkfs >> $seqres.full 2>&1
> +
> +# Create nodatasum inode
> +_scratch_mount "-o nodatasum"
> +touch $SCRATCH_MNT/nodatasum_file
> +_scratch_remount "datasum,compress"
> +_pwrite_byte 0xcd 0 128K $SCRATCH_MNT/nodatasum_file > /dev/null
> +
> +# Write the compressed data back to disk
> +sync
> +
> +# Replace the device
> +_run_btrfs_util_prog replace start -Bf 1 $SPARE_DEV $SCRATCH_MNT
> +
> +_scratch_unmount
> +
> +_mount $SPARE_DEV $SCRATCH_MNT
> +
> +# Since now the compressed extent contains *UNCOMPRESSED* data, reading it will
> +# easily trigger a EIO error

  This sentence is confusing. Are you referring to the bug?
  what is compressed extent containing uncompressed data?

Thanks, Anand

> +cat $SCRATCH_MNT/nodatasum_file > /dev/null
> +
> +_scratch_unmount
> +_spare_dev_put
> +_scratch_dev_pool_put
> +
> +echo "Silence is golden"
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/161.out b/tests/btrfs/161.out
> new file mode 100644
> index 00000000..1752a243
> --- /dev/null
> +++ b/tests/btrfs/161.out
> @@ -0,0 +1,2 @@
> +QA output created by 161
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index f04ee8d5..f900b3d0 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -163,3 +163,4 @@
>   158 auto quick raid scrub
>   159 auto quick
>   160 auto quick
> +161 auto quick replace
> 
