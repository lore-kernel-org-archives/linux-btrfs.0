Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6574 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295AbbIDT7l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Sep 2015 15:59:41 -0400
Date: Fri, 4 Sep 2015 15:59:36 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs for 4.3
Message-ID: <20150904195936.GE5136@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus-4.3 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.3

There are a few conflicts with Jens' pulls this time around, so I've put
a sample merge resolution into:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.3-merged

This is the same resolution I sent to linux-next, and the conflicts were
all pretty easy.  The only gotcha I found was this commit:

commit 73ff61dbe5edeb1799d7e91c8b0641f87feb75fa
Author: Omar Sandoval <osandov@fb.com>
Date:   Fri Jun 19 11:52:51 2015 -0700

Adds a new bio end_io callback to fs/btrfs/scrub.c:

+static void scrub_missing_raid56_end_io(struct bio *bio, int error)
+{
+       struct scrub_block *sblock = bio->bi_private;
+       struct btrfs_fs_info *fs_info = sblock->sctx->dev_root->fs_info;
+
+       if (error)
+               sblock->no_io_error_seen = 0;
+
+       btrfs_queue_work(fs_info->scrub_workers, &sblock->work);
+}
+

This needs to be converted to the new style bio->bi_error instead:

static void scrub_missing_raid56_end_io(struct bio *bio)
                                        ^^^^^^^^^^^^^^^^^^^
{
        struct scrub_block *sblock = bio->bi_private;
        struct btrfs_fs_info *fs_info = sblock->sctx->dev_root->fs_info;

        if (bio->bi_error)
	^^^^^^^^^^^^^^^^^^^^
                sblock->no_io_error_seen = 0;

        btrfs_queue_work(fs_info->scrub_workers, &sblock->work);
}

Conflicts aside, this has Jeff Mahoney's long standing trim patch that
fixes corners where trims were missing.  Omar has some raid5/6 fixes,
especially for using scrub and device replace when devices are missing.

Zhao Lie continues cleaning and fixing things, this series fixes some
really hard to hit corners in xfstests.  I had to pull it last merge
window due to some deadlocks, but those are now resolved.

I added support for Tejun's new blkio controllers.  It seems to work
well for single devices, we'll expand to multi-device as well.

Zhaolei (14) commits (+120/-114):
    btrfs: Cleanup: Remove chunk_objectid argument from btrfs_relocate_chunk() (+2/-8)
    btrfs: use scrub_pause_on/off() to reduce code in scrub_enumerate_chunks() (+3/-7)
    btrfs: Error handle for get_ref_objectid_v0() in relocate_block_group() (+4/-0)
    btrfs: Cleanup: Remove objectid's init-value in create_reloc_inode() (+1/-1)
    btrfs: Separate scrub_blocked_if_needed() to scrub_pause_on/off() (+10/-1)
    btrfs: Fix data checksum error cause by replace with io-load. (+29/-7)
    btrfs: Add WARN_ON() for double lock in btrfs_tree_lock() (+1/-0)
    btrfs: Remove useless condition in start_log_trans() (+17/-26)
    btrfs: Remove root argument in extent_data_ref_count() (+2/-3)
    btrfs: Fix wrong comment of btrfs_alloc_tree_block() (+0/-3)
    btrfs: abort transaction on btrfs_reloc_cow_block() (+3/-1)
    btrfs: Remove unnecessary variants in relocation.c (+7/-11)
    btrfs: Remove unused arguments in tree-log.c (+11/-14)
    btrfs: Use ref_cnt for set_block_group_ro() (+30/-32)

Zhao Lei (7) commits (+55/-43):
    btrfs: Bypass unrelated items before accessing its contents in scrub (+8/-8)
    btrfs: Show detail information when mount failed on missing devices (+3/-2)
    btrfs: Fix calculate typo caused by ambiguous meaning of logic_end (+5/-5)
    btrfs: Check cancel and pause in interval of scrub operation (+18/-16)
    btrfs: Load only necessary csums into list in scrub (+5/-3)
    btrfs: Fix scrub panic when leaf crosses stripes (+10/-7)
    btrfs: Free checksum list on scrub_extent() fail (+6/-2)

