Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45823 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946470AbdEZB1N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 21:27:13 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4Q1RBxs003035
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v4Q1RB0x003272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:11 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v4Q1RBnL013221
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:11 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] add sanity check for extent inline ref type
Date: Thu, 25 May 2017 18:26:25 -0600
Message-Id: <20170526002631.8546-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

An invalid extent inline ref type could be read from a btrfs image and
it ends up with a panic[1], this set is to deal with the insane value
gracefully in patch 1-2 and clean up BUG() in the code in patch 3-5.

Patch 6 adds scrub support to detect the corruption, so users can be
noticed when they do scrub on a regular basis.

I'm not sure in the real world what may result in this corruption, but
I've seen several reports on the ML about __btrfs_free_extent saying
something was missing (or simply wrong), while testing this set with
btrfs-corrupt-block, I found that switching ref type could end up that
situation as well, eg. a data extent's ref type
(BTRFS_EXTENT_DATA_REF_KEY) is switched to (BTRFS_TREE_BLOCK_REF_KEY).

Hopefully this can give people more sights next time when that
happens.

[1]:https://www.spinics.net/lists/linux-btrfs/msg65646.html

Liu Bo (6):
  Btrfs: add a helper to retrive extent inline ref type
  Btrfs: convert to use btrfs_get_extent_inline_ref_type
  Btrfs: remove BUG() in btrfs_extent_inline_ref_size
  Btrfs: remove BUG() in print_extent_item
  Btrfs: remove BUG() in add_data_reference
  Btrfs: add sanity check of extent item in scrub

 fs/btrfs/backref.c     |  9 +++++--
 fs/btrfs/ctree.h       |  5 +++-
 fs/btrfs/extent-tree.c | 68 ++++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/print-tree.c  |  8 +++++-
 fs/btrfs/relocation.c  | 20 ++++++++++++---
 fs/btrfs/scrub.c       | 43 +++++++++++++++++++++++++++++++
 6 files changed, 139 insertions(+), 14 deletions(-)

-- 
2.9.4

