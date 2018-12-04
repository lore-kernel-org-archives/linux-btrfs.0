Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDDA0C04EBF
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 15:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2555206B7
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 15:12:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2555206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbeLDPMX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 10:12:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:59514 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726152AbeLDPMX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 10:12:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 72547AEC7
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Dec 2018 15:12:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 14010DAC39; Tue,  4 Dec 2018 16:12:01 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     fdmanana@suse.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 1/2] btrfs: scrub: pass fs_info to scrub_setup_ctx
Date:   Tue,  4 Dec 2018 16:11:55 +0100
Message-Id: <9049971b8dd554eed0b19134e0642b238792e29b.1543935982.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543935982.git.dsterba@suse.com>
References: <cover.1543935982.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can pass fs_info directly as this is the only member of btrfs_device
that's bing used inside scrub_setup_ctx.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index bbd1b36f4918..ffcab263e057 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -578,12 +578,11 @@ static void scrub_put_ctx(struct scrub_ctx *sctx)
 		scrub_free_ctx(sctx);
 }
 
-static noinline_for_stack
-struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
+static noinline_for_stack struct scrub_ctx *scrub_setup_ctx(
+		struct btrfs_fs_info *fs_info, int is_dev_replace)
 {
 	struct scrub_ctx *sctx;
 	int		i;
-	struct btrfs_fs_info *fs_info = dev->fs_info;
 
 	sctx = kzalloc(sizeof(*sctx), GFP_KERNEL);
 	if (!sctx)
@@ -592,7 +591,7 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	sctx->is_dev_replace = is_dev_replace;
 	sctx->pages_per_rd_bio = SCRUB_PAGES_PER_RD_BIO;
 	sctx->curr = -1;
-	sctx->fs_info = dev->fs_info;
+	sctx->fs_info = fs_info;
 	for (i = 0; i < SCRUB_BIOS_PER_SCTX; ++i) {
 		struct scrub_bio *sbio;
 
@@ -3878,7 +3877,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return ret;
 	}
 
-	sctx = scrub_setup_ctx(dev, is_dev_replace);
+	sctx = scrub_setup_ctx(fs_info, is_dev_replace);
 	if (IS_ERR(sctx)) {
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-- 
2.19.1

