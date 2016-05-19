Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:34534 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326AbcESXNN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 19:13:13 -0400
Received: by mail-qk0-f174.google.com with SMTP id y126so22180533qke.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 16:13:12 -0700 (PDT)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nicholas D Steeves <nsteeves@gmail.com>
Subject: [PATCH 0/1] String and comment review: Fix typos; fix a couple of mandatory grammatical issues for clarity.
Date: Thu, 19 May 2016 19:13:00 -0400
Message-Id: <1463699581-12416-1-git-send-email-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

I took a look at what you merged and what you didn't for my review of btrfs-progs, and revised my approach accordingly.  There are six edits that require your review.  Please search/grep for "Steeves" to find them.

Cheers!
Nicholas

Nicholas D Steeves (1):
  String and comment review: Fix typos; fix a couple of mandatory
    grammatical issues for clarity.

 fs/btrfs/backref.c                |  2 +-
 fs/btrfs/btrfs_inode.h            |  2 +-
 fs/btrfs/check-integrity.c        |  2 +-
 fs/btrfs/ctree.c                  | 14 +++++++-------
 fs/btrfs/ctree.h                  | 10 +++++-----
 fs/btrfs/delayed-ref.h            |  2 +-
 fs/btrfs/dev-replace.c            |  2 +-
 fs/btrfs/disk-io.c                | 10 +++++-----
 fs/btrfs/extent-tree.c            | 34 +++++++++++++++++-----------------
 fs/btrfs/extent_io.c              |  4 ++--
 fs/btrfs/extent_map.c             |  2 +-
 fs/btrfs/file.c                   |  4 ++--
 fs/btrfs/free-space-cache.c       |  2 +-
 fs/btrfs/free-space-cache.h       |  2 +-
 fs/btrfs/inode.c                  | 22 +++++++++++-----------
 fs/btrfs/ioctl.c                  | 10 +++++-----
 fs/btrfs/ordered-data.h           |  2 +-
 fs/btrfs/qgroup.c                 | 16 ++++++++--------
 fs/btrfs/raid56.c                 |  6 +++---
 fs/btrfs/relocation.c             | 12 ++++++------
 fs/btrfs/root-tree.c              |  4 ++--
 fs/btrfs/scrub.c                  |  4 ++--
 fs/btrfs/send.c                   |  6 +++---
 fs/btrfs/struct-funcs.c           |  2 +-
 fs/btrfs/super.c                  | 10 +++++-----
 fs/btrfs/sysfs.c                  |  2 +-
 fs/btrfs/tests/extent-io-tests.c  |  2 +-
 fs/btrfs/tests/free-space-tests.c |  7 ++++---
 fs/btrfs/tests/inode-tests.c      |  2 +-
 fs/btrfs/tests/qgroup-tests.c     |  2 +-
 fs/btrfs/transaction.h            |  2 +-
 fs/btrfs/tree-log.c               |  8 ++++----
 fs/btrfs/ulist.c                  |  2 +-
 fs/btrfs/volumes.c                |  8 ++++----
 34 files changed, 111 insertions(+), 110 deletions(-)

-- 
2.1.4

