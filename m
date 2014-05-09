Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553AbaEIVZA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 17:25:00 -0400
Date: Fri, 9 May 2014 13:40:15 -0700
From: Zach Brown <zab@redhat.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: return errno instead of -1 from compression
Message-ID: <20140509204015.GB23244@lenny.home.zabbo.net>
References: <1399590979-15331-1-git-send-email-zab@redhat.com>
 <20140509133926.GA5988@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140509133926.GA5988@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 09, 2014 at 03:39:26PM +0200, David Sterba wrote:
> On Thu, May 08, 2014 at 07:16:17PM -0400, Zach Brown wrote:
> > The compression layer seems to have been built to return -1 and have
> > callers make up errors that make sense.  This isn't great because there
> > are different classes of errors that originate down in the compression
> > layer.  Allocation failure and corrupt compressed data to name two.
> > 
> > --- a/fs/btrfs/lzo.c
> > +++ b/fs/btrfs/lzo.c
> > @@ -143,7 +143,7 @@ static int lzo_compress_pages(struct list_head *ws,
> >  		if (ret != LZO_E_OK) {
> >  			printk(KERN_DEBUG "BTRFS: deflate in loop returned %d\n",
> >  			       ret);
> > -			ret = -1;
> > +			ret = -EIO;
> >  			goto out;
> >  		}
> >  
> > @@ -189,7 +189,7 @@ static int lzo_compress_pages(struct list_head *ws,
> >  				kunmap(out_page);
> >  				if (nr_pages == nr_dest_pages) {
> >  					out_page = NULL;
> > -					ret = -1;
> > +					ret = -EIO;
> 
> This is not a true EIO, the error conditions says that the caller
> prepared nr_dest_pages for the compressed data but the compression wants
> more.
> 
> The number of pages is at most 128k / PAGE_SIZE.
> 
> It's a soft error, the data are written uncompressed. The closest errno
> here seems E2BIG that would apply in the following hunk as well.

Sure.  *Anything* is better than the raw -EPERM :).  I'll change these
and resend v2.

> > @@ -335,7 +335,7 @@ cont:
> >  					break;
> >  
> >  				if (page_in_index + 1 >= total_pages_in) {
> > -					ret = -1;
> > +					ret = -EIO;
> 
> That looks like an internal error, we should never ask for more pages
> than is in the input, so the buffer offset calculations are wrong.

Yeah, but EIO is still arguably the right thing.  There's nothing
userspace can do about broken kernel code.  We don't want to give them
an error that could be misinterpreted as them having used an interface
incorrectly.  We could wrap WARN_ON_ONCE() around it, I suppose.  I'm
inclined to leave it as is.

- z
