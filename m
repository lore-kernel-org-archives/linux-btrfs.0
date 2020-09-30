Return-Path: <SRS0=DuSC=DH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC28C47420
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Sep 2020 01:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84A202074B
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Sep 2020 01:55:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rC/l1732"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgI3Bzy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 21:55:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:49598 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729322AbgI3Bzy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Sep 2020 21:55:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601430953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ubi6dxuYF1ruxqVWZUNpXQle0M+Nuln4OPBkB7debVE=;
        b=rC/l1732RtnQryElaRPc4JvzJU6ilx/NhAyn9y4axU26vd0YyXXDXzjnjmCV/11GixSXyn
        mI+y8X0DhYH5+S24plykdyz/mpZZYtQILmxC2GWhBV228LUj5xe+749IuDUBsrjeyNqZ3g
        NM8EPSwk+h74kAXMhalw1jLeGe3clfE=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6295BAE07
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2020 01:55:53 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 04/49] btrfs: extent_io: update the comment for find_first_extent_bit()
Date:   Wed, 30 Sep 2020 09:54:54 +0800
Message-Id: <20200930015539.48867-5-wqu@suse.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930015539.48867-1-wqu@suse.com>
References: <20200930015539.48867-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The pitfall here is, if the parameter @bits has multiple bits set, we
will return the first range which just has one of the specified bits
set.

This is a little tricky if we want an exact match.

Anyway, update the comment to inform the callers.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a64d88163f3b..2980e8384e74 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1554,11 +1554,12 @@ find_first_extent_bit_state(struct extent_io_tree *tree,
 }
 
 /*
- * find the first offset in the io tree with 'bits' set. zero is
- * returned if we find something, and *start_ret and *end_ret are
- * set to reflect the state struct that was found.
+ * Find the first offset in the io tree with one or more @bits set.
  *
- * If nothing was found, 1 is returned. If found something, return 0.
+ * NOTE: If @bits are multiple bits, any bit of @bits will meet the match.
+ *
+ * Return 0 if we find something, and update @start_ret and @end_ret.
+ * Return 1 if we found nothing.
  */
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 			  u64 *start_ret, u64 *end_ret, unsigned bits,
-- 
2.28.0

