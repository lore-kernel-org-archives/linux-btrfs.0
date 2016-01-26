Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965164AbcAZK02 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 05:26:28 -0500
Date: Tue, 26 Jan 2016 11:26:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: clm@fb.com, linux-next@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: Add my git tree for linux-next
Message-ID: <20160126102617.GC8567@suse.cz>
Reply-To: dsterba@suse.cz
References: <20160125182445.GA8567@twin.jikos.cz>
 <20160126101616.682677d4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160126101616.682677d4@canb.auug.org.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 26, 2016 at 10:16:16AM +1100, Stephen Rothwell wrote:
> Hi David,
> 
> On Mon, 25 Jan 2016 19:24:45 +0100 David Sterba <dsterba@suse.cz> wrote:
> >
> > please add my git tree to linux-next branches
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
> > 
> > It's not populated yet, I'm planning to add namely other developer
> > patchsets (targeting the next release cycle) as I'm able to review them.
> > I won't track all pending patchsets nor all single patches that go to
> > the mailinglist, due to time reasons.
> 
> What subsystem will these patches relate to? (just btrfs)?  Will you be sending pull
> requests?  To whom? (Chris and Josef)?  If so, how will this be
> different to the current btrfs tree?

Just btrfs, pull requests to Chris. As he wrote, this already happens.
Another point is to make it a bit more clear to the other developers
which patchsets/branches are heading upstream. Sorry for lack of details
in the request.
