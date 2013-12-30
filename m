Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33438 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab3L3RKk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 12:10:40 -0500
Date: Mon, 30 Dec 2013 09:10:39 -0800
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "hugo@carfax.org.uk" <hugo@carfax.org.uk>
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
Message-ID: <20131230171039.GC26054@merlins.org>
References: <20131228171943.GE19863@merlins.org> <20131228173730.GA7234@carfax.org.uk> <20131228180758.GF19863@merlins.org> <20131228182023.GG19863@merlins.org> <1388419531.11341.6.camel@ret.masoncoding.com> <20131230161729.GQ19863@merlins.org> <1388420830.11341.12.camel@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1388420830.11341.12.camel@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 30, 2013 at 04:26:42PM +0000, Chris Mason wrote:
> > 1) Does it need to be an exact byte for byte copy of the block device the
> > source was on?
> > 
> No, in fact this doesn't help.
> 
> > 2) Or can the destination be seeded with a full rsync or cp -a and can btrfs receive
> > take over from there?
> 
> No, it has to be created by btrfs receive.

Aaah, I wasn't clear on that, thanks for clarifying.
So I need to make sure the target block device is at least as big as the
source one, and if necessary a few blocks bigger if the drives do not
allocate partitions of the exactly the same size.

Mmmh, this makes it less desirable for me to use this then since I use over
allocation on the backup servers and if I had to have as much space blocked
off for the full size of each filesystem backed up, I'm going to be short.

Bummer.
 
> > 3) Then, if I hit a bug where something doesn't get synced right, and I run
> > rsync to fix or verify that the two FS are indeed identical file-wise
> > like they're supposed to, if rsync fixes something, are you saying that
> > it'll stop btrfs receive from working after that?
> 
> Yes, today anyway it won't work.  Send converts the changed items into
> an intermediate format (we don't send btree blocks directly over the
> wire) and then receive modifies the destination from userland.
> 
> At the end of the stream we update the destination root to say "you're
> now version xxyyzz of uuid aabbcc".
> 
> We definitely could add a way to manually set this, but once a user does
> it, it'll be very hard to debug any problems they might have had if
> their copy wasn't actually up to date.

Understood. I dreamt that it was computing file differences and could just
apply them on top of any other btrfs filesystem, even if it were smaller and
had been created via rsync.

If one day, it could at least work on a subvolume level (only sync a
subvolume), then it would be more useful to me. Maybe later...

Thanks for clearing that up.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
