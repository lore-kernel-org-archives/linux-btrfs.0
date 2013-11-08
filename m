Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57723 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752755Ab3KHBdX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 20:33:23 -0500
Received: from c-68-35-125-242.hsd1.nm.comcast.net ([68.35.125.242]:51761 helo=[192.168.1.140])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1Veawr-0032GX-Ts
	for linux-btrfs@vger.kernel.org; Thu, 07 Nov 2013 18:33:22 -0700
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Question about btrfs as root filesystem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5eb6a9cbd3a163b70c9cfe4a1b46a1fa@myjm.de>
Date: Thu, 7 Nov 2013 18:33:20 -0700
Message-Id: <236FCD08-8D7A-4067-9CC4-235BA129C953@colorremedies.com>
References: <5eb6a9cbd3a163b70c9cfe4a1b46a1fa@myjm.de>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 7, 2013, at 4:45 PM, Michael Göhler <visit@myjm.de> wrote:
>  The boot subvolume is then set with 'btrfs subvolume set-default' and mounted without subvol/subvolid option by Arch's default mount handler.

I'm unconvinced it's a good idea for it to be used behind the scenes for the described purpose. Consider the following:

1. btrfs subvolume set-default uses a user space tool and in my view it's primarily a user domain behavior modifier for the mount command.

2. It makes the actual mounted subvolume obscured, cat /proc/self/mountinfo doesn't show what subvolume is mounted unless subvol= is explicitly used in /etc/fstab.

3. Grub2 (and I'm pretty sure grubby) do not use the set-default. The GRUB intent for the prefix to search an absolute path, not one relative to the default subvolume. There's a bug that should very recently (week) be fixed, where GRUB fails to find prefix if set-default is changed. This maybe isn't affecting the particular layout you describe where only rootfs is on btrfs, rather than /boot being on its own subvolume.

> That way, we ensure the best compatibility and lowest maintenance, as we don't overwrite default init functions.

I'm sympathetic to the alternative problem, which is that you need to alter grub.cfg to use the proper rootflags=subvol= to explicitly use the proper snapshot, and also it would mean altering the /etc/fstab within that snapshot.

> 
> Now, if we snapshots the root subvolume, the child subvolumes are not snapshoted with it. There is no back reference which would allow Btrfs to auto-mount the original child subvolumes when we mount the snapshot as new root filesystem. Of cause we could snapshot the childs separately into their desired directories. But this would not help, because our hook snapshots the snapshot again, to keep it's original untouched while rolling back. And we don't have fstab to find out the correct mount points at this early boot stage.

The fact of the matter is, we don't have the necessary metadata support in btrfs to understand the relationships between snapshots/subvolumes. There is a need for this, not least of which is the use case you're describing. This has come up with Fedora also for their offline updates rollback they want to eventually do. And it's also an issue with distribution installers which see these snapshots as wholly unique instances of existing installations, rather than as related snapshots.


> 
> Atm. all scenarios results in /usr/bin/init not found.
> 
> So here comes my question:
> Wouldn't it be helpful to add a --recursive option to 'btrfs subvolume snapshot' to snapshot child subvolumes together with their parent?
> Or maybe it is possible to add some functionality to reference the child subvolumes on the snapshots fs-tree to allow auto-mounting?

Well and it raises the problem of nested subvolumes making the parent  subvolume undeletable. So I'd question the significant benefit of making nested subvolume in particular /var. It's complicating how the OS is to be put back together again.


Chris Murphy