Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:8627
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934044Ab3BTQqW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 11:46:22 -0500
Date: Wed, 20 Feb 2013 17:46:05 +0100
From: Matias Bjorling <mabj@itu.dk>
To: <jmad@itu.dk>, <linux-btrfs@vger.kernel.org>, <chris.mason@fusionio.com>,
        <dsterba@suse.cz>
Subject: Hybrid Storage proposal
Message-ID: <20130220164605.GA13504@uflip.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is a short proposal for the hybrid storage cache idea with 
introduction/motivation and a bird's eye view of an approach to implement a 
hybrid storage cache for btrfs. Please note that there is currently no available 
patches. We would like to get as much input before as possible before we start 
designing and implementing a solution.

1. Introduction

The emerge of Solid State Drives (SSD) change how data is stored for fast
accesses. Their high throughput and low latency characteristics make them a good
choice for applications that traditionally require many hard-drives.

SSDs are still more expensive per GB, making traditional hard-drives a good and 
affordable solution to store bulk amount of data. Often, the working set of a 
filesystem is smaller than the full capacity of a drive. We can exploit this by
extending the often used bulk data on SSDs. We prioritize data that is often
accessed randomly, while larger bulk operations are kept on bulk storage.

Recent development in Linux SSD caches, uses a block IO approach to solve
caching. The approach assumes that data is stable on disk and evicts data based 
on LRU, temparature, etc. This is great for read only IO patterns and in-place
writes. However, btrfs uses a copy on write approach, that reduces the benefits 
of block IO caching. The block caches are unable to track updates (require 
extensive hints forth and back between the cache layer). Additionally, data and 
metadata is the same to the block layer.

The internal file-system information available within btrfs allows separation of
these types of updates and enables fine-grained control of a to-be implemented
cache.

2 Overview

The design space for a cache is divided into read and writes. For both read
and write caches, we divide them into caching metadata (trees) accesses or
user data. Writes are further divided into either being write-back or
write-through.

2.1 Overview

Any device attached to the storage pool should allow to be used as a cache. It
is natural to store the cache in the already implemented chunk architecture (as
cache chunks). Each allocated cache chunk may? be available to one or more 
subvolumes.

2.2 Caching hierarchy

By adding an extra layer, we have the following access pattern: host memory -> 
SSD or Disk -> Disk.

  - Host memory caches lookup paths, transactions, free space infomation, etc.
  - SSD/disk cache frequently used data or writes for data that cannot be in 
    host memory.
  - Traditional hard-drives store the largest amount of data and store a 
    complete copy of all data.

2.3 Hotness tracking

The data to cache is defined by some hotness algorithm, which can be applied to 
different layers of btrfs:

  - Inode level
    The recently implemented VFS hot track patches enable us to detect hotness
    for files within any given VFS file-system implementation. For reads that
    are within a tunable cache size, we either cache the tree leaf or its 
    extent.
    For writes, we track the tree updates and write the tree updates to the SSD.
    If the file is larger and it receives a considerable amount of reads or
    writes, their hot subparts should be cached.

  - Tree level
    Within the fs, we can track the hotness of each tree. If a tree is
    read or updated frequently, it should be served by the SSD cache.

  - Extent level
    Hole or parts of extents should be tracked and cached if needed.

2.4 Cache opportunities:

- Hotness tracking for random reads

  Define threshold for when to cache reads. Back of envelope calculation
  tells us to cache when IO size is below 1.5MB. This assumes 100 IO/s and
  a read speed of 150MB/s from the traditional drives. This should be
  tunable.

  If data is updated, we should "follow" the newly written data and evict the
  "old" data from the cache. As such, if the old data was cached, we make sure
  to also cache the new data.

  Implementation details:
    - Use the hot track patches for VFS to track when an inode is hot and then
      cache the reads.
    - Track CoW actions and pre-warm cache.

- Write-back cache 

  * Tree updates

    Updates to trees are batched and flushed every 30 seconds. Flush the updates 
    to cache layer first, and then flush them later to bulk storage.

    When updates are flushed to bulk storage, we reorder IOs to be as sequential
    as possible. This optimization allows us to have higher throughput at
    the cost of sorting writes at flush time.

    The technique requires that we track tree updates between disk cache and
    disk. As our trees are append only, we can track the current generation and
    apply the difference at timed intervals or at mount/unmount times.

    Implementation details: 
      - This can be implemented on a per-tree basis. E.g. specific extent
        trees, checksum tree or other frequently updated tree.

  * Data updates

    Data are placed two places. If small, directly inside the tree leafs or if 
    larger, within extents. If an inode is known to be hot, we cache the updates.

 - Write-through cache for user data

   If the cache isn't "safe", i.e. no duplicate copies. The cache can still be 
   used using write-through and cache subsequent reads.

   This is similar to a pure disk block-based cache approach.

2.5 Other

 - Warmup cache at mount time

   Reread the SSD cache on mount to enjoy a preheated cache of the bulk storage.

   This can be archived by storing information about the cache and reconstruct
   the cache tree.

 - (By David Sterba) Implement appropriate debugfs/sysfs hooks for monitoring
   the cache and get information about the size of trees. This is useful for
   deciding if a tree should be cached on an SSD or not. E.g. the checksum tree
   might always be in memory, but if it isn't, it should be cached on the SSD
   storage to lower checksum tree seeks on the bulk storage.

2.6 Summary

The following list of items have to be addressed for the first full patchset:

 - Cache lookup
 - Cache type (write through, write back, hot tracking, etc.)
 - Data structure for lookup cache
 - Allow for prioritized storage (e.g. PCM>SSD>HDD)
 - Eviction strategy. LRU, LFU, FIFO, Temparature-based (VFS hot track)
 - Disk layout for cache storage

Here we presented our design space for a hybrid drive solution, as well as 
what it would take to carry it out. We are very much open to any kind of input, 
feedback or new ideas you might have.

Sincerely,
Matias & Jesper

