From: Chris Mason <chris.mason@oracle.com>
Subject: New thread pools pushed out to the unstable tree
Date: Wed, 11 Jun 2008 22:09:27 -0400
Message-ID: <1213236567.10187.263.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've been meaning to improve on checksumming scalability for a while.

The old code used workqueues to create checksums during writes and to
verify them after a read.  This didn't scale very well to multiple CPUs.
For streaming writes it might be common for a single CPU to be going at
100% while the other CPUs sit idle.

The new code uses a pool of kthreads and scales much better to a larger
number of disks and cpus.  (almost 2x faster on my larger test rig).

Of course, by scaling better I mean is better able to consume all of the
available CPU power, which might not be what everyone wants.

mount -o thread_pool=n will control the size of the pool.  2 will give
you something very close to the old code.  The new default is 8.

If you're counting kernel threads in the ps output, btrfs actually
creates one pool for readers and one for writers.  This avoids a long
list of deadlocks.

-chris


