Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51579 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbcAVQed (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 11:34:33 -0500
Date: Fri, 22 Jan 2016 11:34:29 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Message-ID: <20160122163429.x3zjvuogf6f5ros5@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Please pull my for-linus-4.5 branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.5

These are mostly fixes that we've been testing, but also we grabbed and
tested a few small cleanups that had been on the list for a while.

Zhao Lei's patchset also fixes some early ENOSPC buglets.

Zhao Lei (10) commits (+85/-115):
    btrfs: Use direct way to determine raid56 write/recover mode (+2/-1)
    btrfs: Fix calculation of rbio->dbitmap's size calculation (+3/-3)
    btrfs: Remove unnecessary ClearPageUptodate for raid56 (+0/-2)
    btrfs: delete unused argument in btrfs_copy_from_user (+2/-4)
    btrfs: Use unified stripe_page's index calculation (+21/-22)
    btrfs: merge functions for wait snapshot creation (+22/-21)
    btrfs: use rbio->nr_pages to reduce calculation (+7/-12)
    btrfs: Small cleanup for get index_srcdev loop (+20/-22)
    btrfs: raid56: Use raid_write_end_io for scrub (+5/-27)
    btrfs: Fix no_space in write and rm loop (+3/-1)

Filipe Manana (2) commits (+11/-9):
    Btrfs: fix deadlock running delayed iputs at transaction commit time (+10/-8)
    Btrfs: fix typo in log message when starting a balance (+1/-1)

Qu Wenruo (2) commits (+80/-50):
    btrfs: Enhance super validation check (+48/-49)
    btrfs: Enhance chunk validation check (+32/-1)

Jeff Mahoney (1) commits (+25/-17):
    btrfs: cleanup, stop casting for extent_map->lookup everywhere

Colin Ian King (1) commits (+1/-1):
    btrfs: remove duplicate const specifier

Dan Carpenter (1) commits (+1/-1):
    Btrfs: clean up an error code in btrfs_init_space_info()

Geliang Tang (1) commits (+5/-5):
    btrfs: fix iterator with update error in backref.c

Chandan Rajendra (1) commits (+33/-8):
    Btrfs: Initialize btrfs_root->highest_objectid when loading tree root and subvolume roots

Tsutomu Itoh (1) commits (+22/-7):
    Btrfs: fix output of compression message in btrfs_parse_options()

Sebastian Andrzej Siewior (1) commits (+1/-0):
    btrfs: initialize the seq counter in struct btrfs_device

Total: (21) commits (+264/-213)

 fs/btrfs/backref.c     |  10 ++--
 fs/btrfs/ctree.h       |   3 +-
 fs/btrfs/dev-replace.c |   2 +-
 fs/btrfs/disk-io.c     | 129 ++++++++++++++++++++++++++++++-------------------
 fs/btrfs/extent-tree.c |  37 +++++++++++---
 fs/btrfs/extent_map.c  |   2 +-
 fs/btrfs/extent_map.h  |  10 +++-
 fs/btrfs/file.c        |   6 +--
 fs/btrfs/inode-map.c   |   9 +---
 fs/btrfs/inode-map.h   |   1 +
 fs/btrfs/inode.c       |  24 +--------
 fs/btrfs/ioctl.c       |   4 ++
 fs/btrfs/raid56.c      | 100 ++++++++++++++------------------------
 fs/btrfs/scrub.c       |   4 +-
 fs/btrfs/super.c       |  29 ++++++++---
 fs/btrfs/volumes.c     | 107 +++++++++++++++++++++++++---------------
 16 files changed, 264 insertions(+), 213 deletions(-)
