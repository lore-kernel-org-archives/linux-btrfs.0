From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Auto-sparseifying
Date: Thu, 11 Dec 2008 09:57:35 -0500
Message-ID: <1229007455.22236.60.camel@think.oraclecorp.com>
References: <1228989948.17969.24.camel@mattos-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228989948.17969.24.camel@mattos-laptop>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-12-11 at 10:05 +0000, Oliver Mattos wrote:
> Hi,
> 
> I've noticed many files have blocks of plain nulls up to a few kb long,
> even files you wouldn't normally expect to, like ELF executables.  I
> know that with compression enabled these will compress very small, but
> that will have a reasonable hit on performance.  How much of an overhead
> would it be to check all checksummed file extents to see if they match
> the checksum for a blank (null filled) extent, and if it does then don't
> save that data?   You may not even want to do it with checksums - just
> by reading the first few bytes of data and checking for "nullness" would
> let you know if the block is null or not.  (if the first 4 bytes are
> null, then the whole block is likely to be nulls, so it's worth the
> overhead of checking the whole block)
> 
> This would seem like a particularly low overhead space and performance
> tweak.  (performance since read/write speed will be increased for
> "average" files that contain a few null blocks)
> 
> Any thoughts?

The first comment is that it won't be as fast as you expect ;)  Most
disks read 64k of data about as fast as they read 4k of data, and so if
you have a file with zeros sprinkled around the disk will end up reading
the zeros and just not sending them back to you.

Jim is definitely right about the cost of metadata for smaller extents.
Putting pointers to the zero extent into the file will greatly increase
the number of extents needed to describe a single file.

Traditional filesystems usually don't detect zeros and skip them because
userland will often write zeros to preallocate the file.  Unless btrfs
is in nodatacow mode, that preallocation step doesn't really impact
layout and we could map zeros to a virtual extent that was never written
or read.

But at the end of the day, the main place that zeros come from is
benchmarking programs.  I would prefer to use compression or dedup and
get larger benefits than to optimize away 4k at a time here and there.

-chris


