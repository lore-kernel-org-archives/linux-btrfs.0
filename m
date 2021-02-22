Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961AAC4332E
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Feb 2021 16:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7271A64EF2
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Feb 2021 16:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhBVQmz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 11:42:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:45940 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231411AbhBVQlf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Feb 2021 11:41:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1614012049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LFQ8YZwWgFJEnkCJcQh1Ak18VrWHBoAmAI2RW9/Ga1I=;
        b=YwOuF09er6yed8iIQfciTfPNCBC6jEjhHV/XSZTMitsqk706CdxhiMrOny/sDd/BJUJPAI
        pi3Jygu0hbJZeWXYHEiatoGvpP4b/vYF/867jU5IGhjpBU7RgGs3/xjGjKqkXq6QPUoeYX
        ErJCskcJDU8K/P/22dILq7KwHiP4WVg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 599CCAD6B;
        Mon, 22 Feb 2021 16:40:49 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/6] btrfs: Free correct amount of space in btrfs_delayed_inode_reserve_metadata
Date:   Mon, 22 Feb 2021 18:40:42 +0200
Message-Id: <20210222164047.978768-2-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210222164047.978768-1-nborisov@suse.com>
References: <20210222164047.978768-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Following commit f218ea6c4792 ("btrfs: delayed-inode: Remove wrong
qgroup meta reservation calls") this function now reserves num_bytes,
rather than the fixed amount of nodesize. As such this requires the
same amount to be freed in case of failure. Fix this by adjusting
the amount we are freeing.

Fixes f218ea6c4792 ("btrfs: delayed-inode: Remove wrong qgroup meta reservation calls")

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index ec0b50b8c5d6..ac9966e76a2f 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -649,7 +649,7 @@ static int btrfs_delayed_inode_reserve_metadata(
 						      btrfs_ino(inode),
 						      num_bytes, 1);
 		} else {
-			btrfs_qgroup_free_meta_prealloc(root, fs_info->nodesize);
+			btrfs_qgroup_free_meta_prealloc(root, num_bytes);
 		}
 		return ret;
 	}
-- 
2.25.1

