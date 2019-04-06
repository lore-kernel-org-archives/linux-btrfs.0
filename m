Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FF7C282DC
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 03:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB29C21871
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 03:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfDFDOc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 23:14:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:58988 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725973AbfDFDOc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 23:14:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CE5DBAFCF;
        Sat,  6 Apr 2019 03:14:30 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/2] block: Add new BLK_STS_SELFTEST status
Date:   Sat,  6 Apr 2019 11:14:25 +0800
Message-Id: <20190406031426.22436-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are a lot of end_io hooks which can do some self test at
read/write time.

Normally such selftest should return -EUCLEAN to indicate something
unexpected.

However there is no BLK_STS_* bit for that, this makes every selftest
error to be interpreted to EIO, which lowers the severity.

This patch will add a new BLK_STS_SELFTEST, to allow the error from
endio to be passed to filesystem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 block/blk-core.c          | 1 +
 include/linux/blk_types.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4673ebe42255..66967642a5ef 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -135,6 +135,7 @@ static const struct {
 	[BLK_STS_RESOURCE]	= { -ENOMEM,	"kernel resource" },
 	[BLK_STS_DEV_RESOURCE]	= { -EBUSY,	"device resource" },
 	[BLK_STS_AGAIN]		= { -EAGAIN,	"nonblocking retry" },
+	[BLK_STS_SELFTEST]	= { -EUCLEAN,	"filesystem selftest" },
 
 	/* device mapper special case, should not leak out: */
 	[BLK_STS_DM_REQUEUE]	= { -EREMCHG, "dm internal retry" },
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 791fee35df88..5bba24c3753c 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -63,6 +63,9 @@ typedef u8 __bitwise blk_status_t;
  */
 #define BLK_STS_DEV_RESOURCE	((__force blk_status_t)13)
 
+/* Filesystem selftest error */
+#define BLK_STS_SELFTEST	((__force blk_status_t)14)
+
 /**
  * blk_path_error - returns true if error may be path related
  * @error: status the request was completed with
-- 
2.21.0

