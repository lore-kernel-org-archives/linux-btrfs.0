Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34315 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932320AbcE0Ro6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 13:44:58 -0400
Date: Fri, 27 May 2016 13:44:41 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160527174441.kwgg754bcy2bj2q7@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We have another round of fixes and a few cleanups in my for-linus-4.7
branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.7

I have a fix for short returns from btrfs_copy_from_user, which finally
nails down a very hard to find regression we added in v4.6.

Dave is pushing around gfp parameters, mostly to cleanup internal apis
and make it a little more consistent.  The rest are smaller fixes, and
one speelling fixup patch.

David Sterba (17) commits (+149/-116):
    btrfs: make state preallocation more speculative in __set_extent_bit (+7/-1)
    btrfs: make find_workspace warn if there are no workspaces (+14/-0)
    btrfs: rename and document compression workspace members (+19/-16)
    btrfs: sink gfp parameter to clear_record_extent_bits (+5/-8)
    btrfs: sink gfp parameter to set_record_extent_bits (+4/-7)
    btrfs: untangle gotos a bit in convert_extent_bit (+7/-9)
    btrfs: untangle gotos a bit in __clear_extent_bit (+8/-8)
    btrfs: sink gfp parameter to set_extent_delalloc (+6/-6)
    btrfs: sink gfp parameter to clear_extent_bits (+15/-16)
    btrfs: sink gfp parameter to convert_extent_bit (+8/-8)
    btrfs: untangle gotos a bit in __set_extent_bit (+7/-8)
    btrfs: sink gfp parameter to clear_extent_dirty (+4/-4)
    btrfs: sink gfp parameter to set_extent_defrag (+3/-3)
    btrfs: sink gfp parameter to set_extent_bits (+10/-11)
    btrfs: sink gfp parameter to set_extent_new (+4/-3)
    btrfs: make find_workspace always succeed (+12/-8)
    btrfs: preallocate compression workspaces (+16/-0)

Liu Bo (2) commits (+7/-3):
    Btrfs: fix unexpected return value of fiemap (+5/-1)
    Btrfs: free sys_array eb as soon as possible (+2/-2)

Chris Mason (1) commits (+17/-10):
    Btrfs: fix handling of faults from btrfs_copy_from_user

Zhao Lei (1) commits (+2/-1):
    btrfs: scrub: Set bbio to NULL before calling btrfs_map_block

Nicholas D Steeves (1) commits (+106/-105):
    btrfs: fix string and comment grammatical issues and typos

Total: (22) commits (+281/-235)

 fs/btrfs/backref.c                |  2 +-
 fs/btrfs/btrfs_inode.h            |  2 +-
 fs/btrfs/check-integrity.c        |  2 +-
 fs/btrfs/ctree.c                  | 14 +++---
 fs/btrfs/ctree.h                  |  6 +--
 fs/btrfs/delayed-ref.h            |  2 +-
 fs/btrfs/dev-replace.c            |  2 +-
 fs/btrfs/disk-io.c                | 14 +++---
 fs/btrfs/extent-tree.c            | 48 ++++++++++----------
 fs/btrfs/extent_io.c              | 94 ++++++++++++++++++++-------------------
 fs/btrfs/extent_io.h              | 34 +++++++-------
 fs/btrfs/extent_map.c             |  2 +-
 fs/btrfs/file-item.c              |  2 +-
 fs/btrfs/file.c                   | 31 ++++++++-----
 fs/btrfs/free-space-cache.c       |  2 +-
 fs/btrfs/free-space-cache.h       |  2 +-
 fs/btrfs/inode.c                  | 27 ++++++-----
 fs/btrfs/ioctl.c                  | 12 ++---
 fs/btrfs/ordered-data.h           |  2 +-
 fs/btrfs/qgroup.c                 | 24 +++++-----
 fs/btrfs/raid56.c                 |  6 +--
 fs/btrfs/relocation.c             | 19 ++++----
 fs/btrfs/root-tree.c              |  4 +-
 fs/btrfs/scrub.c                  | 11 ++---
 fs/btrfs/send.c                   |  6 +--
 fs/btrfs/struct-funcs.c           |  2 +-
 fs/btrfs/super.c                  |  8 ++--
 fs/btrfs/tests/extent-io-tests.c  | 10 ++---
 fs/btrfs/tests/free-space-tests.c |  7 +--
 fs/btrfs/tests/inode-tests.c      |  2 +-
 fs/btrfs/tests/qgroup-tests.c     |  2 +-
 fs/btrfs/transaction.c            |  2 +-
 fs/btrfs/transaction.h            |  2 +-
 fs/btrfs/tree-log.c               | 10 ++---
 fs/btrfs/ulist.c                  |  2 +-
 fs/btrfs/volumes.c                | 12 ++---
 36 files changed, 219 insertions(+), 210 deletions(-)
