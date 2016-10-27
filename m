Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21837 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932442AbcJ0RNe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 13:13:34 -0400
Date: Thu, 27 Oct 2016 10:13:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] generic: make 17[1-4] work well when btrfs
 compression is enabled
Message-ID: <20161027171321.GA5251@birch.djwong.org>
References: <20161026095211.30091-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161026095211.30091-1-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 05:52:11PM +0800, Wang Xiaoguang wrote:
> When enabling btrfs compression, original codes can not fill fs
> correctly, here we introduce _fill_fs() in common/rc, which'll keep
> creating and writing files until enospc error occurs. Note _fill_fs
> is copied from tests/generic/256, but with some minor modifications.
> 
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
> V2: In common/, I did't find an existing function suitable for
>     these 4 test cases to fill fs, so I still use _pwrite_byte() with
>     a big enough file length fo fill fs. Note, for btrfs, metadata space
>     still is not full, only data space is full, but it's OK for these
>     4 test cases.
> 
>     All these 4 cases pass in xfs and btrfs(without compression), if
>     btrfs has compression enabled, these 4 cases will fail for false
>     enospc error, I have sent kernel patches to fix this bug.
> 
> V3: Introduce  _fill_fs in common/rc to fill fs.
> ---
>  common/rc         | 50 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/171 |  4 +---
>  tests/generic/172 |  4 ++--
>  tests/generic/173 |  4 +---
>  tests/generic/174 |  4 +---
>  tests/generic/256 | 65 +++++--------------------------------------------------
>  6 files changed, 60 insertions(+), 71 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 7a9fc90..0e1ac5d 100644
> --- a/common/rc
> +++ b/common/rc

Would you mind moving this to common/populate, where I've been (slowly)
collecting all the "create stuff inside the filesystem" routines?

