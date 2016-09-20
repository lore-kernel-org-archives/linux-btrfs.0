Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45363 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753873AbcITOFH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 10:05:07 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6C771AAC7
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 14:05:05 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/5] btrfs: printing cleanup patchset
Date: Tue, 20 Sep 2016 10:04:58 -0400
Message-Id: <1474380303-25995-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

This is a patchset I've been working on to clean up message printing,
make it adhere to kernel style, and be more consistent.

The end result is that we:
* use dynamic debugging for debugging messages
* merge strings that exceed 80 characters into a single greppable string
* convert printk calls to btrfs_{warn,info,err,debug,etc} calls where it
  makes sense.
* dump the ad-hoc verbose_printk garbage in send

The exception to this is check-integrity since it has a ton of messages
and it also has its own mask mechanism.  I wanted to discuss if we wanted
to find another solution to that and, if so, how we want to move forward
there.

Dave, this will probably conflict with the fsinfo patchset, so please
advise on which you want to land first.

-Jeff

Jeff Mahoney (5):
  btrfs: add dynamic debug support
  btrfs: unsplit printed strings
  btrfs: convert printk(KERN_* to use pr_* calls
  btrfs: convert pr_* to btrfs_* where possible
  btrfs: convert send's verbose_printk to btrfs_debug

 fs/btrfs/backref.c          |  48 ++++---
 fs/btrfs/check-integrity.c  | 335 ++++++++++++++------------------------------
 fs/btrfs/compression.c      |   6 +-
 fs/btrfs/ctree.c            |  12 +-
 fs/btrfs/ctree.h            |  39 +++++-
 fs/btrfs/delayed-inode.c    |  17 +--
 fs/btrfs/delayed-ref.c      |   9 +-
 fs/btrfs/dev-replace.c      |  21 +--
 fs/btrfs/dir-item.c         |   7 +-
 fs/btrfs/disk-io.c          |  98 ++++++-------
 fs/btrfs/extent-tree.c      | 106 +++++++-------
 fs/btrfs/extent_io.c        |  93 ++++++------
 fs/btrfs/free-space-cache.c |  21 +--
 fs/btrfs/free-space-cache.h |   6 +-
 fs/btrfs/free-space-tree.c  |  14 +-
 fs/btrfs/inode-map.c        |  31 ++--
 fs/btrfs/inode.c            |  26 ++--
 fs/btrfs/ioctl.c            |  14 +-
 fs/btrfs/lzo.c              |   6 +-
 fs/btrfs/ordered-data.c     |   4 +-
 fs/btrfs/print-tree.c       |  86 +++++-------
 fs/btrfs/qgroup.c           |  22 +--
 fs/btrfs/reada.c            |  32 ++---
 fs/btrfs/relocation.c       |  16 ++-
 fs/btrfs/root-tree.c        |  18 +--
 fs/btrfs/scrub.c            |  58 ++++----
 fs/btrfs/send.c             |  71 +++++-----
 fs/btrfs/super.c            |  60 ++++----
 fs/btrfs/sysfs.c            |   8 +-
 fs/btrfs/transaction.c      |  20 +--
 fs/btrfs/transaction.h      |   1 +
 fs/btrfs/tree-log.c         |   8 +-
 fs/btrfs/uuid-tree.c        |  27 ++--
 fs/btrfs/volumes.c          | 131 +++++++++--------
 fs/btrfs/volumes.h          |   2 +-
 fs/btrfs/zlib.c             |   8 +-
 36 files changed, 719 insertions(+), 762 deletions(-)

-- 
2.7.1

