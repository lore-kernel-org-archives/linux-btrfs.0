Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f49.google.com ([209.85.167.49]:39559 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbeISKqP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 06:46:15 -0400
Received: by mail-lf1-f49.google.com with SMTP id v77-v6so3937609lfa.6
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 22:10:04 -0700 (PDT)
Subject: Re: GRUB writing to grubenv outside of kernel fs code
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
 <CAJCQCtTw9=A7BS-eZTy0rRJ1V0+=tUY5c43rvGg5ieY4EkdWZg@mail.gmail.com>
 <f0f6dfbd-bdb5-eaa7-ba7b-f6f65ceb8e87@gmail.com>
 <CAJCQCtRH+WHFXMkJ0zvftBQpg5v=qUAA7ASadivcsC39GvwexQ@mail.gmail.com>
 <eef7ba59-ba4f-c990-4556-f0317a10ffd7@gmail.com>
 <53242fa3-0d66-b7a0-ba78-5d95af54f81b@gmail.com>
 <55ee4d00-86ca-da77-8fe3-007010a89fca@gmail.com>
 <26da8df8-45c9-f8e1-897c-8940898a4efd@gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <01eb4643-4bf6-1064-56be-4e6d84bc7b17@gmail.com>
Date: Wed, 19 Sep 2018 08:10:02 +0300
MIME-Version: 1.0
In-Reply-To: <26da8df8-45c9-f8e1-897c-8940898a4efd@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

18.09.2018 22:11, Austin S. Hemmelgarn пишет:
> On 2018-09-18 14:38, Andrei Borzenkov wrote:
>> 18.09.2018 21:25, Austin S. Hemmelgarn пишет:
>>> On 2018-09-18 14:16, Andrei Borzenkov wrote:
>>>> 18.09.2018 08:37, Chris Murphy пишет:
>>>>> On Mon, Sep 17, 2018 at 11:24 PM, Andrei Borzenkov
>>>>> <arvidjaar@gmail.com> wrote:
>>>>>> 18.09.2018 07:21, Chris Murphy пишет:
>>>>>>> On Mon, Sep 17, 2018 at 9:44 PM, Chris Murphy
>>>>>>> <lists@colorremedies.com> wrote:
>> ...
>>>>>>>
>>>>>>> There are a couple of reserve locations in Btrfs at the start and I
>>>>>>> think after the first superblock, for bootloader embedding. Possibly
>>>>>>> one or both of those areas could be used for this so it's outside
>>>>>>> the
>>>>>>> file system. But other implementations are going to run into this
>>>>>>> problem too.
>>>>>>>
>>>>>>
>>>>>> That's what SUSE grub2 version does - it includes patches to redirect
>>>>>> writes on btrfs to reserved area. I am not sure how it behaves in
>>>>>> case
>>>>>> of multi-device btrfs though.
>>>>>
>>>>> The patches aren't upstream yet? Will they be?
>>>>>
>>>>
>>>> I do not know. Personally I think much easier is to make grub location
>>>> independent of /boot, allowing grub be installed in separate partition.
>>>> This automatically covers all other cases (like MD, LVM etc).
>>> It actually is independent of /boot already.  I've got it running just
>>> fine on my laptop off of the EFI system partition (which is independent
>>> of my /boot partition), and thus have no issues with handling of the
>>> grubenv file.  The problem is that all the big distros assume you want
>>> it in /boot, so they have no option for putting it anywhere else.
>>>
>>
>> This requires more than just explicit --boot-directory. With current
>> monolithic configuration file listing all available kernels this file
>> cannot be in the same location, it must be together with kernels (think
>> about rollback to snapshot with completely different content). Or some
>> different, more flexible configuration is needed.
> Uh, no, it doesn't need to be with the kernels.

It does not need to be *with* kernels but it must match content of /boot
if you want to allow booting from multiple subvolumes (or even
partitions) using the same grub instance. The most obvious case is
snapper rollback used by SUSE. You still have single instance of
bootloader, but multiple subvolumes with different kernels. So somehow
bootloader must know which kernels to offer depending on which subvolume
you select.
