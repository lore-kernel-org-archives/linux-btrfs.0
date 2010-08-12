From: bchociej@gmail.com
Subject: [RFC v2 PATCH 0/6] Btrfs: Add hot data relocation functionality
Date: Thu, 12 Aug 2010 17:22:00 -0500
Message-ID: <1281651726-23501-1-git-send-email-bchociej@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	cmm@us.ibm.com, bcchocie@us.ibm.com, mrlupfer@us.ibm.com,
	crscott@us.ibm.com, bchociej@gmail.com, mlupfer@gmail.com,
	conscott@vt.edu
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

These patches are a replacement for our previous hot data tracking
patches. They include some bugfixes as well as the previously promised
hot data relocation code for moving frequently accessed data to SSD.
Structurally, the patches are quite similar to the first set, with the
notable addition of new hotdata_relocate.{c,h} files. Matt Lupfer and
Conor Scott have done as much of the coding as I have, if not more. So,
many thanks to those guys, along with Mingming Cao, Steve French, Steve
Pratt, and Chris Mason, without which this little project would have
been impossible.


INTRODUCTION:

This patch series adds experimental support for relocation of hot data
to SSD in Btrfs. Essentially, this means maintaining some key stats
(like number of reads/writes, last read/write time, frequency of
reads/writes), then distilling those numbers down to a single
"temperature" value that reflects what data is "hot," and using that
temperature to move data to SSDs.

The long-term goal of these patches is to allow Btrfs to intelligently
utilize SSDs in a heterogenous volume. Incidentally, this project has
been motivated by the Project Ideas page on the Btrfs wiki.

Of course, users are warned not to run this code outside of development
environments. These patches are EXPERIMENTAL, and as such they might eat
your data and/or memory. That said, the code should be relatively safe
when the hotdatatrack and hotdatamove mount options are disabled.


MOTIVATION:

The overall goal of enabling hot data relocation to SSD has been
motivated by the Project Ideas page on the Btrfs wiki at
<https://btrfs.wiki.kernel.org/index.php/Project_ideas>. It is hoped
that this initial patchset will eventually mature into a usable hybrid
storage feature set for Btrfs.

This is essentially the traditional cache argument: SSD is fast and
expensive; HDD is cheap but slow. ZFS, for example, can already take
advantage of SSD caching. Btrfs should also be able to take advantage of
hybrid storage without many broad, sweeping changes to existing code.

With Btrfs's COW approach, an external cache (where data is *moved* to
SSD, rather than just cached there) makes a lot of sense. These patches,
in contrast to the previous version, now enable the hot data relocation
functionality. While performance testing so far has been extremely
basic, the code has shown promising results in random read tests (about
5x throughput by adding an SSD of about 20% of the total capacity of the
volume).


SUMMARY:

- Hooks in existing Btrfs functions to track data access frequency
  (btrfs_direct_IO, btrfs_readpages, and extent_write_cache_pages)

- New rbtrees for tracking access frequency of inodes and sub-file
  ranges (hotdata_map.c)

- A hash list for indexing data by its temperature (hotdata_hash.c)

- A debugfs interface for dumping data from the rbtrees (debugfs.c)

- A background kthread for relocating data to faster media based on
  temperature

- Mount options for enabling temperature tracking (-o hotdatatrack,
  -o hotdatamove; move implies track; both default to disabled)

- An ioctl to retrieve the frequency information collected for a certain
  file

- Ioctls to enable/disable frequency tracking and relocation per inode.


DIFFSTAT:

