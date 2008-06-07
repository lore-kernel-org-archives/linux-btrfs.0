From: btrfs-devel@arbitraryconstant.com
Subject: btrfs device management
Date: Sat, 7 Jun 2008 17:53:37 -0600 (MDT)
Message-ID: <62325.68.145.107.21.1212882817.squirrel@avalon.arbitraryconstant.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've noticed one mounts btrfs filesystems by device name (eg /dev/sda1),
even in a multi-device filesystem. I see there's a uuid for the filesystem
in btrfs_super_block, so this is safe to do even if the devices change
names in the future, but it's somewhat sub-optimal in that one's fstab
won't necessarily continue to work. Even if the devices themselves have
uuid's that get used in fstab, a given device could just as easily go away
in the future.

I also see the standard Linux mount command is used here, and it's clearly
designed around the assumption of a 1:1 relationship between block devices
and filesystems, with multi-device stuff happening at another layer. One
assumes the btrfs code in the kernel just grabs the uuid from that device
and uses it to assemble the filesystem from whatever devices are also
members.

My question is: are there plans to support mounting by uuid of the
filesystem directly, or by providing something like /dev/btrfs/XXXXX to
make the mount command happy? Wherever this has been done in Linux to date
(eg filesystems, software RAID, LVMs, etc) it's almost always been a good
thing, it would be a step down to eg worry about what order drives were
plugged in.

Thanks for any responses. :)

Cheers,

-Anthony

