Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38992 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaI3UcG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 16:32:06 -0400
Received: by mail-pd0-f172.google.com with SMTP id p10so3420249pdj.17
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Sep 2014 13:32:05 -0700 (PDT)
Date: Tue, 30 Sep 2014 13:32:03 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Zach Brown <zab@zabbo.net>, dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: fix sparse address space warnings
Message-ID: <20140930203203.GA20187@mew.dhcp4.washington.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140929214954.GG11436@suse.cz>
 <20140930192743.GE12900@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 29, 2014 at 11:49:54PM +0200, David Sterba wrote:
> On Mon, Sep 29, 2014 at 12:45:12PM -0700, Omar Sandoval wrote:
> > > > @@ -639,8 +640,7 @@ static int send_header(struct send_ctx *sctx)
> > > > -	return write_buf(sctx->send_filp, &hdr, sizeof(hdr),
> > > > -					&sctx->send_off);
> > > > +	return write_buf(sctx->send_filp, &hdr, sizeof(hdr), &sctx->send_off);
> > > 
> > > >  	ret = write_buf(sctx->send_filp, sctx->send_buf, sctx->send_size,
> > > > -					&sctx->send_off);
> > > > +			&sctx->send_off);
> > > 
> > > Please do not fold unrelated changes.
> > 
> > My metric for "related" here was that these were call sites of a function I
> > directly modified.
> 
> The changes are only in the whitespace, that's not necessary. It's
> usually ok to fix style issues in the code you modify directly.
> 
> > Is the preferred form to just split style fixes that we encounter into
> > a separate patch in the series?
> 
> Well, I may only express my point of view. Yes, split the style-only
> changes into another patch and don't send it :)
> 
> The problem with patches that do not effectively change anything is that
> they pollute git history and just add extra step when one has to look
> for a patch that broke something, or eg. change context of following
> patches and make backporting a bit more tedious. Code cleanups are fine,
> but there's usually a point of making the code more readable, compact,
> etc.
> 
> The coding style should be perfect from the beginning. Nobody will
> probably point out minor style violations during review, because it just
> pointless for a patch that fixes a real bug.

Thank you for the perspective :)


On Tue, Sep 30, 2014 at 12:27:43PM -0700, Zach Brown wrote:
> On Sun, Sep 28, 2014 at 03:26:04PM -0700, Omar Sandoval wrote:
> > On Sun, Sep 28, 2014 at 01:48:11AM -0700, Omar Sandoval wrote:
> > > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > > index 6528aa6..e0be577 100644
> > > --- a/fs/btrfs/send.c
> > > +++ b/fs/btrfs/send.c
> > > @@ -515,7 +515,8 @@ static int write_buf(struct file *filp, const void *buf, u32 len, loff_t *off)
> > >  	set_fs(KERNEL_DS);
> > >  
> > >  	while (pos < len) {
> > > -		ret = vfs_write(filp, (char *)buf + pos, len - pos, off);
> > > +		ret = vfs_write(filp, (__force const char __user *)buf + pos,
> > > +				len - pos, off);
> > >  		/* TODO handle that correctly */
> > >  		/*if (ret == -ERESTARTSYS) {
> > >  			continue;
> > 
> > Actually, looking at this now, it looks like this is just an open-coded
> > kernel_write. I think this could be made a bit cleaner by using that instead;
> 
> Agreed, but notice that you'll want to be careful to update
> write_buf()'s *off because passing a dereferenced copy to kernel_write()
> will lose the pos update that vfs_write() is currently taking care of.
> 
> A carefully placed "*off += ret" in write_buf() will be fine.  (As fine
> as having a magical private file position in the send context ever was.)
> 
> > the tradeoff is that each call to kernel_write will do the address
> > space flip-flop, so if the write gets split up into many calls,
> > there'd be some slight overhead.  That's probably a microoptimization,
> > but 
> 
> Yeah, I don't think that overhead is going to be significant given all
> of the work that's going on.
> 
> > I think it's worth looking
> > into making kernel_read and kernel_write handle the retry logic.
> 
> I disagree.  I wouldn't broaden the scope to add retrying on behalf of
> all kernel_write() callers and write methods (it's exported to modules,
> too).  I'd leave the looping in btrfs and just call kernel_write() to
> get rid of the segment juggling.
> 
> - z

That sounds fair. I'll submit a v2 that replaces vfs_write with kernel_write.

-- 
Omar
