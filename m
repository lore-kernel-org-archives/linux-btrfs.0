Return-Path: <SRS0=h89n=3F=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B39DC33CAF
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 Jan 2020 17:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE4D824716
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 Jan 2020 17:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579195768;
	bh=OEdYCTN3y8EPJ9dDW/5viKwgfPGu0Jh8WKDLMDDsaXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=SbA0/pnFu8ly76Cml1CuJIV6OOI4mLXTVZtw95cijGSaf2rp/o5x6A/21rk/QqGTx
	 bi5OpUvgrKfNJjDcPkdlxl+bmIPmSPLK8HgWBao4vRd6UIucgwHBsO+QyGt8zhnKQt
	 o9UBSSQYmNo5bzmcyTiARQzpceV/VSTidttJ773U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392721AbgAPR31 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:29:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392712AbgAPR30 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Jan 2020 12:29:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 700D7246E3;
        Thu, 16 Jan 2020 17:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195766;
        bh=OEdYCTN3y8EPJ9dDW/5viKwgfPGu0Jh8WKDLMDDsaXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8kGH0YZ9JOl22R8yNy8SvwnvNq+DZUSgZHQGXbbKjMUsc1FvHUuORe73tDaljZx/
         6ESr8OfxBkGWD+WlZGCgcsW9R172tKyFNEoDPaVGMkjzz/xWzm+PoSvVPiatMFHfbk
         FDpkrB1MnAQZDaPotD+YjKshTogrOZW2esmfxs1w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 294/371] btrfs: use correct count in btrfs_file_write_iter()
Date:   Thu, 16 Jan 2020 12:22:46 -0500
Message-Id: <20200116172403.18149-237-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit c09767a8960ca0500fb636bf73686723337debf4 ]

generic_write_checks() may modify iov_iter_count(), so we must get the
count after the call, not before. Using the wrong one has a couple of
consequences:

1. We check a longer range in check_can_nocow() for nowait than we're
   actually writing.
2. We create extra hole extent maps in btrfs_cont_expand(). As far as I
   can tell, this is harmless, but I might be missing something.

These issues are pretty minor, but let's fix it before something more
important trips on it.

Fixes: edf064e7c6fe ("btrfs: nowait aio support")
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index bf654d48eb46..dd5f6e0df63f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1882,7 +1882,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
 	ssize_t err;
 	loff_t pos;
-	size_t count = iov_iter_count(from);
+	size_t count;
 	loff_t oldsize;
 	int clean_page = 0;
 
@@ -1903,6 +1903,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	}
 
 	pos = iocb->ki_pos;
+	count = iov_iter_count(from);
 	if (iocb->ki_flags & IOCB_NOWAIT) {
 		/*
 		 * We will allocate space in case nodatacow is not set,
-- 
2.20.1

