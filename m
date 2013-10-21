Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab3JUVUl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 17:20:41 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id DB901A5FC2
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 23:20:39 +0200 (CEST)
Message-Id: <20131021211940.432195222@suse.com>
Date: Mon, 21 Oct 2013 17:19:40 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [patch 00/13] sysfs publishing patchset
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset implements the stubbed-out sysfs interface for btrfs. Or
at least begins to do so.

We publish:
- Features supported by the file system implementation
- Features enabled on the file system, including features unknown to
  the implemenation. These attributes can also be used to enable or
  disable features at runtime, subjecting to a safety mask.
- Uses the attribute names to print feature names when declining to
  mount a file system.
- The allocation data: global metadata reservation size and reserved,
  space_infos, and sums of the block groups total and used bytes.
- Device membership via links to the block devices.
- FS label, which is writeable.

- I've also added matching ioctls for some of the functionality here so
  that btrfsprogs can use the information without jumping through hoops
  to read/parse the sysfs files. There are ioctls to query the supported
  features and to query/set features on a particular file system. There's
  also one to export the size of the global metadata reservation. I have
  a patch for btrfs-progs that uses this to print useful info in 'btrfs
  fi df' output.

Ultimately, the tree structure looks like the following, under /sys/fs/btrfs.
This is from a test file system, using two devices in raid1. You'll notice
the 'single' and 'raid1' directories under the {data,metadata,system} dirs.
The raid profiles are created and removed as the first/last block group
of a certain profile is added and removed.

<fsid>/devices/sdc1
<fsid>/devices/sdd1
<fsid>/label
<fsid>/allocation/data/flags
<fsid>/allocation/data/raid1/used_bytes
<fsid>/allocation/data/raid1/total_bytes
<fsid>/allocation/data/bytes_pinned
<fsid>/allocation/data/bytes_may_use
<fsid>/allocation/data/total_bytes_pinned
<fsid>/allocation/data/bytes_reserved
<fsid>/allocation/data/bytes_used
<fsid>/allocation/data/single/used_bytes
<fsid>/allocation/data/single/total_bytes
<fsid>/allocation/data/total_bytes
<fsid>/allocation/data/disk_total
<fsid>/allocation/data/disk_used
<fsid>/allocation/metadata/flags
<fsid>/allocation/metadata/raid1/used_bytes
<fsid>/allocation/metadata/raid1/total_bytes
<fsid>/allocation/metadata/bytes_pinned
<fsid>/allocation/metadata/bytes_may_use
<fsid>/allocation/metadata/total_bytes_pinned
<fsid>/allocation/metadata/bytes_reserved
<fsid>/allocation/metadata/bytes_used
<fsid>/allocation/metadata/single/used_bytes
<fsid>/allocation/metadata/single/total_bytes
<fsid>/allocation/metadata/total_bytes
<fsid>/allocation/metadata/disk_total
<fsid>/allocation/metadata/disk_used
<fsid>/allocation/global_rsv_size
<fsid>/allocation/global_rsv_reserved
<fsid>/allocation/system/flags
<fsid>/allocation/system/raid1/used_bytes
<fsid>/allocation/system/raid1/total_bytes
<fsid>/allocation/system/bytes_pinned
<fsid>/allocation/system/bytes_may_use
<fsid>/allocation/system/total_bytes_pinned
<fsid>/allocation/system/bytes_reserved
<fsid>/allocation/system/bytes_used
<fsid>/allocation/system/single/used_bytes
<fsid>/allocation/system/single/total_bytes
<fsid>/allocation/system/total_bytes
<fsid>/allocation/system/disk_total
<fsid>/allocation/system/disk_used
<fsid>/features/mixed_backref
<fsid>/features/extended_iref
features/compress_lzo
features/big_metadata
features/compress_lzov2
features/default_subvol
features/mixed_backref
features/raid56
features/mixed_groups
features/skinny_metadata
features/extended_iref

-Jeff


