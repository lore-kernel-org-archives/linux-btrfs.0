Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:36525 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbcDRPMw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 11:12:52 -0400
Received: by mail-io0-f176.google.com with SMTP id u185so197577394iod.3
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 08:12:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5714D39B.90402@gmail.com>
References: <CALq5X_gB0YkRMZx7Af+gAYdYRhojiKSCV9r3g8YPG6_8YR+9DQ@mail.gmail.com>
	<5714D39B.90402@gmail.com>
Date: Mon, 18 Apr 2016 09:12:51 -0600
Message-ID: <CAJCQCtRQ_1-peN6QVd53P63xQUqxfvmth4aEbwXrpaCyjVds=Q@mail.gmail.com>
Subject: Re: Install to or Recover RAID Array Subvolume Root?
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: David Alcorn <nroclaed@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 18, 2016 at 6:31 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-04-18 01:22, David Alcorn wrote:
>>
>> Debian's default installer (1) can not create a BTRFS raid array
>> during installation, and (2) installs to the default subvol of the
>> BTRFS target.  The default subvol is 5 (BTRFS root) unless (i) prior
>> to installation a BTRFS file-system was created, (ii) the default
>> subvol is set to something other than 5, and (iii) you do not format
>> the installation target during install. This perspective benefits from
>> https://aykevl.nl/2015/11/debian-btrfs-subvolume.
>>
>> Can Debian install BTRFS to a pre-existing BTRFS RAID 6 array?  If the
>> array's default is set to ,say subvolid 257, can I install to array
>> subvolume 257?  The goal is to install to a subvolume on the array
>> without disturbing date on other array subvolumes.
>
> This is really something you should be asking on the Debian mailing list, or
> on one of their IRC channels.   That said,  based on my limited knowledge of
> the current state of the Debian installer, I think it should work, but I"m
> not certain.  I don't really use Debian much anymore except on a couple of
> Raspberry Pi's at work, so I really can't give a much better answer
> (Ironically, limitations like this in the installer are part of why I
> switched to Gentoo).
>>
>>
>> I erred and shutdown my NAS during a balance.  Grub lost track of my
>> root.  Root was on RAID 6 array subvolid 257.  I can boot a different
>> root from a USB flash drive but neither update-grub not install-grub
>> sees my old root on array subvolid 257.  I am happy to either recover
>> or lose array subvolid 257 but do not want to lose data on other array
>> subvol's.  I prefer to have my root on the array rather than a flash
>> drive.  The balance completed successfully after I booted from the
>> flash drive.
>>
>> I am running a debian back-ported 4.4.0 kernel with btrfs-progs v4.4
>> on both my flash drive and array subvolid 257.  Both installs are
>> UEFI.
>
> It's rather refreshing to see somebody using an up to date kernel and
> userspace for once.  The issue with GRUB is however likely an issue with
> GRUB itself though (or possibly with something it uses for detecting
> filesystems), which brings up the question: How recent is the version of
> GRUB you're trying to install?  I would not be surprised if their current
> support for BTRFS raid5 and raid6 is not particularly good, especially
> considering that their support for BTRFS raid1 was kind of shoddy at first
> (and it still has occasional issues, like not working right half the time if
> one of the devices is missing).

I can't tell if this setup is Btrfs on md/mdadm raid6, or if it's
Btrfs raid6? GRUB has supported mdadm raid6 for a long time, but I
don't think it understands Btrfs raid56 at all.

The only GUI installer I know that explicitly permits installation of
an OS to an existing Btrfs is Anaconda (mainly Red Hat and Fedora).
There's a bug in the storage backend that prevents this from working
in Fedora 23, exposed by a Btrfs change disallowing simultaneous use
of subvolid and subvol, resulting in mount failure, which in turn
causes the installer to crash. But it works in Fedora 22, and it will
work in Fedora 24. On the other hand, no Fedora supports Btrfs for
/boot, it has to be separate and it has to be ext4 or XFS (and maybe
FAT).



-- 
Chris Murphy
