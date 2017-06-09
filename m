Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44369 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbdFIGqW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jun 2017 02:46:22 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/2] cleanup write_dev_flush()
Date: Fri,  9 Jun 2017 14:52:27 +0800
Message-Id: <20170609065229.8188-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit
 9035b5dbc576 btrfs: btrfs_io_bio_alloc never fails, skip error handling

has removed ENOMEM in write_dev_flush() so the below two patches
adds its related cleanups.

This patch is on top of
 git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
But without the namelen-check patches, the last commit is
 30426258414b btrfs: pass bytes to btrfs_bio_alloc

Anand Jain (2):
  btrfs: write_dev_flush does not return ENOMEM anymore
  btrfs: flush error also accounts for its send error

 fs/btrfs/disk-io.c | 99 +++++++++++++++++++-----------------------------------
 1 file changed, 35 insertions(+), 64 deletions(-)

-- 
2.8.3

