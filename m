Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50424 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753052AbeAFAIk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 19:08:40 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w06076Al071423
        for <linux-btrfs@vger.kernel.org>; Sat, 6 Jan 2018 00:08:39 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2fajbrr55y-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Jan 2018 00:08:39 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w05Ks8BK004942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:54:08 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w05Ks8Lr000469
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 20:54:08 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 00/10] bugfixes and regression tests of btrfs_get_extent
Date: Fri,  5 Jan 2018 12:51:07 -0700
Message-Id: <20180105195117.5131-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although
commit e6c4efd87ab0 ("btrfs: Fix and enhance merge_extent_mapping() to insert best fitted extent map")
fixed up the negetive em->len, it has introduced several regressions, several has been fixed by

commit 32be3a1ac6d0 ("btrfs: Fix the wrong condition judgment about subset extent map"),
commit 8dff9c853410 ("Btrfs: deal with duplciates during extent_map insertion in btrfs_get_extent") and
commit 8e2bd3b7fac9 ("Btrfs: deal with existing encompassing extent map in btrfs_get_extent()").

Unfortunately, there is one more regression which is caught recently by a
user's workloads.

While debugging the above issue, I found that all of these bugs are caused
by some racy situations, which can be very tricky to reproduce, so I
created several extent map specific test cases in btrfs's selftest
framework.

Patch 1-2 are fixing two bugs.
Patch 3-4 are some preparatory work.
Patch 3-5 are regression tests about the logic of handling EEXIST from
adding extent map.
Patch 8-10 are debugging wise, one is a direct tracepoint and the other is
to enable kprobe on merge_extent_mapping.

v2:
- Improve commit log to provide more details about the bug.
- Adjust bugfixes to the front so that we can merge them firstly.

Liu Bo (10):
  Btrfs: fix incorrect block_len in merge_extent_mapping
  Btrfs: fix unexpected EEXIST from btrfs_get_extent
  Btrfs: add helper for em merge logic
  Btrfs: move extent map specific code to extent_map.c
  Btrfs: add extent map selftests
  Btrfs: extent map selftest: buffered write vs dio read
  Btrfs: extent map selftest: dio write vs dio read
  Btrfs: add WARN_ONCE to detect unexpected error from
    merge_extent_mapping
  Btrfs: add tracepoint for em's EEXIST case
  Btrfs: noinline merge_extent_mapping

 fs/btrfs/Makefile                 |   2 +-
 fs/btrfs/extent_map.c             | 134 ++++++++++++++
 fs/btrfs/extent_map.h             |   2 +
 fs/btrfs/inode.c                  | 108 +-----------
 fs/btrfs/tests/btrfs-tests.c      |   3 +
 fs/btrfs/tests/btrfs-tests.h      |   1 +
 fs/btrfs/tests/extent-map-tests.c | 363 ++++++++++++++++++++++++++++++++++++++
 include/trace/events/btrfs.h      |  35 ++++
 8 files changed, 540 insertions(+), 108 deletions(-)
 create mode 100644 fs/btrfs/tests/extent-map-tests.c

-- 
2.9.4

