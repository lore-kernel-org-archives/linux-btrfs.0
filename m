Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38407 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752328AbeCNPDV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 11:03:21 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A2333AE0C
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Mar 2018 15:03:20 +0000 (UTC)
From: Edmund Nadolski <enadolski@suse.com>
To: enadolski@suse.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] missing initialization in btrfs_check_shared
Date: Wed, 14 Mar 2018 09:03:10 -0600
Message-Id: <20180314150311.20152-1-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch addresses an issue that causes fiemap to falsely
report a shared extent.  The test case is as follows:

# cat do_xfs_io
xfs_io -f -d -c "pwrite -b 16k 0 64k" -c "fiemap -v" /media/scratch/file5
sync
xfs_io  -c "fiemap -v" /media/scratch/file5

which gives the resulting output:

# . do_xfs_io
wrote 65536/65536 bytes at offset 0
64 KiB, 4 ops; 0.0000 sec (121.359 MiB/sec and 7766.9903 ops/sec)
/media/scratch/file5:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        24576..24703       128 0x2001
/media/scratch/file5:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        24576..24703       128   0x1

This is because btrfs_check_shared calls find_parent_nodes
repeatedly in a loop, passing a share_check struct to report
the count of shared extent. But btrfs_check_shared does not
re-initialize the count value to zero for subsequent calls
from the loop, resulting in a false share count value. This
is a regressive behavior from 4.13.

With proper re-initialization the test result is as follows:

# . do_xfs_io
wrote 65536/65536 bytes at offset 0
64 KiB, 4 ops; 0.0000 sec (110.035 MiB/sec and 7042.2535 ops/sec)
/media/scratch/file5:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        24576..24703       128   0x1
/media/scratch/file5:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        24576..24703       128   0x1

which corrects the regression.

Edmund Nadolski (1):
  btrfs: add missing initialization in btrfs_check_shared

 fs/btrfs/backref.c | 1 +
 1 file changed, 1 insertion(+)

-- 
2.10.2

