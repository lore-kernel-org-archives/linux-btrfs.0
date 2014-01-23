Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55543 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbaAWTS1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 14:18:27 -0500
Message-ID: <52E16AE6.7010202@fb.com>
Date: Thu, 23 Jan 2014 14:17:58 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>, <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfstests: add test for btrfs incremental send infinite
 loop issue
References: <1390348610-8098-1-git-send-email-fdmanana@gmail.com> <1390385119-6998-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1390385119-6998-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/22/2014 05:05 AM, Filipe David Borba Manana wrote:
> Regression test for btrfs' incremental send feature:
>
> 1) Create several nested directories;
>
> 2) Create a read only snapshot;
>
> 3) Change the parentship of some of the deepest directories in a reverse
>     way, so that parents become children and children become parents;
>
> 4) Create another read only snapshot and use it for an incremental send
>     relative to the first snapshot.
>
> At step 4 btrfs' send entered an infinite loop, increasing the memory it
> used while building path strings until a krealloc was unable to allocate
> more memory, which caused a warning dump in dmesg.
>
> The following linux kernel patch fixes this issue.
>
>     Btrfs: fix infinite path build loops in incremental send
>     (https://patchwork.kernel.org/patch/3522361/)
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>
> V2: Updated test to trigger one more code path in the corresponding
>      btrfs linux kernel patch that fixes this issue.
>
>   tests/btrfs/030     |  144 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/030.out |    9 ++++
>   tests/btrfs/group   |    1 +
>   3 files changed, 154 insertions(+)
>   create mode 100755 tests/btrfs/030
>   create mode 100644 tests/btrfs/030.out
>
> diff --git a/tests/btrfs/030 b/tests/btrfs/030
> new file mode 100755
> index 0000000..5e1b4fc
> --- /dev/null
> +++ b/tests/btrfs/030
> @@ -0,0 +1,144 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/030
> +#
> +# Regression test for btrfs' incremental send feature:
> +#
> +# 1) Create several nested directories;
> +# 2) Create a read only snapshot;
> +# 3) Change the parentship of some of the deepest directories in a reverse
> +#    way, so that parents become children and children become parents;
> +# 4) Create another read only snapshot and use it for an incremental send
> +#    relative to the first snapshot.
> +#
> +# At step 4 btrfs' send entered an infinite loop, increasing the memory it
> +# used while building path strings until a krealloc was unable to allocate
> +# more memory, which caused a warning dump in dmesg.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2014 Filipe Manana.  All Rights Reserved.
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
> +tmp=`mktemp -d`
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    rm -fr $tmp
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
> +_need_to_be_root
> +
> +FSSUM_PROG=$here/src/fssum
> +[ -x $FSSUM_PROG ] || _notrun "fssum not built"
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +
> +mkdir -p $SCRATCH_MNT/a/b/c
> +echo "hello" > $SCRATCH_MNT/a/b/c/file.txt
> +mkdir $SCRATCH_MNT/a/b/c/d
> +mkdir $SCRATCH_MNT/a/b/c2
> +mkdir $SCRATCH_MNT/a/b/www
> +mkdir -p $SCRATCH_MNT/a/b/c3/x/y
> +
> +# Directory tree looks like:
> +#
> +# .                         (ino 256)
> +# |-- a/                    (ino 257)
> +#     |-- b/                (ino 258)
> +#         |-- c/            (ino 259)
> +#         |   |-- file.txt  (ino 260)
> +#         |   |-- d/        (ino 261)
> +#         |
> +#         |-- c2/           (ino 262)
> +#         |-- www/          (ino 263)
> +#         |
> +#         |-- c3/           (ino 264)
> +#             |-- x/        (ino 265)
> +#                 |-- y/    (ino 266)
> +
> +$BTRFS_UTIL_PROG subvol snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1 | \
> +    _filter_scratch
> +
> +echo " world" >> $SCRATCH_MNT/a/b/c/file.txt
> +mv $SCRATCH_MNT/a/b/c/d $SCRATCH_MNT/a/b/c2/d2
> +mv $SCRATCH_MNT/a/b/c $SCRATCH_MNT/a/b/c2/d2/cc
> +mv $SCRATCH_MNT/a/b/c3/x/y $SCRATCH_MNT/a/b/c2/y2
> +mv $SCRATCH_MNT/a/b/c3/x $SCRATCH_MNT/a/b/c2/y2/x2
> +mv $SCRATCH_MNT/a/b/c3 $SCRATCH_MNT/a/b/c2/y2/x2/Z
> +mv $SCRATCH_MNT/a/b/www $SCRATCH_MNT/a/b/c2/y2/x2/WWW
> +ln $SCRATCH_MNT/a/b/c2/d2/cc/file.txt $SCRATCH_MNT/a/b/c2/y2/x2/Z/file_link.txt
> +mv $SCRATCH_MNT/a/b/c2/d2/cc/file.txt $SCRATCH_MNT/a/b/c2/y2/x2
> +
> +# Directory tree now looks like:
> +#
> +# .                                         (ino 256)
> +# |-- a/                                    (ino 257)
> +#     |-- b/                                (ino 258)
> +#         |-- c2/                           (ino 262)
> +#             |-- d2/                       (ino 261)
> +#             |   |-- cc/                   (ino 259)
> +#             |        |-- file.txt         (ino 260)
> +#             |-- y2/                       (ino 266)
> +#                 |-- x2/                   (ino 265)
> +#                     |-- WWW/              (ino 263)
> +#                     |-- Z/                (ino 264)
> +#                         |-- file_link.txt
> +
> +$BTRFS_UTIL_PROG subvol snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2 | \
> +    _filter_scratch
> +
> +$FSSUM_PROG -A -f -w $tmp/1.fssum $SCRATCH_MNT/mysnap1
> +$FSSUM_PROG -A -f -w $tmp/2.fssum -x $SCRATCH_MNT/mysnap2/mysnap1 \
> +    $SCRATCH_MNT/mysnap2
> +
> +$BTRFS_UTIL_PROG send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap 2>&1 | _filter_scratch
> +$BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
> +    -f $tmp/2.snap 2>&1 | _filter_scratch
> +
> +_scratch_unmount
> +_check_btrfs_filesystem $SCRATCH_DEV
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/1.snap
> +$FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1
> +$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $tmp/2.snap
> +$FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2
> +

You should do || _fail for the fssum stuff, and maybe redirect the 
output to $seqres.full.

> +_scratch_unmount
> +_check_btrfs_filesystem $SCRATCH_DEV
> +
> +status=0
> +exit
> diff --git a/tests/btrfs/030.out b/tests/btrfs/030.out
> new file mode 100644
> index 0000000..2999f8c
> --- /dev/null
> +++ b/tests/btrfs/030.out
> @@ -0,0 +1,9 @@
> +QA output created by 030
> +Create a readonly snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/mysnap1'
> +Create a readonly snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/mysnap2'
> +At subvol SCRATCH_MNT/mysnap1
> +At subvol SCRATCH_MNT/mysnap2
> +At subvol mysnap1
> +OK
> +At snapshot mysnap2
> +OK

So this depends on the output of btrfs send not changing ever, which 
historically is not a good assumption to make.  It would be better if 
you do like the other send tests and just test for failure like the 
other send tests do.  Thanks,

Josef
