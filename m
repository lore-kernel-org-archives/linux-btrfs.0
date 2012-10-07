Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38165 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2JGOmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2012 10:42:01 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS, getting darn slower everyday
Date: Sun, 7 Oct 2012 16:41:59 +0200
Cc: =?iso-8859-1?q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
References: <50714AC8.4010100@petaramesh.org> <201210071500.43204.Martin@lichtvoll.de> <5071801B.4090704@petaramesh.org> (sfid-20121007_163445_072033_C7BFA79E)
In-Reply-To: <5071801B.4090704@petaramesh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210071641.59272.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 7. Oktober 2012 schrieb Swâmi Petaramesh:
> Le 07/10/2012 15:00, Martin Steigerwald a écrit :
> > I forgot to mention mount options? Which one do you use?
> 
> root@tethys:/etc# grep btrfs fstab
> /dev/VG1/BTR_POOL    /    btrfs   
> subvol=UBUNTU/@,space_cache,autodefrag,compress=lzo,relatime        0 0
> /dev/sda2        /boot    btrfs   
> subvol=UBUNTU/@boot,space_cache,autodefrag,relatime            0 0
> /dev/VG1/BTR_POOL    /tmp    btrfs   
> subvol=UBUNTU/@tmp,space_cache,autodefrag,compress=lzo,relatime        
> 0 0 /dev/VG1/BTR_POOL    /home    btrfs
> subvol=UBUNTU/@home,space_cache,autodefrag,compress=lzo,relatime    0 0
> /dev/VG1/BTR_POOL    /storage    btrfs   
> subvol=STORAGE,space_cache,autodefrag,compress=lzo,relatime    0 0
> /dev/VG1/BTR_POOL    /data/BIG        btrfs   
> subvol=DATA/BIG,space_cache,compress=lzo,noatime    0 0
> /dev/VG1/BTR_POOL    /data/VBOX_HIDDEN    btrfs   
> subvol=DATA/VBOX_HIDDEN,space_cache,compress=lzo,noatime    0 0
> /dev/VG1/BTR_POOL    /data/VBOX_VMS        btrfs   
> subvol=DATA/VBOX_VMS,space_cache,compress=lzo,noatime    0 0

Hmmm, is the slowness on all of these?

For the VBOX volumes I would have a possible explaination for slowness.

Unless the subvolume is mounted with nodatacow, which it isn´t according 
to above output, every write to the VM image goes to a new location. Thus 
this increases fragmentation. While autodefrag might mitigate some of 
these, it may not be enough. AFAIK its only efficient for certain use cases. 
So or so it does not appear tha tthe VBOX volumes use autodefrag.

Could you try filefrag -v on some of the bigger VM image files?

I also wonder about the absence of inode_cache, but this could either be 
default by now or BTRFS remembers whether what has initially been set. But 
you could try this one. Especially on the filesystems with lots of inodes.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
