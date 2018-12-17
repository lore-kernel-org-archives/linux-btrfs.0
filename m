Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C71CFC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 08:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A21482084D
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 08:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731839AbeLQIgK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 03:36:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:56824 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731826AbeLQIgH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 03:36:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EB588AD5C
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 08:36:05 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 4/4] btrfs: Remove not_found_em label from btrfs_get_extent
Date:   Mon, 17 Dec 2018 10:36:02 +0200
Message-Id: <20181217083602.10166-5-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181217083602.10166-1-nborisov@suse.com>
References: <20181217083602.10166-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In order to avoid duplicating init code for em there is an additional
label, not_found_em, which is used to only set ->block_start. The only
case when it will be used is if the extent we are adding overlaps with
an existing extent. Make that case more obvious by :
 1. Adding a comment hinting at what's going on
 2. Assigning EXTENT_MAP_HOLE and directly going to insert.

 No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e8284cd0a122..0b9855c2df21 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6867,10 +6867,13 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 			goto not_found;
 		if (start > found_key.offset)
 			goto next;
+
+		/* New extent overlaps with existing one */
 		em->start = start;
 		em->orig_start = start;
 		em->len = found_key.offset - start;
-		goto not_found_em;
+		em->block_start = EXTENT_MAP_HOLE;
+		goto insert;
 	}
 
 	btrfs_extent_item_to_extent_map(inode, path, item,
@@ -6930,7 +6933,6 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	em->start = start;
 	em->orig_start = start;
 	em->len = len;
-not_found_em:
 	em->block_start = EXTENT_MAP_HOLE;
 insert:
 	btrfs_release_path(path);
-- 
2.17.1

