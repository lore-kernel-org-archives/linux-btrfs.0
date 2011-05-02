From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v3 0/3] btrfs: quasi-round-robin for chunk allocation
Date: Mon,  2 May 2011 10:47:39 +0200
Message-ID: <cover.1304325641.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In a multi device setup, the chunk allocator currently always allocates
chunks on the devices in the same order. This leads to a very uneven
distribution, especially with RAID1 or RAID10 and an uneven number of
devices.
This patch always sorts the devices before allocating, and allocates the
stripes on the devices with the most available space, as long as there
is enough space available. In a low space situation, it first tries to
maximize striping.
The patch also simplifies the allocator and reduces the checks for
corner cases.
The simplification is done by several means. First, it defines the
properties of each RAID type upfront. These properties are used afterwards
instead of differentiating cases in several places.
Second, the old allocator defined a minimum stripe size for each block
group type, tried to find a large enough chunk, and if this fails just
allocates a smaller one. This is now done in one step. The largest possible
chunk (up to max_chunk_size) is searched and allocated.
Because we now have only one pass, the allocation of the map (struct
map_lookup) is moved down to the point where the number of stripes is
already known. This way we avoid reallocation of the map.
We still avoid allocating stripes that are not a multiple of STRIPE_SIZE.

Changes from v1:
 - split into multiple parts
 - added some comments
 - generated with --patience for better readability

Changes from v2:
 - rebased to current master
 - bugfix for 'single' raid type; the initial parameter initialization lacked
   a case for the 'single' type, thus leaving devs_max at the wrong value

Arne Jansen (3):
  btrfs: move btrfs_cmp_device_free_bytes to super.c
  btrfs: heed alloc_start
  btrfs: quasi-round-robin for chunk allocation

 fs/btrfs/super.c   |   25 +++
 fs/btrfs/volumes.c |  494 ++++++++++++++++++----------------------------------
 fs/btrfs/volumes.h |   16 +--
 3 files changed, 197 insertions(+), 338 deletions(-)

-- 
1.7.3.4

