Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbbHZNYj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 09:24:39 -0400
Subject: Re: btrfs -o discard bug in latest dev branches
To: Jun He <jhe@cs.wisc.edu>, linux-btrfs@vger.kernel.org
References: <20150826040442.GC10927@Juns-MacBook-Pro.local>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <55DDBE12.1020104@suse.com>
Date: Wed, 26 Aug 2015 09:24:34 -0400
MIME-Version: 1.0
In-Reply-To: <20150826040442.GC10927@Juns-MacBook-Pro.local>
Content-Type: multipart/mixed;
 boundary="------------070305080307020005010205"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070305080307020005010205
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 8/26/15 12:04 AM, Jun He wrote:
> Hi, I have been playing with btrfs discard for a while and found
> that btrfs may fail to discard some extents with 'mount -o
> discard'. I am aware of Jeff Mahoney's patches (
> https://patchwork.kernel.org/patch/6609491/ ). It seems that the
> patches do not fix the problem. I have seen the same problematic 
> behavior for the following versions
> 
> - https://git.kernel.org/cgit/linux/kernel/git/fdmanana/linux.git/ 
> integration-4.3 commit:477594f93c43b1ee685 - 3.16.0 - 4.2.0-rc7
> 
> The problem can be reproduced by writing and fsyncing a 4MB file
> for 50 times on a 256MB empty FS (mount option: -o discard). You
> will find that some extents are not discarded (my expected behavior
> is that, after overwriting, an old version of a file extent should
> be discarded). I use several ways to confirm this:
> 
> 1. I created a loop device back by a sparse file in tmpfs. After
> running the workload, I found the file is 29MB (ls -lsh). If you
> fstrim the file system, the sparse file will become 4.1MB. This
> proves that there are a lot of data not discarded.

Can you capture the output of 'filefrag -b -v' for the sparse file in
tmpfs both before and after trim?  Also btrfs-debug-tree output for it.

> 2. I collected blktrace + blkparse output and plotted the write and
> discard operations in a space-time graph, where you can intuitively
> see some extents are overwritten but not discarded. Here is the
> space-time graph 
> https://gist.githubusercontent.com/junhe/b6ce39eeb6de8887e66a/raw/825a
3c2946b52a50c2b6032a98d637f5a32bc5c3/integration-4.3.png
>
>  Is it a known problem or is it not a problem? If it is a known
> problem and there exists a patch that I am not aware of, can
> somebody direct me to it? If it is specifically designed this way,
> can the designers give the rationale of discarding some, but not
> all of, old extents?
> 
> The reproducer can be run by: git clone
> https://gist.github.com/b6ce39eeb6de8887e66a.git cd
> b6ce39eeb6de8887e66a sudo python main.py
> 
> It also has a readme.

I tested my discard patches the other day against 4.2-rc8 and it
passed my 326 test.  I'll check out your reproducer.

- -Jeff



- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJV3b4SAAoJEB57S2MheeWyTUMP/R2mF2/6RcXO0iXNJw466/qI
VzEV09C5Cs04NnDSfY0ZPk3W6iD1B4iOnHB1HF+lK8ENeF/Ug+0Tnb1uJpEo4lvn
+yTxUx+qYwo737SU9oTjmvpr4aXzmV3I223gylcPnaXCQu8w80BsldIBvL98ExIq
Ad/ZzuPMAfc3jvhcEZrDTN6L77rIyhXkhGT/fMnRcycW/26myd8HbJDjE0lebmvY
9+L15Ykgm52V4zpW5wSQh1xww8WWsKv/K6nF3shuNPlhmovOwtAAEJhLRQcpJp5e
+jSijexTsd9so5smwc+JJ+sW86zZ6G6opL/K96MJNEXZ4UMBQPaOYNrewAHTh8Xe
V4WzvbL/JWcKAAzPugvhRGjP2xjM+E1oBQGvZEGEmZb0lneW5Fouao9xGXtftRr9
NAc7A8D/WkqSxDb7qhEdmQpexsQNfPMQi4JmTj0/kGCjYAhxCuVlPgNjorE70BW/
nze9Fg1zydZZs0XeQW4Bh4+HU3yjexLshQCgXjnhabmc9+VwBnEuizYVtcjFgm8r
vBCj80cAID7n7PtPhDNE7DfFHLuigpA6hTw+vgUxL1zd4yHEjQ3pGZ0lZuVK42oZ
EIqKX7r0maU24pQGj1v9NL8QPqYQmrj9ljUmk3QSlvjTUGVv5y8U+KVX7h3cGJRO
YMs7n+5BMmI6WKZBn+fr
=StBb
-----END PGP SIGNATURE-----

--------------070305080307020005010205
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="326"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="326"

#! /bin/bash
# FSQA Test No. 326
#
# This test uses a loopback mount with PUNCH_HOLE support to test
# whether discard operations are working as expected.
#
# It tests both -odiscard and fstrim.
#
# Copyright (C) 2015 SUSE. All Rights Reserved.
# Author: Jeff Mahoney <jeffm@suse.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it would be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write the Free Software Foundation,
# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#-----------------------------------------------------------------------
#

seq=`basename $0`
seqres=$RESULT_DIR/$seq
echo "QA output created by $seq"

tmp=/tmp/$$
status=1	# failure is the default!
trap "_cleanup; exit \$status" 0 1 2 3 15

loopdev=
tmpdir=
_cleanup()
{
	[ -n "$tmpdir" ] && umount $tmpdir
	[ -n "$loopdev" ] && losetup -d $loopdev
}

# get standard environment, filters and checks
. ./common/rc
. ./common/filter

# real QA test starts here
_need_to_be_root
_supported_fs generic
_supported_os Linux
_require_scratch
_require_fstrim

MB_BYTES=1048576
GB_BYTES=1073741824

TEST_FS_SIZE_MB=1024
SMFILE_MIN_SIZE=512
SMFILE_MAX_SIZE=$(( 3 * $MB_BYTES ))
LARGEFILE_SIZE_MB=100

# The test methodology is generic, but the values used by each file system
# for the results to make sense may not be.
if [ "$FSTYP" = "btrfs" ]; then
	MAX_REMAINING_MB=10
	TEST_FS_SIZE_MB=10240
	# Larger than a single block group
	LARGEFILE_SIZE_MB=$(( 12 * $GB_BYTES ))
elif [ "$FSTYP" = "xfs" ]; then
	MAX_REMAINING_MB=50
else # ext4, probably, but sufficiently permissive that it should work anywhere
	# Special; Means at
	MAX_REMAINING_MB=0
fi

test_fs_size_bytes=$(( $TEST_FS_SIZE_MB * $MB_BYTES ))

rm -f $seqres.full

_scratch_mkfs &>> $seqres.full
_require_fs_space $SCRATCH_MNT $TEST_FS_SIZE_MB
_scratch_mount

blocks_used_kb()
{
	blocks=$(( $(stat --format="%b*%B/1024" "$1") ))
	echo "# blocks_used_kb $1 ($2)" >> $seqres.full
	echo "$blocks $1" >> $seqres.full
	echo $blocks
}

random_size()
{
	MIN=$1
	MAX=$2
	echo $(( $MIN + ($MAX - $MIN) * $RANDOM / 32768 ))
}

test_discard()
{
	discard=$1
	files=$2

	tmpfile=$SCRATCH_MNT/testfs.img.$$
	tmpdir=$SCRATCH_MNT/testdir.$$
	testdir=$tmpdir/testdir
	mkdir -p $tmpdir || _fail "!!! failed to create temp mount dir"

	# Create a sparse file to host the file system
	$XFS_IO_PROG -f -t -c "truncate $test_fs_size_bytes" $tmpfile \
		|| _fail "!!! failed to create fs image file"

	opts=""
	if [ "$discard" = "discard" ]; then
		opts="-o discard"
	fi

	loopdev=$(losetup --show -f $tmpfile)
	_mkfs_dev $loopdev &> $seqres.full
	$MOUNT_PROG $opts $loopdev $tmpdir \
		|| _fail "!!! failed to loopback mount"


	$FSTRIM_PROG $tmpdir

	ESIZE="$(blocks_used_kb $tmpfile "empty filesystem")"

	if [ "$files" = "large" ]; then
		count=$(( $TEST_FS_SIZE_MB / $LARGEFILE_SIZE_MB ))
		random=false
	else
		count=$(( $TEST_FS_SIZE_MB * $MB_BYTES / $SMFILE_MAX_SIZE ))
		random=true
	fi

	mkdir -p $testdir
	for ((i = 1; i <= count; i++)); do
		SIZE=$(( $LARGEFILE_SIZE_MB * $MB_BYTES ))
		if $random; then
			SIZE=$(random_size $SMFILE_MIN_SIZE $SMFILE_MAX_SIZE)
		fi

		fn=${seq}_${i}
		$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 $SIZE" $testdir/$fn \
			&> /dev/null
		if [ $? -ne 0 ]; then
			echo "Failed creating file $fn" \
				>>$seqres.full
			break
		fi
	done

	sync
	OSIZE="$(blocks_used_kb $tmpfile "before removing files")"

	rm -rf $testdir

	# Ensure everything's actually on the hosted file system
	if [ "$FSTYP" = "btrfs" ]; then
		_run_btrfs_util_prog filesystem sync $tmpdir
	fi
	sync
	if [ "$discard" = "trim" ]; then
		$FSTRIM_PROG $tmpdir
	fi

	$UMOUNT_PROG $tmpdir
	rmdir $tmpdir
	tmpdir=

	# Sync the backing file system to ensure the hole punches have
	# happened and we can trust the result.
	if [ "$FSTYP" = "btrfs" ]; then
		_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
	fi
	sync

	NSIZE="$(blocks_used_kb $tmpfile "after trim")"

	# Going from ~ 10GB to 50MB is a good enough test to account for
	# metadata remaining on different file systems.
	if [ "$NSIZE" -gt $(( 50 * 1024 )) ]; then
		_fail "TRIM failed: before rm ${OSIZE}kB, after rm ${NSIZE}kB"
	fi
	rm $tmpfile
	losetup -d $loopdev
	loopdev=
}


echo "Testing with -odiscard, many small files"
test_discard discard many

echo "Testing with -odiscard, several large files"
test_discard discard large

echo "Testing with fstrim, many small files"
test_discard trim many

echo "Testing with fstrim, several large files"
test_discard trim large

status=0
exit

--------------070305080307020005010205
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="326.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="326.out"

QA output created by 326
Testing with -odiscard, many small files
Testing with -odiscard, several large files
Testing with fstrim, many small files
Testing with fstrim, several large files

--------------070305080307020005010205--
