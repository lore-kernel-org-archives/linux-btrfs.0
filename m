Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33676 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaHTIUw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 04:20:52 -0400
Date: Wed, 20 Aug 2014 16:20:26 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: [PATCH] Btrfs: fix crash on endio of reading corrupted block
Message-ID: <20140820082025.GA30876@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1408462393-3291-1-git-send-email-bo.li.liu@oracle.com>
 <53F3C4D2.4000003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53F3C4D2.4000003@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 19, 2014 at 04:42:42PM -0500, Eric Sandeen wrote:
> On 8/19/14, 10:33 AM, Liu Bo wrote:
> > The crash is
> > 
> > ------------[ cut here ]------------
> > kernel BUG at fs/btrfs/extent_io.c:2124!
> > [...]
> > Workqueue: btrfs-endio normal_work_helper [btrfs]
> > RIP: 0010:[<ffffffffa02d6055>]  [<ffffffffa02d6055>] end_bio_extent_readpage+0xb45/0xcd0 [btrfs]
> > 
> > This is in fact a regression.
> 
> It'd be helpful to identify the commit, or at least kernel release, which caused
> the regression.

Okay, got it.

> 
> > It is because we forgot to increase @offset properly in reading corrupted block,
> > so that the @offset remains, and this leads to checksum errors while reading
> > left blocks queued up in the same bio, and then ends up with hiting the above
> > BUG_ON.
> 
> So does that mean that any checksum error on this path will crash the kernel?
> 
> That sounds like this bug has exposed a more fundamental problem, no?

Eric, you're right, I was hiding some details, now writing a new commit log...

thanks,
-liubo

> 
> Thanks,
> -Eric
> 
> > Reported-by: Chris Murphy <lists@colorremedies.com>
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/extent_io.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index 3af4966..be41e4d 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -2602,6 +2602,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
> >  					test_bit(BIO_UPTODATE, &bio->bi_flags);
> >  				if (err)
> >  					uptodate = 0;
> > +				offset += len;
> >  				continue;
> >  			}
> >  		}
> > 
> 
