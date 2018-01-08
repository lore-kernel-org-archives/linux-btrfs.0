Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46150 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756343AbeAHJpP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 04:45:15 -0500
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/2] Remove custom crc32c init code from btrfs 
Date: Mon,  8 Jan 2018 11:45:03 +0200
Message-Id: <1515404705-490-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So here is a small 2 patch set which removes btrfs' manual initialisation of 
the lower level crc32c module. Explanation why is ok can be found in Patch 2/2.

Patch 1/2 just adds a function to the generic crc32c header which allows 
querying the actual crc32c implementaiton used (i.e. software or hw-accelerated)
to retain current btrfs behavior. This is mainly used for debugging purposes 
and is independent. 

Nikolay Borisov (2):
  libcrc32c: Add crc32c_impl function
  btrfs: Remove custom crc32c init code

 fs/btrfs/Kconfig           |  3 +--
 fs/btrfs/Makefile          |  2 +-
 fs/btrfs/check-integrity.c |  4 ++--
 fs/btrfs/ctree.h           | 16 ++++++++++++++
 fs/btrfs/dir-item.c        |  1 -
 fs/btrfs/disk-io.c         |  4 ++--
 fs/btrfs/extent-tree.c     | 10 ++++-----
 fs/btrfs/hash.c            | 54 ----------------------------------------------
 fs/btrfs/hash.h            | 43 ------------------------------------
 fs/btrfs/inode-item.c      |  1 -
 fs/btrfs/inode.c           |  1 -
 fs/btrfs/props.c           |  2 +-
 fs/btrfs/send.c            |  4 ++--
 fs/btrfs/super.c           | 14 ++++--------
 fs/btrfs/tree-log.c        |  2 +-
 include/linux/crc32c.h     |  1 +
 lib/libcrc32c.c            |  6 ++++++
 17 files changed, 42 insertions(+), 126 deletions(-)
 delete mode 100644 fs/btrfs/hash.c
 delete mode 100644 fs/btrfs/hash.h

-- 
2.7.4

