Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61164 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757094AbaDKQuF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 12:50:05 -0400
Message-ID: <53481D52.5070608@fb.com>
Date: Fri, 11 Apr 2014 12:50:26 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs part two
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Linus,

Please grab my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

The most important changes here are from Josef, fixing a btrfs
regression in 3.14 that can cause corruptions in the extent allocation
tree when snapshots are in use.  Josef also fixed some deadlocks in
send/recv and other assorted races when balance is running.

Josef Bacik (6) commits (+147/-228):
    Btrfs: hold the commit_root_sem when getting the commit root during send (+39/-16)
    Btrfs: abort the transaction when we don't find our extent ref (+2/-0)
    Btrfs: do not reset last_snapshot after relocation (+0/-21)
    Btrfs: don't clear uptodate if the eb is under IO (+27/-3)
    Btrfs: check for an extent_op on the locked ref (+2/-1)
    Btrfs: remove transaction from send (+77/-187)

Wang Shilong (5) commits (+122/-24):
    Btrfs: fix compile warnings on on avr32 platform (+1/-1)
    Btrfs: fix unlock in __start_delalloc_inodes() (+3/-2)
    Btrfs: scrub raid56 stripes in the right way (+89/-19)
    Btrfs: don't compress for a small write (+8/-0)
    Btrfs: fix snapshot vs nocow writting (+21/-2)

Filipe Manana (3) commits (+11/-5):
    Btrfs: send, fix data corruption due to incorrect hole detection (+3/-1)
    Btrfs: more efficient io tree navigation on wait_extent_bit (+5/-1)
    Btrfs: send, build path string only once in send_hole (+3/-3)

David Sterba (2) commits (+52/-12):
    btrfs: export global block reserve size as space_info (+28/-1)
    btrfs: make device scan less noisy (+24/-11)

Sergei Trofimovich (1) commits (+2/-0):
    btrfs: fix crash in remount(thread_pool=) case

Jeff Mahoney (1) commits (+7/-3):
    btrfs: fix lockdep warning with reclaim lock inversion

Gui Hecheng (1) commits (+3/-2):
    btrfs: filter invalid arg for btrfs resize

Harald Hoyer (1) commits (+22/-0):
    btrfs: allow mounting btrfs subvolumes with different ro/rw options

Chris Mason (1) commits (+3/-2):
    Btrfs: fix EINVAL checks in btrfs_clone

Qu Wenruo (1) commits (+4/-1):
    btrfs: Change the expanding write sequence to fix snapshot related bug.

Dan Carpenter (1) commits (+2/-3):
    Btrfs: kmalloc() doesn't return an ERR_PTR

Total: (23) commits

 fs/btrfs/async-thread.c |   2 +
 fs/btrfs/backref.c      |  33 +++++++++++---
 fs/btrfs/ctree.c        |  94 +++-----------------------------------
 fs/btrfs/ctree.h        |  13 ++++--
 fs/btrfs/disk-io.c      |  23 ++++++++--
 fs/btrfs/extent-tree.c  |  35 +++++++++------
 fs/btrfs/extent_io.c    |   8 +++-
 fs/btrfs/extent_io.h    |   1 +
 fs/btrfs/file.c         |   5 ++-
 fs/btrfs/inode-map.c    |  14 +++---
 fs/btrfs/inode.c        |  36 +++++++++++++--
 fs/btrfs/ioctl.c        |  35 ++++++++++++---
 fs/btrfs/relocation.c   |  21 ---------
 fs/btrfs/scrub.c        | 108 ++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/send.c         | 117 +++++++++++++++++-------------------------------
 fs/btrfs/super.c        |  22 +++++++++
 fs/btrfs/transaction.c  |  48 ++++++++++++--------
 fs/btrfs/transaction.h  |   3 ++
 fs/btrfs/volumes.c      |  35 ++++++++++-----
 19 files changed, 374 insertions(+), 279 deletions(-)
