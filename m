Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62763 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852AbaA3VvM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 16:51:12 -0500
Message-ID: <52EAC9B6.7090603@fb.com>
Date: Thu, 30 Jan 2014 16:52:54 -0500
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Linus

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

There are two conflicts right now, one with the ACL code (pick your
version) and one with Kent's changes in the block layer pull.  That one
is pretty obvious too, just do both our cleanup and Kent's rework.

This is a pretty big pull, and most of these changes have been floating
in btrfs-next for a long time.  Filipe's properties work is a cool
building block for inheriting attributes like compression down on a 
per inode basis.

Jeff Mahoney kicked in code to export filesystem info into sysfs.

Otherwise, lots of performance improvements, cleanups and bug fixes.

Looks like there are still a few other small pending incrementals, but I
wanted to get the bulk of this in first.

Filipe David Borba Manana (29) commits (+1856/-301):
    Btrfs: fix deadlock when iterating inode refs and running delayed inodes (+12/-7)
    Btrfs: fix send file hole detection leading to data corruption (+15/-0)
    Btrfs: remove field tree_mod_seq_elem from btrfs_fs_info struct (+0/-1)
    Btrfs: make send's file extent item search more efficient (+17/-10)
    Btrfs: fix infinite path build loops in incremental send (+518/-21)
    Btrfs: reduce btree node locking duration on item update (+14/-10)
    Btrfs: return immediately if tree log mod is not necessary (+1/-1)
    Btrfs: fix pass of transid with wrong endianness in send.c (+3/-3)
    Btrfs: fix btrfs_search_slot_for_read backwards iteration (+3/-1)
    Btrfs: fix send to not send non-aligned clone operations (+2/-1)
    Btrfs: faster and more efficient extent map insertion (+41/-31)
    Btrfs: fix extent boundary check in bio_readpage_error (+1/-1)
    Btrfs: faster file extent item search in clone ioctl (+14/-9)
    Btrfs: unlock inodes in correct order in clone ioctl (+11/-3)
    Btrfs: faster file extent item replace operations (+114/-46)
    Btrfs: avoid unnecessary ordered extent cache resets (+2/-1)
    Btrfs: fix very slow inode eviction and fs unmount (+84/-14)
    Btrfs: fix snprintf usage by send's gen_unique_name (+1/-1)
    Btrfs: fix ordered extent check in btrfs_punch_hole (+1/-1)
    Btrfs: fix btrfs boot when compiled as built-in (+73/-9)
    Btrfs: more efficient extent state insertions (+55/-21)
    Btrfs: fix extent_map block_len after merging (+1/-1)
    Btrfs: add missing extent state caching calls (+3/-1)
    Btrfs: try harder to avoid btree node splits (+14/-6)
    Btrfs: fix use of uninitialized err variable (+1/-1)
    Btrfs: add support for inode properties (+545/-10)
    Btrfs: fix max dir item size calculation (+1/-1)
    Btrfs: more efficient push_leaf_right (+13/-0)
    Btrfs: fix tree mod logging (+296/-89)

Wang Shilong (26) commits (+291/-291):
    Btrfs: remove unnecessary filemap writting and waiting after block group relocation (+0/-5)
    Btrfs: fix to search previous metadata extent item since skinny metadata (+46/-2)
    Btrfs: fix wrong search path initialization before searching tree root (+1/-1)
    Btrfs: optimize to remove unnecessary removal with ulist reallocation (+1/-3)
    Btrfs: fix transaction abortion when remounting btrfs from RW to RO (+2/-2)
    Btrfs: fix wrong super generation mismatch when scrubbing supers (+26/-19)
    Btrfs: fix protection between walking backrefs and root deletion (+12/-1)
    Btrfs: handle EAGAIN case properly in btrfs_drop_snapshot() (+1/-1)
    Btrfs: improve forever loop when doing balance relocation (+36/-38)
    Btrfs: fix to catch all errors when resolving indirect ref (+9/-3)
    Btrfs: fix missing skinny metadata check in scrub_stripe() (+4/-1)
    Btrfs: wrap repeated code into scrub_blocked_if_needed() (+19/-27)
    Btrfs: remove unnecessary transaction commit before send (+0/-29)
    Btrfs: only fua the first superblock when writting supers (+4/-1)
    Btrfs: add a reschedule point in btrfs_find_all_roots() (+1/-0)
    Btrfs: fix an oops when we fail to relocate tree blocks (+6/-0)
    Btrfs: remove unused argument from select_reloc_root() (+2/-4)
    Btrfs: fix protection between send and root deletion (+29/-0)
    Btrfs: fix memory leaks on walking backrefs failure (+18/-7)
    Btrfs: fix an oops when we fail to merge reloc roots (+3/-7)
    Btrfs: fix wrong send_in_progress accounting (+13/-3)
    Btrfs: remove dead comments for read_csums() (+0/-6)
    Btrfs: remove transaction from btrfs send (+0/-33)
    Btrfs: rework ulist with list+rb_tree (+55/-88)
    Btrfs: do not export ulist functions (+1/-10)
    Btrfs: fix a warning when iput a file (+2/-0)

