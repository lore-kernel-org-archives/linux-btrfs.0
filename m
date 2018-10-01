Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AAF0C43143
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C60E20C0A
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:46:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C60E20C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbeJAVYj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 17:24:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:42402 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729496AbeJAVYj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Oct 2018 17:24:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 55920AF54
        for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2018 14:46:28 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 10/10] btrfs-progs: check: Fix wrong error message in case of corrupted bitmap
Date:   Mon,  1 Oct 2018 17:46:21 +0300
Message-Id: <1538405181-25231-11-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1538405181-25231-1-git-send-email-nborisov@suse.com>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Similarly to the fix in e444c7bfa65f ("btrfs-progs: check: Fix wrong
error message in case of corrupted extent") this commits addresses the
same problem but for corrupted bitmap objects.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 free-space-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/free-space-tree.c b/free-space-tree.c
index 3b7e8a3fe4f5..690da44a739d 100644
--- a/free-space-tree.c
+++ b/free-space-tree.c
@@ -1302,7 +1302,7 @@ static int load_free_space_bitmaps(struct btrfs_fs_info *fs_info,
 		if (key.objectid + key.offset > end) {
 			fprintf(stderr,
 	"free space bitmap ends at %llu, beyond end of block group %llu-%llu\n",
-				key.objectid, start, end);
+				key.objectid + key.offset, start, end);
 			(*errors)++;
 			break;
 		}
-- 
2.7.4

