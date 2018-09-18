Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io1-f65.google.com ([209.85.166.65]:44030 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729689AbeIRX7m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 19:59:42 -0400
Received: by mail-io1-f65.google.com with SMTP id y10-v6so2361313ioa.10
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 11:25:52 -0700 (PDT)
Subject: Re: GRUB writing to grubenv outside of kernel fs code
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
 <CAJCQCtTw9=A7BS-eZTy0rRJ1V0+=tUY5c43rvGg5ieY4EkdWZg@mail.gmail.com>
 <f0f6dfbd-bdb5-eaa7-ba7b-f6f65ceb8e87@gmail.com>
 <CAJCQCtRH+WHFXMkJ0zvftBQpg5v=qUAA7ASadivcsC39GvwexQ@mail.gmail.com>
 <eef7ba59-ba4f-c990-4556-f0317a10ffd7@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <53242fa3-0d66-b7a0-ba78-5d95af54f81b@gmail.com>
Date: Tue, 18 Sep 2018 14:25:48 -0400
MIME-Version: 1.0
In-Reply-To: <eef7ba59-ba4f-c990-4556-f0317a10ffd7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-09-18 14:16, Andrei Borzenkov wrote:
> 18.09.2018 08:37, Chris Murphy пишет:
>> On Mon, Sep 17, 2018 at 11:24 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>>> 18.09.2018 07:21, Chris Murphy пишет:
>>>> On Mon, Sep 17, 2018 at 9:44 PM, Chris Murphy <lists@colorremedies.com> wrote:
>>>>> https://btrfs.wiki.kernel.org/index.php/FAQ#Does_grub_support_btrfs.3F
>>>>>
>>>>> Does anyone know if this is still a problem on Btrfs if grubenv has
>>>>> xattr +C set? In which case it should be possible to overwrite and
>>>>> there's no csums that are invalidated.
>>>>>
>>>>> I kinda wonder if in 2018 it's specious for, effectively out of tree
>>>>> code, to be making modifications to the file system, outside of the
>>>>> file system.
>>>>
>>>> a. The bootloader code (pre-boot, not user space setup stuff) would
>>>> have to know how to read xattr and refuse to overwrite a grubenv
>>>> lacking xattr +C.
>>>> b. The bootloader code, would have to have sophisticated enough Btrfs
>>>> knowledge to know if the grubenv has been reflinked or snapshot,
>>>> because even if +C, it may not be valid to overwrite, and COW must
>>>> still happen, and there's no way the code in GRUB can do full blow COW
>>>> and update a bunch of metadata.
>>>>
>>>> So answering my own question, this isn't workable. And it seems the
>>>> same problem for dm-thin.
>>>>
>>>> There are a couple of reserve locations in Btrfs at the start and I
>>>> think after the first superblock, for bootloader embedding. Possibly
>>>> one or both of those areas could be used for this so it's outside the
>>>> file system. But other implementations are going to run into this
>>>> problem too.
>>>>
>>>
>>> That's what SUSE grub2 version does - it includes patches to redirect
>>> writes on btrfs to reserved area. I am not sure how it behaves in case
>>> of multi-device btrfs though.
>>
>> The patches aren't upstream yet? Will they be?
>>
> 
> I do not know. Personally I think much easier is to make grub location
> independent of /boot, allowing grub be installed in separate partition.
> This automatically covers all other cases (like MD, LVM etc).
It actually is independent of /boot already.  I've got it running just 
fine on my laptop off of the EFI system partition (which is independent 
of my /boot partition), and thus have no issues with handling of the 
grubenv file.  The problem is that all the big distros assume you want 
it in /boot, so they have no option for putting it anywhere else.

Actually installing it elsewhere is not hard though, you just pass 
`--boot-directory=/wherever` to the `grub-install` script and turn off 
your distributions automatic reinstall mechanism so it doesn't get 
screwed up by the package manager when the GRUB package gets updated. 
You can also make `/boot/grub` a symbolic link pointing to the real GRUB 
directory, so that you don't have to pass any extra options to tools 
like grub-reboot or grub-set-default.
