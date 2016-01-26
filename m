Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:41340 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbcAZUhV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 15:37:21 -0500
Date: Wed, 27 Jan 2016 07:37:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Sterba <dsterba@suse.cz>
Cc: Chris Mason <clm@fb.com>, <linux-next@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: Add my git tree for linux-next
Message-ID: <20160127073718.10ef442f@canb.auug.org.au>
In-Reply-To: <20160126005914.n5zvov6q3v23hvad@floor.thefacebook.com>
References: <20160125182445.GA8567@twin.jikos.cz>
	<20160126101616.682677d4@canb.auug.org.au>
	<20160126005914.n5zvov6q3v23hvad@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On Mon, 25 Jan 2016 19:59:14 -0500 Chris Mason <clm@fb.com> wrote:
>
> On Tue, Jan 26, 2016 at 10:16:16AM +1100, Stephen Rothwell wrote:
> > 
> > On Mon, 25 Jan 2016 19:24:45 +0100 David Sterba <dsterba@suse.cz> wrote:  
> > >
> > > please add my git tree to linux-next branches
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
> > > 
> > > It's not populated yet, I'm planning to add namely other developer
> > > patchsets (targeting the next release cycle) as I'm able to review them.
> > > I won't track all pending patchsets nor all single patches that go to
> > > the mailinglist, due to time reasons.  
> > 
> > What subsystem will these patches relate to? (just btrfs)?  Will you be sending pull
> > requests?  To whom? (Chris and Josef)?  If so, how will this be
> > different to the current btrfs tree?  
> 
> Dave is one of the btrfs maintainers, and I frequently pull in his trees
> directly for my pull requests to Linus.  Getting them earlier exposure in
> linux-next will definitely help.
> 
> If we ever share the pull-request duties to Linus, it'll also be important to
> have Dave's trees in there.

Added from today.  I called it btrfs-kdave.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window. 

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and 
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

-- 
Cheers,
Stephen Rothwell 
sfr@canb.auug.org.au
