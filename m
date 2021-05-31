Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 646DFC4708F
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 May 2021 08:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 469BD611CA
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 May 2021 08:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbhEaIxG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 31 May 2021 04:53:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:40754 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230500AbhEaIxE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 May 2021 04:53:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622451084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1mrLhEj35Tu+YsGYcNp98T02yzKKOtTMJWQmX4tqlhg=;
        b=tSFGnxU1Ee626pIMrrhuJYWJlwaZfUl0/I1ApMoz48cMQV0gIYs3uGS8qKhjfdHrK1Fyqk
        GjMdGBUBk1Cip/U3H5Sz+wb0Z/lk067xbSt0TtX5dCF1DA10wt6uIW7LZvfBkF6XmKj7Jf
        TGo4Ypb1d6T+k0I1uNGipQ3aYmMOgHU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0BE28B3E8;
        Mon, 31 May 2021 08:51:24 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v4 07/30] btrfs: make end_bio_extent_writepage() to be subpage compatible
Date:   Mon, 31 May 2021 16:50:43 +0800
Message-Id: <20210531085106.259490-8-wqu@suse.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531085106.259490-1-wqu@suse.com>
References: <20210531085106.259490-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Now in end_bio_extent_writepage(), the only subpage incompatible code is
the end_page_writeback().

Just call the subpage helpers.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent_io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 64456146ee8e..82979cb86876 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2853,7 +2853,8 @@ static void end_bio_extent_writepage(struct bio *bio)
 		}
 
 		end_extent_writepage(page, error, start, end);
-		end_page_writeback(page);
+
+		btrfs_page_clear_writeback(fs_info, page, start, bvec->bv_len);
 	}
 
 	bio_put(bio);
-- 
2.31.1

