Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:35439 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbeISAsr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 20:48:47 -0400
Received: by mail-qt0-f194.google.com with SMTP id j7-v6so2816905qtp.2
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 12:14:47 -0700 (PDT)
Subject: Re: GRUB writing to grubenv outside of kernel fs code
To: Chris Murphy <lists@colorremedies.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
 <CAJCQCtTw9=A7BS-eZTy0rRJ1V0+=tUY5c43rvGg5ieY4EkdWZg@mail.gmail.com>
 <f0f6dfbd-bdb5-eaa7-ba7b-f6f65ceb8e87@gmail.com>
 <CAJCQCtRH+WHFXMkJ0zvftBQpg5v=qUAA7ASadivcsC39GvwexQ@mail.gmail.com>
 <eef7ba59-ba4f-c990-4556-f0317a10ffd7@gmail.com>
 <53242fa3-0d66-b7a0-ba78-5d95af54f81b@gmail.com>
 <CAJCQCtQJsYVNaWZAuMhBC6xc0VSkF-Lutz_2vzxTPb_RkfvA=Q@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <08cf5be2-9f6d-6430-7b49-0fcdbadd371b@gmail.com>
Date: Tue, 18 Sep 2018 15:14:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQJsYVNaWZAuMhBC6xc0VSkF-Lutz_2vzxTPb_RkfvA=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-09-18 15:00, Chris Murphy wrote:
> On Tue, Sep 18, 2018 at 12:25 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> 
>> It actually is independent of /boot already.  I've got it running just fine
>> on my laptop off of the EFI system partition (which is independent of my
>> /boot partition), and thus have no issues with handling of the grubenv file.
>> The problem is that all the big distros assume you want it in /boot, so they
>> have no option for putting it anywhere else.
>>
>> Actually installing it elsewhere is not hard though, you just pass
>> `--boot-directory=/wherever` to the `grub-install` script and turn off your
>> distributions automatic reinstall mechanism so it doesn't get screwed up by
>> the package manager when the GRUB package gets updated. You can also make
>> `/boot/grub` a symbolic link pointing to the real GRUB directory, so that
>> you don't have to pass any extra options to tools like grub-reboot or
>> grub-set-default.
> 
> This is how Fedora builds their signed grubx64.efi to behave. But you
> cannot ever run grub-install on a Secure Boot enabled computer, or you
> now have to learn all about signing your own binaries. I don't even
> like doing that, let alone saner users.
> 
> So for those distros that support Secure Boot, in practice you're
> stuck with the behavior of their prebuilt GRUB binary that goes on the
> ESP.
Agreed, but that avoids the issues we're talking about here completely 
because the grubenv file ends up on the ESP too.
