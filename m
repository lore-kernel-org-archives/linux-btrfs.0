Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48621 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaCVUA6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Mar 2014 16:00:58 -0400
Date: Sat, 22 Mar 2014 13:00:57 -0700
From: Marc MERLIN <marc@merlins.org>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Send/Receive howto and script for others to use (was Re: Is anyone using btrfs send/receive)
Message-ID: <20140322200057.GJ28005@merlins.org>
References: <20131228171943.GE19863@merlins.org> <20131228173730.GA7234@carfax.org.uk> <20131228180758.GF19863@merlins.org> <20140107104951.GL10936@merlins.org> <20140107105329.GE15634@carfax.org.uk> <20140108080206.GV10936@merlins.org> <20140321172904.GE28005@merlins.org> <532DE805.7040407@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <532DE805.7040407@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 22, 2014 at 09:44:05PM +0200, Brendan Hide wrote:
> Hi, Marc
> 
> Feel free to use ideas from my own script. Some aspects in my script are 
> more mature and others are frankly pathetic. ;)
> 
> There are also quite a lot of TODOs throughout my script that aren't 
> likely to get the urgent attention they deserve. It has been slowly 
> evolving over the last two weeks.
> 
> http://swiftspirit.co.za/scripts/btrfs-snd-rcv-backup

I figured I likely wasn't the only one working on a script like this :)

>From a quick read, it looks even more complex than mine :) but
- it doesn't do ssh to a destination for a remote backup
- it doesn't seem to keep a list of configurable snapshots not necessary for
send/restore but useful for getting historical data
- it doesn't seem to use a symlink to keep track of the last complete
snapshot on the source and destination, and does more work to compensate
when recovering from an incomplete backup/restore.
- it doesn't create writeable snapshots on the destination in case you want
to use the copy as a live filesystem

Things I noticed:
- I don't use ionice, maybe I should. Did you find that it actually made a
difference with send/receive?
- Your comments say shlock isn't safe and that's documented. I don't see
that in the man page
http://manpages.ubuntu.com/manpages/trusty/man1/shlock.1.html
I'd love to have details on this if I shouldn't be using it
- Is set -o noclobber; echo $$ > $lockfile really atomic and safer than
shlock? If so, great, although I would then wonder why shlock even exists :)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
