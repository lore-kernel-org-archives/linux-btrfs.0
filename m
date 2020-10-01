Return-Path: <SRS0=iHD6=DI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584ECC4727E
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Oct 2020 05:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F662221EC
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Oct 2020 05:58:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KfwUBYug"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730763AbgJAF6M (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Oct 2020 01:58:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:40314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgJAF6L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Oct 2020 01:58:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601531890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cSp7lzar01qW4cPKj6DUznAqb4JvW9BdnIyP2n3OHE4=;
        b=KfwUBYugi9H8uUrwmYFn2nT0hs923DKpTHvSZFbaJfiM9P8m9EvVNfiiX/wVV975stQ+Q9
        2y0agZXplGyaQTL0LY6NfMCyCFRvxSCaA9zVBsKlz0fHjFXukhB5uumrbxW6xjzO5SP8fh
        YKUQ6e+e7sOZgEaflbgmABsuzcm7WTs=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7ED3DB320
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2020 05:58:10 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 9 08/12] btrfs: volumes: update per-profile available space at mount time
Date:   Thu,  1 Oct 2020 13:57:40 +0800
Message-Id: <20201001055744.103261-9-wqu@suse.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001055744.103261-1-wqu@suse.com>
References: <20201001055744.103261-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch will update the initial per-profile available space at mount
time.

Error (-ENOMEM) would lead to mount failure. If we can't even allocate
memory at this moment, not allowing mount is good for everyone.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 28636cf01190..e28d6a304f87 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7860,6 +7860,13 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 
 	/* Ensure all chunks have corresponding dev extents */
 	ret = verify_chunk_dev_extent_mapping(fs_info);
+	if (ret < 0)
+		goto out;
+
+	/* All dev extents are verified, update per-profile available space */
+	mutex_lock(&fs_info->chunk_mutex);
+	ret = btrfs_update_per_profile_avail(fs_info);
+	mutex_unlock(&fs_info->chunk_mutex);
 out:
 	btrfs_free_path(path);
 	return ret;
-- 
2.28.0

