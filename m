Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:46248 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932256AbdJVAA7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Oct 2017 20:00:59 -0400
Received: by mail-qk0-f182.google.com with SMTP id k123so18241797qke.3
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 17:00:59 -0700 (PDT)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nicholas D Steeves <nsteeves@gmail.com>
Subject: [PATCH 1/1] btrfs-progs: docs: annual typo, clarity, & grammar review & fixups
Date: Sat, 21 Oct 2017 20:00:46 -0400
Message-Id: <20171022000046.9000-2-nsteeves@gmail.com>
In-Reply-To: <20171022000046.9000-1-nsteeves@gmail.com>
References: <20171022000046.9000-1-nsteeves@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In one big patch, as requested

Signed-off-by: Nicholas D Steeves <nsteeves@gmail.com>
---
 Documentation/btrfs-balance.asciidoc          | 12 ++++-----
 Documentation/btrfs-check.asciidoc            | 17 ++++++-------
 Documentation/btrfs-convert.asciidoc          | 21 ++++++++--------
 Documentation/btrfs-device.asciidoc           |  6 ++---
 Documentation/btrfs-filesystem.asciidoc       | 18 +++++++-------
 Documentation/btrfs-find-root.asciidoc        |  2 +-
 Documentation/btrfs-inspect-internal.asciidoc |  8 +++---
 Documentation/btrfs-man5.asciidoc             | 36 ++++++++++++++-------------
 Documentation/btrfs-map-logical.asciidoc      |  2 +-
 Documentation/btrfs-qgroup.asciidoc           |  8 +++---
 Documentation/btrfs-quota.asciidoc            | 18 +++++++-------
 Documentation/btrfs-receive.asciidoc          |  2 +-
 Documentation/btrfs-replace.asciidoc          |  6 ++---
 Documentation/btrfs-rescue.asciidoc           |  2 +-
 Documentation/btrfs-scrub.asciidoc            |  4 +--
 Documentation/btrfs-send.asciidoc             | 11 ++++----
 Documentation/btrfs-subvolume.asciidoc        | 15 +++++------
 Documentation/btrfs.asciidoc                  | 14 +++++------
 Documentation/btrfstune.asciidoc              | 13 +++++-----
 Documentation/fsck.btrfs.asciidoc             |  8 +++---
 Documentation/mkfs.btrfs.asciidoc             | 10 ++++----
 21 files changed, 119 insertions(+), 114 deletions(-)

diff --git a/Documentation/btrfs-balance.asciidoc b/Documentation/btrfs-balance.asciidoc
index cc81de91..f471be3b 100644
--- a/Documentation/btrfs-balance.asciidoc
+++ b/Documentation/btrfs-balance.asciidoc
@@ -21,7 +21,7 @@ filesystem.
 The balance operation is cancellable by the user. The on-disk state of the
 filesystem is always consistent so an unexpected interruption (eg. system crash,
 reboot) does not corrupt the filesystem. The progress of the balance operation
-is temporarily stored and will be resumed upon mount, unless the mount option
+****is temporarily stored**** (EDIT: where is it stored?) and will be resumed upon mount, unless the mount option
 'skip_balance' is specified.
 
 WARNING: running balance without filters will take a lot of time as it basically
@@ -200,11 +200,11 @@ section 'PROFILES'.
 ENOSPC
 ------
 
-The way balance operates, it usually needs to temporarily create a new block
+****The way balance operates, it usually needs to temporarily create a new block
 group and move the old data there. For that it needs work space, otherwise
 it fails for ENOSPC reasons.
 This is not the same ENOSPC as if the free space is exhausted. This refers to
-the space on the level of block groups.
+the space on the level of block groups.**** (EDIT: What is the relationship between the new block group and the work space?  Is the "old data" removed from the new block group?  Please say something about block groups to clarify)
 
 The free work space can be calculated from the output of the *btrfs filesystem show*
 command:
@@ -227,7 +227,7 @@ space. After that it might be possible to run other filters.
 
 Conversion to profiles based on striping (RAID0, RAID5/6) require the work
 space on each device. An interrupted balance may leave partially filled block
-groups that might consume the work space.
+groups that ****might**** (EDIT: is this 2nd level of uncertainty necessary?) consume the work space.
 
 EXAMPLES
 --------
@@ -238,7 +238,7 @@ can be found in section 'TYPICAL USECASES' of `btrfs-device`(8).
 MAKING BLOCK GROUP LAYOUT MORE COMPACT
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-The layout of block groups is not normally visible, most tools report only
+The layout of block groups is not normally visible; most tools report only
 summarized numbers of free or used space, but there are still some hints
 provided.
 
@@ -298,7 +298,7 @@ data to the remaining blockgroups, ie. the 6GiB are now free of filesystem
 structures, and can be reused for new data or metadata block groups.
 
 We can do a similar exercise with the metadata block groups, but this should
