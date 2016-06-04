Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:34958 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbcFDHqM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jun 2016 03:46:12 -0400
Received: by mail-lf0-f44.google.com with SMTP id w16so67138100lfd.2
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jun 2016 00:46:11 -0700 (PDT)
Subject: Re: Pointers to mirroring partitions (w/ encryption?) help?
To: Justin Brown <justin.brown@fandingo.org>, "B. S." <bs27975@gmail.com>
References: <5751E8D2.7070001@gmail.com>
 <CAKZK7uyRSUBp3J=HunPbmFVzLzzH1=QghOD2_p-5+UpyMXuGGg@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <5752873C.8050105@gmail.com>
Date: Sat, 4 Jun 2016 10:46:04 +0300
MIME-Version: 1.0
In-Reply-To: <CAKZK7uyRSUBp3J=HunPbmFVzLzzH1=QghOD2_p-5+UpyMXuGGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

04.06.2016 04:39, Justin Brown пишет:
> Here's some thoughts:
> 
>> Assume a CD sized (680MB) /boot
> 
> Some distros carry patches for grub that allow booting from Btrfs,
> so no separate /boot file system is required. (Fedora does not;
> Ubuntu -- and therefore probably all Debians -- does.)
> 

Which grub (or which Fedora) do you mean? btrfs support is upstream
since 2010.

There are restrictions, in particular RAID levels support (RAID5/6 are
not implemented).

>> perhaps a 200MB (?) sized EFI partition
> 
> Way bigger than necessary. It should only be 1-2MiB, and IIRC 2MiB 
> might be the max UEFI allows.
> 

You may want to review recent discussion on systemd regarding systemd
boot (a.k.a. gummiboot) which wants to have ESP mounted as /boot.

UEFI mandates support for FAT32 on ESP so max size should be whatever
max size FAT32 has.

...
> 
>> The additional problem is most articles reference FDE (Full Disk
>> Encryption) - but that doesn't seem to be prudent. e.g. Unencrypted
>> /boot. So having problems finding concise links on the topics, -FDE
>> -"Full Disk Encryption".
> 
> Yeah, when it comes to FDE, you either have to make your peace with 
> trusting the manufacturer, or you can't. If you are going to boot
> your system with a traditional boot loader, an unencrypted partition
> is mandatory.

No, it is not with grub2 that supports LUKS (and geli in *BSD world). Of
course initial grub image must be written outside of encrypted area and
readable by firmware.

> That being said, we live in a world with UEFI Secure
> Boot. While your EFI parition must be unencrypted vfat, you can sign
> the kernels (or shims), and the UEFI can be configured to only boot
> signed executables, including only those signed by your own key. Some
> distros already provide this feature, including using keys probably
> already trusted by the default keystore.
> 

UEFI Secure Boot is rather orthogonal to the question of disk encryption.

