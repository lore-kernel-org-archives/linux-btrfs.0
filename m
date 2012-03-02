From: Kyle Gates <kylegates@hotmail.com>
Subject: nocow flags
Date: Fri, 2 Mar 2012 11:29:40 -0600
Message-ID: <COL113-W450746A36272A165E90E1FB06D0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


I set the C (NOCOW) and z (Not_Compressed) flags on a folder but the extent counts of files contained there keep increasing.
Said files are large and frequently modified but not changing in size. This does not happen when the filesystem is mounted with nodatacow.

I'm using this as a workaround since subvolumes can't be mounted with different options simultaneously. ie. one with COW, one with nodatacow

Any ideas why the flags are being ignored?

I'm running 32bit 3.3rc4 with noatime,nodatasum,space_cache,autodefrag,inode_cache on a 3 disk RAID0 data RAID1 metadata filesystem.

Thanks,
Kyle
 		 	   		  