Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54AB3C433E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Jan 2021 14:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EBF62312E
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Jan 2021 14:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390066AbhASOlG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 09:41:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:37982 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390761AbhASM3F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jan 2021 07:29:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611059213; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uNDo5mvcBaVi2hdPpUvUu1N2yWtRLptIEjdsZUZPo6Q=;
        b=jYlqi1Kyn5kMxoQL+srQiT25MlvNMOsx0+LVNFRqR1iRFutxbZf/qa6f7vv8yDZtQRF2aR
        qiKhyYHW2nHL0SpX4sVkMHZgw4nRotbNSmk8K895BR8Keti90QvNyATwNRjmtE4IDP/Fe2
        UBmCtP8AC8ygCjU1GnsCJR6pltlCk6A=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 910A4AF47;
        Tue, 19 Jan 2021 12:26:53 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 06/13] btrfs: Document now parameter of peek_discard_list
Date:   Tue, 19 Jan 2021 14:26:42 +0200
Message-Id: <20210119122649.187778-7-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119122649.187778-1-nborisov@suse.com>
References: <20210119122649.187778-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Fixes fs/btrfs/discard.c:203: warning: Function parameter or member 'now' not described in 'peek_discard_list'

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/discard.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/discard.c b/fs/btrfs/discard.c
index 2b8383d41144..bfe53eb4c1f3 100644
--- a/fs/btrfs/discard.c
+++ b/fs/btrfs/discard.c
@@ -189,6 +189,7 @@ static struct btrfs_block_group *find_next_block_group(
  * @discard_ctl: discard control
  * @discard_state: the discard_state of the block_group after state management
  * @discard_index: the discard_index of the block_group after state management
+ * @now: Time when discard was invoked, in ns
  *
  * This wraps find_next_block_group() and sets the block_group to be in use.
  * discard_state's control flow is managed here.  Variables related to
-- 
2.25.1

