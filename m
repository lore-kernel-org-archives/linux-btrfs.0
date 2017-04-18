Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37191 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755800AbdDRBRz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 21:17:55 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v3I1Hs6L027555
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 01:17:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v3I1Hsbm026034
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 01:17:54 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v3I1HqAs002924
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 01:17:53 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6 RFC] utilize bio_clone_fast to clean up
Date: Mon, 17 Apr 2017 18:16:21 -0700
Message-Id: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This attempts to use bio_clone_fast() in the places where we clone bio,
such as when bio got cloned for multiple disks and when bio got split
during dio submit.

One benefit is to simplify dio submit to avoid calling bio_add_page one by
one.

Another benefit is that comparing to bio_clone_bioset, bio_clone_fast is
faster because of copying the vector pointer directly, and bio_clone_fast
doesn't modify bi_vcnt, so the extra work is to fix up bi_vcnt usage we
currently have to use bi_iter to iterate bvec.

Liu Bo (6):
  Btrfs: use bio_clone_fast to clone our bio
  Btrfs: use bio_clone_bioset_partial to simplify DIO submit
  Btrfs: change how we iterate bios in endio
  Btrfs: record error if one block has failed to retry
  Btrfs: change check-integrity to use bvec_iter
  Btrfs: unify naming of btrfs_io_bio

 fs/btrfs/check-integrity.c |  27 +++---
 fs/btrfs/extent_io.c       |  18 +++-
 fs/btrfs/extent_io.h       |   1 +
 fs/btrfs/file-item.c       |  31 ++++---
 fs/btrfs/inode.c           | 203 ++++++++++++++++++++-------------------------
 fs/btrfs/volumes.h         |   1 +
 6 files changed, 138 insertions(+), 143 deletions(-)

-- 
2.5.5

