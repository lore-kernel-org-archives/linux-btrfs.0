From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Notes on support for multiple devices for a single filesystem
Date: Wed, 17 Dec 2008 09:53:48 -0500
Message-ID: <1229525628.27170.30.camel@think.oraclecorp.com>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	 <1228962896.21376.11.camel@think.oraclecorp.com>
	 <20081211141436.030c2d65.sfr@canb.auug.org.au>
	 <20081210200604.8e190b0d.akpm@linux-foundation.org>
	 <1229006596.22236.46.camel@think.oraclecorp.com>
	 <20081215210323.GB5000@webber.adilger.int>
	 <20081217132343.GA14695@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andreas Dilger <adilger@sun.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>,
	Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081217132343.GA14695@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-12-17 at 08:23 -0500, Christoph Hellwig wrote:
> FYI: here's a little writeup I did this summer on support for
> filesystems spanning multiple block devices:
> 
> 

Thanks Christoph, I'll start with a description of what btrfs does
today.

Every Btrfs filesystem has a uuid, and a tree that stores all the device
uuids that belong to the FS uuid.

Every btrfs device has a device uuid and a super block that indicates
which FS uuid it belongs to.

The btrfs kernel module holds a list of the FS uuids found and the
devices that belong to each one.  This list is populated by a block
device scanning ioctl that opens a bdev and checks for btrfs supers.

I tried to keep this code as simple as possible because I knew we'd end
up replacing it.  At mount time, btrfs makes sure the devices found by
scanning match the devices the FS expected to find.

btrfsctl -a scans all of /dev calling the scan ioctl on each device and
btrfsctl -A /dev/xxxx just calls the ioctl on a single device.

No scanning is required for a single device filesystem.  After the scan
is done, sending any device in a multi-device filesystem is enough for
the kernel to mount the FS.  IOW:

mkfs.btrfs /dev/sdb ; mount /dev/sdb /mnt just works.
mkfs.btrfs /dev/sdb /dev/sdc ; mount /dev/sdb /mnt also works

(mkfs.btrfs calls the ioctl on multi-device filesystems).

UUIDS and labels are important in large systems, but if the admin knows
a given device is part of an FS, they are going to expect to be able to
send that one device to mount and have things work.

Even though btrfs currently maintains the device list in the kernel, I'm
happy to move it into a userland api once we settle on one.  Kay has
some code so that udev can discover the btrfs device<->FS uuid mappings,
resulting in a tree like this:

  $ tree /dev/btrfs/
  /dev/btrfs/
  |-- 0cdedd75-2d03-41e6-a1eb-156c0920a021
  |   |-- 897fac06-569c-4f45-a0b9-a1f91a9564d4 -> ../../sda10
  |   `-- aac20975-b642-4650-b65b-b92ce22616f2 -> ../../sda9
  `-- a1ec970a-2463-414e-864c-2eb8ac4e1cf2
      |-- 4d1f1fff-4c6b-4b87-8486-36f58abc0610 -> ../../sdb2
      `-- e7fe3065-c39f-4295-a099-a89e839ae350 -> ../../sdb1

It makes sense to me to use /dev/multi-device/ instead of /dev/btrfs/,
I'm fine with anything really.

-chris


