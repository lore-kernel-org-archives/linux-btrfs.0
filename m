Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:63213 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751496AbdJVKyX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Oct 2017 06:54:23 -0400
Subject: Re: [PATCH 1/1] btrfs-progs: docs: annual typo, clarity, & grammar
 review & fixups
To: Nicholas D Steeves <nsteeves@gmail.com>, linux-btrfs@vger.kernel.org
References: <20171022000046.9000-1-nsteeves@gmail.com>
 <20171022000046.9000-2-nsteeves@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <25ead4df-d964-ecac-4c48-5ec20b52ff45@gmx.com>
Date: Sun, 22 Oct 2017 18:54:16 +0800
MIME-Version: 1.0
In-Reply-To: <20171022000046.9000-2-nsteeves@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Nicholas,

Thanks for the documentation update.
Since I'm not a native English speaker, I may not help much to organize
the sentence, but I can help to explain the question noted in the
modification.

On 2017年10月22日 08:00, Nicholas D Steeves wrote:
> In one big patch, as requested
> 
> Signed-off-by: Nicholas D Steeves <nsteeves@gmail.com>
> ---
>  Documentation/btrfs-balance.asciidoc          | 12 ++++-----
>  Documentation/btrfs-check.asciidoc            | 17 ++++++-------
>  Documentation/btrfs-convert.asciidoc          | 21 ++++++++--------
>  Documentation/btrfs-device.asciidoc           |  6 ++---
>  Documentation/btrfs-filesystem.asciidoc       | 18 +++++++-------
>  Documentation/btrfs-find-root.asciidoc        |  2 +-
>  Documentation/btrfs-inspect-internal.asciidoc |  8 +++---
>  Documentation/btrfs-man5.asciidoc             | 36 ++++++++++++++-------------
>  Documentation/btrfs-map-logical.asciidoc      |  2 +-
>  Documentation/btrfs-qgroup.asciidoc           |  8 +++---
>  Documentation/btrfs-quota.asciidoc            | 18 +++++++-------
>  Documentation/btrfs-receive.asciidoc          |  2 +-
>  Documentation/btrfs-replace.asciidoc          |  6 ++---
>  Documentation/btrfs-rescue.asciidoc           |  2 +-
>  Documentation/btrfs-scrub.asciidoc            |  4 +--
>  Documentation/btrfs-send.asciidoc             | 11 ++++----
>  Documentation/btrfs-subvolume.asciidoc        | 15 +++++------
>  Documentation/btrfs.asciidoc                  | 14 +++++------
>  Documentation/btrfstune.asciidoc              | 13 +++++-----
>  Documentation/fsck.btrfs.asciidoc             |  8 +++---
>  Documentation/mkfs.btrfs.asciidoc             | 10 ++++----
>  21 files changed, 119 insertions(+), 114 deletions(-)
> 
> diff --git a/Documentation/btrfs-balance.asciidoc b/Documentation/btrfs-balance.asciidoc
> index cc81de91..f471be3b 100644
> --- a/Documentation/btrfs-balance.asciidoc
> +++ b/Documentation/btrfs-balance.asciidoc
> @@ -21,7 +21,7 @@ filesystem.
>  The balance operation is cancellable by the user. The on-disk state of the
>  filesystem is always consistent so an unexpected interruption (eg. system crash,
>  reboot) does not corrupt the filesystem. The progress of the balance operation
> -is temporarily stored and will be resumed upon mount, unless the mount option
> +****is temporarily stored**** (EDIT: where is it stored?) and will be resumed upon mount, unless the mount option

To be specific, they are stored in data reloc tree and tree reloc tree.

Data reloc tree stores the data/metadata written to new location.

And tree reloc tree is kind of special snapshot for each tree whose tree
block is get relocated during the relocation.

>  'skip_balance' is specified.
>  
>  WARNING: running balance without filters will take a lot of time as it basically
> @@ -200,11 +200,11 @@ section 'PROFILES'.
>  ENOSPC
>  ------
>  
> -The way balance operates, it usually needs to temporarily create a new block
> +****The way balance operates, it usually needs to temporarily create a new block
>  group and move the old data there. For that it needs work space, otherwise
>  it fails for ENOSPC reasons.
>  This is not the same ENOSPC as if the free space is exhausted. This refers to
> -the space on the level of block groups.
> +the space on the level of block groups.**** (EDIT: What is the relationship between the new block group and the work space?  Is the "old data" removed from the new block group?  Please say something about block groups to clarify)

Here I think we're talking about allocating new block group, so it's
using unallocated space.

While for normal space usage, we're allocating from *allocated* block
group space.

So there are two levels of space allocation:

