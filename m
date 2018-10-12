Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC31C71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 20:45:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 320E4204EC
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 20:45:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="zUMlL8jz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 320E4204EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbeJMEUE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 13 Oct 2018 00:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbeJMEUE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Oct 2018 00:20:04 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27214204EC
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 20:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1539377148;
        bh=tNDoLByi7tTrHxEFq7Qg+sdvIu4qY5I7LCW0sIfsJFo=;
        h=From:To:Subject:Date:From;
        b=zUMlL8jzqq9F80GPLb5CNlPrngiomlWnElD4+JQUqoNF0QJiNSK+cQ4qH09GBQFA7
         6ApjQ4GjQI2G6Ptnvs1zbUplLgjzc5ZzfxXdAjX3P8oSEFBytuh/1hHatXJTd1iVvA
         9sE9IuOAQPVnFG905OUPA6anAo7xyqVdRYZblpGk=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix null pointer dereference on compressed write path error
Date:   Fri, 12 Oct 2018 21:45:44 +0100
Message-Id: <20181012204544.27137-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

At inode.c:compress_file_range(), under the "free_pages_out" label, we can
end up dereferencing the "pages" pointer when it has a NULL value. This
case happens when "start" has a value of 0 and we fail to allocate memory
for the "pages" pointer. When that happens we jump to the "cont" label and
then enter the "if (start == 0)" branch where we immediately call the
cow_file_range_inline() function. If that function returns an error (like
-ENOMEM for example) we jump to the "free_pages_out" label and then access
"pages[i]" leading to a NULL pointer dereference, since "nr_pages" has a
value greater than zero at that point.

Fix this by setting "nr_pages" to 0 when we fail to allocate memory for
the "pages" pointer.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201119
Fixes: 771ed689d2cd ("Btrfs: Optimize compressed writeback and reads")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 66c6c4103d2f..d6b61b1facdd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -503,6 +503,7 @@ static noinline void compress_file_range(struct inode *inode,
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {
 			/* just bail out to the uncompressed code */
+			nr_pages = 0;
 			goto cont;
 		}
 
-- 
2.11.0