-not be typically necessary, unless the used/total ration is really off. Here
+not typically be necessary, unless the used/total ratio is really off. Here
 the ratio is roughly 50% but the difference as an absolute number is "a few
 gigabytes", which can be considered normal for a workload with snapshots or
 reflinks updated frequently.
diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-check.asciidoc
index fbf48847..b9f8bd60 100644
--- a/Documentation/btrfs-check.asciidoc
+++ b/Documentation/btrfs-check.asciidoc
@@ -22,10 +22,10 @@ by the option '--readonly'.
 
 *btrfsck* is an alias of *btrfs check* command and is now deprecated.
 
-WARNING: Do not use '--repair' unless you are advised to by a developer, an
-experienced user or accept the fact that 'fsck' cannot possibly fix all sorts
-of damage that could happen to a filesystem because of software and hardware
-bugs.
+WARNING: Do not use '--repair' unless you are advised to do so by a developer
+or an experienced user, and then only after having accepted that no 'fsck' can
+successfully repair all types of filesystem corruption. eg: some software bugs
+and hardware failures can fatally damage a volume.
 
 The structural integrity check verifies if internal filesystem objects or
 data structures satisfy the constraints, point to the right objects or are
@@ -49,9 +49,8 @@ This can be combined with '--super' if some of the superblocks are damaged.
 --check-data-csum::
 verify checksums of data blocks
 +
-This expects that the filesystem is otherwise
-OK, so this is basically and offline 'scrub' but does not repair data from
-spare copies.
+This expects that the filesystem is otherwise OK, and is basically
+an offline 'scrub' that does not repair data from spare copies.
 
 --chunk-root <bytenr>::
 use the given offset 'bytenr' for the chunk tree root
@@ -88,8 +87,8 @@ the free space cache for block groups that are modified while the filesystem is
 mounted with that option. Thus, using this option with 'v1' makes it possible
 to actually clear the entire free space cache.
 +
-For free space cache 'v2', the 'clear_cache' kernel mount option does destroy
-the entire free space cache. This option with 'v2' provides an alternative
+For free space cache 'v2', the 'clear_cache' kernel mount option destroys
+the entire free space cache. This option, with 'v2', provides an alternative
 method of clearing the free space cache that doesn't require mounting the
 filesystem.
 
diff --git a/Documentation/btrfs-convert.asciidoc b/Documentation/btrfs-convert.asciidoc
index 07ff608a..d0dafbe6 100644
--- a/Documentation/btrfs-convert.asciidoc
+++ b/Documentation/btrfs-convert.asciidoc
@@ -19,7 +19,7 @@ Supported filesystems:
 
 * ext2, ext3, ext4 -- original feature, always built in
 
-* reiserfs -- since version 4.13, opptinally built, requires libreiserfscore 3.6.27
+* reiserfs -- since version 4.13, optionally built, requires libreiserfscore 3.6.27
 
 The list of supported source filesystem by a given binary is listed at the end
 of help (option '--help').
@@ -32,13 +32,14 @@ The conversion utilizes free space of the original filesystem. The exact
 estimate of the required space cannot be foretold. The final btrfs metadata
 might occupy several gigabytes on a hundreds-gigabyte filesystem.
 
-If you decide not to rollback anymore, it is recommended to perform a few more
-steps to transform the btrfs filesystem to a more compact layout. The
-conversion inherits the original data block fragmentation and the metadata
-blocks are bound to the original free space layout.
+If the ability to rollback is no longer important, then it is recommended to
+perform a few more steps to transition the btrfs filesystem to a more compact
+layout. This is because the conversion inherits the original data blocks'
+fragmentation, and also because the metadata blocks are bound to the original
+free space layout.
 
