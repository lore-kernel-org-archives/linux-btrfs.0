Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5143 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753361AbcCVAYm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 20:24:42 -0400
Date: Mon, 21 Mar 2016 20:24:36 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160322002436.angclbg3eg6c65ik@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

I waited an extra day to send this one out because I hit a crash late
last week with CONFIG_DEBUG_PAGEALLOC enabled (fixed in the top commit). 

Please pull my my for-linus-4.6 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.6

We have a good sized cleanup of our internal read ahead code, and the
first series of commits from Chandan to enable PAGE_SIZE > sectorsize

Otherwise, it's a normal series of cleanups and fixes, with many thanks
to Dave Sterba for doing most of the patch wrangling this time.

David Sterba (21) commits (+165/-364):
    btrfs: remove error message from search ioctl for nonexistent tree (+0/-2)
    btrfs: drop unused argument in btrfs_ioctl_get_supported_features (+4/-5)
    btrfs: add GET_SUPPORTED_FEATURES to the control device ioctls (+6/-2)
    btrfs: extent same: use GFP_KERNEL for page array allocations (+2/-2)
    Documentation: btrfs: remove usage specific information (+11/-263)
    btrfs: introduce key type for persistent permanent items (+17/-3)
    btrfs: introduce key type for persistent temporary items (+16/-0)
    btrfs: let callers of btrfs_alloc_root pass gfp flags (+11/-10)
    btrfs: teach print_leaf about temporary item subtypes (+11/-0)
    btrfs: teach print_leaf about permanent item subtypes (+10/-2)
    btrfs: switch dev stats item to the permanent item key (+8/-5)
    btrfs: scrub: use GFP_KERNEL on the submission path (+14/-12)
    btrfs: use proper type for failrec in extent_state (+16/-20)
    btrfs: switch balance item to the temporary item key (+3/-3)
    btrfs: switch to kcalloc in btrfs_cmp_data_prepare (+2/-2)
    btrfs: device add and remove: use GFP_KERNEL (+5/-4)
    btrfs: change max_inline default to 2048 (+1/-1)
    btrfs: send: use GFP_KERNEL everywhere (+19/-19)
    btrfs: reada: use GFP_KERNEL everywhere (+5/-5)
    btrfs: fallocate: use GFP_KERNEL (+3/-3)
    btrfs: readdir: use GFP_KERNEL (+1/-1)

Zhao Lei (18) commits (+168/-167):
    btrfs: reada: Use fs_info instead of root in __readahead_hook's argument (+24/-25)
    btrfs: reada: Jump into cleanup in direct way for __readahead_hook() (+21/-19)
    btrfs: reada: reduce additional fs_info->reada_lock in reada_find_zone (+4/-8)
    btrfs: reada: move reada_extent_put to place after __readahead_hook() (+2/-2)
    btrfs: reada: ignore creating reada_extent for a non-existent device (+8/-9)
    btrfs: reada: Pass reada_extent into __readahead_hook directly (+24/-21)
    btrfs: reada: add all reachable mirrors into reada device list (+9/-11)
    btrfs: reada: avoid undone reada extents in btrfs_reada_wait (+8/-1)
    btrfs: reada: Add missed segment checking in reada_find_zone (+3/-1)
    btrfs: reada: Move is_need_to_readahead contition earlier (+9/-11)
    btrfs: reada: Remove level argument in severial functions (+6/-9)
    btrfs: reada: simplify dev->reada_in_flight processing (+10/-18)
    btrfs: reada: bypass adding extent when all zone failed (+5/-0)
    btrfs: reada: Fix in-segment calculation for reada (+2/-2)
    btrfs: Continue write in case of can_not_nocow (+17/-20)
    btrfs: reada: Avoid many times of empty loop (+1/-1)
    btrfs: reada: limit max works count (+12/-1)
    btrfs: reada: Fix a debug code typo (+3/-8)

Chandan Rajendra (12) commits (+321/-165):
    Btrfs: btrfs_ioctl_clone: Truncate complete page after performing clone operation (+3/-2)
    Btrfs: __btrfs_buffered_write: Reserve/release extents aligned to block size (+33/-13)
    Btrfs: btrfs_submit_direct_hook: Handle map_length < bio vector length (+17/-8)
    Btrfs: Use (eb->start, seq) as search key for tree modification log (+17/-17)
    Btrfs: Search for all ordered extents that could span across a page (+20/-8)
    Btrfs: btrfs_page_mkwrite: Reserve space in sectorsized units (+30/-5)
    Btrfs: Compute and look up csums based on sectorsized blocks (+59/-33)
    Btrfs: Clean pte corresponding to page straddling i_size (+11/-3)
    Btrfs: Direct I/O read: Work on sectorsized blocks (+75/-23)
    Btrfs: fallocate: Work with sectorsized blocks (+55/-51)
    Btrfs: Limit inline extents to root->sectorsize (+1/-1)
    Btrfs: Fix block size returned to user space (+0/-1)

