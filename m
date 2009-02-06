From: Thomas Kuther <gimpel@sonnenkinder.org>
Subject: How do I correctly mount a multidevice volume via fstab?
Date: Fri, 6 Feb 2009 17:58:57 +0000 (UTC)
Message-ID: <loom.20090206T174848-929@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I am using a single volume across two devices sdb7 and sda1, initially
created on sdb7, and added sda1 using btrfs-vol later. The fstab entry:

/dev/disk/by-id/scsi-SATA_ST31000333AS_9TE12DSC-part7
 /mnt/btrfs btrfs defaults 1 2

Now after boot I get:
----
device fsid c4822885057410c-d2d65a83c2f15fb4 devid 1
 transid 73034 /dev/sdb7
btrfs: failed to read chunk tree on sdb7
----

So I have to run btrfsctl -a first, then mounting works. Can this be done
via fstab?

Thanks,
Thomas

