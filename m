Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab3CWRs4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Mar 2013 13:48:56 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2NHmums023120
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 23 Mar 2013 13:48:56 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r2NHmsP3031847
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 23 Mar 2013 13:48:55 -0400
Message-ID: <514DEB06.7000606@redhat.com>
Date: Sat, 23 Mar 2013 12:48:54 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: document mount options in Documentation/fs/btrfs.txt
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Document all current btrfs mount options.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

please, Please, PLEASE review this and suggest improvements.
I'm no btrfs wizard but I've done my best to get this all right
based on commit logs, code reading, and wiki reading.  In cases where
any of those 3 disagreed, I've done my best to document reality, but I'm
sure it could use corrections, clarifications, etc.

In particular, some of these mount options could really use more
description of why a user might want them, rather than simply stating
what they do.

"notreelog" is particularly egregious, as I have nothing but self-referential
documentation.

So this can use some iteration, I'm sure, but hopefully it's a decent
start.

Thanks,
-Eric

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 7671352..02a19c8 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -1,6 +1,6 @@
 
-	BTRFS
-	=====
+BTRFS
+=====
 
 Btrfs is a new copy on write filesystem for Linux aimed at
 implementing advanced features while focusing on fault tolerance,
@@ -34,9 +34,173 @@ The main Btrfs features include:
     * Online filesystem defragmentation
 
 
