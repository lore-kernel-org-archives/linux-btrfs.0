From: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Subject: Auto-sparseifying
Date: Thu, 11 Dec 2008 10:05:48 +0000
Message-ID: <1228989948.17969.24.camel@mattos-laptop>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've noticed many files have blocks of plain nulls up to a few kb long,
even files you wouldn't normally expect to, like ELF executables.  I
know that with compression enabled these will compress very small, but
that will have a reasonable hit on performance.  How much of an overhead
would it be to check all checksummed file extents to see if they match
the checksum for a blank (null filled) extent, and if it does then don't
save that data?   You may not even want to do it with checksums - just
by reading the first few bytes of data and checking for "nullness" would
let you know if the block is null or not.  (if the first 4 bytes are
null, then the whole block is likely to be nulls, so it's worth the
overhead of checking the whole block)

This would seem like a particularly low overhead space and performance
tweak.  (performance since read/write speed will be increased for
"average" files that contain a few null blocks)

Any thoughts?

Oliver.

