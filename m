From: Chris Mason <chris.mason@oracle.com>
Subject: btrfs-unstable tree updated to 2.6.29-rc3
Date: Thu, 29 Jan 2009 11:54:20 -0500
Message-ID: <1233248060.13087.15.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've pushed out a largish batch of fixes and improvements, and updated
the unstable tree to 2.6.29-rc3 (a merge conflict on fs/super.c meant I
had to update it).

The big change in this push is new locking btree locking code.  mutexes
are no longer used to lock metadata, instead I've switched it to a
spinlock.

But, there are still a number of places we need to have metadata locked
that can sleep, so I've added a flag to the metadata buffers and a wait
queue.  When the code needs to sleep with a lock held, there are calls
to drop the spin lock and force others to wait on the wait queue instead
of spinning.

Overall, its faster than the old code because the most common places
where we don't sleep (btree searching) get covered by the spin lock.
More importantly, it makes the places we do sleep explicit and easy to
trace.  This way we can go through and get rid of them one by one in an
orderly (and testable) fashion.


Other changes:

* Jim Owen's selinux work.  Thanks Jim, this was included so the fedora
guys could run with btrfs

* Turn off leak debugging and get rid of the per-FS hash lock.  Both of
these reduce system time used in every workload.

* Sort references in btrfs_inc_ref before diving into the extent
allocation tree to update them.  This makes it much more likely we'll do
efficient IO and find things in cache as we go.

* readdir fix on 32 bit machines.  glibc was having problems in some
cases with an offset from btrfs that was too large.

* Fix IO stalls on multi-device filesystems.  I think I really got this
one this time, the async threading code was missing a wakeup call.

The unstable tree hasn't been updated yet, I want to keep it compiling
against 2.6.28 at the very least.  So, I'm making that merging tree
today with the 2.6.28 backports.

-chris


