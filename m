Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23858 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932656AbdIYMXY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 08:23:24 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/3] fix bug in btrfs_init_new_device()
Date: Mon, 25 Sep 2017 20:31:01 +0800
Message-Id: <20170925123104.16526-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1/3 fixes a bug which failed to reset writable when sprouting failed
2/3 is cleanup and preparatory to fix 3/3
3/3 fixes BUG_ON in btrfs_init_new_device()

Anand Jain (3):
  btrfs: undo writable when sprouting fails
  btrfs: cleanup btrfs_init_new_device()
  btrfs: fix BUG_ON in btrfs_init_new_device()

 fs/btrfs/volumes.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

-- 
2.13.1

