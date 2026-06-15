Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFCD165F16
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 21:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781558962; cv=none; b=Gw4l0qIbP46LbQE/DNJLS5DsW+SZO1LaP79dWuPk7BNf7Tn7OrR/mQuRQtNuVNwD07bAP5dM9ZgbGhqUVEX6MTYfwLBJq5BBIuN7maXVuTJIbMtg5X6Dfn+Hw+q2op9X0Fdl+hMfpFpC+g2DNG5xZIX/RGa9FCK4vQnUD38xj8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781558962; c=relaxed/simple;
	bh=rx3nHM/HZavkKsLLal+f2Dx9jboSdEMQGrSJmwL68Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=e7RfRVH3DbuxsvxJHmSZGu2FwLLbaNgO0rYn2Nkf50n0s1uBhutjzrg01N/FA0kP5DGqUJcU9k6bmEjiJS7WHsaAbr/n8bkZOCsKufRK5vQoFxMO5xNIXGCsJjO01c3GuIDyQCaT8SkcF9lJOy8cye2Ainb63eiiQ3DoPCacP0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gAD8uaBN; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gAD8uaBN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gAD8uaBN";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gAD8uaBN"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9C5716C593;
	Mon, 15 Jun 2026 21:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781558958; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zHUq5pSUlJ4q/ZZPTrSK7hSUpjCSCDqD9pPtwpOnH1s=;
	b=gAD8uaBNkWi4WIknsYhDwR43n64mZTiO3lf3500K55bZYWnffHhcySTf7kP466gHozOoHq
	Lq9lvMTs2PUhRj1KKrEzkpTi18IljpnmpG8mclckO65o6aogSCVybRoF6xqz59JXHZiafZ
	l4pY/70tpiE4D6NonWywfAGBMDqufJQ=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781558958; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zHUq5pSUlJ4q/ZZPTrSK7hSUpjCSCDqD9pPtwpOnH1s=;
	b=gAD8uaBNkWi4WIknsYhDwR43n64mZTiO3lf3500K55bZYWnffHhcySTf7kP466gHozOoHq
	Lq9lvMTs2PUhRj1KKrEzkpTi18IljpnmpG8mclckO65o6aogSCVybRoF6xqz59JXHZiafZ
	l4pY/70tpiE4D6NonWywfAGBMDqufJQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 94F9C779A7;
	Mon, 15 Jun 2026 21:29:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gYpYJK5uMGqQBgAAD6G6ig
	(envelope-from <dsterba@suse.com>); Mon, 15 Jun 2026 21:29:18 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 7.2
Date: Mon, 15 Jun 2026 23:29:11 +0200
Message-ID: <cover.1781558337.git.dsterba@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.30
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

Hi,

please pull the following updates. The noticeable change is to enable
large folios by default, it's been in testing for a few releases.
Related to that is huge folio support (still under experimental config).
Otherwise a few ioctl updates, performance improvements and usual fixes
and core changes.

Thanks.

User visible changes:

- enable large folios by default, added in 6.17 (under experimental
  build), no feature limitations, a big change internally

- new ioctl to return raw checksums to userspace (a bit tricky given
  compression and tail extents), can be used for mkfs and deduplication
  optimizations

- provide stable UUID for e.g. overlayfs and temp_fsid, also reflected
  in statvfs() field f_fsid, internal dev_t is hashed in to allow
  cloning

- add 32bit compat version of GET_SUBVOL_INFO ioctl

- in experimental build, support huge folios (up to 2M)

Performance related improvements/changes:

- limit bio size to the estimated optimum derived from the queue, this
  prevents build up of too much data for writeback, which could cause
  latency spikes (reported improvement 15% on sequential writes)

- don't force direct IO to be serialized, forgotten change during mount
  API port, brings back +60% of throughput

- lockless calculation of number of shrinkable extent maps, improve
  performance with many memcg allocated objects

Notable fixes:

- in zoned mode, fix a deadlock due to zone reclaim and relocation when
  space needs to be flushed

- don't trim device which is internally not tracked as writeable (e.g.
  when missing device is being rescanned)

- fix deadlock when cloning inline extent and mounted with flushoncommit

- fix false IO failures after direct IO falls back to buffered write in
  some cases

Core:

- remove COW fixup mechanism completely; detect and fix changes to pages
  outside of filesystem tracking, guaranteed since 5.8, grace period is
  over

- remove 2K block size support, experimental to test subpage code on
  x86_64 but now it would block folio changes

- tree-checker improvements of:
  - free-space cache and tree items
  - root reference and backref items
  - extent state exceptions in reloc tree

