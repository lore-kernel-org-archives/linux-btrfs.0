Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaHSVmr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 17:42:47 -0400
Message-ID: <53F3C4D2.4000003@redhat.com>
Date: Tue, 19 Aug 2014 16:42:42 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Chris Murphy <lists@colorremedies.com>
Subject: Re: [PATCH] Btrfs: fix crash on endio of reading corrupted block
References: <1408462393-3291-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1408462393-3291-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/19/14, 10:33 AM, Liu Bo wrote:
> The crash is
> 
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/extent_io.c:2124!
> [...]
> Workqueue: btrfs-endio normal_work_helper [btrfs]
> RIP: 0010:[<ffffffffa02d6055>]  [<ffffffffa02d6055>] end_bio_extent_readpage+0xb45/0xcd0 [btrfs]
> 
> This is in fact a regression.

It'd be helpful to identify the commit, or at least kernel release, which caused
the regression.

> It is because we forgot to increase @offset properly in reading corrupted block,
> so that the @offset remains, and this leads to checksum errors while reading
> left blocks queued up in the same bio, and then ends up with hiting the above
> BUG_ON.

So does that mean that any checksum error on this path will crash the kernel?

That sounds like this bug has exposed a more fundamental problem, no?

Thanks,
-Eric

> Reported-by: Chris Murphy <lists@colorremedies.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/extent_io.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 3af4966..be41e4d 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2602,6 +2602,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
>  					test_bit(BIO_UPTODATE, &bio->bi_flags);
>  				if (err)
>  					uptodate = 0;
> +				offset += len;
>  				continue;
>  			}
>  		}
> 

