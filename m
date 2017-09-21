Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0050.outbound.protection.outlook.com ([104.47.116.50]:64022
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751652AbdIUGYC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Sep 2017 02:24:02 -0400
From: Paul Jones <paul@pauljones.id.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: SSD caching an existing btrfs raid1
Date: Thu, 21 Sep 2017 06:23:59 +0000
Message-ID: <MEXPR01MB2168811AC03C93E7122642379E660@MEXPR01MB2168.ausprd01.prod.outlook.com>
References: <4ed24e33-09e1-c03a-912c-9d1b2bbdc835@gmail.com>
        <2a208f7c-a140-3ac6-12c6-2e953f3f96ec@gmail.com>
        <36669362-6401-72e3-f963-41de0debd0a4@gmail.com>
 <20170920224520.044d4c45@jupiter.sol.kaishome.de>
In-Reply-To: <20170920224520.044d4c45@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Kai Krakow
> Sent: Thursday, 21 September 2017 6:45 AM
> To: linux-btrfs@vger.kernel.org
> Subject: Re: SSD caching an existing btrfs raid1
> 
> Am Wed, 20 Sep 2017 17:51:15 +0200
> schrieb Psalle <psalleetsile@gmail.com>:
> 
> > On 19/09/17 17:47, Austin S. Hemmelgarn wrote:
> > (...)
> > >
> > > A better option if you can afford to remove a single device from
> > > that array temporarily is to use bcache.Â  Bcache has one specific
> > > advantage in this case, multiple backend devices can share the same
> > > cache device. This means you don't have to carve out dedicated cache
> > > space for each disk on the SSD and leave some unused space so that
> > > you can add new devices if needed.Â  The downside is that you can't
> > > convert each device in-place, but because you're using BTRFS, you
> > > can still convert the volume as a whole in-place.Â  The procedure for
> > > doing so looks like this:
> > >
> > > 1. Format the SSD as a bcache cache.
> > > 2. Use `btrfs device delete` to remove a single hard drive from the
> > > array.
> > > 3. Set up the drive you just removed as a bcache backing device
> > > bound to the cache you created in step 1.
> > > 4. Add the new bcache device to the array.
> > > 5. Repeat from step 2 until the whole array is converted.
> > >
> > > A similar procedure can actually be used to do almost any underlying
> > > storage conversion (for example, switching to whole disk encryption,
> > > or adding LVM underneath BTRFS) provided all your data can fit on
> > > one less disk than you have.
> >
> > Thanks Austin, that's just great. For some reason I had discarded
> > bcache thinking that it would force me to rebuild from scratch, but
> > this kind of incremental migration is exactly why I hoped was
> > possible. I have plenty of space to replace the devices one by one.
> >
> > I will report back my experience in a few days, I hope.
> 
> I've done it exactly that way in the past and it worked flawlessly (but it took
> 24+ hours). But it was easy for me because I was also adding a third disk to
> the pool, so existing stuff could easily move.

Device delete takes freaking ages! I would avoid using it if you can. Device replace is much faster.


Paul.




ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
