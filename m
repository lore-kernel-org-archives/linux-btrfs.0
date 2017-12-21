Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57218 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755156AbdLUXpk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Dec 2017 18:45:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBLNfbNF019917
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:39 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2f0ptyg0fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:39 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBLNjcMu006262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:39 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBLNjc6k011260
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Dec 2017 23:45:38 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 00/10] bugfixes and regression tests of btrfs_get_extent
Date: Thu, 21 Dec 2017 15:42:46 -0700
Message-Id: <20171221224256.18196-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although
commit e6c4efd87ab0 ("btrfs: Fix and enhance merge_extent_mapping() to insert best fitted extent map")
fixed up the negetive em->len, it has introduced several regressions, several has been fixed by

commit 32be3a1ac6d0 ("btrfs: Fix the wrong condition judgment about subset extent map"),
commit 8dff9c853410 ("Btrfs: deal with duplciates during extent_map insertion in btrfs_get_extent") and
commit 8e2bd3b7fac9 ("Btrfs: deal with existing encompassing extent map in btrfs_get_extent()").

Unfortunately, there is one more regression which is caught recently in
our test farm, more details are explained in patch 7.

While debugging the above issue, I found that all of these bugs are caused
by some racy situations, which can be very tricky to reproduce, so I made
several extent map specific test cases in btrfs's selftest framework.

Patch 1-2 are some preparatory work.
Patch 3-5 are regression tests for handling EEXIST from adding extent map.
Patch 6-7 are fixing two bugs which can be reproduced by the above test cases.
Patch 8-10 are debugging wise, so that we can know what happened easily.

Liu Bo (10):
  Btrfs: add helper for em merge logic
  Btrfs: move extent map specific code to extent_map.c
  Btrfs: add extent map selftests
  Btrfs: extent map selftest: buffered write vs dio read
  Btrfs: extent map selftest: dio write vs dio read
  Btrfs: fix incorrect block_len in merge_extent_mapping
  Btrfs: fix unexpected EEXIST from btrfs_get_extent
  Btrfs: add WARN_ONCE to detect unexpected error from
    merge_extent_mapping
  Btrfs: add tracepoint for em's EEXIST case
  Btrfs: noinline merge_extent_mapping

 fs/btrfs/Makefile                 |   2 +-
 fs/btrfs/extent_map.c             | 120 +++++++++++++
 fs/btrfs/extent_map.h             |   2 +
 fs/btrfs/inode.c                  | 108 +-----------
 fs/btrfs/tests/btrfs-tests.c      |   3 +
 fs/btrfs/tests/btrfs-tests.h      |   1 +
 fs/btrfs/tests/extent-map-tests.c | 363 ++++++++++++++++++++++++++++++++++++++
 include/trace/events/btrfs.h      |  35 ++++
 8 files changed, 526 insertions(+), 108 deletions(-)
 create mode 100644 fs/btrfs/tests/extent-map-tests.c

-- 
2.9.4

