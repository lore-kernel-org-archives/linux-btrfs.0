Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0074.outbound.protection.outlook.com ([104.47.116.74]:9280
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750878AbdJBLPG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Oct 2017 07:15:06 -0400
From: Paul Jones <paul@pauljones.id.au>
To: =?utf-8?B?TmljY29sw7IgQmVsbGk=?= <darkbasic@linuxsystems.it>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Why do full balance and deduplication reduce available free
  space?
Date: Mon, 2 Oct 2017 11:14:59 +0000
Message-ID: <MEXPR01MB216878C061CDA1682E356D4A9E7D0@MEXPR01MB2168.ausprd01.prod.outlook.com>
References: <49ec6395-19b4-46e0-83cf-806ef6cdd396@linuxsystems.it>
 <e5bd0dc3-f7a5-7461-0630-6f755425009f@mendix.com>
 <569fb850091001ea7476100eae050c00@linuxsystems.it>
In-Reply-To: <569fb850091001ea7476100eae050c00@linuxsystems.it>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of NiccolÃ² Belli
> Sent: Monday, 2 October 2017 9:29 PM
> To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: Why do full balance and deduplication reduce available free
> space?
> 
> Il 2017-10-02 12:16 Hans van Kranenburg ha scritto:
> > On 10/02/2017 12:02 PM, NiccolÃ² Belli wrote:
> >> [...]
> >>
> >> Since I use lots of snapshots [...] I had to create a systemd timer
> >> to perform a full balance and deduplication each night.
> >
> > Can you explain what's your reasoning behind this 'because X it needs
> > Y'? I don't follow.
> 
> Available free space is important to me, so I want snapshots to be
> deduplicated as well. Since I cannot deduplicate snapshots because they are
> read-only, then the data must be already deduplicated before the snapshots
> are taken. I do not consider the hourly snapshots because in a day they will
> be gone anyway, but daily snapshots will stay there for much longer so I want
> them to be deduplicated.

I use bees for deduplication and it will quite happily dedupe read-only snapshots. You could always change them to RW while dedupe is running then change back to RO.


Paul.




ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
