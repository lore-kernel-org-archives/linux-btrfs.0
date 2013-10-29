Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:61914 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3J2SZ5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 14:25:57 -0400
Received: by mail-ea0-f172.google.com with SMTP id r16so116204ead.17
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 11:25:55 -0700 (PDT)
Message-ID: <526FFDB2.3040301@gmail.com>
Date: Tue, 29 Oct 2013 19:25:54 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [patch 00/13] sysfs publishing patchset
References: <20131021211940.432195222@suse.com>
In-Reply-To: <20131021211940.432195222@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jeff,

On 2013-10-21 23:19, Jeff Mahoney wrote:
> This patchset implements the stubbed-out sysfs interface for btrfs. Or
> at least begins to do so.
> 
> We publish:
> - Features supported by the file system implementation
> - Features enabled on the file system, including features unknown to
>   the implemenation. These attributes can also be used to enable or
>   disable features at runtime, subjecting to a safety mask.
> - Uses the attribute names to print feature names when declining to
>   mount a file system.
> - The allocation data: global metadata reservation size and reserved,
>   space_infos, and sums of the block groups total and used bytes.
> - Device membership via links to the block devices.
> - FS label, which is writeable.
> 
> - I've also added matching ioctls for some of the functionality here so
>   that btrfsprogs can use the information without jumping through hoops
>   to read/parse the sysfs files. There are ioctls to query the supported
>   features and to query/set features on a particular file system. There's
>   also one to export the size of the global metadata reservation. I have
>   a patch for btrfs-progs that uses this to print useful info in 'btrfs
>   fi df' output.
> 
> Ultimately, the tree structure looks like the following, under /sys/fs/btrfs.
> This is from a test file system, using two devices in raid1. You'll notice
> the 'single' and 'raid1' directories under the {data,metadata,system} dirs.
> The raid profiles are created and removed as the first/last block group
> of a certain profile is added and removed.

I really appreciate your work. In the past I tried to push a similar
patch set but without success [*]

I hope that it is not too late, but I have a request:
it is possible to move the filesystems under a fs/ directory ? Something
like

[...]
fs/<fsid>/allocation/system/disk_used
fs/<fsid>/features/mixed_backref
fs/<fsid>/features/extended_iref
features/compress_lzo
features/big_metadata
features/compress_lzov2
[...]

This for two reasons:
1) so it would be possible to show also the disks informations under a
dev/ directory. It would be possible to handle the case that some disks
are registered in btrfs but the related filesystems aren't mounted (like
after a "btrfs dev scan" command)
2) it would help the browsing of the /sys/btrfs/ hierarchy: every
directory under /sys/btrfs/fs/ represents a filesystem. With the current
structure not all the directory under /sys/btrfs are related to a
filesystem (like the features/ one, but I am sure that other directories
sooner or later will appear)

If you interested I can contribute with some patches.

BR
G.Baroncelli

[*] http://lwn.net/Articles/513706/

> 
> <fsid>/devices/sdc1
> <fsid>/devices/sdd1
> <fsid>/label
> <fsid>/allocation/data/flags
> <fsid>/allocation/data/raid1/used_bytes
> <fsid>/allocation/data/raid1/total_bytes
> <fsid>/allocation/data/bytes_pinned
> <fsid>/allocation/data/bytes_may_use
> <fsid>/allocation/data/total_bytes_pinned
> <fsid>/allocation/data/bytes_reserved
> <fsid>/allocation/data/bytes_used
> <fsid>/allocation/data/single/used_bytes
> <fsid>/allocation/data/single/total_bytes
> <fsid>/allocation/data/total_bytes
> <fsid>/allocation/data/disk_total
> <fsid>/allocation/data/disk_used
> <fsid>/allocation/metadata/flags
> <fsid>/allocation/metadata/raid1/used_bytes
> <fsid>/allocation/metadata/raid1/total_bytes
> <fsid>/allocation/metadata/bytes_pinned
> <fsid>/allocation/metadata/bytes_may_use
> <fsid>/allocation/metadata/total_bytes_pinned
> <fsid>/allocation/metadata/bytes_reserved
> <fsid>/allocation/metadata/bytes_used
> <fsid>/allocation/metadata/single/used_bytes
> <fsid>/allocation/metadata/single/total_bytes
> <fsid>/allocation/metadata/total_bytes
> <fsid>/allocation/metadata/disk_total
> <fsid>/allocation/metadata/disk_used
> <fsid>/allocation/global_rsv_size
> <fsid>/allocation/global_rsv_reserved
> <fsid>/allocation/system/flags
> <fsid>/allocation/system/raid1/used_bytes
> <fsid>/allocation/system/raid1/total_bytes
> <fsid>/allocation/system/bytes_pinned
> <fsid>/allocation/system/bytes_may_use
> <fsid>/allocation/system/total_bytes_pinned
> <fsid>/allocation/system/bytes_reserved
> <fsid>/allocation/system/bytes_used
> <fsid>/allocation/system/single/used_bytes
> <fsid>/allocation/system/single/total_bytes
> <fsid>/allocation/system/total_bytes
> <fsid>/allocation/system/disk_total
> <fsid>/allocation/system/disk_used
> <fsid>/features/mixed_backref
> <fsid>/features/extended_iref
> features/compress_lzo
> features/big_metadata
> features/compress_lzov2
> features/default_subvol
> features/mixed_backref
> features/raid56
> features/mixed_groups
> features/skinny_metadata
> features/extended_iref
> 
> -Jeff
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
