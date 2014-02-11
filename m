Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42131 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751285AbaBKRVV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 12:21:21 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BTRFS with RAID1 cannot boot when removing drive
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140211041527.57ef96c4@system>
Date: Tue, 11 Feb 2014 10:21:17 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <0812CEB3-ACEC-4582-BD86-18B7F6A3F74D@colorremedies.com>
References: <20140209224055.3175e70f@system> <191C3349-9491-44B6-8289-C5B1EDF1F59E@colorremedies.com> <20140211041527.57ef96c4@system>
To: Saint Germain <saintger@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 10, 2014, at 8:15 PM, Saint Germain <saintger@gmail.com> wrote:
> 
> Ok I need to really understand how my motherboard works (new Z87E-ITX).
> It is written "64Mb AMI UEFI Legal BIOS", so I thought it was really
> UEFI.

Manufacturers have done us a disservice by equating UEFI and BIOS. Some UEFI also have a compatibility support module (CSM) which presents a BIOS to the operating system. It's intended for legacy operating systems that won't ever directly support UEFI.

A way to tell in linux if you're booting with or without the CSM is issue the efibootmgr command. If it return something that looks like an error message, the CSM is enabled and the OS thinks it's running on a BIOS computer. If it returns some numbered list then the CSM isn't enabled and the OS thinks it's running on a UEFI computer.

> /dev/sdb has the same partition as /dev/sda.

grub-install <device> shouldn't work on UEFI because the only place grub-install installs is to the volume mounted at /boot/efi. And also grub-install /dev/sdb implies installing grub to a disk boot sector, which also isn't applicable to UEFI.


> I understand. Normally the swap will only be used for hibernating. I
> don't expect to use it except perhaps in some extreme case.

I consider hibernate fundamentally broken right now because whether it'll work depends on too many things. It works for some people and not others, and for those it does work it largely didn't work out of the box. It never worked for me and did induce Btrfs corruptions so I've just given up on hibernate entirely. There's a long old Fedora thread that discusses myriad issues about it: https://bugzilla.redhat.com/show_bug.cgi?id=781749 and shows even if it's working, it can stop working without warning after X number of hibernate-resume cycles.

Chris Murphy