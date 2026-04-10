Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF26261B9C
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Apr 2026 01:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775783759; cv=none; b=GOYw10jWVKmCRcsiAczsQmc2sBIR6QuDaodHWtuuOyegvf2s2bJlhD3Sl7S5ODL6h8+s4BvHmPL4A0gbq+AGTqhHh1Uc7nz3SHI0Y7ABBuV1ygKfrsCWc/XpFeslSOoekxjl2DYopyz6tLV5OM8rRBwOgnJSgwi5bWfg7cvZPNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775783759; c=relaxed/simple;
	bh=VWJgXP9ez3arFhC2slnh6eVFTO8d0bOtE1F2NpEazvM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=n3Zs1OU/B990znDg//icaB1w8u5xgPtsRi0sjyIp2xzIZDnn1ghjj4rQvoD2Gorgm5uSOfWQe43BRmpBrhWKH6miLBNYixM6e/pshTA/iKovkkV+7pz2zRji85GwWkozBPzl3dGRNFb6zLSQsOGTpo6Y4hq8tuMOReHhLDWHSzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RMXXqO7J; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RMXXqO7J; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RMXXqO7J";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RMXXqO7J"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D4EFD6A7D2;
	Fri, 10 Apr 2026 01:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775783748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Sf0zkL98zQlIaAW6MT9wf0OiS2VsPtaTdf5fWQtbPzM=;
	b=RMXXqO7JW39rgNOvqdCbWDr1n23siHLbt1hnx3lPpzhoCsUti0suBBlHNUZVzTMoVizlrC
	Ou+ikHT6qRXHcnP4osYKrOwEGVuliXC5v7LZup5eUAR3gUhb8xTorB4wRowfP5Y8iwoS1P
	ldT1vbtJneKoJplW/UycMqUF8pvITKU=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775783748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Sf0zkL98zQlIaAW6MT9wf0OiS2VsPtaTdf5fWQtbPzM=;
	b=RMXXqO7JW39rgNOvqdCbWDr1n23siHLbt1hnx3lPpzhoCsUti0suBBlHNUZVzTMoVizlrC
	Ou+ikHT6qRXHcnP4osYKrOwEGVuliXC5v7LZup5eUAR3gUhb8xTorB4wRowfP5Y8iwoS1P
	ldT1vbtJneKoJplW/UycMqUF8pvITKU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CEF714A0B2;
	Fri, 10 Apr 2026 01:15:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lmaBMkRP2GmkaAAAD6G6ig
	(envelope-from <dsterba@suse.com>); Fri, 10 Apr 2026 01:15:48 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 7.1
Date: Fri, 10 Apr 2026 03:15:45 +0200
Message-ID: <cover.1775782425.git.dsterba@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

Hi,

please pull the following btrfs updates. Thanks.

User visible changes:

- move shutdown ioctl support out of experimental features, a forced stop
  of filesystem operation until the next unmount; additionally there's a
  super block operation to forcibly remove a device from under the
  filesystem that could lead to a shutdown or not if the redundancy allows
  that

- report filesystem shutdown using fserror mechanism

- tree-checker updates:
  - verify free space info, extent and bitmap items
  - verify remap-tree items and related data in block group items

Performance improvements:

- speed up clearing first extent in the tracked range (+10% throughput on
  sample workload)

- reduce COW rewrites of extent buffers during the same transaction

- avoid taking big device lock to update device stats during transaction
  commit

- fix unnecessary flush on close when truncating empty files (observed
  in practice on a backup application)

- prevent direct reclaim during compressed readahead to avoid stalls
  under memory pressure

Notable fixes:

- fix chunk allocation strategy on RAID1-like block groups with
  disproportionate device sizes, this could lead to ENOSPC due to skewed
  reservation estimates

- adjust metadata reservation overcommit ratio to be less aggressive and
  also try to flush if possible, this avoids ENOSPC and potential
  transaction aborts in some edge cases (that are otherwise hard to
  reproduce)

- fix silent IO error in encoded writes and ordered extent split in zoned
  mode, the error was not correctly propagated to the address space and
  could lead to zeroed ranges

- don't mark inline files NOCOMPRESS unexpectedly, the intent was to do
  that for single block writes of regular files

- fix deadlock between reflink and transaction commit when using
  flushoncommit

- fix overly strict item check of a running dev-replace operation

Core:

- zoned mode space reservation fixes:
  - cap delayed refs metadata reservation to avoid overcommit
  - update logic to reclaim partially unusable zones
  - add another state to flush and reclaim partially used zone
  - limit number of zones reclaimed in one go to avoid blocking other
    operations

