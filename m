Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D4E5C67839
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A80820849
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A80820849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbeLLHmj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 02:42:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:40910 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726603AbeLLHmi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 02:42:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E5068AEFA
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 07:42:36 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/3] btrfs: Remove redundant assignment
Date:   Wed, 12 Dec 2018 09:42:34 +0200
Message-Id: <20181212074234.20613-4-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181212074234.20613-1-nborisov@suse.com>
References: <20181212074234.20613-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

hole_len is only used if the hole falls within the requested range. Make
that explicitly clear by only assigning in the corresponding branch.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95eb18779c19..73ae4428d0df 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7021,7 +7021,7 @@ struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
 
 	if (delalloc_len) {
 		u64 hole_start;
-		u64 hole_len = len;
+		u64 hole_len;
 		u64 hole_end = extent_map_end(hole_em);
 
 		em = alloc_extent_map();
-- 
2.17.1

