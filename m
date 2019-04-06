Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E621C282DA
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 10:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0CCD218D9
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 10:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfDFKiH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 06:38:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:49724 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726036AbfDFKiG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Apr 2019 06:38:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 51881AC1B;
        Sat,  6 Apr 2019 10:38:05 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 1/2] block: Add new BLK_STS_SELFTEST status
Date:   Sat,  6 Apr 2019 18:37:58 +0800
Message-Id: <20190406103759.6330-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are quite a lot of filesystems doing their verification work done
at endio hook or hook before submitting bio.

Normally such verification should return -EUCLEAN to indicate something
unexpected.

However there is no BLK_STS_* bit for that, this makes every selftest
error to be interpreted to EIO, which lowers the severity.

This patch will add a new BLK_STS_UCLEAN, to allow -EUCLEAN to be
converted to BLK_STS_UCLEAN, and then converted back to -EUCLEAN without
losing anything.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
- Use BLK_STS_UCLEAN to replace the previous stupid naming scheme.
---
 block/blk-core.c          | 1 +
 include/linux/blk_types.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4673ebe42255..a51c0a13fd5e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -135,6 +135,7 @@ static const struct {
 	[BLK_STS_RESOURCE]	= { -ENOMEM,	"kernel resource" },
 	[BLK_STS_DEV_RESOURCE]	= { -EBUSY,	"device resource" },
 	[BLK_STS_AGAIN]		= { -EAGAIN,	"nonblocking retry" },
+	[BLK_STS_UCLEAN]	= { -EUCLEAN,	"structure needs cleaning" },
 
 	/* device mapper special case, should not leak out: */
 	[BLK_STS_DM_REQUEUE]	= { -EREMCHG, "dm internal retry" },
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 791fee35df88..df0c470147c1 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -63,6 +63,9 @@ typedef u8 __bitwise blk_status_t;
  */
 #define BLK_STS_DEV_RESOURCE	((__force blk_status_t)13)
 
+/* Normally filesystem layer generated error */
+#define BLK_STS_UCLEAN		((__force blk_status_t)14)
+
 /**
  * blk_path_error - returns true if error may be path related
  * @error: status the request was completed with
-- 
2.21.0

