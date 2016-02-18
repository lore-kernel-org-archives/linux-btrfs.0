Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45545 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1425087AbcBRFpd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 00:45:33 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: [GIT PULL][PATCH v7 00/19][For 4.6] Btrfs: Add inband (write time) de-duplication framework
Date: Thu, 18 Feb 2016 13:42:38 +0800
Message-Id: <1455774178-3595-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

This is the pull request for btrfs in-band de-duplication patchset.

The patchset can also be fetched from github:
https://github.com/adam900710/linux.git wang_dedup_20160218

Theis patchset went through several tests and seems quite good based on
integration-4.5.
We will continue test after the rebase to
integration-4.6(commit dc1e02a4ae), but for it hasn't shown any problem yet
and I think it would be OK for 4.6 merge window.

Most of the patchset didn't change after v5.
Only 2 bug fix and minor return value is changed since then.

There is still some little further work to do, but currently it should
be OK for most user to try such new feature.

This updated version of inband de-duplication has the following features:
1) ONE unified dedup framework.
   Most of its code is hidden quietly in dedup.c and export the minimal
   interfaces for its caller.
   Reviewer and further developer would benefit from the unified
   framework.

2) TWO different back-end with different trade-off
   One is the improved version of previous Fujitsu in-memory only dedup.
   The other one is enhanced dedup implementation from Liu Bo.
   Changed its tree structure to handle bytenr -> hash search for
   deleting hash, without the hideous data backref hack.

3) Ioctl interface with persist dedup status
   Advised by David, now we use ioctl to enable/disable dedup.

   And we now have dedup status, recorded in the first item of dedup
   tree.
   Just like quota, once enabled, no extra ioctl is needed for next
   mount.

4) Ability to disable dedup for given dirs/files
   It works just like the compression prop method, by adding a new
   xattr.

TODO:
1) Support compression for hash miss case
   This may need to change the on-disk format for on-disk backend.

2) Add extent-by-extent comparison for faster but more conflicting algorithm
   Current SHA256 hash is quite slow, and for some old(5 years ago) CPU,
   CPU may even be a bottleneck other than IO.
   But for faster hash, it will definitely cause conflicts, so we need
   extent comparison before we introduce new dedup algorithm.

3) Misc end-user related helpers
   Like handy and easy to implement dedup rate report.
   And method to query in-memory hash size for those "non-exist" users who
   want to use 'dedup enable -l' option but didn't ever know how much
   RAM they have.

Changelog:
v2:
  Totally reworked to handle multiple backends
v3:
  Fix a stupid but deadly on-disk backend bug
  Add handle for multiple hash on same bytenr corner case to fix abort
  trans error
  Increase dedup rate by enhancing delayed ref handler for both backend.
  Move dedup_add() to run_delayed_ref() time, to fix abort trans error.
  Increase dedup block size up limit to 8M.
v4:
  Add dedup prop for disabling dedup for given files/dirs.
  Merge inmem_search() and ondisk_search() into generic_search() to save
  some code
  Fix another delayed_ref related bug.
  Use the same mutex for both inmem and ondisk backend.
  Move dedup_add() back to btrfs_finish_ordered_io() to increase dedup
  rate.
v5:
  Reuse compress routine for much simpler dedup function.
  Slightly improved performance due to above modification.
  Fix race between dedup enable/disable
  Fix for false ENOSPC report
v6:
  Further enable/disable race window fix.
  Minor format change according to checkpatch.
v7:
  Fix one concurrency bug with balance.
  Slightly modify return value from -EINVAL to -EOPNOTSUPP for
  btrfs_dedup_ioctl() to allow progs to distinguish unsupported commands
  and error parameter.
  Rebased to integration-4.6.

Qu Wenruo (7):
  btrfs: delayed-ref: Add support for increasing data ref under spinlock
  btrfs: dedup: Inband in-memory only de-duplication implement
  btrfs: dedup: Add basic tree structure for on-disk dedup method
  btrfs: dedup: Introduce interfaces to resume and cleanup dedup info
  btrfs: dedup: Add support for on-disk hash search
  btrfs: dedup: Add support to delete hash for on-disk backend
  btrfs: dedup: Add support for adding hash for on-disk backend

Wang Xiaoguang (13):
  btrfs: dedup: Introduce dedup framework and its header
  btrfs: dedup: Introduce function to initialize dedup info
  btrfs: dedup: Introduce function to add hash into in-memory tree
  btrfs: dedup: Introduce function to remove hash from in-memory tree
  btrfs: dedup: Introduce function to search for an existing hash
  btrfs: dedup: Implement btrfs_dedup_calc_hash interface
  btrfs: ordered-extent: Add support for dedup
  btrfs: dedup: Add ioctl for inband deduplication
  btrfs: dedup: add an inode nodedup flag
  btrfs: dedup: add a property handler for online dedup
  btrfs: dedup: add per-file online dedup control
  btrfs: try more times to alloc metadata reserve space
  btrfs: dedup: Fix a bug when running inband dedup with balance

 fs/btrfs/Makefile            |    2 +-
 fs/btrfs/ctree.h             |   73 ++-
 fs/btrfs/dedup.c             | 1146 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/dedup.h             |  167 ++++++
 fs/btrfs/delayed-ref.c       |   30 +-
 fs/btrfs/delayed-ref.h       |    8 +
 fs/btrfs/disk-io.c           |   23 +-
 fs/btrfs/disk-io.h           |    1 +
 fs/btrfs/extent-tree.c       |   41 +-
 fs/btrfs/inode.c             |  183 ++++++-
 fs/btrfs/ioctl.c             |   70 ++-
 fs/btrfs/ordered-data.c      |   43 +-
 fs/btrfs/ordered-data.h      |   13 +
 fs/btrfs/props.c             |   40 ++
 fs/btrfs/relocation.c        |   13 +
 fs/btrfs/sysfs.c             |    2 +
 include/trace/events/btrfs.h |    3 +-
 include/uapi/linux/btrfs.h   |   24 +
 18 files changed, 1839 insertions(+), 43 deletions(-)
 create mode 100644 fs/btrfs/dedup.c
 create mode 100644 fs/btrfs/dedup.h

-- 
2.7.1



