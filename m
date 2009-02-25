From: Chris Mason <chris.mason@oracle.com>
Subject: Re: questions about GRUB and BTRFS
Date: Wed, 25 Feb 2009 13:22:20 -0500
Message-ID: <1235586140.32346.37.camel@think.oraclecorp.com>
References: <a3a222ba714187fedfe43fe9f7086242@smtp.arbitraryconstant.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linux btrfs <linux-btrfs@vger.kernel.org>
To: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a3a222ba714187fedfe43fe9f7086242@smtp.arbitraryconstant.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-02-24 at 18:32 -0700, Anthony Roberts wrote:
> Hi,
> 
> A quick googling turns up posts that GRUB support for BTRFS is planned. My
> curiosity is more towards how this will be managed, because the way this is
> currently implemented with software RAID/LVM is quite haphazard. I
> therefore have some questions about GRUB + BTRFS:
> 

So, I haven't looked very hard at the grub code, and expected to start
the btrfs grub support with something very minimal (single device only
configs).

> -With GRUB booting, it's easy to think of awkward use cases and limitations
> unless it's capable of discovering BTRFS instances, and can boot by
> specifying BTRFS UUID + subvolume. That seems quite ambitious, but is this
> planned "eventually"?

Grub today works by giving it a device and a path.  Since all the btrfs
subvolumes can be found from a path, device + path will actually work
with the subvolume support.

> 
> -Might it be possible to tweak the userspace component of GRUB to install
> the bootloader to every member device? This seems necessary for reliable
> booting and rebuilding after a dead disk.

I need to look into the grub code in detail to answer this.

> 
> -64 kb at the beginning of the device is plenty for MBR + GRUB stage 1 +
> 1.5. Might this allow bootable BTRFS without paritions being used at all?
> The space used for partitioning is negligible, however we're on the cusp of
> disks that are too big to partition with MBR, and GPT booting doesn't seem
> well supported yet.
> 

Part of the reason we're 64kb in was to better support bootloaders.

> There's obviously no point in getting worked up about this before
> production ready support is available in the first place. :) However, I am
> curious about what sort of implementation is planned.

In the ideal implementation, the grub.conf has a list of devices it is
allowed to scan, and we put the FS uuid directly in there, let grub scan
them and we'll be able to boot off multiple volumes in that way.

But, that is a significant project, so we'll have to do it in stages.

-chris


