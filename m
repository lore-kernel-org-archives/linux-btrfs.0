Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:46025 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755292AbdLTQ5X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 11:57:23 -0500
Received: by mail-io0-f174.google.com with SMTP id e204so18015432iof.12
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Dec 2017 08:57:23 -0800 (PST)
Subject: Re: Unexpected raid1 behaviour
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        Chris Murphy <lists@colorremedies.com>, Tomasz Pala <gotar@polanet.pl>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
 <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
 <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
 <20171219175633.GA19477@polanet.pl>
 <CAJCQCtT+DjUDf3NBEQNxYm6SRhDL_FFXpz===fgub_k+AMmABg@mail.gmail.com>
 <2532cc1d-bbe4-a140-8c69-beecb2b73f79@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e7d64a7c-d254-03c9-71e5-b98973766a20@gmail.com>
Date: Wed, 20 Dec 2017 11:57:17 -0500
MIME-Version: 1.0
In-Reply-To: <2532cc1d-bbe4-a140-8c69-beecb2b73f79@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-20 11:53, Andrei Borzenkov wrote:
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
That's the beauty of it all though, you don't need to install on such a 
setup directly like you would need to with hardware RAID, you can 
install in single-device mode and then convert the system on-line to use 
multiple devices, and that will (usually) be faster than a direct 
install if you're using replication (unless you're using RAID10 and have 
a _lot_ of disks).
