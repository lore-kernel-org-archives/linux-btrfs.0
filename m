Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:45617 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753009AbeGBLtH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 07:49:07 -0400
Received: by mail-io0-f195.google.com with SMTP id l25-v6so14442964ioh.12
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jul 2018 04:49:07 -0700 (PDT)
Subject: Re: unsolvable technical issues?
To: Andrei Borzenkov <arvidjaar@gmail.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net>
 <pan$11f2c$c623d7b0$5173b25$c7594479@cox.net>
 <646f0c52-4726-7a7d-0242-4412950bf002@libero.it>
 <64876ad1-9f63-f6f0-9d55-0fa4999f0bf5@gmail.com>
 <pan$15832$609432db$876d9a8a$e5840f46@cox.net>
 <9b482289-c96f-dac3-d2e7-db6a32596334@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ea1a9c9b-7132-87f1-04fc-85b278975925@gmail.com>
Date: Mon, 2 Jul 2018 07:49:05 -0400
MIME-Version: 1.0
In-Reply-To: <9b482289-c96f-dac3-d2e7-db6a32596334@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-06-30 01:32, Andrei Borzenkov wrote:
> 30.06.2018 06:22, Duncan пишет:
>> Austin S. Hemmelgarn posted on Mon, 25 Jun 2018 07:26:41 -0400 as
>> excerpted:
>>
>>> On 2018-06-24 16:22, Goffredo Baroncelli wrote:
>>>> On 06/23/2018 07:11 AM, Duncan wrote:
>>>>> waxhead posted on Fri, 22 Jun 2018 01:13:31 +0200 as excerpted:
>>>>>
>>>>>> According to this:
>>>>>>
>>>>>> https://stratis-storage.github.io/StratisSoftwareDesign.pdf Page 4 ,
>>>>>> section 1.2
>>>>>>
>>>>>> It claims that BTRFS still have significant technical issues that may
>>>>>> never be resolved.
>>>>>
>>>>> I can speculate a bit.
>>>>>
>>>>> 1) When I see btrfs "technical issue that may never be resolved", the
>>>>> #1 first thing I think of, that AFAIK there are _definitely_ no plans
>>>>> to resolve, because it's very deeply woven into the btrfs core by now,
>>>>> is...
>>>>>
>>>>> [1)] Filesystem UUID Identification.  Btrfs takes the UU bit of
>>>>> Universally Unique quite literally, assuming they really *are*
>>>>> unique, at least on that system[.]  Because
>>>>> btrfs uses this supposedly unique ID to ID devices that belong to the
>>>>> filesystem, it can get *very* mixed up, with results possibly
>>>>> including dataloss, if it sees devices that don't actually belong to a
>>>>> filesystem with the same UUID as a mounted filesystem.
>>>>
>>>> As partial workaround you can disable udev btrfs rules and then do a
>>>> "btrfs dev scan" manually only for the device which you need.
>>
>>> You don't even need `btrfs dev scan` if you just specify the exact set
>>> of devices in the mount options.  The `device=` mount option tells the
>>> kernel to check that device during the mount process.
>>
>> Not that lvm does any better in this regard[1], but has btrfs ever solved
>> the bug where only one device= in the kernel commandline's rootflags=
>> would take effect, effectively forcing initr* on people (like me) who
>> would otherwise not need them and prefer to do without them, if they're
>> using a multi-device btrfs as root?
>>
> 
> This requires in-kernel device scanning; I doubt we will ever see it.
> 
>> Not to mention the fact that as kernel people will tell you, device
>> enumeration isn't guaranteed to be in the same order every boot, so
>> device=/dev/* can't be relied upon and shouldn't be used -- but of course
>> device=LABEL= and device=UUID= and similar won't work without userspace,
>> basically udev (if they work at all, IDK if they actually do).
>>
>> Tho in practice from what I've seen, device enumeration order tends to be
>> dependable /enough/ for at least those without enterprise-level numbers
>> of devices to enumerate.
> 
> Just boot with USB stick/eSATA drive plugged in, there are good chances
> it changes device order.
It really depends on your particular hardware.  If your USB controllers 
are at lower PCI addresses than your primary disk controllers, then yes, 
this will cause an issue.  Same for whatever SATA controller your eSATA 
port is on (or stupid systems where the eSATA port is port 0 on the main 
SATA controller).

Notably, most Intel systems I've seen have the SATA controllers in the 
chipset enumerate after the USB controllers, and the whole chipset 
enumerates after add-in cards (so they almost always have this issue), 
while most AMD systems I've seen demonstrate the exact opposite 
behavior, they enumerate the SATA controller from the chipset before the 
USB controllers, and then enumerate the chipset before all the add-in 
cards (so they almost never have this issue).

That said, one of the constraints for them remaining consistent is that 
you don't change hardware.
> 
>>   True, it /does/ change from time to time with a
>> new kernel, but anybody sane keeps a tested-dependable old kernel around
>> to boot to until they know the new one works as expected, and that sort
>> of change is seldom enough that users can boot to the old kernel and
>> adjust their settings for the new one as necessary when it does happen.
>> So as "don't do it that way because it's not reliable" as it might indeed
>> be in theory, in practice, just using an ordered /dev/* in kernel
>> commandlines does tend to "just work"... provided one is ready for the
>> occasion when that device parameter might need a bit of adjustment, of
>> course.
>>
> ...
>>
>> ---
>> [1] LVM is userspace code on top of the kernelspace devicemapper, and
>> therefore requires an initr* if root is on lvm, regardless.  So btrfs
>> actually does a bit better here, only requiring it for multi-device btrfs.
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

