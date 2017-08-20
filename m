Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:62030 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753191AbdHTUQl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Aug 2017 16:16:41 -0400
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/4] BTRFS: Adjustments for several function implementations
Message-ID: <360126ba-e45b-0a8d-57b6-83764c4c2bce@users.sourceforge.net>
Date: Sun, 20 Aug 2017 22:16:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 20 Aug 2017 22:11:33 +0200

Some update suggestions were taken into account
from static source code analysis.

Markus Elfring (4):
  Delete an error message for a failed memory allocation in btrfsic_process_superblock()
  Adjust 32 checks for null pointers
  Improve eight size determinations
  Delete an unnecessary variable initialisation in tree_mod_log_eb_copy()

 fs/btrfs/check-integrity.c |  4 +---
 fs/btrfs/ctree.c           | 16 +++++++---------
 fs/btrfs/delayed-inode.c   |  4 ++--
 fs/btrfs/extent-tree.c     |  2 +-
 fs/btrfs/extent_io.c       |  2 +-
 fs/btrfs/inode.c           |  4 ++--
 fs/btrfs/lzo.c             |  4 ++--
 fs/btrfs/qgroup.c          |  6 +++---
 fs/btrfs/raid56.c          |  2 +-
 fs/btrfs/reada.c           |  4 ++--
 fs/btrfs/scrub.c           | 12 ++++++------
 fs/btrfs/super.c           |  2 +-
 fs/btrfs/transaction.c     |  2 +-
 fs/btrfs/tree-log.c        |  4 ++--
 fs/btrfs/volumes.c         | 14 +++++++-------
 fs/btrfs/xattr.c           |  2 +-
 fs/btrfs/zlib.c            |  4 ++--
 17 files changed, 42 insertions(+), 46 deletions(-)

-- 
2.14.0

