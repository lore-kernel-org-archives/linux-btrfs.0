Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52268 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751409AbaFECKV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jun 2014 22:10:21 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <util-linux@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] mount: add btrfs to mount.8
Date: Thu, 5 Jun 2014 10:05:19 +0800
Message-ID: <1401933919-23608-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Based on Documentation/filesystems/btrfs.txt

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 sys-utils/mount.8 | 186 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 186 insertions(+)

diff --git a/sys-utils/mount.8 b/sys-utils/mount.8
index efa1ae8..ec8eab3 100644
--- a/sys-utils/mount.8
+++ b/sys-utils/mount.8
@@ -671,6 +671,7 @@ currently supported include:
 .IR adfs ,
 .IR affs ,
 .IR autofs ,
+.IR btrfs ,
 .IR cifs ,
 .IR coda ,
 .IR coherent ,
@@ -1245,6 +1246,191 @@ Give blocksize. Allowed values are 512, 1024, 2048, 4096.
 These options are accepted but ignored.
 (However, quota utilities may react to such strings in
 .IR /etc/fstab .)
+.SH "Mount options for btrfs"
+Btrfs is a copy on write filesystem for Linux aimed at
+implementing advanced features while focusing on fault tolerance,
+repair and easy administration.
+.TP
+.BI alloc_start= bytes
+Debugging option to force all block allocations above a certain
+byte threshold on each block device.  The value is specified in
+bytes, optionally with a K, M, or G suffix, case insensitive.
+Default is 1MB.
+.TP
+.B autodefrag
+Disable/enable auto defragmentation.
+Auto defragmentation detects small random writes into files and queue
+them up for the defrag process.  Works best for small files;
+Not well suited for large database workloads.
+.TP
+\fBcheck_int\fP|\fBcheck_int_data\fP|\fBcheck_int_print_mask=\fP\,\fIvalue\fP
+These debugging options control the behavior of the integrity checking
+module(the BTRFS_FS_CHECK_INTEGRITY config option required).
+
+.B check_int
+enables the integrity checker module, which examines all
+block write requests to ensure on-disk consistency, at a large
+memory and CPU cost.  
+
+.B check_int_data
+includes extent data in the integrity checks, and
+implies the check_int option.
+
+.B check_int_print_mask
+takes a bitmask of BTRFSIC_PRINT_MASK_* values
+as defined in fs/btrfs/check-integrity.c, to control the integrity
+checker module behavior.
+
+See comments at the top of
+.IR fs/btrfs/check-integrity.c
+for more info.
+.TP
+.BI commit= seconds
+Set the interval of periodic commit, 30 seconds by default. Higher
+values defer data being synced to permanent storage with obvious
+consequences when the system crashes. The upper bound is not forced,
+but a warning is printed if it's more than 300 seconds (5 minutes).
+.TP
+\fBcompress\fP|\fBcompress=\fP\,\fItype\fP|\fBcompress-force\fP|\fBcompress-force=\fP\,\fItype\fP
+Control BTRFS file data compression.  Type may be specified as "zlib"
+"lzo" or "no" (for no compression, used for remounting).  If no type
+is specified, zlib is used.  If compress-force is specified,
+all files will be compressed, whether or not they compress well.
+If compression is enabled, nodatacow and nodatasum are disabled.
+.TP
+.B degraded
+Allow mounts to continue with missing devices.  A read-write mount may
+fail with too many devices missing, for example if a stripe member
+is completely missing.
+.TP
+.BI device= devicepath
+Specify a device during mount so that ioctls on the control device
+can be avoided.  Especially useful when trying to mount a multi-device
+setup as root.  May be specified multiple times for multiple devices.
+.TP
+.B discard
+Disable/enable discard mount option.
+Discard issues frequent commands to let the block device reclaim space
+freed by the filesystem.
+This is useful for SSD devices, thinly provisioned
+LUNs and virtual machine images, but may have a significant
+performance impact.  (The fstrim command is also available to
+initiate batch trims from userspace).
+.TP
+.B enospc_debug
+Disable/enable debugging option to be more verbose in some ENOSPC conditions.
+.TP
+.BI fatal_errors= action
+Action to take when encountering a fatal error: 
+  "bug" - BUG() on a fatal error.  This is the default.
+  "panic" - panic() on a fatal error.
+.TP
+.B flushoncommit
+The
+.B flushoncommit
+mount option forces any data dirtied by a write in a
+prior transaction to commit as part of the current commit.  This makes
+the committed state a fully consistent view of the file system from the
+application's perspective (i.e., it includes all completed file system
+operations).  This was previously the behavior only when a snapshot is
+created.
+.TP
+.B inode_cache
+Enable free inode number caching.   Defaults to off due to an overflow
+problem when the free space crcs don't fit inside a single page.
+.TP
+.BI max_inline= bytes
+Specify the maximum amount of space, in bytes, that can be inlined in
+a metadata B-tree leaf.  The value is specified in bytes, optionally 
+with a K, M, or G suffix, case insensitive.  In practice, this value
+is limited by the root sector size, with some space unavailable due
+to leaf headers.  For a 4k sectorsize, max inline data is ~3900 bytes.
+.TP
+.BI metadata_ratio= value
+Specify that 1 metadata chunk should be allocated after every
+.IRvalue
+data chunks.  Off by default.
+.TP
+.B noacl
+Enable/disable support for Posix Access Control Lists (ACLs).  See the
+.B acl(5)
+manual page for more information about ACLs.
+.TP
+.B nobarrier
+Enable/disable the use of block layer write barriers.  Write barriers
+ensure that certain IOs make it through the device cache and are on
+persistent storage. If disabled on a device with a volatile
+(non-battery-backed) write-back cache, nobarrier option will lead to
+filesystem corruption on a system crash or power loss.
+.TP
+.B nodatacow
+Enable/disable data copy-on-write for newly created files.
+Nodatacow implies nodatasum, and disables all compression.
+.TP
+.B nodatasum
+Enable/disable data checksumming for newly created files.
+Datasum implies datacow.
+.TP
+.B notreelog
+Enable/disable the tree logging used for fsync and O_SYNC writes.
+.TP
+.B recovery
+Enable autorecovery attempts if a bad tree root is found at mount time.
+Currently this scans a list of several previous tree roots and tries to 
+use the first readable.
+.TP
+.B rescan_uuid_tree
+Force check and rebuild procedure of the UUID tree. This should not
+normally be needed.
+.TP
+.B skip_balance
+Skip automatic resume of interrupted balance operation after mount.
+May be resumed with "btrfs balance resume."
+.TP
+.B nospace_cache
+Disable freespace cache loading without clearing the cache.
+.TP
+.B clear_cache
+Force clearing and rebuilding of the disk space cache if something
+has gone wrong.
+.TP
+.BR ssd | nossd | ssd_spread
+Options to control ssd allocation schemes.  By default, BTRFS will
+enable or disable ssd allocation heuristics depending on whether a
+rotational or nonrotational disk is in use.  The ssd and nossd options
+can override this autodetection.
+
+The ssd_spread mount option attempts to allocate into big chunks
+of unused space, and may perform better on low-end ssds.  ssd_spread
+implies ssd, enabling all other ssd heuristics as well.
+.TP
+.BI subvol= path
+Mount subvolume at
+.IR path
+rather than the root subvolume. The
+.IR path
+is relative to the top level subvolume.
+.TP
+.BI subvolid= ID
+Mount subvolume specified by an ID number rather than the root subvolume.
+This allows mounting of subvolumes which are not in the root of the mounted
+filesystem.
+You can use "btrfs subvolume list" to see subvolume ID numbers.
+.TP
+.BI subvolrootid= objectid (deprecated)
+Mount subvolume specified by
+.IR objectid
+rather than the root subvolume.
+This allows mounting of subvolumes which are not in the root of the mounted
+filesystem.
+You can use "btrfs subvolume show " to see the object ID for a subvolume.
+.TP	
+.BI thread_pool= number
+The number of worker threads to allocate.  The default number is equal
+to the number of CPUs + 2, or 8, whichever is smaller.
+.TP
+.B user_subvol_rm_allowed
+Allow subvolumes to be deleted by a non-root user. Use with caution. 
 
 .SH "Mount options for cifs"
 See the options section of the
-- 
1.8.1.4

