Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7828CC282CE
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 07:41:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49421217D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 07:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbfDJHly (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 03:41:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:44576 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726954AbfDJHlx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 03:41:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 73182AFE7
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2019 07:41:52 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/2] block: Add new BLK_STS_UCLEAN status
Date:   Wed, 10 Apr 2019 15:41:48 +0800
Message-Id: <20190410074149.26646-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are quite a lot of filesystems doing their verification work done
at endio hook or hook before submitting bio.

Normally such verification returns -EUCLEAN to indicate something
unexpected, and some of such verification either uses bio->bi_status or
users bio->bi_endio to return their value.

In such case, the missing of such corresponding BLK_STS_UCLEAN can lower
the severity just like:
  In endio function:
	return errno_to_blk_status(-EUCLEAN);
 	^^^ -EUCLEAN gets interpreted to BLK_STS_IOERR

  In the filesystem code:
	ret = blk_status_to_errno(bi->bi_status);
	^^^ BLK_STS_IOERR gets interpreted to -EIO;

This lowers the severity, making the filesystem layer to believe it's
just an ordinary error.

This patch will add a new BLK_STS_UCLEAN, to allow -EUCLEAN to be
converted to BLK_STS_UCLEAN, and then converted back to -EUCLEAN without
losing anything.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changlog:
v2:
- Use BLK_STS_UCLEAN to replace the previous stupid naming scheme.
v3:
- Use "filesystem is corrupted" as error string.
- Add explanation about why filesystem code needs such status.
---
 block/blk-core.c          | 1 +
 include/linux/blk_types.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index a55389ba8779..427528950dcc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -135,6 +135,7 @@ static const struct {
 	[BLK_STS_RESOURCE]	= { -ENOMEM,	"kernel resource" },
 	[BLK_STS_DEV_RESOURCE]	= { -EBUSY,	"device resource" },
 	[BLK_STS_AGAIN]		= { -EAGAIN,	"nonblocking retry" },
+	[BLK_STS_UCLEAN]	= { -EUCLEAN,	"filesystem is corrupted" },
 
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

