Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i2.italiaonline.it ([212.48.25.198]:52625 "EHLO
	smtp-18.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750802AbaKVReo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Nov 2014 12:34:44 -0500
Message-ID: <5470C92E.1070607@inwind.it>
Date: Sat, 22 Nov 2014 18:34:38 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Zygo Blaxell <zblaxell@furryterror.org>, Phillip Susi <psusi@ubuntu.com>
CC: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
References: <54699CC7.1050909@swiftspirit.co.za> <546A46A5.8030603@inwind.it> <CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com> <CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com> <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com> <546B68F8.6080008@ubuntu.com> <FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com> <546BA96D.4050805@ubuntu.com> <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com> <546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org>
In-Reply-To: <20141121042814.GR17395@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/21/2014 05:28 AM, Zygo Blaxell wrote:
> e.g. if an ext4 filesystem explodes, I can:
> 
> 	1.  make a LVM snapshot of the broken filesystem
> 
> 	2.  run e2fsck on the snapshot
> 
> 	3.  mount and repair the snapshot, e.g. rsync any missing files
> 	from backups, salvage anything that survived
> 
> 	4.  LVM merge the snapshot to its origin volume
> 
> 	5.  umount the origin volume and mount the merged volume
> 	(or just reboot)
> 
> ...and I can do all of this on a running system, in-place, with only a
> few minutes of downtime in the must-reboot case.
> 
> None of the above works with btrfs at all.  Multi-device btrfs fails
> at 2, 

You can't compare ext4 with btrfs, if you are talking about a multi-device 
filesystem: ext4 haven't this capability. 
Try to make a md-raid over a snapshotted logical volume(s); I never tried
that, but I suppose that there will be the same problems...

> and mounting the filesystem fails at 3.  
Are you sure ?

ghigo@venice:/tmp$ # create a btrfs filesystem in a logical volume
ghigo@venice:/tmp$ sudo truncate -s +10G disk.img
ghigo@venice:/tmp$ sudo losetup -f disk.img 
ghigo@venice:/tmp$ sudo pvcreate /dev/loop0 
ghigo@venice:/tmp$ sudo vgcreate vgtest /dev/loop0 
ghigo@venice:/tmp$ sudo lvcreate -n lvone -L 3G vgtest
ghigo@venice:/tmp$ sudo mkfs.btrfs /dev/vgtest/lvone 
ghigo@venice:/tmp$ mkdir t

ghigo@venice:/tmp$ # create a file inside a btrfs fs
ghigo@venice:/tmp$ sudo mount /dev/vgtest/lvone t/
ghigo@venice:/tmp$ sudo dd if=/dev/zero of=t/disk-orig bs=1M count=1
ghigo@venice:/tmp$ sudo umount t

ghigo@venice:/tmp$ # make a lvm snapshot and add a 2nd file
ghigo@venice:/tmp$ sudo lvcreate -s -n lvone_snap -L 3G vgtest/lvone
ghigo@venice:/tmp$ sudo mount /dev/vgtest/lvone_snap t/
ghigo@venice:/tmp$ sudo dd if=/dev/zero of=t/disk-snap bs=1M count=1
ghigo@venice:/tmp$ sudo umount t

ghigo@venice:/tmp$ # mount the first one lv, and check the file
ghigo@venice:/tmp$ sudo mount /dev/vgtest/lvone t/
ghigo@venice:/tmp$ ls -l t
total 1024
-rw-r--r-- 1 root root 1048576 Nov 22 18:11 disk-orig
ghigo@venice:/tmp$ sudo umount t

ghigo@venice:/tmp$ # mount the first one lv, and check the files
ghigo@venice:/tmp$ sudo mount /dev/vgtest/lvone_snap t/
ghigo@venice:/tmp$ ls -l t
total 2048
-rw-r--r-- 1 root root 1048576 Nov 22 18:11 disk-orig
-rw-r--r-- 1 root root 1048576 Nov 22 18:12 disk-snap

On the basis of the example above, in case you want to mount a 
"single-disk", BTRFS seems me to work properly. You have to pay
attention only to not mount the two filesystem at the same time.

BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
