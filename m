From: Christoph Hellwig <hch@infradead.org>
Subject: Notes on support for multiple devices for a single filesystem
Date: Wed, 17 Dec 2008 08:23:44 -0500
Message-ID: <20081217132343.GA14695@infradead.org>
References: <1227183484.6161.17.camel@think.oraclecorp.com> <1228962896.21376.11.camel@think.oraclecorp.com> <20081211141436.030c2d65.sfr@canb.auug.org.au> <20081210200604.8e190b0d.akpm@linux-foundation.org> <1229006596.22236.46.camel@think.oraclecorp.com> <20081215210323.GB5000@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081215210323.GB5000@webber.adilger.int>
List-ID: <linux-btrfs.vger.kernel.org>

FYI: here's a little writeup I did this summer on support for
filesystems spanning multiple block devices:


-- 

=== Notes on support for multiple devices for a single filesystem ===

== Intro ==

Btrfs (and an experimental XFS version) can support multiple underlying block
devices for a single filesystem instances in a generalized and flexible way.

Unlike the support for external log devices in ext3, jfs, reiserfs, XFS, and
the special real-time device in XFS all data and metadata may be spread over a
potentially large number of block devices, and not just one (or two)


== Requirements ==

We want a scheme to support these complex filesystem topologies in way
that is

 a) easy to setup and non-fragile for the users
 b) scalable to a large number of disks in the system
 c) recoverable without requiring user space running first
 d) generic enough to work for multiple filesystems or other consumers

Requirement a) means that a multiple-device filesystem should be mountable
by a simple fstab entry (UUID/LABEL or some other cookie) which continues
to work when the filesystem topology changes.

Requirement b) implies we must not do a scan over all available block devices
in large systems, but use an event-based callout on detection of new block
devices.

Requirement c) means there must be some version to add devices to a filesystem
by kernel command lines, even if this is not the default way, and might require
additional knowledge from the user / system administrator.

Requirement d) means that we should not implement this mechanism inside a
single filesystem.


== Prior art ==

* External log and realtime volume

The most common way to specify the external log device and the XFS real time
device is to have a mount option that contains the path to the block special
device for it.  This variant means a mount option is always required, and
requires the device name doesn't change, which is enough with udev-generated
unique device names (/dev/disk/by-{label,uuid}).

An alternative way, supported by optionally by ext3 and reiserfs and
exclusively supported by jfs is to open the journal device by the device
number (dev_t) of the block special device.  While this doesn't require
an additional mount option when the device number is stored in the filesystem
superblock it relies on the device number being stable which is getting
increasingly unlikely in complex storage topologies.


* RAID (MD) and LVM

Software RAID and volume managers, although not strictly filesystems,
have a similar very similar problem finding their devices.  The traditional
solution used for early versions of the Linux MD driver and LVM version 1
was to hook into the partitions scanning code and add device with the
right partition type to a kernel-internal list of potential RAID / LVM
devices.  This approach has the advantage of being simple to implement,
fast, reliable and not requiring additional user space programs in the boot
process.  The downside is that it only works with specific partition table
formats that allow specifying a partition type, and doesn't work with
unpartitioned disks at all.  Recent MD setups and LVM2 thus move the scanning
to user space, typically using a command iterating over all block device
nodes and performing the format-specific scanning.  While this is more flexible
than the in-kernel scanning, it scales very badly to a large number of
block devices, and requires additional user space commands to run early
in the boot process.  A variant of this schemes runs a scanning callout
from udev once disk device are detected, which avoids the scanning overhead.


== High-level design considerations ==

Due to requirement b) we need a layer that finds devices for a single
fstab entry.  We can either do this in user space, or in kernel space. As we've
traditionally always done UUID/LABEL to device mapping in userspace, and we
already have libvolume_id and libblkid dealing with the specialized case
of UUID/LABEL to single device mapping I would recommend to keep doing
this in user space and try to reuse the libvolume_id / libblkid.

There are to options to perform the assembly of the device list for
a filesystem:

 1) whenever libvolume_id / libblkid find a device detected as a multi-device
    capable filesystem it gets added to a list of all devices of this
    particular filesystem type.
    On mount type mount(8) or a mount.fstype helpers calls out to the
    libraries to get a list of devices belonging to this filesystem
    type and translates them to device names, which can be passed to
    the kernel on the mount command line.

    Advantage:	    Requires a mount.fstype helper or fs-specific knowledge
    		    in mount(8).
    Disadvantages:  Required libvolume_id / libblkid to keep state.

 2) whenever libvolume_id / libblkid find a device detected as a multi-device
    capable filesystem they call into the kernel through and ioctl / sysfs /
    etc to add it to a list in kernel space.  The kernel code then manages
    to select the right filesystem instances, and either adds it to an already
    running instance, or prepares a list for a future mount.
    
    Advantages:    keeps state in the kernel instead of in libraries
    Disadvantages: requires and additional user interface to mount

c) will be deal with an option that allows adding named block devices
on the mount command line, which is already required for design 1) but
would have to be implemented additionally for design 2).
