From: Jan Engelhardt <jengelh@medozas.de>
Subject: Inode count in statvfs
Date: Tue, 3 Mar 2009 03:28:09 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903030326440.19850@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,


I noticed that `df -i` on btrfs returns zero values, much like it does 
for vfat and - I think I remember - reiser3.
It would be nice if btrfs could count the number of inodes on a volume, 
to get an overview of just how much dust I am collecting.
Is it doable?

Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/loop0                 0       0       0    -  /lo/kernel2


Jan