$ git diff --stat --summary -M

 fs/btrfs/Makefile           |    3 +-
 fs/btrfs/ctree.h            |   96 ++++
 fs/btrfs/debugfs.c          |  532 ++++++++++++++++++++++
 fs/btrfs/debugfs.h          |   89 ++++
 fs/btrfs/disk-io.c          |   28 ++
 fs/btrfs/extent-tree.c      |   62 +++-
 fs/btrfs/extent_io.c        |   34 ++
 fs/btrfs/extent_io.h        |    7 +
 fs/btrfs/hotdata_hash.c     |  338 ++++++++++++++
 fs/btrfs/hotdata_hash.h     |  155 +++++++
 fs/btrfs/hotdata_map.c      |  804 +++++++++++++++++++++++++++++++++
 fs/btrfs/hotdata_map.h      |  167 +++++++
 fs/btrfs/hotdata_relocate.c |  783 ++++++++++++++++++++++++++++++++
 fs/btrfs/hotdata_relocate.h |   73 +++
 fs/btrfs/inode.c            |  164 +++++++-
 fs/btrfs/ioctl.c            |  142 ++++++-
 fs/btrfs/ioctl.h            |   23 +
 fs/btrfs/super.c            |   62 +++-
 fs/btrfs/volumes.c          |   38 ++-
 19 files changed, 3580 insertions(+), 20 deletions(-)

 create mode 100644 fs/btrfs/debugfs.c
 create mode 100644 fs/btrfs/debugfs.h
 create mode 100644 fs/btrfs/hotdata_hash.c
 create mode 100644 fs/btrfs/hotdata_hash.h
 create mode 100644 fs/btrfs/hotdata_map.c
 create mode 100644 fs/btrfs/hotdata_map.h
 create mode 100644 fs/btrfs/hotdata_relocate.c
 create mode 100644 fs/btrfs/hotdata_relocate.h


IMPLEMENTATION (in a nutshell):

Hooks have been added to various functions (btrfs_writepage(s),
btrfs_readpages, btrfs_direct_IO, and extent_write_cache_pages) in
order to track data access patterns. Each of these hooks calls a new
function, btrfs_update_freqs, that records each access to an inode,
possibly including some sub-file-level information as well. A data
structure containing some various frequency metrics gets updated with
the latest access information.

>From there, a hash list takes over the job of figuring out a total
"temperature" value for the data and indexing that temperature for fast
lookup in the future. The function that does the temperature
distillation is rather sensitive and can be tuned/tweaked by altering
various #defined values in hotdata_hash.h.

As for the actual data relocation, a kthread runs periodically that uses
the hashlist to find data eligible for relocation, either
to or from SSD. It then initiates the transfer of the data to the
preferred media type by allocating to an appropriate block group
type on the destination media, based on the temperature of the file and
the speed of the media.

Aside from the core functionality, there is a debugfs interface to spit
out some of the data that is collected, and ioctls are also introduced
to manipulate the new functionality on a per-inode basis.


HOW TO USE HOTDATA RELOCATION:

First, format like this:

	# mkfs.btrfs -h <spinning_disk_blockdev> [any_blockdev] ...

Note that a spinning disk must be the first block device listed, or you
will receive a warning and unexpected behavior. To use hot data tracking
alone, you only need one block device, and it needn't be an SSD. To use
hot data relocation, you should have at least one spinning disk and at
least one SSD. Then...

	# mount -o hotdatamove <any_blockdev> <mountpoint>

Optionally, view information about hot data from debugfs:

	# cat /sys/kernel/debug/btrfs_data/<blockdev>/inode_data
	# cat /sys/kernel/debug/btrfs_data/<blockdev>/range_data


KNOWN ISSUES:
(When hotdatatrack or hotdatamove mount options are enabled)

- Occasional errors (-EIO) from read/write syscalls.

- Heavy file creation workloads encounter high lock contention,
  significantly impacting performance.


FUTURE GOALS:

- Store more information about data temperature / access frequency
  persistently between mounts.

- Track temperature of and relocate metadata (and inline extents) to
  SSD.


Signed-off-by: Ben Chociej <bchociej@gmail.com>
Signed-off-by: Matt Lupfer <mlupfer@gmail.com>
Signed-off-by: Conor Scott <conscott@vt.edu>
Reviewed-by: Mingming Cao <cmm@us.ibm.com>
Reviewed-by: Steve French <smfrench@gmail.com>