-Due to different constraints, it's possible to convert only filesystem that
-have supported data block size (ie. the same that would be valid for
+Due to different constraints, it is only possible to convert filesystems that
+have a supported data block size (ie. the same that would be valid for
 'mkfs.btrfs'). This is typically the system page size (4KiB on x86_64
 machines).
 
@@ -52,8 +53,8 @@ metadata of the original filesystem will be removed:
 
    # btrfs subvolume delete /mnt/ext2_saved
 
-At this point it's not possible to do rollback. The filesystem is usable but may
-be impacted by the fragmentation inherited from the original filesystem.
+At this point it is not possible to do a rollback. The filesystem is usable but
+may be impacted by the fragmentation inherited from the original filesystem.
 
 **MAKE FILE DATA MORE CONTIGUOUS**
 
@@ -102,7 +103,7 @@ set filesystem label during conversion
 -L|--copy-label::
 use label from the converted filesystem
 -O|--features <feature1>[,<feature2>...]::
-A list of filesystem features turned on at conversion time. Not all features
+A list of filesystem features enabled at the time of conversion. Not all features
 are supported by old kernels. To disable a feature, prefix it with '^'.
 Description of the features is in section 'FILESYSTEM FEATURES' of
 `mkfs.btrfs`(8).
diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
index 88822ece..aa14717d 100644
--- a/Documentation/btrfs-device.asciidoc
+++ b/Documentation/btrfs-device.asciidoc
@@ -114,7 +114,7 @@ statistics and the meaning.
 Print the stats and reset the values to zero afterwards.
 
 -c|--check::::
-Check if the stats are all zeros and return 0 it it is so. Set bit 6 of the
+Check if the stats are all zeros and return 0 if this is so. Set bit 6 of the
 return code if any of the statistics is no-zero. The error values is 65 if
 reading stats from at least one device failed, otherwise it's 64.
 
@@ -180,8 +180,8 @@ there's enough workspace for the conversion process, we can do:
 
  $ btrfs balance start -mconvert=raid1 /mnt
 
-This operation can take a while as the metadata have to be moved and all block
-pointers updated. Depending on the physical locations of the old and new
+This operation can take a while, because all metadata must be moved and all
+block pointers updated. Depending on the physical locations of the old and new
 blocks, the disk seeking is the key factor affecting performance.
 
 You'll note that the system block group has been also converted to RAID1, this
diff --git a/Documentation/btrfs-filesystem.asciidoc b/Documentation/btrfs-filesystem.asciidoc
index 41b30320..f6b66f06 100644
--- a/Documentation/btrfs-filesystem.asciidoc
+++ b/Documentation/btrfs-filesystem.asciidoc
@@ -3,7 +3,7 @@ btrfs-filesystem(8)
 
 NAME
 ----
-btrfs-filesystem - command group of btrfs that usually work on the whole filesystem
+btrfs-filesystem - command group that primarily does work on whole filesystems
 
 SYNOPSIS
 --------
@@ -53,8 +53,8 @@ not total size of filesystem.
 when the filesystem is full. Its 'total' size is dynamic based on the
 filesystem size, usually not larger than 512MiB, 'used' may fluctuate.
 +
-The global block reserve is accounted within Metadata. In case the filesystem
-metadata are exhausted, 'GlobalReserve/total + Metadata/used = Metadata/total'.
+The global block reserve is accounted within Metadata. ****In case the filesystem
+metadata are exhausted, 'GlobalReserve/total + Metadata/used =
Metadata/total'.**** (EDIT: s/are/is/? And please write more for
clarity. Is "global block reserve" part of GlobalReserve that is
accounted within Metadata?  Isn't all of GlobalReserve's metadata
accounted within Metadata?  eg: "global block reserve" is the data
portion of GlobalReserve, but all metadata is accounted for in
Metadata.)
 +
 `Options`
 +
@@ -93,10 +93,10 @@ You can also turn on compression in defragment operations.
 +
 WARNING: Defragmenting with Linux kernel versions < 3.9 or ≥ 3.14-rc2 as well as
 with Linux stable kernel versions ≥ 3.10.31, ≥ 3.12.12 or ≥ 3.13.4 will break up
-the ref-links of COW data (for example files copied with `cp --reflink`,
+the reflinks of COW data (for example files copied with `cp --reflink`,
 snapshots or de-duplicated data).
 This may cause considerable increase of space usage depending on the broken up
-ref-links.
+reflinks.
 +
 NOTE: Directory arguments without '-r' do not defragment files recursively but will
 defragment certain internal trees (extent tree and the subvolume tree). This has been
@@ -174,7 +174,7 @@ show sizes in TiB, or TB with --si.
 Show or update the label of a filesystem. This works on a mounted filesystem or
 a filesystem image.
 +
-The 'newlabel' argument is optional. Current label is printed if the the argument
+The 'newlabel' argument is optional. Current label is printed if the argument
 is omitted.
 +
 NOTE: the maximum allowable length shall be less than 256 chars and must not contain
@@ -359,9 +359,9 @@ specify the devid though.
 
 *$ btrfs filesystem resize 1:max /path*
 
-Let's assume that devid 1 exists, the filesystem does not occupy the whole block
-device, eg. it has been enlarged and we wan the grow the filesystem. Simply using
-'max' as size we will achieve that.
+Let's assume that devid 1 exists, and the filesystem does not occupy the whole
+block device, eg. it can be enlarged, and we want to grow the filesystem. By
+simply using 'max' as size we will achieve that.
 
 NOTE: There are two ways to minimize the filesystem on a given device. The
 *btrfs inspect-internal min-dev-size* command, or iteratively shrink in steps.
diff --git a/Documentation/btrfs-find-root.asciidoc b/Documentation/btrfs-find-root.asciidoc
index 3d6af2df..b28192be 100644
--- a/Documentation/btrfs-find-root.asciidoc
+++ b/Documentation/btrfs-find-root.asciidoc
@@ -17,7 +17,7 @@ root tree's objectid, generation, level.
 OPTIONS
 -------
 -a::
-Search through all the metadata extents, even the root is already found.
+Search through all metadata extents, even if the root has already been found.
 -g <generation>::
 Filter root tree by it's original transaction id, tree root's generation in default.
 -o <objectid>::
diff --git a/Documentation/btrfs-inspect-internal.asciidoc b/Documentation/btrfs-inspect-internal.asciidoc
index 62b10294..e072a943 100644
--- a/Documentation/btrfs-inspect-internal.asciidoc
+++ b/Documentation/btrfs-inspect-internal.asciidoc
@@ -136,16 +136,16 @@ resize operation, this may be useful before executing the actual resize operatio
 specify the device 'id' to query, default is 1 if this option is not used
 
 *rootid* <path>::
-for a given file or directory, return the containing tree root id, for a
-subvolume itself return it's own tree id (ie. subvol id)
+for a given file or directory, return the containing tree root id, but for a
+subvolume itself return its own tree id (ie. subvol id)
 +
 NOTE: The result is undefined for the so-called empty subvolumes (identified by
-inode number 2), but such subvolume does not contain any files anyway
+inode number 2), but such a subvolume does not contain any files anyway
 
 *subvolid-resolve* <subvolid> <path>::
 (needs root privileges)
 +
