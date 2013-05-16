Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:25133 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab3EPOpK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 10:45:10 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp3) (RZmta 31.27 OK)
	with ESMTP id p05175p4G8aXN7 for <linux-btrfs@vger.kernel.org>;
	Thu, 16 May 2013 16:45:07 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/8] Btrfs: introduce a tree for UUID to subvol ID mapping
Date: Thu, 16 May 2013 16:44:59 +0200
Message-Id: <cover.1368713300.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mapping UUIDs to subvolume IDs is an operation with a high effort
today. Today, the algorithm even has quadratic effort (based on the
number of existing subvolumes), which means, that it takes minutes
to send/receive a single subvolume if 10,000 subvolumes exist. But
even linear effort would be too much since it is a waste. And these
data structures to allow mapping UUIDs to subvolume IDs are created
every time a btrfs send/receive instance is started.

So the issue to address is that Btrfs send / receive does not work
as it is today when a high number of subvolumes exist.

The table below shows the time it takes on my testbox to send _one_
empty subvolume depending on the number of subvolume that exist in
the filesystem.

# of subvols  | without    | with
in filesystem | UUID tree  | UUID tree
--------------+------------+----------
            2 |  0m00.004s | 0m00.003s
         1000 |  0m07.010s | 0m00.004s
         2000 |  0m28.210s | 0m00.004s
         3000 |  1m04.872s | 0m00.004s
         4000 |  1m56.059s | 0m00.004s
         5000 |  3m00.489s | 0m00.004s
         6000 |  4m27.376s | 0m00.004s
         7000 |  6m08.938s | 0m00.004s
         8000 |  7m54.020s | 0m00.004s
         9000 | 10m05.108s | 0m00.004s
        10000 | 12m47.406s | 0m00.004s
        11000 | 15m05.800s | 0m00.004s
        12000 | 18m00.170s | 0m00.004s
        13000 | 21m39.438s | 0m00.004s
        14000 | 24m54.681s | 0m00.004s
        15000 | 28m09.096s | 0m00.004s
        16000 | 33m08.856s | 0m00.004s
        17000 | 37m10.562s | 0m00.004s
        18000 | 41m44.727s | 0m00.004s
        19000 | 46m14.335s | 0m00.004s
        20000 | 51m55.100s | 0m00.004s
        21000 | 56m54.346s | 0m00.004s
        22000 | 62m53.466s | 0m00.004s
        23000 | 66m57.328s | 0m00.004s
        24000 | 73m59.687s | 0m00.004s
        25000 | 81m24.476s | 0m00.004s
        26000 | 87m11.478s | 0m00.004s
        27000 | 92m59.225s | 0m00.004s

Or as a chart:
http://btrfs.giantdisaster.de/Btrfs-send-recv-perf.pdf

It is much more efficient to maintain a searchable persistent data
structure in the filesystem, one that is updated whenever a
subvolume/snapshot is created and deleted, and when the received
subvolume UUID is set by the btrfs-receive tool.

Therefore kernel code is added that is able to maintain data
structures in the filesystem that allow to quickly search for a
given UUID and to retrieve the subvol ID.

Now follows the lengthy justification, why a new tree was added
instead of using the existing root tree:

The first approach was to not create another tree that holds UUID
items. Instead, the items should just go into the top root tree.
Unfortunately this confused the algorithm to assign the objectid
of subvolumes and snapshots. The reason is that
btrfs_find_free_objectid() calls btrfs_find_highest_objectid() for
the first created subvol or snapshot after mounting a filesystem,
and this function simply searches for the largest used objectid in
the root tree keys to pick the next objectid to assign. Of course,
the UUID keys have always been the ones with the highest offset
value, and the next assigned subvol ID was wastefully huge.

To use any other existing tree did not look proper. To apply a
workaround such as setting the objectid to zero in the UUID item
key and to implement collision handling would either add
limitations (in case of a btrfs_extend_item() approach to handle
the collisions) or a lot of complexity and source code (in case a
key would be looked up that is free of collisions). Adding new code
that introduces limitations is not good, and adding code that is
complex and lengthy for no good reason is also not good. That's the
justification why a completely new tree was introduced.

v1 -> v2:
- All review comments from David Sterba, Josef Bacik and Jan Schmidt
  are addressed.
  The hugest change was to add a mechanism that handles the case that
  the filesystem is mounted with an older kernel. Now that case is
  detected when the filesystem is mounted with a newer kernel again,
  and the UUID tree is updated in the background.

v2 -> v3:
- All review comments from Liu Bo are addressed:
  - shrinked the size of the uuid_item.
  - fixed the issue that the uuid-tree was not using the transaction
    block reserve.

Stefan Behrens (8):
  Btrfs: introduce a tree for items that map UUIDs to something
  Btrfs: support printing UUID tree elements
  Btrfs: create UUID tree if required
  Btrfs: maintain subvolume items in the UUID tree
  Btrfs: fill UUID tree initially
  Btrfs: introduce uuid-tree-gen field
  Btrfs: check UUID tree during mount if required
  Btrfs: add mount option to force UUID tree checking

 fs/btrfs/Makefile      |   3 +-
 fs/btrfs/ctree.h       |  65 ++++-
 fs/btrfs/disk-io.c     |  62 ++++-
 fs/btrfs/extent-tree.c |   3 +
 fs/btrfs/ioctl.c       |  74 +++++-
 fs/btrfs/print-tree.c  |  81 +++++++
 fs/btrfs/super.c       |   8 +-
 fs/btrfs/transaction.c |  21 +-
 fs/btrfs/uuid-tree.c   | 636 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c     | 257 ++++++++++++++++++++
 fs/btrfs/volumes.h     |   2 +
 11 files changed, 1197 insertions(+), 15 deletions(-)
 create mode 100644 fs/btrfs/uuid-tree.c

-- 
1.8.2.3

