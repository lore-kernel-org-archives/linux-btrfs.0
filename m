Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0D2C4361B
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Dec 2020 05:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B066123A52
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Dec 2020 05:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgLRFRz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 00:17:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:50158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgLRFRz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Dec 2020 00:17:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1608268629; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZiuLKZnHiGnwAItXBUbWP0W6qOGiq8Ot4ieMMcJ/XQ4=;
        b=tXtkgmU38na0AnDhc2lt2lPh3h7Kd/XviORFoWNwuhuZcffKthp1foKcYTldIO7mwg35YE
        bSN1O9Cy77LZ/jZEWJzfbROReHQlZHmwb9qVZZLdraz1z4qwZzg94BAkMRR0rrhTvFAVLH
        AXbmTvf3H9gf2Ba0pAGRG7HbGN+19bc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E3E8FB732
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Dec 2020 05:17:08 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: make btrfs_dio_private::bytes to be u32
Date:   Fri, 18 Dec 2020 13:17:00 +0800
Message-Id: <20201218051701.62262-2-wqu@suse.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201218051701.62262-1-wqu@suse.com>
References: <20201218051701.62262-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_dio_private::bytes is only assigned from bio::bi_iter::bi_size,
which is no larger than U32.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/btrfs_inode.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index d9bf53d9ff90..fbd65807f29d 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -325,7 +325,7 @@ struct btrfs_dio_private {
 	struct inode *inode;
 	u64 logical_offset;
 	u64 disk_bytenr;
-	u64 bytes;
+	u32 bytes;
 
 	/*
 	 * References to this structure. There is one reference per in-flight
-- 
2.29.2

