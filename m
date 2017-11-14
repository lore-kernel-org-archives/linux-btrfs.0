Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:52825 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751171AbdKNDpO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 22:45:14 -0500
Received: by mail-oi0-f66.google.com with SMTP id r128so12799770oig.9
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 19:45:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <SY3PR01MB1465C3E1A99997C75685BE0FF9280@SY3PR01MB1465.ausprd01.prod.outlook.com>
References: <SY3PR01MB1465C3E1A99997C75685BE0FF9280@SY3PR01MB1465.ausprd01.prod.outlook.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 13 Nov 2017 20:45:13 -0700
Message-ID: <CAJCQCtTKNL9bjpeZFKU0r99R0kkMB4NQ_UE16CYX=9dDyWaXWA@mail.gmail.com>
Subject: Re: btrfs check fails with: btrfs_alloc_chunk: BUG_ON `ret`
 triggered, value -28
To: Ben Hooper <ben@ayrton.com.au>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 13, 2017 at 8:08 PM, Ben Hooper <ben@ayrton.com.au> wrote:

> [28205.454029] Code: 79 ff ff ff 49 8b 7c 24 60 89 da 48 c7 c6 68 c7 be a0 31 c0 e8 12 4e fe ff eb 9b 89 de 48 c7 c7 38 c7 be a0 31 c0 e8 53 11 5a e0 <0f> ff eb 87 66 90 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
> [28205.456407] ---[ end trace 77358f42ce65a0d0 ]---
> [28205.457579] BTRFS: error (device sdl) in btrfs_create_pending_block_groups:10254: errno=-27 unknown
> [28206.172366] BTRFS: error (device sdl) in btrfs_create_pending_block_groups:10254: errno=-27 unknown
> [28206.178599] BTRFS warning (device sdl): Skipping commit of aborted transaction.
> [28206.179840] BTRFS: error (device sdl) in cleanup_transaction:1873: errno=-5 IO failure
> [28206.256720] BTRFS error (device sdl): pending csums is 1368064

The mysterious -27. But then also IO failure. Are there any other
storage related kernel messages in the ~2 to 5 minutes prior to this
trace? I'm wondering if there's something misbehaving: cable,
controller, drive, other.




-- 
Chris Murphy
