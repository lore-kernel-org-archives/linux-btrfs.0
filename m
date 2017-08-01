Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33462 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751901AbdHARPy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:15:54 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v71HFrTS002118
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFqCo024837
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:53 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v71HFqT7032259
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:52 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
Date: Tue,  1 Aug 2017 10:14:23 -0600
Message-Id: <20170801161439.13426-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This aims to fix write hole issue on btrfs raid5/6 setup by adding a
separate disk as a journal (aka raid5/6 log), so that after unclean
shutdown we can make sure data and parity are consistent on the raid
array by replaying the journal.

The idea and the code are similar to the write-through mode of md
raid5-cache, so ppl(partial parity log) is also feasible to implement.
(If you've been familiar with md, you may find this patch set is
boring to read...)

Patch 1-3 are about adding a log disk, patch 5-8 are the main part of
the implementation, the rest patches are improvements and bugfixes,
eg. readahead for recovery, checksum.

Two btrfs-progs patches are required to play with this patch set, one
is to enhance 'btrfs device add' to add a disk as raid5/6 log with the
option '-L', the other is to teach 'btrfs-show-super' to show
%journal_tail.

This is currently based on 4.12-rc3.

The patch set is tagged with RFC, and comments are always welcome,
thanks.

Known limitations:
- Deleting a log device is not implemented yet.


Liu Bo (14):
  Btrfs: raid56: add raid56 log via add_dev v2 ioctl
  Btrfs: raid56: do not allocate chunk on raid56 log
  Btrfs: raid56: detect raid56 log on mount
  Btrfs: raid56: add verbose debug
  Btrfs: raid56: add stripe log for raid5/6
  Btrfs: raid56: add reclaim support
  Btrfs: raid56: load r5log
  Btrfs: raid56: log recovery
  Btrfs: raid56: add readahead for recovery
  Btrfs: raid56: use the readahead helper to get page
  Btrfs: raid56: add csum support
  Btrfs: raid56: fix error handling while adding a log device
  Btrfs: raid56: initialize raid5/6 log after adding it
  Btrfs: raid56: maintain IO order on raid5/6 log

 fs/btrfs/ctree.h                |   16 +-
 fs/btrfs/disk-io.c              |   16 +
 fs/btrfs/ioctl.c                |   48 +-
 fs/btrfs/raid56.c               | 1429 ++++++++++++++++++++++++++++++++++-----
 fs/btrfs/raid56.h               |   82 +++
 fs/btrfs/transaction.c          |    2 +
 fs/btrfs/volumes.c              |   56 +-
 fs/btrfs/volumes.h              |    7 +-
 include/uapi/linux/btrfs.h      |    3 +
 include/uapi/linux/btrfs_tree.h |    4 +
 10 files changed, 1487 insertions(+), 176 deletions(-)

-- 
2.9.4

