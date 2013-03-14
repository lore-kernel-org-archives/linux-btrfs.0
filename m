Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42146 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3CNJxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 05:53:00 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Any method to 'umount' a subvolume?
Date: Thu, 14 Mar 2013 10:52:57 +0100
Cc: Harald Glatt <mail@hachre.de>, Queen Adam <adam900710@gmail.com>
References: <CAFy8SQVzHYXmCkwgJ2tmE4QoZDGF4z1efN4z4CkVACQi2LEY_Q@mail.gmail.com> <CAFWF=amiXCdrvrWnuPW5-bn2V5FgvaK3VaOXMKGdfZwHH2KLfA@mail.gmail.com> (sfid-20130314_092330_722501_8C14D0AE)
In-Reply-To: <CAFWF=amiXCdrvrWnuPW5-bn2V5FgvaK3VaOXMKGdfZwHH2KLfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201303141052.58093.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 14. März 2013 schrieb Harald Glatt:
> That's because the test shouldn't be in your root in the first place.
> The common way of thinking now is to create a btrfs volume with a
> structure for holding subvolumes inside of which your system root is a
> member. You then mount the system root via -o subvol= and will only
> see it and nothing else. If you want access to the "control" structure
> you mount that without -o subvol. If you want to mount another
> subvolume (even in place of your root) you mount that with -o subvol
> to whereever you want.
> 
> Examples:
> real btrfs root:
> /root/default
> /root/snap1
> /root/snap2
> /home/default
> /home/snap1
> 
> The system root mounts /root/default on boot via -o
> subvol=root/default as well as the /home/default subvolume for /home.
> 
> Then if you want to make a snapshot you mount btrfs to something like
> /mnt/ctrl and do 'btrfs sub snap / /mnt/ctrl/root/snap3' and umount
> /mnt/ctrl again.

I use it that way, but I use

btrfs subvolume set-default NUMBER /mount/path

in order to not have to put the subvolid option into fstab.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
