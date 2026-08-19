Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66F1481FD9;
	Wed, 19 Aug 2026 16:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787158260; cv=none; b=IAfyWL/s2wtRwnrE9MSt0dN062eX23bsl8BME9zUPkQy0OtrXzC0Evgf0wYiJ4vZGonGuDb26AJiYyBD1cNqv/qK6Oaa85kBjgiAf1/2DEq2bqUwopGXSgj4ERj2tVP2Ex6nzTEiotdbEj+tQuGsTFIuVEfUj91tP3aS5iyPtgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787158260; c=relaxed/simple;
	bh=K7HYTiAyWF8Fntf4jG7HJbh4R5zElEXT5FQrIFXAc7g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PeW+cPQsGLS1eadwWClFS+4Ns3JBHGK8/DyCmweFXJHTJwp3sVStKdRzC+poWtjJLeMM9KJE8sHSgHYxSGpDHKZrvTRzc3HiH0Y8YuZEKLvKM6VJJrrJMU9bXNNBAY3XwZMZp8mSsCnZL6V/rZYfRSCDH38NzBYC4W6flt4L55k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BSKxKUvt; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ehk8eUle; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BSKxKUvt";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ehk8eUle"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BEB293EA0;
	Wed, 19 Aug 2026 16:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787158251; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=p7xuHPi7TOI04cNzF0mTaAFoxLGb65d4Lb1KA3lMRcE=;
	b=BSKxKUvtD24efx6TZ6UUv/QbLbPxgrxH9JrVxSaLSQ+45JYsjTzx6YQbP2MBq6jZdevaG+
	Ys/9yZvsomOThoR34cNqj+Stwe4ZDOAdymwRUMQcOsVO4uk4bEShxua57BQj4x5LU9fSnr
	GH+zhsRnmU4Z6oZOTEKwjmzMJfCMeAE=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Ehk8eUle
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787158247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=p7xuHPi7TOI04cNzF0mTaAFoxLGb65d4Lb1KA3lMRcE=;
	b=Ehk8eUleqWmUzbfKe3ysLj+DvjsnVzpWKiKYFJOVOdOlqRffutnvhmhl7A66OJILkeLZZg
	D4ldWLU8+vxTiSCtcOoUYKWnbXyNgcCtS2bs5P96W/t+a+y5uEiQuX1FJjccOZkpYjcEFT
	Rww7e1gLNqKOdeyWYIZ+OhKSbg6MyAQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B7CC82F81;
	Wed, 19 Aug 2026 16:50:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0xzZLOfehWoPFgAAD6G6ig
	(envelope-from <dsterba@suse.com>); Wed, 19 Aug 2026 16:50:47 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 7.3
Date: Wed, 19 Aug 2026 18:50:10 +0200
Message-ID: <cover.1787152457.git.dsterba@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:dkim];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.51
X-Spam-Level: 
X-Rspamd-Queue-Id: BEB293EA0
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Hi,

this is summer edition of btrfs changes, smaller than usual. Yet, there
are performance improvements in various areas or for specific workloads
and some notable changes like removing space cache v1 code or mount
option reduction.

Please pull, thanks.

User visible changes:

- free space v1 disabled by default; the v2 (free space tree) is mkfs
  default since 5.15, filesystems with v1 still work but could be
  slightly slower due to lack of block group caching

- mount option 'rescue=usebackuproot' requires read-only mount, it's
  too risky to allow writable mount

- remove standalone mount option 'usebackuproot', deprecated in 5.9

- preserve constraints of NODATASUM and NODATACOW when chattr and mount
  options may change the attributes

- remove arbitrary limitation of 4KiB for page size when allowing block
  sizes smaller than page

- print messages when pinned block groups affect swap activation

Performance improvements:

- use iomap bounce buffer for direct io instead of a fall back to
  buffered io; past correctness vs speed trade-offs dropped performance
  to ~50% of theoretical maximum, now it's ~95%, effectively doubled

- replace xarray with local LRU list for tracking inhibited extent
  buffers, restored performance to pre-inhibition state (relatively ~3x)

- remove unnecessary 1 jiffy delay in "non-SSD" mode with multiple
  logging tasks, decrease latency, throughput increased ~5x on sample
  workload

- skip hole detection during full fsync for files without holes and lots
  of extents, reduce run time ~5x on sample workload (microsecond ranges)

- reduce locking around extent readahead so it does not slow down other
  tasks using an overlapping range

- enhance extent buffer allocation modes to allow NOWAIT semantics in
  some cases

