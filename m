From: Shridhar Shetty <shridhar@staff.ownmail.com>
Subject: Btrfs in degraded mode
Date: Tue, 17 Apr 2012 16:14:45 +0000 (UTC)
Message-ID: <loom.20120417T181336-69@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have created a btrfs filesystem with RAID1 setup having 2 disks. Everything
works fine but when I try to umount the device and remount it in degraded mode,
the data still goes into both the disk. ideally in degraded mode only one disk
show disk activity and not the failed ones. 

System Config: 
Base OS: Slackware 
kernel: linux 3.3.2 

"sar -pd 2 10" shows me that the data is been written/read from both devices. 

Also, Is there any way in which I can remove the failed disk without adding a
new one in a RAID1 (2 disk setup). The reason being we want the option to keep
it running in degraded(single disk) mode for sometime and on a weekend replace
the failed drive with a fresh one :-).  

Thanks
Shridhar 

