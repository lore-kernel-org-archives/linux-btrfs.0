Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A64C10F14
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 07:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E65FC217D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 07:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbfDJHl5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 03:41:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:44582 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726954AbfDJHlz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 03:41:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3046AAFE7
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2019 07:41:54 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/2] btrfs: Add error string for EUCLEAN
Date:   Wed, 10 Apr 2019 15:41:49 +0800
Message-Id: <20190410074149.26646-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190410074149.26646-1-wqu@suse.com>
References: <20190410074149.26646-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since we're going to support write time tree checker, it's possible that
transaction get aborted due to tree-checker, also due to new
BLK_STS_UCLEAN bit, we can distinguish real EIO error and EUCLEAN
error.

So adding new string for EUCLEAN to make the "unknown" reason to an easy
to read one.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 120e4340792a..c8d0646bfd2c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -86,6 +86,9 @@ const char *btrfs_decode_error(int errno)
 	case -ENOENT:
 		errstr = "No such entry";
 		break;
+	case -EUCLEAN:
+		errstr = "Filesystem is corrupted";
+		break;
 	}
 
 	return errstr;
-- 
2.21.0

