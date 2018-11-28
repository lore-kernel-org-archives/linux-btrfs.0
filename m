Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3B7C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89D142086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:07:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89D142086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbeK1OHk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:07:40 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:3979 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726847AbeK1OHk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:07:40 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766435"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:07:37 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 9554E4B7349D
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:07:37 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 28 Nov
 2018 11:07:43 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH] btrfs: drop file privileges in btrfs_clone_files
Date:   Wed, 28 Nov 2018 11:07:31 +0800
Message-ID: <20181128030731.10288-1-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 9554E4B7349D.A75BA
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The generic/513 tell that cloning into a file did not strip security
privileges (suid, capabilities) like a regular write would.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
The xfs and ocfs2 call generic_remap_file_range_prep to drop file
privileges, I'm not sure whether btrfs should do the same thing.

Any suggestion?

 fs/btrfs/ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 410c7e007ba8..bc33c480603b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4312,6 +4312,10 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 			goto out_unlock;
 	}
 
+	ret = file_remove_privs(file);
+	if (ret)
+		goto out_unlock;
+
 	if (destoff > inode->i_size) {
 		ret = btrfs_cont_expand(inode, inode->i_size, destoff);
 		if (ret)
-- 
2.19.2



