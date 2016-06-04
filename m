Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:38002 "EHLO
	mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbcFDRiZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jun 2016 13:38:25 -0400
Received: by mail-it0-f54.google.com with SMTP id i65so7302417ith.1
        for <linux-btrfs@vger.kernel.org>; Sat, 04 Jun 2016 10:38:24 -0700 (PDT)
Received: from [169.254.77.254] ([70.51.159.130])
        by smtp.gmail.com with ESMTPSA id d74sm2316680ith.13.2016.06.04.10.31.06
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sat, 04 Jun 2016 10:31:06 -0700 (PDT)
Message-ID: <5753105A.1030404@gmail.com>
Date: Sat, 04 Jun 2016 13:31:06 -0400
From: "B. S." <bs27975@gmail.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Pointers to mirroring partitions (w/ encryption?) help?
References: <5751E8D2.7070001@gmail.com> <CAKZK7uyRSUBp3J=HunPbmFVzLzzH1=QghOD2_p-5+UpyMXuGGg@mail.gmail.com> <5752873C.8050105@gmail.com>
In-Reply-To: <5752873C.8050105@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 06/04/2016 03:46 AM, Andrei Borzenkov wrote:
> 04.06.2016 04:39, Justin Brown пишет:
>> Here's some thoughts:
>>
>>> Assume a CD sized (680MB) /boot
>>
>> Some distros carry patches for grub that allow booting from Btrfs,
>> so no separate /boot file system is required. (Fedora does not;
>> Ubuntu -- and therefore probably all Debians -- does.)
>>
>
> Which grub (or which Fedora) do you mean? btrfs support is upstream
> since 2010.
>
> There are restrictions, in particular RAID levels support (RAID5/6 are
> not implemented).

Good to know / be reminded of (such specifics) - thanks.

>>> perhaps a 200MB (?) sized EFI partition
>>
>> Way bigger than necessary. It should only be 1-2MiB, and IIRC 2MiB
>> might be the max UEFI allows.
>>
>
> You may want to review recent discussion on systemd regarding systemd
> boot (a.k.a. gummiboot) which wants to have ESP mounted as /boot.
>
> UEFI mandates support for FAT32 on ESP so max size should be whatever
> max size FAT32 has.
> ...
>>
>>> The additional problem is most articles reference FDE (Full Disk
>>> Encryption) - but that doesn't seem to be prudent. e.g. Unencrypted
>>> /boot. So having problems finding concise links on the topics, -FDE
>>> -"Full Disk Encryption".
>>
>> Yeah, when it comes to FDE, you either have to make your peace with
>> trusting the manufacturer, or you can't. If you are going to boot
>> your system with a traditional boot loader, an unencrypted partition
>> is mandatory.
>
> No, it is not with grub2 that supports LUKS (and geli in *BSD world). Of
> course initial grub image must be written outside of encrypted area and
> readable by firmware.

Good to know. Do you have a link to a how to on such?

>> That being said, we live in a world with UEFI Secure
>> Boot. While your EFI parition must be unencrypted vfat, you can sign
>> the kernels (or shims), and the UEFI can be configured to only boot
>> signed executables, including only those signed by your own key. Some
>> distros already provide this feature, including using keys probably
>> already trusted by the default keystore.
>>
>
> UEFI Secure Boot is rather orthogonal to the question of disk encryption.

Perhaps, but not orthogonal to the OP question.

In the end, the OP is about all this 'stuff' landing at once, the 
majority btrfs centric, and a call for help finding the end of the 
string to pull on in a linear way. e.g., as pointed out, most articles 
premising FDE, which is not in play per OP. The OP requesting pointers 
to good concise how to links.
