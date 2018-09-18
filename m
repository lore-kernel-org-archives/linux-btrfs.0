Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33358 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbeISAsK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 20:48:10 -0400
Received: by mail-qk1-f194.google.com with SMTP id z78-v6so1670283qka.0
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 12:14:10 -0700 (PDT)
Subject: Re: GRUB writing to grubenv outside of kernel fs code
To: Chris Murphy <lists@colorremedies.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
 <CAJCQCtTw9=A7BS-eZTy0rRJ1V0+=tUY5c43rvGg5ieY4EkdWZg@mail.gmail.com>
 <f0f6dfbd-bdb5-eaa7-ba7b-f6f65ceb8e87@gmail.com>
 <CAJCQCtRH+WHFXMkJ0zvftBQpg5v=qUAA7ASadivcsC39GvwexQ@mail.gmail.com>
 <eef7ba59-ba4f-c990-4556-f0317a10ffd7@gmail.com>
 <CAJCQCtRm-1Briye1-h7xyzT8VOK_kVOD7eJRnq1CnXA8jk9suA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a96b24fa-7384-10d0-75e9-c328f7c380b2@gmail.com>
Date: Tue, 18 Sep 2018 15:13:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRm-1Briye1-h7xyzT8VOK_kVOD7eJRnq1CnXA8jk9suA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-09-18 14:57, Chris Murphy wrote:
> On Tue, Sep 18, 2018 at 12:16 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>> 18.09.2018 08:37, Chris Murphy пишет:
> 
>>> The patches aren't upstream yet? Will they be?
>>>
>>
>> I do not know. Personally I think much easier is to make grub location
>> independent of /boot, allowing grub be installed in separate partition.
>> This automatically covers all other cases (like MD, LVM etc).
> 
> The only case where I'm aware of this happens is Fedora on UEFI where
> they write grubenv and grub.cfg on the FAT ESP. I'm pretty sure
> upstream expects grubenv and grub.cfg at /boot/grub and I haven't ever
> seen it elsewhere (except Fedora on UEFI).
> 
> I'm not sure this is much easier. Yet another volume that would be
> persistently mounted? Where? A nested mount at /boot/grub? I'm not
> liking that at all. Even Windows and macOS have saner and simpler to
> understand booting methods than this.
On this front maybe, but Windows' boot sequence is insane in it's own 
way (fun fact, if you have the Windows 8/8.1/10 boot-loader set up to 
multi-boot and want it to boot to something other than the default, it 
has to essentially _reboot the machine_ to actually boot that 
alternative entry).
