Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39621 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936976AbdIZIdx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 04:33:53 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 0/2] fix bug in btrfs_init_new_device()
Date: Tue, 26 Sep 2017 16:41:33 +0800
Message-Id: <20170926084135.3189-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1/2 fixes a bug which failed to reset writable when sprouting failed
2/2 fixes BUG_ON in btrfs_init_new_device()

Anand Jain (2):
  btrfs: undo writable when sprouting fails
  btrfs: fix BUG_ON in btrfs_init_new_device()

 fs/btrfs/volumes.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

-- 
2.13.1

