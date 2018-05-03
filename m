Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oln040092067030.outbound.protection.outlook.com ([40.92.67.30]:22932
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751075AbeECMrv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 May 2018 08:47:51 -0400
From: Alberto Bursi <alberto.bursi@outlook.it>
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: RAID56 - 6 parity raid
Date: Thu, 3 May 2018 12:47:49 +0000
Message-ID: <VI1PR08MB0336F86EAF3DF8BF47E66E8692870@VI1PR08MB0336.eurprd08.prod.outlook.com>
References: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
In-Reply-To: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/05/2018 23:57, Gandalf Corvotempesta wrote:
> Hi to all
> I've found some patches from Andrea Mazzoleni that adds support up to 6
> parity raid.
> Why these are wasn't merged ?
> With modern disk size, having something greater than 2 parity, would be
> great.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

His patch was about a generic library to do RAID6, it wasn't directly 
for btrfs.

To actually use that for btrfs someone would have to actually port btrfs 
to that library.

-Alberto
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