Miao Xie (16) commits (+375/-232):
    Btrfs: fix the reserved space leak caused by the race between nonlock dio and buffered io (+84/-47)
    Btrfs: change the members' order of btrfs_space_info structure to reduce the cache miss (+15/-14)
    Btrfs: flush the dirty pages of the ordered extent aggressively during logging csum (+5/-1)
    Btrfs: cleanup the redundant code for the block group allocation and init (+44/-50)
    Btrfs: introduce the delayed inode ref deletion for the single link inode (+157/-6)
    Btrfs: fix wrong block group in trace during the free space allocation (+2/-1)
    Btrfs: cleanup the code of used_block_group in find_free_extent() (+13/-20)
    Btrfs: cleanup unnecessary parameter and variant of prepare_pages() (+6/-8)
    Btrfs: fix the race between write back and nocow buffered write (+5/-2)
    Btrfs: use flags instead of the bool variants in delayed node (+21/-18)
    Btrfs: don't run delayed nodes again after all nodes flush (+1/-0)
    Btrfs: remove residual code in delayed inode async helper (+0/-27)
    Btrfs: cleanup code of btrfs_balance_delayed_items() (+11/-23)
    Btrfs: fix double initialization of the raid kobject (+5/-4)
    Btrfs: remove btrfs_end_transaction_dmeta() (+1/-9)
    Btrfs: fix the wrong nocow range check (+5/-2)

Jeff Mahoney (14) commits (+1068/-94):
    btrfs: use feature attribute names to print better error messages (+64/-6)
    btrfs: add ioctl to export size of global metadata reservation (+17/-0)
    btrfs: add ioctls to query/change feature bits online (+163/-0)
    btrfs: add ability to change features via sysfs (+117/-4)
    btrfs: publish unknown feature bits in sysfs (+107/-1)
    btrfs: publish per-super attributes in sysfs (+57/-0)
    btrfs: publish per-super features in sysfs (+65/-16)
    btrfs: publish supported featured in sysfs (+87/-0)
    btrfs: publish device membership in sysfs (+33/-0)
    btrfs: publish allocation data in sysfs (+238/-5)
    btrfs: fix leaks during sysfs teardown (+73/-60)
    btrfs: fix static checker warnings (+2/-2)
    btrfs: publish fs label in sysfs (+44/-0)
    kobject: export kobj_sysfs_ops (+1/-0)

Josef Bacik (13) commits (+836/-542):
    Btrfs: fix check-integrity to look at the referenced data properly (+12/-4)
    Btrfs: fix extent_from_logical to deal with skinny metadata (+33/-8)
    Btrfs: stop caching thread if extent_commit_sem is contended (+2/-1)
    Btrfs: move the extent buffer radix tree into the fs_info (+34/-39)
    Btrfs: incompatible format change to remove hole extents (+373/-56)
    Btrfs: only process as many file extents as there are refs (+9/-8)
    Btrfs: attach delayed ref updates to delayed ref heads (+267/-405)
    Btrfs: fix qgroup rescan to work with skinny metadata (+13/-5)
    Btrfs: use a bit to track if we're in the radix tree (+5/-3)
    Btrfs: deal with io_tree->mapping being NULL (+16/-8)
    Btrfs: make fsync latency less sucky (+15/-1)
    Btrfs: throttle delayed refs better (+46/-4)
    rwsem: add rwsem_is_contended (+11/-0)

