From: Chris Mason <chris.mason@oracle.com>
Subject: Re: resize ate my root node
Date: Thu, 10 Mar 2011 08:19:49 -0500
Message-ID: <1299763154-sup-2900@think>
References: <20110307174820.5100.qmail@stuge.se> <1299620014-sup-698@think> <20110310062333.13172.qmail@stuge.se>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Peter Stuge <peter@stuge.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110310062333.13172.qmail@stuge.se>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Peter Stuge's message of 2011-03-10 01:23:33 -0500:
> Hi Chris,
> 
> Chris Mason wrote:
> > > I ran btrfsctl resize -r -3gb /dev/sda2 using wireless-testing.git
> > > based on 2.6.38-rc6 and all seemed good. df reported reduced size so
> > > I repartitioned and rebooted. Filesystem can no longer be mounted:
> > 
> > Ouch, sorry about this.  Do you have details on how big the FS was
> > and how big the partition was before the resize?
> 
> Not complete details I'm afraid. I only remember some of the numbers
> at the end of the original partition size. Apologies for not having
> including more details about the media in the first message!

One more question which Jens Axboe just suggested.  Which tool and which
version of the tool did you use to delete the partition?  

-chris

> 
> It's a 64GB CF card with two partitions; one 40MB ext2 and "the rest"
> is btrfs. This is the current fdisk output:
> 
> Command (m for help): p
> 
> Disk /dev/sdb: 64.0 GB, 64030244864 bytes
> 64 heads, 32 sectors/track, 61064 cylinders
> Units = cylinders of 2048 * 512 = 1048576 bytes
> Disk identifier: 0x001c2022
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1               1          40       40131   83  Linux
> Partition 1 does not end on cylinder boundary.
> /dev/sdb2              40       61064    62489373+  83  Linux
> 
> Command (m for help): u
> Changing display/entry units to sectors
> 
> Command (m for help): p
> 
> Disk /dev/sdb: 64.0 GB, 64030244864 bytes
> 64 heads, 32 sectors/track, 61064 cylinders, total 125059072 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Disk identifier: 0x001c2022
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1              63       80324       40131   83  Linux
> Partition 1 does not end on cylinder boundary.
> /dev/sdb2           80325   125059071    62489373+  83  Linux
> 
> Command (m for help): x
> 
> Expert command (m for help): p
> 
> Disk /dev/sdb: 64 heads, 32 sectors, 61064 cylinders
> 
> Nr AF  Hd Sec  Cyl  Hd Sec  Cyl     Start      Size ID
>  1 00   1   1    0 254  63    4         63      80262 83
> Partition 1 does not end on cylinder boundary.
>  2 00  14   6   39  63  32 1023      80325  124978747 83
>  3 00   0   0    0   0   0    0          0          0 00
>  4 00   0   0    0   0   0    0          0          0 00
> 
> I say current, because by now I have changed the sdb2 partition
> twice.
> 
> > Have you tried using fdisk to bring the partition back to the
> > original size?
> 
> Almost..
> 
> After resizing I deleted the partition and then created a new one
> starting at 80325, which was exactly 120000000 sectors. This is only
> 1.2 GB smaller than the original partition (resized -3gb) but I
> wanted to avoid mistakes while calculating sectors, so I exaggerated.
> The 1-or-so GB free space at the end would be enough anyway.
> 
> In any case changing the partition table shouldn't affect the
> filesystem, right? Also, I changed the partition with the filesystem
> mounted, so the kernel did not start using the new partition table.
> 
> When the mount failed after rebooting, I tried to do what you
> suggest; I removed the partition and then created a new one which
> used all available space on the card. This is the state of the card
> now. However, I am 100% sure that the current size of the partition
> is not exactly the same as the original partition was. Could this
> partition table difference have an impact after all? Is something in
> the fs calculated based on device size?
> 
> 
> I would expect serious trouble if I made the partition smaller
> *without* resizing, so that a seek within the fs could go beyond
> device limits, but from gdb:ing disk-io.c it seems that zero-bytes
> are where there's supposed to be a root node. So either the root node
> was destroyed (uh-oh?) or code is reading from the wrong place. I
> don't know which is more likely?
> 
> > > $ ./btrfs-debug-tree /dev/sdb2
> > > btrfs-debug-tree: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' failed.
> > > 
> > > $ gdb --args ./btrfs-debug-tree /dev/sdb2
> ..
> > > Breakpoint 1, check_tree_block (root=0x946e008, buf=0x9474628) at disk-io.c:44
> > > 44              if (buf->start != btrfs_header_bytenr(buf))
> > > (gdb) p buf->start
> > > $4 = 34520006656
> > > (gdb) p btrfs_header_bytenr(buf)
> > > $5 = 0
> ..
> > > (gdb) bt
> > > #0  check_tree_block (root=0x946e008, buf=0x9474628) at disk-io.c:45
> > > #1  0x080514fc in read_tree_block (root=0x946e008, bytenr=34520006656, 
> > >     blocksize=4096, parent_transid=341132) at disk-io.c:207
> > > #2  0x080531a7 in open_ctree_fd (fp=7, path=0xbfef322a "/dev/sdb2", 
> > >     sb_bytenr=65536, writes=0) at disk-io.c:736
> 
> The fs had >20 GB available before resize, and 19-something after.
> (From memory of df output.) I haven't removed very many files from
> the filesystem since it was created. I have also not used any
> "advanced" features such as snapshots or subvolumes. This was the
> first time I ran btrfsctl.
> 
> I appreciate the help!
> 
> 
> //Peter
