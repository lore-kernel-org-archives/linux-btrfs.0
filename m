Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318163905E6;
	Thu, 15 Oct 2026 17:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792087065; cv=none; b=L6m1X0n7/78oCZ1EsnGu4qoVi6xrh3XBAS2BM/e5QOlg4bCWk5hpQEsFcAQmFaK+YSqFxydxdXrZiBfbYeGCTi3pAcHufoO+rneVdzsyJSgRvKwzvo7IOoD+NT4xvbmquN4IdQ+cwPM9SC0fJq9hTx3x0MMZ/qedhf2V6/sYmsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792087065; c=relaxed/simple;
	bh=xkD/eDLixbrXBeWCzxb2vYHYzsxs2rcx/D3Cnde7Q5o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L4MKDcqy3LvwPClYWWX/yPtHgdCCzsxiKtv+dXMk7Qb1JaoV5q8+0HevO4b85UxQcQFKyMMtbOtu7dWqL+g+Y1Hu9IqN2hqex8DX1Fj91WF38xUlGs1dZAKz3NZopQ3WfuQtbevgeMFjxH2TjAjB0u3VG98KhY6EM04pY5vRoLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hu+IzQpR; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Z97tS/nH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hu+IzQpR";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Z97tS/nH"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CAB7C1F86C;
	Thu, 15 Oct 2026 17:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792087052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pzUQJeyur+HpfUcqiybhAFiNGP/0NieVBKDqsM/p8v0=;
	b=hu+IzQpRd/WnLFuuIKy3qaemqtff0GU/5R/8pa+tZn79ZUemSOOLeYbIClyQL7qQdFgS4K
	qGQOVwf0fEU24TZ5qUC84Ch0f95Wo3+BzL6+VwBBWtWqAAHPAItxrfNX4VVqUskP4D8k64
	T0yrQm0Q9hhhg1bsYOjAxTYkR/1UdYI=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792087050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pzUQJeyur+HpfUcqiybhAFiNGP/0NieVBKDqsM/p8v0=;
	b=Z97tS/nHwQiN3RO91hzg0UxGBAekgjLyBsD5Pnkth21HiUvfMG4+v6qo6WiWlRQ5yVIyFd
	tkUPShAxhX/XJWtOqRhFR+f4htNlRJRFSQlm0wsnlydqFUWeylDZuLqJ3ZYFNuPmdhUll/
	yN4sWqAoadLERKf+tpABSTdXNIYXpjU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4F8513223;
	Thu, 15 Oct 2026 17:57:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Fn+EIAoU0Wp1ZAAAD6G6ig
	(envelope-from <dsterba@suse.com>); Thu, 15 Oct 2026 17:57:30 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 7.4
Date: Thu, 15 Oct 2026 19:57:24 +0200
Message-ID: <cover.1792086912.git.dsterba@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO

Hi,

there's a handful of user visible changes, some of them fixes and the
rest is in the core.  There are some minor performance improvements too.

Please pull, thanks.

User visible changes:

- remove tweakable sysfs way to enable features, used only for extent-irefs
  which has been default since 3.12; the sysfs interface makes it complicated
  due to locking and context, unlike ioctl

- change which backup superblock does mount option 'rescue=usebackuproot'
  choose, skip the last one due to rotation, for more fine grained control add
  options selecting a specific backup superblock by index (usebackuproot_N)

Notable fixes:

- syslog message fixup of error state description, duplicate 'E' renamed to 'H'
  (emergency shutdown), added 'I 'when delayed iputs are blocked

- use kvmalloc for b-tree buffer allocations, as we're using more contig ranges
  because of large folios, the allocations started to warn on fragmented memory

- handle unknown commands for the /dev/btrfs-control ioctls

- tune timing of transaction commit when the space is getting low

- in raid56, skip verifications if data checksums are not available

Performance improvements:

