Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758531AbaELOUy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 10:20:54 -0400
Date: Mon, 12 May 2014 16:20:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: return errno instead of -1 from compression
Message-ID: <20140512142052.GC6917@suse.cz>
Reply-To: dsterba@suse.cz
References: <1399590979-15331-1-git-send-email-zab@redhat.com>
 <20140509133926.GA5988@twin.jikos.cz>
 <20140509204015.GB23244@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140509204015.GB23244@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 09, 2014 at 01:40:15PM -0700, Zach Brown wrote:
> > > @@ -335,7 +335,7 @@ cont:
> > >  					break;
> > >  
> > >  				if (page_in_index + 1 >= total_pages_in) {
> > > -					ret = -1;
> > > +					ret = -EIO;
> > 
> > That looks like an internal error, we should never ask for more pages
> > than is in the input, so the buffer offset calculations are wrong.
> 
> Yeah, but EIO is still arguably the right thing.  There's nothing
> userspace can do about broken kernel code.  We don't want to give them
> an error that could be misinterpreted as them having used an interface
> incorrectly.  We could wrap WARN_ON_ONCE() around it, I suppose.  I'm
> inclined to leave it as is.

Ok. An EIO is better than an ASSERT or BUG_ON, the error paths will
handle it. I think adding the WARN_ON_ONCE is a good compromise, I'm not
expecting to see this error but the stack trace will help.
