Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36664 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdE1WZI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 May 2017 18:25:08 -0400
Received: by mail-wm0-f42.google.com with SMTP id 7so34910127wmo.1
        for <linux-btrfs@vger.kernel.org>; Sun, 28 May 2017 15:25:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHPjZW7Af2KzRr_HTaCNGqRAM0SsV8+gJWSRis6eCjGeXNBK7Q@mail.gmail.com>
References: <CAHPjZW7Af2KzRr_HTaCNGqRAM0SsV8+gJWSRis6eCjGeXNBK7Q@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 28 May 2017 16:25:06 -0600
Message-ID: <CAJCQCtQWoE_J24uHMzb3y-c1PPStj64cEkOz2YXQDKPX6J3j_A@mail.gmail.com>
Subject: Re: btrfs mounts RO, kernel oops on RW
To: Bill Williamson <bill@bbqninja.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 27, 2017 at 8:46 PM, Bill Williamson <bill@bbqninja.com> wrote:
> btrfs_async_reclaim_metadata_space

I only found this:
https://www.spinics.net/lists/linux-btrfs/msg62382.html

I can't tell if it's related though.


I'd include the results from btrfs check and btrfs check
--mode=lowmem, using btrfs-progs 4.10.2 or 4.11 (without --repair) and
post the results as attachments. They might reveal what issues there
are with the file system.

>4.10.0-22-generic #24-Ubuntu

I don't know what that translates into upstream wise. 4.10.18 is the
last of that series. I would try 4.11.3, since it's the most current.
And if that doesn't work then I'd try 4.9.30 or something relatively
recent in that series, just because it's a long term and shouldn't
have any major new features causing this if it's a regression.


-- 
Chris Murphy
