Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A6AC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 16:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A216F208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 16:00:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A216F208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730440AbeK1C6n (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 21:58:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:54474 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726384AbeK1C6n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 21:58:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AB249AF4B
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 16:00:20 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 1/3] btrfs: don't initialize 'offset' in map_private_extent_buffer()
Date:   Tue, 27 Nov 2018 17:00:08 +0100
Message-Id: <20181127160010.18123-2-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181127160010.18123-1-jthumshirn@suse.de>
References: <20181127160010.18123-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In map_private_extent_buffer() the 'offset' variable is initialized to a
page aligned version of the 'start' parameter.

But later on it is overwritten with either the offset from the extent
buffer's start or 0.

So get rid of the initial initialization.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 582b4b1c41e0..7aafdec49dc3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5380,7 +5380,7 @@ int map_private_extent_buffer(const struct extent_buffer *eb,
 			      char **map, unsigned long *map_start,
 			      unsigned long *map_len)
 {
-	size_t offset = start & (PAGE_SIZE - 1);
+	size_t offset;
 	char *kaddr;
 	struct page *p;
 	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
-- 
2.16.4

