Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52014 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbeISKmU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 06:42:20 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1g2Uec-0003O7-Hx
        for linux-btrfs@vger.kernel.org; Wed, 19 Sep 2018 07:03:58 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: GRUB writing to grubenv outside of kernel fs code
Date: Wed, 19 Sep 2018 05:03:52 +0000 (UTC)
Message-ID: <pan$302f2$2439c3c$6b63fa14$11d7e448@cox.net>
References: <CAJCQCtRyY=_qPTkBkMCs9HCNMvEHJCeFJ_=eCK_BGKgWLHotXA@mail.gmail.com>
        <CAJCQCtTw9=A7BS-eZTy0rRJ1V0+=tUY5c43rvGg5ieY4EkdWZg@mail.gmail.com>
        <406ded26-bcef-ce8c-36e4-1b25bbb36768@libero.it>
        <CAJCQCtRsox-QC2xkmpuTynHM6+MjQHCff2bEy3659FNQ5YN1oA@mail.gmail.com>
        <5bf40cee-ca21-da82-c522-69766241d735@inwind.it>
        <CAJCQCtRQJ1_tNF2__RRO2qD0=34PT_rpT+EzUQ=i9orp9qUj8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 18 Sep 2018 13:34:14 -0600 as excerpted:

> I've run into some issue where grub2-mkconfig and grubby, can change the
> grub.cfg, and then do a really fast reboot without cleanly unmounting
> the volume - and what happens? Can't boot. The bootloader can't do log
> replay so it doesn't see the new grub.cfg at all. If all you do is mount
> the volume and unmount, log replay happens, the fs metadata is all fixed
> up just fine, and now the bootloader can see it.
> This same problem can happen with the kernel and initramfs
> installations.
> 
> (Hilariously the reason why this can happen is because of a process
> exempting itself from being forcibly killed by systemd *against* the
> documented advice of systemd devs that you should only do this for
> processes not on rootfs; but as a consequence of this process doing the
> wrong thing, systemd at reboot time ends up doing an unclean unmount and
> reboot because it won't kill the kill exempt process.)

That's... interesting!

FWIW here I use grub2, but as many admins I'm quite comfortable with 
bash, and the high-level grub2 config mechanisms simply didn't let me do 
what I needed to do.  So I had to learn the lower-level grub bash-like 
scripting language to do what I wanted to do, and I even go so far as to 
install-mask some of the higher level stuff so it doesn't get installed 
at all, and thus can't somehow run and screw up my config.

So I edit my grub scripts (and grubenv) much like I'd edit any other 
system script (and its separate config file where I have them) I might 
need to update, then save my work, and with both a bios-boot partition 
setup for grub-core and an entirely separate /boot that's not routinely 
mounted unless I'm updating it, I normally unmount it when I'm done, 
before I actually reboot.

So I've never had systemd interfere.

(And of course I have backups.  In fact, on my main personal system, with 
both the working root and its primary backup being btrfs pair-device 
raid1 on separate devices, I have four physical ssds installed, with a 
bios-boot partition with grub installed and a separate dedicated (btrfs 
dup mode) /boot on each of all four, so I have a working grub and /boot 
and three backups, each of which I can point the bios at and have tested 
separately as bootable.  So if upgrading grub or anything on /boot goes 
wrong I find that out testing the working copy, and boot one of the 
backups to resolve the problem before eventually upgrading all three 
backups after the working copy upgrade is well tested.)

> So *already* we have file systems that are becoming too complicated for
> the bootloader to reliably read, because they cannot do journal relay,
> let alone have any chance of modifying (nor would I want them to do
> this). So yeah I'm, very rapidly becoming opposed to grubenv on anything
> but super simple volumes like maybe ext4 without a journal (extents are
> nice); or even perhaps GRUB should just implement its own damn file
> system and we give it its own partition - similar to BIOS Boot - but
> probably a little bigger

You realize that solution is already standardized as EFI and its standard 
FAT filesystem, right?

=:^)

>>> but is the bootloader overwrite of gruvenv going to recompute parity
>>> and write to multiple devices? Eek!
>>
>> Recompute the parity should not be a big deal. Updating all the
>> (b)trees would be a too complex goal.
> 
> I think it's just asking for trouble. Sometimes the best answer ends up
> being no, no and definitely no.

Agreed.  I actually /like/ the fact that at the grub prompt I can rely on 
everything being read-only, and if that SuSE patch to put grubenv in the 
reserved space and make it writable gets upstreamed, I really hope 
there's a build-time configure option to disable the feature, because IMO 
grub doesn't /need/ to save state at that point, and allowing it to do so 
is effectively needlessly playing a risky Russian Roulette game with my 
storage devices.  Were it actually needed that'd be different, but it's 
not needed, so any risk is too much risk.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
