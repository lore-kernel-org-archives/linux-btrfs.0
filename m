From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Odd mkbtrfs behavior inside of chroot
Date: Mon, 03 Jan 2011 00:14:24 +0100
Message-ID: <4D2106D0.80609@libero.it>
References: <915110.93115.qm@web112501.mail.gq1.yahoo.com>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: J G <yoosty_cmn@yahoo.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <915110.93115.qm@web112501.mail.gq1.yahoo.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/02/2011 08:52 PM, J G wrote:
> I just encountered some odd behavior from mkbtrfs.
> The end goal is to restore a backup to newly created BTRFS partitions while using the latest btrfs-tools. 
> Here's the steps to what I did:
> * Booted SystemRescueCD
> * Partitioned the drives (two 750GB drives with 12 partitions each)
> * Created an extra partition on sda as a temporary holding place for the backed up files and so I can update btrfs-tools
> * Formatted/mounted/restored backup files to the temporary partition which I mounted on /mnt/backup
> * mount -t proc none /mnt/backup/proc; mount -o bind /dev /mnt/backup/dev
> * chroot /mnt/backup /bin/bash
> * Updated btrfs-tools to the latest git pull from today (v0.19-35-g1b444cd-dirty).
> * mkbtrfs /dev/sda5 /dev/sdb5 -L root
> 
> mkbtrfs returned with:
> 
> error checking /dev/sda5 mount status
> 
> So I used strace to find out how it was checking for the mount status. Now, I'm no expert here, but I'm confused as to just why it failed. The last thing of note:
> 
> lstat("/boot", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
> lstat("/boot/sysrcd.dat", 0x7fffb29681e0) = -1 ENOENT (No such file or directory)
> close(3)                                = 0
> munmap(0x7f11df372000, 4096)            = 0
> write(2, "error checking /dev/sda5 mount s"..., 38error checking /dev/sda5 mount status
> ) = 38
> 
> 
> doesn't explain much. I see that it's checking /proc/mounts to see what's mounted, and then it fails on stating /boot/sysrcd.dat (which doesn't exist in the non-chrooted FS, btw).
> 
> To make this even weirder, if I format sda5/sdb5 using the SysRescCD version of mkbtrfs (v0.19) and then format sda5/sdb5 using the chroot version, it works fine.
> 
> Any ideas here? I would expect that mkbtrfs would work inside of a chroot without any assistance from the original root.
> 
> I have the full strace from the chrooted mkbtrfs failing and from it succeeding, if that's helpful.

On the basis of the provided information, and on the code it seems that
mkfs.btrfs tries hard to check that the user is not formatting a mounted
disk (or loop). So mkfs.btrfs scan the /proc/mount file and checks every
devices. To do the check it needs to access the original file if this is
a "loop backend". This is reasonable.

In this case in a chroot-ed environment the loop file is not accessible.

If you need a [dirty] "quick hack" to by-pass the problem (not tested):
- unmount the proc filesystem
- create an empty file /proc/mounts
- run btrfs.fsck
- mount the proc filesystem (removing the fake mounts file)
- perform a "btrfs device scan"
- mount the filesystem

Of course the "right" solution is to add a "--force" switch which
permits to by-pass these checks. Other mkfs.* tools have this switch.

>From the mkfs.ext4 man page:
[...]
       -F     Force mke2fs to create a filesystem,
              even if the specified device is  not
              a   partition  on  a  block  special
              device, or if  other  parameters  do
              not  make  sense.  In order to force
              mke2fs to create a  filesystem  even
              if  the  filesystem appears to be in
              use or is mounted (a truly dangerous
              thing  to  do),  this option must be
              specified twice.

[...]


> 
> .:Justin:.
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

