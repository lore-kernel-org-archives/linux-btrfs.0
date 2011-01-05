From: Mikael Cluseau <nwrk@linux.nc>
Subject: transid problem after a power-failure
Date: Thu, 06 Jan 2011 08:02:24 +1100
Message-ID: <1294261344.5764.34.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello people of BTRFS :)

I'm writing because (as the subject says) I have a problem mounting a
btrfs after a power failure.

About the context...

This a as pretty simple BTRFS setup: the 3ware 9690SA-4I RAID controller
with RAID-5 composed of 4x1TB drives. No software RAID, no BTRFS RAID.

My uname -a is:
Linux nwrk 2.6.36-gentoo-r5-nwrk #1 SMP PREEMPT Sat Dec 18 09:52:24 NCT 2010 x86_64 Intel(R) Core(TM) i7 CPU 975 @ 3.33GHz GenuineIntel GNU/Linux

btrfs-show from the latest btrfs-progs-unstable (pulled from Mason's
git) gives the following informations:

failed to read /dev/sdb
Label: none  uuid: 375315d5-6cc9-4e3c-b318-1823508a4e50
	Total devices 1 FS bytes used 789.63GB
	devid    1 size 2.73TB used 793.54GB path /dev/dm-0

Btrfs v0.19-35-g1b444cd

About the problem...

Whatever I tried to do I had the following in the kernel log or on
stdout:

Jan 06 07:34:32 [kernel] device fsid 3c4ec96cd5155337-504e8a50231818b3 devid 1 transid 85879 /dev/mapper/raid-data
Jan 06 07:34:32 [kernel] parent transid verify failed on 657818017792 wanted 85879 found 85878
                - Last output repeated 2 times -
Jan 06 07:34:32 [kernel] btrfs: open_ctree failed
^-- this line is more detailled with btrfsck:
                         btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' failed.

I've STFG of course, and then info I found was the following thread, on
this list :
http://kerneltrap.org/mailarchive/linux-btrfs/2010/12/9/6886529/thread
( From: Tommy Jonsson ; Subject: Fsck, parent transid verify failed )

so I tried the following things with the result above each time:

      * mount /dev/dm-0 /mnt/raid
      * mount -o degraded /dev/dm-0 /mnt/raid
      * btrfsck /dev/dm-0
      * git clone
        git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git; make and...
      * ./btrfsck /dev/mapper/raid-data
      * ./btrfsck -s 1 /dev/mapper/raid-data
      * ./btrfsck -s 2 /dev/mapper/raid-data
      * for i in `seq 0 50`; do ./btrfsck -s $i /dev/dm-0; done

None of them gave anything different than the previous log.

I don't know exactly what the problem is, I suppose its a kind
half-commited transaction issue, or maybe a problem with a cache-flush
that wrote the superblock (or even the superblocks) before writing the
transaction...

Regards,
Mikael.
