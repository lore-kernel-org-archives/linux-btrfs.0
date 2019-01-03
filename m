Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C257C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA9AA20883
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 08:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbfACIuI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 03:50:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:60060 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726876AbfACIuI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 03:50:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0BDC1AEBC
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 08:50:07 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/7] More misc fixes
Date:   Thu,  3 Jan 2019 10:49:58 +0200
Message-Id: <20190103085005.32053-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here is an assortment of fixes, mainly around the async (compressed) cow path. 
Just removes some redundant arguments/local variables, makes shrink_delalloc a
bit more readable by simplifying variable usage and giving more appropriate names. 
Also documents the ->inode null check in async_cow_submit and cleans up open-coded
usage of DIV_ROUND_UP. No functional changes to any of the patches. 

Nikolay Borisov (7):
  btrfs: Remove inode argument from async_cow_submit
  btrfs: Remove isize local variable in compress_file_range
  btrfs: Use ihold instead of igrab in cow_file_range_async
  btrfs: Remove WARN_ON in btrfs_alloc_delalloc_work
  btrfs: Document logic in async_cow_submit
  btrfs: Replace open-coded maths with DIV_ROUND_UP
  btrfs: Refactor shrink_delalloc

 fs/btrfs/extent-tree.c | 33 ++++++++++++++++++++++-----------
 fs/btrfs/extent_io.c   |  7 +++----
 fs/btrfs/inode.c       | 27 +++++++++++++++------------
 3 files changed, 40 insertions(+), 27 deletions(-)

-- 
2.17.1

