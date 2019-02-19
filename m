Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6A9C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 03:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C10082147C
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 03:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbfBSDVT convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 22:21:19 -0500
Received: from sender-op-o13.zoho.com ([135.84.80.198]:17745 "EHLO
        sender-op-o13.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfBSDVT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 22:21:19 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Feb 2019 22:21:18 EST
ARC-Seal: i=1; a=rsa-sha256; t=1550545573; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=aij60hr/TpZYHkv0qKW6u6bNBwTElpuWbC8fyuOFPf2HPjwRm7D8bwSY0nr4JKc65SlnCX6RefHlHchPVt7wYY/9lQk6c5VGH0fUnu7Boq4yA2hGz7LnCGOzvXRQ5ELYhcrM4km/HSmIYL+8nh8ZRtC7trh1QtId2L/hgENAvRg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1550545573; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To:ARC-Authentication-Results; 
        bh=BFO2jXgY3r96FSj14avSGjrAsr4hGhqV222fvkA4+sU=; 
        b=ZnXkzJH/jdhGfCgJ+AxrxF9cYUtcvUDsek2QN+Bj5cJwqIwQzhgt7yi5PFJ8iw+9B7a5hm/8iQDqKrB8+QhsVKyXHmpRRoztmg7o0XF9jSZH45ToW8GNnt0VAzsu5nyE/utHgIjS6UNPuGoBb+kPE/1woWP38iDKVBcBYie6ixo=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=dlrobertson.com;
        spf=pass  smtp.mailfrom=dan@dlrobertson.com;
        dmarc=pass header.from=<dan@dlrobertson.com> header.from=<dan@dlrobertson.com>
Received: from nessie.verizon.net (pool-100-15-144-194.washdc.fios.verizon.net [100.15.144.194]) by mx.zohomail.com
        with SMTPS id 155054557150443.79394515512354; Mon, 18 Feb 2019 19:06:11 -0800 (PST)
From:   Dan Robertson <dan@dlrobertson.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Dan Robertson <dan@dlrobertson.com>
Message-ID: <20190219025643.20382-1-dan@dlrobertson.com>
Subject: [PATCH] fs/btrfs: init csum_list before possible free
Date:   Tue, 19 Feb 2019 02:56:43 +0000
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The scrub_ctx csum_list member must be initialized before
scrub_free_ctx is called. If the csum_list is not initialized
beforehand, the list_empty call in scrub_free_csums will result
in a null deref.

Signed-off-by: Dan Robertson <dan@dlrobertson.com>
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6dcd36d7b849..1e08ad1fe2aa 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -584,6 +584,7 @@ static noinline_for_stack struct scrub_ctx *scrub_setup_ctx(
 	sctx->pages_per_rd_bio = SCRUB_PAGES_PER_RD_BIO;
 	sctx->curr = -1;
 	sctx->fs_info = fs_info;
+	INIT_LIST_HEAD(&sctx->csum_list);
 	for (i = 0; i < SCRUB_BIOS_PER_SCTX; ++i) {
 		struct scrub_bio *sbio;
 
@@ -608,7 +609,6 @@ static noinline_for_stack struct scrub_ctx *scrub_setup_ctx(
 	atomic_set(&sctx->workers_pending, 0);
 	atomic_set(&sctx->cancel_req, 0);
 	sctx->csum_size = btrfs_super_csum_size(fs_info->super_copy);
-	INIT_LIST_HEAD(&sctx->csum_list);
 
 	spin_lock_init(&sctx->list_lock);
 	spin_lock_init(&sctx->stat_lock);
-- 
2.20.1



