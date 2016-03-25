Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbcCYDxI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 23:53:08 -0400
Date: Fri, 25 Mar 2016 11:53:06 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] fstests: add btrfs test for fsync after snapshot deletion
Message-ID: <20160325035306.GX11419@eguan.usersys.redhat.com>
References: <1458839241-12379-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1458839241-12379-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 24, 2016 at 05:07:21PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that if we delete a snapshot, delete its parent directory, create
> another directory with the same name as that parent and then fsync either
> the new directory or a file inside the new directory, the fsync succeeds,
> the fsync log is replayable and produces a correct result.
> 
> This is motivated by a bug that is fixed by the following patch for
> btrfs (linux kernel):
> 
>   Btrfs: fix unreplayable log after snapshot deletion and parent
>   re-creation

Test fails on v4.5 kernel as expected, but I failed to compile btrfs
after applying this patch, seems btrfs_must_commit_transaction was not
defined anywhere (I did grep it through the kernel tree, nothing showed
up), did I miss anything?

fs/btrfs/tree-log.c: In function ‘check_parent_dirs_for_sync’:
fs/btrfs/tree-log.c:4836:4: error: implicit declaration of function ‘btrfs_must_commit_transaction’ [-Werror=implicit-function-declaration]
    if (btrfs_must_commit_transaction(trans, inode))
    ^
cc1: some warnings being treated as errors
make[1]: *** [fs/btrfs/tree-log.o] Error 1
make: *** [_module_fs/btrfs] Error 2

> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  tests/btrfs/120     | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/120.out | 12 +++++++
>  tests/btrfs/group   |  1 +
>  3 files changed, 104 insertions(+)
>  create mode 100755 tests/btrfs/120
>  create mode 100644 tests/btrfs/120.out
> 
> diff --git a/tests/btrfs/120 b/tests/btrfs/120
> new file mode 100755
> index 0000000..4ede4e6
> --- /dev/null
> +++ b/tests/btrfs/120
> @@ -0,0 +1,91 @@
> +#! /bin/bash
> +# FSQA Test No. 120
> +#
> +# Test that if we delete a snapshot, delete its parent directory, create
> +# another directory with the same name as that parent and then fsync either
> +# the new directory or a file inside the new directory, the fsync succeeds,
> +# the fsync log is replayable and produces a correct result.
> +#
> +#-----------------------------------------------------------------------
> +#
> +# Copyright (C) 2016 SUSE Linux Products GmbH. All Rights Reserved.
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
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	_cleanup_flakey
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmflakey
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +_require_dm_target flakey
> +_require_metadata_journaling $SCRATCH_DEV
> +
> +rm -f $seqres.full
> +
> +_populate_fs()
> +{
> +	_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT \
> +		$SCRATCH_MNT/testdir/snap
> +	_run_btrfs_util_prog subvolume delete $SCRATCH_MNT/testdir/snap
> +	rmdir $SCRATCH_MNT/testdir
> +	mkdir $SCRATCH_MNT/testdir
> +}

There's already a _populate_fs function in common/rc, though this one
could override it, I think it's better to define a different function
name, e.g. without the leading underscore, as it's only used locally.

Thanks,
Eryu
