Return-Path: <SRS0=hiUa=QN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE72C169C4
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 20:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB82D217F9
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 20:49:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="wBM8Bjll"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfBFUt1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Feb 2019 15:49:27 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39516 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfBFUt1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2019 15:49:27 -0500
Received: by mail-qt1-f196.google.com with SMTP id o6so3161268qtk.6
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Feb 2019 12:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=oTjsSJ0wFTxeIeYHeHnRwNlz072yHETcbZ0gKsNKoJQ=;
        b=wBM8Bjll2dJvKoCRVJ+v5e9dz9my6t6GD6YE7laUL8nlhbLm9hULiodOI4R7i2MfgS
         M9CneY9UcaDMrAewG/8EN9X5rsjNJH9BxL9ZpycIsY9dxpeC82pXQAoGRGNwQUkWWFyw
         5wbsCT1pftXiQHTL1sa1vpaExYbq5OW3MwlYdDF5HQFo5+pzctFpBX9iSLeY/uYe1mLK
         akE50Uui3ERwxEa2tQq7ANUw8RC0QyhszkY+3tvXXE0dRUWz2SHGsCREmG00JjWr52ma
         CDoTXNDhflgMIYZet4+82deE8uCXG6b5cJDfHoi86d+Bephx4TDUcd2eUiA1T5liAOUB
         r3nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=oTjsSJ0wFTxeIeYHeHnRwNlz072yHETcbZ0gKsNKoJQ=;
        b=KLSERwY599kydEeltYcDdWJ/V5r1ITuoEtyJYEBYzCrsdp9iQqnGf+bcylj1yF+BiE
         wEdKwL95kjqQ6+D29IMQclrqilpJmtsLcLkUM53vyRz0u2tIb+5SYe8UlADnc54yBk1k
         fxnTIB3h7bqpdHgFguAuhltIOIcdcHoWEC2mMQlvTXiW4uij1WX/Gx8Pum7sdwSyzq2p
         Xj7yIArO+2fOvRUmEr9sNWyeOGa0Mej4C+D107dr3S4N2HioYdqUdw4Xf0lV93Ls8N0b
         U6bakp5IaJeKQSVgPwM9hvAJFiQy8nN3OWChhxwY/PQHUCVAIv0MneWpiSpxM3kKHvao
         HvZg==
X-Gm-Message-State: AHQUAuZsNpNtfyLynpYod9y5alVmY1O4hBrbbB85KFYMiC+hlkanTQIx
        zyEH4iIsRry7H2tcaWw6NDhzhpJQMiI=
X-Google-Smtp-Source: AHgI3IaH/rUaxLh47n2CRz4SqLWHkuu2FSgsSiqW2YJip9IBUX0tO9pd3lRmb64ae6sxPBYwcjZy0g==
X-Received: by 2002:ac8:78a:: with SMTP id l10mr9338965qth.365.1549486166146;
        Wed, 06 Feb 2019 12:49:26 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c202sm24225360qkb.19.2019.02.06.12.49.25
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Feb 2019 12:49:25 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: deal with drop_progress properly in fsck
Date:   Wed,  6 Feb 2019 15:49:24 -0500
Message-Id: <20190206204924.6096-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

While testing snapshot deletion with dm-log-writes I saw that I was
failing the fsck sometimes when the fs was actually in the correct
state.  This is because we only skip blocks on the same level of
root_item->drop_level.  If the drop_level < the root level then we could
very well walk into nodes that we wouldn't actually walk into on fs
mount, because the drop_progress is further ahead in the slot of the
root.  Instead only process the slots of the nodes that are above the
drop_progress key.  With this patch in place we no longer improperly
fail to check fs'es that have a drop_progress set with a drop_level <
root level.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 check/main.c | 19 ++++++++++++++++---
 ctree.c      |  6 +++---
 ctree.h      |  2 ++
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/check/main.c b/check/main.c
index 7547209c5604..89f0ce75e13d 100644
--- a/check/main.c
+++ b/check/main.c
@@ -6325,15 +6325,28 @@ static int run_next_block(struct btrfs_root *root,
 		int level;
 
 		level = btrfs_header_level(buf);
-		for (i = 0; i < nritems; i++) {
+		i = 0;
+
+		/*
+		 * If we have a drop key we need to not walk down any slots we
+		 * would have ignored when mounting the fs.  These blocks are
+		 * technically unreferenced and don't need to be worried about.
+		 */
+		if (ri != NULL && ri->drop_level && level > ri->drop_level) {
+			ret = btrfs_bin_search(buf, &ri->drop_key, level, &i);
+			if (ret && i > 0)
+				i--;
+		}
+
+		for (; i < nritems; i++) {
 			struct extent_record tmpl;
 
 			ptr = btrfs_node_blockptr(buf, i);
 			size = root->fs_info->nodesize;
 			btrfs_node_key_to_cpu(buf, &key, i);
 			if (ri != NULL) {
-				if ((level == ri->drop_level)
-				    && is_dropped_key(&key, &ri->drop_key)) {
+				if ((level == ri->drop_level) &&
+				    is_dropped_key(&key, &ri->drop_key)) {
 					continue;
 				}
 			}
diff --git a/ctree.c b/ctree.c
index 7cb3f8451542..a086d59d6a1c 100644
--- a/ctree.c
+++ b/ctree.c
@@ -638,8 +638,8 @@ static int generic_bin_search(struct extent_buffer *eb, unsigned long p,
  * simple bin_search frontend that does the right thing for
  * leaves vs nodes
  */
-static int bin_search(struct extent_buffer *eb, const struct btrfs_key *key,
-		      int level, int *slot)
+int btrfs_bin_search(struct extent_buffer *eb, const struct btrfs_key *key,
+		     int level, int *slot)
 {
 	if (level == 0)
 		return generic_bin_search(eb,
@@ -1172,7 +1172,7 @@ again:
 		ret = check_block(root, p, level);
 		if (ret)
 			return -1;
-		ret = bin_search(b, key, level, &slot);
+		ret = btrfs_bin_search(b, key, level, &slot);
 		if (level != 0) {
 			if (ret && slot > 0)
 				slot -= 1;
diff --git a/ctree.h b/ctree.h
index abc20e283fdc..f31a680eb473 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2616,6 +2616,8 @@ int btrfs_search_slot_for_read(struct btrfs_root *root,
                                const struct btrfs_key *key,
                                struct btrfs_path *p, int find_higher,
                                int return_any);
+int btrfs_bin_search(struct extent_buffer *eb, const struct btrfs_key *key,
+		     int level, int *slot);
 int btrfs_find_item(struct btrfs_root *fs_root, struct btrfs_path *found_path,
 		u64 iobjectid, u64 ioff, u8 key_type,
 		struct btrfs_key *found_key);
-- 
2.14.3