-
-	MAILING LIST
-	============
+Mount Options
+=============
+
+When mounting a btrfs filesystem, the following option are accepted.
+Unless otherwise specified, all options default to off.
+
+  alloc_start=<bytes>
+	Debugging option to force all block allocations above a threshold.
+	The value is specified in bytes, optionally with a K, M, or G suffix,
+	case insensitive.  Default is 1MB.
+
+  autodefrag
+	Detect small random writes into files and queue them up for the
+	defrag process.  Works best for small files; Not well suited for
+	large database workloads.
+
+  check_int
+  check_int_data
+  check_int_print_mask=<value>
+	These debugging options control the behavior of the integrity checking
+	module (the BTRFS_FS_CHECK_INTEGRITY config option required).
+
+	check_int enables the integrity checker module, which examines all
+	block write requests to ensure on-disk consistency, at a large
+	memory and CPU cost.  
+
+	check_int_data includes extent data in the integrity checks, and
+	implies the check_int option.
+
+	check_int_print_mask takes a bitmask of BTRFSIC_PRINT_MASK_* values
+	as defined in fs/btrfs/check-integrity.c, to control the integrity
+	checker module behavior.
+
+	See comments at the top of fs/btrfs/check-integrity.c for more info.
+
+  compress
+  compress=<type>
+  compress-force
+  compress-force=<type>
+	Control BTRFS file data compression.  Type may be specified as "zlib"
+	"lzo" or "no" (for no compression, used for remounting).  If no type
+	is specified, zlib is used.  If compress-force is specified,
+	all files will be compressed, whether or not they compress well.
+	If compression is enabled, nodatacow and nodatasum are disabled.
+
+  degraded
+	Allow mounts to continue with missing devices.  A read-write mount may
+	fail with too many devices missing, for example if a stripe member
+	is completely missing.
+
+  device=<devicepath>
+	Specify a device during mount so that ioctls on the control device
+	can be avoided.  Especialy useful when trying to mount a multi-device
+	setup as root.  May be specified multiple times for multiple devices.
+
+  discard
+	Issue command to let the block device reclaim space freed by the
+	filesystem.  This is useful for SSD devices, thinly provisioned
+	LUNs and virtual machine images, but may have a performance
+	impact.
+
+  enospc_debug
+	Debugging option to be more verbose in some ENOSPC conditions.
+
+  fatal_errors=<action>
+	Action to take when encountering a fatal error: 
+	  "bug" - BUG() on a fatal error.  This is the default.
+	  "panic" - panic() on a fatal error.
+
+  flushoncommit
+	The 'flushoncommit' mount option forces any data dirtied by a write in a
+	prior transaction to commit as part of the current commit.  This makes
+	the committed state a fully consistent view of the file system from the
+	application's perspective (i.e., it includes all completed file system
+	operations).  This was previously the behavior only when a snapshot is
+	created.
+
+  inode_cache
+	Enable free inode number caching.   Defaults to off due to an overflow
+	problem when the free space crcs don't fit inside a single page.
+
+  max_inline=<bytes>
+	Specify the maximum amount of space, in bytes, that can be inlined in
+	a metadata B-tree leaf.  The value is specified in bytes, optionally 
+	with a K, M, or G suffix, case insensitive.  In practice, this value
+	is limited by the root sector size, with some space unavailable due
+	to leaf headers.  For a 4k sectorsize, max inline data is ~3900 bytes.
+
+  metadata_ratio=<value>
+	Specify that 1 metadata chunk should be allocated after every <value>
+	data chunks.  Off by default.
+
+  noacl
+	Disable support for Posix Access Control Lists (ACLs).  See the
+	acl(5) manual page for more information about ACLs.
+
+  nobarrier
+        Disables the use of block layer write barriers.  Write barriers ensure
+	that certain IOs make it through the device cache and are on persistent
+	storage.  If used on a device with a volatile (non-battery-backed)
+	write-back cache, this option will lead to filesystem corruption on a
+	system crash or power loss.
+
+  nodatacow
+	Disable data copy-on-write for newly created files.  Implies nodatasum,
+	and disables all compression.
+
+  nodatasum
+	Disable data checksumming for newly created files.
+
+  notreelog
+	Disable the tree logging used for fsync and O_SYNC writes.
+
+  recovery
+	Enable autorecovery attempts if a bad tree root is found at mount time.
+	Currently this scans a list of several previous tree roots and tries to 
+	use the first readable.
+
+ skip_balance
+	Skip automatic restart of previous balance operation after mount.  May
+	be restarted with "btrfs device balance"
+
+  space_cache (*)
+	Enable the on-disk freespace cache.
+  nospace_cache
+	Disable freespace cache loading without clearing the cache.
+  clear_cache
+	Force clearing and rebuilding of the disk space cache if something
+	has gone wrong.
+
+  ssd
+  nossd
+  ssd_spread
+	Options to control ssd allocation schemes.  By default, BTRFS will
+	enable or disable ssd allocation heuristics depending on whether a
+	rotational or nonrotational disk is in use.  The ssd and nossd options
+	can override this autodetection.
+
+	The ssd_spread mount option attempts to allocate into big chunks
+	of unused space, and may perform better on low-end ssds.  ssd_spread
+	implies ssd, enabling all other ssd heuristics as well.
+
+  subvol=<path>
+	Mount subvolume at <path> rather than the root subvolume.  <path> is
+	relative to the top level subvolume.
+
+  subvolid=<ID>
+	Mount subvolume specified by an ID number rather than the root subvolume.
+	This allows mounting of subvolumes which are not in the root of the mounted
+	filesystem.
+	You can use "btrfs subvolume list" to see subvolume ID numbers.
+
+  subvolrootid=<objectid> (deprecated)
+	Mount subvolume specified by <objectid> rather than the root subvolume.
+	This allows mounting of subvolumes which are not in the root of the mounted
+	filesystem.
+	You can use "btrfs subvolume show " to see the object ID for a subvolume.
+	
+  thread_pool=<number>
+	The number of worker threads to allocate.  The default number is equal
+	to the number of CPUs + 2, or 8, whichever is smaller.
+
+  user_subvol_rm_allowed
+	Allow subvolumes to be deleted by a non-root user. Use with caution. 
+
+MAILING LIST
+============
 
 There is a Btrfs mailing list hosted on vger.kernel.org. You can
 find details on how to subscribe here:
@@ -49,8 +213,8 @@ http://dir.gmane.org/gmane.comp.file-systems.btrfs
 
 
 
-	IRC
-	===
+IRC
+===
 
 Discussion of Btrfs also occurs on the #btrfs channel of the Freenode
 IRC network.

