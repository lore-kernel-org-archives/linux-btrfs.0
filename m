Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30940 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932626AbcH2IJM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 04:09:12 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 48D494334C72
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 16:09:05 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/4] Fix chunk num_stripes FPE error found by fuzzed image
Date: Mon, 29 Aug 2016 16:08:58 +0800
Message-ID: <20160829080902.2952-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset will fix chunk num_stripes FPE error, by introducing another 2
layers of check.

1) Check key type validation against leaf owner(for original mode)
   This will prevent invalid key, like CHUNK_ITEM key in root tree, to be
   passed to later check.

   For original mode, it uses leaf's owner as standard.
   For low memory mode, it will use root->objectid(while not in devel
   branch yet)

   This is an extra early check layer, which could benefit other part.

2) Check chunk item again before processing it
   This is the root fix, as final defense for chunk item.
   This check itself can already fix the problem.
   But 1) can give more info on which is really going wrong in the fs.

Thanks for Lukas for his fuzzed images and report.

Qu Wenruo (4):
  btrfs-progs: Enhance and export print_objectid function
  btrfs-progs: Enhance and export print_key_type function
  btrfs-progs: Ignore invalid key in invalid root
  btrfs-progs: Do extra chunk check before processing chunk item

 cmds-check.c |  78 ++++++++++++++++++++++++++++++++
 print-tree.c | 145 ++++++++++++++++++++++++++++++-----------------------------
 print-tree.h |   2 +
 volumes.c    |   8 ++--
 volumes.h    |   4 ++
 5 files changed, 161 insertions(+), 76 deletions(-)

-- 
2.9.3



