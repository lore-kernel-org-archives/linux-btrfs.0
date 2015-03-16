Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbbCPLhI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Mar 2015 07:37:08 -0400
Date: Mon, 16 Mar 2015 12:37:02 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
To: Filipe Manana <fdmanana@suse.com>
cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: generic test for fallocate
In-Reply-To: <1426174736-982-1-git-send-email-fdmanana@suse.com>
Message-ID: <alpine.LFD.2.00.1503161236000.10086@localhost.localdomain>
References: <1426174736-982-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 12 Mar 2015, Filipe Manana wrote:

> Date: Thu, 12 Mar 2015 15:38:56 +0000
> From: Filipe Manana <fdmanana@suse.com>
> To: fstests@vger.kernel.org
> Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
> Subject: [PATCH] fstests: generic test for fallocate
> 
> Test extent pre-allocation (using fallocate) into a region that already has a
> pre-allocated extent that ends beyond the file's size. Verify that if the fs
> is unmounted immediately after, the file's size and content are not lost.
> 
> This is motivated by a minor issue found in btrfs where the second fallocate
> wouldn't update the inode's i_size on disk, fixed by the following btrfs
> patch: "Btrfs: add missing inode item update in fallocate()".

Looks good.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks!
-Lukas

> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  tests/generic/071     | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/071.out |  9 ++++++
>  tests/generic/group   |  1 +
>  3 files changed, 89 insertions(+)
>  create mode 100755 tests/generic/071
>  create mode 100644 tests/generic/071.out
> 
> diff --git a/tests/generic/071 b/tests/generic/071
> new file mode 100755
> index 0000000..7aaaed7
> --- /dev/null
> +++ b/tests/generic/071
> @@ -0,0 +1,79 @@
> +#! /bin/bash
> +# FS QA Test No. 071
> +#
> +# Test extent pre-allocation (using fallocate) into a region that already has a
> +# pre-allocated extent that ends beyond the file's size. Verify that if the fs
> +# is unmounted immediately after, the file's size and content are not lost.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2015 SUSE Linux Products GmbH. All Rights Reserved.
> +# Author: Filipe Manana <fdmanana@suse.com>
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
> +
> +_cleanup()
> +{
> +	rm -f $tmp.*
> +}
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_need_to_be_root
> +_require_scratch
> +_require_xfs_io_command "falloc"
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount
> +
> +# Create our test file with a pre-allocated extent that doesn't increase the
> +# file's size.
> +$XFS_IO_PROG -f -c "falloc -k 0 1M" $SCRATCH_MNT/foo
> +
> +# Write some data to our file.
> +$XFS_IO_PROG -c "pwrite -S 0xaa 0 256K" $SCRATCH_MNT/foo | _filter_xfs_io
> +
> +# Now call fallocate again, but allowing it to increase the file's size and
> +# cover a range that is entirely covered by the extent that we previously
> +# pre-allocated.
> +$XFS_IO_PROG -c "falloc 0 512K" $SCRATCH_MNT/foo
> +
> +# Now ummount and mount again the fs. After this we expect the file's size to
> +# be 512Kb.
> +_scratch_remount
> +
> +# Now check that all data we wrote before are available and the file size is
> +# 512Kb.
> +echo "File content after remount:"
> +od -t x1 $SCRATCH_MNT/foo
> +
> +status=0
> +exit
> diff --git a/tests/generic/071.out b/tests/generic/071.out
> new file mode 100644
> index 0000000..c12fd00
> --- /dev/null
> +++ b/tests/generic/071.out
> @@ -0,0 +1,9 @@
> +QA output created by 071
> +wrote 262144/262144 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +File content after remount:
> +0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
> +*
> +1000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> +*
> +2000000
> diff --git a/tests/generic/group b/tests/generic/group
> index 05cc6a9..b4e5cc6 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -73,6 +73,7 @@
>  068 other auto freeze dangerous stress
>  069 rw udf auto quick
>  070 attr udf auto quick stress
> +071 auto quick prealloc
>  074 rw udf auto
>  075 rw udf auto quick
>  076 metadata rw udf auto quick stress
> 
