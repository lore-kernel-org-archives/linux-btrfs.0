Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D49C282D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 02:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB3BF20989
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 02:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfAaCun (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 21:50:43 -0500
Received: from gateway24.websitewelcome.com ([192.185.51.122]:13857 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbfAaCum (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 21:50:42 -0500
X-Greylist: delayed 1223 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jan 2019 21:50:42 EST
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 6583EC9AB
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 20:30:18 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id p27OgKqEp4FKpp27Ogi0kB; Wed, 30 Jan 2019 20:30:18 -0600
X-Authority-Reason: nr=8
Received: from [189.250.82.227] (port=40668 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gp27N-002kdJ-MS; Wed, 30 Jan 2019 20:30:17 -0600
Date:   Wed, 30 Jan 2019 20:30:16 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] btrfs: qgroup: Fix inconsistent IS_ERR and PTR_ERR
Message-ID: <20190131023016.GA3413@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.82.227
X-Source-L: No
X-Exim-ID: 1gp27N-002kdJ-MS
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.82.227]:40668
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 5
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Fix inconsistent IS_ERR and PTR_ERR in btrfs_qgroup_trace_subtree_after_cow

The proper pointer to be passed as argument is reloc_eb.

This bug was detected with the help of Coccinelle.

Fixes: 2b35a512e9cf ("btrfs: qgroup: Use delayed subtree rescan for balance")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 8559ed92d708..16d7ec8e4a06 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3931,7 +3931,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
 				   block->reloc_generation, block->level,
 				   &block->first_key);
 	if (IS_ERR(reloc_eb)) {
-		ret = PTR_ERR(subv_eb);
+		ret = PTR_ERR(reloc_eb);
 		reloc_eb = NULL;
 		goto free_out;
 	}
-- 
2.20.1

