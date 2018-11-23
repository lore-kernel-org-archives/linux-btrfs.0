Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89120C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 10:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E29320820
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 10:11:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="TQlqsjtx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E29320820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=163.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409253AbeKWUyy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 15:54:54 -0500
Received: from m12-11.163.com ([220.181.12.11]:50115 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393883AbeKWUyy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 15:54:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=icHIWunFbiRtJzIRcC
        0uS1zytXEq3qTYVVTD+GKmUy0=; b=TQlqsjtxeKjYAoQxQEFGvnC4HVZlSNwam5
        /9BdzFLK+IxiJiP1AWY4gI64CwRt6sk24sDle5FbatJ25sEWC0fsqXgX19MC9CNm
        J3hMJmjnr/m1n5RVMxqQ0Skz8bYMx1pOU+AAYZCpC0I4Gi2use9+PZEj4FYV21to
        I8GiXAKgk=
Received: from bp.localdomain (unknown [106.120.213.96])
        by smtp7 (Coremail) with SMTP id C8CowACnVJYG0vdbwcgtBg--.58364S3;
        Fri, 23 Nov 2018 18:10:18 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH] btrfs: relocation: set trans to be NULL after free
Date:   Fri, 23 Nov 2018 18:10:15 +0800
Message-Id: <1542967815-14547-1-git-send-email-bianpan2016@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: C8CowACnVJYG0vdbwcgtBg--.58364S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrurWUtr13Zw45AFWUAryUAwb_yoWDWrX_WF
        4xtrs2ywn5Xry3CFn0krs5JFZak34FgF1DWwn5t3yakay3ArZ0qr4DXws3Xrs8W398GryY
        qrZ5Zw18C34fWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnsXo7UUUUU==
X-Originating-IP: [106.120.213.96]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/1tbiDhMIclXlpkg5VwABsW
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The function relocate_block_group calls btrfs_end_transaction to release
trans when update_backref_cache returns 1, and then continues the loop
body. If btrfs_block_rsv_refill fails this time, it will jump out the
loop and the freed trans will be accessed. This may result in a
use-after-free bug. The patch assigns NULL to trans after trans is
released so that it will not be accessed.

Fixes: 0647bf564f1("Btrfs: improve forever loop when doing balance
relocation")

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 fs/btrfs/relocation.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 924116f..a3f75b8 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3959,6 +3959,7 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 restart:
 		if (update_backref_cache(trans, &rc->backref_cache)) {
 			btrfs_end_transaction(trans);
+			trans = NULL;
 			continue;
 		}
 
-- 
2.7.4


