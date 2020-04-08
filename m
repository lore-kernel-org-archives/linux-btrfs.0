Return-Path: <SRS0=tPet=5Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B62EFC2D0EA
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Apr 2020 07:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F34220747
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Apr 2020 07:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgDHHER (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 03:04:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:58502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgDHHER (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Apr 2020 03:04:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 025BFAC6C
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2020 07:04:15 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Fix bad kernel header non-flat include case
Date:   Wed,  8 Apr 2020 15:04:12 +0800
Message-Id: <20200408070412.40911-1-wqu@suse.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If we're compiling using system header, we should include
<btrfs/crc32c.h> other than "btrfs/crc32.h".

Fixes: 2efe160bc757 ("btrfs-progs: move name hashing functions to ctree.h and delete hash.h")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ctree.h b/ctree.h
index 9d69fa946079..df830956fdb8 100644
--- a/ctree.h
+++ b/ctree.h
@@ -38,7 +38,7 @@
 #include <btrfs/extent_io.h>
 #include <btrfs/ioctl.h>
 #include <btrfs/sizes.h>
-#include "btrfs/crc32c.h"
+#include <btrfs/crc32c.h>
 #endif /* BTRFS_FLAT_INCLUDES */
 
 struct btrfs_root;
-- 
2.26.0

