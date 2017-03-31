Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53399 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753033AbdCaVGH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 17:06:07 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
From: Chris Mason <clm@fb.com>
Message-ID: <0e0a392d-6afa-ad0d-4f78-86ee9b95a75a@fb.com>
Date: Fri, 31 Mar 2017 17:05:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

We have 3 small fixes queued up in my for-linus-4.11 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.11

Goldwyn Rodrigues (1) commits (+7/-7):
    btrfs: Change qgroup_meta_rsv to 64bit

Dan Carpenter (1) commits (+6/-1):
    Btrfs: fix an integer overflow check

Liu Bo (1) commits (+31/-21):
    Btrfs: bring back repair during read

Total: (3) commits (+44/-29)

 fs/btrfs/ctree.h     |  2 +-
 fs/btrfs/disk-io.c   |  2 +-
 fs/btrfs/extent_io.c | 46 ++++++++++++++++++++++++++++------------------
 fs/btrfs/inode.c     |  6 +++---
 fs/btrfs/qgroup.c    | 10 +++++-----
 fs/btrfs/send.c      |  7 ++++++-
 6 files changed, 44 insertions(+), 29 deletions(-)
