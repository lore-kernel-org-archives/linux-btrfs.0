Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56095 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754087AbeDYLFJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 07:05:09 -0400
Date: Wed, 25 Apr 2018 13:02:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs release 4.16.1
Message-ID: <20180425110234.GN21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180424115857.25174-1-dsterba@suse.com>
 <pan$3f697$9cfd5cd2$6e9f2dc3$73937e71@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$3f697$9cfd5cd2$6e9f2dc3$73937e71@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 25, 2018 at 06:31:20AM +0000, Duncan wrote:
> David Sterba posted on Tue, 24 Apr 2018 13:58:57 +0200 as excerpted:
> 
> > btrfs-progs version 4.16.1 have been released.  This is a bugfix
> > release.
> > 
> > Changes:
> > 
> >   * remove obsolete tools: btrfs-debug-tree, btrfs-zero-log,
> >   btrfs-show-super, btrfs-calc-size
> 
> Cue the admin-side gripes about developer definitions of micro-upgrade 
> explicit "bugfix release" that allow disappearance of "obsolete tools".
> 
> Arguably such removals can be expected in a "feature release", but 
> shouldn't surprise unsuspecting admins doing a micro-version upgrade 
> that's specifically billed as a "bugfix release".

A major version release would be a better time for the removal, I agree
and should have considered that.

However, the tools have been obsoleted for a long time (since 2015 or
2016) so I wonder if the deprecation warnings have been ignored by the
admins all the time.

> (Further support for btrfs being "still stabilizing, not yet fully stable 
> and mature."  But development mode habits need to end /sometime/, if 
> stability is indeed a goal.) 

What happened here was a bad release management decision, a minor one in
my oppinion but I hear your complaint and will keep that in mind for
future releases.

Do you really want to use that to perpetuate the 'still stabilizing and
not mature' claim? If you expect 0 bugs and essentially no other visible
problems, than I don't think you should use linux. Or wait until it's
fully stable, whatever that means.

In terms of features, btrfs is not done and will be actively developed
and maintained. Bugs will be found, reported and fixed, new features
will add more code that will have to be stabilized over time. This is
how the entire linux kernel evolves.

The focus in recent releases has been on cleanups and refactoring,
besides bugfixes. No big feature has been merged, to some disappointment
of developers and users, but this is namely to minimize the fallout of
new code that does not have enough review and testing.  My target is to
do slow and steady incremental changes with no regressions.
