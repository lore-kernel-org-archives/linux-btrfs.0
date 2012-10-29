Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39180 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab2J2EaD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 00:30:03 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1TSgzC-0003Dj-8h
	for <linux-btrfs@vger.kernel.org>; Sun, 28 Oct 2012 21:30:02 -0700
Date: Sun, 28 Oct 2012 21:30:02 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Need help mounting laptop corrupted root btrfs. Kernel BUG at fs/btrfs/volumes.c:3707
Message-ID: <20121029043002.GA8019@merlins.org>
References: <20121025195805.GA24111@merlins.org> <CAE5mzvi=y6Auyr9cGMOm=tUSSj7sSQ78W0Bnzk+dJOqkW6z6jA@mail.gmail.com> <20121025201223.GB24111@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121025201223.GB24111@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 25, 2012 at 01:12:23PM -0700, Marc MERLIN wrote:
> On Thu, Oct 25, 2012 at 02:03:49PM -0600, cwillu wrote:
> > > 3) Want me to try btrfsck although it may make it impossible for me to
> > > reproduce the bug and test a fix, as well as potentially break the filesystem
> > > more (last time I tried btrfsck, it outputted thousands of lines and never converged
> > > to a state it was happy with)
> > 
> > This looks like something btrfs-zero-log would work around (although
> > -o recovery should do mostly the same things).  That would destroy the
> > evidence though, and may just make things (slightly) worse, so I'd
> > wait to see if anyone suggests something better before trying it.  If
> > you're ultimately ending up restoring from backup though, it may save
> > you that effort at least.
> 
> Thanks for pointing out btrfs-zero-log, I hadn't re-read the wiki page since
> this got added.
> But I'll hold off at least until tomorrow morning (GMT-7).

I'm a bit surprised that no one seems to be replying on btrfs crashes,
that's a bit worrisome. I'm willing to risk my data somewhat, but if finding
a problem doesn't help fixing the code, I'm not sure if I'm helping anymore
:-/

Since I ran out of time, I tried:
gandalfthegreat:~# btrfs-zero-log 
usage: btrfs-zero-log dev
Btrfs Btrfs v0.19
gandalfthegreat:~# btrfs-zero-log /dev/mapper/bootdsk 
Check tree block failed, want=7533391872, have=17347973115472321934
Check tree block failed, want=7533391872, have=17347973115472321934
Check tree block failed, want=7533391872, have=8450612919225897562
Check tree block failed, want=7533391872, have=17347973115472321934
Check tree block failed, want=7533391872, have=17347973115472321934
read block failed check_tree_block
gandalfthegreat:~# 

So from here, unless someone chimes in tomorrow, I'm going to have to wipe
my filesystem and start over. I suppose that means btrfs can likely still
cause unknown and unfixable corruption.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
