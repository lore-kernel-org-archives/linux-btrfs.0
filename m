Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:45371 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbaBKRgs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 12:36:48 -0500
Received: by mail-qc0-f179.google.com with SMTP id e16so13695200qcx.10
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 09:36:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0812CEB3-ACEC-4582-BD86-18B7F6A3F74D@colorremedies.com>
References: <20140209224055.3175e70f@system>
	<191C3349-9491-44B6-8289-C5B1EDF1F59E@colorremedies.com>
	<20140211041527.57ef96c4@system>
	<0812CEB3-ACEC-4582-BD86-18B7F6A3F74D@colorremedies.com>
Date: Tue, 11 Feb 2014 18:36:47 +0100
Message-ID: <CAJbEPe67biUB001mvFZkdKOyTOrWesgsbr+W9uonE8aBoDO64A@mail.gmail.com>
Subject: Re: BTRFS with RAID1 cannot boot when removing drive
From: Saint Germain <saintger@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11 February 2014 18:21, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Feb 10, 2014, at 8:15 PM, Saint Germain <saintger@gmail.com> wrote:
>>
>> Ok I need to really understand how my motherboard works (new Z87E-ITX).
>> It is written "64Mb AMI UEFI Legal BIOS", so I thought it was really
>> UEFI.
>
> Manufacturers have done us a disservice by equating UEFI and BIOS. Some UEFI also have a compatibility support module (CSM) which presents a BIOS to the operating system. It's intended for legacy operating systems that won't ever directly support UEFI.
>
> A way to tell in linux if you're booting with or without the CSM is issue the efibootmgr command. If it return something that looks like an error message, the CSM is enabled and the OS thinks it's running on a BIOS computer. If it returns some numbered list then the CSM isn't enabled and the OS thinks it's running on a UEFI computer.
>

Nice trick ! Thanks.

>> /dev/sdb has the same partition as /dev/sda.
>
> grub-install <device> shouldn't work on UEFI because the only place grub-install installs is to the volume mounted at /boot/efi. And also grub-install /dev/sdb implies installing grub to a disk boot sector, which also isn't applicable to UEFI.
>

I am still not up to date on UEFI partition and so.
But I have read these pages:
http://tanguy.ortolo.eu/blog/article51/debian-efi
http://forums.debian.net/viewtopic.php?f=16&t=81120
And apparently is grub-install <device> is the correct command (but
you have to copy file in addition).
It is maybe because they use a special package grub-efi-amd64, which
replace the grub-install.
It is quite difficult to find reliable info on the topic...

>
>> I understand. Normally the swap will only be used for hibernating. I
>> don't expect to use it except perhaps in some extreme case.
>
> I consider hibernate fundamentally broken right now because whether it'll work depends on too many things. It works for some people and not others, and for those it does work it largely didn't work out of the box. It never worked for me and did induce Btrfs corruptions so I've just given up on hibernate entirely. There's a long old Fedora thread that discusses myriad issues about it: https://bugzilla.redhat.com/show_bug.cgi?id=781749 and shows even if it's working, it can stop working without warning after X number of hibernate-resume cycles.
>

I am among the fortunate to have a working hibernate out of the box
(Debian stable) and it works reliably (even it ultimately it WILL fail
after 20-30 iterations). So I use the feature to save on electricity
cost ;-)
But yes, maybe I will get rid of the swap...

Thanks !
