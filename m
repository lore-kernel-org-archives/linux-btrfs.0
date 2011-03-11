From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [PATCH v2 0/6] btrfs: scrub
Date: Fri, 11 Mar 2011 11:17:20 -0500
Message-ID: <4D7A4B10.7050904@gmail.com>
References: <cover.1299854593.git.sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	jansen@webgods.de
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1299854593.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/11/2011 09:49 AM, Arne Jansen wrote:
> This series adds an initial implementation for scrub. It works quite
> straightforward. The usermode issues an ioctl for each device in the
> fs. For each device, it enumerates the allocated device chunks. For
> each chunk, the contained extents are enumerated and the data checksums
> fetched. The extents are read sequentially and the checksums verified.
> If an error occurs (checksum or EIO), a good copy is searched for. If
> one is found, the bad copy will be rewritten.
> All enumerations happen from the commit roots. During a transaction
> commit, the scrubs get paused and afterwards continue from the new
> roots.
> For future improvements please see the inline comments.
>
> The accompanying user mode patches will follow shortly.
>
> This v2 mainly changes the dev_info ioctl interface.
>
> Thanks,
> Arne
>

Great work!

I do wonder if we should also worry about the unallocated part of the storage 
device. Often, with local disks specifically, your unused space might accumulate 
errors over time.

What you add to your scrub phase is a simple read operation for the unallocated 
ranges (optionally a READ_VERIFY which validates the data on platter without 
transferring data over the bus to the host).

The recovery operation here would be to write (zeros) to the block if an error 
is detected, so we might be pessimistic and simply use write to "zero" those 
unallocated ranges as well.  Note that there are "WRITE_SAME" commands that RAID 
people use for initializing unused drives for example.

I would not run the overwrite or read check on SSD or arrays so this would be an 
optional type of scrub I suppose.

Regards,

Ric

> Arne Jansen (5):
>    btrfs: add parameter to btrfs_lookup_csum_range
>    btrfs: make struct map_lookup public
>    btrfs: add scrub code and prototypes
>    btrfs: sync scrub with commit&  device removal
>    btrfs: add state information for scrub
>
> Jan Schmidt (1):
>    btrfs: new ioctls for scrub
>
>   fs/btrfs/Makefile      |    2 +-
>   fs/btrfs/ctree.h       |   46 ++-
>   fs/btrfs/disk-io.c     |   16 +
>   fs/btrfs/file-item.c   |    8 +-
>   fs/btrfs/inode.c       |    2 +-
>   fs/btrfs/ioctl.c       |  131 +++++
>   fs/btrfs/ioctl.h       |   55 ++
>   fs/btrfs/relocation.c  |    2 +-
>   fs/btrfs/scrub.c       | 1463 ++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/btrfs/transaction.c |    3 +
>   fs/btrfs/tree-log.c    |    6 +-
>   fs/btrfs/volumes.c     |   16 +-
>   fs/btrfs/volumes.h     |   17 +
>   13 files changed, 1743 insertions(+), 24 deletions(-)
>   create mode 100644 fs/btrfs/scrub.c
>