Filipe Manana (6) commits (+309/-26):
    Btrfs: teach backref walking about backrefs with underflowed offset values (+25/-2)
    Btrfs: fix stale dir entries after unlink, inode eviction and fsync (+29/-0)
    Btrfs: check if previous transaction aborted to avoid fs corruption (+3/-0)
    Btrfs: fix file read corruption after extent cloning and fsync (+54/-0)
    Btrfs: fix stale dir entries after removing a link and fsync (+138/-20)
    Btrfs: fix stale directory entries after fsync log replay (+60/-4)

Jeff Mahoney (6) commits (+350/-66):
    btrfs: btrfs_issue_discard ensure offset/length are aligned to sector boundaries (+13/-4)
    btrfs: explictly delete unused block groups in close_ctree and ro-remount (+20/-0)
    btrfs: add missing discards when unpinning extents with -o discard (+105/-29)
    btrfs: make btrfs_issue_discard return bytes discarded (+14/-5)
    btrfs: iterate over unused chunk space in FITRIM (+143/-24)
    btrfs: skip superblocks during discard (+55/-4)

Omar Sandoval (5) commits (+259/-44):
    Btrfs: count devices correctly in readahead during RAID 5/6 replace (+3/-1)
    Btrfs: add RAID 5/6 BTRFS_RBIO_REBUILD_MISSING operation (+86/-14)
    Btrfs: remove misleading handling of missing device scrub (+1/-15)
    Btrfs: fix device replace of a missing RAID 5/6 device (+147/-10)
    Btrfs: fix parity scrub of RAID 5/6 with missing device (+22/-4)

Michal Hocko (2) commits (+3/-7):
    btrfs: Prevent from early transaction abort (+2/-4)
    btrfs: use __GFP_NOFAIL in alloc_btrfs_bio (+1/-3)

Liu Bo (2) commits (+7/-7):
    Btrfs: fix defrag to merge tail file extent (+5/-1)
    Btrfs: fix warning in backref walking (+2/-6)

Chris Mason (2) commits (+33/-4):
    btrfs: fix compile when block cgroups are not enabled (+5/-0)
    Btrfs: add support for blkio controllers (+28/-4)

Mark Fasheh (1) commits (+8/-26):
    btrfs: fix clone / extent-same deadlocks

Byongho Lee (1) commits (+0/-7):
    Btrfs: remove unused mutex from struct 'btrfs_fs_info'

Naohiro Aota (1) commits (+9/-3):
    btrfs: fix search key advancing condition

Total: (47) commits (+1153/-347)

 fs/btrfs/backref.c          |  35 ++++-
 fs/btrfs/ctree.c            |   4 +-
 fs/btrfs/ctree.h            |  18 +--
 fs/btrfs/disk-io.c          |  16 +-
 fs/btrfs/extent-tree.c      | 298 ++++++++++++++++++++++++++++++++-----
 fs/btrfs/extent_io.c        |  25 +++-
 fs/btrfs/free-space-cache.c |  57 +++++---
 fs/btrfs/inode.c            |  35 ++++-
 fs/btrfs/ioctl.c            |  52 +++----
 fs/btrfs/locking.c          |   1 +
 fs/btrfs/raid56.c           |  87 +++++++++--
 fs/btrfs/raid56.h           |  10 +-
 fs/btrfs/reada.c            |   4 +-
 fs/btrfs/relocation.c       |  33 ++---
 fs/btrfs/scrub.c            | 348 +++++++++++++++++++++++++++++++++-----------
 fs/btrfs/super.c            |  14 +-
 fs/btrfs/transaction.c      |   7 +-
 fs/btrfs/transaction.h      |   2 +
 fs/btrfs/tree-log.c         | 344 +++++++++++++++++++++++++++++++++++--------
 fs/btrfs/volumes.c          |  89 ++++++-----
 fs/btrfs/volumes.h          |   3 +
 21 files changed, 1144 insertions(+), 338 deletions(-)