(It's part of a slow-moving effort to declutter common/rc.)

> @@ -4003,6 +4003,56 @@ _require_xfs_mkfs_without_validation()
>  	fi
>  }
>  
> +# Fill a file system by repeatedly creating files in the given folder
> +# starting with the given file size.  Files are reduced in size when
> +# they can no longer fit until no more files can be created.
> +_fill_fs()
> +{
> +	local file_size=$1
> +	local dir=$2
> +	local block_size=$3
> +	local switch_user=$4
> +	local file_count=1
> +	local bytes_written=0
> +
> +	if [ $# -ne 4 ]; then
> +		echo "Usage: _fill_fs filesize dir blocksize"
> +		exit 1
> +	fi
> +
> +	if [ $switch_user -eq 0 ]; then
> +		mkdir -p $dir
> +	else
> +		_user_do "mkdir -p $dir"
> +	fi
> +
> +	if [ $file_size -lt $block_size ]; then
> +		$file_size = $block_size
> +	fi
> +
> +	while [ $file_size -ge $block_size ]; do
> +		bytes_written=0
> +		if [ $switch_user -eq 0 ]; then
> +			$XFS_IO_PROG -f -c "pwrite 0 $file_size" \
> +				$dir/$file_count > /dev/null

If you want to speed this up some more you could pass "-b 8388608" in
the pwrite string so that xfs_io will allocate an 8MB memory buffer
internally when writing out data.

$XFS_IO_PROG -f -c "pwrite -b 8388608 0 $file_size" $dir/$file_count

> +		else
> +			_user_do "$XFS_IO_PROG -f -c \"pwrite 0 $file_size\" \
> +				$dir/$file_count > /dev/null"

Also, why redirect to /dev/null?  I think helper functions generally let
the individual test decide where the stdout & stderr output ultimately
end up.  Most tests seem to dump to $seqres.full or /dev/null, but we
should let the test decide where potentially useful diagnostic
information ends up.

/me also wonders if falloc would be a faster way to consume disk blocks
than pwrite, but ... <shrug>

> +		fi
> +
> +		if [ -f $dir/$file_count ]; then
> +			bytes_written=$(stat -c '%s' $dir/$file_count)
> +		fi
> +
> +		# If there was no room to make the file, then divide it in
> +		# half, and keep going
> +		if [ $bytes_written -lt $file_size ]; then
> +			file_size=$((file_size / 2))
> +		fi
> +		file_count=$((file_count + 1))
> +	done
> +}
> +
>  init_rc
>  
>  ################################################################################
> diff --git a/tests/generic/171 b/tests/generic/171
> index a69f798..fde8ef2 100755
> --- a/tests/generic/171
> +++ b/tests/generic/171
> @@ -75,9 +75,7 @@ _cp_reflink $testdir/bigfile $testdir/clonefile
>  sync
>  
>  echo "Allocate the rest of the space"
> -nr_free=$(stat -f -c '%f' $testdir)
> -touch $testdir/file0 $testdir/file1
> -_pwrite_byte 0x61 0 $((blksz * nr_free)) $testdir/eat_my_space >> $seqres.full 2>&1
> +_fill_fs $((32 * 1024 * 1024)) $testdir/space $blksz 0 >> $seqres.full 2>&1

Given that _fill_fs has exponential backoff to try to really fill the fs,
why not call it with $((blksz * nr_free)) instead of a fixed 32MB?

--D

>  sync
>  
>  echo "CoW the big file"
> diff --git a/tests/generic/172 b/tests/generic/172
> index 8192290..3625546 100755
> --- a/tests/generic/172
> +++ b/tests/generic/172
> @@ -57,6 +57,7 @@ testdir=$SCRATCH_MNT/test-$seq
>  mkdir $testdir
>  
>  echo "Reformat with appropriate size"
> +blksz="$(get_block_size $testdir)"
>  umount $SCRATCH_MNT
>  
>  file_size=$((168 * 1024 * 1024))
> @@ -72,8 +73,7 @@ _cp_reflink $testdir/bigfile $testdir/clonefile
>  sync
>  
>  echo "Allocate the rest of the space"
> -touch $testdir/file0 $testdir/file1
> -_pwrite_byte 0x61 0 $fs_size $testdir/eat_my_space >> $seqres.full 2>&1
> +_fill_fs $((32 * 1024 * 1024)) $testdir/space $blksz 0 >> $seqres.full 2>&1
>  sync
>  
>  echo "CoW the big file"
> diff --git a/tests/generic/173 b/tests/generic/173
> index e35597f..3d583b1 100755
> --- a/tests/generic/173
> +++ b/tests/generic/173
> @@ -75,9 +75,7 @@ _cp_reflink $testdir/bigfile $testdir/clonefile
>  sync
>  
>  echo "Allocate the rest of the space"
> -nr_free=$(stat -f -c '%f' $testdir)
> -touch $testdir/file0 $testdir/file1
> -_pwrite_byte 0x61 0 $((blksz * nr_free)) $testdir/eat_my_space >> $seqres.full 2>&1
> +_fill_fs $((32 * 1024 * 1024)) $testdir/space $blksz 0 >> $seqres.full 2>&1
>  sync
>  
>  echo "mmap CoW the big file"
> diff --git a/tests/generic/174 b/tests/generic/174
> index e58d64b..bd7fc11 100755
> --- a/tests/generic/174
> +++ b/tests/generic/174
> @@ -76,9 +76,7 @@ _cp_reflink $testdir/bigfile $testdir/clonefile
>  sync
>  
>  echo "Allocate the rest of the space"
> -nr_free=$(stat -f -c '%f' $testdir)
> -touch $testdir/file0 $testdir/file1
> -_pwrite_byte 0x61 0 $((blksz * nr_free)) $testdir/eat_my_space >> $seqres.full 2>&1
> +_fill_fs $((32 * 1024 * 1024)) $testdir/space $blksz 0 >> $seqres.full 2>&1
>  sync
>  
>  echo "CoW the big file"
> diff --git a/tests/generic/256 b/tests/generic/256
> index cfbf790..9488648 100755
> --- a/tests/generic/256
> +++ b/tests/generic/256
> @@ -53,64 +53,6 @@ _require_test
>  
>  testfile=$TEST_DIR/256.$$
>  
> -# _fill_fs()
> -#
> -# Fills a file system by repeatedly creating files in the given folder
> -# starting with the given file size.  Files are reduced in size when
> -# they can no longer fit untill no more files can be created.
> -#
> -# This routine is used by _test_full_fs_punch to test that a hole may
> -# still be punched when the disk is full by borrowing reserved blocks.
> -# All files are created as a non root user to prevent reserved blocks
> -# from being consumed.
> -#
> -_fill_fs() {
> -	local file_size=$1
> -	local dir=$2
> -	local block_size=$3
> -	local file_count=1
> -	local bytes_written=0
> -
> -	if [ $# -ne 3 ]
> -	then
> -		echo "USAGE: _fill_fs filesize dir block size"
> -		exit 1
> -	fi
> -
> -	# Creation of files or folders
> -	# must not be done as root or
> -	# reserved blocks will be consumed
> -	_user_do "mkdir -p $dir &> /dev/null"
> -	if [ $? -ne 0 ] ; then
> -		return 0
> -	fi
> -
> -	if [ $file_size -lt $block_size ]
> -	then
> -		$file_size = $block_size
> -	fi
> -
> -	while [ $file_size -ge $block_size ]
> -	do
> -		bytes_written=0
> -		_user_do "$XFS_IO_PROG -f -c \"pwrite 0 $file_size\" $dir/$file_count.bin &> /dev/null"
> -
> -		if [ -f $dir/$file_count.bin ]
> -		then
> -			bytes_written=`$XFS_IO_PROG -c "stat"  $dir/$file_count.bin | grep stat.size | cut -d ' ' -f3`
> -		fi
> -
> -		# If there was no room to make the file,
> -		# then divide it in half, and keep going
> -		if [ $bytes_written -lt $file_size ]
> -		then
> -			file_size=$(( $file_size / 2 ))
> -		fi
> -		file_count=$(( $file_count + 1 ))
> -
> -	done
> -}
> -
>  # _test_full_fs_punch()
>  #
>  # This function will test that a hole may be punched
> @@ -144,7 +86,10 @@ _test_full_fs_punch()
>  		-c "fsync" $file_name &> /dev/null
>  	chmod 666 $file_name
>  
> -	_fill_fs $(( 1024 * 1024 * 1024 )) $path/fill $block_size
> +	# All files are created as a non root user to prevent reserved blocks
> +	# from being consumed.
> +	_fill_fs $(( 1024 * 1024 * 1024 )) $path/fill $block_size 1 \
> +		> /dev/null 2>&1
>  
>  	for (( i=0; i<$iterations; i++ ))
>  	do
> @@ -159,7 +104,7 @@ _test_full_fs_punch()
>  
>  		hole_offset=$(( $hole_offset + $hole_len + $hole_interval ))
>  
> -		_fill_fs $hole_len $path/fill.$i $block_size
> +		_fill_fs $hole_len $path/fill.$i $block_size 1 > /dev/null 2>&1
>  
>  	done
>  }
> -- 
> 2.9.0
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
