Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26529 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932193AbaFTPs2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 11:48:28 -0400
Message-ID: <53A45909.50506@fb.com>
Date: Fri, 20 Jun 2014 11:53:45 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This fixes some lockups in btrfs reported with rc1.  It probably has
some performance impact because it is backing off our spinning locks
more often and switching to a blocking lock.  I'll be able to nail that
down next week, but for now I want to get the lockups taken care of.

Otherwise some more stack reduction and assorted fixes.

Miao Xie (5) commits (+304/-126):
    Btrfs: fix wrong error handle when the device is missing or is not writeable (+15/-7)
    Btrfs: make free space cache write out functions more readable (+93/-66)
    Btrfs: fix broken free space cache after the system crashed (+186/-44)
    Btrfs: fix deadlock when mounting a degraded fs (+9/-1)
    Btrfs: use bio_endio_nodec instead of open code (+1/-8)

Chris Mason (1) commits (+46/-34):
    Btrfs: fix deadlocks with trylock on tree nodes

Wang Shilong (1) commits (+6/-7):
    Btrfs: fix NULL pointer crash when running balance and scrub concurrently

Filipe Manana (1) commits (+0/-1):
    Btrfs: remove unused wait queue in struct extent_buffer

Qu Wenruo (1) commits (+9/-10):
    btrfs: Skip scrubbing removed chunks to avoid -ENOENT.

Total: (9) commits (+365/-178)

 fs/btrfs/ctree.h            |  13 ++-
 fs/btrfs/extent-tree.c      | 143 ++++++++++++++++++++++++++-------
 fs/btrfs/extent_io.h        |   1 -
 fs/btrfs/extent_map.c       |   2 +
 fs/btrfs/extent_map.h       |   1 +
 fs/btrfs/free-space-cache.c | 192 +++++++++++++++++++++++++++++---------------
 fs/btrfs/inode.c            |  41 +++++++---
 fs/btrfs/locking.c          |  80 ++++++++++--------
 fs/btrfs/scrub.c            |  19 +++--
 fs/btrfs/volumes.c          |  36 +++++----
 fs/btrfs/volumes.h          |   3 +
 11 files changed, 359 insertions(+), 172 deletions(-)
