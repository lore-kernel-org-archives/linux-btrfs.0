Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60011 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753254AbcJNUbt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 16:31:49 -0400
Date: Fri, 14 Oct 2016 16:31:45 -0400
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20161014203145.xt5lvjjuvs2424pb@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

My for-linus-4.9 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.9

Has some fixes from Omar and Dave Sterba for our new free space tree.
This isn't heavily used yet, but as we move toward making it the new
default we wanted to nail down an endian bug.

Omar Sandoval (5) commits (+259/-145):
    Btrfs: expand free space tree sanity tests to catch endianness bug (+96/-68)
    Btrfs: fix extent buffer bitmap tests on big-endian systems (+51/-36)
    Btrfs: fix free space tree bitmaps on big-endian systems (+76/-27)
    Btrfs: fix mount -o clear_cache,space_cache=v2 (+12/-12)
    Btrfs: catch invalid free space trees (+24/-2)

David Sterba (2) commits (+13/-12):
    btrfs: tests: uninline member definitions in free_space_extent (+2/-1)
    btrfs: tests: constify free space extent specs (+11/-11)

Total: (7) commits (+272/-157)

 fs/btrfs/ctree.h                       |   3 +-
 fs/btrfs/disk-io.c                     |  33 +++---
 fs/btrfs/extent_io.c                   |  64 +++++++----
 fs/btrfs/extent_io.h                   |  22 ++++
 fs/btrfs/free-space-tree.c             |  19 ++--
 fs/btrfs/tests/extent-io-tests.c       |  87 ++++++++-------
 fs/btrfs/tests/free-space-tree-tests.c | 189 +++++++++++++++++++--------------
 include/uapi/linux/btrfs.h             |  12 ++-
 8 files changed, 272 insertions(+), 157 deletions(-)
