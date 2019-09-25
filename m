Return-Path: <SRS0=zJiL=XU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D3DC4360D
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Sep 2019 12:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0F55217F4
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Sep 2019 12:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405470AbfIYMOD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 08:14:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:59700 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405211AbfIYMOC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Sep 2019 08:14:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D7C58ABCE
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Sep 2019 12:14:01 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 01/10] btrfs-progs: image: Output error message for chunk tree build error
Date:   Wed, 25 Sep 2019 20:13:47 +0800
Message-Id: <20190925121356.118038-2-wqu@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925121356.118038-1-wqu@suse.com>
References: <20190925121356.118038-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/image/main.c b/image/main.c
index 28ef1609b5ff..fb407f33f858 100644
--- a/image/main.c
+++ b/image/main.c
@@ -2406,8 +2406,10 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 
 	if (!multi_devices && !old_restore) {
 		ret = build_chunk_tree(&mdrestore, cluster);
-		if (ret)
+		if (ret) {
+			error("failed to build chunk tree");
 			goto out;
+		}
 		if (!list_empty(&mdrestore.overlapping_chunks))
 			remap_overlapping_chunks(&mdrestore);
 	}
-- 
2.23.0

