From: lutz.euler@freenet.de (Lutz Euler)
Subject: Bulk discard doesn't work after add/delete of devices
Date: Sun, 5 Feb 2012 21:37:13 +0100
Message-ID: <20270.59513.240729.662692@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

... maybe even the block group cache is nonfunctional then?

I am using a btrfs file system, mirrored data and metadata on two SSDs,
and recently tried for the first time to run fstrim on it. fstrim
unexpectedly said "0 bytes were trimmed". strace -T shows that it spends
only a few microseconds in the ioctl system call (basically the overhead
of strace, it seems), so I engaged in some "printk" debugging and found
that after "btrfs_trim_fs" executes its first statement,

  cache = btrfs_lookup_block_group(fs_info, range->start);

cache is 0. As the file system was created with a very recent kernel and
always mounted with the default "space_cache" option I guessed that this
might have something to do with the fact that I exchanged both the
filesystem's devices earlier (as you can see from the devid's in the
following output -- this is the only btrfs file system on the machine):

# btrfs fi show /dev/sda3
Label: none  uuid: 88af7576-3027-4a3b-a5ae-34bfd167982f
	Total devices 2 FS bytes used 28.13GB
	devid    4 size 74.53GB used 38.06GB path /dev/sdb1
	devid    3 size 75.24GB used 38.06GB path /dev/sda3

("exchanged" means: I created the filesystem as a mirror of sdb1 and
sdb2, put data on it, then added sda3, balanced, deleted sdb2, balanced
again, then unmounted, repartitioned sdb1 and sdb2 together as a larger
sdb1, mounted degraded, added sdb1, balanced and deleted "missing".)

So I tried to reproduce this and got the following:

# dd if=/dev/zero of=img0 bs=1 count=0 seek=5G
# dd if=/dev/zero of=img1 bs=1 count=0 seek=5G
# losetup -f img0
# losetup -f img1
# mkfs.btrfs -d raid1 -m raid1 /dev/loop0 /dev/loop1
# mount /dev/loop0 /mnt
# fstrim -v /mnt
/mnt: 4332265472 bytes were trimmed

(The above mentioned kernel instrumentation shows that "cache" was
not 0 here.)

# dd if=/dev/zero of=img2 bs=1 count=0 seek=5G
# losetup -f img2
# btrfs device add /dev/loop2 /mnt
# btrfs device delete /dev/loop0 /mnt
# fstrim -v /mnt
/mnt: 0 bytes were trimmed

("cache" was 0 here.)

Software versions: See my earlier mail about degraded mirrors;
reproducing the issue was on v3.3-rc2-172-g23783f8. I built fstrim
from git, that is, util-linux pulled yesterday from git.kernel.org.

What's going on here?
If the space cache is indeed broken on this filesystem, can I repair
it without risk to my data?
By mounting with "nospace_cache" once or somehow using "clear_cache"?

Greetings,

Lutz
