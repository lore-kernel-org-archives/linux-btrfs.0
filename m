Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:27075 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752213AbaBJVjt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 16:39:49 -0500
Date: Tue, 11 Feb 2014 08:39:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] xfstests: btrfs/004: fix to make test really work
Message-ID: <20140210213944.GT13647@dastard>
References: <1392034256-2412-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392034256-2412-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 10, 2014 at 08:10:56PM +0800, Wang Shilong wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> 
> So i was wandering why test 004 could pass my previous wrong
> kernel patch while it defenitely should not.
> 
> By some debugging, i found here perl script is wrong, we did not
> filter out anything and this unit test did not work acutally.so
> it came out we will never fail this test.
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
>  tests/btrfs/004 | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>  mode change 100755 => 100644 tests/btrfs/004
> 
> diff --git a/tests/btrfs/004 b/tests/btrfs/004
> old mode 100755
> new mode 100644
> index 14da9f1..17a6e34
> --- a/tests/btrfs/004
> +++ b/tests/btrfs/004
> @@ -57,10 +57,9 @@ _require_command "/usr/sbin/filefrag"
>  
>  rm -f $seqres.full
>  
> -FILEFRAG_FILTER='if (/, blocksize (\d+)/) {$blocksize = $1; next} ($ext, '\
> -'$logical, $physical, $expected, $length, $flags) = (/^\s*(\d+)\s+(\d+)'\
> -'\s+(\d+)\s+(?:(\d+)\s+)?(\d+)\s+(.*)/) or next; $flags =~ '\
> -'/(?:^|,)inline(?:,|$)/ and next; print $physical * $blocksize, "#", '\
> +FILEFRAG_FILTER='if (/blocks of (\d+) bytes/) {$blocksize = $1; next} ($ext, '\
> +'$logical, $physical, $length) = (/^\s*(\d+):\s+(\d+)..\s+\d+:'\
> +'\s+(\d+)..\s+\d+:\s+(\d+):/) or next; print $physical * $blocksize, "#", '\
>  '$length * $blocksize, "#", $logical * $blocksize, " "'

Oh, boy, who allowed that mess to pass review? Please format this in
a readable manner while you are changing it.

FILEFRAG_FILTER='
	if (/blocks of (\d+) bytes/) {			\
		$blocksize = $1;			\
		next;					\
	}
.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
