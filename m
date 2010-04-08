From: David Brown <btrfs@davidb.org>
Subject: UUID of subvolumes
Date: Thu, 8 Apr 2010 08:51:42 -0700
Message-ID: <20100408155141.GA14330@arch.davidb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I am developing backup software (<http://github.com/d3zd3z/jpool> for
the curious), and have been doing some testing with btrfs.

Jpool currently uses the blkid database to map between device numbers
(st_rdev) and the uuid of a particular filesystem.  I originally
created this because LVM device numbers sometimes changed.  Jpool
uses the uuid to track files within a tree.

The subvolumes on btrfs seem to be getting ephemeral device numbers,
which aren't listed in the blkid output.  The program falls back to
using the mountpoint, but that misses mountpoints changing.

   - Do subvolumes in btrfs even have separate uuids, and should they?

   - Is there any way for me to map a particular st_rdev value to a
     particular filesystem/subvolume?

   - btrfs seems to allow me to rename subvolumes, so this doesn't seem
     like a particularly good value to use as a key.  The device number
     can change depending on what else might be used.

   - Any other ideas on a unique key I could use for a given subvolume
     to identify the files on that volume, even if it moves around?

Thanks,
David Brown
