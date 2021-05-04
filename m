Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBAEC433ED
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 May 2021 06:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02D72610FC
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 May 2021 06:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhEDG02 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 May 2021 02:26:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:49922 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229773AbhEDG00 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 May 2021 02:26:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620109531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1qTwqK6tTKyXyAEhBuwNr9U4EdyPjD4oqirrODoiY4A=;
        b=Q+JgMO1lmIwHslovkMNY9mWT98Grf4RWook4UWSxT2I3pHWFtE2QQbuuUB4ABg46vFlKK9
        Eq00wPewmVCyq6sTKdEjnXo63XawCjL0pTCJKDwSxFlLxx8449Vysn1p8XLhcaWzHbG/ya
        HKMXWeSepUL4qf2hLr18ykfl2pQrk8c=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AD88EAE03
        for <linux-btrfs@vger.kernel.org>; Tue,  4 May 2021 06:25:31 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs-progs: check/original: add the "0x" prefix for hex error number
Date:   Tue,  4 May 2021 14:25:22 +0800
Message-Id: <20210504062525.152540-2-wqu@suse.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210504062525.152540-1-wqu@suse.com>
References: <20210504062525.152540-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In print_inode_error(), it print the error number in hex, but without
"0x" prefix.

Just add the prefix.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check/main.c b/check/main.c
index 0c4eb3ca5ded..1e65f8da4c6c 100644
--- a/check/main.c
+++ b/check/main.c
@@ -578,7 +578,7 @@ static void print_inode_error(struct btrfs_root *root, struct inode_record *rec)
 		root_objectid = root->root_key.offset;
 		fprintf(stderr, "reloc");
 	}
-	fprintf(stderr, "root %llu inode %llu errors %x",
+	fprintf(stderr, "root %llu inode %llu errors 0x%x",
 		(unsigned long long) root_objectid,
 		(unsigned long long) rec->ino, rec->errors);
 
-- 
2.31.1

