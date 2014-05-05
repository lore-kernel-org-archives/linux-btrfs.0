Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50062 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbaEEVZY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 17:25:24 -0400
Date: Mon, 5 May 2014 14:25:13 -0700
From: Marc MERLIN <marc@merlins.org>
To: john terragon <jterragon@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs on software RAID0
Message-ID: <20140505212513.GS10159@merlins.org>
References: <CANg_oxxFKHioyWO0ct7vcT=aTbX11KbCKtGwvZo_59jirLDGow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANg_oxxFKHioyWO0ct7vcT=aTbX11KbCKtGwvZo_59jirLDGow@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 05, 2014 at 10:51:46PM +0200, john terragon wrote:
> Hi.
> I'm about to try btrfs on an RAID0 md device (to be precise there will
> be dm-crypt in between the md device and btrfs). If I used ext4 I
> would set the stride and stripe_width extended options. Is there
> anything similar I should be doing with mkfs.btrfs? Or maybe some
> mount options beneficial to this kind of setting.

This is not directly an answer to your question, so far I haven't used a
special option like this with btrfs on my arrays although my
undertstanding is that it's not as important as with ext4.

That said, please read
http://marc.merlins.org/perso/btrfs/post_2014-04-27_Btrfs-Multi-Device-Dmcrypt.html

1) use align-payload=1024 on cryptsetup instead of something bigger like
8192. This will reduce write amplification (if you're not on an SSD).

2) you don't need md0 in the middle, crypt each device and then use
btrfs built in raid0 which will be faster (and is stable, at least as
far as we know :) ).

Then use /etc/crypttab or a script like this
http://marc.merlins.org/linux/scripts/start-btrfs-dmcrypt
to decrypt all your devices in one swoop and mount btrfs.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
