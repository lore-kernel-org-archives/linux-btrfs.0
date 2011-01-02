From: J G <yoosty_cmn@yahoo.com>
Subject: Odd mkbtrfs behavior inside of chroot
Date: Sun, 2 Jan 2011 11:52:52 -0800 (PST)
Message-ID: <915110.93115.qm@web112501.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I just encountered some odd behavior from mkbtrfs.
The end goal is to restore a backup to newly created BTRFS partitions while using the latest btrfs-tools. 
Here's the steps to what I did:
* Booted SystemRescueCD
* Partitioned the drives (two 750GB drives with 12 partitions each)
* Created an extra partition on sda as a temporary holding place for the backed up files and so I can update btrfs-tools
* Formatted/mounted/restored backup files to the temporary partition which I mounted on /mnt/backup
* mount -t proc none /mnt/backup/proc; mount -o bind /dev /mnt/backup/dev
* chroot /mnt/backup /bin/bash
* Updated btrfs-tools to the latest git pull from today (v0.19-35-g1b444cd-dirty).
* mkbtrfs /dev/sda5 /dev/sdb5 -L root

mkbtrfs returned with:

error checking /dev/sda5 mount status

So I used strace to find out how it was checking for the mount status. Now, I'm no expert here, but I'm confused as to just why it failed. The last thing of note:

lstat("/boot", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
lstat("/boot/sysrcd.dat", 0x7fffb29681e0) = -1 ENOENT (No such file or directory)
close(3)                                = 0
munmap(0x7f11df372000, 4096)            = 0
write(2, "error checking /dev/sda5 mount s"..., 38error checking /dev/sda5 mount status
) = 38


doesn't explain much. I see that it's checking /proc/mounts to see what's mounted, and then it fails on stating /boot/sysrcd.dat (which doesn't exist in the non-chrooted FS, btw).

To make this even weirder, if I format sda5/sdb5 using the SysRescCD version of mkbtrfs (v0.19) and then format sda5/sdb5 using the chroot version, it works fine.

Any ideas here? I would expect that mkbtrfs would work inside of a chroot without any assistance from the original root.

I have the full strace from the chrooted mkbtrfs failing and from it succeeding, if that's helpful.


.:Justin:.


      
