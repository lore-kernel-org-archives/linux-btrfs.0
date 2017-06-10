Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44809 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751583AbdFJNBQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Jun 2017 09:01:16 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Subject: [GIT PULL] Btrfs
Message-ID: <6dd9667f-4812-dc80-1875-182ec27f0c1e@fb.com>
Date: Sat, 10 Jun 2017 09:00:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.12 branch has some fixes that Dave Sterba collected:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.12

We've been hitting an early enospc problem on production machines that
Omar tracked down to an old int->u64 mistake.  I waited a bit on
this pull to make sure it was really the problem from production,
but it's on ~2100 hosts now and I think we're good.

Omar also noticed a commit in the queue would make new early ENOSPC
problems.  I pulled that out for now, which is why the top three commits
are younger than the rest.

Otherwise these are all fixes, some explaining very old bugs that we've
been poking at for a while.

Jeff Mahoney (2) commits (+4/-3):
    btrfs: fix race with relocation recovery and fs_root setup (+3/-3)
    btrfs: fix memory leak in update_space_info failure path (+1/-0)

Liu Bo (1) commits (+1/-1):
    Btrfs: clear EXTENT_DEFRAG bits in finish_ordered_io

Colin Ian King (1) commits (+1/-1):
    btrfs: fix incorrect error return ret being passed to mapping_set_error

Omar Sandoval (1) commits (+2/-2):
    Btrfs: fix delalloc accounting leak caused by u32 overflow

Qu Wenruo (1) commits (+122/-2):
    btrfs: fiemap: Cache and merge fiemap extent before submit it to user

David Sterba (1) commits (+2/-2):
    btrfs: use correct types for page indices in btrfs_page_exists_in_range

Jan Kara (1) commits (+6/-4):
    btrfs: Make flush bios explicitely sync

Su Yue (1) commits (+1/-1):
    btrfs: tree-log.c: Wrong printk information about namelen

Total: (9) commits (+139/-16)

 fs/btrfs/ctree.h       |   4 +-
 fs/btrfs/dir-item.c    |   2 +-
 fs/btrfs/disk-io.c     |  10 ++--
 fs/btrfs/extent-tree.c |   7 +--
 fs/btrfs/extent_io.c   | 126 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/inode.c       |   6 +--
 6 files changed, 139 insertions(+), 16 deletions(-)
