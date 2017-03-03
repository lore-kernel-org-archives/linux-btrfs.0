Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6290 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751333AbdCCJCY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 04:02:24 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 00/17] fs, btrfs refcount conversions
Date: Fri,  3 Mar 2017 10:55:09 +0200
Message-Id: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now when new refcount_t type and API are finally merged
(see include/linux/refcount.h), the following
patches convert various refcounters in the btrfs filesystem from atomic_t
to refcount_t. By doing this we prevent intentional or accidental
underflows or overflows that can led to use-after-free vulnerabilities.

The below patches are fully independent and can be cherry-picked separately.
Since we convert all kernel subsystems in the same fashion, resulting
in about 300 patches, we have to group them for sending at least in some
fashion to be manageable. Please excuse the long cc list.

These patches have been tested with xfstests by running btrfs-related tests.
btrfs debug was enabled, warns on refcount errors, too. No output related to
refcount errors produced. However, the following errors were during the run:
 * tests btrfs/078, btrfs/114, btrfs/115, no errors anywhere in dmesg, but
 process hangs. They all seem to be around qgroup, sometimes error visible
 such as qgroup scan failed -4 before it blocks, but not always.
 * test btrfs/104 dmesg has additional error output:
 BTRFS warning (device vdc): qgroup 258 reserved space underflow, have: 0,
 to free: 4096
 I tried looking at the code on what causes the failure, but could not figure
 it out. It doesn't seem to be related to any refcount changes at least IMO.

The above test failures are hard for me to understand and interpreted, but
they don't seem to relate to refcount conversions.

Elena Reshetova (17):
  fs, btrfs: convert btrfs_bio.refs from atomic_t to refcount_t
  fs, btrfs: convert btrfs_transaction.use_count from atomic_t to
    refcount_t
  fs, btrfs: convert extent_map.refs from atomic_t to refcount_t
  fs, btrfs: convert btrfs_ordered_extent.refs from atomic_t to
    refcount_t
  fs, btrfs: convert btrfs_caching_control.count from atomic_t to
    refcount_t
  fs, btrfs: convert btrfs_delayed_ref_node.refs from atomic_t to
    refcount_t
  fs, btrfs: convert btrfs_delayed_node.refs from atomic_t to refcount_t
  fs, btrfs: convert btrfs_delayed_item.refs from atomic_t to refcount_t
  fs, btrfs: convert btrfs_root.refs from atomic_t to refcount_t
  fs, btrfs: convert extent_state.refs from atomic_t to refcount_t
  fs, btrfs: convert compressed_bio.pending_bios from atomic_t to
    refcount_t
  fs, btrfs: convert scrub_recover.refs from atomic_t to refcount_t
  fs, btrfs: convert scrub_page.refs from atomic_t to refcount_t
  fs, btrfs: convert scrub_block.refs from atomic_t to refcount_t
  fs, btrfs: convert scrub_parity.refs from atomic_t to refcount_t
  fs, btrfs: convert scrub_ctx.refs from atomic_t to refcount_t
  fs, btrfs: convert btrfs_raid_bio.refs from atomic_t to refcount_t

 fs/btrfs/backref.c           |  2 +-
 fs/btrfs/compression.c       | 18 ++++++++---------
 fs/btrfs/ctree.h             |  5 +++--
 fs/btrfs/delayed-inode.c     | 46 ++++++++++++++++++++++----------------------
 fs/btrfs/delayed-inode.h     |  5 +++--
 fs/btrfs/delayed-ref.c       |  8 ++++----
 fs/btrfs/delayed-ref.h       |  8 +++++---
 fs/btrfs/disk-io.c           |  6 +++---
 fs/btrfs/disk-io.h           |  4 ++--
 fs/btrfs/extent-tree.c       | 20 +++++++++----------
 fs/btrfs/extent_io.c         | 18 ++++++++---------
 fs/btrfs/extent_io.h         |  3 ++-
 fs/btrfs/extent_map.c        | 10 +++++-----
 fs/btrfs/extent_map.h        |  3 ++-
 fs/btrfs/ordered-data.c      | 20 +++++++++----------
 fs/btrfs/ordered-data.h      |  2 +-
 fs/btrfs/raid56.c            | 19 +++++++++---------
 fs/btrfs/scrub.c             | 42 ++++++++++++++++++++--------------------
 fs/btrfs/transaction.c       | 20 +++++++++----------
 fs/btrfs/transaction.h       |  3 ++-
 fs/btrfs/tree-log.c          |  2 +-
 fs/btrfs/volumes.c           | 10 +++++-----
 fs/btrfs/volumes.h           |  2 +-
 include/trace/events/btrfs.h |  4 ++--
 24 files changed, 143 insertions(+), 137 deletions(-)

-- 
2.7.4