1) Extent level
   Always allocated from existing block group (or chunk).
   Data extent, tree block allocation are all happening at this level.

2) Block group (or chunk, which are the same) level
   Always allocated from free device space.

I think the original sentence just wants to address this.

>  
>  The free work space can be calculated from the output of the *btrfs filesystem show*
>  command:
> @@ -227,7 +227,7 @@ space. After that it might be possible to run other filters.
>  
>  Conversion to profiles based on striping (RAID0, RAID5/6) require the work
>  space on each device. An interrupted balance may leave partially filled block
> -groups that might consume the work space.
> +groups that ****might**** (EDIT: is this 2nd level of uncertainty necessary?) consume the work space.
>  
>  EXAMPLES
>  --------
> @@ -238,7 +238,7 @@ can be found in section 'TYPICAL USECASES' of `btrfs-device`(8).
>  MAKING BLOCK GROUP LAYOUT MORE COMPACT
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[snip]
> @@ -3,7 +3,7 @@ btrfs-filesystem(8)
>  
>  NAME
>  ----
> -btrfs-filesystem - command group of btrfs that usually work on the whole filesystem
> +btrfs-filesystem - command group that primarily does work on whole filesystems
>  
>  SYNOPSIS
>  --------
> @@ -53,8 +53,8 @@ not total size of filesystem.
>  when the filesystem is full. Its 'total' size is dynamic based on the
>  filesystem size, usually not larger than 512MiB, 'used' may fluctuate.
>  +
> -The global block reserve is accounted within Metadata. In case the filesystem
> -metadata are exhausted, 'GlobalReserve/total + Metadata/used = Metadata/total'.
> +The global block reserve is accounted within Metadata. ****In case the filesystem
> +metadata are exhausted, 'GlobalReserve/total + Metadata/used = Metadata/total'.**** (EDIT: s/are/is/? And please write more for clarity. Is "global block reserve" part of GlobalReserve that is accounted within Metadata?  Isn't all of GlobalReserve's metadata accounted within Metadata?  eg: "global block reserve" is the data portion of GlobalReserve, but all metadata is accounted for in Metadata.)

GlobalReserve is accounted as Metadata, but most of time it's just as a
buffer until we really run out of metadata space.

It's like metadata headroom reserved for really important time.

So under most situation, the GlobalReserve usage should be 0.
And it's not accounted as Meta/used. (so, if there is Meta/free, then it
belongs to Meta/free)

But when GlobalReserve/used is not 0, the used part is accounted to
Meta/Used, and the unused part (GlobalReserve/free if exists) belongs to
Meta/free.

Not sure how to explain it better.

>  +
>  `Options`
>  +
> @@ -93,10 +93,10 @@ You can also turn on compression in defragment operations.
>  +
>  WARNING: Defragmenting with Linux kernel versions < 3.9 or ≥ 3.14-rc2 as well as
>  with Linux stable kernel versions ≥ 3.10.31, ≥ 3.12.12 or ≥ 3.13.4 will break up
> -the ref-links of COW data (for example files copied with `cp --reflink`,
> +the reflinks of COW data (for example files copied with `cp --reflink`,
>  snapshots or de-duplicated data).
>  This may cause considerable increase of space usage depending on the broken up
> -ref-links.
> +reflinks.
>  +
[snip]
> +broken up reflinks.
>  
>  *barrier*::
>  *nobarrier*::
>  (default: on)
>  +
>  Ensure that all IO write operations make it through the device cache and are stored
> -permanently when the filesystem is at it's consistency checkpoint. This
> +permanently when the filesystem is at ****(EDIT: "its" or "one of its" consistency checkpoint[s])****. This

I think it is "one of its", as there are in fact 2 checkpoints for btrfs:
1) Normal transaction commitment
2) Log tree commitment
   Which only commits the log trees and log tree root.

But I'm not really sure if log tree commitment is also under the control
of barrier.

