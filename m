Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FEE9C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 03:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2410E20657
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 03:25:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="tUQWRVzM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfANDZM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 13 Jan 2019 22:25:12 -0500
Received: from mail.synology.com ([211.23.38.101]:40815 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726622AbfANDZM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Jan 2019 22:25:12 -0500
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jan 2019 22:25:11 EST
Received: from localhost.localdomain (unknown [10.17.32.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by synology.com (Postfix) with ESMTPSA id 98A6AA5A45C6;
        Mon, 14 Jan 2019 11:16:02 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1547435762; bh=ZeDPo137mu79avqFeXFbtwtZksj/ObUeodd7Yso1+A0=;
        h=From:To:Cc:Subject:Date;
        b=tUQWRVzMn57J1D1qHB6fEduWLAe+noj0/HOA2x1nQH//XvV+s+NQ7upNaujEiyqQT
         iSBoKi6qhkGonk0qurgrg0JllW8aDlqY1W2FZbCBeUnY3seCYhJH1T3/lKh3wITE/G
         CNT5vsVtWHpYroNrD9GVFpm5ePDltxNUFRGHX+bs=
From:   robbieko <robbieko@synology.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Robbie Ko <robbieko@synology.com>
Subject: [PATCH] Btrfs: fix data bytes_may_use underflow with fallocate due to failed quota reserve
Date:   Mon, 14 Jan 2019 11:15:47 +0800
Message-Id: <1547435747-20013-1-git-send-email-robbieko@synology.com>
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
and then reserve the qutoa.
If quota reservation fails, we'll release all reserved parts of
reserve_list.
However, cur_offset doen't update to indicate that this range is
already been inserted into the list.
Therefore, the same range is freed twice.
One at list_for_each_entry loop, and the other at the end of the
function.
This will result in WARN_ON on bytes_may_use when we free the
remaining space.

Fixes: ("btrfs: update btrfs_space_info's bytes_may_use timely")
Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d38dc8c..43c6c8a 100644
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
-- 
1.9.1

