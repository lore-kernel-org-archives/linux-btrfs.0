Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59249 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934218Ab2JYUMY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 16:12:24 -0400
Date: Thu, 25 Oct 2012 13:12:23 -0700
From: Marc MERLIN <marc@merlins.org>
To: cwillu <cwillu@cwillu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Need help mounting laptop corrupted root btrfs. Kernel BUG at fs/btrfs/volumes.c:3707
Message-ID: <20121025201223.GB24111@merlins.org>
References: <20121025195805.GA24111@merlins.org> <CAE5mzvi=y6Auyr9cGMOm=tUSSj7sSQ78W0Bnzk+dJOqkW6z6jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAE5mzvi=y6Auyr9cGMOm=tUSSj7sSQ78W0Bnzk+dJOqkW6z6jA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 25, 2012 at 02:03:49PM -0600, cwillu wrote:
> > 3) Want me to try btrfsck although it may make it impossible for me to
> > reproduce the bug and test a fix, as well as potentially break the filesystem
> > more (last time I tried btrfsck, it outputted thousands of lines and never converged
> > to a state it was happy with)
> 
> This looks like something btrfs-zero-log would work around (although
> -o recovery should do mostly the same things).  That would destroy the
> evidence though, and may just make things (slightly) worse, so I'd
> wait to see if anyone suggests something better before trying it.  If
> you're ultimately ending up restoring from backup though, it may save
> you that effort at least.

Thanks for pointing out btrfs-zero-log, I hadn't re-read the wiki page since
this got added.
But I'll hold off at least until tomorrow morning (GMT-7).

If someone would like me to hold off a bit longer, please let me know and
I'll wait for whatever patch you'd like me to try.

As for backups, yes, I have some :) and I also have hourly, daily, weekly
btrfs subvolume snapshots, but I can't use those currently since I can't
mount the base filesystem.
If my latest snapshot is corrupted, once I know which subvolume has the
problem (I can't quite tell since the crash doesn't say which subvolume is
causing it), I can revert to the last hourly snapshot.

Thanks for your reply.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
