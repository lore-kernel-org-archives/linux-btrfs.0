Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2ACDC43218
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 11:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 587E7206DD
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 11:09:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="NSE313h+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbfDZLJn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 07:09:43 -0400
Received: from mail.synology.com ([211.23.38.101]:35316 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725877AbfDZLJm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 07:09:42 -0400
Received: from localhost.localdomain (unknown [10.17.32.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by synology.com (Postfix) with ESMTPSA id 4E9581FC104FC;
        Fri, 26 Apr 2019 19:09:40 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1556276980; bh=qAWipAkXRojyQuYPu7pQlxLnqYY+ezKZS0/4cbJv5yM=;
        h=From:To:Cc:Subject:Date;
        b=NSE313h+9ZqJVPpt/XrNCZ/JetAO9lWiAXYHLEgbCq0rC2OxqF6GCyM+nUP7Xg3VH
         Hc6kisF2hq1tXuSvkNTQc2Oe8dZQ/eyETxLoR6ssbrgJKRxuqkv8tAKbSWRJEawvI4
         eqTNmePaN7hKTXnBKJHIIjjqmzl4sJxc/7iidXPI=
From:   robbieko <robbieko@synology.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Robbie Ko <robbieko@synology.com>
Subject: [PATCH] Btrfs: avoid allocating too many data chunks on massive concurrent write
Date:   Fri, 26 Apr 2019 19:09:22 +0800
Message-Id: <20190426110922.21888-1-robbieko@synology.com>
X-Mailer: git-send-email 2.17.1
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Robbie Ko <robbieko@synology.com>

I found a issue when btrfs allocates much more space than it actual needed
on massive concurrent writes. That may consume all free space and when it
need to allocate more space for metadata that result in ENOSPC.

I did a test that issue by 5000 dd to do write stress concurrently.

The space info after ENOSPC:
Overall:
Device size: 926.91GiB
Device allocated: 926.91GiB
Device unallocated: 1.00MiB
Device missing: 0.00B
Used: 211.59GiB
Free (estimated): 714.18GiB (min: 714.18GiB)
Data ratio: 1.00
Metadata ratio: 2.00
Global reserve: 512.00MiB (used: 0.00B)

Data,single: Size:923.77GiB, Used:209.59GiB
/dev/devname 923.77GiB

Metadata,DUP: Size:1.50GiB, Used:1022.50MiB
/dev/devname 3.00GiB

System,DUP: Size:72.00MiB, Used:128.00KiB
/dev/devname 144.00MiB

We can see that the Metadata space (1022.50MiB + 512.00MiB) is almost full.
But Data allocated much more space (923.77GiB) than it actually needed
(209.59GiB).

When the data space is not enough, this 5000 dd process will call
do_chunk_alloc() to allocate more space.

In the while loop of do_chunk_alloc, the variable force will be changed
to CHUNK_ALLOC_FORCE in second run and should_alloc_chunk() will always
return true when force is CHUNK_ALLOC_FORCE. That means every concurrent
dd process will allocate a chunk in do_chunk_alloc().

Fix this by keeping original value of force and re-assign it to force in
the end of the loop.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/extent-tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c5880329ae37..73856f70db31 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4511,6 +4511,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
 	bool wait_for_alloc = false;
 	bool should_alloc = false;
 	int ret = 0;
+	int orig_force = force;
 
 	/* Don't re-enter if we're already allocating a chunk */
 	if (trans->allocating_chunk)
@@ -4544,6 +4545,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
 			 */
 			wait_for_alloc = true;
 			spin_unlock(&space_info->lock);
+			force = orig_force;
 			mutex_lock(&fs_info->chunk_mutex);
 			mutex_unlock(&fs_info->chunk_mutex);
 		} else {
-- 
2.17.1

