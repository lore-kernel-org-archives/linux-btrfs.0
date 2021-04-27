Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EB3C433B4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Apr 2021 23:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D46D96105A
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Apr 2021 23:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239458AbhD0XFp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 19:05:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:37348 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238340AbhD0XFo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Apr 2021 19:05:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619564699; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GXcKM8kizCpmOYRaqp/1f0oECykWeEbYZ8Ou0iFcjek=;
        b=omWniCl65kIBprpT1eRUqDOCAUXsUi59u0lHwZRGNsstty+YKomBw97ai2R7piJk1Yc1cv
        bLwNXXKVNm+QHeXuOKIaai5rsHihTU7q/LoBsQqjXfgT6nzilaBukdHPtGWnL3F9e+IvSi
        vc9LY2QqPwbApaV65JFu+rT7w+HzlDI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9DFC0AC6A
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Apr 2021 23:04:59 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [Patch v2 29/42] btrfs: make btrfs_page_mkwrite() to be subpage compatible
Date:   Wed, 28 Apr 2021 07:03:36 +0800
Message-Id: <20210427230349.369603-30-wqu@suse.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210427230349.369603-1-wqu@suse.com>
References: <20210427230349.369603-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Only set_page_dirty() and SetPageUptodate() is not subpage compatible.
Convert them to subpage helpers, so that __extent_writepage_io() can
submit page content correctly.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a54ea576a061..b8cf9709b225 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8600,8 +8600,9 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 		kunmap(page);
 	}
 	ClearPageChecked(page);
-	set_page_dirty(page);
-	SetPageUptodate(page);
+	btrfs_page_set_dirty(fs_info, page, page_start, end + 1 - page_start);
+	btrfs_page_set_uptodate(fs_info, page, page_start,
+				end + 1 - page_start);
 
 	btrfs_set_inode_last_sub_trans(BTRFS_I(inode));
 
-- 
2.31.1

