Return-Path: <SRS0=dRQQ=6M=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C518AC83008
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AED3A205C9
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgD1PLO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 11:11:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:56232 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727915AbgD1PLN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Apr 2020 11:11:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E8069AC8F;
        Tue, 28 Apr 2020 15:11:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A667FDA8C9; Tue, 28 Apr 2020 17:10:27 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 1/2] btrfs: sort error decoder entries
Date:   Tue, 28 Apr 2020 17:10:27 +0200
Message-Id: <a848755b7943f0f15fd87af15cff99ab3c484f00.1588086487.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <cover.1588086487.git.dsterba@suse.com>
References: <cover.1588086487.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add the raw errnos and sort them accordingly.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/super.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7932d8d07cff..9e5d723a0d99 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -72,23 +72,23 @@ const char * __attribute_const__ btrfs_decode_error(int errno)
 	char *errstr = "unknown";
 
 	switch (errno) {
-	case -EIO:
+	case -ENOENT:		/* -2 */
+		errstr = "No such entry";
+		break;
+	case -EIO:		/* -5 */
 		errstr = "IO failure";
 		break;
-	case -ENOMEM:
+	case -ENOMEM:		/* -12*/
 		errstr = "Out of memory";
 		break;
-	case -EROFS:
-		errstr = "Readonly filesystem";
-		break;
-	case -EEXIST:
+	case -EEXIST:		/* -17 */
 		errstr = "Object already exists";
 		break;
-	case -ENOSPC:
+	case -ENOSPC:		/* -28 */
 		errstr = "No space left";
 		break;
-	case -ENOENT:
-		errstr = "No such entry";
+	case -EROFS:		/* -30 */
+		errstr = "Readonly filesystem";
 		break;
 	}
 
-- 
2.25.0

