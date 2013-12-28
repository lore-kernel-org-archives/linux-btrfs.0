Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43500 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3L1SVr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Dec 2013 13:21:47 -0500
Date: Sat, 28 Dec 2013 10:20:23 -0800
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
Message-ID: <20131228182023.GG19863@merlins.org>
References: <20131228171943.GE19863@merlins.org>
 <20131228173730.GA7234@carfax.org.uk>
 <20131228180758.GF19863@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131228180758.GF19863@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 28, 2013 at 10:07:58AM -0800, Marc MERLIN wrote:
> For instance, if I use an existing rsync destination to start syncing
> btrfs snapshots to after that, and one file operation can't be applied
> because let's say the destination file it's supposed to be applied to,
> isn't there?

I should have written more: I'm guessing what happens is that the btrfs
receive fails/aborts, I get an error, I then run a manual rsync to reset
everything to a good known state, and then continue the btrfs
send/receive after that?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
