Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:59488 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab3KHNlD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Nov 2013 08:41:03 -0500
Received: from cloud.myjm.de (37-5-161-32-dynip.superkabel.de [37.5.161.32])
	by smtp.strato.de (RZmta 32.13 DYNA|AUTH)
	with (TLSv1.2:DHE-RSA-AES256-GCM-SHA384 encrypted) ESMTPSA id m04a5apA8Df03YL
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Nov 2013 14:41:00 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 08 Nov 2013 14:41:00 +0100
From: =?UTF-8?Q?Michael_G=C3=B6hler?= <visit@myjm.de>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Question about btrfs as root filesystem
In-Reply-To: <236FCD08-8D7A-4067-9CC4-235BA129C953@colorremedies.com>
References: <5eb6a9cbd3a163b70c9cfe4a1b46a1fa@myjm.de>
 <236FCD08-8D7A-4067-9CC4-235BA129C953@colorremedies.com>
Message-ID: <7b2cdbd67793f539fb07f5c73a1509c8@myjm.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris

thanks for taking the time.

>>  The boot subvolume is then set with 'btrfs subvolume set-default' and 
>> mounted without subvol/subvolid option by Arch's default mount 
>> handler.
> 
> I'm unconvinced it's a good idea for it to be used behind the scenes
> for the described purpose. Consider the following:
> 
> 1. btrfs subvolume set-default uses a user space tool and in my view
> it's primarily a user domain behavior modifier for the mount command.
The only drawback I can imagine is that the initrd can have a different 
version of the btrfs command, as it isn't repacked on package upgrades 
of btrfs-utils. But this isn't related to set-default only, but also for 
the snapshot command. Of cause, if we find a better way to achieve our 
goal, we are willing to drop it.

> 2. It makes the actual mounted subvolume obscured, cat
> /proc/self/mountinfo doesn't show what subvolume is mounted unless
> subvol= is explicitly used in /etc/fstab.
We use btrfs subvolume get-default to check on which subvolume we are.
You are right, an average user will find it confusing. But if he does, 
he will also not look into the /proc filesystem. He will run mount 
without options to look for it, and have no luck because it isn't 
displayed there too.

> 3. Grub2 (and I'm pretty sure grubby) do not use the set-default. The
> GRUB intent for the prefix to search an absolute path, not one
> relative to the default subvolume. There's a bug that should very
> recently (week) be fixed, where GRUB fails to find prefix if
> set-default is changed. This maybe isn't affecting the particular
> layout you describe where only rootfs is on btrfs, rather than /boot
> being on its own subvolume.
Actually 2.00.5086-1 which is latest on Arch is respecting set-default 
and searches for the kernel on the default subvolume without prefix and 
rootflags. Thanks for pointing this out, so I can watch out for the next 
grub update and fix the hook accordingly.

> I'm sympathetic to the alternative problem, which is that you need to
> alter grub.cfg to use the proper rootflags=subvol= to explicitly use
> the proper snapshot, and also it would mean altering the /etc/fstab
> within that snapshot.
In my opinion, the whole set-default/subvolid= discussion is not 
relevant for my question (beside I appreciate it). Because the 
/etc/fstab is first read by init after switching to real root. So, if 
init itself is on a nested subvolume, /etc/fstab will not help at all.

> The fact of the matter is, we don't have the necessary metadata
> support in btrfs to understand the relationships between
> snapshots/subvolumes. There is a need for this, not least of which is
> the use case you're describing. This has come up with Fedora also for
> their offline updates rollback they want to eventually do. And it's
> also an issue with distribution installers which see these snapshots
> as wholly unique instances of existing installations, rather than as
> related snapshots.
[snip]
>> So here comes my question:
>> Wouldn't it be helpful to add a --recursive option to 'btrfs subvolume 
>> snapshot' to snapshot child subvolumes together with their parent?
>> Or maybe it is possible to add some functionality to reference the 
>> child subvolumes on the snapshots fs-tree to allow auto-mounting?
> 
> Well and it raises the problem of nested subvolumes making the parent
> subvolume undeletable.
We could make deletion recursive, the same as snapshotting, if that's 
the only reason.

> So I'd question the significant benefit of
> making nested subvolume in particular /var. It's complicating how the
> OS is to be put back together again.
Some apps are using the /var filesystem for caching and if they go nuts, 
your root filesystem runs out of space. Of cause you can question that. 
And I'm with you (at least for /usr). But this has been a common 
practice for years, and some of the oldschool sysadmins aren't to 
convince on that ;-)

To answer Duncans mail, the whole discussion on nested subvolumes is not 
relevant as long as quota support isn't stable. But I still wanted to 
bring this up to maybe open a feature request. And maybe it could be 
relevant to other projects (like Fedora) too.

Regards,
Michael


