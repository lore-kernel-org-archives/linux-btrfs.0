Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f51.google.com ([209.85.167.51]:45704 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbeISBIU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 21:08:20 -0400
Received: by mail-lf1-f51.google.com with SMTP id r4-v6so2925075lff.12
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 12:34:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5bf40cee-ca21-da82-c522-69766241d735@inwind.it>
References: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
 <CAJCQCtTw9=A7BS-eZTy0rRJ1V0+=tUY5c43rvGg5ieY4EkdWZg@mail.gmail.com>
 <406ded26-bcef-ce8c-36e4-1b25bbb36768@libero.it> <CAJCQCtRsox-QC2xkmpuTynHM6+MjQHCff2bEy3659FNQ5YN1oA@mail.gmail.com>
 <5bf40cee-ca21-da82-c522-69766241d735@inwind.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 18 Sep 2018 13:34:14 -0600
Message-ID: <CAJCQCtRQJ1_tNF2__RRO2qD0=34PT_rpT+EzUQ=i9orp9qUj8A@mail.gmail.com>
Subject: Re: GRUB writing to grubenv outside of kernel fs code
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 18, 2018 at 1:11 PM, Goffredo Baroncelli <kreijack@inwind.it> wrote:


>> I think it's a problem, and near as I can tell it'll be a problem for
>> all kinds of complex storage. I don't see how the bootloader itself
>> can do an overwrite onto raid5 or raid6.
>
>
>> That's certainly supported by GRUB for reading
> Not yet, I am working on that [1]


Sorry! I meant mdadm raid56. It definitely can read that format for
some time and even degraded! It's pretty cool. But I see no way that
it's sane to have the bootloader write to such a volume.

I've run into some issue where grub2-mkconfig and grubby, can change
the grub.cfg, and then do a really fast reboot without cleanly
unmounting the volume - and what happens? Can't boot. The bootloader
can't do log replay so it doesn't see the new grub.cfg at all. If all
you do is mount the volume and unmount, log replay happens, the fs
metadata is all fixed up just fine, and now the bootloader can see it.
This same problem can happen with the kernel and initramfs
installations.

(Hilariously the reason why this can happen is because of a process
exempting itself from being forcibly killed by systemd *against* the
documented advice of systemd devs that you should only do this for
processes not on rootfs; but as a consequence of this process doing
the wrong thing, systemd at reboot time ends up doing an unclean
unmount and reboot because it won't kill the kill exempt process.)

So *already* we have file systems that are becoming too complicated
for the bootloader to reliably read, because they cannot do journal
relay, let alone have any chance of modifying (nor would I want them
to do this). So yeah I'm, very rapidly becoming opposed to grubenv on
anything but super simple volumes like maybe ext4 without a journal
(extents are nice); or even perhaps GRUB should just implement its own
damn file system and we give it its own partition - similar to BIOS
Boot - but probably a little bigger


>
>> but is the bootloader overwrite of gruvenv going to
>> recompute parity and write to multiple devices? Eek!
>
> Recompute the parity should not be a big deal. Updating all the (b)trees would be a too complex goal.

I think it's just asking for trouble. Sometimes the best answer ends
up being no, no and definitely no.

-- 
Chris Murphy
