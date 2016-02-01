Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34395 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbcBAX3z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 18:29:55 -0500
Received: by mail-io0-f179.google.com with SMTP id 9so97270184iom.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Feb 2016 15:29:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56AFCEC3.9050803@friedels.name>
References: <56AFCEC3.9050803@friedels.name>
Date: Mon, 1 Feb 2016 16:29:54 -0700
Message-ID: <CAJCQCtRox+q5u902iwA3YL2yvEP+9_=02HJzpZU6TWZ1R9V+Qg@mail.gmail.com>
Subject: Re: booting from BTRFS works only with one device in the pool
From: Chris Murphy <lists@colorremedies.com>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 1, 2016 at 2:31 PM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hello,
>
> I am running CentOS from a btrfs root.
> This worked fine until I added a device to that pool:
> btrfs device add /dev/sda3 /
> reboot
>
> This now causes the errors:
> BTRFS: failed to read chunk tree on sdb3
> BTRFS: open_ctree failed
>
> Here  I am stuck in a recovery prompt.
>
> btrfs fi show displays the file system correctly with 2.1GiB used for sdb3
> and 0.00GiB used on sda3
>
> btrfs-tools version reports
> btrfs-progs v4.3.1
>
> Now, I read that in case of this issue, should add the second device of the
> pool to the commandline argument of the kernel/the boot options/grub.cfg
>
> But I am not sure how to do this.
> I can mount /boot/  and the /boot/grub2/grub.cfg contains:
> insmod ext2 (but not btrfs!)

That's a bit weird. This is BIOS or UEFI system? On UEFI, the prebaked
grubx64.efi includes btrfs, so insmod isn't strictly needed. But on
BIOS it would be. I wonder if possibly this is malformed due to some
confusion on GRUBs part when it finds a multiple device btrfs volume?
But anyway, it might not be related since it sounds like the
bootloader found the kernel and the initramfs, and what's happening is
it's breaking in the initramfs.

It might be as simple as manually mounting:

btrfs dev scan
btrfs fi show  ## hopefully both devices are now associated with the volume
mount /dev/sdXY /sysroot
exit

If it mounts, you can exit to continue the startup process. And then:

dracut -f

That'll rebuild the initramfs.



> set root='hd0,msdos1'
> search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos1
> --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1 --hint='hd0,msdos1'
> 4a470ac6-f013-4e7b-a4f3-3a58cc4debc3
>
> after removing sda3 from the pool again, the system boots normally.

That's unexpected. Both devices should now refer to each other, so
either device missing should fail, it's effectively raid0 except on a
chunk level.




-- 
Chris Murphy
