From: "Jean-Philippe Robichaud" <jean.philippe.robichaud@gmail.com>
Subject: unexpected raid1 behavior?
Date: Fri, 27 Nov 2009 15:41:17 -0500
Message-ID: <200911271541.17451.jean.philippe.robichaud@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I'm starting to play with btrfs on my new computer. I'm running Gentoo and 
have compiled the 2.6.31 kernel, enabling btrfs.

Now I have 2 partitions (on 2 different sata disks) that are free for me to 
play with, each about 375 gb in size.  I wanted to create a "raid1" volume 
using these two partitions, so I did:
 
# mkfs.btrfs -d raid1 /dev/sda5 /dev/sdb5
# mount /dev/sda5 /btrfs

and everything seems fine.

Now what I find strange is that everything looks like a raid0 was created, not 
a raid1:

$ df -h /btrfs/
 Filesystem            Size  Used Avail Use% Mounted on
/dev/sda5             684G   72G  612G  11% /btrfs

What am I doing (or understanding) wrong?

Thanks!

Jp
