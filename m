Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46724 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaC3PNH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Mar 2014 11:13:07 -0400
Date: Sun, 30 Mar 2014 07:27:33 -0700
From: Marc MERLIN <marc@merlins.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send/receive still gets out of sync in 3.14.0
Message-ID: <20140330142733.GB22552@merlins.org>
References: <20140322210455.GL28005@merlins.org>
 <20140330032202.GV22552@merlins.org>
 <20140330124224.GN7442@carfax.org.uk>
 <CAL3q7H6C+fBBK4n7cL8r1zoZ=onn2hM5jKLcxN4b5dbQnUKXcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6C+fBBK4n7cL8r1zoZ=onn2hM5jKLcxN4b5dbQnUKXcA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 30, 2014 at 02:13:35PM +0100, Filipe David Manana wrote:
> On Sun, Mar 30, 2014 at 1:42 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Sat, Mar 29, 2014 at 08:22:02PM -0700, Marc MERLIN wrote:
> >> On Sat, Mar 22, 2014 at 02:04:56PM -0700, Marc MERLIN wrote:
> >> > After deleting a huge directory tree in my /home subvolume, syncing
> >> > snapshots now fails with:
> >> >
> >> > ERROR: rmdir o1952777-157-0 failed. No such file or directory
> >>
> >> So, I'm ok again after I deleted my destination snapshot and re-init'ed,
> >> but on multi terabyte backups, this ain't great :)
> >>
> >> Do I need to file a bug that btrfs send/receive still gets out of sync
> >> in 3.14, or is it already known and maybe even fixed in btrfs-next?
> >
> >    Filipe has been posting a series of patches related to send/receive
> > recently, so this may be related to those bugs.
> 
> Yes, this one in particular might have fixed the issue:
> 
> http://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?id=29d6d30f5c8aa58b04f40a58442df3bcaae5a1d5
> 
> (There might be other cases that attempt to rmdir a non-existing
> orphan directory)

Cool, thanks for fixing those. 
Is that meant to make it in 3.14 final, or is it going to be 3.15?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
