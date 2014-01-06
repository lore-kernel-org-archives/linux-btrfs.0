Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48062 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751470AbaAFS35 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 13:29:57 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1416119.lWHlh5idGF@quad>
Date: Mon, 6 Jan 2014 11:30:00 -0700
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <C7E0F781-5F46-4C76-BCC9-0DE416553046@colorremedies.com>
References: <52C73987.7000106@jrs-s.net> <52C87A41.9030701@jrs-s.net> <05C97109-682D-4A62-B074-4EDCF8E9CE1E@colorremedies.com> <1416119.lWHlh5idGF@quad>
To: Chris Samuel <chris@csamuel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 6, 2014, at 3:20 AM, Chris Samuel <chris@csamuel.org> wrote:

> On Sun, 5 Jan 2014 01:25:19 PM Chris Murphy wrote:
> 
>> Does the Ubuntu 12.03 LTS installer let you create sysroot on a Btrfs raid1
>> volume?
> 
> I doubt it, given the alpha for 14.04 doesn't seem to have the concept yet. 
> :-)
> 
> https://bugs.launchpad.net/ubuntu/+source/grub-installer/+bug/1266200

Color me surprised.

Fedora 20 lets you create Btrfs raid1/raid0 for rootfs, but due to a long standing grubby bug [1] /boot can't be on Btrfs, so it's only ext4. That means only one of your disks will get grub.cfg, and means if it dies, you won't boot without user intervention that also requires esoteric grub knowledge. 

/boot needs to be on Btrfs or it gets messy. The messy alternative, each drive has an ext4 boot partition means kernel updates have to be written to each drive, and each drives separate /boot/grub/grub.cfg needs to be updated. That's kinda ick x2.  Yes they could be made md raid1 to solve part of this.

It gets slightly more amusing on UEFI, where the installer needs to be smart enough to create (or reuse) the EFI System partition on each device [2] for the bootloader but NOT for the grub.cfg [3], otherwise we have separate grub.cfgs on each ESP to update when there are kernel updates.

And if a disk fails, and is replaced, while grub-install works on BIOS, it doesn't work on UEFI because it'll only install a bootloader if the ESP is mounted in the right location.

So until every duck is in the row, I think we can hardly point one finger when it comes to making a degrade system bootable without any human intervention.

[1] grubby fatal error updating grub.cfg when /boot is btrfs
https://bugzilla.redhat.com/show_bug.cgi?id=864198

[2] RFE: always create required bootloader partitions in custom partitioning
https://bugzilla.redhat.com/show_bug.cgi?id=1022316

[2] On EFI, grub.cfg should be in /boot/grub not /boot/efi/EFI/fedora
https://bugzilla.redhat.com/show_bug.cgi?id=1048999


Chris Murphy