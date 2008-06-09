From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs device management
Date: Sun, 8 Jun 2008 21:45:59 -0400
Message-ID: <200806082145.59734.chris.mason@oracle.com>
References: <62325.68.145.107.21.1212882817.squirrel@avalon.arbitraryconstant.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: btrfs-devel@arbitraryconstant.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <62325.68.145.107.21.1212882817.squirrel@avalon.arbitraryconstant.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 07 June 2008, btrfs-devel@arbitraryconstant.com wrote:
> Hello,
>
> I've noticed one mounts btrfs filesystems by device name (eg /dev/sda1),
> even in a multi-device filesystem. I see there's a uuid for the filesystem
> in btrfs_super_block, so this is safe to do even if the devices change
> names in the future, but it's somewhat sub-optimal in that one's fstab
> won't necessarily continue to work. Even if the devices themselves have
> uuid's that get used in fstab, a given device could just as easily go away
> in the future.
>
> I also see the standard Linux mount command is used here, and it's clearly
> designed around the assumption of a 1:1 relationship between block devices
> and filesystems, with multi-device stuff happening at another layer. One
> assumes the btrfs code in the kernel just grabs the uuid from that device
> and uses it to assemble the filesystem from whatever devices are also
> members.
>
> My question is: are there plans to support mounting by uuid of the
> filesystem directly, or by providing something like /dev/btrfs/XXXXX to
> make the mount command happy? Wherever this has been done in Linux to date
> (eg filesystems, software RAID, LVMs, etc) it's almost always been a good
> thing, it would be a step down to eg worry about what order drives were
> plugged in.
>
> Thanks for any responses. :)

Btrfs does something similar to LVM for device management, there is a scanning 
program that finds btrfs volumes and populates a kernel table matching 
filesystem uuid to devices.  So, if /dev/sdb becomes /dev/sdc, btrfs will 
still do the right thing.

Btrfs doesn't actually store device path names in the FS metadata, so it has 
no idea that /dev/sdb is part of your FS.  It just scans super blocks and is 
able to mount them wherever it finds them.

This means the device you pass to mount is going to move around as the devices 
move which is kind of awkward.  Longer term, it'll move to a udev helper 
style setup that puts links into a /dev/btrfs/by-uuid and /dev/btrfs/by-label

See the btrfs-show command for an example of how the scanning is done if 
you're in a patching mood.  It could populate the /dev/btrfs directory 
directly.

-chris
