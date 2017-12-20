Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:41428 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755867AbdLTUCw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 15:02:52 -0500
Received: by mail-oi0-f41.google.com with SMTP id t78so15407183oie.8
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 12:02:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2532cc1d-bbe4-a140-8c69-beecb2b73f79@gmail.com>
References: <5A357909.8010206@yandex.ru> <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk> <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl> <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl> <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
 <20171219175633.GA19477@polanet.pl> <CAJCQCtT+DjUDf3NBEQNxYm6SRhDL_FFXpz===fgub_k+AMmABg@mail.gmail.com>
 <2532cc1d-bbe4-a140-8c69-beecb2b73f79@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 20 Dec 2017 13:02:51 -0700
Message-ID: <CAJCQCtR5HnDSOepiv4r4=kiL1P969oSyS1fr6UGUz23ksj-OYg@mail.gmail.com>
Subject: Re: Unexpected raid1 behaviour
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Tomasz Pala <gotar@polanet.pl>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 20, 2017 at 9:53 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 19.12.2017 22:47, Chris Murphy пишет:
>>
>>>
>>> BTW, doesn't SuSE use btrfs by default? Would you expect everyone using
>>> this distro to research every component used?
>>
>> As far as I'm aware, only Btrfs single device stuff is "supported".
>> The multiple device stuff is definitely not supported on openSUSE, but
>> I have no idea to what degree they support it with enterprise license,
>> no doubt that support must come with caveats.
>>
>
> I was rather surprised seeing RAID1 and RAID10 listed as supported in
> SLES 12.x release notes, especially as there is no support for
> multi-device btrfs in YaST and hence no way to even install on such
> filesystem.

Haha. OK well I'm at a loss then. And they use systemd which is going
to run into the udev rule that prevents systemd from even attempting
to mount rootfs if one or more devices are missing. So I don't know
how it really gets supported. At the dracut prompt, manually mount
using -o degraded to /sysroot and then exit? I guess?


-- 
Chris Murphy
