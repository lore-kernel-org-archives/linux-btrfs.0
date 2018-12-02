Return-Path: <SRS0=5FUL=OL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DATE_IN_FUTURE_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E197C04EB8
	for <linux-btrfs@archiver.kernel.org>; Sun,  2 Dec 2018 06:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 003742080A
	for <linux-btrfs@archiver.kernel.org>; Sun,  2 Dec 2018 06:37:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BUxmIDgS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 003742080A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725440AbeLBGep (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 2 Dec 2018 01:34:45 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39145 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbeLBGep (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Dec 2018 01:34:45 -0500
Received: by mail-pf1-f194.google.com with SMTP id c72so4789689pfc.6
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Dec 2018 22:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eq4KoD6Ck+oeskhsEk6urmY2LnKdR2Mlb/yY0GvEgNI=;
        b=BUxmIDgSPAUGraUBmZqwtUmEQWgnDOR5M0IByAdftDJDBoPOQzf+5TDcrVNJiZUfZG
         cYM8PsTntFIQwJr2UUFH9hc+WWeAr0zBAs8gXFpquqs0Xh8yolnyum/eBLRv3kSbFAcp
         WQCVTg1yUz8z33L1JKc8llw00kkRTz17x2KqQSSRyGs7XwcNSySWDrNsmnsLeIYWoEJH
         uKYsQXtVbFeSeblz2AXkuc4Y5+zCyqftL5OqJBum45Gi+5PKNJ+AmMRbj04ytoJFyQ3r
         qAAtoYXmnH41NjLBmBnSA/ouPlX1JYXIhn5nNb5SCg9LEDmO4Mizv/trOf64wVel+f+S
         X56Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eq4KoD6Ck+oeskhsEk6urmY2LnKdR2Mlb/yY0GvEgNI=;
        b=idoj7JTNPdir6FI/19ezPY1CPriXIr0MTEJK7ZBv5f4An0aLhVfroR73gZTkjJgJGZ
         Hi01H1AG6sr70B/Ujog+1T00RRAEzM3S+UAD4ksDeKy9SF3fv8aiaeH+jJQom1TcFlSM
         1BUfrhG3hQWKH48x2n6sKDq8GwLywj3/uo/jH6/qxhDMpQT9NVkkfDPZVOhA7MWsC2ME
         GuCjk3XA+c40ktxc1Usvz7wU06/UdWy5p21tifwWCEq0KWTOJYVru0VtzIKOA3CpFe/3
         vNzv/a0jHImITyVlD4zLc5v1k3IPNDO7Vy0ZbUs4dsHSu7ruBdQ01BAhsC6z30idIOx6
         khgg==
X-Gm-Message-State: AA+aEWZBjxbpOVVa/mbnTco7HB+r6I0mzECOwkQGAff7eeUlXC1gW+Y3
        b4S74j2TTTlgUxfqcPOg8TCOepO/
X-Google-Smtp-Source: AFSGD/Xg1Tb6jUGRrzd1YBBKByTalmaIlNfVnO1PZp8F/bImAw4fndIf/R6KQbfTdd3WHUrmSoHXjg==
X-Received: by 2002:a63:902:: with SMTP id 2mr8984701pgj.219.1543732481387;
        Sat, 01 Dec 2018 22:34:41 -0800 (PST)
Received: from cat-arch.lan ([173.82.208.113])
        by smtp.gmail.com with ESMTPSA id m9sm10316555pgd.32.2018.12.01.22.34.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Dec 2018 22:34:40 -0800 (PST)
From:   damenly.su@gmail.com
X-Google-Original-From: suy.fnst@cn.fujitsu.com
To:     linux-btrfs@vger.kernel.org
Cc:     suy.fnst@cn.fujitsu.com
Subject: [PATCH v2 01/13] btrfs-progs: lowmem: add argument path to punch_extent_hole()
Date:   Sun,  2 Dec 2018 14:34:24 +0000
Message-Id: <20181202143424.14892-1-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181023094147.7906-2-suy.fnst@cn.fujitsu.com>
References: <20181023094147.7906-2-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yue <suy.fnst@cn.fujitsu.com>

Since repair will do CoW, the outer path may be invalid,
add an argument path to punch_extent_hole().
When punch_extent_hole() returns, path will still point to the item
before calling punch_extent_hole();

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
Changelog:
v2:
  Remove varaiable @ret2.
  Call btrfs_abort_transaction() if failed.
  
---
 check/mode-lowmem.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 1bce44f5658a..3dce4d3b5fc1 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1710,28 +1710,37 @@ out:
 /*
  * Wrapper function of btrfs_punch_hole.
  *
+ * @path:	will point to the item while calling the function.
+ *
  * Returns 0 means success.
  * Returns not 0 means error.
  */
-static int punch_extent_hole(struct btrfs_root *root, u64 ino, u64 start,
-			     u64 len)
+static int punch_extent_hole(struct btrfs_root *root, struct btrfs_path *path,
+			     u64 ino, u64 start, u64 len)
 {
 	struct btrfs_trans_handle *trans;
-	int ret = 0;
+	struct btrfs_key key;
+	int ret;
 
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
 	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
 	ret = btrfs_punch_hole(trans, root, ino, start, len);
-	if (ret)
+	if (ret) {
 		error("failed to add hole [%llu, %llu] in inode [%llu]",
 		      start, len, ino);
-	else
-		printf("Add a hole [%llu, %llu] in inode [%llu]\n", start, len,
-		       ino);
-
+		btrfs_abort_transaction(trans, ret);
+		return ret;
+	}
+	printf("Add a hole [%llu, %llu] in inode [%llu]\n", start, len, ino);
 	btrfs_commit_transaction(trans, root);
+
+	btrfs_release_path(path);
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret > 0)
+		ret = -ENOENT;
 	return ret;
 }
 
@@ -1963,7 +1972,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
 	/* Check EXTENT_DATA hole */
 	if (!no_holes && *end != fkey.offset) {
 		if (repair)
-			ret = punch_extent_hole(root, fkey.objectid,
+			ret = punch_extent_hole(root, path, fkey.objectid,
 						*end, fkey.offset - *end);
 		if (!repair || ret) {
 			err |= FILE_EXTENT_ERROR;
@@ -2534,7 +2543,7 @@ out:
 
 		if (!nbytes && !no_holes && extent_end < isize) {
 			if (repair)
-				ret = punch_extent_hole(root, inode_id,
+				ret = punch_extent_hole(root, path, inode_id,
 						extent_end, isize - extent_end);
 			if (!repair || ret) {
 				err |= NBYTES_ERROR;
-- 
2.19.1

