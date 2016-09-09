Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33268 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754006AbcIIRqe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Sep 2016 13:46:34 -0400
Date: Fri, 9 Sep 2016 13:46:27 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160909174627.vmu3fjkhqujp472o@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We have three fixes in my for-linus-4.8 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.8

I'm not proud of how long it took me to track down that one liner in
btrfs_sync_log(), but the good news is the patches I was trying to blame
for these problems were actually fine (sorry Filipe).

Wang Xiaoguang (2) commits (+16/-8):
    btrfs: introduce tickets_id to determine whether asynchronous metadata reclaim work makes progress (+7/-5)
    btrfs: do not decrease bytes_may_use when replaying extents (+9/-3)

Chris Mason (1) commits (+1/-0):
    Btrfs: remove root_log_ctx from ctx list before btrfs_sync_log returns

Total: (3) commits (+17/-8)

 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/extent-tree.c | 23 +++++++++++++++--------
 fs/btrfs/tree-log.c    |  1 +
 3 files changed, 17 insertions(+), 8 deletions(-)