Filipe Manana (7) commits (+167/-43):
    Btrfs: fix listxattrs not listing all xattrs packed in the same item (+41/-24)
    Btrfs: do not collect ordered extents when logging that inode exists (+16/-1)
    Btrfs: fix unreplayable log after snapshot delete + parent dir fsync (+20/-0)
    Btrfs: fix file loss on log replay after renaming a file and fsync (+59/-12)
    Btrfs: fix deadlock between direct IO reads and buffered writes (+23/-2)
    Btrfs: fix extent_same allowing destination offset beyond i_size (+3/-0)
    Btrfs: fix race when checking if we can skip fsync'ing an inode (+5/-4)

Josef Bacik (4) commits (+36/-17):
    Btrfs: check reserved when deciding to background flush (+1/-1)
    Btrfs: add transaction space reservation tracepoints (+5/-1)
    Btrfs: change how we update the global block rsv (+20/-14)
    Btrfs: fix truncate_space_check (+10/-1)

Qu Wenruo (3) commits (+68/-19):
    btrfs: Introduce new mount option usebackuproot to replace recovery (+25/-11)
    btrfs: Introduce new mount option to disable tree log replay (+40/-7)
    btrfs: Introduce new mount option alias for nologreplay (+3/-1)

Byongho Lee (2) commits (+1/-6):
    btrfs: simplify expression in btrfs_calc_trans_metadata_size() (+1/-2)
    btrfs: remove redundant error check (+0/-4)

Anand Jain (2) commits (+22/-10):
    btrfs: rename btrfs_print_info to btrfs_print_mod_info (+2/-2)
    btrfs: move btrfs_compression_type to compression.h (+20/-8)

Kinglong Mee (2) commits (+18/-40):
    btrfs: fix memory leak of fs_info in block group cache (+1/-6)
    btrfs: drop null testing before destroy functions (+17/-34)

Deepa Dinamani (1) commits (+26/-22):
    btrfs: Replace CURRENT_TIME by current_fs_time()

Arnd Bergmann (1) commits (+2/-2):
    btrfs: avoid uninitialized variable warning

Dave Jones (1) commits (+3/-6):
    btrfs: remove open-coded swap() in backref.c:__merge_refs

Liu Bo (1) commits (+105/-84):
    Btrfs: fix lockdep deadlock warning due to dev_replace

Adam Buchbinder (1) commits (+16/-16):
    btrfs: Fix misspellings in comments.

Satoru Takeuchi (1) commits (+3/-0):
    Btrfs: Show a warning message if one of objectid reaches its highest value

Ashish Samant (1) commits (+6/-1):
    btrfs: Print Warning only if ENOSPC_DEBUG is enabled

Sudip Mukherjee (1) commits (+1/-1):
    btrfs: fix build warning

Chris Mason (1) commits (+10/-0):
    btrfs: make sure we stay inside the bvec during __btrfs_lookup_bio_sums

Rasmus Villemoes (1) commits (+3/-6):
    btrfs: use kbasename in btrfsic_mount

Dan Carpenter (1) commits (+1/-1):
    btrfs: scrub: silence an uninitialized variable warning

Total: (82) commits (+1142/-970)

 Documentation/filesystems/btrfs.txt    | 261 ++------------------------
 fs/btrfs/backref.c                     |  12 +-
 fs/btrfs/check-integrity.c             |  12 +-
 fs/btrfs/compression.h                 |   9 +
 fs/btrfs/ctree.c                       |  36 ++--
 fs/btrfs/ctree.h                       |  87 ++++++---
 fs/btrfs/delayed-inode.c               |  10 +-
 fs/btrfs/delayed-ref.c                 |  12 +-
 fs/btrfs/dev-replace.c                 | 134 +++++++-------
 fs/btrfs/dev-replace.h                 |   7 +-
 fs/btrfs/disk-io.c                     |  71 ++++---
 fs/btrfs/extent-tree.c                 |  40 ++--
 fs/btrfs/extent_io.c                   |  40 ++--
 fs/btrfs/extent_io.h                   |   5 +-
 fs/btrfs/extent_map.c                  |   8 +-
 fs/btrfs/file-item.c                   | 103 +++++++----
 fs/btrfs/file.c                        | 158 +++++++++-------
 fs/btrfs/inode-map.c                   |   3 +
 fs/btrfs/inode.c                       | 326 +++++++++++++++++++++++----------
 fs/btrfs/ioctl.c                       |  35 ++--
 fs/btrfs/ordered-data.c                |   6 +-
 fs/btrfs/print-tree.c                  |  23 ++-
 fs/btrfs/props.c                       |   1 +
 fs/btrfs/reada.c                       | 268 +++++++++++++--------------
 fs/btrfs/root-tree.c                   |   2 +-
 fs/btrfs/scrub.c                       |  32 ++--
 fs/btrfs/send.c                        |  37 ++--
 fs/btrfs/super.c                       |  52 ++++--
 fs/btrfs/tests/btrfs-tests.c           |   6 -
 fs/btrfs/tests/free-space-tree-tests.c |   1 +
 fs/btrfs/tests/inode-tests.c           |   1 +
 fs/btrfs/transaction.c                 |  13 +-
 fs/btrfs/tree-log.c                    | 102 +++++++++--
 fs/btrfs/tree-log.h                    |   2 +
 fs/btrfs/volumes.c                     |  51 +++---
 fs/btrfs/xattr.c                       |  67 ++++---
 36 files changed, 1102 insertions(+), 931 deletions(-)
