Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22683 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751338AbdEPJdd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 05:33:33 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [RFC PATCH 0/2] Introduce blkdev_issue_flush_no_wait()
Date: Tue, 16 May 2017 17:39:12 +0800
Message-Id: <20170516093914.16035-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTRFS wanted a block device flush function which does not wait for
its completion, so that the flush for the next device can be called
in the same thread.

Here is a RFC patch to provide the function
'blkdev_issue_flush_no_wait()', which is based on the current device
flush function 'blkdev_issue_flush()', however it uses submit_bio()
instead of submit_bio_wait().

This patch is for review comments, will send out a final patch based
on the comments received.

Thanks, Anand

Anand Jain (2):
  block: Introduce blkdev_issue_flush_no_wait()
  btrfs: Use blkdev_issue_flush_no_wait()

 block/blk-flush.c      |  47 +++++++++++++++++++++
 fs/btrfs/disk-io.c     | 108 +++++++++++++++----------------------------------
 fs/btrfs/volumes.h     |   2 +-
 include/linux/blkdev.h |   8 ++++
 4 files changed, 88 insertions(+), 77 deletions(-)

-- 
2.10.0

