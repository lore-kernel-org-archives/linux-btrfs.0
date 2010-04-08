From: Karel Zak <kzak@redhat.com>
Subject: Re: UUID of subvolumes
Date: Fri, 9 Apr 2010 00:57:05 +0200
Message-ID: <20100408225705.GJ7858@nb.net.home>
References: <20100408155141.GA14330@arch.davidb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: David Brown <btrfs@davidb.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100408155141.GA14330@arch.davidb.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 08, 2010 at 08:51:42AM -0700, David Brown wrote:
> I am developing backup software (<http://github.com/d3zd3z/jpool> for
> the curious), and have been doing some testing with btrfs.
>
> Jpool currently uses the blkid database to map between device numbers
> (st_rdev) and the uuid of a particular filesystem.  I originally
> created this because LVM device numbers sometimes changed.  Jpool
> uses the uuid to track files within a tree.
>
> The subvolumes on btrfs seem to be getting ephemeral device numbers,
> which aren't listed in the blkid output.  The program falls back to
> using the mountpoint, but that misses mountpoints changing.
>
>   - Do subvolumes in btrfs even have separate uuids, and should they?

I think yes, in libblkid code is:

   blkid_probe_set_uuid(pr, bfs->fsid);
   blkid_probe_set_uuid_as(pr, bfs->dev_item.uuid, "UUID_SUB");

so there should be two UUIDs for the device.

However, I'd like to see more information about btrfs UUIDs.

BTW, see my old discussion with Andreas about UUIDs:
http://marc.info/?l=linux-fsdevel&m=126754081900406&w=2

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
