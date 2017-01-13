Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44888 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751283AbdAMWBZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jan 2017 17:01:25 -0500
Date: Fri, 13 Jan 2017 17:01:20 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20170113220120.2z6z3set2n4u2k5x@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Dave Sterba queued up a few fixes for btrfs.  I have them in my
for-linus-4.10 branch:

These are all over the place.  The tracepoint part of the pull fixes a
crash and adds a little more information to two tracepoints, while the
rest are good old fashioned fixes.

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.10

Liu Bo (5) commits (+34/-11):
    Btrfs: adjust outstanding_extents counter properly when dio write is split (+9/-2)
    Btrfs: add truncated_len for ordered extent tracepoints (+4/-0)
    Btrfs: use down_read_nested to make lockdep silent (+2/-1)
    Btrfs: add 'inode' for extent map tracepoint (+9/-5)
    Btrfs: fix lockdep warning about log_mutex (+10/-3)

David Sterba (2) commits (+80/-69):
    btrfs: fix crash when tracepoint arguments are freed by wq callbacks (+24/-13)
    btrfs: make tracepoint format strings more compact (+56/-56)

Jeff Mahoney (2) commits (+4/-1):
    btrfs: fix locking when we put back a delayed ref that's too new (+1/-1)
    btrfs: fix error handling when run_delayed_extent_op fails (+3/-0)

Pan Bian (1) commits (+1/-3):
    btrfs: return the actual error value from  from btrfs_uuid_tree_iterate

Total: (10) commits (+119/-84)

 fs/btrfs/async-thread.c      |  15 +++--
 fs/btrfs/extent-tree.c       |   8 ++-
 fs/btrfs/inode.c             |  13 +++-
 fs/btrfs/tree-log.c          |  13 +++-
 fs/btrfs/uuid-tree.c         |   4 +-
 include/trace/events/btrfs.h | 146 +++++++++++++++++++++++--------------------
 6 files changed, 117 insertions(+), 82 deletions(-)
