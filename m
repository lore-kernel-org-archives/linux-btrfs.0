Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AC6C433E0
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Jan 2021 10:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 114D3224D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Jan 2021 10:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbhAKK7B (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 05:59:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:34466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729572AbhAKK7B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jan 2021 05:59:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610362694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s9I5LmkY/MJZ1OBZpxrCm4bkvzlYkd2ZZNEA4hSe1b8=;
        b=HLWACCGmsv9ejRD0+UqtBShVtl/wgWd3jPnKZi2grM6cLJwlj48tedF+KONmz75VeV4/h3
        OU4YTp36lLsu7uVhT9EV0QZd3MB3oq6Ii+XMO4aZHKPU6If0TkM+6JWErWX2bUq/DHIDWv
        s0IS1gQI5uFTc6/rrdBGX4G7mfmV/nk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 94FF6ADCA;
        Mon, 11 Jan 2021 10:58:14 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     dsterba@suse.cz
Cc:     linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs: Remove always true condition in btrfs_start_delalloc_roots
Date:   Mon, 11 Jan 2021 12:58:12 +0200
Message-Id: <20210111105812.423915-2-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210111105812.423915-1-nborisov@suse.com>
References: <20210111105812.423915-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Following the rework in
"btrfs: shrink delalloc pages instead of full inodes" the nr variable
is no longer passed by reference to start_delalloc_inodes hence it
cannot change. Additionally we are always guaranteed for it to be
positive number hence it's redundant to have it as a condition in the
loop. Simply remove that usage.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 69e24341afc0..eb0a25e75126 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9495,7 +9495,7 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
 	mutex_lock(&fs_info->delalloc_root_mutex);
 	spin_lock(&fs_info->delalloc_root_lock);
 	list_splice_init(&fs_info->delalloc_roots, &splice);
-	while (!list_empty(&splice) && nr) {
+	while (!list_empty(&splice)) {
 		/*
 		 * Reset nr_to_write here so we know that we're doing a full
 		 * flush.
-- 
2.25.1

