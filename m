From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Resizing a btrfs managed partition
Date: Wed, 24 Feb 2010 18:58:07 +0100
Message-ID: <201002241858.12343.kreijack@libero.it>
References: <hm3dai$pnl$1@dough.gmane.org>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: bugs@cherrybyte.me.uk
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <hm3dai$pnl$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 24 February 2010, planetf1 wrote:
> Hi,
Hi

>   Let me know if this is the wrong place to ask...
> 
>   I'm using Fedora 12 x86_64, mostly with the newer 21.6.32 kernel, and 
> have a single btrfs filesystem within a 120Gb partition.
> 
>   I'd like to extend the space btrfs can use. One option is presumably 
> add a new device to btrfs, but I was hoping to simple resize the 
> existing partition to say 160Gb.
> 
>   With ext4 I might do this with gparted , although mostly I'd use LVM, 
> with seperate LVs for /opt /home / etc and that's been the way I've done 
> it for many years.
> 
>   With btrfs I'm unsure as to the safe steps and decided to skip on use 
> of LVM giving the enhanced capabilities of btrfs itself.
> 
>   Is it ok to resize the partition with gparted?
IIRC gparted want to resize both partition and filesystem. So if gparted 
doesn't support btrfs, it will not be usable
>   How do I make btrfs use the new partition size?
I am never tried, but it should be sufficient to 
a) resize the underling partition (with fdisk)
b) resize the filesystem (with btrfsctl -r <size> <path-to-filesystem>).

If you want to grow the filesystem, the step are a) then b). Otherwise if you 
want to shrink the filesystem the step are b) then a)

Pay attention to:
- btrfs support online filesystem
- if you resize a partition it may be required to reboot the system, otherwise 
the kernel may not be able to read the new size of the partition
- if you pass 'max' as size of the btrfsctl utility, the filesystem grows up 
to fill all available space.

I suggest you to test the resizing on a loop device before tring a real 
filesystem.

>   Or are there other btrfs specific tools that can manage partitions
Not in my knowledge 
>   Would I be better off still using lvm in conjunction with btrfs?
In theory btrfs has the capability to add/remove device and resize a 
filesystem. But it is a young filesystem, so the results may be not the one 
expected.
>   Are there good pointers to useful user material on btrfs on these issues?
http://btrfs.wiki.kernel.org/index.php
http://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices

>   Is creating new subvolumes to manage /home (say I want to limit that 
> space, and create snapshots independently) appropriate, and if so what's 
> the easiest way to do that -- I had trouble with getting the subvolume 
> ops to work

If you don't use snapshot creating a subvolume is not useful. If you had 
problem, post the command which you had used.
 
> Mostly rather than NEED btrfs per se, I'm using a clean laptop 
> environment as a way to experiment with the new filesystem & understand 
> how to manage it.
> 
> Thanks
> Nigel.
> bugs@cherrybyte.me.uk
>
BR
Goffredo
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
