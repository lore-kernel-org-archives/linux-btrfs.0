Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43420 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab3L1SID (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Dec 2013 13:08:03 -0500
Date: Sat, 28 Dec 2013 10:07:58 -0800
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
Message-ID: <20131228180758.GF19863@merlins.org>
References: <20131228171943.GE19863@merlins.org>
 <20131228173730.GA7234@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131228173730.GA7234@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 28, 2013 at 05:37:30PM +0000, Hugo Mills wrote:
> > Is it still being worked on, or kind of frozen/good as is?
> 
>    It's almost feature-complete: there's one version bump expected in
> the stream format, to handle files with holes in. There are probably
> still awkward bugs in there (awkward in the sense that your backups
> will fail noisily if you hit one), but for my current usage -- disk to
> disk on the same system -- it seems to work OK.
> 
>    I'm trying at the moment to hack together a working send/receive
> backup between two systems. As far as I know, the send/receive will
> work OK, but I'm having problems with firewalls and ssh tunnels right
> now. :)

Good to know, thanks.

Just curious: what happens if the destination you're syncing the
snapshot diff to, isn't quite like expected?

For instance, if I use an existing rsync destination to start syncing
btrfs snapshots to after that, and one file operation can't be applied
because let's say the destination file it's supposed to be applied to,
isn't there?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
