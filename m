From: Morey Roof <moreyroof@gmail.com>
Subject: Re: New feature Idea
Date: Wed, 13 Aug 2008 13:40:09 -0600
Message-ID: <1218656409.5907.3.camel@sdevel.nmt.edu>
References: <48A320A0.80609@gmail.com> <48A32DDE.8070203@hp.com>
	 <48A330A2.6020306@gentoo.org>  <48A335E7.4020407@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48A335E7.4020407@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-08-13 at 15:28 -0400, jim owens wrote:
> Joe Peterson wrote:
> > My thoughts on what you are saying is that it is not generally a good
> > idea to assume any filesystem will lay things out in any specific way,
> > including whether it has one-to-one mapping of files to blocks.  In
> > other words, making a copy of a file on the same filesystem for safety
> > reasons (unless you are modifying a file and want a backup of its old
> > state, like emacs' ~ files) is probably not a great habit to get into.
> > 
> > The implementation details of how a filesystem makes things safer should
> > be behind-the-scenes (like checksums, multiple-copies-by-default,
> > mirroring, etc.).  That way, you can simply rely on the filesystem to
> > manage protection of your data rather than going to the effort of
> > managing multiple copies of files yourself for that reason.
> 
> I'm a filesystem guy so I only use ones I know do what I want,
> I never trust ones I don't know about :)
> 
> I agree with you about the danger of assuming what a filesystem
> will or won't do on local copies.  I also fear that 99% of normal
> users have an expectation that making a copy makes a new physical
> instance (which of course is not safe if the device crashes either).
> 
> I hate dealing with customers that have lost their data because
> of the filesystem.
> 
> 
> Morey Roof wrote:
> > I was hoping to have it specified as a set of mount options or defaults 
> > controlled in the super block so that if you want to use it you can 
> > otherwise it doesn't exist.
> 
> I don't have veto power in btrfs so my aversion means nothing.
> 
> As you say, there are a number of good ways to control it.
> 
> If you pursue this, I might suggest having a dedup limit
> so they can say "keep at least 2 copies" or "just one".
> 
> jim


This is an interesting idea.  Perhaps we could tie this in a little
closer to the protection systems in btrfs so that depending on the type
of protection chosen the dedup will try to match it.

However, I need to start figuring out a prototype for this which is what
I started this thread for.

-Morey

