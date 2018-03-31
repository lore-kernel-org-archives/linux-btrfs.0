Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:46247 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751922AbeCaWnz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 31 Mar 2018 18:43:55 -0400
Received: by mail-oi0-f41.google.com with SMTP id e123-v6so10271515oih.13
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Mar 2018 15:43:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180331224006.llzkfni4tsuaaveg@angband.pl>
References: <CAJCQCtTTerrYvXpof+jiShO1D8PmaPaFCA9W1PyFxaGs0PZaig@mail.gmail.com>
 <20180331224006.llzkfni4tsuaaveg@angband.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 31 Mar 2018 16:43:54 -0600
Message-ID: <CAJCQCtScwyQFHxQB=wiP3XAepYZ9pmA+LpK8F1yRBdZ0bbn2Jg@mail.gmail.com>
Subject: Re: dead or dying SDXC card fsck's OK but mount hangs indefinitely
To: Adam Borowski <kilobyte@angband.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Btrfs BTRFS <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 31, 2018 at 4:40 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Sat, Mar 31, 2018 at 03:50:03PM -0600, Chris Murphy wrote:
>> This is perhaps a novelty problem report. And it's also a throw away
>> card data wise, and is a $12 Samsung EVO+ SDXC card used in an Intel
>> NUC.
>>
>> It contains FAT, ext4, and Btrfs file systems. They can all be fsck'd,
>> but none can be mounted. Even if it use blockdev --setro on the entire
>> mmc device and then mount -o ro it still fails. Kinda weird huh?
>
>> [69107.488123] mmc0: Card stuck in programming state! mmcblk0 card_busy_detect
>> [69107.539128] mmc0: Tuning timeout, falling back to fixed sampling clock
>
>> The corrupt 10 was fixed with a scrub months ago, and I never reset
>> the counter so that's not a current corruption. The most recent scrub
>> was maybe a week ago. And even offline scrub works. So literally every
>> single block related to this Btrfs file system is readable, and yet
>> it's not mountable? Very weird.
>
>> Basically the card is in some sort of state that the kernel code is
>> not going to ever second guess. So there's no further error or reset
>> attempt.
>
> As the SD card is tiny compared to any hard disks (be they spinning or
> solid), I'd dd it as an image as the first step.
>
> This in general is a wise step for any kind of recovery, but in your case
> it's especially easy.  It also lets you separate hardware issues from
> filesystem corruption.

It's definitely not file system corruption. The FAT and ext4 volumes
have the same issue, they will not mount, presumably because they
immediately want to update a superblock.

Anyway, recovery not required. Just a spectacle that it fails in a
readable state (it's completely totally readable once mounting
ro,nologreplay) but not a single write can happen.

Also blkdiscard command succeeds, but does nothing. All the data is
still present.

-- 
Chris Murphy
