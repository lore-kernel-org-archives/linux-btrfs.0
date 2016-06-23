Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbcFWI1V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 04:27:21 -0400
Date: Thu, 23 Jun 2016 16:27:18 +0800
From: Eryu Guan <eguan@redhat.com>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: check truncate can update file size correctly
 when truncate fails
Message-ID: <20160623082718.GF3226@eguan.usersys.redhat.com>
References: <1466667400-21639-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466667400-21639-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 03:36:40PM +0800, Wang Xiaoguang wrote:
> In btrfs, when truncate operation fails for enospc reason, file may still
> have some disk blocks, but it will fail to update filesize accordingly.
> 
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  tests/btrfs/124     | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/124.out |  2 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 89 insertions(+)
>  create mode 100755 tests/btrfs/124
>  create mode 100644 tests/btrfs/124.out
> 
> diff --git a/tests/btrfs/124 b/tests/btrfs/124
> new file mode 100755
> index 0000000..1a13ddf
> --- /dev/null
> +++ b/tests/btrfs/124
> @@ -0,0 +1,86 @@
> +#! /bin/bash
> +# FS QA Test 124
> +#
> +# Test whether truncate can update file size correctly when truncate fails
> +#
> +# When truncate operation fails for enospc reason, file will still
> +# have some disk blocks, but it will fail to update filesize accordingly.
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
> +_supported_fs btrfs

Two "_supported_fs" here.

And I don't see any other btrfs-specific configs except MKFS_OPTIONS, is
it possible to make it a generic test?

> +_require_scratch_reflink
> +
> +MKFS_OPTIONS="-O ^mixed-bg"

Need comments on why testing with this MKFS_OPTIONS.

> +_scratch_mkfs_sized $((101 * 1024 * 1024)) >> $seqres.full 2>&1

101M is too small to make btrfs on ppc64 host for me.

> +_scratch_mount
> +
> +blocksize=$((128 * 1024))
> +file="$SCRATCH_MNT/testfile"
> +filesize=$((12 * 1024 * 1024 * 1024))

Comments on these numbers picked would be good, i.e. why 128k blocksize,
why 12M filesize. Any special reason or just good enough for the test?

> +nr=$((filesize / blocksize))
> +
> +# write the initial block for later reflink
> +_pwrite_byte 0xcdcdcdcd 0 $blocksize $file > /dev/null
> +
> +# use reflink to create the rest of the file, whose all extents are all
> +# pointing to the first extent
> +for ((i = 1; i < $nr; i++)); do
> +	_reflink_range $file 0 $file $(($i * $blocksize)) $blocksize > /dev/null
> +done

It's not clear to me in test description that why reflink is needed in
this test. Perhaps test description and comments above can be updated to
reflect the purpose of reflink?

> +
> +$XFS_IO_PROG -f -c "truncate 0" $file > /dev/null 2>&1
> +disk_usage=`du $file | $AWK_PROG '{print $1}'`
> +new_filesize=`ls -l $file | $AWK_PROG '{print $5}'`

I think "stat -c %s $file" is much easier :)

> +if [ $disk_usage -gt 0 ] && [ $new_filesize -eq 0 ]; then
> +	echo "after truncate, file size is 0, but file still owns disk blocks"
> +	status=1
> +	exit
> +fi
> +
> +echo "Silence is golden"
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/124.out b/tests/btrfs/124.out
> new file mode 100644
> index 0000000..d7339e6
> --- /dev/null
> +++ b/tests/btrfs/124.out
> @@ -0,0 +1,2 @@
> +QA output created by 124
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 5a26ed7..8b5050e 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -126,3 +126,4 @@
>  121 auto quick snapshot qgroup
>  122 auto quick snapshot qgroup
>  123 auto quick qgroup
> +124 auto quick metadata

Add it to 'clone' group as well?

Thanks,
Eryu
