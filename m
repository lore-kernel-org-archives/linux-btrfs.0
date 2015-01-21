Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:48007 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751853AbbAUEDv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 23:03:51 -0500
Date: Wed, 21 Jan 2015 15:03:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstest: btrfs/006: Add extra check on return value and
 'fi show' by device
Message-ID: <20150121040315.GC16510@dastard>
References: <1421373430-21915-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421373430-21915-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 16, 2015 at 09:57:10AM +0800, Qu Wenruo wrote:
> Reported in Red Hat BZ#1181627, 'btrfs fi show' on unmounted device will
> return 1 even no error happens.

Please describe the bug in the commit message, don't make me have to
go look at some web page to work out what you are trying to fix.

> Introduced by: commit 2513077f
> btrfs-progs: fix device missing of btrfs fi show with seed devices
> 
> Patch fixing it:
> https://patchwork.kernel.org/patch/5626001/
> btrfs-progs: Fix wrong return value when executing 'fi show' on
> umounted device.

What btrfs progs commit introduced and fixed is not actually
relevant to fstests. If I have to go read other stuff to understand
the change you are making, then the description needs more detail
and less external references....


> Reported-by: Vratislav Podzimek <vpodzime@redhat.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  tests/btrfs/006     | 51 ++++++++++++++++++++++++++++++++++++++++++++-------
>  tests/btrfs/006.out | 10 ++++++++++
>  2 files changed, 54 insertions(+), 7 deletions(-)
> 
> diff --git a/tests/btrfs/006 b/tests/btrfs/006
> index 715fd80..2d8c1c0 100755
> --- a/tests/btrfs/006
> +++ b/tests/btrfs/006
> @@ -62,33 +62,70 @@ _scratch_pool_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
>  
>  # These have to be done unmounted...?
>  echo "== Set filesystem label to $LABEL"
> -$BTRFS_UTIL_PROG filesystem label $SCRATCH_DEV $LABEL
> +$BTRFS_UTIL_PROG filesystem label $SCRATCH_DEV $LABEL || \
> +	_fail "set lable failed"

Apart from the typo, why not _run_btrfs_util_prog?

However, this will make the test fail on older btrfs progs
installations that we previously passing the test just fine, right?

IOWs, if you want to test that `btrfs fi show` always returns the
correct value, don't add that checking to an existing test: write a
new test that tests the validity of the return value....


>  echo "== Get filesystem label"
> -$BTRFS_UTIL_PROG filesystem label $SCRATCH_DEV
> +$BTRFS_UTIL_PROG filesystem label $SCRATCH_DEV || \
> +	_fail "get lable failed"
> +
> +echo "== Show filesystem by device(offline)"
> +$BTRFS_UTIL_PROG filesystem show $FIRST_POOL_DEV | \
> +	_filter_btrfs_filesystem_show $TOTAL_DEVS $UUID
> +[ ${PIPESTATUS[0]} -ne 0 ] && \
> +	_fail "show filesystem by device(offline) return value wrong"

That's a new function being tested. Again, this belongs in a new
test, not an existing regression test....

FWIW, Now that I've seen it used a couple of times, I don't really
like the mess that checking errors via PIPESTATUS results in,
especially as

_run_btrfs_util_prog filesystem show $FIRST_POOL_DEV | \
	_filter_btrfs_filesystem_show $TOTAL_DEVS $UUID

Gives *exactly* the same failure detection....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
