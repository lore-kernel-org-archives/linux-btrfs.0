From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: BUG: Link from sub volume, then remove the subvolume -> wrong link
Date: Sat, 12 Dec 2009 14:54:00 +0100
Message-ID: <200912121454.00871.kreijack@libero.it>
References: <200912112054.25986.kreijack@libero.it> <4B22E2D8.7020706@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B22E2D8.7020706@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 12 December 2009, TARUISI Hiroaki wrote:
> Hi,
> 
>  I don't know how a hard link becomes to a soft link, hard link
> across subvolumes should not allowed in btrfs.
I try an explanation below

> 
>  Hard link contains target inode number but not target tree.
> So, if we can create such hard link normally, it points to
> a file which has same inode number in same subvolume.

I can add further details. The next boot my machine was un-bootable. The 
reasons was that the *soft link* /lib64 (which pointed to /lib) was wrong.

My explanation of the fact is:
- In my root there was the link "/lib64 -> lib"; the file /lib64 had inode 
number = 257.
- I created a subvolume for my test. Under this subvolume I created a file 
(called "myfile") which (casually) had inode number = 257.
- I hard linked the  file "myfile" (which inode number 257) in my root volume.
- Unfortunately the inode number of the linked file, existed already and was 
the one of the /lib64 link.
- When I removed the subvolume used for my test, the two file (/lib64 and the 
linked target) exchanged its content and the hard-link becames a soft link and 
vice-versa.

The final results was:
- an unbootable machine
- three files with the same inode (and with a ref count equal to two !!)

On the basis of the facts above, I suggest to Chris to raise the importance of 
the patch of TARUISI Hiroaki (see email [PATCH] Deny sys_link across 
subvolumes 12/11/2009).

BR
Goffredo



-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