Qu Wenruo (11) commits (+189/-86):
    btrfs: Add "barrier" option to support "-o remount,barrier" (+14/-7)
    btrfs: Cleanup the btrfs_parse_options for remount. (+77/-60)
    btrfs: Add noflushoncommit mount option. (+8/-1)
    btrfs: Add noenospc_debug mount option. (+7/-1)
    btrfs: Add noinode_cache mount option (+22/-2)
    btrfs: Add noautodefrag mount option. (+12/-4)
    btrfs: Add nodiscard mount option. (+10/-3)
    btrfs: Add datasum mount option. (+13/-1)
    btrfs: Add datacow mount option. (+10/-3)
    btrfs: Add treelog mount option. (+9/-2)
    btrfs: Add acl mount option. (+7/-2)

David Sterba (10) commits (+128/-92):
    btrfs: call permission checks earlier in ioctls and return EPERM (+9/-13)
    btrfs: reserve no transaction units in btrfs_feature_attr_store (+1/-1)
    btrfs: Check read-only status of roots during send (+79/-3)
    btrfs: sysfs: don't show reserved incompat feature (+0/-2)
    btrfs: restrict snapshotting to own subvolumes (+6/-0)
    btrfs: check balance of send_in_progress (+20/-18)
    btrfs: replace BUG in can_modify_feature (+3/-1)
    btrfs: sysfs: list the NO_HOLES feature (+2/-0)
    btrfs: remove unused mnt from send_ctx (+0/-4)
    btrfs: send: clean up dead code (+8/-50)

Valentina Giusti (8) commits (+4/-41):
    btrfs: replace path->slots[0] with otherwise unused variable 'slot' (+2/-2)
    btrfs: remove unused variable from setup_cluster_no_bitmap (+0/-2)
    btrfs: remove unused variable from scrub_fixup_nodatasum (+0/-2)
    btrfs: remove unused variable from find_free_extent (+0/-2)
    btrfs: remove unused variable from btrfs_new_inode (+0/-6)
    btrfs: remove unused variables from extent_io.c (+0/-7)
    btrfs: remove unused variables from disk-io.c (+0/-11)
    btrfs: fix unused variables in qgroup.c (+2/-9)

Liu Bo (7) commits (+136/-85):
    Btrfs/tracepoint: fix to report right flags for ordered extent (+11/-11)
    Btrfs: release subvolume's block_rsv before transaction commit (+7/-7)
    Btrfs: return free space to global_rsv as much as possible (+1/-1)
    Btrfs/tracepoint: update new flags for ordered extent TP (+2/-1)
    Btrfs: fix extent state leak on transaction abortion (+9/-5)
    Btrfs: skip merge part for delayed data refs (+7/-0)
    Btrfs: introduce a head ref rbtree (+99/-60)

Chris Mason (3) commits (+64/-32):
    Btrfs: setup inode location during btrfs_init_inode_locked (+9/-9)
    Btrfs: don't use ram_bytes for uncompressed inline items (+52/-22)
    Btrfs: fix spin_unlock in check_ref_cleanup (+3/-1)

Kelley Nielsen (3) commits (+71/-91):
    btrfs: expand btrfs_find_item() to include find_orphan_item functionality (+17/-35)
    btrfs: expand btrfs_find_item() to include find_root_ref functionality (+11/-20)
    btrfs: bootstrap generic btrfs_find_item interface (+43/-36)

Frank Holton (2) commits (+364/-329):
    Btrfs: make btrfs_debug match pr_debug handling related to DEBUG (+6/-0)
    Btrfs: convert printk to btrfs_ and fix BTRFS prefix (+358/-329)

Sergei Trofimovich (1) commits (+0/-71):
    btrfs: cleanup: removed unused 'btrfs_get_inode_ref_index'

Gui Hecheng (1) commits (+1/-1):
    btrfs: fix warning while merging two adjacent extents

Michal Nazarewicz (1) commits (+1/-6):
    btrfs: remove dead code

