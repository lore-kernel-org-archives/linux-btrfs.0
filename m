Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47663 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab3HPOzm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 10:55:42 -0400
Message-ID: <520E3D6C.8070007@sandeen.net>
Date: Fri, 16 Aug 2013 09:55:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: silence btrfs balance in btrfs/003
References: <1376664680-16046-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1376664680-16046-1-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/16/13 9:51 AM, Stefan Behrens wrote:
> This test failed for me with output from 'btrfs balance':
>      QA output created by 003
>     +Done, had to relocate 4 out of 4 chunks
>     +Done, had to relocate 5 out of 5 chunks
>      Silence is golden
> 
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>  tests/btrfs/003 | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/btrfs/003 b/tests/btrfs/003
> index 3790935..795badb 100755
> --- a/tests/btrfs/003
> +++ b/tests/btrfs/003
> @@ -109,7 +109,7 @@ _test_add()
>  	for i in `seq 1 $n`; do
>  		$BTRFS_UTIL_PROG device add ${devs[$i]} $SCRATCH_MNT > /dev/null 2>&1 || _fail "device add failed"
>  	done
> -	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT || _fail "balance failed"
> +	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT > /dev/null 2>&1 || _fail "balance failed"

It'd be better to redirect to $seqres.full; that way when it fails,
you'll have something to look at with more info than /dev/null contains :)

You'd need just a little prep work there to rm -f $seqres.full at the beginning
of the test so it doesn't grow forever.

-Eric

>  	umount $SCRATCH_MNT
>  }
>  
> @@ -152,7 +152,7 @@ _test_replace()
>  	# in some system balance fails if there is no delay (a bug)
>  	# putting sleep 10 to work around as of now
>  	# sleep 10
> -	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT || _fail "dev balance failed"
> +	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT > /dev/null 2>&1 || _fail "dev balance failed"
>  
>  	# cleaup. add the removed disk
>  	umount $SCRATCH_MNT
> 

