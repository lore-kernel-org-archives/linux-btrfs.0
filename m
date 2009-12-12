From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: BUG: Link from sub volume, then remove the subvolume -> wrong
 link
Date: Sat, 12 Dec 2009 09:24:56 +0900
Message-ID: <4B22E2D8.7020706@jp.fujitsu.com>
References: <200912112054.25986.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200912112054.25986.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

 I don't know how a hard link becomes to a soft link, hard link
across subvolumes should not allowed in btrfs.

 Hard link contains target inode number but not target tree.
So, if we can create such hard link normally, it points to
a file which has same inode number in same subvolume.
 As for this problem, Christian Parpart posted a patch, and
I rebased it.

Regards,
taruisi

(2009/12/12 4:54), Goffredo Baroncelli wrote:
> Hi all
> 
> when I tried to reproduce the bug highlighted by Andrew, I discovered another 
> bug. When I link a file from a subvolume to another, then remove the subvolume 
> I got a wrong link: in my test an *hard* link becomes a *soft* link !!!!
> 
> Steps to reproduce the bug:
> 
> 	root@venice:/tmp/test# sudo btrfsctl -S subvol2 .
> 	operation complete
> 	Btrfs Btrfs v0.19
> 	root@venice:/tmp/test# echo 123 >>subvol2/myfile
> 	root@venice:/tmp/test# ln subvol2/myfile .
> 	root@venice:/tmp/test# ls -l . subvol2/
> 	.:
> 	total 4
> 	-rw-r--r-- 2 root root  4 2009-12-11 20:40 myfile
> 	drwx------ 1 root root 12 2009-12-11 20:40 subvol2
> 
> 	subvol2/:
> 	total 4
> 	-rw-r--r-- 2 root root 4 2009-12-11 20:40 myfile
> 	root@venice:/tmp/test# btrfsctl -D subvol2 .
> 	operation complete
> 	Btrfs Btrfs v0.19
> 	root@venice:/tmp/test# ls -l
> 	total 0
> 	lrwxrwxrwx 1 root root 3 2009-11-22 10:56 myfile -> lib
> 
> Now myfile is a soft link instead to a hard link!!!! Moreover the soft link is 
> to an incorrect target ( 1) lib doesn't exist, 2) in any case is not the right 
> target).
> 
> 
> BR
> Goffredo


-- 
taruisi

