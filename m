Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52674 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751943AbdI0Ksw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 06:48:52 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7AEE6AABA
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Sep 2017 10:48:51 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/3] Few transaction semantic fixes 
Date: Wed, 27 Sep 2017 13:48:44 +0300
Message-Id: <1506509327-18862-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While looking at the transaction code and various pattern I came across some
problems which this series aim to fix. 

Patch 1 just removes some redundant code. 

Patch 2 adds a missing btrfs_abort_transaction, otherwise we don't properly 
close out the transaction. I believe this could lead to btrfs_root_item being 
modified yet we could be missing respective entry in the uuid tree. 

Patch 3 btrfs_rm_dev_item totally missed aborting the transaction in its failure
cases.

Nikolay Borisov (3):
  btrfs: Remove unnecessary btrfs_abort_transaction on transaction
    commit failure
  btrfs: Handle failure to add received uuid to uuid tree in 
  _btrfs_ioctl_set_received_subvol
  btrfs: Fix transaction abort during failure in btrfs_rm_dev_item

 fs/btrfs/ioctl.c   | 9 +--------
 fs/btrfs/volumes.c | 6 ++++--
 2 files changed, 5 insertions(+), 10 deletions(-)

-- 
2.7.4

