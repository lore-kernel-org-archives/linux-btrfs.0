Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23282 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752694AbbAIBmE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Jan 2015 20:42:04 -0500
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <miaoxie@huawei.com>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH] btrfs: fix raid56 scrub failed in xfstests btrfs/072
Date: Fri, 9 Jan 2015 09:39:40 +0800
Message-ID: <1420767580-19380-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The xfstests btrfs/072 reports uncorrectable read errors in dmesg,
because scrub forgets to use commit_root for parity scrub routine
and scrub attempts to scrub those extents items whose contents are
not fully on disk.

To fix it, we just add the @search_commit_root flag back.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f2bb13a..aa8ff75 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3065,6 +3065,8 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	path->search_commit_root = 1;
 	path->skip_locking = 1;
 
+	ppath->search_commit_root = 1;
+	ppath->skip_locking = 1;
 	/*
 	 * trigger the readahead for extent tree csum tree and wait for
 	 * completion. During readahead, the scrub is officially paused
-- 
1.8.1.4

