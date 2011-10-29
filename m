From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs progs git repo on kernel.org
Date: Sat, 29 Oct 2011 01:07:03 -0400
Message-ID: <20111029050703.GA4054@shiny.Mikenopa.local>
References: <20111027152707.GA11028@shiny.Mikenopa.local>
 <20111028192756.5f93bb9f@sf.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111028192756.5f93bb9f@sf.home>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 28, 2011 at 07:27:56PM +0300, Sergei Trofimovich wrote:
> > Hi everyone,
> > 
> > I've pulled in Hugo's integration tree, minus the features that were not
> > yet in the kernel.  This also has a few small commits that I had queued
> > up outside of the fsck work.
> > 
> > Hugo, many thanks for keeping up the integration tree!  Taking out the
> > features not in the kernel meant I had to rebase it the commits, I'm
> > sorry about that.
> > 
> > The code from the integration tree is here:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> 
> Sounds great! Should we treat is as new home of a thing called "-unstable" before?
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
> 
> Or you are planning to restore that repo as well?

That's a good point, I'll see if I can make the -unstable a link.  Still
figuring out the new git interface.

But yes, this is the new home of the progs.

-chris