Notable fixes:

- write-protect folios during writeback, prevent concurrent mmap and
  compress/checksumming/etc undesired interactions

- in zoned mode, handle transient overcommit full instead of going
  read-only

- fix possible deadlock between defragmentation and delayed allocation
  reservations

- handle remaining iputs at umount time

- fix lockdep warning between device scan locking and log mutex

- add workaround for degenerate RAID56 device count modes (2 and 3) not
  supported by the parity calculation library

- restore check that subvolume is not read-only when changing ACLs

- retry reading verity data colliding with up-to-date status changes

Core:

- simplify raid56 stripe handling by using contiguous virtual
  allocations

- in zoned mode, fix various metadata write issues in writeback or
  unmount

- space reservation fixes

- remove unused data structure members

- more auto-freeing conversions

- error pointer values are printed using %pe format

----------------------------------------------------------------
The following changes since commit a13307e97d5c54b65720bb71fa379960ded1e51a:

  Merge tag 'bpf-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2026-08-07 08:08:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-tag

for you to fetch changes up to 4096e2a06f43fae209d6472d395f3219e02ab2e6:

  btrfs: skip hole detection during full fsync for files without holes (2026-08-07 19:17:19 +0200)

----------------------------------------------------------------
Boris Burkov (6):
      btrfs: release extent lock per folio in readahead
      btrfs: write-protect folios during data writeback
      btrfs: factor init_extent_buffer from __alloc_extent_buffer
      btrfs: add struct btrfs_eb_prealloc
      btrfs: enable unlocked NOFAIL retry for eb allocations
      btrfs: use GFP_NOWAIT for tree block readahead

David Sterba (1):
      btrfs: sink idmap parameter to __btrfs_ioctl_snap_create()

Dongjiang Zhu (1):
      btrfs: start qgroup ioctl transactions on the quota root

Filipe Manana (18):
      btrfs: don't over reserve metadata space for property in btrfs_fileattr_set()
      btrfs: fix memory barrier order in reloc_root_is_dead()
      btrfs: fix copy_remapped_data() to not allocate more memory than intended
      btrfs: send: fix comment for SEND_MAX_DIR_UTIMES_CACHE_SIZE
      btrfs: send: fix is_current_inode_path() to avoid path resets for common prefixes
      btrfs: defrag: fix deadlock between defrag and delalloc space reservation
      btrfs: fix pending delayed iputs when using autodefrag
      btrfs: defrag: use a single list for each loop in defrag_one_range()
      btrfs: defrag: use auto kfree in defrag_one_range() for folios array
      btrfs: defrag: use simple list_del() in defrag_collect_targets()
      btrfs: defrag: remove pointless list_del_init() in defrag_one_cluster()
      btrfs: get rid of useless label in btrfs_create_dio_extent()
      btrfs: stop sleeping for one jiffy in non-ssd mounts during log commit
      btrfs: remove log batch counter use for fsync
      btrfs: move condition for log commit wait into wait_log_commit()
      btrfs: check for exit condition after waking in wait_log_commit()
      btrfs: use simple booleans for log_commit field in struct btrfs_root
      btrfs: skip hole detection during full fsync for files without holes

Guanghui Yang (1):
      btrfs: drop recovered reloc root refs on recovery failure

Hongling Zeng (1):
      btrfs: add missing sctx check in cleanup path in btrfs_ioctl_send()

Johannes Thumshirn (5):
      btrfs: zoned: don't force read-only on transient -EAGAIN from reloc merge
      btrfs: zoned: flush active metadata block group at btree_writepages() start
      btrfs: zoned: drop stranded dirty metadata on transaction abort
      btrfs: zoned: drop stranded dirty metadata buffers at unmount
      btrfs: zoned: don't clobber the extent buffer when zeroing it out

Leo Martins (1):
      btrfs: replace writeback inhibition xarray with a fixed inline buffer

Miquel Sabaté Solà (1):
      btrfs: don't pass tree_id in btrfs_search_path_in_tree()