>  typically means that a flush command is sent to the device that will
>  synchronize all pending data and ordinary metadata blocks, then writes the
>  superblock and issues another flush.
> @@ -120,7 +120,7 @@ but a warning is printed if it's more than 300 seconds (5 minutes).
>  Control BTRFS file data compression.  Type may be specified as 'zlib',
>  'lzo', 'zstd' or 'no' (for no compression, used for remounting).  If no type
>  is specified, 'zlib' is used.  If 'compress-force' is specified,
> -the compression will allways be attempted, but the data may end up uncompressed
> +then compression will always be attempted, but the data may end up uncompressed
>  if the compression would make them larger.
>  +
>  Otherwise some simple heuristics are applied to detect an incompressible file.
> @@ -174,17 +174,19 @@ system at that point.
>  *nodiscard*::
>  (default: off)
>  +
> -Enable discarding of freed file blocks using TRIM operation.  This is useful
> -for SSD devices, thinly provisioned LUNs or virtual machine images where the
> -backing device understands the operation. Depending on support of the
> -underlying device, the operation may severely hurt performance in case the TRIM
> -operation is synchronous (eg. with SATA devices up to revision 3.0).
> +Enable discarding of freed file blocks. This is useful for SSD devices, thinly
> +provisioned LUNs, or virtual machine images; however, every storage layer must
> +support discard for it to work. If the backing device does not support
> +asynchronous queued TRIM, then this operation can severely degrade performance,
> +because a synchronous TRIM operation will be attempted instead. Queued TRIM
> +requires newer than SATA revision 3.1 chipsets and devices.
>  +
> -If discarding is not necessary to be done at the block freeing time, there's
> -`fstrim` tool that lets the filesystem discard all free blocks in a batch,
> -possibly not much interfering with other operations. Also, the the device may
> -ignore the TRIM command if the range is too small, so running the batch discard
> -can actually discard the blocks.
> +If it is not necessary to immediately discard freed blocks, then the `fstrim`
> +tool can be used to discard all free blocks in a batch. Scheduling a TRIM
> +during a period of low system activity will prevent latent interference with
> +the performance of other operations. Also, a device may ignore the TRIM command
> +if the range is too small, so running a batch discard has a greater probability
> +of actually discarding the blocks.
>  
>  *enospc_debug*::
>  *noenospc_debug*::
> @@ -334,7 +336,7 @@ command may be run on a 'v2' filesystem by clearing the cache, running the
>  command, and then remounting with 'space_cache=v2'.
>  +
>  If a version is not explicitly specified, the default implementation will be
> -chosen, which is 'v1' as of 4.9.
> +chosen, which is 'v1' as of ****4.9.**** (EDIT: needs update for 4.14)

What about just saying 'v1' is the default?
Since we're not defaulting to 'v2' space cache tree yet.

>  
>  *sync* <path> [subvolid...]::
> -Wait until given subvolume(s) are completely removed from the filesystem
> -after deletion. If no subvolume id is given, wait until all current  deletion
> -requests are completed, but do not wait for subvolumes deleted meanwhile.
> -The status of subvolume ids is checked periodically.
> +Wait until given subvolume[s] are completely removed from the filesystem after
> +deletion. If no subvolume id is given, wait until all current deletion requests
> +are completed, but do not wait for subvolumes deleted in the meantime.  ****The
> +status of subvolume ids is checked periodically.**** (EDIT: How is the relevant to sync?  Should it read "the status of all subvolume ids are periodically synced as a normal background operation"?)

The background is, subvolume deletion is expensive for btrfs, so
subvolume deletion is split into 2 stages:
1) Unlike the subvolume
   So no one can access the deleted subvolume

2) Delete the subvolume tree blocks and its data in background
   And for tree blocks, we skip the normal tree balance, to speed up the
   deletion.

I think the original sentence means we won't wait for the 2nd stage.

