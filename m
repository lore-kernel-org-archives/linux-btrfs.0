Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35629 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755375AbcH1RP3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 13:15:29 -0400
Received: by mail-oi0-f45.google.com with SMTP id j203so23447867oih.2
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Aug 2016 10:15:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+WRLO8KuP8LS77NUbZLAs3e120oFudES_R3tYQjjYiCXH4BOA@mail.gmail.com>
References: <CA+WRLO8KuP8LS77NUbZLAs3e120oFudES_R3tYQjjYiCXH4BOA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 28 Aug 2016 11:15:28 -0600
Message-ID: <CAJCQCtSUVeXwuKn8rR_Rw24anzHNSLgVo_wYkot1mZYXiGkJ1w@mail.gmail.com>
Subject: Re: Recommendation on raid5 drive error resolution
To: Gareth Pye <gareth@cerberos.id.au>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 25, 2016 at 1:23 AM, Gareth Pye <gareth@cerberos.id.au> wrote:
> So I've been living on the reckless-side (meta RAID6, data RAID5) and
> I have a drive or two that isn't playing nicely any more.
>
> dmesg of the system running for a few minutes: http://pastebin.com/9pHBRQVe
>
> Everything of value is backed up, but I'd rather keep data than
> download it all again. When I only saw one disk having troubles I was
> concerned. Now I notice both sda and sdc having issues I'm thinking I
> might be about to have a bad time.
>
> What else should I provide?


[   72.555921] BTRFS info (device sda7): bdev /dev/sdc errs: wr 0, rd
9091, flush 0, corrupt 0, gen 0
[   72.555941] BTRFS info (device sda7): bdev /dev/sdh errs: wr 0, rd
74, flush 0, corrupt 0, gen 0

Two devices with read errors, bad. If they overlap, it's basically a
dead raid5. And it also means you *CANNOT* remove either drive.  So
now you have a problem, and I highly advise that you fresh your backup
because this is a really fragile state for any raid5.

What's the result from these two commands for every drive in this array?

smarctl -l scterc <dev>
cat /sys/block/sdX/device/timeout

The SCTERC value must be less than the timeout. This really must be
the first thing you do, even before starting your backup, because
otherwise a misconfiguration here has a very good chance of preventing
the success of getting a backup. Note these are not persistent
settings.


-- 
Chris Murphy
