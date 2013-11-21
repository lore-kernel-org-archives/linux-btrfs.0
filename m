Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:51141 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3KUSfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 13:35:25 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 080EE9A06B0
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Nov 2013 11:35:25 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Message-ID: <20131121183508.5312.64818@localhost.localdomain>
From: Chris Mason <chris.mason@fusionio.com>
Subject: [GIT PULL] Btrfs
Date: Thu, 21 Nov 2013 13:35:08 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

You'll notice the last two commits were recently rebased, these were
just fixing a typo in the new documentation.

Almost all of these are bug fixes.  Dave Sterba's documentation update
is the big exception because he removed our promises to set any machine
running Btrfs on fire.

Ilya Dryomov (3) commits (+13/-5):
    Btrfs: do not inc uncorrectable_errors counter on ro scrubs (+4/-2)
    Btrfs: disable online raid-repair on ro mounts (+8/-3)
    Btrfs: fix __btrfs_start_workers retval (+1/-0)

Josef Bacik (3) commits (+5/-3):
    Btrfs: only drop modified extents if we logged the whole inode (+1/-1)
    Btrfs: don't BUG_ON() if we get an error walking backrefs (+2/-1)
    Btrfs: make sure to copy everything if we rename (+2/-1)

David Sterba (3) commits (+27/-22):
    Documentation: filesystems: add new btrfs mount options (+11/-1)
    Documentation: filesystems: update btrfs tools section (+6/-16)
    btrfs: update kconfig help text (+10/-5)

Liu Bo (2) commits (+3/-22):
    Btrfs: avoid heavy operations in btrfs_commit_super (+1/-20)
    Btrfs: fix lockdep error in async commit (+2/-2)

Stefan Behrens (1) commits (+17/-8):
    Btrfs: print bytenr instead of page pointer in check-int

Anand Jain (1) commits (+1/-1):
    btrfs: fix typo in the log message

Filipe David Borba Manana (1) commits (+1/-1):
    Btrfs: don't wait for ordered data outside desired range

Wang Shilong (1) commits (+0/-6):
    Btrfs: remove dead codes from ctree.h

Akinobu Mita (1) commits (+1/-1):
    btrfs: fix bio_size_ok() for max_sectors > 0xffff

Miao Xie (1) commits (+1/-0):
    Btrfs: fix list delete warning when removing ordered root from the list

Steven Rostedt (1) commits (+4/-3):
    btrfs: Use trace condition for get_extent tracepoint

Total: (18) commits (+73/-72)

 Documentation/filesystems/btrfs.txt | 34 +++++++++++++++++-----------------
 fs/btrfs/Kconfig                    | 15 ++++++++++-----
 fs/btrfs/async-thread.c             |  1 +
 fs/btrfs/check-integrity.c          | 25 +++++++++++++++++--------
 fs/btrfs/ctree.h                    |  6 ------
 fs/btrfs/dev-replace.c              |  2 +-
 fs/btrfs/disk-io.c                  | 21 +--------------------
 fs/btrfs/extent_io.c                | 11 ++++++++---
 fs/btrfs/inode.c                    |  6 +++---
 fs/btrfs/ordered-data.c             |  3 ++-
 fs/btrfs/scrub.c                    |  6 ++++--
 fs/btrfs/transaction.c              |  4 ++--
 fs/btrfs/tree-log.c                 |  5 +++--
 fs/btrfs/volumes.c                  |  2 +-
 include/trace/events/btrfs.h        |  4 +++-
 15 files changed, 73 insertions(+), 72 deletions(-)
