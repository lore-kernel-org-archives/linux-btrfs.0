From: Sage Weil <sage@newdream.net>
Subject: [PATCH 0/5] asynchronous commit, snapshot ponies
Date: Mon, 22 Mar 2010 12:13:25 -0700
Message-ID: <1269285210-19085-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

This patchset is the latest approach I'm using for the Ceph storage daemon to
keep track of which data has safely committed to disk.  The basic idea is to
not use the (problematic) user transaction ioctls at all.  Instead, the daemon
quiesces its own write requests, initiates an async snapshot, and then
continues.

The snapshot approach is nice because it provides rollback.  If something goes
wrong, we can cleanly go back to the most recent consistent commit.  The
performance is also very similar to what I was doing before (using the
'flushoncommit' mount option and tiggering a sync_fs to flush data).  The only
difference is the old snapshots stick around for a bit longer before I delete
them and the references get dropped.

The first patch introduces a generic btrfs_commit_transaction_async() helper,
which starts btrfs_commit_transaction asynchronously and returns either
when the commit starts (blocked=1) or when it has done it's dirty work
(blocked=0).  The second patch adds ioctls that let you start and wait for
an asynchronous commit.  The third introduces a SNAP_CREATE_ASYNC ioctl that
creates a snap but returns before it hits disk.

The fourth patch returns the commiting transid to userspace, so that it can be
fed to the WAIT_SYNC ioctl.  I'm not that happy with the interface, though; any
suggestions for alternatives would be great.  Alternatively, I could get by
without knowing the exact transid and it wouldn't be the end of the world.

The final patch lets you delete a snapshot/subvol reference without doing an
immediate commit (btrfs_end_transaction instead of btrfs_commit_transaction).
AFAICS there's no reason the commit has to happen immediately (user expectations
aside).

Overall I like this much better than the various user transaction proposals.
It's simpler, does the job, and the primitives should be useful for other
applications.  Let me know what you think!  I'm doing more testing this week,
but so far I haven't seen any problems with these changes.

Thanks-
sage

Sage Weil (5):
  Btrfs: async transaction commit
  Btrfs: add START_SYNC, WAIT_SYNC ioctls
  Btrfs: add SNAP_CREATE_ASYNC ioctl
  Btrfs: return transid to userspace from SNAP_CREATE_ASYNC ioctl
  btrfs: add SNAP_DESTROY_ASYNC ioctl

 fs/btrfs/ctree.h       |    1 +
 fs/btrfs/disk-io.c     |    1 +
 fs/btrfs/ioctl.c       |   94 ++++++++++++++++++++++----
 fs/btrfs/ioctl.h       |   10 +++-
 fs/btrfs/transaction.c |  171 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.h |    4 +
 6 files changed, 265 insertions(+), 16 deletions(-)

