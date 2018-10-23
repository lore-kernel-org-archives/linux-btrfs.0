Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD83C67863
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0976020665
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0976020665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbeJWR5T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 13:57:19 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2023 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728020AbeJWR5T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 13:57:19 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46602834"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 23 Oct 2018 17:34:43 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id B0F9E4B6EDAD
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2018 17:34:39 +0800 (CST)
Received: from archlinux.g08.fujitsu.local (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 23 Oct 2018 17:34:45 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 07/13] btrfs-progs: lowmem: delete unaligned bytes extent data under repair
Date:   Tue, 23 Oct 2018 17:41:41 +0800
Message-ID: <20181023094147.7906-8-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: B0F9E4B6EDAD.AE90F
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If found a extent data item has unaligned part, lowmem repair
just deletes it.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 3c9ecff7e498..5381096fa8b2 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2972,6 +2972,7 @@ out:
 }
 
 /*
+ * If @err contains BYTES_UNALIGNED then delete the extent data item.
  * If @err contains BACKREF_MISSING then add extent of the
  * file_extent_data_item.
  *
@@ -3023,6 +3024,13 @@ static int repair_extent_data_item(struct btrfs_root *root,
 	else
 		parent = 0;
 
+	if (err & BYTES_UNALIGNED) {
+		ret = delete_item(root, pathp);
+		if (!ret)
+			err = 0;
+		goto out;
+	}
+
 	/* now repair only adds backref */
 	if ((err & BACKREF_MISSING) == 0)
 		return err;
-- 
2.19.1



