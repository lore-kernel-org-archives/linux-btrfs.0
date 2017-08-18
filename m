Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59461 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751059AbdHRXVN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 19:21:13 -0400
Subject: Re: BTRFS error (device sda4): failed to read chunk tree: -5
To: Zirconium Hacker <jared.e.vb@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CALsQ4_wnfHtJ+Drn3DJsQxdkX9=ZYDqH_H=hi3BxdSrnDZpqmw@mail.gmail.com>
 <CALsQ4_wZLvdqHdKa9DyjRXTmf1CV47+11-O_SqLRQJoQDT+gqQ@mail.gmail.com>
 <CAJCQCtRYxb4QdN__WcUX_Jhs=GyguwJV79pKUp4PYhC9h_H-xA@mail.gmail.com>
 <CALsQ4_xWte-vOJD-ppOPkvfHpLtu_-24KZPj2H9Tp99S7jDGcw@mail.gmail.com>
 <CAJCQCtR-+o_GA7fCfSe8Lfwp8h6FzfiSR=qz8ekc4=dy98mtiQ@mail.gmail.com>
 <CALsQ4_zTdxgfN25pkbhtXfj5EMVUbZ2=FrUHUocNxjynHhYhuA@mail.gmail.com>
 <CAJCQCtTuxjKcZqLOqQvVYZANXyke1_ZeKXF_fr8UG-5mUb=hhw@mail.gmail.com>
 <38bbcea5-882b-1637-1970-e147cb141d39@gmx.com>
 <CAJCQCtTGy1yw+b2ZWNdBA_OZwywzsA0efO2tCrrr02922oKoAg@mail.gmail.com>
 <CALsQ4_y=36OQPqq-o5mB4LQeui4h4qoc5QZnj0cCTBULbRX-dA@mail.gmail.com>
 <5193c358-f64b-6b1f-bc55-c9e423a1ac8c@gmx.com>
 <CALsQ4_yw0zbtuCbRQiUXCeft0OaukD9N=2UKM-bk36D8-8iiBQ@mail.gmail.com>
 <CAJCQCtT4v0T0Y_w5wkJ1u1zsYYeAV4XwByQdKEGQYGPHr3Q7bQ@mail.gmail.com>
 <CALsQ4_zECmJeJredhKOQYuNV+TMwQPRuDMfFHK7aQwm3v+JgLA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <abf0086a-e6c0-8694-e505-2ab98e19a895@gmx.com>
Date: Sat, 19 Aug 2017 07:21:06 +0800
MIME-Version: 1.0
In-Reply-To: <CALsQ4_zECmJeJredhKOQYuNV+TMwQPRuDMfFHK7aQwm3v+JgLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月19日 05:52, Zirconium Hacker wrote:
> Ok, so since it's clear now that I need that 5 GB device to be
> present... I found the image file.  But how do I get BTRFS to
> recognize the image as a device?

# losetup -f
Remember the loop*, here use /dev/loop1 as example.

# losetup /dev/loop1 <your image>
# partprobe /dev/loop1
Then you should have /dev/loop1p1

# btrfs dev rescan
If nothing wrong happened, you should be good to go.

Thanks,
Qu

>  I have zero experience with
> multi-device systems.  Setting it up as a loop device doesn't fix
> mounting, and wipefs doesn't detect the BTRFS magic number, but
> printing some of it to console shows it does have real data.  Writing
> the magic number onto it (it's a copy of the original to be safe)
> shows in dump-super, but all other values are zero.
> 
> I tried sending the above on my phone earlier but it was detected as a
> "virus" because it contained HTML.  Whoops.
> 
> On Fri, Aug 18, 2017 at 11:00 AM, Chris Murphy <lists@colorremedies.com> wrote:
>> On Fri, Aug 18, 2017 at 2:47 AM, Zirconium Hacker <jared.e.vb@gmail.com> wrote:
>>
>>> I vaguely remember following this guide at some point:
>>> http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
>>> -- specifically the "Balance cannot run because the filesystem is
>>> full" part.  This may have broken some things?
>>>
>>
>> If you don't do 'btrfs device delete /dev/loop0' or if that command
>> does not complete, then it's possible to get into the situation you're
>> in.
>>
>> Have you ever mounted this file system with -o degraded?
>>
>> I'm going to guess the history is something like:
>> 1. enospc
>> 2. btrfs dev add
>> 3. some kind of filtered balance, which only causes data block groups
>> to be moved to the 2nd device
>> 4. 2nd device is physically removed without first 'btrfs dev del'
>>
>> Zirco's superblock very clearly says num_devices  2, so I'd expect
>> normal mount to always fail unless both devices are present. Is there
>> some weird edge case where Btrfs might permit non-degraded mount when
>> only data bg's are on a 2nd device? And then trouble only happens
>> later when a balance is done and it goes looking for these bg's? And
>> then, boom!
>>
>> --
>> Chris Murphy
