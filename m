Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:46925 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3C1S1b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 14:27:31 -0400
Message-ID: <51548B8F.8060307@petaramesh.org>
Date: Thu, 28 Mar 2013 19:27:27 +0100
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: This time HD LED doesn't come up at all :-(
References: <51542EB6.7030403@petaramesh.org> <20130328131939.GN28030@localhost.localdomain> <515467EE.1090105@petaramesh.org> <20130328180548.GQ28030@localhost.localdomain>
In-Reply-To: <20130328180548.GQ28030@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 28/03/2013 19:05, Josef Bacik a écrit :
> Actually I see the deadlock now, sorry, I'll fix it up and send a patch.

Meanwhile, I booted in PartedMagic again (My Hero !), mounted the FS,
chrooted into it, mounted everything under it, then I rebuilt the
initramfs, unmounted and restarted "the usual way".

Then the HD LED stayed LIT for at least 5 full minutes, and in the end
it would boot properly.

I don't know what exactly happened, but it seems that regenerating the
initramfs from within the live CD somehow helped BTRFS to fix itself ?

Happily enough for me, for that's my wife's system, and you know bad
things can happen when wife is unhappy :-\

(She's actually already badly unhappy about performance, leaves the
machine "suspended" all the time for she can't stand the time it takes
to boot, but if I tell her that her Linux FS died, I'm afraid she's back
to WinXP in minutes :-/ which is worse than death...)

Thanks for your help :-)


FYI parts of this machine's fstab and mountinfo in case it might help...

# grep btrfs fstab
/dev/sda1       /               btrfs  
subvol=@,compress=lzo,space_cache,inode_cache,autodefrag,relatime       0 0
/dev/sda1       /boot           btrfs  
subvol=@boot,space_cache,inode_cache,autodefrag,relatime                               
0 0
/dev/sda1       /tmp            btrfs  
subvol=@tmp,compress=lzo,space_cache,inode_cache,autodefrag,relatime    0 0
/dev/sda1       /home           btrfs  
subvol=@home,compress=lzo,space_cache,inode_cache,autodefrag,relatime   0 0
/dev/sda1       /storage/owner_.VBox  btrfs  
subvol=@owner_.VBox,compress=lzo,space_cache,inode_cache,autodefrag,noatime  
0 0
/dev/sda1       /storage/owner_BIG    btrfs  
subvol=@owner_BIG,compress=lzo,space_cache,inode_cache,autodefrag,noatime    
0 0
/dev/sda1       /mnt/ROOTFS     btrfs  
noauto,compress=lzo,space_cache,inode_cache,autodefrag,relatime 0 0

# grep btrfs /proc/self/mountinfo
20 1 0:16 /@ / rw,relatime - btrfs /dev/sda1
rw,compress=lzo,space_cache,autodefrag,inode_cache
27 20 0:16 /@tmp /tmp rw,relatime - btrfs /dev/sda1
rw,compress=lzo,space_cache,autodefrag,inode_cache
28 20 0:16 /@boot /boot rw,relatime - btrfs /dev/sda1
rw,compress=lzo,space_cache,autodefrag,inode_cache
29 20 0:16 /@home /home rw,relatime - btrfs /dev/sda1
rw,compress=lzo,space_cache,autodefrag,inode_cache
30 20 0:16 /@owner_.VBox /storage/owner_.VBox rw,noatime - btrfs
/dev/sda1 rw,compress=lzo,space_cache,autodefrag,inode_cache
31 20 0:16 /@owner_BIG /storage/owner_BIG rw,noatime - btrfs /dev/sda1
rw,compress=lzo,space_cache,autodefrag,inode_cache


-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

