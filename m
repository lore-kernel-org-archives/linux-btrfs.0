Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo202.cox.net ([68.230.241.217]:56406 "EHLO
	eastrmfepo202.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003Ab3AFOhW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jan 2013 09:37:22 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo202.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130106143721.LQTU6475.eastrmfepo202.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>; Sun, 6 Jan 2013 09:37:21 -0500
Message-ID: <50E98C20.3040504@czarc.net>
Date: Sun, 06 Jan 2013 09:37:20 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Subject: Re: /boot as a btrfs subvolume
References: <50E8986A.2050002@czarc.net> <C4D7AC34-9841-4E58-BE5D-FF30C85FBD34@colorremedies.com>
In-Reply-To: <C4D7AC34-9841-4E58-BE5D-FF30C85FBD34@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/05/2013 04:32 PM, Chris Murphy wrote:
> On Jan 5, 2013, at 2:17 PM, Gene Czarcinski <gene@czarc.net> wrote:
>
>> As of the latest updates to anaconda and grub2 for Fedora 18, it is now possible to install with /boot as a btrfs subvolume.  The way that grub2 is handling this is the "reach down" to the files it needs as if the subvolume was a directory.
> Also for what it's worth, it also works for multiple device Btrfs volumes, all profiles supported by GRUB2. For me GRUB fails to navigate Btrfs for RAID0 if there are 5+ devices. Single still works, oddly RAID10 still works. So some regression is needed to figure out what's going on there. May be a bug, but honestly it's still pretty cool.
>
> Also to test is if installing grub to each device, in a multiple device raid1 or raid10 volume, still allows it to be bootable with any one device removed from the volume. I think it'll work.
>
There is also issues with btrfs and os-prober for multiboot ... it does 
not currently work.  I hacked up a patch to get it to work but have 
since had second thoughts about how multiboot should be handled.  I now 
prefer a separate grub partition, os-prober disabled, and a grub.cfg 
file which points to the grub.cfg for each individual system.

BTW, although you can install and boot boot installed in a logical 
volume, that system is not supported in os-prober multiboot.

Gene
