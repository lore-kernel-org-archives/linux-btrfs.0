Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C96C48BDF
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jun 2021 05:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AF29613E3
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jun 2021 05:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFJFLf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jun 2021 01:11:35 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:59028 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbhFJFLf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jun 2021 01:11:35 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 302A3219A3
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jun 2021 05:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623301779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xeYtr4Y17qniPMB1NMaBQtPGKsvlrbQSePkXcBxTMrw=;
        b=ty6a78fPH+yTjPigYOtH6+eNxMd8cl6r3irwuTJXSJ0UVeYa3o5FsxOqhVuio9fK57UEoJ
        Hs6/ERejJzuQ+zdxpG7yIQ6ZPR2zYIsJOJOUyEHeEEZe3HqRcAnZE8ZtDt8FZ8F+b+L6ar
        qYXEvnOTSAVbsaWiIDTliiUbQVJ9/l4=
Received: from adam-pc.lan (unknown [10.163.16.38])
        by relay2.suse.de (Postfix) with ESMTP id 0E5B3A3B89
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jun 2021 05:09:37 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 10/10] btrfs: defrag: enable defrag for subpage case
Date:   Thu, 10 Jun 2021 13:09:17 +0800
Message-Id: <20210610050917.105458-11-wqu@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210610050917.105458-1-wqu@suse.com>
References: <20210610050917.105458-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

With the new infrasturture which has taken subpage into consideration,
now we should be safe to allow defrag to work for subpage case.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ioctl.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 446b2336725c..edf597ad515f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2974,12 +2974,6 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 		goto out;
 	}
 
-	/* Subpage defrag will be supported in later commits */
-	if (root->fs_info->sectorsize < PAGE_SIZE) {
-		ret = -ENOTTY;
-		goto out;
-	}
-
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFDIR:
 		if (!capable(CAP_SYS_ADMIN)) {
-- 
2.32.0

