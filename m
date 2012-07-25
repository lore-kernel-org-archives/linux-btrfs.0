Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:40892 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964778Ab2GYPRe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 11:17:34 -0400
Date: Wed, 25 Jul 2012 11:17:30 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Hugo Mills <hugo@carfax.org.uk>
CC: Alexander Block <ablock84@googlemail.com>, Arne Jansen <sensille@gmx.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH 0/6] Experimental btrfs send/receive (btrfs-progs)
Message-ID: <20120725151730.GA22762@shiny>
References: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
 <500D43A7.1010801@gmx.net>
 <CAB9VWqAGTOttaz722LnMiufPNUZaLQU7epAdGFejK9gssuHnRg@mail.gmail.com>
 <20120725140036.GE30007@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120725140036.GE30007@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 25, 2012 at 08:00:36AM -0600, Hugo Mills wrote:
> On Wed, Jul 25, 2012 at 12:41:56PM +0200, Alexander Block wrote:
> > On Mon, Jul 23, 2012 at 2:29 PM, Arne Jansen <sensille@gmx.net> wrote:
> > > On 04.07.2012 15:39, Alexander Block wrote:
> > >> Hello all,
> > >>
> > >> This is the user space side of btrfs send/receive.
> > >>
> > >> You can apply them manually or use my git repo:
> > >>
> > >> git://github.com/ablock84/btrfs-progs.git (branch send)
> > >>
> > >> The branch is based on Hugo's integration-20120605 branch. I had to add a temporary
> > >> commit to fix a bug introduced in one of the strncpy/overflow patches that got into
> > >> btrfs-progs. This fix is not part of the btrfs send/receive patchset, but you'll
> > >> probably need it if you want to base on the integration branch. I hope this is not
> > >> required in the future when a new integration branch comes out.
> > >>
> > >> Example usage:
> > >>
> > >> Multiple snapshots at once:
> > >> btrfs send /mnt/snap[123] > snap123.btrfs
> > >
> > > a) Do we really want a single token command here, not
> > > btrfs filesystem send or subvol send?
> > In my opinion the single token is easier to type and remember. But if
> > enough speaks for normal subcommands this can be changed (but by
> > someone else as I'm running out of time).
> 
>    Since everything else is two commands, yes, I think we need it for
> consistency. (And, since it's a publically-visible interface, for
> acceptance of the patches -- we don't want to be changing the way the
> commands work after the fact).

I've been sending and receiving while getting this code integrated.
These are really first class operations, and I'd prefer they not be
sub-commands.

I'm afraid there isn't a lot of logic here, just what feels good to
type.

-chris