Qu Wenruo (31):
      btrfs: remove btrfs_dio_data::submitted
      btrfs: refactor btrfs_dio_iomap_end()
      btrfs: do not overwrite NODATASUM flag when removing NODATACOW flag
      btrfs: log swapfile activation/deactivation and warn about pinned block groups
      btrfs: disable v1 space cache
      btrfs: remove out-of-date comments regarding 2K block size
      btrfs: allow any block size that is no larger than page size
      btrfs: use correct type for sectorsize/nodesize/blocksize
      btrfs: remove btrfs_fs_info::stripesize
      btrfs: always wait for ordered extents to avoid OE races
      btrfs: use IOMAP_DIO_BOUNCE flag instead of falling back to buffered IO
      btrfs: add "rescue=usebackuproot" into forced read-only options
      btrfs: add "rescue=usebackuproot" into "rescue=all" shortcut
      btrfs: remove "usebackuproot" mount option
      btrfs: remove SCRUB_MAX_SECTORS_PER_BLOCK
      btrfs: factor out common scrub read endio into a helper
      btrfs: scrub: implement calc_sector_number() in a faster way
      btrfs: use kvmalloc() for stripe buffer of scrub_stripe
      btrfs: fix a lockdep caused by path resolution during device scan
      btrfs: make sure EXTENT_BUFFER_READING is cleared under refs_lock
      btrfs: remove btrfs_chunk_map::io_(align|width) members
      btrfs: remove duplicated block group type assignment
      btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
      btrfs: open code BTRFS_BYTES_TO_BLKS()
      btrfs: use %pe for error code output
      btrfs: convert reflink.c to use btrfs_inode as parameters
      btrfs: use aligned range for locking in extent_fiemap()
      btrfs: use aligned range for locking in reflink
      btrfs: add validation for extent states
      btrfs: qgroup: fix a wrong length calculation in qgroup_free_reserved_data()
      btrfs: add extra ASSERT()s to make sure the folio size is correct

Rosen Penev (1):
      btrfs: compression: allocate heuristic buckets with workspace

Shuangpeng Bai (1):
      btrfs: fix extent map leak in NOCOW direct I/O write

Sun YangKai (2):
      btrfs: change block group reclaim_mark to bool
      btrfs: check if root is readonly when setting posix acl

Yichong Chen (1):
      btrfs: retry verity reads for not-uptodate Merkle folios

Zenghui Yu (1):
      btrfs: sysfs: fix path of the "read_policy" module parameter in comment

 fs/btrfs/acl.c               |   4 +
 fs/btrfs/block-group.c       |  13 +-
 fs/btrfs/block-group.h       |   4 +-
 fs/btrfs/compression.c       |  14 +-
 fs/btrfs/ctree.c             |  36 ++-
 fs/btrfs/ctree.h             |   6 +-
 fs/btrfs/defrag.c            |  61 +++--
 fs/btrfs/delayed-inode.c     |  12 +-
 fs/btrfs/direct-io.c         | 210 +++++++-------
 fs/btrfs/disk-io.c           | 153 +++++++----
 fs/btrfs/disk-io.h           |   2 +
 fs/btrfs/extent-io-tree.c    |  21 ++
 fs/btrfs/extent-tree.c       |  28 +-
 fs/btrfs/extent_io.c         | 637 ++++++++++++++++++++++++++++++++-----------
 fs/btrfs/extent_io.h         |  29 ++
 fs/btrfs/fiemap.c            |   6 +-
 fs/btrfs/file.c              | 120 ++++----
 fs/btrfs/fs.c                |  19 +-
 fs/btrfs/fs.h                |   6 +-
 fs/btrfs/inode.c             |  86 ++++--
 fs/btrfs/ioctl.c             | 138 ++++++----
 fs/btrfs/messages.c          |  10 +-
 fs/btrfs/qgroup.c            |  26 +-
 fs/btrfs/raid56.c            |  18 +-
 fs/btrfs/raid56.h            |   2 +-
 fs/btrfs/reflink.c           | 111 ++++----
 fs/btrfs/relocation.c        |  97 +++++--
 fs/btrfs/root-tree.c         |   6 +-
 fs/btrfs/scrub.c             | 234 +++++++---------
 fs/btrfs/send.c              |  17 +-
 fs/btrfs/space-info.c        |   2 +-
 fs/btrfs/subpage.c           |   7 +-
 fs/btrfs/subpage.h           |   3 +-
 fs/btrfs/super.c             |  37 +--
 fs/btrfs/sysfs.c             |   2 +-
 fs/btrfs/transaction.c       |  18 +-
 fs/btrfs/transaction.h       |  25 +-
 fs/btrfs/tree-log.c          |  99 +++----
 fs/btrfs/verity.c            |  18 +-
 fs/btrfs/volumes.c           |  64 ++---
 fs/btrfs/volumes.h           |  10 +-
 include/trace/events/btrfs.h |   4 +-
 42 files changed, 1437 insertions(+), 978 deletions(-)
