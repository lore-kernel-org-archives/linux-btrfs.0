From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Notes on support for multiple devices for a single filesystem
Date: Wed, 17 Dec 2008 15:50:45 +0100
Message-ID: <ac3eb2510812170650j404edfb1h38aa86bbe3ffa2e@mail.gmail.com>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	 <1228962896.21376.11.camel@think.oraclecorp.com>
	 <20081211141436.030c2d65.sfr@canb.auug.org.au>
	 <20081210200604.8e190b0d.akpm@linux-foundation.org>
	 <1229006596.22236.46.camel@think.oraclecorp.com>
	 <20081215210323.GB5000@webber.adilger.int>
	 <20081217132343.GA14695@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Andreas Dilger" <adilger@sun.com>,
	"Chris Mason" <chris.mason@oracle.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Stephen Rothwell" <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Christoph Hellwig" <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081217132343.GA14695@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 17, 2008 at 14:23, Christoph Hellwig <hch@infradead.org> wrote:
> === Notes on support for multiple devices for a single filesystem ===
>
> == Intro ==
>
> Btrfs (and an experimental XFS version) can support multiple underlying block
> devices for a single filesystem instances in a generalized and flexible way.
>
> Unlike the support for external log devices in ext3, jfs, reiserfs, XFS, and
> the special real-time device in XFS all data and metadata may be spread over a
> potentially large number of block devices, and not just one (or two)
>
>
> == Requirements ==
>
> We want a scheme to support these complex filesystem topologies in way
> that is
>
>  a) easy to setup and non-fragile for the users
>  b) scalable to a large number of disks in the system
>  c) recoverable without requiring user space running first
>  d) generic enough to work for multiple filesystems or other consumers
>
> Requirement a) means that a multiple-device filesystem should be mountable
> by a simple fstab entry (UUID/LABEL or some other cookie) which continues
> to work when the filesystem topology changes.
>
> Requirement b) implies we must not do a scan over all available block devices
> in large systems, but use an event-based callout on detection of new block
> devices.
>
> Requirement c) means there must be some version to add devices to a filesystem
> by kernel command lines, even if this is not the default way, and might require
> additional knowledge from the user / system administrator.
>
> Requirement d) means that we should not implement this mechanism inside a
> single filesystem.
>
>
> == Prior art ==
>
> * External log and realtime volume
>
> The most common way to specify the external log device and the XFS real time
> device is to have a mount option that contains the path to the block special
> device for it.  This variant means a mount option is always required, and
> requires the device name doesn't change, which is enough with udev-generated
> unique device names (/dev/disk/by-{label,uuid}).
>
> An alternative way, supported by optionally by ext3 and reiserfs and
> exclusively supported by jfs is to open the journal device by the device
> number (dev_t) of the block special device.  While this doesn't require
> an additional mount option when the device number is stored in the filesystem
> superblock it relies on the device number being stable which is getting
> increasingly unlikely in complex storage topologies.
>
>
> * RAID (MD) and LVM
>
> Software RAID and volume managers, although not strictly filesystems,
> have a similar very similar problem finding their devices.  The traditional
> solution used for early versions of the Linux MD driver and LVM version 1
> was to hook into the partitions scanning code and add device with the
> right partition type to a kernel-internal list of potential RAID / LVM
> devices.  This approach has the advantage of being simple to implement,
> fast, reliable and not requiring additional user space programs in the boot
> process.  The downside is that it only works with specific partition table
> formats that allow specifying a partition type, and doesn't work with
> unpartitioned disks at all.  Recent MD setups and LVM2 thus move the scanning
> to user space, typically using a command iterating over all block device
> nodes and performing the format-specific scanning.  While this is more flexible
> than the in-kernel scanning, it scales very badly to a large number of
> block devices, and requires additional user space commands to run early
> in the boot process.  A variant of this schemes runs a scanning callout
> from udev once disk device are detected, which avoids the scanning overhead.
>
>
> == High-level design considerations ==
>
> Due to requirement b) we need a layer that finds devices for a single
> fstab entry.  We can either do this in user space, or in kernel space. As we've
> traditionally always done UUID/LABEL to device mapping in userspace, and we
> already have libvolume_id and libblkid dealing with the specialized case
> of UUID/LABEL to single device mapping I would recommend to keep doing
> this in user space and try to reuse the libvolume_id / libblkid.
>
> There are to options to perform the assembly of the device list for
> a filesystem:
>
>  1) whenever libvolume_id / libblkid find a device detected as a multi-device
>    capable filesystem it gets added to a list of all devices of this
>    particular filesystem type.
>    On mount type mount(8) or a mount.fstype helpers calls out to the
>    libraries to get a list of devices belonging to this filesystem
>    type and translates them to device names, which can be passed to
>    the kernel on the mount command line.
>
>    Advantage:      Requires a mount.fstype helper or fs-specific knowledge
>                    in mount(8).
>    Disadvantages:  Required libvolume_id / libblkid to keep state.
>
>  2) whenever libvolume_id / libblkid find a device detected as a multi-device
>    capable filesystem they call into the kernel through and ioctl / sysfs /
>    etc to add it to a list in kernel space.  The kernel code then manages
>    to select the right filesystem instances, and either adds it to an already
>    running instance, or prepares a list for a future mount.
>
>    Advantages:    keeps state in the kernel instead of in libraries
>    Disadvantages: requires and additional user interface to mount
>
> c) will be deal with an option that allows adding named block devices
> on the mount command line, which is already required for design 1) but
> would have to be implemented additionally for design 2).

Sounds all sensible. Btrfs already stores the (possibly incomplete)
device tree state in the kernel, which should make things pretty easy
for userspace, compared to other already existing subsystems.

We could have udev maintain a btrfs volume tree:
  /dev/btrfs/
  |-- 0cdedd75-2d03-41e6-a1eb-156c0920a021
  |   |-- 897fac06-569c-4f45-a0b9-a1f91a9564d4 -> ../../sda10
  |   `-- aac20975-b642-4650-b65b-b92ce22616f2 -> ../../sda9
  `-- a1ec970a-2463-414e-864c-2eb8ac4e1cf2
      |-- 4d1f1fff-4c6b-4b87-8486-36f58abc0610 -> ../../sdb2
      `-- e7fe3065-c39f-4295-a099-a89e839ae350 -> ../../sdb1

At the same time, by-uuid/ is created:
  /dev/disk/by-uuid/
  |-- 0cdedd75-2d03-41e6-a1eb-156c0920a021 -> ../../sda10
  |-- a1ec970a-2463-414e-864c-2eb8ac4e1cf2 -> ../../sdb2
  ...

And possibly by-label/:
  /dev/disk/by-label/
  |-- butter-butter -> ../../sda10
  ...

The by-uuid/, by-label/ links always get overwritten by the last
device claiming that name (unless udev rules specify a "link priority"
for specific devices, which might not make sense for btrfs).

With the udev rules that maintain the /dev/btrfs/ tree, we can just
plug in "btrfs -A" calls, to make the device known to the kernel.

If possible, "btrfsctrl -A" could return the updated state of the
in-kernel device tree. If it is complete, we can send out an event to
possibly trigger the mounting. This model should just work fine in
initramfs too.

For recue and recovery cases, it will still be nice to be able to
trigger "scan all devices" code in btrfsctrl (own code or libbklid),
but it should be avoided in any normal operation mode.

Thanks,
Kay
