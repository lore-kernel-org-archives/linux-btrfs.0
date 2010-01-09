From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Still Problems with /dev/btrfs-control
Date: Sat, 9 Jan 2010 12:05:34 +0100
Message-ID: <201001091205.34578.kreijack@libero.it>
References: <20100109114203.70ae0c14@simplux>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
To: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100109114203.70ae0c14@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Michael

On Saturday 09 January 2010, Dipl.-Ing. Michael Niederle wrote:
> Thanks for the quick reply!
> 
> But I still have problems with btrfsctl:
> > stat /dev/btrfs-control 
>   File: `/dev/btrfs-control'
>   Size: 0         	Blocks: 0          IO Block: 4096   block special file
> Device: ch/12d	Inode: 659848      Links: 1     Device type: a,3e

Ok, two things:

1) btrfs-control is a *character* device and _not_ a *block device*
2) on my system it is allocated under 10,55 (major/minor).

	$ stat /dev/btrfs-control
	  File: `/dev/btrfs-control'
	  Size: 0  Blocks: 0 IO Block: 4096   character special file
	Device: fh/15d  Inode: 2404        Links: 1     Device type: a,37
	Access: (0660/crw-rw----)  Uid: (0/ root)   Gid: ( 0/ root)
	Access: 2010-01-09 11:35:30.764909719 +0100
	Modify: 2010-01-09 11:35:30.764909719 +0100
	Change: 2010-01-09 11:35:30.764909719 +0100
	ghigo@venice:~$ ls -l /dev/btrfs-control
	crw-rw---- 1 root root 10, 55 2010-01-09 11:35 /dev/btrfs-control

Looking at the source

	btrfs-unstable/fs/btrfs$ grep -A 2 -B 2 "btrfs-control" *.c
	super.c-static struct miscdevice btrfs_misc = {
	super.c-        .minor          = MISC_DYNAMIC_MINOR,
	super.c:        .name           = "btrfs-control",
	super.c-        .fops           = &btrfs_ctl_fops
	super.c-};

It seems that it is dynamically allocated. The "major" should be always 10, 
the minor may be find with

	$ cat /proc/misc  | grep btrfs-control
	 55 btrfs-control

Or by

	$ cat /sys/class/misc/btrfs-control/dev
	10:55


Regards
Goffredo


> Access: (0644/brw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2010-01-09 11:31:15.757979602 +0100
> Modify: 2010-01-09 11:31:15.757979602 +0100
> Change: 2010-01-09 11:31:15.757979602 +0100
> > mount -l -t btrfs
> /dev/sda3 on / type btrfs (rw,relatime,noacl) [Alpha4]
> > btrfsctl -A /dev/sda3
> failed to open /dev/btrfs-control: No such device or address
> 
> Remark: When the btrfs-filesystem is originally mounted (from the startup-
code
> in the initial ramdisk), /dev/btrfs-control is not yet existant, because the
> dev-directory is contained in the btrfs-filesystem.
> 
> Everything else works fine.
> 
> Greetings, Michael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
