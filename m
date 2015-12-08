Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53464 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965362AbbLHQjR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 11:39:17 -0500
Date: Tue, 8 Dec 2015 08:39:16 -0800
From: Marc MERLIN <marc@merlins.org>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: Lionel Bouton <lionel-subscription@bouton.name>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Scrub: no spae left on device
Message-ID: <20151208163916.GP27889@merlins.org>
References: <20151208150638.GL27889@merlins.org> <5666F947.5010902@googlemail.com> <5666FB58.2040900@bouton.name> <20151208160615.GO27889@merlins.org> <56670430.4070907@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <56670430.4070907@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 08, 2015 at 05:24:16PM +0100, Holger Hoffstätte wrote:
> On 12/08/15 17:06, Marc MERLIN wrote:
> > Label: 'btrfs_pool1'  uuid: 5ee24229-2431-448a-868e-2c325d10bfa7
> > 	Total devices 1 FS bytes used 524.26GiB
> > 	devid    1 size 615.01GiB used 614.94GiB path /dev/mapper/pool1
>                         ^^^^^^^^^^^^^^^^^^^^^^^^
> This is what I was alluding to. You could have started a -dusage balance
> *before* the scrub so that one or several data chunks get freed.
> Balancing metadata when you're out of space accomplishes nothing and only
> will very likely fail, just as you saw. You have ~90GB usable space, but
> that space is spread over chunks with low utilisation.

Yes, my partition got a bit full, I freed up space, and unfortunately we
still don't have a background rebalance to fix this, so I did run a manual
one.
But my filesystem was usable, I was writing to it just fine. I was just very
surprised that scrub needed to rewrite blocks on a single disk device.

You could make the case that scrub and balance=0 should be run together.
In the meantime, I upgraded my script:
http://marc.merlins.org/perso/btrfs/2014-03.html#Btrfs-Tips_-Btrfs-Scrub-and-Btrfs-Filesystem-Repair
http://marc.merlins.org/linux/scripts/btrfs-scrub

I figured there is no good reason not to run a balance 20 on metadata and
data every night.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
