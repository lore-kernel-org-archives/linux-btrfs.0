Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A30C433F5
	for <linux-btrfs@archiver.kernel.org>; Sat, 21 May 2022 11:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242335AbiEULMD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 21 May 2022 07:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240824AbiEULMA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 May 2022 07:12:00 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C3B2A270;
        Sat, 21 May 2022 04:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sUMaQJx9OoQYbZAPgow8C7/7CAL2c6Y2tYZO0S3DjAQ=;
  b=G2Y6JpnyH9CXiioJMsob+658UyW+lGq4Zmhp2KT69SALSqzHbp8C0VXx
   d2EnqjHOh1ntHxpR4d1aY8KXWJG4nyf3U769yysfEImLYQkiqo0HxZuMp
   bMwJ8rADZihbySZHvd3fWU59ZL0XEZ0AjTXNO9g0sVDQ9YqUlUnGfS9JT
   Y=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727893"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:11:52 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Chris Mason <clm@fb.com>
Cc:     kernel-janitors@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: fix typos in comments
Date:   Sat, 21 May 2022 13:10:15 +0200
Message-Id: <20220521111145.81697-5-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Spelling mistakes (triple letters) in comments.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 fs/btrfs/ctree.h   |    2 +-
 fs/btrfs/subpage.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0e49b1a0c071..5d7da73a4804 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2734,7 +2734,7 @@ int btrfs_get_extent_inline_ref_type(const struct extent_buffer *eb,
 u64 hash_extent_data_ref(u64 root_objectid, u64 owner, u64 offset);
 
 /*
- * Take the number of bytes to be checksummmed and figure out how many leaves
+ * Take the number of bytes to be checksummed and figure out how many leaves
  * it would require to store the csums for that many bytes.
  */
 static inline u64 btrfs_csum_bytes_to_leaves(
diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index a105b291444f..0146fee730a0 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -123,7 +123,7 @@ int btrfs_attach_subpage(const struct btrfs_fs_info *fs_info,
 	struct btrfs_subpage *subpage;
 
 	/*
-	 * We have cases like a dummy extent buffer page, which is not mappped
+	 * We have cases like a dummy extent buffer page, which is not mapped
 	 * and doesn't need to be locked.
 	 */
 	if (page->mapping)