- don't let log trees consume global reserve on overcommit and fall back
  to transaction commit

- revalidate extent buffer when checking its up-to-date status

- add self tests for zoned mode block group specifics

- reduce atomic allocations in some qgroup paths

- avoid unnecessary root node COW during snapshotting

- start new transaction in block group relocation conditionally

- faster check of NOCOW files on currently snapshotted root

- change how compressed bio size is tracked from bio and reduce the
  structure size

- new tracepoint for search slot restart tracking

- checksum list manipulation improvements

- type, parameter cleanups, refactoring

- error handling improvements, transaction abort call adjustments

----------------------------------------------------------------
The following changes since commit 591cd656a1bf5ea94a222af5ef2ee76df029c1d2:

  Linux 7.0-rc7 (2026-04-05 15:26:23 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.1-tag

for you to fetch changes up to fc3d53288158d68444eed059adb734709b855bbf:

  btrfs: btrfs_log_dev_io_error() on all bio errors (2026-04-07 20:00:29 +0200)

----------------------------------------------------------------
Alexey Velichayshiy (1):
      btrfs: remove redundant nowait check in lock_extent_direct()

Boris Burkov (1):
      btrfs: btrfs_log_dev_io_error() on all bio errors

Chen Guan Jie (1):
      btrfs: check snapshot_force_cow earlier in can_nocow_file_extent()

Chen Ni (1):
      btrfs: remove duplicate include of delayed-inode.h in disk-io.c

Dave Chen (3):
      btrfs: fix unnecessary flush on close when truncating zero-sized files
      btrfs: use BTRFS_FS_UPDATE_UUID_TREE_GEN flag for UUID tree rescan check
      btrfs: skip clearing EXTENT_DEFRAG for NOCOW ordered extents

David Sterba (9):
      btrfs: remove duplicate calculation of eb offset in btrfs_bin_search()
      btrfs: unify types for binary search variables
      btrfs: rename local variable for offset in folio
      btrfs: read eb folio index right before loops
      btrfs: use common eb range validation in read_extent_buffer_to_user_nofault()
      btrfs: lzo: inline read/write length helpers
      btrfs: zlib: drop redundant folio address variable
      btrfs: zlib: don't cache sectorsize in a local variable
      btrfs: zstd: don't cache sectorsize in a local variable

Filipe Manana (46):
      btrfs: pass boolean literals as the last argument to inc_block_group_ro()
      btrfs: remove duplicate system chunk array max size overflow check
      btrfs: move min sys chunk array size check to validate_sys_chunk_array()
      btrfs: be less aggressive with metadata overcommit when we can do full flushing
      btrfs: don't allow log trees to consume global reserve or overcommit metadata
      btrfs: update comment for BTRFS_RESERVE_NO_FLUSH
      btrfs: mark all error and warning checks as unlikely in btrfs_validate_super()
      btrfs: pass transaction handle to write_all_supers()
      btrfs: abort transaction on error in write_all_supers()
      btrfs: tag error branches as unlikely during super block writes
      btrfs: remove max_mirrors argument from write_all_supers()
      btrfs: set written super flag once in write_all_supers()
      btrfs: remove duplicated eb uptodate check in btrfs_buffer_uptodate()
      btrfs: use the helper extent_buffer_uptodate() everywhere
      btrfs: remove redundant extent_buffer_uptodate() checks after read_tree_block()
      btrfs: avoid starting new transaction and commit in relocate_block_group()
      btrfs: remove pointless out label in qgroup_account_snapshot()
      btrfs: pass literal booleans to functions that take boolean arguments
      btrfs: remove bogus root search condition in load_extent_tree_free()
      btrfs: avoid unnecessary root node COW during snapshotting
      btrfs: constify arguments of some functions
      btrfs: stop printing condition result in assertion failure messages
      btrfs: pass a btrfs inode to tree-log.c:fill_inode_item()
      btrfs: stop checking for -EEXIST return value from btrfs_uuid_tree_add()
      btrfs: remove duplicated uuid tree existence check in btrfs_uuid_tree_add()
      btrfs: remove pointless error check in btrfs_check_dir_item_collision()
      btrfs: optimize clearing all bits from the last extent record in an io tree
      btrfs: turn extent_io_tree_panic() into a macro for better error reporting
      btrfs: tag as unlikely branches that call extent_io_tree_panic()
      btrfs: make add_extent_changeset() only return errors or success
      btrfs: use extent_io_tree_panic() instead of BUG_ON()
      btrfs: change last argument of add_extent_changeset() to boolean
      btrfs: remove wake parameter from clear_state_bit()
      btrfs: avoid unnecessary wake ups on io trees when there are no waiters
      btrfs: free cached state outside critical section in wait_extent_bit()
      btrfs: panic instead of warn when splitting extent state not in the tree
      btrfs: optimize clearing all bits from first extent record in an io tree
      btrfs: remove unused qgroup functions for pertrans reservation and freeing
      btrfs: collapse __btrfs_qgroup_free_meta() into btrfs_qgroup_free_meta_prealloc()
      btrfs: collapse __btrfs_qgroup_reserve_meta() into btrfs_qgroup_reserve_meta_prealloc()
      btrfs: unexport btrfs_qgroup_reserve_meta()
      btrfs: avoid taking the device_list_mutex in btrfs_run_dev_stats()
      btrfs: fix deadlock between reflink and transaction commit when using flushoncommit
      btrfs: make btrfs_free_log() and btrfs_free_log_root_tree() return void
      btrfs: tag as unlikely if statements that check for fs in error state
      btrfs: remove duplicate journal_info reset on failure to commit transaction

Guangshuo Li (2):
      btrfs: fix double free in create_space_info_sub_group() error path
      btrfs: fix double free in create_space_info() error path

JP Kobryn (Meta) (1):
      btrfs: prevent direct reclaim during compressed readahead

Jiasheng Jiang (1):
      btrfs: zoned: remove redundant space_info lock and variable in do_allocation_zoned()

Johannes Thumshirn (8):
      btrfs: zoned: cap delayed refs metadata reservation to avoid overcommit
      btrfs: zoned: move partially zone_unusable block groups to reclaim list
      btrfs: zoned: add zone reclaim flush state for DATA space_info
      btrfs: change return type of cache_save_setup to void
      btrfs: move reclaiming of a single block group into its own function
      btrfs: create btrfs_reclaim_block_groups()
      btrfs: zoned: limit number of zones reclaimed in flush_space()
      btrfs: decrease indentation of find_free_extent_update_loop

Leo Martins (3):
      btrfs: inhibit extent buffer writeback to prevent COW amplification
      btrfs: add tracepoint for search slot restart tracking
      btrfs: avoid GFP_ATOMIC allocations in qgroup free paths

Mark Harmstone (4):
      btrfs: fix placement of unlikely() in btrfs_insert_one_raid_extent()
      btrfs: tree-checker: add checker for items in remap tree
      btrfs: tree-checker: check remap-tree flags in btrfs_check_chunk_valid()
      btrfs: tree-checker: add remap-tree checks to check_block_group_item()

Michal Grzedzicki (1):
      btrfs: fix silent IO error loss in encoded writes and zoned split

Miquel Sabaté Solà (2):
      btrfs: replace kcalloc() calls to kzalloc_objs()
      btrfs: report filesystem shutdown via fserror

Naohiro Aota (1):
      btrfs: tests: zoned: add tests cases for zoned code

Philipp Hahn (1):
      btrfs: prefer IS_ERR_OR_NULL() over manual NULL check

Qu Wenruo (26):
      btrfs: introduce the device layout aware per-profile available space
      btrfs: update per-profile available estimation
      btrfs: use per-profile available space in calc_available_free_space()
      btrfs: fix the inline compressed extent check in inode_need_compress()
      btrfs: rename btrfs_ordered_extent::list to csum_list
      btrfs: make add_pending_csums() to take an ordered extent as parameter
      btrfs: rename btrfs_csum_file_blocks() to btrfs_insert_data_csums()
      btrfs: remove out-of-date comments in btree_writepages()
      btrfs: remove the btrfs_inode parameter from btrfs_remove_ordered_extent()
      btrfs: remove folio parameter from ordered io related functions
      btrfs: do not mark inode incompressible after inline attempt fails
      btrfs: introduce a common helper to calculate the size of a bio
      btrfs: reduce the size of compressed_bio
      btrfs: do compressed bio size roundup and zeroing in one go
      btrfs: extract the max compression chunk size into a macro
      btrfs: remove the alignment check in end_bbio_data_write()
      btrfs: move the mapping_set_error() out of the loop in end_bbio_data_write()
      btrfs: extract inlined creation into a dedicated delalloc helper
      btrfs: tree-checker: introduce checks for FREE_SPACE_INFO
      btrfs: tree-checker: introduce checks for FREE_SPACE_EXTENT
      btrfs: check type flags in alloc_ordered_extent()
      btrfs: output more info when duplicated ordered extent is found
      btrfs: remove atomic parameter from btrfs_buffer_uptodate()
      btrfs: move shutdown and remove_bdev callbacks out of experimental features
      btrfs: only invalidate btree inode pages after all ebs are released
      btrfs: do not reject a valid running dev-replace

Teng Liu (1):
      btrfs: replace BUG_ON() with error return in cache_save_setup()

Yochai Eisenrich (1):
      btrfs: fix btrfs_ioctl_space_info() slot_count TOCTOU which can lead to info-leak

ZhengYuan Huang (2):
      btrfs: tree-checker: introduce checks for FREE_SPACE_BITMAP
      btrfs: revalidate cached tree blocks on the uptodate path

 fs/btrfs/Kconfig                |   2 -
 fs/btrfs/Makefile               |   4 +
 fs/btrfs/backref.c              |  10 -
 fs/btrfs/bio.c                  |  12 +-
 fs/btrfs/block-group.c          | 335 +++++++++++---------
 fs/btrfs/block-group.h          |   1 +
 fs/btrfs/block-rsv.c            |  25 ++
 fs/btrfs/compression.c          |  45 ++-
 fs/btrfs/compression.h          |   8 +-
 fs/btrfs/ctree.c                |  47 +--
 fs/btrfs/delayed-inode.c        |   3 +-
 fs/btrfs/delayed-ref.c          |  28 ++
 fs/btrfs/dev-replace.c          |   4 +-
 fs/btrfs/dir-item.c             |   4 +-
 fs/btrfs/direct-io.c            |  11 +-
 fs/btrfs/disk-io.c              | 247 +++++++--------
 fs/btrfs/disk-io.h              |   7 +-
 fs/btrfs/extent-io-tree.c       | 184 ++++++++---
 fs/btrfs/extent-tree.c          | 119 ++++---
 fs/btrfs/extent_io.c            | 186 +++++++----
 fs/btrfs/extent_io.h            |  31 +-
 fs/btrfs/file-item.c            |   6 +-
 fs/btrfs/file-item.h            |   6 +-
 fs/btrfs/file.c                 |   6 +-
 fs/btrfs/fs.h                   |   9 +-
 fs/btrfs/inode.c                | 316 ++++++++++---------
 fs/btrfs/ioctl.c                |   9 +-
 fs/btrfs/lzo.c                  |  41 +--
 fs/btrfs/messages.c             |   2 +-
 fs/btrfs/messages.h             |   8 +-
 fs/btrfs/misc.h                 |  18 +-
 fs/btrfs/ordered-data.c         |  69 ++--
 fs/btrfs/ordered-data.h         |  66 ++--
 fs/btrfs/print-tree.c           |   4 -
 fs/btrfs/qgroup.c               |  42 ++-
 fs/btrfs/qgroup.h               |  42 +--
 fs/btrfs/raid-stripe-tree.c     |   2 +-
 fs/btrfs/raid56.c               |  17 +-
 fs/btrfs/reflink.c              |  49 ++-
 fs/btrfs/relocation.c           |  12 +-
 fs/btrfs/scrub.c                |  24 +-
 fs/btrfs/send.c                 |   6 +-
 fs/btrfs/space-info.c           |  69 ++--
 fs/btrfs/space-info.h           |  22 +-
 fs/btrfs/super.c                |   6 +-
 fs/btrfs/super.h                |   2 +-
 fs/btrfs/tests/btrfs-tests.c    |   3 +
 fs/btrfs/tests/btrfs-tests.h    |  10 +
 fs/btrfs/tests/zoned-tests.c    | 675 ++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.c          |  90 +++---
 fs/btrfs/transaction.h          |   3 +
 fs/btrfs/tree-checker.c         | 247 +++++++++++++++
 fs/btrfs/tree-log.c             |  75 +++--
 fs/btrfs/tree-log.h             |   5 +-
 fs/btrfs/tree-mod-log.c         |   8 +-
 fs/btrfs/uuid-tree.c            |   7 +-
 fs/btrfs/volumes.c              | 225 +++++++++++++-
 fs/btrfs/volumes.h              |  34 ++
 fs/btrfs/zlib.c                 |  26 +-
 fs/btrfs/zoned.c                |  17 +-
 fs/btrfs/zstd.c                 |  20 +-
 include/trace/events/btrfs.h    |  24 ++
 include/uapi/linux/btrfs_tree.h |   3 +-
 63 files changed, 2559 insertions(+), 1079 deletions(-)
 create mode 100644 fs/btrfs/tests/zoned-tests.c
