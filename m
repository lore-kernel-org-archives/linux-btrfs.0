Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-sy3aus01on0051.outbound.protection.outlook.com ([104.47.117.51]:21268
        "EHLO AUS01-SY3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751135AbdIOKMX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 06:12:23 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Marat Khalili <mkh@rqc.ru>, Hugo Mills <hugo@carfax.org.uk>,
        "Goffredo Baroncelli" <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: RE: BUG: BTRFS and O_DIRECT could lead to wrong checksum and wrong
 data
Date: Fri, 15 Sep 2017 10:12:20 +0000
Message-ID: <MEXPR01MB2168100EB552E2F59C57DD559E6C0@MEXPR01MB2168.ausprd01.prod.outlook.com>
References: <cf8a733f-2c9d-7ffe-e865-4c13d99dfb60@libero.it>
 <20170914221824.GD7067@carfax.org.uk>
 <15f070ee-ec6a-2140-0908-c43f466505ad@inwind.it>
 <20170915082601.GE7067@carfax.org.uk>
 <7aa8063a-2f1f-c611-d24a-d5e6a9ceb29b@rqc.ru>
In-Reply-To: <7aa8063a-2f1f-c611-d24a-d5e6a9ceb29b@rqc.ru>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Marat Khalili
> Sent: Friday, 15 September 2017 7:50 PM
> To: Hugo Mills <hugo@carfax.org.uk>; Goffredo Baroncelli
> <kreijack@inwind.it>; linux-btrfs <linux-btrfs@vger.kernel.org>
> Subject: Re: BUG: BTRFS and O_DIRECT could lead to wrong checksum and
> wrong data
> 
> May I state my user's point of view:
> 
> I know one applications that uses O_DIRECT, and it is subtly broken on BTRFS.
> I know no applications that use O_DIRECT and are not broken.
> (Really more statistics would help here, probably some exist that provably
> work.) According to developers making O_DIRECT work on BTRFS is difficult if
> not impossible. Isn't it time to disable O_DIRECT like ZFS does AFAIU? Data
> safety is certainly more important than performance gain it may or may not
> give some applications.

I agree - I've had trouble with this before because I didn't understand the consequences of using it.
It would be better to hide it behind a mount option or similar IMHO.

Paul.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
