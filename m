Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36519 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751307AbdHSDpe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 23:45:34 -0400
Received: by mail-wm0-f46.google.com with SMTP id t201so12209239wmt.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 20:45:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALsQ4_xqXr1+pEOETZyx7XYwhtmiXst5wXqW-d3PxyGzjVJdew@mail.gmail.com>
References: <CALsQ4_wnfHtJ+Drn3DJsQxdkX9=ZYDqH_H=hi3BxdSrnDZpqmw@mail.gmail.com>
 <CALsQ4_wZLvdqHdKa9DyjRXTmf1CV47+11-O_SqLRQJoQDT+gqQ@mail.gmail.com>
 <CAJCQCtRYxb4QdN__WcUX_Jhs=GyguwJV79pKUp4PYhC9h_H-xA@mail.gmail.com>
 <CALsQ4_xWte-vOJD-ppOPkvfHpLtu_-24KZPj2H9Tp99S7jDGcw@mail.gmail.com>
 <CAJCQCtR-+o_GA7fCfSe8Lfwp8h6FzfiSR=qz8ekc4=dy98mtiQ@mail.gmail.com>
 <CALsQ4_zTdxgfN25pkbhtXfj5EMVUbZ2=FrUHUocNxjynHhYhuA@mail.gmail.com>
 <CAJCQCtTuxjKcZqLOqQvVYZANXyke1_ZeKXF_fr8UG-5mUb=hhw@mail.gmail.com>
 <38bbcea5-882b-1637-1970-e147cb141d39@gmx.com> <CAJCQCtTGy1yw+b2ZWNdBA_OZwywzsA0efO2tCrrr02922oKoAg@mail.gmail.com>
 <CALsQ4_y=36OQPqq-o5mB4LQeui4h4qoc5QZnj0cCTBULbRX-dA@mail.gmail.com>
 <5193c358-f64b-6b1f-bc55-c9e423a1ac8c@gmx.com> <CALsQ4_yw0zbtuCbRQiUXCeft0OaukD9N=2UKM-bk36D8-8iiBQ@mail.gmail.com>
 <CAJCQCtT4v0T0Y_w5wkJ1u1zsYYeAV4XwByQdKEGQYGPHr3Q7bQ@mail.gmail.com>
 <CALsQ4_zECmJeJredhKOQYuNV+TMwQPRuDMfFHK7aQwm3v+JgLA@mail.gmail.com>
 <abf0086a-e6c0-8694-e505-2ab98e19a895@gmx.com> <CALsQ4_xqXr1+pEOETZyx7XYwhtmiXst5wXqW-d3PxyGzjVJdew@mail.gmail.com>
From: Zirconium Hacker <jared.e.vb@gmail.com>
Date: Fri, 18 Aug 2017 23:45:32 -0400
Message-ID: <CALsQ4_xPmLqpxgELo3iYQYE=cQMkO7hs384P8AxODLDGsEFWEg@mail.gmail.com>
Subject: Re: BTRFS error (device sda4): failed to read chunk tree: -5
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

THANK YOU ALL!  I just had to truncate the first 1.5 KiB of the image
file to get the offsets right (God knows why), but I could then get
the btrfs driver to recognize it, and I could MOUNT THE FILESYSTEM!
I'm going to run btrfs check on it, free some space on it, PROPERLY
remove the extra device, and then boot the system and set up both more
cloud backups and probably throw in a 500GB disk I have laying around
so I can set up snapshots.
Everyone has been very helpful, and sorry for the real issue being my
own stupidity.  :)

On Fri, Aug 18, 2017 at 10:28 PM, Zirconium Hacker <jared.e.vb@gmail.com> wrote:
> The image doesn't have a valid superblock.  I'm really confused as to
> how that could've happened.
>
> On Fri, Aug 18, 2017 at 7:21 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>> On 2017年08月19日 05:52, Zirconium Hacker wrote:
>>>
>>> Ok, so since it's clear now that I need that 5 GB device to be
>>> present... I found the image file.  But how do I get BTRFS to
>>> recognize the image as a device?
>>
>>
>> # losetup -f
>> Remember the loop*, here use /dev/loop1 as example.
>>
>> # losetup /dev/loop1 <your image>
>> # partprobe /dev/loop1
>> Then you should have /dev/loop1p1
>>
>> # btrfs dev rescan
>> If nothing wrong happened, you should be good to go.
>>
>> Thanks,
>> Qu
>>
>>
>>>  I have zero experience with
>>> multi-device systems.  Setting it up as a loop device doesn't fix
>>> mounting, and wipefs doesn't detect the BTRFS magic number, but
>>> printing some of it to console shows it does have real data.  Writing
>>> the magic number onto it (it's a copy of the original to be safe)
>>> shows in dump-super, but all other values are zero.
>>>
>>> I tried sending the above on my phone earlier but it was detected as a
>>> "virus" because it contained HTML.  Whoops.
>>>
>>> On Fri, Aug 18, 2017 at 11:00 AM, Chris Murphy <lists@colorremedies.com>
>>> wrote:
>>>>
>>>> On Fri, Aug 18, 2017 at 2:47 AM, Zirconium Hacker <jared.e.vb@gmail.com>
>>>> wrote:
>>>>
>>>>> I vaguely remember following this guide at some point:
>>>>>
>>>>> http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
>>>>> -- specifically the "Balance cannot run because the filesystem is
>>>>> full" part.  This may have broken some things?
>>>>>
>>>>
>>>> If you don't do 'btrfs device delete /dev/loop0' or if that command
>>>> does not complete, then it's possible to get into the situation you're
>>>> in.
>>>>
>>>> Have you ever mounted this file system with -o degraded?
>>>>
>>>> I'm going to guess the history is something like:
>>>> 1. enospc
>>>> 2. btrfs dev add
>>>> 3. some kind of filtered balance, which only causes data block groups
>>>> to be moved to the 2nd device
>>>> 4. 2nd device is physically removed without first 'btrfs dev del'
>>>>
>>>> Zirco's superblock very clearly says num_devices  2, so I'd expect
>>>> normal mount to always fail unless both devices are present. Is there
>>>> some weird edge case where Btrfs might permit non-degraded mount when
>>>> only data bg's are on a 2nd device? And then trouble only happens
>>>> later when a balance is done and it goes looking for these bg's? And
>>>> then, boom!
>>>>
>>>> --
>>>> Chris Murphy
