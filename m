Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:4872 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753896AbbAUET0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 23:19:26 -0500
Date: Wed, 21 Jan 2015 15:19:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs/079: Fix wrong value passed to available
 space check.
Message-ID: <20150121041911.GE16510@dastard>
References: <1419837438-13771-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1419837438-13771-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 29, 2014 at 03:17:18PM +0800, Qu Wenruo wrote:
> Before the patch, we passed wrong value to _require_fs_space, which
> should be in unit of 1024, but passed in unit of GB.

Yes, that needs fixing.

> Fix it and add better prompt for falloc failure.

That doesn't....

> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  tests/btrfs/079 | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/btrfs/079 b/tests/btrfs/079
> index 202d3e6..99d0187 100755
> --- a/tests/btrfs/079
> +++ b/tests/btrfs/079
> @@ -73,8 +73,9 @@ rm -f $seqres.full
>  
>  _scratch_mkfs >>$seqres.full 2>&1
>  _scratch_mount
> -_require_fs_space $SCRATCH_MNT $(($filesize / 1024 / 1024 / 1024))
> -$XFS_IO_PROG -f -c "falloc 0 $filesize" $testfile
> +_require_fs_space $SCRATCH_MNT $(($filesize / 1024))
> +$XFS_IO_PROG -f -c "falloc 0 $filesize" $testfile || \
> +	_fail "falloc failed"

If the falloc fails, then the golden output match will fail. Let the
test run, regardless, because the first thing it does is try to
overwrite the fallocated region where the success or failure of the
writes are completely ignored. Hence a falloc failure should also be
ignored...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
