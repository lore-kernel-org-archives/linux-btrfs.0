Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30710 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933408AbcGKDIj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jul 2016 23:08:39 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 804C541C0BAA
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 11:08:29 +0800 (CST)
Subject: Re: [PATCH v12.1 00/15] Btrfs in-band de-duplication
To: <linux-btrfs@vger.kernel.org>
References: <20160711030543.30115-1-quwenruo@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a6b24ffe-a5f3-79dd-9790-8df80d8ffe6c@cn.fujitsu.com>
Date: Mon, 11 Jul 2016 11:08:28 +0800
MIME-Version: 1.0
In-Reply-To: <20160711030543.30115-1-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 07/11/2016 11:05 AM, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux.git wang_dedupe_20160711
>
> This version is just a small update, rebased to David's for-next-20160704
> branch, and adds a small non-functional patch to co-ordinate dedupe and
> subpage size patchset.
>
> With this update, conflict for both dedupe and subpage patchset could be
> solved quite easily.

Just forgot changlog:
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
   and wrong parameter.
   Rebased to integration-4.6.
v8:
   Rename 'dedup' to 'dedupe'.
   Add support to allow dedupe and compression work at the same time.
   Fix several balance related bugs. Special thanks to Satoru Takeuchi,
   who exposed most of them.
   Small dedupe hit case performance improvement.
v9:
   Re-order the patchset to completely separate pure in-memory and any
   on-disk format change.
   Fold bug fixes into its original patch.
v10:
   Adding back missing bug fix patch.
   Reduce on-disk item size.
   Hide dedupe ioctl under CONFIG_BTRFS_DEBUG.
v11:
   Remove other backend and props support to focus on the framework and
   in-memory backend. Suggested by David.
   Better disable and buffered write race protection.
   Comprehensive fix to dedupe metadata ENOSPC problem.
v12:
   Stateful 'enable' ioctl and new 'reconf' ioctl
   New FORCE flag for enable ioctl to allow stateless ioctl
   Precious error report and extendable ioctl structure.
v12.1
   Rebase to David's for-next-20160704 branch
   Add co-ordinate patch for subpage and dedupe patchset.


>
> Qu Wenruo (4):
>   btrfs: delayed-ref: Add support for increasing data ref under spinlock
>   btrfs: dedupe: Inband in-memory only de-duplication implement
>   btrfs: relocation: Enhance error handling to avoid BUG_ON
>   btrfs: dedupe: Introduce new reconfigure ioctl
>
> Wang Xiaoguang (11):
>   btrfs: expand cow_file_range() to support in-band dedup and
>     subpage-blocksize
>   btrfs: dedupe: Introduce dedupe framework and its header
>   btrfs: dedupe: Introduce function to initialize dedupe info
>   btrfs: dedupe: Introduce function to add hash into in-memory tree
>   btrfs: dedupe: Introduce function to remove hash from in-memory tree
>   btrfs: dedupe: Introduce function to search for an existing hash
>   btrfs: dedupe: Implement btrfs_dedupe_calc_hash interface
>   btrfs: ordered-extent: Add support for dedupe
>   btrfs: dedupe: Add ioctl for inband dedupelication
>   btrfs: improve inode's outstanding_extents computation
>   btrfs: dedupe: fix false ENOSPC
>
>  fs/btrfs/Makefile                |   2 +-
>  fs/btrfs/ctree.h                 |  25 +-
>  fs/btrfs/dedupe.c                | 820 +++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/dedupe.h                | 221 +++++++++++
>  fs/btrfs/delayed-ref.c           |  30 +-
>  fs/btrfs/delayed-ref.h           |   8 +
>  fs/btrfs/disk-io.c               |   4 +
>  fs/btrfs/extent-tree.c           |  83 +++-
>  fs/btrfs/extent_io.c             |  63 ++-
>  fs/btrfs/extent_io.h             |  15 +-
>  fs/btrfs/file.c                  |  26 +-
>  fs/btrfs/free-space-cache.c      |   5 +-
>  fs/btrfs/inode-map.c             |   4 +-
>  fs/btrfs/inode.c                 | 453 ++++++++++++++++-----
>  fs/btrfs/ioctl.c                 |  93 ++++-
>  fs/btrfs/ordered-data.c          |  46 ++-
>  fs/btrfs/ordered-data.h          |  14 +
>  fs/btrfs/relocation.c            |  46 ++-
>  fs/btrfs/sysfs.c                 |   2 +
>  fs/btrfs/tests/extent-io-tests.c |   6 +-
>  fs/btrfs/tests/inode-tests.c     |  12 +-
>  include/uapi/linux/btrfs.h       |  55 +++
>  22 files changed, 1872 insertions(+), 161 deletions(-)
>  create mode 100644 fs/btrfs/dedupe.c
>  create mode 100644 fs/btrfs/dedupe.h
>


