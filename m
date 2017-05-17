Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39947 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754486AbdEQXXd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 19:23:33 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4HNNWqq013287
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v4HNNVbs023504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:32 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v4HNNT32005997
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:30 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/8 v1] utilize bio_clone_fast to clean up
Date: Wed, 17 May 2017 16:22:44 -0600
Message-Id: <20170517222252.29242-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v1: - Drop the RFC tag.
    - Update to use bio_segments accordingly as __bio_segments is removed.
    - Remove if (!bio) since bio_clone_fast with bioset and GFP_NOFS will
      never fail.

This attempts to use bio_clone_fast() in the places where we clone bio,
such as when bio got cloned for multiple disks and when bio got split
during dio submit.

One benefit is to simplify dio submit to avoid calling bio_add_page one by
one.

Another benefit is that comparing to bio_clone_bioset, bio_clone_fast is
faster because of copying the vector pointer directly, and bio_clone_fast
doesn't modify bi_vcnt, so the extra work is to fix up bi_vcnt usage we
currently have to use bi_iter to iterate bvec.

Here are some numbers collected with the script [1], note that most of
performance tests usually issue bs=4k dio write/read so our directIO split code
is not tested as it requires bs > stripe_len(64K), thus I made this simple
script which writes 2G with bs=128K.

- vanilla:
real    0m10.265s
user    0m0.005s
sys     0m9.164s

- patched:
real    0m8.973s
user    0m0.006s
sys     0m7.804s

[1]:
#!/bin/bash

M=/mnt/btrfs
D1=/dev/pmem0p1
D2=/dev/pmem0p2

umount $M
mkfs.btrfs -f $D1 $D2 >/dev/null || exit

mount $D1 $M -onodatasum || exit

xfs_io -f -c "falloc 0 2G" $M/foo

time xfs_io -d -c "pwrite -b 128K 0 2G" $M/foo

Liu Bo (8):
  Btrfs: use bio_clone_fast to clone our bio
  Btrfs: new helper btrfs_bio_clone_partial
  Btrfs: use bio_clone_bioset_partial to simplify DIO submit
  Btrfs: change how we iterate bios in endio
  Btrfs: record error if one block has failed to retry
  Btrfs: make check-integrity use bvec_iter
  Btrfs: unify naming of btrfs_io_bio
  Btrfs: hardcode GFP_NOFS for btrfs_bio_clone_partial

 fs/btrfs/check-integrity.c |  27 +++---
 fs/btrfs/extent_io.c       |  20 ++++-
 fs/btrfs/extent_io.h       |   1 +
 fs/btrfs/file-item.c       |  31 ++++---
 fs/btrfs/inode.c           | 204 ++++++++++++++++++++-------------------------
 fs/btrfs/volumes.h         |   1 +
 6 files changed, 142 insertions(+), 142 deletions(-)

-- 
2.9.4

