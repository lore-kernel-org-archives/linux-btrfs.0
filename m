From: Simon Kirby <sim@hostway.ca>
Subject: ring btrfs
Date: Wed, 29 Sep 2010 18:19:20 -0700
Message-ID: <20100930011920.GA14974@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Just curious...

I've been wondering if it would possible/useful to make a btrfs mode
where it _always_ writes in a ring on the entire disk.  Since it can
write "anywhere" already, it could just write sequentially always.

The write process would have to be changed to read a blob, throw away
the garbage, and fit in the new stuff in the gaps, then write the blob.
Write performance would degrade to half once the disk is half full of
stuff that can't be thrown away, but then almost all file I/O patterns
should be about the same speed, because disk writes are only sequential.

Or is it that it's pretty much always like this until space is tight
anyway?  I suspect that eventually free space will be pretty fragmented,
and it'll have to seek a lot just to write in available space.  Perhaps
the performance is similar or worse to sequential read+write versus just
writing in the gaps in many/all cases?

Maybe this what nilfs2, etc., are all about, in which case maybe it would
be neat to have a mount option or even realtime heuristic-based switching
if load patterns fit better to a particular mode...

Simon-
