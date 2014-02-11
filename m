Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40970 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751753AbaBKSP6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 13:15:58 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BTRFS partitioning scheme (was BTRFS with RAID1 cannot boot when removing drive)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAJbEPe6COMz0Dmj9rSOjb0wCVu-e0OR_2d8irKxgSA3N4sBB+g@mail.gmail.com>
Date: Tue, 11 Feb 2014 11:15:56 -0700
Cc: linux-btrfs@vger.kernel.org, Kyle Gates <kylegates@hotmail.com>
Message-Id: <E588F10F-919E-405C-8120-7375A2A6885B@colorremedies.com>
References: <CAJbEPe6COMz0Dmj9rSOjb0wCVu-e0OR_2d8irKxgSA3N4sBB+g@mail.gmail.com>
To: Saint Germain <saintger@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 11, 2014, at 10:02 AM, Saint Germain <saintger@gmail.com> wrote:

> Hello and thanks for your feedback !
> 
> Cc back to the mailing-list as it may be of interest here as well.
> 
> On 11 February 2014 16:11, Kyle Gates <kylegates@hotmail.com> wrote:
>>> The big problem I currently have is that based on your input, I
>>> hesitate a lot on my partitioning scheme: should I use a dedicated
>>> /boot partition or should I have one global BTRFS partition ?
>>> It is not very clear in the doc (a lof of people used a dedicated
>>> /boot because at that time, grub couldn't natively boot BTRFS it
>>> seems, but it has changed).
>>> Could you recommend a partitioning scheme for a simple RAID1 with 2
>>> identical hard drives (just for home computing, not business).
>> 
>> I run a 1GiB RAID1 btrfs /boot in mixed mode with grub2 and gpt partitions.
>> IIRC grub2 doesn't understand lzo compression nor subvolumes.

Any sufficiently recent version of GRUB2 understands both lzo, zlib. 

Grub doesn't directly understand the concept of subvolumes, but it treats them as directories, which is expected to work.

grub-mkconfig likewise is indirectly aware of subvolumes. If fstab indicates / is on Btrfs and there's a subvol= option, grub-mkconfig creates a rootflags=subvol= boot parameter in the resulting grub.cfg.


> Well I did tried to read about this and ended up being confused
> because development is so fast, documentation can become quickly
> outdated.
> It seems that grub can boot BTRFS /boot subvolumes:
> https://bbs.archlinux.org/viewtopic.php?pid=1222358

I think it's more accurate to say it can locate boot files on a subvolume by treating the subvolume as a directory. So as long as the path to those boot files is correct, it should work.

And yes it's true that distros are frequently very far behind with grub, and this poses problems. Fedora has been on grub 2.00 since release two years ago. Many other distros are still using pre-release grub2 versions 1.97 through 1.99 which isn't good. The distros should be pressured to move to grub 2.02, currently in beta, upon release. And I think it would be good for Btrfs testers to build grub 2.02 beta, and try to break it with various Btrfs configurations so that it can be better tested grub release.



> However Chris Murphy has some problems a few months ago:
> http://comments.gmane.org/gmane.comp.file-systems.btrfs/29140

The decision by Grub upstream is that Grub should always treat pathnames as starting from the top level of the file system, ID5, rather than starting from the user defined default subvolume. Otherwise, the user can instantly render their system unbootable just by changing the default subvolume.

subvol= option is intended to be read as starting from the top level of the file system regardless of the default subvolume. Probably more testing of this is needed, along with grub2, and other boot loaders.


> 
> So I still don't know if it is a good idea or not to have a BTRFS /boot ?
> Of course the idea is that I would like to snapshot /boot and have it on RAID1.

It's fine to do that, and it does work. You can also just have /boot as a directory within a root subvolume.


> 
> To summarize, I think I have 3 options for partitioning (I am not
> considering UEFI secure boot or swap):
> 1) grub, BTRFS partition (i.e. full disk in BTRFS), /boot inside BTRFS subvolume

This doesn't seem like a good idea for a boot drive to be without partitions.


> 2) grub, GPT partition, with (A) on sda1, and a BTRFS partition on
> sda2, /boot inside BTRFS subvolume
> 3) grub, GPT partition, with (A) on sda1, /boot (ext4) on sda2, and a
> BTRFS on sda3
> 
> (A) = BIOS Boot partition (1 MiB) or EFI System Partition (FAT32, 550MiB)
> 
> I don't really see the point of having UEFI/ESP if I don't use other
> proprietary operating system, so I think I will go with (A) = BIOS
> Boot partition except if there is someting I have missed.

You need to boot your system in UEFI and CSM-BIOS modes, and compare the dmesg for each. I'm finding it common the CSM limits power management, and relegates drives to IDE speeds rather than full SATA link speeds. Sometimes it's unavoidable to use the CSM if it has better overall behavior for your use case. I've found it to be lacking and have abandoned it. It's basically intended for booting Windows XP, right?

Chris Murphy