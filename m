Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3630C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71FCB2081B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:23:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71FCB2081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbeK1OXG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:23:06 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:18162 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726894AbeK1OXG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:23:06 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48767156"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:23:01 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 589EE4B6ED56
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:23:00 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 28 Nov
 2018 11:23:06 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] btrfs: cleanup the useless DEFINE_WAIT in cleanup_transaction
Date:   Wed, 28 Nov 2018 11:22:54 +0800
Message-ID: <20181128032254.11625-1-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181128032130.11452-1-lufq.fnst@cn.fujitsu.com>
References: <20181128032130.11452-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 589EE4B6ED56.A91C4
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When it is introduced at commit f094ac32aba3 ("Btrfs: fix NULL pointer
after aborting a transaction"), it's useless.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f92c0a88c4ad..67e84939b758 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1840,7 +1840,6 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans, int err)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_transaction *cur_trans = trans->transaction;
-	DEFINE_WAIT(wait);
 
 	WARN_ON(refcount_read(&trans->use_count) > 1);
 
-- 
2.19.2