- reflink speedup, reorder locking and flushing to optimize for more common
  cases where the reflinked ranges are accessed, avoid unnecessary contention

- minor speedup in zstd decompression (+8MB/s)

- reduced contention of inode extent map lock, improves e.g. when shrinker
  processes inodes without extent maps, measured time reduction 10-20%

Core changes:

- move allocation errors out of some contexts (new inode/dentry/rename) to
  avoid transaction aborts

- allocate system new chunks earlier, e.g. when consumed by fallocate, and tune
  deleting unused block groups if the system space is low

- tree checker: reject extents for special files

- many qgroup fixes regarding enabling/disabling, other state changes and
  qgroup relation updates

- error handling fixes

- refactoring, cleanups
  - page to folio cleanups
  - transaction state macros/enums simplification
  - parameter simplifications

----------------------------------------------------------------
The following changes since commit 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907:

  Linux 7.3-rc7 (2026-10-11 20:04:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.4-tag

for you to fetch changes up to 58e844c3ba387ceb0f527a6ba82aa50c81c4d7b7:

  btrfs: fix use-after-free on quota enable allocation failure (2026-10-12 23:59:21 +0200)

----------------------------------------------------------------
Boris Burkov (6):
      btrfs: keep unused block groups queued when a pass fails
      btrfs: pre-flush reflink source before taking inode locks
      btrfs: skip unlocked reflink source flush if the inode has writers
      btrfs: downgrade the reflink source inode lock for tree walking
      btrfs: allocate additional SYSTEM space earlier
      btrfs: commit after deleting an unused block group if system space is low

Breno Leitao (1):
      btrfs: skip extent tree lock in the shrinker for inodes without extent maps

Daniel Vacek (2):
      btrfs: consume given iter directly instead of copying in csum_one_bio()
      btrfs: use bio::remaining for async checksumming synchronization

Filipe Manana (31):
      btrfs: increment extent count once when logging extents during fast fsync
      btrfs: tree-checker: cache accessor return value in CHECK_FE_ALIGNED()
      btrfs: add missing unlikely to a couple error checks during sys chunk array validation
      btrfs: remove redundant eb generation check in btrfs_buffer_uptodate()
      btrfs: remove duplicate error message when writing super blocks
      btrfs: fix off by one super block end offset calculation when writing super blocks
      btrfs: fix barrier usage in btrfs_record_root_in_trans()
      btrfs: assert reloc mutex is held in record_root_in_trans()
      btrfs: fix dangling nodes in tree-mod-log after error in btrfs_tree_mod_log_insert_root()
      btrfs: simplify dir item location setup in btrfs_insert_xattr_item()
      btrfs: fix incomplete iteration over fs state when logging messages
      btrfs: fix duplicated code in fs state string in logged messages
      btrfs: add missing code for no delayed iput fs state in log messages
      btrfs: remove unnecessary pointer increment in btrfs_state_to_string()
      btrfs: avoid overhead when logging messages if fs state is clean
      btrfs: fix off-by-one end offset check in report_setget_bounds()
      btrfs: remove fs_info argument from btrfs_block_rsv_add()
      btrfs: remove fs_info argument from btrfs_block_rsv_refill()
      btrfs: remove pointless qgroup assignment in block_rsv_release_bytes()
      btrfs: remove unnecessary forward struct declarations in volumes.h
      btrfs: qgroup: fix swapped blocks existence check when tracing after COW
      btrfs: qgroup: abort transaction on failure to add qgroup relation
      btrfs: qgroup: fix leak of qgroups in rb tree after failure to enable quotas
      btrfs: qgroup: merge error labels in btrfs_quota_enable()
      btrfs: abort transaction on qgroup failures in create_pending_snapshot()
      btrfs: qgroup: fix off-by-one max level check in qgroup_trace_new_subtree_blocks()
      btrfs: fix lost error return value in btrfs_alloc_logged_file_extent()
      btrfs: qgroup: make btrfs_record_squota_delta() return void
      btrfs: use READ_ONCE() to read the chunk size from the data space_info
      btrfs: defrag: fix key comparison with max defrag key in btrfs_defrag_leaves()
      btrfs: defrag: fix check to see if next extent can be defragged too

Guanghui Yang (2):
      btrfs: free unlinked replace target on initialization failure
      btrfs: roll back sprout setup after device add failure

Hemanth Selam (1):
      btrfs: fix typos and repeated words in comments

Hengyu Liang (1):
      btrfs: return -ENOTTY for unknown ioctls on the control device

Jeff Layton (4):
      btrfs: split btrfs_insert_delayed_dir_index() into prealloc and commit phases
      btrfs: pre-allocate delayed dir index before btree modification
      btrfs: handle ENOMEM from btrfs_insert_dir_item() without aborting
      btrfs: pre-allocate delayed dir index for non-overwrite rename

Johannes Thumshirn (1):
      btrfs: zoned: fix double list add in btrfs_load_block_group_zone_info

Peng Fan (1):
      btrfs: use assign_bit() where applicable

Qu Wenruo (29):
      btrfs: refactor read_key_bytes() to remove the dest_folio parameter
      btrfs: replace btrfs_repair_io_failure() to use bio for page iteration
      btrfs: enhance btrfs_data_csum_ok() to use bio for page iteration
      btrfs: use a shared helper to calculate data checksum for a bio
      btrfs: remove on-stack paddrs[] array usage
      btrfs: remove unused variable flags from btrfs_read_qgroup_config()
      btrfs: qgroup: use atomic operations for btrfs_fs_info::qgroup_flags
      btrfs: reject new qgroup rescan during subvolume dropping
      btrfs: avoid long stall when dropping a non-shared large subvolume
      btrfs: remove runtime tweakable feature sysfs interface
      btrfs: use ordered extent to grab the logical address for submission
      btrfs: tree-checker: reject file extent items for special files
      btrfs: use kvmalloc() for b-tree split_item()
      btrfs: tree-log: use kvmalloc() for overwrite_item()
      btrfs: use kvmalloc() for uncompress_inline()
      btrfs: use kvmalloc() to allocate compression workspace buffer for zlib and zstd
      btrfs: cleanup and rename submit_extent_folio()
      btrfs: fix off-by-one end related to inode_need_compress()
      btrfs: simplify heuristic_collect_sample() to handle large folios better
      btrfs: move __TRANS_* and TRANS_* flags out of transaction.h
      btrfs: remove __TRANS_FREEZABLE
      btrfs: remove __TRANS_* flags
      btrfs: qgroup: do not treat "ret > 0" as error when deleting a qgroup
      btrfs: qgroup: use qgroup_mark_inconsistent() in quick_update_accounting()
      btrfs: qgroup: do not leak -ENOENT from btrfs_remove_qgroup()
      btrfs: raid56: do not verify the content if there is no data checksum
      btrfs: always use the second newest slot for rescue=usebackuproot
      btrfs: introduce more accurate usebackuproot options
      btrfs: prevent use-after-free in btrfs_transaction::switch_commits

Tal Zussman (8):
      btrfs: tests: rename process_page_range() to process_folio_range()
      btrfs: tests: convert test_find_delalloc() to use folios
      btrfs: tests: use eb folio helpers in extent buffer memory checks
      btrfs: convert btrfs_compr_pool_scan() to use folios
      btrfs: convert heuristic_collect_sample() to use folios
      btrfs: fix stale function references in compression comments
      btrfs: use folios for reading super blocks from the block device
      btrfs: use u64 for the page indices in heuristic_collect_sample()

Usama Arif (1):
      btrfs: zstd: avoid a copy in zstd_decompress_bio()

Wentao Liang (1):
      btrfs: zoned: fix block group reference leak in btrfs_repair_one_zone()

Yalagada Pavan Kumar (1):
      btrfs: fix use-after-free on quota enable allocation failure

Yang Xiuwei (1):
      btrfs: drop unused uring encoded IO REISSUE stash helpers

Zhen Ni (1):
      btrfs: replace is_data_bbio() with is_data_inode() for direct usage

 fs/btrfs/accessors.c             |   2 +-
 fs/btrfs/backref.c               |   2 +-
 fs/btrfs/bio.c                   | 163 +++++++++++---------------
 fs/btrfs/bio.h                   |   9 +-
 fs/btrfs/block-group.c           |  65 +++++++++--
 fs/btrfs/block-group.h           |   2 +-
 fs/btrfs/block-rsv.c             |  12 +-
 fs/btrfs/block-rsv.h             |   6 +-
 fs/btrfs/btrfs_inode.h           |  22 ++--
 fs/btrfs/compression.c           |  61 +++++-----
 fs/btrfs/ctree.c                 |   4 +-
 fs/btrfs/ctree.h                 |   2 +-
 fs/btrfs/defrag.c                |   8 +-
 fs/btrfs/delayed-inode.c         | 118 ++++++++++++++-----
 fs/btrfs/delayed-inode.h         |  22 +++-
 fs/btrfs/dev-replace.c           |  10 +-
 fs/btrfs/dir-item.c              |  50 +++++---
 fs/btrfs/dir-item.h              |   5 +-
 fs/btrfs/direct-io.c             |   7 ++
 fs/btrfs/disk-io.c               | 167 +++++++++++++-------------
 fs/btrfs/extent-io-tree.c        |   2 +-
 fs/btrfs/extent-tree.c           |  21 ++--
 fs/btrfs/extent_io.c             | 247 +++++++++++++++++++--------------------
 fs/btrfs/extent_map.c            |   8 ++
 fs/btrfs/file-item.c             |  35 ++----
 fs/btrfs/fs.c                    |   2 +-
 fs/btrfs/fs.h                    |   3 +-
 fs/btrfs/inode.c                 | 190 +++++++++++++++---------------
 fs/btrfs/ioctl.c                 |  14 +--
 fs/btrfs/messages.c              |  28 ++---
 fs/btrfs/props.c                 |   3 +-
 fs/btrfs/qgroup.c                | 212 +++++++++++++++++++--------------
 fs/btrfs/qgroup.h                |  20 +++-
 fs/btrfs/raid56.c                |  68 ++++++-----
 fs/btrfs/reflink.c               |  51 +++++++-
 fs/btrfs/relocation.c            |  13 +--
 fs/btrfs/root-tree.c             |   3 +-
 fs/btrfs/send.c                  |   2 +-
 fs/btrfs/space-info.c            |   4 +-
 fs/btrfs/super.c                 |  31 ++++-
 fs/btrfs/sysfs.c                 | 134 ++-------------------
 fs/btrfs/tests/btrfs-tests.c     |   9 --
 fs/btrfs/tests/btrfs-tests.h     |   2 -
 fs/btrfs/tests/extent-io-tests.c | 129 ++++++++++----------
 fs/btrfs/transaction.c           | 127 +++++++++++++-------
 fs/btrfs/transaction.h           |  31 ++---
 fs/btrfs/tree-checker.c          |  83 ++++++++++---
 fs/btrfs/tree-log.c              |  11 +-
 fs/btrfs/tree-mod-log.c          |  13 ++-
 fs/btrfs/verity.c                |  31 +++--
 fs/btrfs/volumes.c               |  67 ++++++++---
 fs/btrfs/volumes.h               |   4 +-
 fs/btrfs/zlib.c                  |  10 +-
 fs/btrfs/zoned.c                 |  20 ++--
 fs/btrfs/zstd.c                  |  73 +++++++++---
 include/uapi/linux/btrfs_tree.h  |  25 ++--
 56 files changed, 1360 insertions(+), 1103 deletions(-)
