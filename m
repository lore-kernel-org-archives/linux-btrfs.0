From: Christoph Hellwig <hch@infradead.org>
Subject: Re: btrfs device management
Date: Mon, 9 Jun 2008 02:43:58 -0400
Message-ID: <20080609064358.GA27849@infradead.org>
References: <62325.68.145.107.21.1212882817.squirrel@avalon.arbitraryconstant.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: btrfs-devel@arbitraryconstant.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <62325.68.145.107.21.1212882817.squirrel@avalon.arbitraryconstant.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 07, 2008 at 05:53:37PM -0600, btrfs-devel@arbitraryconstant.com wrote:
> Hello,
> 
> I've noticed one mounts btrfs filesystems by device name (eg /dev/sda1),
> even in a multi-device filesystem. I see there's a uuid for the filesystem
> in btrfs_super_block, so this is safe to do even if the devices change
> names in the future, but it's somewhat sub-optimal in that one's fstab
> won't necessarily continue to work. Even if the devices themselves have
> uuid's that get used in fstab, a given device could just as easily go away
> in the future.

You can mount by uuid, altough not yet a multi-device btrfs setup.

> I also see the standard Linux mount command is used here, and it's clearly
> designed around the assumption of a 1:1 relationship between block devices
> and filesystems, with multi-device stuff happening at another layer. One
> assumes the btrfs code in the kernel just grabs the uuid from that device
> and uses it to assemble the filesystem from whatever devices are also
> members.

It doesn't even automatically assemble all other devices.

> My question is: are there plans to support mounting by uuid of the
> filesystem directly, or by providing something like /dev/btrfs/XXXXX to
> make the mount command happy? Wherever this has been done in Linux to date
> (eg filesystems, software RAID, LVMs, etc) it's almost always been a good
> thing, it would be a step down to eg worry about what order drives were
> plugged in.

Yes, I plan to work on adding properly designed multiple device support
for btrfs and my upcoming similar xfs work.  I'll live in good old mount
and libvolume_id.

