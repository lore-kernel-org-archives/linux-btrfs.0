Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f48.google.com ([209.85.167.48]:44474 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727660AbeISA4r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 20:56:47 -0400
Received: by mail-lf1-f48.google.com with SMTP id g24-v6so2892174lfb.11
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 12:22:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1060aa5d-e004-f6c6-bbbd-77af4f2dc859@gmail.com>
References: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
 <CAJCQCtTw9=A7BS-eZTy0rRJ1V0+=tUY5c43rvGg5ieY4EkdWZg@mail.gmail.com>
 <f0f6dfbd-bdb5-eaa7-ba7b-f6f65ceb8e87@gmail.com> <CAJCQCtRH+WHFXMkJ0zvftBQpg5v=qUAA7ASadivcsC39GvwexQ@mail.gmail.com>
 <eef7ba59-ba4f-c990-4556-f0317a10ffd7@gmail.com> <CAJCQCtRm-1Briye1-h7xyzT8VOK_kVOD7eJRnq1CnXA8jk9suA@mail.gmail.com>
 <1060aa5d-e004-f6c6-bbbd-77af4f2dc859@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 18 Sep 2018 13:22:43 -0600
Message-ID: <CAJCQCtTQ9nrJv1vuYBQ6V=-0p20bqr07PRChhBWK2C6+_-8XZw@mail.gmail.com>
Subject: Re: GRUB writing to grubenv outside of kernel fs code
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 18, 2018 at 1:01 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 18.09.2018 21:57, Chris Murphy пишет:
>> On Tue, Sep 18, 2018 at 12:16 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>>> 18.09.2018 08:37, Chris Murphy пишет:
>>
>>>> The patches aren't upstream yet? Will they be?
>>>>
>>>
>>> I do not know. Personally I think much easier is to make grub location
>>> independent of /boot, allowing grub be installed in separate partition.
>>> This automatically covers all other cases (like MD, LVM etc).
>>
>> The only case where I'm aware of this happens is Fedora on UEFI where
>> they write grubenv and grub.cfg on the FAT ESP. I'm pretty sure
>> upstream expects grubenv and grub.cfg at /boot/grub and I haven't ever
>> seen it elsewhere (except Fedora on UEFI).
>>
>> I'm not sure this is much easier. Yet another volume that would be
>> persistently mounted? Where? A nested mount at /boot/grub? I'm not
>> liking that at all. Even Windows and macOS have saner and simpler to
>> understand booting methods than this.
>>
>>
> That's exactly what Windows ended up with - separate boot volume with
> bootloader related files.

The OEM installer will absolutely install to a single partition. If
you point it to a blank drive on BIOS it will preferentially create a
"system" volume that's used for booting. But it's not mandatory. On
UEFI, it doesn't create a "system" volume, just "recovery" is ~500M
and "reserved" 16M. The reserved partition is blank unless you've done
some resizing on the main volume. The recovery volume contains
Winre.wim which is used for doing resets. If you blow away that
partition, you can still boot, but you can't do resets.

-- 
Chris Murphy
