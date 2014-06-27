Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:52262 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753297AbaF0WIL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 18:08:11 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Can't mount subvolume with ro option
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53ADCF0B.4010109@free.fr>
Date: Fri, 27 Jun 2014 16:08:07 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <B87E6AE0-F47D-4F75-9628-E1151BB7467D@colorremedies.com>
References: <53ADCF0B.4010109@free.fr>
To: =?iso-8859-1?Q?S=E9bastien_ROHAUT?= <sebastien.rohaut@free.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 27, 2014, at 2:07 PM, Sébastien ROHAUT <sebastien.rohaut@free.fr> wrote:

> Hi,
> 
> In the wiki, it's said we can mount subvolumes with different mount options. nosuid, nodev, rw and ro are listed, as valid generic mount options.

This might require 3.15. I don't recall it working with early 3.14 kernels, but by 3.14.3 I'd moved onto testing 3.15.

[root@rawhide ~]# mount /dev/sda3 /mnt
[root@rawhide ~]# btrfs subvol create /mnt/test
Create subvolume '/mnt/test'
[root@rawhide ~]# umount /mnt
[root@rawhide ~]# mount -o ro,subvol=test /dev/sda3 /mnt
[root@rawhide ~]# mount | grep btrfs
/dev/sda3 on / type btrfs (rw,relatime,seclabel,space_cache,autodefrag)
/dev/sda3 on /home type btrfs (rw,relatime,seclabel,space_cache,autodefrag)
/dev/sda3 on /var type btrfs (rw,relatime,seclabel,space_cache,autodefrag)
/dev/sda3 on /boot type btrfs (rw,relatime,seclabel,space_cache,autodefrag)
/dev/sda3 on /mnt type btrfs (ro,relatime,seclabel,space_cache,autodefrag)
[root@rawhide ~]# cat /proc/self/mountinfo | grep btrfs
58 0 0:33 /root / rw,relatime shared:1 - btrfs /dev/sda3 rw,seclabel,space_cache,autodefrag
72 58 0:33 /home /home rw,relatime shared:29 - btrfs /dev/sda3 rw,seclabel,space_cache,autodefrag
74 58 0:33 /var /var rw,relatime shared:30 - btrfs /dev/sda3 rw,seclabel,space_cache,autodefrag
76 58 0:33 /boot /boot rw,relatime shared:31 - btrfs /dev/sda3 rw,seclabel,space_cache,autodefrag
84 58 0:33 /test /mnt ro,relatime shared:35 - btrfs /dev/sda3 rw,seclabel,space_cache,autodefrag

So on my end it seems like it's working correctly with 3.15.


Chris Murphy