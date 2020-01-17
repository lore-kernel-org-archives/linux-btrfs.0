Return-Path: <SRS0=6qVc=3G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC0EC33CB3
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Jan 2020 21:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E78402072E
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Jan 2020 21:26:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="aRhhLK98"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgAQV0V (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 16:26:21 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36049 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAQV0U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Jan 2020 16:26:20 -0500
Received: by mail-qk1-f193.google.com with SMTP id a203so24178675qkc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jan 2020 13:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9u6qpskOC0taJN3qwnyWq7XSFIsCi5A4bt7jQopBCno=;
        b=aRhhLK98Q9qCA47LYppq0Fssuy/Y0ZpCKZ9/FafAfVIDxakgBfIuVKSok/rEC26FHp
         nwN7DDqIxa4gPwPjSE8bZbbW4oIiRlEZhHhfAdx+f9B2UFWOQZUefxE65wJfT97sLPhQ
         cszeqO0BXlFUfv38XZIfC8veSniloTCMY9BUK0CvqxsRETP2YR/oiJ+QrGCqq8eVo31G
         pNFHUg1kIsfHcDCe1OKMKiQaO9Q+yOm3BPYmOXBqLV0HgiN/QuPG4nwpfaLGryvProBf
         LLvqd0AwHBv2q9+DB9tvRD06aDaFIZ14ER1rBHqyP1/VmFxIDN63irFI97mmacWCdDod
         6S9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9u6qpskOC0taJN3qwnyWq7XSFIsCi5A4bt7jQopBCno=;
        b=T3vcdAPjSPB7sKoYnMNeO/sYNXhatXxJqZwB5q9WCucUDM6TzQahfijTg9s041nvUk
         te4nZR5T5roiZeAuTUHTgE7Bnuqkxp7Fl1mUjVlxS+XuXZt5sHXIQsotbGrpWJV/mVU4
         /aGQmZkq+uVZ9B5NvIXUyUUAxW//0gS9nebihgh71dOF/d35Ad8MDeBH56D9AjwcKGXx
         /Y1nD4yPTjcghOoRiusMbNIc5szd4GX5tqAp1+PsPzIbSjPsmpnHtw33Ji/9woIahqS9
         y1qMxA4KEZeJ1/tSAq8BXHi9375Yxjqw8vTL0bIliIUMiH9xInjV+gGUiHJVHMYwOpXN
         pqcA==
X-Gm-Message-State: APjAAAWOrMhzyutUuvGWwbae3g1vS/96C4L6I8Z/qmxZsA3rvlPLedon
        yypYmBpzLuZz4sLgchrivWcTFk2ntCDd0Q==
X-Google-Smtp-Source: APXvYqziquEQwG2coe0xRrmgEmmAoXXNb9ZUrqIs4y1jIo3SMBpJMGqmTsCa5uNFhRmHiaGbkZWkKA==
X-Received: by 2002:a37:c449:: with SMTP id h9mr34883504qkm.124.1579296379297;
        Fri, 17 Jan 2020 13:26:19 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id t2sm12175316qkc.31.2020.01.17.13.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 13:26:18 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 08/43] btrfs: make the fs root init functions static
Date:   Fri, 17 Jan 2020 16:25:27 -0500
Message-Id: <20200117212602.6737-9-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117212602.6737-1-josef@toxicpanda.com>
References: <20200117212602.6737-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Now that the orphan cleanup stuff doesn't use this directly we can just
make them static.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 6 +++---
 fs/btrfs/disk-io.h | 3 ---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d13791ccb4f6..f030ff87ed18 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1437,7 +1437,7 @@ struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
 	goto out;
 }
 
-int btrfs_init_fs_root(struct btrfs_root *root)
+static int btrfs_init_fs_root(struct btrfs_root *root)
 {
 	int ret;
 	struct btrfs_subvolume_writers *writers;
@@ -1488,8 +1488,8 @@ int btrfs_init_fs_root(struct btrfs_root *root)
 	return ret;
 }
 
-struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
-					u64 root_id)
+static struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
+					       u64 root_id)
 {
 	struct btrfs_root *root;
 
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index c2e765edf034..7aa1c7a3a115 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -60,9 +60,6 @@ int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
 int btrfs_commit_super(struct btrfs_fs_info *fs_info);
 struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
 					struct btrfs_key *key);
-int btrfs_init_fs_root(struct btrfs_root *root);
-struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
-					u64 root_id);
 int btrfs_insert_fs_root(struct btrfs_fs_info *fs_info,
 			 struct btrfs_root *root);
 void btrfs_free_fs_roots(struct btrfs_fs_info *fs_info);
-- 
2.24.1

