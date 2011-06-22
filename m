From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: how reliable is btrfsck?
Date: Thu, 23 Jun 2011 01:23:51 +0200
Message-ID: <201106230123.51586.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After some problems with btrfs (Oopses), I've checked now the btrfs filesystems 
on my systems as a precaution. On the first system I got

root 256 inode 404596 errors 400
root 256 inode 404603 errors 400
root 256 inode 409540 errors 400
root 256 inode 409562 errors 400
root 258 inode 5555 errors 400
root 258 inode 5556 errors 400
root 258 inode 27624 errors 400
root 258 inode 27659 errors 400
root 258 inode 29243 errors 400
root 258 inode 29255 errors 400
root 258 inode 29256 errors 400
root 258 inode 90400 errors 400
root 258 inode 90401 errors 400
root 258 inode 91155 errors 400
root 258 inode 166025 errors 400
found 71626346496 bytes used err is 1
total csum bytes: 68939428
total tree bytes: 1028964352
total fs tree bytes: 901152768
btree space waste bytes: 274375495
file data blocks allocated: 73391845376
 referenced 70346993664
Btrfs v0.19-50-ge6bd18d

This is a single disk system with three subvolumes additional to the default.
On a second system with a RAID1 setup with two 500G disks I get:

failed to read /dev/sr0
failed to read /dev/sr0
root 5 inode 1891143 errors 400
root 5 inode 1891166 errors 400
root 5 inode 1915207 errors 400
root 5 inode 1915214 errors 400
root 5 inode 1915531 errors 400
root 5 inode 1915547 errors 400
root 5 inode 1915599 errors 400
root 5 inode 1915750 errors 400
root 5 inode 1915777 errors 400
found 391921790976 bytes used err is 1
total csum bytes: 379086532
total tree bytes: 3737182208
total fs tree bytes: 3013656576
btree space waste bytes: 1024370594
file data blocks allocated: 388184608768
 referenced 388184051712
Btrfs v0.19-36-g28da90f

The output is identical for both disks. A third disk in this system doesn't 
show any errors.

So the question is, is btrfsck miss-reporting something here? Or are these 
real errors?

regards,
  Johannes
