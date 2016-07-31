Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9007 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752822AbcGaNzP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Jul 2016 09:55:15 -0400
Date: Sun, 31 Jul 2016 09:55:09 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160731135509.iykc244eoqaux5oa@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

This is part one of my btrfs pull, and you can find it in my
for-linus-4.8 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.8

This pull is dedicated to Josef's enospc rework, which we've been
testing for a few releases now.  It fixes some early enospc problems and
is dramatically faster.

The pull also includes an updated fix for the delalloc accounting that
happens after a fault in copy_from_user.   My patch in v4.7 was almost but
not quite enough.

Dave Sterba has a branch prepped with a cleanup series from Jeff Mahoney
as well as other fixes.  My plan is to send that after wading
through vacation backlog on Monday.

Josef Bacik (19) commits (+679/-344):
    Btrfs: avoid deadlocks during reservations in btrfs_truncate_block (+5/-0)
    Btrfs: use FLUSH_LIMIT for relocation in reserve_metadata_bytes (+22/-17)
    Btrfs: don't bother kicking async if there's nothing to reclaim (+3/-0)
    Btrfs: change delayed reservation fallback behavior (+23/-41)
    Btrfs: always reserve metadata for delalloc extents (+13/-22)
    Btrfs: change how we calculate the global block rsv (+9/-36)
    Btrfs: add bytes_readonly to the spaceinfo at once (+11/-18)
    Btrfs: introduce ticketed enospc infrastructure (+380/-151)
    Btrfs: fill relocation block rsv after allocation (+6/-0)
    Btrfs: fix delalloc reservation amount tracepoint (+3/-1)
    Btrfs: fix release reserved extents trace points (+1/-5)
    Btrfs: fix callers of btrfs_block_rsv_migrate (+18/-25)
    Btrfs: always use trans->block_rsv for orphans (+7/-1)
    Btrfs: use root when checking need_async_flush (+6/-5)
    Btrfs: add tracepoint for adding block groups (+42/-0)
    Btrfs: add tracepoints for flush events (+103/-10)
    Btrfs: warn_on for unaccounted spaces (+8/-6)
    Btrfs: add fsid to some tracepoints (+11/-6)
    Btrfs: trace pinned extents (+8/-0)

Chris Mason (1) commits (+5/-7):
    Btrfs: fix delalloc accounting after copy_from_user faults

Total: (20) commits (+684/-351)

 fs/btrfs/ctree.h             |  15 +-
 fs/btrfs/delayed-inode.c     |  68 ++--
 fs/btrfs/extent-tree.c       | 731 +++++++++++++++++++++++++++----------------
 fs/btrfs/file.c              |  16 +-
 fs/btrfs/inode.c             |   7 +-
 fs/btrfs/relocation.c        |  45 +--
 include/trace/events/btrfs.h | 139 +++++++-
 7 files changed, 677 insertions(+), 344 deletions(-)
