Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39282 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757235AbcILJSj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 05:18:39 -0400
Date: Mon, 12 Sep 2016 17:18:32 +0800
From: Eryu Guan <eguan@redhat.com>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] generic: check whether we can truncate heavily reflinked
 file
Message-ID: <20160912091832.GL27776@eguan.usersys.redhat.com>
References: <20160912063659.4112-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160912063659.4112-1-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 12, 2016 at 02:36:59PM +0800, Wang Xiaoguang wrote:
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

It's better to describe the test a bit in the commit log, e.g. why this
test is needed etc., which at least could give us some historical
information when we look at this case again some time later. I guess
there's a btrfs bug that truncate would fail due to ENOSPC.

> ---
>  tests/generic/377     | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/377.out |  2 ++
>  tests/generic/group   |  1 +
>  3 files changed, 77 insertions(+)
>  create mode 100755 tests/generic/377
>  create mode 100644 tests/generic/377.out
> 
> diff --git a/tests/generic/377 b/tests/generic/377
> new file mode 100755
> index 0000000..3a0c27e
> --- /dev/null
> +++ b/tests/generic/377
> @@ -0,0 +1,74 @@
> +#! /bin/bash
> +# FS QA Test 377
> +#
> +# Create a heavily reflinked file, then check whether we can truncate
> +# it correctly.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Fujitsu.  All Rights Reserved.
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
> +. ./common/reflink
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_require_scratch_reflink
> +_require_cp_reflink

cp is not used, so this "require" is not needed.

> +
> +_scratch_mkfs_sized $((128 * 1024 * 1024)) >> $seqres.full 2>&1
> +_scratch_mount
> +
> +file=$SCRATCH_MNT/testfile
> +blocksize=$((128 * 1024))
> +
> +# create the initial file.
> +_pwrite_byte 0xcdcdcdcd 0 $blocksize  $file > /dev/null
> +
> +echo "Silence is golden"
> +# filesize is 20GB, and here 20GB is choosen deliberately, so it
> +# can consume enough fs free space.
> +for ((i=1; i<163840; i++)); do
> +	_reflink_range $file 0 $file $(($i * $blocksize)) $blocksize \
> +		>> $seqres.full 2>&1
> +done
> +$XFS_IO_PROG -f -c 'truncate 0' $file

This took me more than 10 minutes to finish on my test vm (4vcpu and 8G
memory), 980s for XFS and 700s for btrfs(truncate failed due to ENOSPC).
That's too long for an 'auto' test.

Can the runtime be reduced? I'm not sure how long time it took for you,
but it would be good to have it finish around 5 minutes.

Thanks,
Eryu

> +
> +status=0
> +exit
> diff --git a/tests/generic/377.out b/tests/generic/377.out
> new file mode 100644
> index 0000000..d14a512
> --- /dev/null
> +++ b/tests/generic/377.out
> @@ -0,0 +1,2 @@
> +QA output created by 377
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index bad71bc..ea98752 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -379,3 +379,4 @@
>  374 auto quick clone dedupe
>  375 auto quick acl
>  376 auto quick metadata
> +377 auto clone
> -- 
> 2.9.0
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
