Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751423AbdEJKx3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 06:53:29 -0400
Date: Wed, 10 May 2017 18:53:26 +0800
From: Eryu Guan <eguan@redhat.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@gmail.com>
Subject: Re: [PATCH 3/6] fstests: regression test for btrfs dio read repair
Message-ID: <20170510105326.GB7250@eguan.usersys.redhat.com>
References: <1494352571-17199-1-git-send-email-bo.li.liu@oracle.com>
 <1494352571-17199-4-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1494352571-17199-4-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 09, 2017 at 11:56:08AM -0600, Liu Bo wrote:
> This case tests whether dio read can repair the bad copy if we have
> a good copy.
> 
> Commit 2dabb3248453 ("Btrfs: Direct I/O read: Work on sectorsized blocks")
> introduced the regression.
> 
> The upstream fix is
> 	Btrfs: fix invalid dereference in btrfs_retry_endio

I noticed this is in upstream now, you can refer to it along with hash
tag too.

> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  tests/btrfs/140     | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/140.out |  39 ++++++++++++++++++
>  tests/btrfs/group   |   1 +
>  3 files changed, 155 insertions(+)
>  create mode 100755 tests/btrfs/140
>  create mode 100644 tests/btrfs/140.out
> 
> diff --git a/tests/btrfs/140 b/tests/btrfs/140
> new file mode 100755
> index 0000000..09a9939
> --- /dev/null
> +++ b/tests/btrfs/140
> @@ -0,0 +1,115 @@
> +#! /bin/bash
> +# FS QA Test 140
> +#
> +# Regression test for btrfs DIO read's repair during read.
> +#
> +# Commit 2dabb3248453 ("Btrfs: Direct I/O read: Work on sectorsized blocks")
> +# introduced the regression.
> +# The upstream fix is
> +# 	Btrfs: fix invalid dereference in btrfs_retry_endio
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Liu Bo.  All Rights Reserved.
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
> +_require_scratch_dev_pool 2
> +
> +_require_btrfs_command inspect-internal dump-tree
> +_require_command "$FILEFRAG_PROG" filefrag
> +_require_odirect
> +
> +get_physical()
> +{
> +	# $1 is logical address
> +	# print chunk tree and find devid 2 which is $SCRATCH_DEV
> +	$BTRFS_UTIL_PROG inspect-internal dump-tree -t 3 $SCRATCH_DEV | \
> +	grep $1 -A 6 | awk '($1 ~ /stripe/ && $3 ~ /devid/ && $4 ~ /1/) { print $6 }'
> +}
> +
> +_scratch_dev_pool_get 2
> +# step 1, create a raid1 btrfs which contains one 128k file.
> +echo "step 1......mkfs.btrfs" >>$seqres.full
> +
> +mkfs_opts="-d raid1 -b 1G"
> +_scratch_pool_mkfs $mkfs_opts >>$seqres.full 2>&1
> +
> +# -o nospace_cache makes sure data is written to the start position of the data
> +# chunk
> +_scratch_mount -o nospace_cache
> +
> +$XFS_IO_PROG -f -d -c "pwrite -S 0xaa -b 128K 0 128K" "$SCRATCH_MNT/foobar" | _filter_xfs_io
> +
> +# step 2, corrupt the first 64k of one copy (on SCRATCH_DEV which is the first
> +# one in $SCRATCH_DEV_POOL
> +echo "step 2......corrupt file extent" >>$seqres.full
> +
> +${FILEFRAG_PROG} -v $SCRATCH_MNT/foobar >> $seqres.full
> +logical_in_btrfs=`${FILEFRAG_PROG} -v $SCRATCH_MNT/foobar | _filter_filefrag | cut -d '#' -f 1`
> +physical_on_scratch=`get_physical ${logical_in_btrfs}`
> +
> +_scratch_unmount
> +$XFS_IO_PROG -d -c "pwrite -S 0xbb -b 64K $physical_on_scratch 64K" $SCRATCH_DEV | _filter_xfs_io
> +
> +_scratch_mount
> +
> +# step 3, 128k dio read (this read can repair bad copy)
> +echo "step 3......repair the bad copy" >>$seqres.full
> +
> +# since raid1 consists of two copies, and the following read may read the good
> +# copy directly, so lets loop 10 times here and discard output that dio reads
> +# give
> +for i in `seq 1 10`; do
> +	$XFS_IO_PROG -d -c "pread -b 128K 0 128K" "$SCRATCH_MNT/foobar" > /dev/null
> +	_get_current_dmesg | grep -q -e "csum failed" && break
> +done

Half of the time I got test failure because pread from SCRATCH_DEV read
0xbb instead of 0xaa on v4.11 kernel (bug should be fixed there), tested
on two different hosts and could hit failure on both hosts.

Similar failure happened to all the 4 tests randomly. I thought it was
because "csum failed" was never hit, so I tried a "while true; do" loop,
and that did fix the btrfs/140 failure for me, but then btrfs/141 would
loop forever sometimes.

On the other hand, the tests from your last post always passed on the
same test host, but I didn't see anything particular would make this
difference..

Can you please take a look? Thanks!

Eryu

> +
> +_scratch_unmount
> +
> +# check if the repair works
> +$XFS_IO_PROG -d -c "pread -v -b 512 $physical_on_scratch 512" $SCRATCH_DEV | _filter_xfs_io
> +
> +_scratch_dev_pool_put
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/140.out b/tests/btrfs/140.out
> new file mode 100644
> index 0000000..c8565f5
> --- /dev/null
> +++ b/tests/btrfs/140.out
> @@ -0,0 +1,39 @@
> +QA output created by 140
> +wrote 131072/131072 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 65536/65536 bytes at offset 136708096
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +08260000:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260010:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260020:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260030:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260040:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260050:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260060:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260070:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260080:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260090:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +082600a0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +082600b0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +082600c0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +082600d0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +082600e0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +082600f0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260100:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260110:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260120:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260130:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260140:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260150:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260160:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260170:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260180:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +08260190:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +082601a0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +082601b0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +082601c0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +082601d0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +082601e0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +082601f0:  aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa  ................
> +read 512/512 bytes at offset 136708096
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 9d4b80b..1cb9c98 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -141,3 +141,4 @@
>  137 auto quick send
>  138 auto compress
>  139 auto qgroup
> +140 auto quick
> -- 
> 2.5.0
> 
