Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33237 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbcFDTF6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jun 2016 15:05:58 -0400
Received: by mail-oi0-f49.google.com with SMTP id k23so173657875oih.0
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jun 2016 12:05:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKZK7uyRSUBp3J=HunPbmFVzLzzH1=QghOD2_p-5+UpyMXuGGg@mail.gmail.com>
References: <5751E8D2.7070001@gmail.com>
	<CAKZK7uyRSUBp3J=HunPbmFVzLzzH1=QghOD2_p-5+UpyMXuGGg@mail.gmail.com>
Date: Sat, 4 Jun 2016 13:05:57 -0600
Message-ID: <CAJCQCtQUBsB-w7TrSAd=+t+E=6aqyPmcUrmMWyd6sg6BuJsS4Q@mail.gmail.com>
Subject: Re: Pointers to mirroring partitions (w/ encryption?) help?
From: Chris Murphy <lists@colorremedies.com>
To: Justin Brown <justin.brown@fandingo.org>
Cc: "B. S." <bs27975@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 3, 2016 at 7:39 PM, Justin Brown <justin.brown@fandingo.org> wrote:
> Here's some thoughts:
>
>> Assume a CD sized (680MB) /boot
>
> Some distros carry patches for grub that allow booting from Btrfs

Upstream GRUB has had Btrfs support for a long time. There's been no
need for distros to carry separate patches for years. The exception is
openSUSE, where they have a healthy set of patches for supporting the
discovery of and boot of read only snapshots created by snapper. Those
patches are not merged upstream, I'm not sure if they will be.


>, so
> no separate /boot file system is required. (Fedora does not; Ubuntu --
> and therefore probably all Debians -- does.)

The problem on Fedora is that they depend on grubby to modify the
grub.cfg. And grubby gets confused when the kernel/initramfs are
located on a Btrfs subvolume other than the top level. And Fedora's
installer only installs the system onto a subvolume (specifically,
every mount point defined in the installer becomes a subvolume if you
use Btrfs). So it's stuck being unable to support /boot if it's on
Btrfs.



>
>> perhaps a 200MB (?) sized EFI partition
>
> Way bigger than necessary. It should only be 1-2MiB, and IIRC 2MiB
> might be the max UEFI allows.

You're confusing the ESP with BIOSBoot. The minimum size for 512 byte
sector drives per Microsoft's technotes is 100MiB. Most OEMs use
something between 100MiB and 300MiB. Apple creates a 200MB ESP even
though they don't use it for booting, rather just to stage firmware
updates.

The UEFI spec itself doesn't say how big the ESP should be. 200MiBi is
sane for 512 byte drives. It needs to be 260MiB minimum for 4Kn
drives, because of the minimum number of FAT allocation units at 4096
bytes each requires a 260MiB minimum volume.




>
>> The additional problem is most articles reference FDE (Full Disk Encryption) - but that doesn't seem to be prudent. e.g. Unencrypted /boot. So having problems finding concise links on the topics, -FDE -"Full Disk Encryption".
>
> Yeah, when it comes to FDE, you either have to make your peace with
> trusting the manufacturer, or you can't. If you are going to boot your
> system with a traditional boot loader, an unencrypted partition is
> mandatory.

/boot can be encrypted, GRUB supports this, but I'm unaware of any
installer that does. The ESP can't be encrypted.

http://dustymabe.com/2015/07/06/encrypting-more-boot-joins-the-party/

It's vaguely possible for the SED variety of drive to support fully
encrypted everything, including the ESP. The problem is we don't have
OPAL support on Linux at all anywhere. And for some inexplicable
reason, the TCG hasn't commissioned a free UEFI application for
managing the keys and unlocking the drive in the preboot environment.
For now, it seems, such support has to already be in the firmware.




-- 
Chris Murphy
