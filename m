Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f194.google.com ([209.85.213.194]:36117 "EHLO
	mail-ig0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbcDRPRX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 11:17:23 -0400
Received: by mail-ig0-f194.google.com with SMTP id kb1so11285926igb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 08:17:23 -0700 (PDT)
Subject: Re: Install to or Recover RAID Array Subvolume Root?
To: Chris Murphy <lists@colorremedies.com>
References: <CALq5X_gB0YkRMZx7Af+gAYdYRhojiKSCV9r3g8YPG6_8YR+9DQ@mail.gmail.com>
 <5714D39B.90402@gmail.com>
 <CAJCQCtRQ_1-peN6QVd53P63xQUqxfvmth4aEbwXrpaCyjVds=Q@mail.gmail.com>
Cc: David Alcorn <nroclaed@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5714FA2F.6010207@gmail.com>
Date: Mon, 18 Apr 2016 11:15:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRQ_1-peN6QVd53P63xQUqxfvmth4aEbwXrpaCyjVds=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-18 11:12, Chris Murphy wrote:
> On Mon, Apr 18, 2016 at 6:31 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2016-04-18 01:22, David Alcorn wrote:
>>>
>>>
>>> I erred and shutdown my NAS during a balance.  Grub lost track of my
>>> root.  Root was on RAID 6 array subvolid 257.  I can boot a different
>>> root from a USB flash drive but neither update-grub not install-grub
>>> sees my old root on array subvolid 257.  I am happy to either recover
>>> or lose array subvolid 257 but do not want to lose data on other array
>>> subvol's.  I prefer to have my root on the array rather than a flash
>>> drive.  The balance completed successfully after I booted from the
>>> flash drive.
>>>
>>> I am running a debian back-ported 4.4.0 kernel with btrfs-progs v4.4
>>> on both my flash drive and array subvolid 257.  Both installs are
>>> UEFI.
>>
>> It's rather refreshing to see somebody using an up to date kernel and
>> userspace for once.  The issue with GRUB is however likely an issue with
>> GRUB itself though (or possibly with something it uses for detecting
>> filesystems), which brings up the question: How recent is the version of
>> GRUB you're trying to install?  I would not be surprised if their current
>> support for BTRFS raid5 and raid6 is not particularly good, especially
>> considering that their support for BTRFS raid1 was kind of shoddy at first
>> (and it still has occasional issues, like not working right half the time if
>> one of the devices is missing).
>
> I can't tell if this setup is Btrfs on md/mdadm raid6, or if it's
> Btrfs raid6? GRUB has supported mdadm raid6 for a long time, but I
> don't think it understands Btrfs raid56 at all.
>
> The only GUI installer I know that explicitly permits installation of
> an OS to an existing Btrfs is Anaconda (mainly Red Hat and Fedora).
> There's a bug in the storage backend that prevents this from working
> in Fedora 23, exposed by a Btrfs change disallowing simultaneous use
> of subvolid and subvol, resulting in mount failure, which in turn
> causes the installer to crash. But it works in Fedora 22, and it will
> work in Fedora 24. On the other hand, no Fedora supports Btrfs for
> /boot, it has to be separate and it has to be ext4 or XFS (and maybe
> FAT).
>
I don't know about the current state of the Debian installer, but I know 
back when I used Debian regularly and used the standard text based 
installer, as long as I didn't format things from the UI, I could 
provision the filesystems however the hell I wanted manually and point 
the installer at the appropriate ones for each mount point, and it worked.
