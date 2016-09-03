Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38994 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752325AbcICNyY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 3 Sep 2016 09:54:24 -0400
Date: Sat, 3 Sep 2016 09:54:19 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160903135419.t4t5izzvb5snex4m@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We have a few small fixes queued up in my for-linus-4.8 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.8

I'm still prepping a set of fixes for btrfs fsync, just nailing
down a hard to trigger memory corruption.  For now, these are tested and
ready:

Josef Bacik (1) commits (+5/-3):
    Btrfs: kill invalid ASSERT() in process_all_refs()

Liu Bo (1) commits (+5/-3):
    Btrfs: fix endless loop in balancing block groups

Wang Xiaoguang (1) commits (+5/-5):
    btrfs: fix one bug that process may endlessly wait for ticket in wait_reserve_ticket()

Total: (3) commits (+15/-11)

 fs/btrfs/extent-tree.c | 10 +++++-----
 fs/btrfs/relocation.c  |  8 +++++---
 fs/btrfs/send.c        |  8 +++++---
 3 files changed, 15 insertions(+), 11 deletions(-)
