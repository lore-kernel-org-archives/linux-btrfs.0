Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:42089 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1756052AbcILDd6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 23:33:58 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bjI0I-0007Ln-JF
        for linux-btrfs@vger.kernel.org; Mon, 12 Sep 2016 05:33:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Small fs
Date: Mon, 12 Sep 2016 03:33:47 +0000 (UTC)
Message-ID: <pan$10305$d0b1bd23$a49643ee$465d6f6c@cox.net>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
        <5440522.9CHaGU5Wjs@merkaba>
        <pan$238e8$d4dacca2$71255eb4$9f2e5ec1@cox.net>
        <CAK5rZE6X_m6wyTmqRZ8B3TTZsXtEtPT5TaanFfgXKycJoBfsTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Imran Geriskovan posted on Sun, 11 Sep 2016 21:56:07 +0300 as excerpted:

> On 9/11/16, Duncan <1i5t5.duncan@cox.net> wrote:
>> Martin Steigerwald posted on Sun, 11 Sep 2016 17:32:44 +0200 as
>> excerpted:
>>>> What is the smallest recommended fs size for btrfs?
>>>> Can we say size should be in multiples of 64MB?
>>> Do you want to know the smalled *recommended* or the smallest
>>> *possible*
>>> size?
> 
> In fact both.
> I'm reconsidering my options for /boot

>> [Snip my detail points, leaving just the summary...]
 
>> So of my 256 MiB btrfs mixed-mode /boot, 31+4=35 MiB is overhead,
>> leaving 221 MiB for actual data and metadata.  But due to dup mode
>> that's halved, to 110.5 MiB usable space.
> 
> That's quite an info.. Thanks a lot..
> 
> Just to note again:
> Ordinary 127MB btrfs gives "Out of space" around 64MB payload. 128MB is
> usable to the end.

Thanks, and just to clarify for others possibly following along or 
googling it up later, that's single mode (as opposed to dup mode) for at 
least data, if in normal separate data/metadata mode, and single for the 
combined mixed-mode chunks if in mixed-bg mode, correct?

Because if the data is dup mode as well, as it would be by default in 
mixed-bg mode (unless on ssd), 128 MiB should allow storing only 64 MiB 
(and that's not accounting for the system chunk or global reserve 
metadata, so it'd be less than that) data.

> I'm experimenting with an extracted (and customized) initrd on /boot.
> That is, /boot is a "minimal root on its own" which can switch to real
> root or do other things. Kernel and modules at /boot will not support
> any fs other than btrfs. (Or it may)
> 
> It seems a minimally usable root around 10MB is possible.
> And it is free of udev and systemd..

You don't specifically mention the distro, but given that gentoo's one of 
the only general-purpose distros that hasn't switched to systemd yet (tho 
it offers the choice for those who want it, and I've taken that choice 
here), there's a fair chance that's what you're running, as both I and 
Martin Steigerwald (based on earlier threads) are.

FWIW, a bit more about my /boot (and kernel/initr*) layout, then, since 
it may be apropos... both because you're dealing with /boot, and because 
you might be on gentoo, as well, in which case you may find even more 
useful hints in the below.  Of course you can set it up how you like, but 
this is what I've found works very well for me. =:^)

1) Since I custom-configure and build my own kernels anyway, I build 
monolithic, no kernel modules, and indeed, the kernel options allowing 
loading modules are turned off -- more secure that way since I don't load 
modules anyway.

That simplifies a lot of stuff, including no longer needing module-init-
tools or whatever installed at all.  So it's not. (I negated the @system 
listing for it; actually I negated @system entirely and added what I 
actually needed to my @world via world-sets, but that's beside the point.)

2) Since a multi-device btrfs / effectively requires an initr*, I do run 
one, using dracut to generate it, but I don't boot it as a separate 
file.  Instead I have the kernel configured to pull it in and append it 
as an initramfs to each built kernel.

The idea here is that I keep tested-bootable kernels along with their 
tested-bootable initr*s around, so whatever I may be upgrading, kernel, 
dracut, the initr* itself, or some package with a binary in the initr*, I 
always have a fallback kernel and its attached initramfs that's tested 
bootable.  That way, should some kernel/initr* component fail, I know I 
can simply pick an older/tested kernel/initramfs file, since they're a 
single file, and boot with it, using that boot to investigate and fix the 
problem with the kernel/initramfs.  And I also know that once I've tested 
a kernel/initramfs to work, if it suddenly fails, it can't be something 
in the initramfs or kernel itself, as that is known to work, it must 
instead be some problem with the hardware or in the boot after handover 
to the main /.

