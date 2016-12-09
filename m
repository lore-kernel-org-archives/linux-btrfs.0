Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:7388 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750807AbcLIFOE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Dec 2016 00:14:04 -0500
Date: Fri, 9 Dec 2016 16:13:59 +1100
From: Dave Chinner <david@fromorbit.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Jan Kara <jack@suse.cz>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 4/6] Btrfs: add DAX support for nocow btrfs
Message-ID: <20161209051359.GO4219@dastard>
References: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
 <1481147110-20048-5-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1481147110-20048-5-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 07, 2016 at 01:45:08PM -0800, Liu Bo wrote:
> Since I haven't figure out how to map multiple devices to userspace without
> pagecache, this DAX support is only for single-device, and I don't think
> DAX(Direct Access) can work with cow, this is limited to nocow case.  I made
> this by setting nodatacow in dax mount option.

DAX can be made to work with COW quite easily - it's already been
done, in fact. Go look up Nova for how it works with DAX:

https://github.com/Andiry/nova

Essentially, it has a set of "temporary pages" it links to the inode
where writes are done directly, and when a synchronisation event
occurs it pulls them from the per-inode list, does whatever
transformations are needed (e.g. CRC calculation, mirroring, etc)
and marks them them as current in the inode extent list.

When a new overwrite comes along, it allocates a new block in the
temporary page list, copies the existing data into it, and then uses
that block for DAX until the next synchronisation event occurs.

For XFS, CoW for DAX through read/write isn't really any different
to the direct IO path we currently already have. And for page write
faults on shared extents, instead of zeroing the newly allocated
block we simply copy the original data into the new block before the
allocation returns. It does mean, however, that XFS does not have
the capability for data transformations in the IO path. This limits
us to atomic write devices (software raid 0 or hardware redundancy
such as DIMM mirroring), but we can still do out-of-band online data
transformations and movement (e.g. dedupe, defrag) with DAX.

Yes, I know these methods are very different to how btrfs uses COW.
However, my point is that DAX and CoW and/or mulitple devices are
not incompatible if the architecture is correctly structured. i.e
DAX should be able to work even with most of btrfs's special magic
still enabled.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
