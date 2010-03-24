From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 0/2] more raid456 thread pool experimentation
Date: Wed, 24 Mar 2010 07:53:10 -0700
Message-ID: <20100324144904.15371.2317.stgit@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The current implementation with the async thread pool ends up spreading
the work over too many threads.  The btrfs workqueue is targeted at high
cpu utilization works and has a threshold mechanism to limit thread
spawning.  Unfortunately it still ends up increasing cpu utilization
without a comparable improvement in throughput.  Here are the numbers
relative to the multicore disabled case:

idle_thresh	throughput	cycles
4		+0%		+102%
64		+4%		+63%
128		+1%		+45%

This appears to show that something more fundamental needs to happen to
take advantage of percpu raid processing.  More profiling is needed, but
the suspects in my mind are conf->device_lock contention and the fact
that all work is serialized through conf->handle_list with no method for
encouraging stripe_head to thread affinity.

The idle_thresh parameter translates to the number of stripes that can
be in a thread's backlog before new work spills over into a new thread.
The current implementation via async is effectively using a threshold of
zero which ends up impacting throughput due to excessive cpu utilization
and thread creation.  I do not think we need any more experimentation
before declaring the current implementation broken.

---

Dan Williams (2):
      btrq: uplevel the btrfs thread pool for md/raid456 usage
      md/raid456: switch to btrq for multicore operation


 drivers/md/Kconfig       |    1 
 drivers/md/raid5.c       |   79 +++++++++++++----------
 drivers/md/raid5.h       |   13 ++--
 fs/btrfs/Kconfig         |    1 
 fs/btrfs/Makefile        |    2 -
 fs/btrfs/ctree.h         |   22 +++---
 fs/btrfs/disk-io.c       |  157 +++++++++++++++++++++++-----------------------
 fs/btrfs/extent-tree.c   |    7 +-
 fs/btrfs/inode.c         |   18 +++--
 fs/btrfs/relocation.c    |   22 +++---
 fs/btrfs/volumes.c       |   12 ++--
 fs/btrfs/volumes.h       |    4 +
 include/linux/btrqueue.h |   36 +++++------
 lib/Kconfig              |    6 ++
 lib/Makefile             |    2 +
 lib/btrqueue.c           |  119 ++++++++++++++++++-----------------
 16 files changed, 265 insertions(+), 236 deletions(-)
 rename fs/btrfs/async-thread.h => include/linux/btrqueue.h (76%)
 rename fs/btrfs/async-thread.c => lib/btrqueue.c (82%)

