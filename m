Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:46258 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdKNDuq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 22:50:46 -0500
Received: by mail-oi0-f66.google.com with SMTP id n16so3740473oig.3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 19:50:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTKNL9bjpeZFKU0r99R0kkMB4NQ_UE16CYX=9dDyWaXWA@mail.gmail.com>
References: <SY3PR01MB1465C3E1A99997C75685BE0FF9280@SY3PR01MB1465.ausprd01.prod.outlook.com>
 <CAJCQCtTKNL9bjpeZFKU0r99R0kkMB4NQ_UE16CYX=9dDyWaXWA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 13 Nov 2017 20:50:45 -0700
Message-ID: <CAJCQCtQ3_pxXbt=t+L8zuHCzUmfBrLnSOSDS1aUB9mjbR5z+Pw@mail.gmail.com>
Subject: Re: btrfs check fails with: btrfs_alloc_chunk: BUG_ON `ret`
 triggered, value -28
To: Omar Sandoval <osandov@osandov.com>, Filipe Manana <fdmanana@gmail.com>
Cc: Ben Hooper <ben@ayrton.com.au>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 13, 2017 at 8:45 PM, Chris Murphy <lists@colorremedies.com> wrote:
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
>

Found a similar trace from July 2015 that Omar ran into and Filipe
thought he was close to tracking it down. It was also a pretty big
file system. Maybe they have an idea here. But btrfs check blowing up
isn't good in any case.



-- 
Chris Murphy
