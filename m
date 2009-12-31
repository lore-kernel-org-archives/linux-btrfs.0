From: regomodo <regomodo@googlemail.com>
Subject: Mount via /etc/fstab constant failure
Date: Thu, 31 Dec 2009 18:22:57 +0000
Message-ID: <200912311822.57397.regomodo@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a btrfs 'pool' of x2 Samsung 500GB HDD's in non-raid format. It works 
fine for the most part except for mounting on bootup. Every bootup I have to 
change the block-device to and fro /dev/sda & /dev/sdb. This happens on 
linux-2.6.32.2 and 2.6.33-rc2.

My relevant fstab section is:

/dev/sda        /mnt/btrfs      btrfs           defaults                0       
0
/dev/sda       /home           btrfs           subvol=HOME             0       
1
/dev/sdb       /media/data     btrfs           subvol=DATA            0       
0 

I get some output in /var/log/messages (2.6.32.2) also:
Dec 31 11:05:17 funtoo-pc kernel: device label BTRFS devid 1 transid 12372 
/dev/sda                         
Dec 31 11:05:17 funtoo-pc kernel: btrfs: failed to read the system array on 
sda                             
Dec 31 11:05:17 funtoo-pc kernel: btrfs: open_ctree failed                                                  

Is this a known issue as I know of one other person with exactly the same 
issue?

Regards

Reg
