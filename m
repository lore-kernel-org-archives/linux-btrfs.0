Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8569C676D2
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 12:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7FEF20858
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 12:31:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7FEF20858
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbeJHTmb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 15:42:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:60284 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726056AbeJHTmb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 15:42:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0D52AAFDB
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Oct 2018 12:31:01 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 5/6] btrfs-progs: original check: Add dev_item check for used bytes and total bytes
Date:   Mon,  8 Oct 2018 20:30:43 +0800
Message-Id: <20181008123044.13413-6-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181008123044.13413-1-wqu@suse.com>
References: <20181008123044.13413-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/check/main.c b/check/main.c
index ff9a785ce555..12f12e18a83f 100644
--- a/check/main.c
+++ b/check/main.c
@@ -7938,6 +7938,12 @@ static int check_device_used(struct device_record *dev_rec,
 	struct device_extent_record *dev_extent_rec;
 	u64 total_byte = 0;
 
+	if (dev_rec->byte_used > dev_rec->total_byte) {
+		error("device %llu has incorrect used bytes %llu > total bytes %llu",
+		      dev_rec->devid, dev_rec->byte_used, dev_rec->total_byte);
+		return -EUCLEAN;
+	}
+
 	cache = search_cache_extent2(&dext_cache->tree, dev_rec->devid, 0);
 	while (cache) {
 		dev_extent_rec = container_of(cache,
-- 
2.19.1