- subpage mode updates:
  - code optimizations, simplify tracking bitmaps
  - re-enable readahead of compressed extent
  - extend bitmap size to cover huge folios

- add tracepoints related to sync, tree-log and transactions

- device stats item tracking unification, remove item if there are no
  stats recorded, also don't leave stale stats on replaced device

- allow extent buffer pages to be allocated as movable, to help page
  migration

- added checks for proper extent buffer release

- btrfs.ko code size reduction due to transaction abort call
  simplifications

- several struct size reductions

- more auto free conversions

- more verbose assertions

----------------------------------------------------------------
The following changes since commit 4549871118cf616eecdd2d939f78e3b9e1dddc48:

  Linux 7.1-rc7 (2026-06-07 15:37:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-tag

for you to fetch changes up to ae2eb64bfd9762536f60b690840adcdf622cdcce:

  btrfs: fix use-after-free after relocation failure with concurrent COW (2026-06-09 18:22:47 +0200)

----------------------------------------------------------------
Anand Jain (2):
      btrfs: use on-disk uuid for s_uuid in temp_fsid mounts
      btrfs: derive f_fsid from on-disk fsid and dev_t

Ben Maurer (1):
      btrfs: use lockless read in nr_cached_objects shrinker callback

Cen Zhang (1):
      btrfs: annotate lockless read of defrag_bytes in should_nocow()

Daan De Meyer (1):
      btrfs: add 32-bit compat ioctl for BTRFS_IOC_GET_SUBVOL_INFO

Dave Chen (1):
      btrfs: optimize fill_holes() to merge a new hole with both adjacent items

David Sterba (18):
      btrfs: move condition to WARN_ON in btrfs_set_delalloc_extent()
      btrfs: replace open coded DEBUG_WARN in extent_writepage()
      btrfs: lift assertions to beginning of insert_delayed_ref()
      btrfs: do more kmalloc_obj()/kmalloc_objs() conversions
      btrfs: convert kmalloc_array to kmalloc_objs in btrfs_calc_avail_data_space()
      btrfs: convert ioctl handlers to AUTO_KFREE
      btrfs: make more ASSERTs verbose, part 3
      btrfs: remove 32bit compat code for VFS inode number
      btrfs: move transaction abort message to __btrfs_abort_transaction()
      btrfs: remove fs_info from struct btrfs_backref_iter
      btrfs: use on stack backref iterator in build_backref_tree()
      btrfs: validate negative error number passed to btrfs_abort_transaction()
      btrfs: simplify how first hit is passed to __btrfs_abort_transaction()
      btrfs: add message format for qgroupid
      btrfs: send: switch struct fs_path to auto freeing
      btrfs: use shifts for sectorsize and nodesize
      btrfs: send: pass bool for pending_move and refs_processed parameters
      btrfs: switch local indicator variables to bools

Filipe Manana (51):
      btrfs: use a kmem_cache for block groups
      btrfs: reduce size of struct btrfs_block_group
      btrfs: use a kmem_cache for free space control structures
      btrfs: remove start field from struct btrfs_free_space_ctl
      btrfs: remove unit field from struct btrfs_free_space_ctl
      btrfs: reduce size of struct btrfs_free_space_ctl
      btrfs: remove op field from struct btrfs_free_space_ctl
      btrfs: remove block group argument from copy_free_space_cache()
      btrfs: remove unnecessary ctl argument from __btrfs_write_out_cache()
      btrfs: remove unnecessary ctl argument from write_cache_extent_entries()
      btrfs: use min_size variable to setup block rsv in btrfs_replace_file_extents()
      btrfs: use the enums instead of int type in struct btrfs_block_group fields
      btrfs: add missing unlikely to if branches leading to a DEBUG_WARN()
      btrfs: change return type from int to bool in check_eb_range()
      btrfs: make sure report_eb_range() is not inlined
      btrfs: tracepoints: remove double negation in finish ordered extent event
      btrfs: tracepoints: remove pointless root field from transaction commit event
      btrfs: remove call to transaction commit trace in warn_about_uncommitted_trans()
      btrfs: remove call to transaction commit trace in btrfs_cleanup_transaction()
      btrfs: tracepoints: pass a transaction handle to transaction commit event
      btrfs: tracepoints: add in_fsync field to transaction commit event
      btrfs: tracepoints: add trace event for transaction aborts
      btrfs: tracepoints: add trace event for the start of a new transaction
      btrfs: tracepoints: trace transaction states during commit phase
      btrfs: stop checking for greater then zero return values in btrfs_sync_file()
      btrfs: remove redundant writeback error check during fsync
      btrfs: tracepoints: add trace event for when fsync finishes
      btrfs: tracepoints: add trace event for btrfs_log_inode_parent()
      btrfs: use a named enum for the log mode in inode log functions
      btrfs: tracepoints: add trace event for btrfs_log_inode()
      btrfs: tracepoints: add trace event for btrfs_log_all_parents()
      btrfs: tracepoints: add trace event for log_all_new_ancestors()
      btrfs: tracepoints: add trace event for log_new_dir_dentries()
      btrfs: tracepoints: add trace event for add_conflicting_inode()
      btrfs: tracepoints: add trace event for log_conflicting_inodes()
      btrfs: use simple assertions where enough during inode logging and replay
      btrfs: tracepoints: add trace event for log_new_delayed_dentries()
      btrfs: tracepoints: add trace event for btrfs_record_unlink_dir()
      btrfs: tracepoints: add trace event for btrfs_record_snapshot_destroy()
      btrfs: tracepoints: add trace event for btrfs_record_new_subvolume()
      btrfs: tracepoints: add trace event for btrfs_log_new_name()
      btrfs: tracepoints: add trace event for btrfs_sync_log()
      btrfs: tracepoints: show inode type in btrfs_sync_file_enter() event
      btrfs: fix invalid pointer dereference in __btrfs_run_delayed_refs()
      btrfs: fix deadlock cloning inline extent when using flushoncommit
      btrfs: use mapping shared locking for reading super block
      btrfs: return real error after lookup failure in btrfs_ioctl_default_subvol()
      btrfs: use verbose assertions in backref.c
      btrfs: move locking into btrfs_get_reloc_bg_bytenr()
      btrfs: move WARN_ON on unexpected error in __add_tree_block()
      btrfs: fix use-after-free after relocation failure with concurrent COW

Jan Kara (1):
      btrfs: limit size of bios submitted from writeback

Johannes Thumshirn (6):
      btrfs: zoned: document RECLAIM_ZONES flush state
      btrfs: zoned: decode 'RECLAIM_ZONES' state in tracepoints
      btrfs: zoned: always set data_relocation_bg
      btrfs: zoned: don't account data relocation space-info in statfs free space
      btrfs: zoned: fix deadlock waiting for ticket during data relocation
      btrfs: zoned: always set max_active_zones for zoned devices

KangNing Liao (1):
      btrfs: protect sb_write_pointer() with invalidate lock

Mark Harmstone (2):
      btrfs: add ioctl GET_CSUMS to read raw checksums from file range
      btrfs: don't force DIO writes to be serialized

Matthew Wilcox (Oracle) (3):
      Revert "btrfs: fix the file offset calculation inside btrfs_decompress_buf2page()"
      btrfs: replace __free_page with folio_put() in attach_eb_folio_to_filemap()
      btrfs: use bvec_phys() in compressed_bio_last_folio()

Qu Wenruo (33):
      btrfs: pass a valid btrfs_tree_parent_check when possible
      btrfs: remove the COW fixup mechanism
      btrfs: remove folio checked subpage bitmap tracking
      btrfs: check and set EXTENT_DELALLOC_NEW before clearing EXTENT_DELALLOC
      btrfs: remove 2K block size support
      btrfs: enable cross-folio readahead for bs < ps and large folio cases
      btrfs: refresh add_ra_bio_pages() to indicate it's using folios
      btrfs: move large data folios out of experimental features
      btrfs: warn about extent buffer that can not be released
      btrfs: unexport and move extent_invalidate_folio()
      btrfs: simplify the btree folio wait during invalidation
      btrfs: remove locked subpage bitmap
      btrfs: detect dirty blocks without an ordered extent more reliably
      btrfs: unify folio dirty flag clearing
      btrfs: use dirty flag to check if an ordered extent needs to be truncated
      btrfs: remove folio_test_ordered() usage
      btrfs: remove folio ordered flag and subpage bitmap
      btrfs: tree-checker: extract the shared key check for free space entries
      btrfs: tree-checker: ensure free space tree entries won't overflow
      btrfs: tree-checker: add more cross checks for free space tree
      btrfs: update the out-of-date comments on subpage
      btrfs: prepare subpage operations to support more than BITS_PER_LONG sub-bitmaps
      btrfs: migrate btrfs_bio_ctrl::submit_bitmap to support larger bitmaps
      btrfs: introduce support for huge folios
      btrfs: remove the dev stats item for replace target device
      btrfs: remove the dev stats item when removing a device
      btrfs: always update/create the dev stats item when adding a new device
      btrfs: avoid unnecessary dev stats updates
      btrfs: do not trim a device which is not writeable
      btrfs: print a message when a missing device re-appears
      btrfs: fix false IO failure after falling back to buffered write
      btrfs: fix incorrect buffered IO fallback for append direct writes
      btrfs: retry faulting in the pages after a zero sized short direct write

Rik van Riel (1):
      btrfs: allocate eb-attached btree pages as movable

Teng Liu (1):
      btrfs: validate data reloc tree file extent item members

Thorsten Blum (1):
      btrfs: use QSTR() in __btrfs_ioctl_snap_create()

Weiming Shi (1):
      btrfs: lzo: reject compressed segment that overflows the compressed input

Zhang Cen (2):
      btrfs: free-space-tree: reject mismatched extent and bitmap items
      btrfs: tree-checker: validate names in ROOT_REF and ROOT_BACKREF

ZhengYuan Huang (3):
      btrfs: balance: fix potential bg lookup failure in chunk_usage_filter()
      btrfs: balance: fix potential bg lookup failure in chunk_usage_range_filter()
      btrfs: balance: fix potential bg lookup failure in btrfs_may_alloc_data_chunk()

 fs/btrfs/Kconfig                  |   8 +-
 fs/btrfs/backref.c                |  73 ++--
 fs/btrfs/backref.h                |   9 +-
 fs/btrfs/block-group.c            |  48 +-
 fs/btrfs/block-group.h            |  40 +-
 fs/btrfs/btrfs_inode.h            |  37 +-
 fs/btrfs/compression.c            |  83 +---
 fs/btrfs/ctree.c                  |  33 +-
 fs/btrfs/defrag.c                 |  18 -
 fs/btrfs/delalloc-space.c         |   6 +-
 fs/btrfs/delayed-ref.c            |   5 +-
 fs/btrfs/dev-replace.c            |  11 +-
 fs/btrfs/direct-io.c              |  62 ++-
 fs/btrfs/disk-io.c                | 139 ++++--
 fs/btrfs/extent-io-tree.c         |   4 +-
 fs/btrfs/extent-tree.c            |  57 ++-
 fs/btrfs/extent_io.c              | 345 ++++++++-------
 fs/btrfs/extent_io.h              |  25 +-
 fs/btrfs/extent_map.c             |   6 +-
 fs/btrfs/fiemap.c                 |   2 +-
 fs/btrfs/file-item.c              |   6 +-
 fs/btrfs/file.c                   | 120 +++--
 fs/btrfs/free-space-cache.c       | 163 ++++---
 fs/btrfs/free-space-cache.h       |  14 +-
 fs/btrfs/free-space-tree.c        |  51 ++-
 fs/btrfs/fs.h                     |  57 +--
 fs/btrfs/inode.c                  | 327 +++-----------
 fs/btrfs/ioctl.c                  | 757 +++++++++++++++++++++++---------
 fs/btrfs/lzo.c                    |  11 +
 fs/btrfs/ordered-data.c           |  24 +-
 fs/btrfs/ordered-data.h           |   2 +
 fs/btrfs/qgroup.c                 |  41 +-
 fs/btrfs/raid-stripe-tree.c       |   4 +-
 fs/btrfs/raid56.c                 |  18 +-
 fs/btrfs/reflink.c                | 111 ++---
 fs/btrfs/relocation.c             | 348 +++++++++------
 fs/btrfs/relocation.h             |   2 +-
 fs/btrfs/root-tree.c              |   6 +-
 fs/btrfs/scrub.c                  |   3 +-
 fs/btrfs/send.c                   | 162 +++----
 fs/btrfs/space-info.c             |   9 +
 fs/btrfs/space-info.h             |  11 +
 fs/btrfs/subpage.c                | 286 +++++-------
 fs/btrfs/subpage.h                |  33 +-
 fs/btrfs/super.c                  |  58 ++-
 fs/btrfs/tests/btrfs-tests.c      |   1 +
 fs/btrfs/tests/free-space-tests.c |  24 +-
 fs/btrfs/transaction.c            |  39 +-
 fs/btrfs/transaction.h            |  50 ++-
 fs/btrfs/tree-checker.c           | 183 ++++++--
 fs/btrfs/tree-log.c               | 276 ++++++++----
 fs/btrfs/tree-log.h               |   7 +
 fs/btrfs/verity.c                 |   4 +-
 fs/btrfs/volumes.c                | 166 +++++--
 fs/btrfs/volumes.h                |   2 +
 fs/btrfs/zoned.c                  |  79 ++--
 include/trace/events/btrfs.h      | 889 +++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/btrfs.h        |  34 ++
 58 files changed, 3480 insertions(+), 1909 deletions(-)
