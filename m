Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6FBC56202
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CD3E2224B
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Nov 2020 12:52:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MgrjdHb7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgKMMwf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 07:52:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:46966 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbgKMMwe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Nov 2020 07:52:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1605271953; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXejXz4lAB8y8m/vh2JhSttSkxVpz+Q4OclFOF9kNUM=;
        b=MgrjdHb7oPdSJI+Oknp76BrOFIyDpQb8A0g4cl9NMuYcbvfWZXOe81R4s93ecuNtYdqp0w
        xLaNw8+/1s06h354R6dOfi6HKa8nBMSb6jwpqKhPBYvF4+Pi2qwYybdvVKZrFKoJG0PKn4
        cmTt/Jb1lxXhJAlS8oWnaU9G4zbCGF8=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1FAA0ABD6
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2020 12:52:33 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 11/24] btrfs: extent_io: don't allow tree block to cross page boundary for subpage support
Date:   Fri, 13 Nov 2020 20:51:36 +0800
Message-Id: <20201113125149.140836-12-wqu@suse.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201113125149.140836-1-wqu@suse.com>
References: <20201113125149.140836-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

As a preparation for subpage sector size support (allowing filesystem
with sector size smaller than page size to be mounted) if the sector
size is smaller than page size, we don't allow tree block to be read if
it crosses 64K(*) boundary.

The 64K is selected because:
- We are only going to support 64K page size for subpage for now
- 64K is also the max node size btrfs supports

This ensures that, tree blocks are always contained in one page for a
system with 64K page size, which can greatly simplify the handling.

Or we need to do complex multi-page handling for tree blocks.

Currently there is no way to create such tree blocks.
Kernel has avoided such tree blocks allocation even on 4K page size, as
it can lead to RAID56 stripe scrubing.

While btrfs-progs has fixed its chunk allocator since 2016 for convert,
and has extra checks to do the same behavior as the kernel.

Just add such graceful checks for ancient btrfs.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ca3eb095a298..f87220167f99 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5261,6 +5261,13 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 		btrfs_err(fs_info, "bad tree block start %llu", start);
 		return ERR_PTR(-EINVAL);
 	}
+	if (btrfs_is_subpage(fs_info) && offset_in_page(start) + len >
+			PAGE_SIZE) {
+		btrfs_err(fs_info,
+		"tree block crosses page boundary, start %llu nodesize %lu",
+			  start, len);
+		return ERR_PTR(-EINVAL);
+	}
 
 	eb = find_extent_buffer(fs_info, start);
 	if (eb)
-- 
2.29.2

