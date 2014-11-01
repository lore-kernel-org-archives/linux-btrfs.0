Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32719 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981AbaKAQFK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 1 Nov 2014 12:05:10 -0400
Message-ID: <545504B1.9050408@fb.com>
Date: Sat, 1 Nov 2014 12:05:05 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Linus,

We have a few fixes in my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Filipe is nailing down some problems with our skinny extent variation,
and Dave's patch fixes endian problems in the new super block checks.

Filipe Manana (2) commits (+4/-18):
    Btrfs: fix race that makes btrfs_lookup_extent_info miss skinny extent items (+0/-8)
    Btrfs: fix invalid leaf slot access in btrfs_lookup_extent() (+4/-10)

Josef Bacik (1) commits (+1/-0):
    Btrfs: properly clean up btrfs_end_io_wq_cache

David Sterba (1) commits (+22/-21):
    btrfs: use macro accessors in superblock validation checks

Total: (4) commits (+27/-39)

 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/disk-io.c     | 43 ++++++++++++++++++++++---------------------
 fs/btrfs/extent-tree.c | 18 ++----------------
 fs/btrfs/super.c       |  1 +
 fs/btrfs/tree-log.c    |  2 +-
 5 files changed, 27 insertions(+), 39 deletions(-)
