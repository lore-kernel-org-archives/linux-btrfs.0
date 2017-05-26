Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30454 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163781AbdEZHj1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 03:39:27 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/3 v2] compression ops args clean up and trace point
Date: Fri, 26 May 2017 15:44:57 +0800
Message-Id: <20170526074500.20342-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch 1 and 2 are preparatory and clean up patches, and patch 3 adds
the trace point for the compression.

I have used same trace function for both compress and decompress
as I wanted to maintain compress and decompress debug data aligned

v2: added patch #2
Anand Jain (3):
  btrfs: btrfs_decompress_bio() could accept compressed_bio instead
  btrfs: reduce arguments for decompress_bio ops
  btrfs: add compression trace points

 fs/btrfs/compression.c       | 70 +++++++++++---------------------------------
 fs/btrfs/compression.h       | 44 +++++++++++++++++++++++++---
 fs/btrfs/lzo.c               | 10 +++----
 fs/btrfs/zlib.c              |  9 +++---
 include/trace/events/btrfs.h | 36 +++++++++++++++++++++++
 5 files changed, 103 insertions(+), 66 deletions(-)

-- 
2.10.0

