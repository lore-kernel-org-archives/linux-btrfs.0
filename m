From: Chris Mason <chris.mason@oracle.com>
Subject: Online device removal pushed to the unstable tree
Date: Tue, 13 May 2008 16:08:36 -0400
Message-ID: <200805131608.36386.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

The unstable tree is still format compatible with v0.14, and it now includes 
the ability to remove devices online.  In mirror configurations, IO errors to 
one of the mirrors are also handled, although it doesn't currently kick off a 
rebuild or other magic.

To try things out:

mkfs.btrfs -d raid1 -m raid1 /dev/sdb /dev/sdc
mount /dev/sdb /mnt
# put data on /mnt
# then add /dev/sdd to the FS
btrfs-vol -a /dev/sdd /mnt

At this point we've got a raid1 filesystem with data spread across sdb and 
sdc.  If we remove /dev/sdc, all the existing data will be remirrored onto 
sdd:

btrfs-vol -r /dev/sdc /mnt

There is also a mount -o degraded to handle situations where a device in the 
FS has been lost or removed:

mkfs.btrfs -d raid1 -m raid1 /dev/sd[bc]
mount /dev/sdb /mnt
# put data on /mnt
umount /mnt
# corrupt the drive
dd if=/dev/zero of=/dev/sdc bs=1M count=1000

# this mount will fail, dmesg will show that not enough devices were found
mount /dev/sdb /mnt

# this mount will succeed, but only one device will be used
mount -o degraded /dev/sdb /mnt

# add a spare
btrfs-vol -a /dev/sdd /mnt

# remove the corrupted drive
btrfs-vol -r missing /mnt

btrfs-vol -r missing is a special command that tells btrfs to reconstruct 
things without the first device it can find that is mentioned in the metadata 
but not present in the mounted FS.

I plan on hammering on this for a bit and then cutting v0.15

-chris
