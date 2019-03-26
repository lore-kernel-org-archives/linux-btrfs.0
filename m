Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 894A9C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 03:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5852520811
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 03:56:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="RqcWXnca"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730807AbfCZD4W (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 23:56:22 -0400
Received: from mail.synology.com ([211.23.38.101]:56649 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729681AbfCZD4W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 23:56:22 -0400
Received: from localhost.localdomain (unknown [10.17.32.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by synology.com (Postfix) with ESMTPSA id A9D75162F2FBD;
        Tue, 26 Mar 2019 11:56:19 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1553572579; bh=MvDwju8UIkFCLnrU6pw4VHmwAzsL120iuTVyzj6WADU=;
        h=From:To:Cc:Subject:Date;
        b=RqcWXncaPgOYVeCfaoQA5S9a1gHOCq+6VaAjHpkny7Wf6QMFJiZgEVx3eKHR+M62y
         VYFKJQoGjTLt3tN6swynfeNMUKArSpRiHPnAfnJFesZoAXW3FjYEK8pN6MrhaNnYdq
         /DjiqYDfAGwRI3O6LrsUf33UOr7hiB9euhut6IRk=
From:   robbieko <robbieko@synology.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Robbie Ko <robbieko@synology.com>
Subject: [PATCH v2] Btrfs: fix data bytes_may_use underflow with fallocate due to failed quota reserve
Date:   Tue, 26 Mar 2019 11:56:11 +0800
Message-Id: <1553572571-15614-1-git-send-email-robbieko@synology.com>
X-Mailer: git-send-email 1.9.1
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Robbie Ko <robbieko@synology.com>

When doing fallocate, we first add the range to the reserve_list
and then reserve the quota.
If quota reservation fails, we'll release all reserved parts of
reserve_list.
However, cur_offset is not updated to indicate that this
range is already been inserted into the list.
Therefore, the same range is freed twice.
Once at list_for_each_entry loop, and once at the end of the
function.
This will result in WARN_ON on bytes_may_use when we free the
remaining space.

At the end, under the 'out' label we have a call to:
   btrfs_free_reserved_data_space(inode, data_reserved, alloc_start,
alloc_end - cur_offset);
The start offset, third argument, should be cur_offset.
Everything from alloc_start to cur_offset was freed by the
list_for_each_entry_safe_loop.

Fixes: 18513091af94 ("btrfs: update btrfs_space_info's bytes_may_use timely")
Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 34fe8a5..0832449 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3132,6 +3132,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 			ret = btrfs_qgroup_reserve_data(inode, &data_reserved,
 					cur_offset, last_byte - cur_offset);
 			if (ret < 0) {
+				cur_offset = last_byte;
 				free_extent_map(em);
 				break;
 			}
@@ -3181,7 +3182,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	/* Let go of our reservation. */
 	if (ret != 0 && !(mode & FALLOC_FL_ZERO_RANGE))
 		btrfs_free_reserved_data_space(inode, data_reserved,
-				alloc_start, alloc_end - cur_offset);
+				cur_offset, alloc_end - cur_offset);
 	extent_changeset_free(data_reserved);
 	return ret;
 }
-- 
1.9.1

