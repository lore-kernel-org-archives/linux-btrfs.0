Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A7DDC64EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A78620854
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:31:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A78620854
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbeJEE0J (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 00:26:09 -0400
Received: from smtp.dpl.mendix.net ([83.96.177.10]:45760 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbeJEE0J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 00:26:09 -0400
Received: from mekker.bofh.hq.mendix.net (mekker.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::21])
        by smtp.dpl.mendix.net (Postfix) with ESMTP id 024C1202A9
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Oct 2018 23:24:44 +0200 (CEST)
From:   Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] btrfs: alloc_chunk: do not refurbish num_bytes
Date:   Thu,  4 Oct 2018 23:24:38 +0200
Message-Id: <20181004212443.26519-2-hans.van.kranenburg@mendix.com>
X-Mailer: git-send-email 2.19.0.329.g76f2f5c1e3
In-Reply-To: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

num_bytes is used to store the chunk length of the chunk that we're
allocating. Do not reuse it for something really different in the same
function.

Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
---
 fs/btrfs/volumes.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f4405e430da6..9c9bb127eeee 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4837,8 +4837,9 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		goto error_del_extent;
 
 	for (i = 0; i < map->num_stripes; i++) {
-		num_bytes = map->stripes[i].dev->bytes_used + stripe_size;
-		btrfs_device_set_bytes_used(map->stripes[i].dev, num_bytes);
+		btrfs_device_set_bytes_used(map->stripes[i].dev,
+					    map->stripes[i].dev->bytes_used +
+					    stripe_size);
 	}
 
 	atomic64_sub(stripe_size * map->num_stripes, &info->free_chunk_space);
-- 
2.19.0.329.g76f2f5c1e3

