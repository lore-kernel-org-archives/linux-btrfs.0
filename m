Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A7AC6FA82
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Sep 2022 20:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbiIBURJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Sep 2022 16:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiIBUQ6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Sep 2022 16:16:58 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B079FF4931
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Sep 2022 13:16:52 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id g14so2335190qto.11
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Sep 2022 13:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date;
        bh=pwS5JNUJo5O1jJU5UJg3jmCFhjt1cK+PNS4yDs0aoYE=;
        b=jYDQl9x2UM710HlibjlTpUwqRyReagyEcgp1KRUUb2ZtRlLrOJfKLUqq5Cb50Sbbo2
         bgVead260eYix10dO4oHhM9vyVnM32WlQEB2wFugUNoU59muowa2ePh7uDSjXI8389YN
         pxlHL5dNSd8calXmVta2iStZWnLPYXyWWPUqk4qPi8XjA7empeHBrlTl1ecWu8m8cTfb
         2glJzu5dBBt5HvGdqtLyWyj4/3qsDWXTxPka8ogGJlmfI9XfwMJDL49W0R89Ywvq0uKO
         qxSFVX1cWJVjtvS/r4QY+t9urgxTOBqsMkFBjq7CTOhGrAXwzh6D2bH6DxP8XSNc9p5H
         fCfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=pwS5JNUJo5O1jJU5UJg3jmCFhjt1cK+PNS4yDs0aoYE=;
        b=kNBntTWdBTakti9wk4DsLTqj1VwLqgxwYtQoktF3gRf1w7a6FpDW86s2Kn88RU/t1v
         Yq/j6CZldOlMArldbMzecdG8R/3QGy1w0g4z0UCZx7uZ4eiEHmUloiHYyI/qoIWvVTVS
         cH+SJUAhvGgvPJkziobYoRbFmr9RMdtBNlf9BaqP5VDtQlUJRbjUWZWgZGOgaVV01AMm
         LDzc+UWCWTgDnGImCQglNCQH1/Xl1x3YHuZpwNyfBtRMCK4D1X/ZRE2Ldpe6Dx5Kx7oF
         6MdDc6KCa1hmlOjxGnYL/Jzh7GY/u9+Xcnx3RxF6BbhiaQcf0o2XJdkDo+EB+45OzozV
         vCuA==
X-Gm-Message-State: ACgBeo3CPwmGrtwdn38uPlGYwelIBkI3AS/4gIr9AI+MMs9ql83V2IcL
        VGKtRT8BHNjZ5dOzDL9RVcq2/t2dHzJhnQ==
X-Google-Smtp-Source: AA6agR5Y3KhRMZzDNTMBxEBuv/hdiXXF04LPDYImV30QgG55KdmFnrXk9Wfyzwq6mLtEm6SerHuwvg==
X-Received: by 2002:ac8:5d8f:0:b0:344:a747:abf1 with SMTP id d15-20020ac85d8f000000b00344a747abf1mr30118708qtx.273.1662149811084;
        Fri, 02 Sep 2022 13:16:51 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id r9-20020a05620a298900b006b919c6749esm2203497qkp.91.2022.09.02.13.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 13:16:50 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 07/31] btrfs: temporarily export alloc_extent_state helpers
Date:   Fri,  2 Sep 2022 16:16:12 -0400
Message-Id: <f36aacb04583ff09e006da6a077026ca56181f35.1662149276.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1662149276.git.josef@toxicpanda.com>
References: <cover.1662149276.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We're going to move this code in stages, but while we're doing that we
need to export these helpers so we can more easily move the code into
the new file.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-io-tree.h | 3 +++
 fs/btrfs/extent_io.c      | 5 ++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.h b/fs/btrfs/extent-io-tree.h
index 6c2016db304b..8e7a548b88e9 100644
--- a/fs/btrfs/extent-io-tree.h
+++ b/fs/btrfs/extent-io-tree.h
@@ -250,4 +250,7 @@ void btrfs_free_io_failure_record(struct btrfs_inode *inode, u64 start,
 int btrfs_clean_io_failure(struct btrfs_inode *inode, u64 start,
 			   struct page *page, unsigned int pg_offset);
 
+struct extent_state *alloc_extent_state_atomic(struct extent_state *prealloc);
+struct extent_state *alloc_extent_state(gfp_t mask);
+
 #endif /* BTRFS_EXTENT_IO_TREE_H */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 27f412a3c668..47b12837edd6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -339,7 +339,7 @@ void extent_io_tree_release(struct extent_io_tree *tree)
 	spin_unlock(&tree->lock);
 }
 
-static struct extent_state *alloc_extent_state(gfp_t mask)
+struct extent_state *alloc_extent_state(gfp_t mask)
 {
 	struct extent_state *state;
 
@@ -710,8 +710,7 @@ static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 	return next;
 }
 
-static struct extent_state *
-alloc_extent_state_atomic(struct extent_state *prealloc)
+struct extent_state *alloc_extent_state_atomic(struct extent_state *prealloc)
 {
 	if (!prealloc)
 		prealloc = alloc_extent_state(GFP_ATOMIC);
-- 
2.26.3