Anand Jain (1) commits (+7/-4):
    btrfs: undo sysfs when open_ctree() fails

Tsutomu Itoh (1) commits (+21/-7):
    Btrfs: fix error check of btrfs_lookup_dentry()

Wenliang Fan (1) commits (+4/-0):
    fs/btrfs: Integer overflow in btrfs_ioctl_resize()

Justin Maggard (1) commits (+3/-3):
    btrfs: fix defrag 32-bit integer overflow

Total: (149) commits

 Documentation/filesystems/btrfs.txt |  47 +-
 fs/btrfs/Kconfig                    |   3 +-
 fs/btrfs/Makefile                   |   2 +-
 fs/btrfs/acl.c                      |   7 +-
 fs/btrfs/backref.c                  | 195 ++++----
 fs/btrfs/btrfs_inode.h              |   4 +
 fs/btrfs/check-integrity.c          |  12 +-
 fs/btrfs/compression.c              |  12 +-
 fs/btrfs/ctree.c                    | 552 ++++++++++++++++-----
 fs/btrfs/ctree.h                    | 134 +++--
 fs/btrfs/delayed-inode.c            | 208 +++++---
 fs/btrfs/delayed-inode.h            |   8 +-
 fs/btrfs/delayed-ref.c              | 300 +++++------
 fs/btrfs/delayed-ref.h              |  26 +-
 fs/btrfs/dev-replace.c              |  56 ++-
 fs/btrfs/dir-item.c                 |   8 +-
 fs/btrfs/disk-io.c                  | 253 +++++-----
 fs/btrfs/extent-tree.c              | 617 ++++++++++++-----------
 fs/btrfs/extent_io.c                | 228 +++++----
 fs/btrfs/extent_io.h                |   9 +-
 fs/btrfs/extent_map.c               |  74 +--
 fs/btrfs/file-item.c                |   4 +-
 fs/btrfs/file.c                     | 216 +++++---
 fs/btrfs/free-space-cache.c         |  23 +-
 fs/btrfs/hash.c                     |  50 ++
 fs/btrfs/hash.h                     |  11 +-
 fs/btrfs/inode-item.c               |  65 ---
 fs/btrfs/inode.c                    | 446 ++++++++++++-----
 fs/btrfs/ioctl.c                    | 348 +++++++++++--
 fs/btrfs/lzo.c                      |   6 +-
 fs/btrfs/ordered-data.c             |  15 +-
 fs/btrfs/orphan.c                   |  20 -
 fs/btrfs/print-tree.c               |   4 +-
 fs/btrfs/props.c                    | 427 ++++++++++++++++
 fs/btrfs/props.h                    |  42 ++
 fs/btrfs/qgroup.c                   |  57 ++-
 fs/btrfs/reada.c                    |   9 +-
 fs/btrfs/relocation.c               | 105 ++--
 fs/btrfs/root-tree.c                |  19 +-
 fs/btrfs/scrub.c                    | 134 ++---
 fs/btrfs/send.c                     | 961 ++++++++++++++++++++++++++++++------
 fs/btrfs/super.c                    | 241 ++++++---
 fs/btrfs/sysfs.c                    | 617 +++++++++++++++++++++++
 fs/btrfs/sysfs.h                    |  64 +++
 fs/btrfs/tests/btrfs-tests.h        |   2 +-
 fs/btrfs/transaction.c              |  55 ++-
 fs/btrfs/transaction.h              |   3 +-
 fs/btrfs/tree-log.c                 | 209 +++++++-
 fs/btrfs/ulist.c                    | 117 ++---
 fs/btrfs/ulist.h                    |  39 +-
 fs/btrfs/uuid-tree.c                |  13 +-
 fs/btrfs/volumes.c                  |  89 ++--
 fs/btrfs/xattr.c                    |  12 +-
 fs/btrfs/zlib.c                     |   8 +-
 include/linux/rwsem.h               |  11 +
 include/trace/events/btrfs.h        |  23 +-
 include/uapi/linux/btrfs.h          |  13 +
 include/uapi/linux/xattr.h          |   3 +
 lib/kobject.c                       |   1 +
 59 files changed, 5174 insertions(+), 2063 deletions(-)