-resolve the absolute path of a the subvolume id 'subvolid'
+resolve the absolute path of the subvolume id 'subvolid'
 
 *tree-stats* [options] <device>::
 (needs root privileges)
diff --git a/Documentation/btrfs-man5.asciidoc b/Documentation/btrfs-man5.asciidoc
index 3981435e..779c79e8 100644
--- a/Documentation/btrfs-man5.asciidoc
+++ b/Documentation/btrfs-man5.asciidoc
@@ -51,17 +51,17 @@ location.
 +
 WARNING: Defragmenting with Linux kernel versions < 3.9 or ≥ 3.14-rc2 as
 well as with Linux stable kernel versions ≥ 3.10.31, ≥ 3.12.12 or
-≥ 3.13.4 will break up the ref-links of CoW data (for example files
+≥ 3.13.4 will break up the reflinks of CoW data (for example files
 copied with `cp --reflink`, snapshots or de-duplicated data).
 This may cause considerable increase of space usage depending on the
-broken up ref-links.
+broken up reflinks.
 
 *barrier*::
 *nobarrier*::
 (default: on)
 +
 Ensure that all IO write operations make it through the device cache and are stored
-permanently when the filesystem is at it's consistency checkpoint. This
+permanently when the filesystem is at ****(EDIT: "its" or "one of its"
consistency checkpoint[s])****. This

 typically means that a flush command is sent to the device that will
 synchronize all pending data and ordinary metadata blocks, then writes the
 superblock and issues another flush.
@@ -120,7 +120,7 @@ but a warning is printed if it's more than 300 seconds (5 minutes).
 Control BTRFS file data compression.  Type may be specified as 'zlib',
 'lzo', 'zstd' or 'no' (for no compression, used for remounting).  If no type
 is specified, 'zlib' is used.  If 'compress-force' is specified,
-the compression will allways be attempted, but the data may end up uncompressed
+then compression will always be attempted, but the data may end up uncompressed
 if the compression would make them larger.
 +
 Otherwise some simple heuristics are applied to detect an incompressible file.
@@ -174,17 +174,19 @@ system at that point.
 *nodiscard*::
 (default: off)
 +
-Enable discarding of freed file blocks using TRIM operation.  This is useful
-for SSD devices, thinly provisioned LUNs or virtual machine images where the
-backing device understands the operation. Depending on support of the
-underlying device, the operation may severely hurt performance in case the TRIM
-operation is synchronous (eg. with SATA devices up to revision 3.0).
+Enable discarding of freed file blocks. This is useful for SSD devices, thinly
+provisioned LUNs, or virtual machine images; however, every storage layer must
+support discard for it to work. If the backing device does not support
+asynchronous queued TRIM, then this operation can severely degrade performance,
+because a synchronous TRIM operation will be attempted instead. Queued TRIM
+requires newer than SATA revision 3.1 chipsets and devices.
 +
-If discarding is not necessary to be done at the block freeing time, there's
-`fstrim` tool that lets the filesystem discard all free blocks in a batch,
-possibly not much interfering with other operations. Also, the the device may
-ignore the TRIM command if the range is too small, so running the batch discard
-can actually discard the blocks.
+If it is not necessary to immediately discard freed blocks, then the `fstrim`
+tool can be used to discard all free blocks in a batch. Scheduling a TRIM
+during a period of low system activity will prevent latent interference with
+the performance of other operations. Also, a device may ignore the TRIM command
+if the range is too small, so running a batch discard has a greater probability
+of actually discarding the blocks.
 
 *enospc_debug*::
 *noenospc_debug*::
@@ -334,7 +336,7 @@ command may be run on a 'v2' filesystem by clearing the cache, running the
 command, and then remounting with 'space_cache=v2'.
 +
 If a version is not explicitly specified, the default implementation will be
-chosen, which is 'v1' as of 4.9.
+chosen, which is 'v1' as of ****4.9.**** (EDIT: needs update for 4.14)
 
 *ssd*::
 *ssd_spread*::
@@ -566,8 +568,8 @@ long as this attribute is set (obviously the exception is unsetting the attribut
 'O_DSYNC'
 
 *X*::
-'no compression', permanently turn off compression on the given file, other
-compression mount options will not affect that
+'no compression', permanently turn off compression for the given file. Any
+compression mount options will not affect this file
 +
 When set on a directory, all newly created files will inherit this attribute.
 
diff --git a/Documentation/btrfs-map-logical.asciidoc b/Documentation/btrfs-map-logical.asciidoc
index a3d110cb..34b22c0d 100644
--- a/Documentation/btrfs-map-logical.asciidoc
+++ b/Documentation/btrfs-map-logical.asciidoc
@@ -12,7 +12,7 @@ SYNOPSIS
 DESCRIPTION
 -----------
 *btrfs-map-logical* can be used to find out what the physical offsets are
-on the mirrors, the result is dumped into stdout in default.
+on the mirrors, the result is dumped to stdout by default.
 
 Mainly used for debug purpose.
 
diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
index 3053f2e6..e382e92c 100644
--- a/Documentation/btrfs-qgroup.asciidoc
+++ b/Documentation/btrfs-qgroup.asciidoc
@@ -17,7 +17,7 @@ NOTE: To use qgroup you need to enable quota first using *btrfs quota enable*
 command.
 
 WARNING: Qgroup is not stable yet and will impact performance in current mainline
-kernel (v3.14 so far).
+kernel ****(v3.14 so far).****(EDIT: needs update for 4.14)
 
 QGROUP
 ------
@@ -56,13 +56,13 @@ Explicitly ask not to do a rescan.
 Create a subvolume quota group.
 +
 For the '0/<subvolume id>' qgroup, a qgroup can be created even before the
-subvolume created.
+subvolume is created.
 
 *destroy* <qgroupid> <path>::
 Destroy a qgroup.
 +
-If a qgroup is no isolated,which means it is a parent or child qgroup, it
-can't be destroyed.
+If a qgroup is not isolated, meaning it is a parent or child qgroup, then it
+can only be destroyed after the relationship is removed.
 
 *limit* [options] <size>|none [<qgroupid>] <path>::
 Limit the size of a qgroup to <size> or no limit in the btrfs filesystem
diff --git a/Documentation/btrfs-quota.asciidoc b/Documentation/btrfs-quota.asciidoc
index f882647d..f26c2e41 100644
--- a/Documentation/btrfs-quota.asciidoc
+++ b/Documentation/btrfs-quota.asciidoc
@@ -15,24 +15,24 @@ The commands under *btrfs quota* are used to affect the global status of quotas
 of a btrfs filesystem. The quota groups (qgroups) are managed by the subcommand
 `btrfs qgroup`(8).
 
-NOTE: the qgroups are different than the traditional user quotas and designed
-to track shared and exclusive data per-subvolume.  Please refer to the section
+NOTE: Qgroups are different from traditional user quotas and are designed to
+track shared and exclusive data per-subvolume.  Please refer to the section
 'HIERARCHICAL QUOTA GROUP CONCEPTS' for a detailed description.
 
 PERFORMANCE IMPLICATIONS
 ~~~~~~~~~~~~~~~~~~~~~~~~
 
-When the quotas are turned on, they affect all extent processing, taking a
-performance hit. It is not recommended to turn on qgroups unless the user
+When quotas are activated, they affect all extent processing, which takes a
+performance hit.  Activation of qgroups is not recommended unless the user
 intends to actually use them.
 
 STABILITY STATUS
 ~~~~~~~~~~~~~~~~
 
 The qgroup implementation has turned out to be quite difficult as it affects
-the core of the filesystem operation. The users have hit various corner cases
-over time, eg. wrong accounting or system instability. The situation is
-gradually improving but currently (4.7) there are still issues found and fixed.
+the core of a filesystem's operation.  Qgroup users have hit various corner cases
+over time, such as faulty accounting or system instability.  The situation is
+gradually improving but currently ****(4.7)**** (EDIT: update for 4.14) there are still issues found and fixed.
 
 HIERARCHICAL QUOTA GROUP CONCEPTS
 ---------------------------------
@@ -52,7 +52,7 @@ On the other hand, the traditional approach has only a poor solution to
 restrict directories.
 At installation time, the harddisk can be partitioned so that every directory
 (eg. /usr, /var/, ...) that needs a limit gets its own partition.  The obvious
-problem is, that those limits cannot be changed without a reinstallation.  The
+problem is that those limits cannot be changed without a reinstallation. The
 btrfs subvolume feature builds a bridge.  Subvolumes correspond in many ways to
 partitions, as every subvolume looks like its own filesystem.  With subvolume
 quota, it is now possible to restrict each subvolume like a partition, but keep
@@ -181,7 +181,7 @@ own way how to integrate qgroups.
 `Replacement for partitions`
 
 The simplest use case is to use qgroups as simple replacement for partitions.
-Btrfs takes the disk as a whole, and /, /usr, /var etc.  are created as
+Btrfs takes the disk as a whole, and /, /usr, /var, etc. are created as
 subvolumes.  As each subvolume gets it own qgroup automatically, they can
 simply be restricted.  No hierarchy is needed for that.
 
diff --git a/Documentation/btrfs-receive.asciidoc b/Documentation/btrfs-receive.asciidoc
index 1f6847a9..cbd88e6a 100644
--- a/Documentation/btrfs-receive.asciidoc
+++ b/Documentation/btrfs-receive.asciidoc
@@ -81,7 +81,7 @@ should be protected from access by users until the receive operation
 has completed and the subvolume is set to read-only.
 
 Additionally, receive does not currently do a very good job of validating
-that an incremental send streams actually makes sense, and it is thus
+that an incremental send stream actually makes sense, and it is thus
 possible for a specially crafted send stream to create a subvolume with
 reflinks to arbitrary files in the same filesystem.  Because of this,
 users are advised to not use *btrfs receive* on send streams from
diff --git a/Documentation/btrfs-replace.asciidoc b/Documentation/btrfs-replace.asciidoc
index 9a8a9ea1..35ecb1f8 100644
--- a/Documentation/btrfs-replace.asciidoc
+++ b/Documentation/btrfs-replace.asciidoc
@@ -34,7 +34,7 @@ from the system, you have to use the devid parameter format.
 The <targetdev> needs to be same size or larger than the <srcdev>.
 +
 NOTE: the filesystem has to be resized to fully take advantage of a
-larger target device, this can be achieved with
+larger target device; this can be achieved with
 `btrfs filesystem resize <devid>:max /path`
 +
 `Options`
@@ -45,10 +45,10 @@ only read from <srcdev> if no other zero-defect mirror exists.
 slow)
 -f::::
 force using and overwriting <targetdev> even if it looks like
-containing a valid btrfs filesystem.
+it contains a valid btrfs filesystem.
 +
 A valid filesystem is assumed if a btrfs superblock is found which contains a
-correct checksum. Devices which are currently mounted are
+correct checksum. Devices that are currently mounted are
 never allowed to be used as the <targetdev>.
 +
 -B::::
diff --git a/Documentation/btrfs-rescue.asciidoc b/Documentation/btrfs-rescue.asciidoc
index 24b619c6..12b7e07d 100644
--- a/Documentation/btrfs-rescue.asciidoc
+++ b/Documentation/btrfs-rescue.asciidoc
@@ -47,7 +47,7 @@ This command will clear the filesystem log tree. This may fix a specific
 set of problem when the filesystem mount fails due to the log replay. See below
 for sample stacktraces that may show up in system log.
 +
-The common case where this happens has been fixed a long time ago,
+The common case where this happens was fixed a long time ago,
 so it is unlikely that you will see this particular problem, but the utility is
 kept around.
 +
diff --git a/Documentation/btrfs-scrub.asciidoc b/Documentation/btrfs-scrub.asciidoc
index eb90a1c4..d2d20627 100644
--- a/Documentation/btrfs-scrub.asciidoc
+++ b/Documentation/btrfs-scrub.asciidoc
@@ -21,8 +21,8 @@ structural damage in the filesystem.
 The user is supposed to run it manually or via a periodic system service. The
 recommended period is a month but could be less. The estimated device bandwidth
 utilization is about 80% on an idle filesystem. The IO priority class is by
-default 'idle' so background scrub should not interfere with normal filesystem
-operation significantly.
+default 'idle' so background scrub should not significantly interfere with
+normal filesystem operation.
 
 The scrubbing status is recorded in '/var/lib/btrfs/' in textual files named
 'scrub.status.UUID' for a filesystem identified by the given UUID. (Progress
diff --git a/Documentation/btrfs-send.asciidoc b/Documentation/btrfs-send.asciidoc
index ef345f68..0e8bbdd5 100644
--- a/Documentation/btrfs-send.asciidoc
+++ b/Documentation/btrfs-send.asciidoc
@@ -29,12 +29,13 @@ are available on both the sending and receiving side can be used to reduce the
 amount of information that has to be sent to reconstruct the sent snapshot on a
 different filesystem.
 
-It is allowed to omit the '-p <parent>' option when '-c <clone-src>' options
-are given, in which case *btrfs send* will determine a suitable parent among the
-clone sources itself.
+The '-p <parent>' option can be omitted when '-c <clone-src>' options are
+given, in which case *btrfs send* will determine a suitable parent from among
+the clone sources.
 
 You must not specify clone sources unless you guarantee that these snapshots
-are exactly in the same state on both sides, the sender and the receiver.
+are exactly in the same state on both sides--both for the sender and the
+receiver.
 
 `Options`
 
@@ -53,7 +54,7 @@ send in 'NO_FILE_DATA' mode
 +
 The output stream does not contain any file
 data and thus cannot be used to transfer changes. This mode is faster and
-useful to show the differences in metadata.
+is useful to show differences in metadata.
 
 -v|--verbose::
 enable verbose output, print generated commands in a readable form, (each
diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index d33fee5a..355f31ed 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -17,7 +17,7 @@ snapshots.
 SUBVOLUME AND SNAPSHOT
 ----------------------
 
-A subvolume is a part of filesystem with its own and independent
+A subvolume is a part of filesystem with its own independent
 file/directory hierarchy. Subvolumes can share file extents. A snapshot is
 also subvolume, but with a given initial content of the original subvolume.
 
@@ -66,7 +66,7 @@ If <subvolume> is not a subvolume, btrfs returns an error but continues if
 there are more arguments to process.
 +
 The corresponding directory is removed instantly but the data blocks are
-removed later in the background. The command returns immediatelly. See `btrfs
+removed later in the background. The command returns immediately. See `btrfs
 subvolume sync` how to wait until the subvolume gets completely removed.
 +
 The deletion does not involve full transaction commit by default due to
@@ -143,7 +143,8 @@ for --sort you can combine some items together by \',', just like
 --sort=+ogen,-gen,path,rootid.
 
 *set-default* [<subvolume>|<id> <path>]::
-Set the default subvolume of the (mounted) filesystem.
+Set the default subvolume for the (mounted) filesystem at <path>. This will hide
+the top-level subvolume (subvol=/|subvolid=5). Takes action on next mount.
 +
 There are two ways how to specify the subvolume, by <id> or by the <subvolume>
 path.
@@ -162,10 +163,10 @@ If <source> is not a subvolume, btrfs returns an error.
 If '-r' is given, the snapshot will be readonly.
 
 *sync* <path> [subvolid...]::
-Wait until given subvolume(s) are completely removed from the filesystem
-after deletion. If no subvolume id is given, wait until all current  deletion
-requests are completed, but do not wait for subvolumes deleted meanwhile.
-The status of subvolume ids is checked periodically.
+Wait until given subvolume[s] are completely removed from the filesystem after
+deletion. If no subvolume id is given, wait until all current deletion requests
+are completed, but do not wait for subvolumes deleted in the meantime.  ****The
+status of subvolume ids is checked periodically.**** (EDIT: How is the

relevant to sync?  Should it read "the status of all subvolume ids are
periodically synced as a normal background operation"?)

 +
 `Options`
 +
diff --git a/Documentation/btrfs.asciidoc b/Documentation/btrfs.asciidoc
index 100a6adf..2845fda4 100644
--- a/Documentation/btrfs.asciidoc
+++ b/Documentation/btrfs.asciidoc
@@ -25,9 +25,9 @@ page `btrfs`(5).
 COMMAND SYNTAX
 --------------
 
-Any command name can be shortened as far as it stays unambiguous,
-however it is recommended to use full command names in scripts.
-All command groups have their manual page named *btrfs-<group>*.
+Any command name can be shortened so long as the shortened form is unambiguous;
+however, it is recommended to use full command names in scripts.  All command
+groups have their manual page named *btrfs-<group>*.
 
 For example: it is possible to run *btrfs sub snaps* instead of
 *btrfs subvolume snapshot*.
@@ -106,10 +106,10 @@ COMMANDS
 STANDALONE TOOLS
 ----------------
 
-There are several standalone tools to provide certain functionality. If the
-functionality proves to be useful, the standalone tools are declared obsolete
-and their functionality copied to the main tool. The deprecation period is long
-(years) and the obsolete binaries are still provided.
+New functionality is provided using a standalone tool. If the functionality
+proves to be useful, then the standalone tool is declared obsolete and its
+functionality is copied to the main tool. Obsolete tools are removed after a
+long (years) depreciation period.
 
 Tools that are still in active use without an equivalent in *btrfs*:
 
diff --git a/Documentation/btrfstune.asciidoc b/Documentation/btrfstune.asciidoc
index cd7bb532..59cee3f1 100644
--- a/Documentation/btrfstune.asciidoc
+++ b/Documentation/btrfstune.asciidoc
@@ -11,7 +11,7 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-*btrfstune* can be used to enable, disable or set various filesystem
+*btrfstune* can be used to enable, disable, or set various filesystem
 parameters. The filesystem must be unmounted.
 
 The common usecase is to enable features that were not enabled at mkfs time.
@@ -20,8 +20,8 @@ complete list of features and kernel version of their introduction at
 https://btrfs.wiki.kernel.org/index.php/Changelog#By_feature .  Also, the
 manual page `mkfs.btrfs`(8) contains more details about the features.
 
-Some of the features could be enabled on a mounted filesystem. Please refer to
-the respective section in `btrfs`(5).
+****Some of these features can be enabled on a mounted filesystem.
Please refer to
+the respective section in `btrfs`(5).**** (EDIT: Some of these features
can be enabled/toggled on a mounted filesystem, even though "The
filesystem must be unmounted" is at the top of the Description?  If this
is the cases then "The filesystem must usually be unmounted" or "The
filesystem must be umounted except for change x, y, and z".  Or maybe
"The functionality merged into the main btrfs tool allows x,y,z
operations on a mounted filesystem; however, a,b,c can only be performed
with btrfstune on an unmounted filesystem.  Additionally what is/are the
"respective section[s]" in btrfs(5)?)
 
 OPTIONS
 -------
@@ -86,9 +86,10 @@ EXIT STATUS
 
 COMPATIBILITY NOTE
 ------------------
-This tool exists for historical reasons but is still in use today.  The
-functionality is about to be merged to the main tool someday and *btrfstune*
-will become deprecated and removed afterwards.
+
+This depreciated tool exists for historical reasons but is still in use today.  Its
+functionality will soon be merged to the main tool, at which time *btrfstune*
+will be declared obsolete and scheduled for removal.
 
 SEE ALSO
 --------
diff --git a/Documentation/fsck.btrfs.asciidoc b/Documentation/fsck.btrfs.asciidoc
index 0bad075b..d3853abf 100644
--- a/Documentation/fsck.btrfs.asciidoc
+++ b/Documentation/fsck.btrfs.asciidoc
@@ -13,16 +13,16 @@ DESCRIPTION
 -----------
 *fsck.btrfs* is a type of utility that should exist for any filesystem and is
 called during system setup when the corresponding `/etc/fstab` entries
-contain non-zero value for `fs_passno` , see `fstab`(5) for more.
+contain non-zero value for `fs_passno`. See `fstab`(5) for more information.
 
 Traditional filesystems need to run their respective fsck utility in case the
 filesystem was not unmounted cleanly and the log needs to be replayed before
 mount. This is not needed for BTRFS. You should set fs_passno to 0.
 
 If you wish to check the consistency of a BTRFS filesystem or repair a damaged
-filesystem, see `btrfs-check`(8). By default the filesystem
-consistency is checked, the repair mode is enabled via '--repair' option (use
-with care!).
+filesystem, see `btrfs-check`(8). By default filesystem consistency is checked
+but not repaired. The repair mode is enabled via the '--repair' option (use with
+care!).
 
 OPTIONS
 -------
diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index d53d9e26..737e84d0 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -27,7 +27,7 @@ Specify the (physical) offset from the start of the device at which allocations
 start.  The default value is zero.
 
 *-b|--byte-count <size>*::
-Specify the size of the filesystem. If this option is not used,
+Specify the size of the filesystem. If this option is not used, then
 mkfs.btrfs uses the entire device space for the filesystem.
 
 *-d|--data <profile>*::
@@ -79,7 +79,7 @@ default value is 16KiB (16384) or the page size, whichever is bigger. Must be a
 multiple of the sectorsize and a power of 2, but not larger than 64KiB (65536).
 Leafsize always equals nodesize and the options are aliases.
 +
-Smaller node size increases fragmentation but lead to higher b-trees which in
+Smaller node size increases fragmentation ****but lead to higher b-trees**** (EDIT: "but leads to taller/deeper/more/increased-usage-of b-trees"?) which in
 turn leads to lower locking contention. Higher node sizes give better packing
 and less fragmentation at the cost of more expensive memory operations while
 updating the metadata blocks.
@@ -166,7 +166,7 @@ root partition created with RAID1/10/5/6 profiles. The mount action can happen
 before all block devices are discovered. The waiting is usually done on the
 initramfs/initrd systems.
 
-As of kernel 4.9, RAID5/6 is still considered experimental and shouldn't be
+As of kernel ****4.9**** (EDIT: 4.14 status?), RAID5/6 is still considered experimental and shouldn't be
 employed for production use.
 
 FILESYSTEM FEATURES
@@ -281,9 +281,9 @@ The mkfs utility will let the user create a filesystem with profiles that write
 the logical blocks to 2 physical locations. Whether there are really 2
 physical copies highly depends on the underlying device type.
 
-For example, a SSD drive can remap the blocks internally to a single copy thus
+For example, a SSD drive can remap the blocks internally to a single copy--thus
 deduplicating them. This negates the purpose of increased redundancy and just
-wastes filesystem space without the expected level of redundancy.
+wastes filesystem space without providing the expected level of redundancy.
 
 The duplicated data/metadata may still be useful to statistically improve the
 chances on a device that might perform some internal optimizations. The actual
-- 
2.11.0

