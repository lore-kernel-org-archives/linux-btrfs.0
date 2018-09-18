Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk1-f176.google.com ([209.85.222.176]:42744 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728726AbeISAp6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 20:45:58 -0400
Received: by mail-qk1-f176.google.com with SMTP id g13-v6so1648965qki.9
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 12:11:58 -0700 (PDT)
Subject: Re: GRUB writing to grubenv outside of kernel fs code
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
 <CAJCQCtTw9=A7BS-eZTy0rRJ1V0+=tUY5c43rvGg5ieY4EkdWZg@mail.gmail.com>
 <f0f6dfbd-bdb5-eaa7-ba7b-f6f65ceb8e87@gmail.com>
 <CAJCQCtRH+WHFXMkJ0zvftBQpg5v=qUAA7ASadivcsC39GvwexQ@mail.gmail.com>
 <eef7ba59-ba4f-c990-4556-f0317a10ffd7@gmail.com>
 <53242fa3-0d66-b7a0-ba78-5d95af54f81b@gmail.com>
 <55ee4d00-86ca-da77-8fe3-007010a89fca@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <26da8df8-45c9-f8e1-897c-8940898a4efd@gmail.com>
Date: Tue, 18 Sep 2018 15:11:55 -0400
MIME-Version: 1.0
In-Reply-To: <55ee4d00-86ca-da77-8fe3-007010a89fca@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-09-18 14:38, Andrei Borzenkov wrote:
> 18.09.2018 21:25, Austin S. Hemmelgarn пишет:
>> On 2018-09-18 14:16, Andrei Borzenkov wrote:
>>> 18.09.2018 08:37, Chris Murphy пишет:
>>>> On Mon, Sep 17, 2018 at 11:24 PM, Andrei Borzenkov
>>>> <arvidjaar@gmail.com> wrote:
>>>>> 18.09.2018 07:21, Chris Murphy пишет:
>>>>>> On Mon, Sep 17, 2018 at 9:44 PM, Chris Murphy
>>>>>> <lists@colorremedies.com> wrote:
> ...
>>>>>>
>>>>>> There are a couple of reserve locations in Btrfs at the start and I
>>>>>> think after the first superblock, for bootloader embedding. Possibly
>>>>>> one or both of those areas could be used for this so it's outside the
>>>>>> file system. But other implementations are going to run into this
>>>>>> problem too.
>>>>>>
>>>>>
>>>>> That's what SUSE grub2 version does - it includes patches to redirect
>>>>> writes on btrfs to reserved area. I am not sure how it behaves in case
>>>>> of multi-device btrfs though.
>>>>
>>>> The patches aren't upstream yet? Will they be?
>>>>
>>>
>>> I do not know. Personally I think much easier is to make grub location
>>> independent of /boot, allowing grub be installed in separate partition.
>>> This automatically covers all other cases (like MD, LVM etc).
>> It actually is independent of /boot already.  I've got it running just
>> fine on my laptop off of the EFI system partition (which is independent
>> of my /boot partition), and thus have no issues with handling of the
>> grubenv file.  The problem is that all the big distros assume you want
>> it in /boot, so they have no option for putting it anywhere else.
>>
> 
> This requires more than just explicit --boot-directory. With current
> monolithic configuration file listing all available kernels this file
> cannot be in the same location, it must be together with kernels (think
> about rollback to snapshot with completely different content). Or some
> different, more flexible configuration is needed.
Uh, no, it doesn't need to be with the kernels.  Fedora stores it on the 
ESP separate from the kernels (which are still on the boot partition) if 
you use Secure Boot, and I'm doing the same (without secure boot) 
without issue.  You do have to explicitly set the `root` variable 
correctly in the config though to get it to work though, and the default 
upstream 'easy configuration' arrangement does not do this consistently. 
  It's not too hard to hack in though, and it's positively trivial if 
you just write your own configuration files by hand like I do (no, I'm 
not crazy, the default configuration generator just produces a 
brobdingnagian monstrosity of a config that has tons of stuff I don't 
need and makes invalid assumptions about how I want things invoked, and 
the config syntax is actually not that hard).
> 
> As is now grub silently assumes everything is under /boot. This turned
> out to be oversimplified.
No, it assumes everything is under whatever you told GRUB to set the 
default value of the `prefix` variable to when you built the GRUB image, 
which is automatically set to the path you pass to `--boot-directory` 
when you use grub-install.  This persists until you explicitly set that 
variable to a different location, or change the `root` variable (but 
GRUB still uses `prefix` for module look-ups if you just change the 
`root` variable).
