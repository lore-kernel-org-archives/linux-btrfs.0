Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754803AbdDEB10 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Apr 2017 21:27:26 -0400
Date: Wed, 5 Apr 2017 09:27:23 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs: Check if btrfs will create
 inline-then-regular file extents
Message-ID: <20170405012723.GR22845@eguan.usersys.redhat.com>
References: <20170403030139.7677-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170403030139.7677-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 03, 2017 at 11:01:39AM +0800, Qu Wenruo wrote:
> Btrfs allows inline file extent if and only if
> 1) It's at offset 0
> 2) It's smaller than min(max_inline, page_size)
>    Although we don't specify if the size is before compression or after
>    compression.
>    At least according to current behavior, we are only limiting the size
>    after compression.
> 3) It's the only file extent
>    So that if we append existing inline extent, it should be converted
>    to regular file extents.
> 
> However several users in btrfs mail list have reported invalid inline
> file extent, which only meets the first two condition, but with regular
> file extents follows.
> 
> The bug is here for a long long time, so long that we have modified
> kernel and btrfs-progs to accept such case, but it's still not designed
> behavior, and must be detected and fixed.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Better to have btrfs developers review this too to see if it's a valid
test. Some comments inline from fstests perspective of view.

> ---
>  tests/btrfs/140     | 124 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/140.out |   2 +
>  tests/btrfs/group   |   1 +
>  3 files changed, 127 insertions(+)
>  create mode 100755 tests/btrfs/140
>  create mode 100644 tests/btrfs/140.out
> 
> diff --git a/tests/btrfs/140 b/tests/btrfs/140
> new file mode 100755
> index 0000000..139df76
> --- /dev/null
> +++ b/tests/btrfs/140
> @@ -0,0 +1,124 @@
> +#! /bin/bash
> +# FS QA Test 140
> +#
> +# Check if btrfs will create inline-then-regular file layout.
> +#
> +# Btrfs only allows inline file extent if file is small enough, and any
> +# incoming write enlarges the file beyong max_inline should replace inline
> +# extents with regular extents.
> +# This is a long standing bug, so fsck won't detect it and kernel will allow
> +# normal read on it, but should be avoided.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Fujitsu.  All Rights Reserved.
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
> +_require_scratch
> +_require_btrfs_command inspect-internal dump-tree
> +
> +inline_size=2048
> +page_size=$(get_page_size)
> +src_subv="$SCRATCH_MNT/src"
> +dst_subv="$SCRATCH_MNT/dst"
> +runtime=$(($LOAD_FACTOR * 8))	#The possibility is over 80%, just in case

This confused me a bit, I thought test would run for $runtime seconds
and wanted to suggest s/LOAD_FACTOR/TIME_FACTOR, but runtime is really a
loop counter. Mind renaming it to something more obvious, like
loop_count?

> +corrupted=0
> +
> +do_test()
> +{
> +	local ret
> +	_scratch_mkfs > /dev/null >&1
                                 ^^^^ meant 2>&1 ?
> +
> +	# specify max_inline and compress explicitly to create
> +	# inlined compressed extent
> +	_scratch_mount "-o max_inline=$inline_size,compress"
> +	

Whitespace issue in above line.

> +	# Subvolume id=257
> +	_run_btrfs_util_prog subvolume create $src_subv
> +
> +	# Page sized data will be compressed to quite small size,
> +	# which is about 50 bytes for 4K, 100 bytes for 64K,
> +	# far smaller than $inline_size, causing a inlined compressed
> +	# file extent
> +	xfs_io -f -c "pwrite 0 $page_size" $src_subv/file > /dev/null
> +	sync

$XFS_IO_PROG and use '-c fsync' to sync the file.

> +
> +	# Subvolume id=258
> +	_run_btrfs_util_prog subvolume snapshot $src_subv $dst_subv
> +	

Whitespace issue.

> +	# Append another page to file in snapshot, since its offset is not
> +	# 0, it will cause regular extent, and should convert inline extent
> +	# to regular too.
> +	xfs_io -c "pwrite $page_size $page_size" $dst_subv/file > /dev/null

$XFS_IO_PROG

> +	_scratch_unmount
> +
> +	# Fsck won't report inline-then-regular as error, as it's so long
> +	# standing that we have no choice but to accept.
> +	# So here we use dump-tree to catch inline extent of $dst_subv, and
> +	# we need piping stdout, call btrfs-progs directly
> +	$BTRFS_UTIL_PROG inspect-internal dump-tree -t 258 $SCRATCH_DEV \
> +		> $tmp.dump_tree
> +	if [[ $(cat $tmp.dump_tree | grep inline) ]]; then

if grep -q inline $tmp.dump_tree; then

> +		cat $tmp.dump_tree >> $seqres.full
> +		echo "Invalid inline file extent detected"
> +		return 1
> +	fi
> +	return 0
> +}
> +
> +for i in $(seq 1 $runtime); do
> +	do_test
> +	if [ $? -ne 0 ]; then
> +		corrupted=$(($corrupted + 1))
> +	fi
> +done
> +
> +if [ $corrupted -ne 0 ]; then
> +	echo "Corruption possibility: $corrupted/$runtime" >> $seqres.full
> +fi

Hmm, I don't think $corrupted is needed, just echo the message to
$seqres.full unconditionally would be fine.

Thanks,
Eryu

> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/140.out b/tests/btrfs/140.out
> new file mode 100644
> index 0000000..24e90bc
> --- /dev/null
> +++ b/tests/btrfs/140.out
> @@ -0,0 +1,2 @@
> +QA output created by 140
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 641d826..e4c76e3 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -142,3 +142,4 @@
>  137 auto quick send
>  138 auto compress
>  139 auto qgroup
> +140 auto
> -- 
> 2.9.3
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
