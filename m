Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0070.outbound.protection.outlook.com ([104.47.116.70]:63461
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1764640AbdKRK2i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Nov 2017 05:28:38 -0500
From: Ben Hooper <ben@ayrton.com.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs check fails with: btrfs_alloc_chunk: BUG_ON `ret`
 triggered, value -28
Date: Sat, 18 Nov 2017 10:28:34 +0000
Message-ID: <B98611CB-D684-4D47-AA84-0CB7B2C96441@ayrton.com.au>
References: <SY3PR01MB1465C3E1A99997C75685BE0FF9280@SY3PR01MB1465.ausprd01.prod.outlook.com>
 <CAJCQCtTKNL9bjpeZFKU0r99R0kkMB4NQ_UE16CYX=9dDyWaXWA@mail.gmail.com>
In-Reply-To: <CAJCQCtTKNL9bjpeZFKU0r99R0kkMB4NQ_UE16CYX=9dDyWaXWA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> On 14 Nov 2017, at 11:45 am, Chris Murphy <lists@colorremedies.com> wrote:
> 
> On Mon, Nov 13, 2017 at 8:08 PM, Ben Hooper <ben@ayrton.com.au> wrote:
> 
>> [28205.454029] Code: 79 ff ff ff 49 8b 7c 24 60 89 da 48 c7 c6 68 c7 be a0 31 c0 e8 12 4e fe ff eb 9b 89 de 48 c7 c7 38 c7 be a0 31 c0 e8 53 11 5a e0 <0f> ff eb 87 66 90 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
>> [28205.456407] ---[ end trace 77358f42ce65a0d0 ]---
>> [28205.457579] BTRFS: error (device sdl) in btrfs_create_pending_block_groups:10254: errno=-27 unknown
>> [28206.172366] BTRFS: error (device sdl) in btrfs_create_pending_block_groups:10254: errno=-27 unknown
>> [28206.178599] BTRFS warning (device sdl): Skipping commit of aborted transaction.
>> [28206.179840] BTRFS: error (device sdl) in cleanup_transaction:1873: errno=-5 IO failure
>> [28206.256720] BTRFS error (device sdl): pending csums is 1368064
> 
> The mysterious -27. But then also IO failure. Are there any other
> storage related kernel messages in the ~2 to 5 minutes prior to this
> trace? I'm wondering if there's something misbehaving: cable,
> controller, drive, other.

Iâ€™m now getting these -27 daily with the filesystem automatically remounting RO. Still see no errors from the controller in the KRB.

Anyone have any other suggestions before I start migrating the filesystem?

Cheers,

Benÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
