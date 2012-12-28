Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:39398 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444Ab2L1Bo3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 20:44:29 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: problems with dracut mounting subvols
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50DCF245.20705@parallels.com>
Date: Thu, 27 Dec 2012 18:44:29 -0700
Message-Id: <5EE8E8F7-4147-4DD3-A928-AEFA27CE683C@colorremedies.com>
References: <5FA2C0D0-740D-4425-A099-46382311E2A3@colorremedies.com> <50DCF245.20705@parallels.com>
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 27, 2012, at 6:13 PM, dima <dolenin@parallels.com> wrote:
> 
> 
>> /dev/disk/by-uuid/64383cfe-c31d-4d25-97c4-4e6b7e788b26 /sysroot/usr btrfs subvol=usr,subvol=root,ro 1 2
> 
> I'd say that the problem is definitely with this line having two subvolumes listed.
> Maybe you should boot from a live CD, mount your subvolid=1 and check out what subvolumes you really have in there. And then re-write fstab manually.

When I mount subvolid=5 there are subvols root, boot, usr, var, home. And the /etc/fstab in root is:

#
# /etc/fstab
# Created by anaconda on Thu Dec 27 15:21:03 2012
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=64383cfe-c31d-4d25-97c4-4e6b7e788b26 /                       btrfs   subvol=root     1 1
UUID=64383cfe-c31d-4d25-97c4-4e6b7e788b26 /boot                   btrfs   subvol=boot     1 2
UUID=64383cfe-c31d-4d25-97c4-4e6b7e788b26 /home                   btrfs   subvol=home     1 2
UUID=64383cfe-c31d-4d25-97c4-4e6b7e788b26 /usr                    btrfs   subvol=usr      1 2
UUID=64383cfe-c31d-4d25-97c4-4e6b7e788b26 /var                    btrfs   subvol=var      1 2


It's correct.

Seems dracut is creating the wrong fstab for itself, but then also can't mount it correctly manually from a shell command. When booted in rescue mode to a full system, not just a dracut shell, I can mount -o subvol=root to one mount point, and also mount -o subvol=usr to another mountpoint (within or outside the former mount point) without error.


> If you have /sysroot subvolume, you can create /sysroot/usr as a child subvolume and you won't even need then to specify /sysroot/usr in your fstab because it will be mounted automatically when the parent subvolume gets mounted.

It's a useful work around. I'd like to narrow down if the real problem is dracut and if it should eventually be fixed. Seems both need fixing.


Chris Murphy