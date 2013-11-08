Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:51312 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758006Ab3KHTaR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Nov 2013 14:30:17 -0500
Received: from 105-34-agavebb-nm.abq.nm.agavebb.net ([199.21.105.34]:47450 helo=[10.1.8.1])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1Verl0-001LhK-9s
	for linux-btrfs@vger.kernel.org; Fri, 08 Nov 2013 12:30:15 -0700
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Question about btrfs as root filesystem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <7b2cdbd67793f539fb07f5c73a1509c8@myjm.de>
Date: Fri, 8 Nov 2013 12:30:10 -0700
Message-Id: <B01EE27D-B324-47DD-AAEA-583EB27E407F@colorremedies.com>
References: <5eb6a9cbd3a163b70c9cfe4a1b46a1fa@myjm.de> <236FCD08-8D7A-4067-9CC4-235BA129C953@colorremedies.com> <7b2cdbd67793f539fb07f5c73a1509c8@myjm.de>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 8, 2013, at 6:41 AM, Michael Göhler <visit@myjm.de> wrote:

> Hi Chris
> 
> thanks for taking the time.
> 
>>> The boot subvolume is then set with 'btrfs subvolume set-default' and mounted without subvol/subvolid option by Arch's default mount handler.
>> I'm unconvinced it's a good idea for it to be used behind the scenes
>> for the described purpose. Consider the following:
>> 1. btrfs subvolume set-default uses a user space tool and in my view
>> it's primarily a user domain behavior modifier for the mount command.
> The only drawback I can imagine is that the initrd can have a different version of the btrfs command, as it isn't repacked on package upgrades of btrfs-utils. But this isn't related to set-default only, but also for the snapshot command. Of cause, if we find a better way to achieve our goal, we are willing to drop it.

Consider the muliboot scenario were I want opensuse to boot with snapshotX persistently, and I want Fedora to boot with snapshotY persistently. If both distributions claim the right to change the default subvolume this now breaks horribly because neither distribution actually knows which snapshot is to be booted because that knowledge is only stored as the default subvolume, the value of which isn't preserved once changed.


>> 2. It makes the actual mounted subvolume obscured, cat
>> /proc/self/mountinfo doesn't show what subvolume is mounted unless
>> subvol= is explicitly used in /etc/fstab.
> We use btrfs subvolume get-default to check on which subvolume we are.

And what if that get-default presents you with a subvolume that isn't yours? It sounds like a setup for distributions stepping on each other.


> You are right, an average user will find it confusing. But if he does, he will also not look into the /proc filesystem. He will run mount without options to look for it, and have no luck because it isn't displayed there too.
> 
>> 3. Grub2 (and I'm pretty sure grubby) do not use the set-default. The
>> GRUB intent for the prefix to search an absolute path, not one
>> relative to the default subvolume. There's a bug that should very
>> recently (week) be fixed, where GRUB fails to find prefix if
>> set-default is changed. This maybe isn't affecting the particular
>> layout you describe where only rootfs is on btrfs, rather than /boot
>> being on its own subvolume.
> Actually 2.00.5086-1 which is latest on Arch is respecting set-default and searches for the kernel on the default subvolume without prefix and rootflags. Thanks for pointing this out, so I can watch out for the next grub update and fix the hook accordingly.

Maybe I'm not following what you mean by fix. If distributions were to have different GRUB behaviors in this respect, multiboot on Btrfs will be fundamentally broken: e.g. if one distribution expects GRUB to interpret prefix and rootflags as absolute paths from subvolid=5, and another distro interprets them as relative to the default subvolume.


> 
>> I'm sympathetic to the alternative problem, which is that you need to
>> alter grub.cfg to use the proper rootflags=subvol= to explicitly use
>> the proper snapshot, and also it would mean altering the /etc/fstab
>> within that snapshot.
> In my opinion, the whole set-default/subvolid= discussion is not relevant for my question (beside I appreciate it). Because the /etc/fstab is first read by init after switching to real root. So, if init itself is on a nested subvolume, /etc/fstab will not help at all.

I think this emphasizes that the necessary pieces aren't actually present to enable booting from snapshots, it becomes very use case specific and effectively proprietary to a distribution.


> Some apps are using the /var filesystem for caching and if they go nuts, your root filesystem runs out of space.

By making /var a subvolume on a file system that also hosts a root subvolume, you've not changed the risk of /var causing rootfs to run out of space, unless you also implement quotas for /var. And I think that's too risky to implement.


> Of cause you can question that. And I'm with you (at least for /usr). But this has been a common practice for years, and some of the oldschool sysadmins aren't to convince on that ;-)

I don't feel that implementing best practices that differs from oldschool convention requires convincing oldschoolers of anything. They can retroactively implement whatever they want if they wish. But today's developers doing this new work should consider best practices, not old practices. And should consider newschoolers, not just oldschoolers, who will become confused by antiquated conventions that have little (or no) efficacy.


Chris Murphy

