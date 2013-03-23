Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:59405 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab3CWUff (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Mar 2013 16:35:35 -0400
Received: by mail-ea0-f175.google.com with SMTP id o10so1814598eaj.20
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Mar 2013 13:35:33 -0700 (PDT)
Date: Sat, 23 Mar 2013 22:35:32 +0200
From: Ilya Dryomov <idryomov@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: document mount options in
 Documentation/fs/btrfs.txt
Message-ID: <20130323203532.GA1920@zambezi.lan>
References: <514DEB06.7000606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <514DEB06.7000606@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 23, 2013 at 12:48:54PM -0500, Eric Sandeen wrote:
> Document all current btrfs mount options.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> please, Please, PLEASE review this and suggest improvements.
> I'm no btrfs wizard but I've done my best to get this all right
> based on commit logs, code reading, and wiki reading.  In cases where
> any of those 3 disagreed, I've done my best to document reality, but I'm
> sure it could use corrections, clarifications, etc.
> 
> In particular, some of these mount options could really use more
> description of why a user might want them, rather than simply stating
> what they do.
> 
> "notreelog" is particularly egregious, as I have nothing but self-referential
> documentation.
> 
> So this can use some iteration, I'm sure, but hopefully it's a decent
> start.
> 
> Thanks,
> -Eric
> 
> diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
> index 7671352..02a19c8 100644
> --- a/Documentation/filesystems/btrfs.txt
> +++ b/Documentation/filesystems/btrfs.txt
> @@ -1,6 +1,6 @@
>  
> -	BTRFS
> -	=====
> +BTRFS
> +=====
>  
>  Btrfs is a new copy on write filesystem for Linux aimed at
>  implementing advanced features while focusing on fault tolerance,
> @@ -34,9 +34,173 @@ The main Btrfs features include:
>      * Online filesystem defragmentation
>  
>  
> -
> -	MAILING LIST
> -	============
> +Mount Options
> +=============
> +
> +When mounting a btrfs filesystem, the following option are accepted.
> +Unless otherwise specified, all options default to off.
> +
> +  alloc_start=<bytes>
> +	Debugging option to force all block allocations above a threshold.
> +	The value is specified in bytes, optionally with a K, M, or G suffix,
> +	case insensitive.  Default is 1MB.
> +
> +  autodefrag
> +	Detect small random writes into files and queue them up for the
> +	defrag process.  Works best for small files; Not well suited for
> +	large database workloads.
> +
> +  check_int
> +  check_int_data
> +  check_int_print_mask=<value>
> +	These debugging options control the behavior of the integrity checking
> +	module (the BTRFS_FS_CHECK_INTEGRITY config option required).
> +
> +	check_int enables the integrity checker module, which examines all
> +	block write requests to ensure on-disk consistency, at a large
> +	memory and CPU cost.  
> +
> +	check_int_data includes extent data in the integrity checks, and
> +	implies the check_int option.
> +
> +	check_int_print_mask takes a bitmask of BTRFSIC_PRINT_MASK_* values
> +	as defined in fs/btrfs/check-integrity.c, to control the integrity
> +	checker module behavior.
> +
> +	See comments at the top of fs/btrfs/check-integrity.c for more info.
> +
> +  compress
> +  compress=<type>
> +  compress-force
> +  compress-force=<type>
> +	Control BTRFS file data compression.  Type may be specified as "zlib"
> +	"lzo" or "no" (for no compression, used for remounting).  If no type
> +	is specified, zlib is used.  If compress-force is specified,
> +	all files will be compressed, whether or not they compress well.
> +	If compression is enabled, nodatacow and nodatasum are disabled.
> +
> +  degraded
> +	Allow mounts to continue with missing devices.  A read-write mount may
> +	fail with too many devices missing, for example if a stripe member
> +	is completely missing.
> +
> +  device=<devicepath>
> +	Specify a device during mount so that ioctls on the control device
> +	can be avoided.  Especialy useful when trying to mount a multi-device
> +	setup as root.  May be specified multiple times for multiple devices.
> +
> +  discard
> +	Issue command to let the block device reclaim space freed by the
> +	filesystem.  This is useful for SSD devices, thinly provisioned
> +	LUNs and virtual machine images, but may have a performance
> +	impact.
> +
> +  enospc_debug
> +	Debugging option to be more verbose in some ENOSPC conditions.
> +
> +  fatal_errors=<action>
> +	Action to take when encountering a fatal error: 
> +	  "bug" - BUG() on a fatal error.  This is the default.
> +	  "panic" - panic() on a fatal error.
> +
> +  flushoncommit
> +	The 'flushoncommit' mount option forces any data dirtied by a write in a
> +	prior transaction to commit as part of the current commit.  This makes
> +	the committed state a fully consistent view of the file system from the
> +	application's perspective (i.e., it includes all completed file system
> +	operations).  This was previously the behavior only when a snapshot is
> +	created.
> +
> +  inode_cache
> +	Enable free inode number caching.   Defaults to off due to an overflow
> +	problem when the free space crcs don't fit inside a single page.
> +
> +  max_inline=<bytes>
> +	Specify the maximum amount of space, in bytes, that can be inlined in
> +	a metadata B-tree leaf.  The value is specified in bytes, optionally 
> +	with a K, M, or G suffix, case insensitive.  In practice, this value
> +	is limited by the root sector size, with some space unavailable due
> +	to leaf headers.  For a 4k sectorsize, max inline data is ~3900 bytes.
> +
> +  metadata_ratio=<value>
> +	Specify that 1 metadata chunk should be allocated after every <value>
> +	data chunks.  Off by default.
> +
> +  noacl
> +	Disable support for Posix Access Control Lists (ACLs).  See the
> +	acl(5) manual page for more information about ACLs.
> +
> +  nobarrier
> +        Disables the use of block layer write barriers.  Write barriers ensure
> +	that certain IOs make it through the device cache and are on persistent
> +	storage.  If used on a device with a volatile (non-battery-backed)
> +	write-back cache, this option will lead to filesystem corruption on a
> +	system crash or power loss.
> +
> +  nodatacow
> +	Disable data copy-on-write for newly created files.  Implies nodatasum,
> +	and disables all compression.
> +
> +  nodatasum
> +	Disable data checksumming for newly created files.
> +
> +  notreelog
> +	Disable the tree logging used for fsync and O_SYNC writes.
> +
> +  recovery
> +	Enable autorecovery attempts if a bad tree root is found at mount time.
> +	Currently this scans a list of several previous tree roots and tries to 
> +	use the first readable.
> +
> + skip_balance
> +	Skip automatic restart of previous balance operation after mount.  May
                       resume      interrupted

> +	be restarted with "btrfs device balance"

May be resumed with "btrfs balance resume" or cancelled with "btrfs
balance cancel".  skip_balance simply keeps balance in paused state.
Feel free to word this appropriately ;)

Thanks,

		Ilya
