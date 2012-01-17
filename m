From: Kyle Gates <kylegates@hotmail.com>
Subject: fstab mount options ignored on subsequent subvolume mounts
Date: Tue, 17 Jan 2012 13:09:36 -0600
Message-ID: <COL113-W4695DE73CE3FDD13C0E8BBB0800@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Greeting all,

I have multiple subvolumes on the same filesystem that are mounted with different options in fstab.
The problem is the mount options for subsequent subvolume mounts seem to be ignored as reflected in /proc/mounts.

$ cat /etc/fstab | grep mnt
UUID=<REMOVED> /mnt/a btrfs subvol=a,defaults,nodatacow,autodefrag,noatime,space_cache,inode_cache 0 0
UUID=<REMOVED> /mnt/b btrfs subvol=b,defaults,autodefrag,noatime,space_cache,inode_cache 0 0
UUID=<REMOVED> /mnt/c btrfs subvol=c,defaults,compress=zlib,autodefrag,noatime,space_cache,inode_cache 0 0
$ mount | grep mnt
/dev/sdb2 on /mnt/a type btrfs (rw,noatime,subvol=a,nodatacow,autodefrag,space_cache,inode_cache)
/dev/sdb2 on /mnt/b type btrfs (rw,noatime,subvol=b,autodefrag,space_cache,inode_cache)
/dev/sdb2 on /mnt/c type btrfs (rw,noatime,subvol=c,compress=zlib,autodefrag,space_cache,inode_cache)
$ cat /proc/mounts | grep mnt
/dev/sdb2 /mnt/a btrfs rw,noatime,nodatasum,nodatacow,space_cache,autodefrag,inode_cache 0 0
/dev/sdb2 /mnt/b btrfs rw,noatime,nodatasum,nodatacow,space_cache,autodefrag,inode_cache 0 0
/dev/sdb2 /mnt/c btrfs rw,noatime,nodatasum,nodatacow,space_cache,autodefrag,inode_cache 0 0

continuing the example which should only change the mount options for one of the subvolumes:
$ sudo mount -o remount,compress=zlib /mnt/oldhome
$ cat /proc/mounts | grep mnt
/dev/sdb2 /mnt/a btrfs rw,noatime,nodatasum,nodatacow,compress=zlib,space_cache,autodefrag,inode_cache 0 0
/dev/sdb2 /mnt/b btrfs rw,noatime,nodatasum,nodatacow,compress=zlib,space_cache,autodefrag,inode_cache 0 0
/dev/sdb2 /mnt/c btrfs rw,noatime,nodatasum,nodatacow,compress=zlib,space_cache,autodefrag,inode_cache 0 0


Running Ubuntu mainline kernel 3.2.1 (3.2.1-030201-generic #201201121644 SMP Thu Jan 12 21:53:24 UTC 2012 i686 athlon i386 GNU/Linux) with most recent btrfs-progs (2011-12-01) from linux/kernel/git/mason/btrfs-progs.git

Thanks,
Kyle
 		 	   		  