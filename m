Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41423 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751811AbdLAJTw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Dec 2017 04:19:52 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E19A2AD17
        for <linux-btrfs@vger.kernel.org>; Fri,  1 Dec 2017 09:19:50 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/5] Misc cleanups
Date: Fri,  1 Dec 2017 11:19:39 +0200
Message-Id: <1512119984-12708-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here's a bunch of stuff that coverity found, this survived a full xfstest run.

Nikolay Borisov (5):
  btrfs: Remove dead code
  btrfs: Remove dead code
  btrfs: Fix possible off-by-one in  btrfs_search_path_in_tree
  btrfs: Remove redundant NULL check
  btrfs: Greatly simplify btrfs_read_dev_super

 fs/btrfs/disk-io.c | 27 ++++-----------------------
 fs/btrfs/inode.c   | 12 ++----------
 fs/btrfs/ioctl.c   |  6 +++---
 fs/btrfs/sysfs.c   |  2 --
 4 files changed, 9 insertions(+), 38 deletions(-)

-- 
2.7.4

