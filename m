Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:49576 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbaI3T1o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 15:27:44 -0400
Date: Tue, 30 Sep 2014 12:27:43 -0700
From: Zach Brown <zab@zabbo.net>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        orenl@cellrox.com
Subject: Re: [PATCH 1/2] btrfs: fix sparse address space warnings
Message-ID: <20140930192743.GE12900@lenny.home.zabbo.net>
References: <1411894092-28784-1-git-send-email-osandov@osandov.com>
 <1411894092-28784-2-git-send-email-osandov@osandov.com>
 <20140928222604.GA6328@molino.home.network>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140928222604.GA6328@molino.home.network>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 28, 2014 at 03:26:04PM -0700, Omar Sandoval wrote:
> On Sun, Sep 28, 2014 at 01:48:11AM -0700, Omar Sandoval wrote:
> > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > index 6528aa6..e0be577 100644
> > --- a/fs/btrfs/send.c
> > +++ b/fs/btrfs/send.c
> > @@ -515,7 +515,8 @@ static int write_buf(struct file *filp, const void *buf, u32 len, loff_t *off)
> >  	set_fs(KERNEL_DS);
> >  
> >  	while (pos < len) {
> > -		ret = vfs_write(filp, (char *)buf + pos, len - pos, off);
> > +		ret = vfs_write(filp, (__force const char __user *)buf + pos,
> > +				len - pos, off);
> >  		/* TODO handle that correctly */
> >  		/*if (ret == -ERESTARTSYS) {
> >  			continue;
> 
> Actually, looking at this now, it looks like this is just an open-coded
> kernel_write. I think this could be made a bit cleaner by using that instead;

Agreed, but notice that you'll want to be careful to update
write_buf()'s *off because passing a dereferenced copy to kernel_write()
will lose the pos update that vfs_write() is currently taking care of.

A carefully placed "*off += ret" in write_buf() will be fine.  (As fine
as having a magical private file position in the send context ever was.)

> the tradeoff is that each call to kernel_write will do the address
> space flip-flop, so if the write gets split up into many calls,
> there'd be some slight overhead.  That's probably a microoptimization,
> but 

Yeah, I don't think that overhead is going to be significant given all
of the work that's going on.

> I think it's worth looking
> into making kernel_read and kernel_write handle the retry logic.

I disagree.  I wouldn't broaden the scope to add retrying on behalf of
all kernel_write() callers and write methods (it's exported to modules,
too).  I'd leave the looping in btrfs and just call kernel_write() to
get rid of the segment juggling.

- z
