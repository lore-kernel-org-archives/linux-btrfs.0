Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:41346 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751997AbdLULob (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Dec 2017 06:44:31 -0500
Received: by mail-qt0-f195.google.com with SMTP id i40so32032935qti.8
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 03:44:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <aac98fbf-c94b-1a88-f191-902146ff544f@gmail.com>
References: <5A357909.8010206@yandex.ru> <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk> <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl> <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl> <CAJCQCtSwfoSmAfFyP15xp-uysBY1kWyt65Jhf37g68YcPQ2QEA@mail.gmail.com>
 <20171219204155.GB14726@polanet.pl> <aac98fbf-c94b-1a88-f191-902146ff544f@gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Thu, 21 Dec 2017 14:44:30 +0300
Message-ID: <CAA91j0X_MZ+EjgZMNGrfChBdFed_G3oLttdpYjCOq-vERzoiKw@mail.gmail.com>
Subject: Re: Unexpected raid1 behaviour
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Tomasz Pala <gotar@polanet.pl>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 11:47 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2017-12-19 15:41, Tomasz Pala wrote:
>>
>> On Tue, Dec 19, 2017 at 12:35:20 -0700, Chris Murphy wrote:
>>
>>> with a read only file system. Another reason is the kernel code and
>>> udev rule for device "readiness" means the volume is not "ready" until
>>> all member devices are present. And while the volume is not "ready"
>>> systemd will not even attempt to mount. Solving this requires kernel
>>> and udev work, or possibly a helper, to wait an appropriate amount of
>>
>>
>> Sth like this? I got such problem a few months ago, my solution was
>> accepted upstream:
>>
>> https://github.com/systemd/systemd/commit/0e8856d25ab71764a279c2377ae593c0f2460d8f
>>
>> Rationale is in referred ticket, udev would not support any more btrfs
>> logic, so unless btrfs handles this itself on kernel level (daemon?),
>> that is all that can be done.
>
> Or maybe systemd can quit trying to treat BTRFS like a volume manager (which
> it isn't) and just try to mount the requested filesystem with the requested
> options?

You can't mount filesystem until sufficient number of devices are
present and not waiting (at least attempting to wait) for them opens
you to races on startup. So far systemd position was - it is up to
filesystem to give it something to wait on. And while apparently
everyone agrees that current "btrfs device ready" does not fit the
bill, this is the only thing we have.

This integration issue was so far silently ignored both by btrfs and
systemd developers.
