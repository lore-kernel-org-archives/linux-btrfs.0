Return-Path: <SRS0=R2l8=VB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D165C0650E
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Jul 2019 06:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F8B620881
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Jul 2019 06:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfGDGLN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Jul 2019 02:11:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:54372 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725861AbfGDGLN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Jul 2019 02:11:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 11EB3AF55
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Jul 2019 06:11:12 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2.1 02/10] btrfs-progs: image: Fix error output to show correct return value
Date:   Thu,  4 Jul 2019 14:10:55 +0800
Message-Id: <20190704061103.20096-3-wqu@suse.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190704061103.20096-1-wqu@suse.com>
References: <20190704061103.20096-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can easily get confusing error message like:
  ERROR: restore failed: Success

This is caused by wrong "%m" usage, as we normally use ret to indicate
error, without populating errno.

This patch will fix it by output the return value directly as normally
we have extra error message to show more meaning message than the return
value.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/image/main.c b/image/main.c
index fb407f33f858..7c499c0853d0 100644
--- a/image/main.c
+++ b/image/main.c
@@ -2734,7 +2734,7 @@ int BOX_MAIN(image)(int argc, char *argv[])
 				       0, target, multi_devices);
 	}
 	if (ret) {
-		error("%s failed: %m", (create) ? "create" : "restore");
+		error("%s failed: %d", (create) ? "create" : "restore", ret);
 		goto out;
 	}
 
-- 
2.22.0