>  +
>  `Options`
>  +
> diff --git a/Documentation/btrfs.asciidoc b/Documentation/btrfs.asciidoc
[snip]
>  DESCRIPTION
>  -----------
> -*btrfstune* can be used to enable, disable or set various filesystem
> +*btrfstune* can be used to enable, disable, or set various filesystem
>  parameters. The filesystem must be unmounted.
>  
>  The common usecase is to enable features that were not enabled at mkfs time.
> @@ -20,8 +20,8 @@ complete list of features and kernel version of their introduction at
>  https://btrfs.wiki.kernel.org/index.php/Changelog#By_feature .  Also, the
>  manual page `mkfs.btrfs`(8) contains more details about the features.
>  
> -Some of the features could be enabled on a mounted filesystem. Please refer to
> -the respective section in `btrfs`(5).
> +****Some of these features can be enabled on a mounted filesystem. Please refer to
> +the respective section in `btrfs`(5).**** (EDIT: Some of these features can be enabled/toggled on a mounted filesystem, even though "The filesystem must be unmounted" is at the top of the Description?  If this is the cases then "The filesystem must usually be unmounted" or "The filesystem must be umounted except for change x, y, and z".  Or maybe "The functionality merged into the main btrfs tool allows x,y,z operations on a mounted filesystem; however, a,b,c can only be performed with btrfstune on an unmounted filesystem.  Additionally what is/are the "respective section[s]" in btrfs(5)?)

I need to recheck the code to see make sure.

>  
>  OPTIONS
>  -------
> @@ -86,9 +86,10 @@ EXIT STATUS
>  
>  COMPATIBILITY NOTE
>  ------------------
> -This tool exists for historical reasons but is still in use today.  The
> -functionality is about to be merged to the main tool someday and *btrfstune*
> -will become deprecated and removed afterwards.
> +
> +This depreciated tool exists for historical reasons but is still in use today.  Its
> +functionality will soon be merged to the main tool, at which time *btrfstune*
> +will be declared obsolete and scheduled for removal.
>  
>  SEE ALSO
>  --------
> diff --git a/Documentation/fsck.btrfs.asciidoc b/Documentation/fsck.btrfs.asciidoc
> index 0bad075b..d3853abf 100644
> --- a/Documentation/fsck.btrfs.asciidoc
> +++ b/Documentation/fsck.btrfs.asciidoc
> @@ -13,16 +13,16 @@ DESCRIPTION
>  -----------
>  *fsck.btrfs* is a type of utility that should exist for any filesystem and is
>  called during system setup when the corresponding `/etc/fstab` entries
> -contain non-zero value for `fs_passno` , see `fstab`(5) for more.
> +contain non-zero value for `fs_passno`. See `fstab`(5) for more information.
>  
>  Traditional filesystems need to run their respective fsck utility in case the
>  filesystem was not unmounted cleanly and the log needs to be replayed before
>  mount. This is not needed for BTRFS. You should set fs_passno to 0.
>  
>  If you wish to check the consistency of a BTRFS filesystem or repair a damaged
> -filesystem, see `btrfs-check`(8). By default the filesystem
> -consistency is checked, the repair mode is enabled via '--repair' option (use
> -with care!).
> +filesystem, see `btrfs-check`(8). By default filesystem consistency is checked
> +but not repaired. The repair mode is enabled via the '--repair' option (use with
> +care!).
>  
>  OPTIONS
>  -------
> diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
> index d53d9e26..737e84d0 100644
> --- a/Documentation/mkfs.btrfs.asciidoc
> +++ b/Documentation/mkfs.btrfs.asciidoc
> @@ -27,7 +27,7 @@ Specify the (physical) offset from the start of the device at which allocations
>  start.  The default value is zero.
>  
>  *-b|--byte-count <size>*::
> -Specify the size of the filesystem. If this option is not used,
> +Specify the size of the filesystem. If this option is not used, then
>  mkfs.btrfs uses the entire device space for the filesystem.
>  
>  *-d|--data <profile>*::
> @@ -79,7 +79,7 @@ default value is 16KiB (16384) or the page size, whichever is bigger. Must be a
>  multiple of the sectorsize and a power of 2, but not larger than 64KiB (65536).
>  Leafsize always equals nodesize and the options are aliases.
>  +
> -Smaller node size increases fragmentation but lead to higher b-trees which in
> +Smaller node size increases fragmentation ****but lead to higher b-trees**** (EDIT: "but leads to taller/deeper/more/increased-usage-of b-trees"?) which in

What's the difference between "higher" and "taller"?
Seems quite similar to me though.

>  turn leads to lower locking contention. Higher node sizes give better packing
>  and less fragmentation at the cost of more expensive memory operations while
>  updating the metadata blocks.
> @@ -166,7 +166,7 @@ root partition created with RAID1/10/5/6 profiles. The mount action can happen
>  before all block devices are discovered. The waiting is usually done on the
>  initramfs/initrd systems.
>  
> -As of kernel 4.9, RAID5/6 is still considered experimental and shouldn't be
> +As of kernel ****4.9**** (EDIT: 4.14 status?), RAID5/6 is still considered experimental and shouldn't be

Well, this changed a lot in v4.14. So definitely need to be modified.

At least Oracle is considring RAID5/6 stable. Maybe we'd better to wait
for several other releases to see if this is true.

Thanks,
Qu

>  employed for production use.
>  
>  FILESYSTEM FEATURES
> @@ -281,9 +281,9 @@ The mkfs utility will let the user create a filesystem with profiles that write
>  the logical blocks to 2 physical locations. Whether there are really 2
>  physical copies highly depends on the underlying device type.
>  
> -For example, a SSD drive can remap the blocks internally to a single copy thus
> +For example, a SSD drive can remap the blocks internally to a single copy--thus
>  deduplicating them. This negates the purpose of increased redundancy and just
> -wastes filesystem space without the expected level of redundancy.
> +wastes filesystem space without providing the expected level of redundancy.
>  
>  The duplicated data/metadata may still be useful to statistically improve the
>  chances on a device that might perform some internal optimizations. The actual
> 
