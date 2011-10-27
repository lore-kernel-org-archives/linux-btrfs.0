From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs progs git repo on kernel.org
Date: Thu, 27 Oct 2011 17:32:58 -0400
Message-ID: <20111027213258.GA25582@shiny.Mikenopa.local>
References: <20111027152707.GA11028@shiny.Mikenopa.local>
 <20111027155854.GK29548@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugo Mills <hugo@carfax.org.uk>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111027155854.GK29548@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 27, 2011 at 04:58:54PM +0100, Hugo Mills wrote:
> On Thu, Oct 27, 2011 at 11:27:07AM -0400, Chris Mason wrote:
> > I've pulled in Hugo's integration tree, minus the features that were not
> > yet in the kernel.  This also has a few small commits that I had queued
> > up outside of the fsck work.
> > 
> > Hugo, many thanks for keeping up the integration tree!  Taking out the
> > features not in the kernel meant I had to rebase it the commits, I'm
> > sorry about that.
> 
>    OK, I'm sure I can cope with that. I'll just drop the patches from
> my stack that you've already brought in, and generate a new
> integration branch based on your master. I've got 4-5 other patches to
> add in as well, gleaned from the mailing list and, via David Sterba,
> from SuSE's local patches.
> 
>    I've also got the basis of a set of regression tests for -progs,
> which I'll send out patches for in the next couple of days. At the
> moment, it only tests building and snapshots, but should be relatively
> easily extensible to the other bits of ./btrfs (although I'm not sure
> how we can easily and repeatably test the recovery tools).

Please talk with Anand Jain on the test programs, he has been making
scripts for xfs-tests.

> 
>    One other thing that's *really* needed is a new version tag, which
> I was going to do this weekend, but it looks like you're back at the
> helm of -progs, so I'll just whine in your general direction instead.

Definitely, fsck deserves a new version tag.

> 
>    I'll try to keep up with the integration branch still, and feed
> public patches I pull off the mailing list through to you, if that's
> going to continue to be useful. At the moment, though, I'm doing very
> little in the way of active review on these patches, so the fact that
> a patch is in integration-* doesn't necessarily mean that it's passed
> any kind of quality check from me.

That's great, it still helps.

-chris
