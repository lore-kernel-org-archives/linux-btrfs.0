Return-Path: <SRS0=OHkO=4B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EF5C3F68F
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 15:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B67D24649
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 15:58:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="llRsZk/m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgBMP60 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 10:58:26 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:60885 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388189AbgBMP6O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Feb 2020 10:58:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581609540; x=1613145540;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dax4nT4EgI9eBuEOKjigBXI+B6H5jyT/BI0k2SyIjG8=;
  b=llRsZk/mujcKLwxNMYWsin8JRaLIHpJxWkoKmYrCwypCnQv24dUR6Nwa
   7Tz03Xeiw/gQ7Z6QlOTeXskdL3ZCv1JN20RnonGnBXWhgwvIvCIm1ViZn
   /n/9yVUWxS9xCp/nXMRKOJvh8d0rfVn57NtsTVXB3kmD3dpuXYrJ1FmdC
   uavxwLM5jw3WiMr/jDnNvATfurwNUDypMVuEjazMD+TdkUkNFbcGLhn3J
   6kxkQmZgJXwC5MhfkAkSXEeQ5Ws/E/CEa4P0y4oGDZn6ELg/nVwk3K6k5
   QkVG9M1jmMtTjscQnRdC9b7imSuQtXiuCBqH3JeKwzVXIzKptscNGczHo
   w==;
IronPort-SDR: 67E+NQn3L0jibwVaHynXz4/4xBdii/4kmQCbOMsrrNb4DuMq0VtyM+LwvVI+9Zt4Lz8tKfqtFT
 MfSof5dSQItoCLA6vOKz4QgLc106aWgkUPW2YIKo8/OeGzUh+bDAEoL8SqyYp3P4YA48aPJbGn
 Q1MtxQ8tsGl1uE2tz209p81cGQP9vTr3pL4fschdKpQmTmFpaKf6ukE9LSxkWFATfLsRBbfo9a
 1D+xv/vXytNZiThogiLhvjFNJY96BKo87mqiaZN4g0kfQH6qPB/5KkUfpYr3cYs/Plpw8mWPvQ
 hPE=
X-IronPort-AV: E=Sophos;i="5.70,437,1574092800"; 
   d="scan'208";a="231587560"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Feb 2020 23:59:00 +0800
IronPort-SDR: QqgneapdVDIBGJCYCkc8YGKKkklDr0/Th3x4Om5QcVx45hHHzmMI0ivcCdCNfEQR47yo8mi1z8
 E+7HeN1EQ3EDoLMMVkYa3gN0hH7nDHsCz3YB2bFQtag6AImcptlVGsSzOVNz+S4E8tEi9hFRmU
 tkrQCi/TgyZS3V1j2ywp9CHLhZ5UWP9WQD5bVhrKb9N/Eo2KGzNn7PMko6m2eqINssWOewv+we
 CrZ8Elzvt/AOTBZEgzaBdJGV/7BHoq1iFjf61VDJdQfi2XbPQrPbomjYGUBEETfa41+KkO+O+V
 EcZJ3oXwiB+8rcw5o0zUNvQ5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2020 07:51:01 -0800
IronPort-SDR: lwGyKE7cWRGhCrHWeyr8nGnx5Un8OS0kEQIDHnC9NdBb8IB7RoHWgpnu+8dQLDcfDAHOIdXE3g
 3aqrf7DpdB9mAGmFOuh57+fKVPZCiJDDGKJwqgMU1ocRMY++miixHvlvwyZNs84+Iv56xpuQeI
 iyX2TkWLGar+cg3IK1mfIq0Hfpu025KMxp3qmsjPvFPLFjcNoT5YH9yJJHdwxmcq82NxGpNnIp
 ro2BFHuePyLXkMarHViN0xCIVcdtPKilAp/mo1UrBsMAKWskePSIrjzKjVHehU56zWQVYOy0To
 xzc=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Feb 2020 07:58:13 -0800
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     David Sterba <dsterba@suse.cz>
Cc:     "linux-btrfs @ vger . kernel . org" <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 0/5] Fix memory leak on failed cache-writes
Date:   Fri, 14 Feb 2020 00:57:58 +0900
Message-Id: <20200213155803.14799-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Fstests' test case generic/475 reliably leaks the btrfs_io_ctl::pages
allocated in __btrfs_write_out_cache().

The first patch in this series is freeing the pages when we throw away a dirty
block group. The other patches are small things I noticed while hunting down the
problem and are independant of fix.

Changes to v1:
- Move fix to the first position (David)

Johannes Thumshirn (5):
  btrfs: free allocated pages on failed cache write-out
  btrfs: use inode from io_ctl in io_ctl_prepare_pages
  btrfs: make the uptodate argument of io_ctl_add_pages() boolean.
  btrfs: use standard debug config option to enable free-space-cache
    debug prints
  btrfs: simplify error handling in __btrfs_write_out_cache()

 fs/btrfs/disk-io.c          |  6 +++++
 fs/btrfs/free-space-cache.c | 44 ++++++++++++++++++++-----------------
 fs/btrfs/free-space-cache.h |  1 +
 3 files changed, 31 insertions(+), 20 deletions(-)

-- 
2.24.1

