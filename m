Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39679 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbaHKPx3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 11:53:29 -0400
Date: Mon, 11 Aug 2014 08:53:19 -0700
From: Marc MERLIN <marc@merlins.org>
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: Nikolaus Rath <Nikolaus@rath.org>, linux-btrfs@vger.kernel.org
Message-ID: <20140811155319.GD25324@merlins.org>
References: <87mwbbnjpt.fsf@vostro.rath.org>
 <1407771945.6404.1.camel@kepstin.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1407771945.6404.1.camel@kepstin.ca>
Subject: Re: File system stuck in scrub
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 11, 2014 at 11:45:45AM -0400, Calvin Walton wrote:
> > $ sudo btrfs scrub start /home/nikratio/
> > ERROR: scrub is already running.
> > To cancel use 'btrfs scrub cancel /home/nikratio/'.
> > To see the status use 'btrfs scrub status [-d] /home/nikratio/'.
> My guess is that this is a mismatch between some state stored by the 
> userspace tools and the state in the kernel. One of the things you can 
> try is to delete the files /var/lib/btrfs/scrub.status.* - that will 
> force the btrfs tools to get the current status from the kernel (you 
> will lose some statistics and scrub history.)

No need to really delete it, just changing one character will do :)

http://marc.merlins.org/perso/btrfs/post_2014-04-26_Btrfs-Tips_-Cancel-A-Btrfs-Scrub-That-Is-Already-Stopped.html

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
