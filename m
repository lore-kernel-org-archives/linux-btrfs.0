Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750760AbdFPEUQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Jun 2017 00:20:16 -0400
Date: Fri, 16 Jun 2017 12:20:14 +0800
From: Eryu Guan <eguan@redhat.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: fstests@vger.kernel.org, jeffm@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs/145: Test various btrfs operations rounding
 behavior
Message-ID: <20170616042014.GF17436@eguan.usersys.redhat.com>
References: <1497534338-11433-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1497534338-11433-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 15, 2017 at 04:45:38PM +0300, Nikolay Borisov wrote:
> When changing the size of disks/filesystem we should always be
> rounding down to a multiple of sectorsize. This is a test for the following
> btrfs patche: 
> 
> btrfs: Round up values which are written for total_bytes_size
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

[ cc btrfs list ]

I'd like to use some help from other btrfs developers on this test :)

I'll comment from fstests perspective of view.

> ---
>  tests/btrfs/145     | 147 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/145.out |  20 +++++++
>  tests/btrfs/group   |   1 +
>  3 files changed, 168 insertions(+)
>  create mode 100755 tests/btrfs/145
>  create mode 100644 tests/btrfs/145.out
> 
> diff --git a/tests/btrfs/145 b/tests/btrfs/145
> new file mode 100755
> index 0000000..4461b37
> --- /dev/null
> +++ b/tests/btrfs/145
> @@ -0,0 +1,147 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/145
> +# 

Trailing whitespace issue in above line, and many other lines in this
test, please remove them all.

> +# Test that various code paths which deal with modifying the total size
> +# of devices/superblock correctly round the value to a multiple of 
> +# sector size
> +#
> +#-----------------------------------------------------------------------
> +#
> +# Copyright (C) 2017 SUSE Linux Products GmbH. All Rights Reserved.
> +# Author: Nikolay Borisov <nborisov@suse.com>
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
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	$UMOUNT_PROG $loop_mnt 
> +	_destroy_loop_device $loop_dev1
> +	_destroy_loop_device $loop_dev2
> +	cd /
> +	rm -f $tmp.*
> +	
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_require_loop
> +_require_block_device $SCRATCH_DEV

I see 'btrfs inspect-internal dump-super' is used, I think we need

_require_btrfs_command inspect-internal dump-super

> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount
> +
> +
> +#Size of devices which are going to be half a page larger than 
> +#default sectorsize (4kb)

Nitpick, please add a space after '#' for comments.

> +expectedsize=$(( 1 * 1024 * 1024 * 1024 )) 
> +filesize=$(( $expectedsize + 2048 ))
> +loop_mnt=$SCRATCH_MNT/mount
> +fs_img1=$SCRATCH_MNT/disk1.img
> +fs_img2=$SCRATCH_MNT/disk2.img
> +
> +mkdir $loop_mnt
> +
> +#create files to hold dummy devices
> +$XFS_IO_PROG -f -c "falloc 0 $filesize" $fs_img1 &> /dev/null
> +$XFS_IO_PROG -f -c "falloc 0 $filesize" $fs_img2 &> /dev/null

Perhaps we need to make sure $SCRATCH_MNT has enough free space to hold
the two fs imgs.

_require_fs_space $SCRATCH_MNT <size_in_kb>

> +
> +loop_dev1=$(_create_loop_device $fs_img1)
> +loop_dev2=$(_create_loop_device $fs_img2) 
> +
> +#create fs only on the first device
> +_mkfs_dev $loop_dev1 
> +_mount $loop_dev1 $loop_mnt
> +
> +echo "Size from mkfs"
> +$BTRFS_UTIL_PROG inspect-internal dump-super /dev/loop0 | grep total
                                                ^^^^^^^^^^ $loop_dev1
> +
> +#resize down to 768mb + 2k
> +$BTRFS_UTIL_PROG fi resize 824182784 $loop_mnt >>$seqres.full 2>&1 

Better to use full subcommand name, i.e. s/fi/filesystem/, I remembered
there was a patch to do this

2fd80ca btrfs: use full subcommand names

> +sync
> +
> +echo ""
> +
> +echo "Size after resizing down"
> +$BTRFS_UTIL_PROG inspect-internal dump-super $loop_dev1 | grep total
> +
> +echo ""
> +
> +#now resize back up to 1 gb
> +$BTRFS_UTIL_PROG fi resize max $loop_mnt >>$seqres.full 2>&1 
> +sync
> +
> +echo "Size after resizing up"
> +$BTRFS_UTIL_PROG inspect-internal dump-super /dev/loop0 | grep total
> +
> +#Add fs load for later balance operations, we need to do this 
> +#before adding a second device
> +$FSSTRESS_PROG -w -n 15000 -p 2 -d $loop_mnt >> $seqres.full 2>&1
> +
> +#add second unaligned device, this checks the btrfs_init_new_device codepath 
> +#device should be aligned
> +$BTRFS_UTIL_PROG device add $loop_dev2 $loop_mnt >>$seqres.full 2>&1
> +sync
> +
> +echo ""
> +
> +#Ensure that adding a device doesn't cause the superbock to be
> +#unaligned
> +echo "Size of superblock after device addition"
> +$BTRFS_UTIL_PROG inspect-internal dump-super $loop_dev1 | grep total
> +
> +echo ""
> +
> +#The newly added device must also be aligned
> +echo "Size of superblock/device for second device"
> +$BTRFS_UTIL_PROG inspect-internal dump-super $loop_dev2 | grep total
> +
> +#now start a balance, this might produce warnings while
> +#it's relocating chunks and updating the size of devices
> +$BTRFS_UTIL_PROG balance start $loop_mnt >> $seqres.full 2>&1
> +sync
> +
> +#delete everything and then run balance
> +rm -rf $loop_mnt/*
> +
> +#do a bit more stress testing until we fill the fs 
> +$FSSTRESS_PROG -w -n 15000 -p 4 -d $loop_mnt >> $seqres.full 2>&1
> +rm -rf $loop_mnt/p0 $loop_mnt/p2
> +
> +#run balance again, this time we will be freeing chunks 
> +$BTRFS_UTIL_PROG balance start $loop_mnt >> $seqres.full 2>&1
> +sync
> +
> +#Warnings are produced if we try to store unaligned values
> +_check_dmesg

By default, the test harness will do this after each test, so there's no
need to call _check_dmesg explicitly in test.

Thanks,
Eryu

> +
> +status=$?
> +exit
> diff --git a/tests/btrfs/145.out b/tests/btrfs/145.out
> new file mode 100644
> index 0000000..7340db2
> --- /dev/null
> +++ b/tests/btrfs/145.out
> @@ -0,0 +1,20 @@
> +QA output created by 145
> +Size from mkfs
> +total_bytes		1073741824
> +dev_item.total_bytes	1073741824
> +
> +Size after resizing down
> +total_bytes		824180736
> +dev_item.total_bytes	824180736
> +
> +Size after resizing up
> +total_bytes		1073741824
> +dev_item.total_bytes	1073741824
> +
> +Size of superblock after device addition
> +total_bytes		2147483648
> +dev_item.total_bytes	1073741824
> +
> +Size of superblock/device for second device
> +total_bytes		2147483648
> +dev_item.total_bytes	1073741824
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index be05487..6c930d4 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -147,3 +147,4 @@
>  142 auto quick
>  143 auto quick
>  144 auto quick send
> +145 auto quick
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
