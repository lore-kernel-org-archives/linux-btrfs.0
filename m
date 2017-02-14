Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:37508 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbdBNRxB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 12:53:01 -0500
Received: by mail-it0-f43.google.com with SMTP id x75so42119323itb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Feb 2017 09:53:01 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id a22sm614154itb.29.2017.02.14.09.52.58
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Feb 2017 09:52:58 -0800 (PST)
Subject: Re: Unexpected behavior involving file attributes and snapshots.
References: <ea92c7c6-4b98-d683-eb66-593836bcc82a@gmail.com>
 <CAJCQCtQi56sVYccDPsVi8Av+FW=4SQjPpDskL0kJ-qY=P6rU1A@mail.gmail.com>
 <03288d87-0689-2cf5-0ab5-e625c97880dd@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <30e8de70-df75-2dda-8e3e-bfde998eaf9e@gmail.com>
Date: Tue, 14 Feb 2017 12:52:55 -0500
MIME-Version: 1.0
In-Reply-To: <03288d87-0689-2cf5-0ab5-e625c97880dd@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-14 11:46, Austin S. Hemmelgarn wrote:
> On 2017-02-14 11:07, Chris Murphy wrote:
>> On Tue, Feb 14, 2017 at 8:30 AM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>> I was just experimenting with snapshots on 4.9.0, and came across some
>>> unexpected behavior.
>>>
>>> The simple explanation is that if you snapshot a subvolume, any files
>>> in the
>>> subvolume that have the NOCOW attribute will not have that attribute
>>> in the
>>> snapshot.  Some further testing indicates that this is the only file
>>> attribute that isn't preserved (I checked all the chattr flags that
>>> BTRFS
>>> supports).
>>
>> Huh, I can't reproduce this with 4.9.8 or 4.10rc7. systemd sets
>> journal files with chattr +C, and I do manual snapshots of rootfs
>> periodically, and those snapshots have journal files that have +C
>> still set.
>>
> Just tested on a different filesystem, and I'm not seeing it there
> either, I'll take a closer look at the FS I saw this on and see if I can
> figure out what's up.
>
After poking around a bit further, the system crashed, and it looks like 
there was some memory corruption scattered throughout the kernel from 
one of the other modules I had loaded (now I get to spend a day or more 
figuring out which one and reporting that bug).  Given the state of the 
kernel crash dump though, I'm actually somewhat surprised that things 
weren't misbehaving more spectacularly than this.
