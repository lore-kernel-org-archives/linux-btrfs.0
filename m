Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44269 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751401AbdKVBiU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 20:38:20 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAM1cJcc022095
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAM1cJmW014907
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:19 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAM1cJHa029437
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:19 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/7] retry write on error
Date: Tue, 21 Nov 2017 17:35:51 -0700
Message-Id: <20171122003558.28722-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the underlying protocal doesn't support retry and there are some
transient errors happening somewhere in our IO stack, we'd like to
give an extra chance for IO.  Or sometimes you see btrfs reporting
'wrr 1 flush 0 read 0 blabla' but the disk drive is 100% good, this
retry may help a bit.

In btrfs, read retry is handled in bio_readpage_error() with the retry
unit being page size, for write retry however, we're going to do it in
a different way, as a write may consist of several writes onto
different stripes, retry write needs to be done right after the IO on
each stripe completes and arrives at endio.

Patch 1-3 are the implementation of retry write on error for
non-raid56 profile.  Patch 4-6 are for raid56 profile.  Both raid56
and non-raid56 shares one retry function helper.

Patch 3 does retry sector by sector, but since this patch set doesn't
included badblocks support, patch 7 changes it back to retry the whole
bio.  (I didn't fold patch 7 to patch 3 in the hope of just reverting
patch 7 once badblocks support is done, but I'm open to it.)

Liu Bo (7):
  Btrfs: keep a copy of bi_iter in btrfs_io_bio
  Btrfs: add helper __btrfs_end_bio
  Btrfs: retry write for non-raid56
  Btrfs: get rbio inside fail_bio_stripe
  Btrfs: add helper __raid_write_end_io
  Btrfs: retry write for raid56
  Btrfs: retry the whole bio on write error

 fs/btrfs/extent_io.c |   2 -
 fs/btrfs/raid56.c    |  73 ++++++++++++++++++++++------
 fs/btrfs/volumes.c   | 133 ++++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/volumes.h   |   3 ++
 4 files changed, 167 insertions(+), 44 deletions(-)

-- 
2.9.4

