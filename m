Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51169 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbbGIRRk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jul 2015 13:17:40 -0400
Date: Thu, 9 Jul 2015 10:17:37 -0700
From: Marc MERLIN <marc@merlins.org>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Anyone tried out btrbk yet?
Message-ID: <20150709171737.GS17274@merlins.org>
References: <11148188.L9vtSMaNHV@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <11148188.L9vtSMaNHV@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 09, 2015 at 02:26:55PM +0200, Martin Steigerwald wrote:
> Hi!
> 
> I see Alex, the developer of btrbk posted here once about btrfs send and 
> receive, but well any other users of btrbk¹? What are your experiences?
> 
> I consider switching to it from my home grown rsync based backup script to 
> it.
> 
> Well I may try it for one of my BTRFS volumes in addition to the rsync 
> backup for now. I would like to give all options on command line, but well, 
> maybe it can completely replace my current script if I put everything in its 
> configuration.
> 
> Any other handy BTRFS backup solutions?

I use my own which I wrote :)
http://marc.merlins.org/perso/btrfs/2014-03.html#Btrfs-Tips_-Doing-Fast-Incremental-Backups-With-Btrfs-Send-and-Receive
http://marc.merlins.org/linux/scripts/btrfs-subvolume-backup

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
