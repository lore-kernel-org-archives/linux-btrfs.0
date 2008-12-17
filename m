From: Andreas Dilger <adilger@sun.com>
Subject: Re: Notes on support for multiple devices for a single filesystem
Date: Wed, 17 Dec 2008 15:04:49 -0700
Message-ID: <20081217220449.GC5000@webber.adilger.int>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
 <1228962896.21376.11.camel@think.oraclecorp.com>
 <20081211141436.030c2d65.sfr@canb.auug.org.au>
 <20081210200604.8e190b0d.akpm@linux-foundation.org>
 <1229006596.22236.46.camel@think.oraclecorp.com>
 <20081215210323.GB5000@webber.adilger.int>
 <20081217132343.GA14695@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20081217132343.GA14695@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Dec 17, 2008  08:23 -0500, Christoph Hellwig wrote:
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

Just as an FYI here - the dev_t stored in the ext3/4 superblock for the
journal device is only a "cached" device.  The journal is properly
identified by its UUID, and should the device mapping change there is a
"journal_dev=" option that can be used to specify the new device.  The
one shortcoming is that there is no mount.ext3 helper which does this 
journal UUID->dev mapping and automatically passes "journal_dev=" if
needed.

> * RAID (MD) and LVM
> 
> Recent MD setups and LVM2 thus move the scanning to user space, typically
> using a command iterating over all block device nodes and performing the
> format-specific scanning.  While this is more flexible
> than the in-kernel scanning, it scales very badly to a large number of
> block devices, and requires additional user space commands to run early
> in the boot process.  A variant of this schemes runs a scanning callout
> from udev once disk device are detected, which avoids the scanning overhead.

My (admittedly somewhat vague) impression is that with large numbers of
devices the udev callout can itself be a huge overhead because this involves
a userspace fork/exec for each new device being added.  For the same
number of devices, a single scan from userspace only requires a single
process, and an equal number of device probes.

Added to this is that the blkid cache can be used to eliminate the need
to do any scanning if the devices have not changed from the previous boot
makes it unclear which mechanism is more efficient.  The drawback is that
the initrd device cache is never going to be up-to-date so it wouldn't
be useful until the root partition is mounted.

We've used blkid for our testing of Lustre-on-DMU with up to 48 (local)
disks w/o any kind of performance issues.  We'll eventually be able to
test on systems with around 400 disks in a JBOD configuration, but until
then we only run on systems with hundreds of disks behind a RAID controller.

> == High-level design considerations ==
> 
> Due to requirement b) we need a layer that finds devices for a single
> fstab entry.  We can either do this in user space, or in kernel space.
> As we've traditionally always done UUID/LABEL to device mapping in
> userspace, and we already have libvolume_id and libblkid dealing with
> the specialized case of UUID/LABEL to single device mapping I would
> recommend to keep doing this in user space and reuse libvolume_id/libblkid.
> 
> There are to options to perform the assembly of the device list for
> a filesystem:
> 
>  1) whenever libvolume_id / libblkid find a device detected as a multi-device
>     capable filesystem it gets added to a list of all devices of this
>     particular filesystem type.
>     On mount type mount(8) or a mount.fstype helpers calls out to the
>     libraries to get a list of devices belonging to this filesystem
>     type and translates them to device names, which can be passed to
>     the kernel on the mount command line.

I would actually suggest that instead of keeping devices in groups by
the filesystem type, rather keep a list of devices with the same UUID
and/or LABEL, and if the mount is looking for this UUID/LABEL it gets
the whole list of matching devices back.

This could also be done in the kernel by having the filesystems register
a "probe" function that examines the device/partitions as they are added,
similar to the way that MD used to do it.  There would likely be very few
probe functions needed, only ext3/4 (for journal devices), btrfs, and
maybe MD, LVM2 and a handful more.

If we wanted to avoid code duplication, this could share code between
libblkid and the kernel (just the enhanced probe-only functions in the
util-linux-ng implementation) since these functions are little more than
"take a pointer, cast it to struct X, check some magic fields and return
match + {LABEL, UUID}, or no-match".

That MD used to check only the partition type doesn't mean that we can't
have simple functions that read the superblock (or equivalent) to make
an internal list of suitable devices attached to a filesystem-type global
structure (possibly split into per-fsUUID sublists if it wants).  When
filesystem X is mounted (using any one device from the filesystem passed
to mount) it can quickly scan this list to find all devices that for that
filesystem's UUID to assemble all of the required devices.

Since the filesystem would internally have to verify the list of devices
that would (somehow) be passed to the kernel during mount this doesn't
really gain much to keep the list in userspace.

>     Advantage:    Requires a mount.fstype helper or fs-specific knowledge
>     		    in mount(8).
>     Disadvantages:  Required libvolume_id / libblkid to keep state.
> 
>  2) whenever libvolume_id / libblkid find a device detected as a multi-device
>     capable filesystem they call into the kernel through and ioctl / sysfs /
>     etc to add it to a list in kernel space.  The kernel code then manages
>     to select the right filesystem instances, and either adds it to an already
>     running instance, or prepares a list for a future mount.

While not performance critical, this seems that calling into userspace
just to call back down into the kernel is more complex than it needs to
be (i.e. prone to failure).

I'm not stuck on doing this in the kernel, just thinking that the more
components involved the more likely it is that something goes wrong.  I
have enough grief with just initrd not having the right kernel module,
I'd hate to depend on tools to do the device assembly for the root fs.

>     Advantages:    keeps state in the kernel instead of in libraries
>     Disadvantages: requires and additional user interface to mount
> 
> c) will be deal with an option that allows adding named block devices
> on the mount command line, which is already required for design 1) but
> would have to be implemented additionally for design 2).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

