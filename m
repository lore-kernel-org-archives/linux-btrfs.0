Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34094 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750723AbdEBOTf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 May 2017 10:19:35 -0400
Received: by mail-qk0-f180.google.com with SMTP id r189so17723982qkf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 02 May 2017 07:19:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170502135820.2ft7bsoceeqhnbqf@angband.pl>
References: <1e2e2e5c-5ee8-85c1-1db4-74293d8c9c1e@gmail.com> <20170502135820.2ft7bsoceeqhnbqf@angband.pl>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Tue, 2 May 2017 17:19:34 +0300
Message-ID: <CAA91j0V97dCb+j_thg0oi7B4D29VVKcqtRcpCWbgQyzi+FScKA@mail.gmail.com>
Subject: Re: Can I see what device was used to mount btrfs?
To: Adam Borowski <kilobyte@angband.pl>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 2, 2017 at 4:58 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Sun, Apr 30, 2017 at 08:47:43AM +0300, Andrei Borzenkov wrote:
>> I'm chasing issue with btrfs mounts under systemd
>> (https://github.com/systemd/systemd/issues/5781) - to summarize, systemd
>> waits for the final device that makes btrfs complete and mounts it using
>> this device name.
>
> Systemd is wrong here -- its approach can possibly work only on clean mounts;
> if you need to mount degraded it will hang forever.  Even worse, if it's not
> the root filesystem, it will "helpfully" unmount it after you mount manually
> (for root fs, it will _try_ to unmount but that obviously fails, resulting
> in nothing but some CPU wasted on trying to unmount over and over).
>
>> But in /proc/self/mountinfo we actually see another
>> device name. Due to peculiarities of systemd implementation this device
>> "does not exist" from systemd PoV.
>>
>> Looking at btrfs code I start to suspect that we actually do not know
>> what device was used to mount it at all.
>>
>> So we always show device with the smallest devid, irrespectively of what
>> device was actually used to mount it.
>
> Devices come and go (ok, it's not like you hot-remove disks every day,
> but...).  Storing the device that started the mount is pointless: btrfs
> can handle removal fine so such a stored device would point nowhere -- or
> worse, to some unrelated innocent disk you put in for data recovery (you may
> have other plans than re-provisioning that raid).
>

Yes, I understand all of this, you do not need to convince me. OTOH
the problem is real - we need to have some way to order btrfs mounts
during bootup. In the past it was solved by delays. Systemd tries to
eliminate ad hoc delays ... which is by itself not bad. So what can be
utilized from btrfs side to implement ordering? We need /something/ to
wait for. It could be virtual device that represents btrfs RAID and
have state online/offline (similar to Linux MD). It could be some
daemon that waits for btrfs to become complete. Do we have something?
