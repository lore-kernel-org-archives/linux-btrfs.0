Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:19634 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3JWRFv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 13:05:51 -0400
Message-ID: <526801EF.8030307@giantdisaster.de>
Date: Wed, 23 Oct 2013 19:05:51 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] xfstests btrfs/020: test device replace on RO btrfs
References: <1382527446-16053-1-git-send-email-eguan@redhat.com> <1382546683-454-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1382546683-454-1-git-send-email-eguan@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 24 Oct 2013 00:44:43 +0800, Eryu Guan wrote:
> btrfs replace on readonly fs should not be allowed.
> 
> Regression test case for commit:
> bbb651e Btrfs: don't allow the replace procedure on read only filesystems
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
> v2: Address Eric's review
>  - use truncate to create fs image instead of writing to each file
> 
>  tests/btrfs/020     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/020.out |  2 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 87 insertions(+)
>  create mode 100755 tests/btrfs/020
>  create mode 100644 tests/btrfs/020.out
> 
> diff --git a/tests/btrfs/020 b/tests/btrfs/020
> new file mode 100755
> index 0000000..7464bd0
> --- /dev/null
> +++ b/tests/btrfs/020
> @@ -0,0 +1,84 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/020
> +#
> +# btrfs device replace test on RO fs
> +#
> +# Regression test for commit:
> +# bbb651e Btrfs: don't allow the replace procedure on read only filesystems
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
> +
> +status=1	# failure is the default!
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	$UMOUNT_PROG $loop_mnt
> +	_destroy_loop_device $loop_dev1
> +	losetup -d $loop_dev2 >/dev/null 2>&1
> +	_destroy_loop_device $loop_dev3
> +	rm -rf $loop_mnt
> +	rm -f $fs_img1 $fs_img2 $fs_img3
> +}
> +
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux

It is still unclear to me why everybody adds this "_supported_os Linux"
to the Btrfs tests. Is it because loop devices are used in this
particular test btrfs/020 or is it because of Btrfs itself?
tests/btrfs/001..010 and tests/btrfs/012..020 contain the "_supported_os
Linux".


> +
> +rm -f $seqres.full
> +echo "Silence is golden"
> +
> +loop_mnt=$TEST_DIR/$seq.$$.mnt
> +fs_img1=$TEST_DIR/$seq.$$.img1
> +fs_img2=$TEST_DIR/$seq.$$.img2
> +fs_img3=$TEST_DIR/$seq.$$.img3
> +mkdir $loop_mnt
> +$XFS_IO_PROG -f -c "truncate 256m" $fs_img1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -f -c "truncate 256m" $fs_img2 >>$seqres.full 2>&1
> +$XFS_IO_PROG -f -c "truncate 256m" $fs_img3 >>$seqres.full 2>&1
> +
> +loop_dev1=`_create_loop_device $fs_img1`
> +loop_dev2=`_create_loop_device $fs_img2`
> +loop_dev3=`_create_loop_device $fs_img3`
> +
> +$MKFS_BTRFS_PROG -m raid1 -d raid1 $loop_dev1 $loop_dev2 >>$seqres.full 2>&1
> +$MOUNT_PROG -o ro $loop_dev1 $loop_mnt
> +
> +# Fail the second device and replace with the third
> +_destroy_loop_device $loop_dev2
> +$BTRFS_UTIL_PROG replace start -B 2 $loop_dev3 $loop_mnt >>$seqres.full 2>&1 && \
> +_fail "FAIL: Device replaced on RO btrfs"
> +
> +status=0
> +exit
> diff --git a/tests/btrfs/020.out b/tests/btrfs/020.out
[...]


