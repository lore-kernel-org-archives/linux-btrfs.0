Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50576 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751304AbaHOR0p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Aug 2014 13:26:45 -0400
Message-ID: <53EE42A9.7000607@fb.com>
Date: Fri, 15 Aug 2014 13:26:01 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Smaller btrfs pull
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

I reworked my trees to remove the cleanups and a few of the fixes that
were doing larger surgery.  This cut the pull in half, and I've pushed
it out to my integration branch.

Almost all of them are fit for an rc2 or rc3, so I've shelved most of it
for later.  I'll go through again and rip a few more of them out for
the next merge window.

I also rebased and retested 9 of these that I'd like to see in
sooner.  They are all fixes I'd like to get out to a broader audience.

The biggest of the bunch is Mark's quota fix, which is also in the SUSE
kernel, and makes our subvolume quotas dramatically more accurate.

I've been running xfstests with these against your current git
overnight, but I'm queueing up longer tests as well.  I understand
you may want to wait until rc2, but either way I'll get a sane queue
into my linux-next branch for the rest of the rcs.

These are all in my for-linus2 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus2

Chris Mason (1) commits (+6/-267):
    btrfs: disable strict file flushes for renames and truncates

David Sterba (1) commits (+45/-6):
    btrfs: adjust statfs calculations according to raid profiles

Filipe Manana (2) commits (+4/-1):
    Btrfs: fix csum tree corruption, duplicate and outdated checksums
    Btrfs: read lock extent buffer while walking backrefs

Josef Bacik (1) commits (+23/-25):
    Btrfs: __btrfs_mod_ref should always use no_quota

Liu Bo (1) commits (+12/-0):
    Btrfs: fix compressed write corruption on enospc

Mark Fasheh (2) commits (+435/-4):
    btrfs: qgroup: account shared subtrees during snapshot delete
    btrfs: correctly handle return from ulist_add

Takashi Iwai (1) commits (+20/-6):
    Btrfs: Fix memory corruption by ulist_add_merge() on 32bit arch

Total: (9) commits

 fs/btrfs/backref.c      |  14 ++-
 fs/btrfs/btrfs_inode.h  |   6 -
 fs/btrfs/ctree.c        |  20 ++--
 fs/btrfs/ctree.h        |   4 +-
 fs/btrfs/disk-io.c      |  32 ------
 fs/btrfs/extent-tree.c  | 285 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/file-item.c    |   2 +-
 fs/btrfs/file.c         |  26 +----
 fs/btrfs/inode.c        |  59 +++-------
 fs/btrfs/ordered-data.c | 123 ---------------------
 fs/btrfs/ordered-data.h |   5 -
 fs/btrfs/qgroup.c       | 169 ++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h       |   1 +
 fs/btrfs/super.c        |  51 ++++++++-
 fs/btrfs/transaction.c  |  33 +-----
 fs/btrfs/transaction.h  |   1 -
 fs/btrfs/ulist.h        |  15 +++
 17 files changed, 541 insertions(+), 305 deletions(-)
