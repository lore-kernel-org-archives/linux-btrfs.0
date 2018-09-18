Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f179.google.com ([209.85.208.179]:46474 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbeISAbR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 20:31:17 -0400
Received: by mail-lj1-f179.google.com with SMTP id 203-v6so2725696ljj.13
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 11:57:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <eef7ba59-ba4f-c990-4556-f0317a10ffd7@gmail.com>
References: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
 <CAJCQCtTw9=A7BS-eZTy0rRJ1V0+=tUY5c43rvGg5ieY4EkdWZg@mail.gmail.com>
 <f0f6dfbd-bdb5-eaa7-ba7b-f6f65ceb8e87@gmail.com> <CAJCQCtRH+WHFXMkJ0zvftBQpg5v=qUAA7ASadivcsC39GvwexQ@mail.gmail.com>
 <eef7ba59-ba4f-c990-4556-f0317a10ffd7@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 18 Sep 2018 12:57:18 -0600
Message-ID: <CAJCQCtRm-1Briye1-h7xyzT8VOK_kVOD7eJRnq1CnXA8jk9suA@mail.gmail.com>
Subject: Re: GRUB writing to grubenv outside of kernel fs code
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 18, 2018 at 12:16 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 18.09.2018 08:37, Chris Murphy пишет:

>> The patches aren't upstream yet? Will they be?
>>
>
> I do not know. Personally I think much easier is to make grub location
> independent of /boot, allowing grub be installed in separate partition.
> This automatically covers all other cases (like MD, LVM etc).

The only case where I'm aware of this happens is Fedora on UEFI where
they write grubenv and grub.cfg on the FAT ESP. I'm pretty sure
upstream expects grubenv and grub.cfg at /boot/grub and I haven't ever
seen it elsewhere (except Fedora on UEFI).

I'm not sure this is much easier. Yet another volume that would be
persistently mounted? Where? A nested mount at /boot/grub? I'm not
liking that at all. Even Windows and macOS have saner and simpler to
understand booting methods than this.


-- 
Chris Murphy
