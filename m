Return-Path: <SRS0=5HN8=ZA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80037FC6196
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5232C2178F
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387400AbfKHVi5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 16:38:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:45844 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730009AbfKHVi5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Nov 2019 16:38:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 08A9FB192;
        Fri,  8 Nov 2019 21:38:56 +0000 (UTC)
From:   =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To:     Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH next 1/2] btrfs: tree-checker: Fix error format string
Date:   Fri,  8 Nov 2019 22:38:52 +0100
Message-Id: <20191108213853.16635-2-afaerber@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191108213853.16635-1-afaerber@suse.de>
References: <20191108213853.16635-1-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Andreas Färber <afaerber@suse.com>

Argument BTRFS_FILE_EXTENT_INLINE_DATA_START is defined as offsetof(),
which returns type size_t, so we need %zu instead of %lu.

This fixes a build warning on 32-bit arm:

  ../fs/btrfs/tree-checker.c: In function 'check_extent_data_item':
  ../fs/btrfs/tree-checker.c:230:43: warning: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'unsigned int' [-Wformat=]
    230 |     "invalid item size, have %u expect [%lu, %u)",
        |                                         ~~^
        |                                           |
        |                                           long unsigned int
        |                                         %u

Fixes: a31ccb4b7ba2 ("btrfs: tree-checker: Check item size before reading file extent type")
Cc: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>
Signed-off-by: Andreas Färber <afaerber@suse.com>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 493d4d9e0f79..092b8ece36d7 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -227,7 +227,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 	 */
 	if (item_size < BTRFS_FILE_EXTENT_INLINE_DATA_START) {
 		file_extent_err(leaf, slot,
-				"invalid item size, have %u expect [%lu, %u)",
+				"invalid item size, have %u expect [%zu, %u)",
 				item_size, BTRFS_FILE_EXTENT_INLINE_DATA_START,
 				SZ_4K);
 		return -EUCLEAN;
-- 
2.16.4

