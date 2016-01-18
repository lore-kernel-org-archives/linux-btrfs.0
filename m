Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:32938 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbcARSeA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jan 2016 13:34:00 -0500
Date: Mon, 18 Jan 2016 19:27:17 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Omar Sandoval <osandov@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: space_cache=v2 on root fs
Message-ID: <20160118182717.GA321@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

while testing the new space_cache=v2 mount option it looks like my root fs
doesn't automatically create the new space cache.

I'm using the following /etc/fstab:

UUID=7ef56edc-673e-452e-9e05-3fabf074168b       /               btrfs           noatime,compress=lzo,space_cache=v2             0 0
UUID=6b7d75bf-3d12-409c-88ed-500ac6b78510       /var            btrfs           compress=lzo,space_cache=v2                     0 0
UUID=24cee7e4-9093-4f86-aa73-d8a59d7f3c6c       /var/tmp        btrfs           compress=lzo,space_cache=v2                     0 0

During first mount the space cache was created for /var (/dev/sdb2) and
/var/tmp (/dev/sda3), but apparently not for / (/dev/sdc3):

Jan 18 18:48:18 x4 kernel: BTRFS info (device sdb2): enabling free space tree  
Jan 18 18:48:18 x4 kernel: BTRFS info (device sdb2): using free space tree 
Jan 18 18:48:18 x4 kernel: BTRFS: creating free space tree
Jan 18 18:48:18 x4 kernel: BTRFS info (device sdb2): setting 1 ro feature flag
Jan 18 18:48:18 x4 kernel: BTRFS: checking UUID tree
Jan 18 18:48:18 x4 kernel: BTRFS info (device sda3): enabling free space tree
Jan 18 18:48:18 x4 kernel: BTRFS info (device sda3): using free space tree
Jan 18 18:48:18 x4 kernel: BTRFS: has skinny extents
Jan 18 18:48:18 x4 kernel: BTRFS: detected SSD devices, enabling SSD mode
Jan 18 18:48:18 x4 kernel: BTRFS: creating free space tree
Jan 18 18:48:18 x4 kernel: BTRFS info (device sda3): setting 1 ro feature flag
Jan 18 18:48:18 x4 kernel: BTRFS: checking UUID tree
Jan 18 18:48:22 x4 kernel: BTRFS info (device sdc3): enabling free space tree
Jan 18 18:48:22 x4 kernel: BTRFS info (device sdc3): using free space tree

During subsequent boots the "enabling free space tree" message is
repeated every time for the root fs.

Jan 18 18:53:48 x4 kernel: BTRFS info (device sdb2): using free space tree 
Jan 18 18:53:48 x4 kernel: BTRFS info (device sda3): using free space tree 
Jan 18 18:53:52 x4 kernel: BTRFS info (device sdc3): enabling free space tree 
Jan 18 18:53:52 x4 kernel: BTRFS info (device sdc3): using free space tree  

markus@x4 tmp % mount
/dev/sdc3 on / type btrfs (rw,noatime,compress=lzo,ssd,noacl,space_cache=v2,subvolid=5,subvol=/)
devtmpfs on /dev type devtmpfs (rw,relatime,size=4080208k,nr_inodes=1020052,mode=755)
proc on /proc type proc (rw,relatime)
sys on /sys type sysfs (rw,relatime)
devpts on /dev/pts type devpts (rw,relatime,gid=5,mode=620)
none on /dev/shm type tmpfs (rw,relatime,size=409600k)
/dev/sdb2 on /var type btrfs (rw,relatime,compress=lzo,noacl,space_cache=v2,subvolid=5,subvol=/)
/dev/sda3 on /var/tmp type btrfs (rw,relatime,compress=lzo,ssd,noacl,space_cache=v2,subvolid=5,subvol=/)

-- 
Markus