One additional detail here regarding dracut:  Even if you've configured 
dracut to not worry about modules as you run a monolithic kernel, for 
some reason (bug?) it still requires (as opposed to uses if installed) 
rmmod for an initr* build.  Why it requires rmmod but not modprobe is 
beyond me, but it does.  So now I have a no-rmmod.patch in
/etc/portage/patches/sys-kernel/dracut , and I can use dracut setup for a 
monolithic kernel initr*, without having to have the useless rmmod from 
module-init-tools around for it to pull in when I build a new initr*.

3) Due to btrfs dup-mode halving my usable space on /boot, something I 
should have anticipated but didn't, I have only ~110 MiB of space on /
boot, and the grub2 installation eats up some of it.  Of course that 
leaves me way less room for kernels than I expected, particularly when I 
had the uncompressed initr* (that the kernel build compresses and appends 
as an initramfs to every built kernel) stored on /boot as well.

Eventually that crimped my style sufficiently that I moved the 
uncompressed initr* elsewhere.  I ended up with it on /p, my packages/
build partition, which has the kernel sources on it too, so it'd need to 
be mounted to build the kernel anyway.  Without the uncompressed initr* 
on /boot, the 256 MiB btrfs dup-mode, thus ~110 MiB usable, has been fine 
-- I don't find myself running out of space for new kernel builds as much 
any more, making it much easier to git-bisect a kernel bug, for instance. 
=:^)

So if you're going to do an uncompressed initr* on /boot, if you're using 
btrfs in mixed-bg dup mode as I am, better make it 384 MiB or even 512 
MiB, because 256 MiB will definitely crimp your style.  If OTOH you're 
using single mode data, presumably because you're doing mixed-mode but 
only single (I still wouldn't recommend non-mixed-mode at that size), 256 
MiB ends up being much more reasonable.

4) I use gpt partition tables on everything.  They're far more flexible 
and reliable than the old MBR, and because they have a checksummed second 
copy at the end of the device as well, they're far easier to recover if 
the primary copy gets corrupted (plus with the checksumming the 
corruption is actually detected).

In gpt, I actually setup both an EFI partition and a legacy BIOS 
partition.  They're both very small and it increases your flexibility 
dramatically.  As it happens, my current main system was purchased just a 
bit before EFI replaced BIOS, and I have grub2 installed to the legacy 
BIOS area and the EFI unused, but both are available should that change 
and I decide to use EFI booting.  (I may not, it sounds like more trouble 
than it's worth for those building their own grub, etc, but the 
flexibility is there should I decide to use it.)

5) The BIOS does have a hotkey to select the boot device, however, and I 
keep a backup /boot installed to the other ssd (primary backup) and to 
the spinning rust (secondary backup), just in case.

That allows me to upgrade grub without worrying about killing bootability 
due to a corrupted grub install.  I upgrade the package, then install it 
to one device first, then test booting to it before trying to install to 
the backups.

6) In ordered to facilitate installing grub2 to the backups as well as my 
working /boot, /boot itself is actually a symlink.  By default, it points 
to /bt, the mountpoint for my working /boot.  That way I can tell grub2 
to install to /dev/sda, and it installs grub2-core to the dedicated BIOS 
boot partition on that device, while installing the various other grub 
files to the /boot, which is pointed at the mounted /bt.

When I want to install grub2 to a backup, I point the /boot symlink at 
/bk/bt, the back-boot mountpoint, instead.  Then with the appropriate 
backup boot mounted, I can install grub2 to either sdb or sdc as 
appropriate, and again have it install both grub-core to the appropriate 
device's dedicated BIOS boot partition, and the various grub files to /
boot, which is now pointing at /bk/bt, which is where the backup /boot 
for the appropriate device is mounted.

Because it's far easier and easier to keep track of without getting 
confused, to simply switch the symlink pointer and keep the backup /boots 
mounting in the backup location, than it would be to switch the 
mountpoints themselves around.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

