Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33080 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab3L3QRe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 11:17:34 -0500
Date: Mon, 30 Dec 2013 08:17:29 -0800
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "hugo@carfax.org.uk" <hugo@carfax.org.uk>
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
Message-ID: <20131230161729.GQ19863@merlins.org>
References: <20131228171943.GE19863@merlins.org>
 <20131228173730.GA7234@carfax.org.uk>
 <20131228180758.GF19863@merlins.org>
 <20131228182023.GG19863@merlins.org>
 <1388419531.11341.6.camel@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1388419531.11341.6.camel@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 30, 2013 at 04:05:03PM +0000, Chris Mason wrote:
> On Sat, 2013-12-28 at 10:20 -0800, Marc MERLIN wrote:
> > On Sat, Dec 28, 2013 at 10:07:58AM -0800, Marc MERLIN wrote:
> > > For instance, if I use an existing rsync destination to start syncing
> > > btrfs snapshots to after that, and one file operation can't be applied
> > > because let's say the destination file it's supposed to be applied to,
> > > isn't there?
> > 
> > I should have written more: I'm guessing what happens is that the btrfs
> > receive fails/aborts, I get an error, I then run a manual rsync to reset
> > everything to a good known state, and then continue the btrfs
> > send/receive after that?
> 
> Btrfs send/receive works by matching state between snapshots on the
> sending and receiving end.  If you update the files manually on the
> receiving end (say with rsync), it can't merge the states anymore.

I got that, but it wasn't quite my question :)

I understand that btrfs receive cannot apply file changes if the
destination filesystem isn't in a file state that's identical to the source
one.

I'm just not too sure how the destination FS needs to be configured so
that btrfs receive can work with it.

1) Does it need to be an exact byte for byte copy of the block device the
source was on?

2) Or can the destination be seeded with a full rsync or cp -a and can btrfs receive
take over from there?

3) Then, if I hit a bug where something doesn't get synced right, and I run
rsync to fix or verify that the two FS are indeed identical file-wise
like they're supposed to, if rsync fixes something, are you saying that
it'll stop btrfs receive from working after that?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
