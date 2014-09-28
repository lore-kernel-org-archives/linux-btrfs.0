Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51236 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaI1WZB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Sep 2014 18:25:01 -0400
Received: by mail-pa0-f47.google.com with SMTP id rd3so5841661pab.6
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Sep 2014 15:25:00 -0700 (PDT)
Date: Sun, 28 Sep 2014 15:26:04 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: orenl@cellrox.com
Subject: Re: [PATCH 1/2] btrfs: fix sparse address space warnings
Message-ID: <20140928222604.GA6328@molino.home.network>
References: <1411894092-28784-1-git-send-email-osandov@osandov.com>
 <1411894092-28784-2-git-send-email-osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1411894092-28784-2-git-send-email-osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 28, 2014 at 01:48:11AM -0700, Omar Sandoval wrote:
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 6528aa6..e0be577 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -515,7 +515,8 @@ static int write_buf(struct file *filp, const void *buf, u32 len, loff_t *off)
>  	set_fs(KERNEL_DS);
>  
>  	while (pos < len) {
> -		ret = vfs_write(filp, (char *)buf + pos, len - pos, off);
> +		ret = vfs_write(filp, (__force const char __user *)buf + pos,
> +				len - pos, off);
>  		/* TODO handle that correctly */
>  		/*if (ret == -ERESTARTSYS) {
>  			continue;

Actually, looking at this now, it looks like this is just an open-coded
kernel_write. I think this could be made a bit cleaner by using that instead;
the tradeoff is that each call to kernel_write will do the address space
flip-flop, so if the write gets split up into many calls, there'd be some
slight overhead. That's probably a microoptimization, but I think it's worth
looking into making kernel_read and kernel_write handle the retry logic.

It looks like Oren Laadan submitted a patch doing exactly that as part of the
checkpoint/restart patch series: https://lkml.org/lkml/2010/5/6/142. I've added
an email address that I found for him.

>From Josef's response way back in 2010:
> > +static ssize_t _kernel_write(struct file *file, loff_t offset,
> > +			     const char __user *ubuf, size_t count)
> > +{
> > +	ssize_t nwrite;
> > +	size_t nleft;
> > +	loff_t pos = offset;
> > +
> > +	for (nleft = count; nleft; nleft -= nwrite) {
> > +		nwrite = vfs_write(file, ubuf, nleft, &pos);
> > +		if (nwrite < 0) {
> > +			if (nwrite == -EAGAIN) {
> > +				nwrite = 0;
> > +				continue;
> > +			} else
> > +				return nwrite;
> > +		}
> > +		ubuf += nwrite;
> > +	}
> > +	return count - nleft;
> > +}
> 
> I'm not entirely sure if this can happen, but if vfs_write doesn't write
> anything, but doesn't have an error, we could end up in an infinite loop.  Like
> I said I'm not sure if thats even possible, but its definitely one of those
> things that if it is possible some random security guy is going to figure out
> how to exploit it at some point down the line.

Did anyone ever come up with a good answer for this?

-- 
Omar
