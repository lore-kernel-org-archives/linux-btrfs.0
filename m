Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24852 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966921AbdIZHlE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 03:41:04 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 0/3] fix bug in btrfs_init_new_device()
Date: Tue, 26 Sep 2017 15:48:40 +0800
Message-Id: <20170926074843.31910-1-anand.jain@oracle.com>
In-Reply-To: <20170925123104.16526-1-anand.jain@oracle.com>
References: <20170925123104.16526-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1/3 fixes a bug which failed to reset writable when sprouting failed
2/3 is cleanup and preparatory to fix 3/3
3/3 fixes BUG_ON in btrfs_init_new_device()

v2:
 add commit log to 1/3
 do not consolidate btrfs_abort_transaction() in 2/3

Anand Jain (3):
  btrfs: undo writable when sprouting fails
  btrfs: cleanup btrfs_init_new_device()
  btrfs: fix BUG_ON in btrfs_init_new_device()

 fs/btrfs/volumes.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

-- 
2.13.1

