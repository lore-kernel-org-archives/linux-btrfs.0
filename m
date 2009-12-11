From: Goffredo Baroncelli <kreijack@libero.it>
Subject: BUG: Link from sub volume, then remove the subvolume -> wrong link
Date: Fri, 11 Dec 2009 20:54:25 +0100
Message-ID: <200912112054.25986.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all

when I tried to reproduce the bug highlighted by Andrew, I discovered another 
bug. When I link a file from a subvolume to another, then remove the subvolume 
I got a wrong link: in my test an *hard* link becomes a *soft* link !!!!

Steps to reproduce the bug:

	root@venice:/tmp/test# sudo btrfsctl -S subvol2 .
	operation complete
	Btrfs Btrfs v0.19
	root@venice:/tmp/test# echo 123 >>subvol2/myfile
	root@venice:/tmp/test# ln subvol2/myfile .
	root@venice:/tmp/test# ls -l . subvol2/
	.:
	total 4
	-rw-r--r-- 2 root root  4 2009-12-11 20:40 myfile
	drwx------ 1 root root 12 2009-12-11 20:40 subvol2

	subvol2/:
	total 4
	-rw-r--r-- 2 root root 4 2009-12-11 20:40 myfile
	root@venice:/tmp/test# btrfsctl -D subvol2 .
	operation complete
	Btrfs Btrfs v0.19
	root@venice:/tmp/test# ls -l
	total 0
	lrwxrwxrwx 1 root root 3 2009-11-22 10:56 myfile -> lib

Now myfile is a soft link instead to a hard link!!!! Moreover the soft link is 
to an incorrect target ( 1) lib doesn't exist, 2) in any case is not the right 
target).


BR
Goffredo
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
