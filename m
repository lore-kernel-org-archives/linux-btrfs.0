Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B606C3526E
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Dec 2020 16:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BE28233F7
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Dec 2020 16:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgLPQ2k (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Dec 2020 11:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgLPQ2j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Dec 2020 11:28:39 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DC3C0619DC
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2020 08:27:53 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id h4so18167837qkk.4
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2020 08:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s/Sz8cWPtTfUa+Wl4786/qmcO33KzJmrjnJNHWLp8ek=;
        b=HaUyAMap9VFha6/kSomaLKK0FIS0d8Vlhjk9SeMJZh6wtMNhKfTFe+2HuPKtXDPno3
         nnWf+JNdzFLyv2Xe0W+PVPcAfMG5ATH85KZmuwgpmRUHq5qqbxTFyFNfBfrGg1z6x+x0
         1/uGzR+65jI4D79hVpYy6oFoAPJRL+17OhN3cycD6drMBJ+sn9coTlGGY7yY2QMrwDSs
         F+lTEppjlVN6KbX8JhNfa95sOQ+Yji5B32Meo5kGDWPRkHulH2JYRCOTM7IDuzXhippY
         BPtM6TuPdfZxiTU3WUAyIp4tA89OmLI8GPuStVv9ozCo32C/0ARETbDYlr4i7dRNSHcV
         +8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s/Sz8cWPtTfUa+Wl4786/qmcO33KzJmrjnJNHWLp8ek=;
        b=EMyN2qBsrPHcPPovVgJhhR8LmBQ+B+CC0nCs3yNBhNSMFL9mZ18lbgZY9pnNaOfG1F
         WJQBIe0SPQ8BEr6s/6oXgPlRRpEyyzluc1OYldrCb73MmojBW4+U2Jvcgv+1mErSz04/
         8dH7eniUZKGWHiEgPrhkFoYgYpyy0szw+y05/tqqNHFMzfqg6sVxKEcpbzbZem29GXKq
         DlwrNcnOtCLOboCtfbJby8enxTl/1sESn/H24Re1FGxdCYhN5MMKf3t3HlDNmHJ36tyh
         OEJdBSsAZ2dN2fH/X/BHWt7ykq4kABlSqSwZyoXv0t/RKi4cG5jdyRkddvQDx2cfCgvK
         ZIFg==
X-Gm-Message-State: AOAM530P7kO57U38HJy/tCr8GFobjP1tDSux0xBVaxokBUbGW9NVqB2u
        g+Q6UO+lkX1l9A3CWr8bcG6svpqyzL5FQWIV
X-Google-Smtp-Source: ABdhPJzI15yJ3cHStb2JEptMXTMmWrdpL9OQveJBmvRdwY30l7S9+kYIWHDobjIbpYGcpiqb5fxeTQ==
X-Received: by 2002:a37:c442:: with SMTP id h2mr30494028qkm.283.1608136072238;
        Wed, 16 Dec 2020 08:27:52 -0800 (PST)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id c14sm1241077qtg.85.2020.12.16.08.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 08:27:51 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Qu Wenruo <wqu@suse.com>
Subject: [PATCH v7 32/38] btrfs: remove the extent item sanity checks in relocate_block_group
Date:   Wed, 16 Dec 2020 11:26:48 -0500
Message-Id: <d6e64dc88c153008df3782fdfc7a8c71630f15d8.1608135849.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1608135849.git.josef@toxicpanda.com>
References: <cover.1608135849.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

These checks are all taken care of for us by the tree checker code.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/relocation.c | 29 +----------------------------
 1 file changed, 1 insertion(+), 28 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 67df6ae6d13f..93446ec5bcd9 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3371,20 +3371,6 @@ static void unset_reloc_control(struct reloc_control *rc)
 	mutex_unlock(&fs_info->reloc_mutex);
 }
 
-static int check_extent_flags(u64 flags)
-{
-	if ((flags & BTRFS_EXTENT_FLAG_DATA) &&
-	    (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK))
-		return 1;
-	if (!(flags & BTRFS_EXTENT_FLAG_DATA) &&
-	    !(flags & BTRFS_EXTENT_FLAG_TREE_BLOCK))
-		return 1;
-	if ((flags & BTRFS_EXTENT_FLAG_DATA) &&
-	    (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF))
-		return 1;
-	return 0;
-}
-
 static noinline_for_stack
 int prepare_to_relocate(struct reloc_control *rc)
 {
@@ -3436,7 +3422,6 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 	struct btrfs_path *path;
 	struct btrfs_extent_item *ei;
 	u64 flags;
-	u32 item_size;
 	int ret;
 	int err = 0;
 	int progress = 0;
@@ -3485,19 +3470,7 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 
 		ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				    struct btrfs_extent_item);
-		item_size = btrfs_item_size_nr(path->nodes[0], path->slots[0]);
-		if (item_size >= sizeof(*ei)) {
-			flags = btrfs_extent_flags(path->nodes[0], ei);
-			ret = check_extent_flags(flags);
-			BUG_ON(ret);
-		} else if (unlikely(item_size == sizeof(struct btrfs_extent_item_v0))) {
-			err = -EINVAL;
-			btrfs_print_v0_err(trans->fs_info);
-			btrfs_abort_transaction(trans, err);
-			break;
-		} else {
-			BUG();
-		}
+		flags = btrfs_extent_flags(path->nodes[0], ei);
 
 		if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 			ret = add_tree_block(rc, &key, path, &blocks);
-- 
2.26.2

