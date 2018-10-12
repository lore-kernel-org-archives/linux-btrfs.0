Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C02C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 08:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12FB92086A
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 08:25:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="RhWGKIH3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12FB92086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=synology.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbeJLP5B (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 11:57:01 -0400
Received: from synology.com ([59.124.61.242]:44577 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727484AbeJLP5A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 11:57:00 -0400
Received: from localhost.localdomain (unknown [10.13.20.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by synology.com (Postfix) with ESMTPSA id CCEC41B6388B;
        Fri, 12 Oct 2018 16:25:40 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1539332740; bh=YjEqG2BBHBkMENmLjuKna+75e7Uc+kcPPTJzuiWBwko=;
        h=From:To:Cc:Subject:Date;
        b=RhWGKIH3l+lXqGfqZLwfSvV+0opMJXO/T1xquU9XVagEQ9TvfAbwe1LI6BJ/ZHryA
         5AR4kJhle8U2RXfpkpuD+vbWJYFBLg1o7hRJUmB9M5E6kJu0bQ45G78CW6xXv167V8
         ArwqkEk+tYSIADGUH8SJhMRq5bMs5LidY/D5ffEY=
From:   robbieko <robbieko@synology.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Robbie Ko <robbieko@synology.com>
Subject: [PATCH] btrfs-progs: super-recover: fix double free fs_devices memory
Date:   Fri, 12 Oct 2018 16:25:23 +0800
Message-Id: <1539332723-5868-1-git-send-email-robbieko@synology.com>
X-Mailer: git-send-email 1.9.1
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Robbie Ko <robbieko@synology.com>

super-recover collects btrfs devices information using existed
functions scan_one_devices().

Problem is fs_devices is freed twice. One in __open_ctree_fd() when
error happens and the other in btrfs_close_devices(recover.fs_devices)
when root is NULL.

Commit "30fd6f2e92695c355c8f76b8887cd4fade60cdac" add force-close
all opened device before program exit, to avoid memory leak in all
btrfs sub-command.
Therefore, there is an unnecessary freed of fs_devices in
btrfs_recover_superblocks.

Fix this problem by remove unnecessary freed of fs_devices.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 super-recover.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/super-recover.c b/super-recover.c
index 880fd77..86b3df9 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -292,9 +292,6 @@ int btrfs_recover_superblocks(const char *dname,
 no_recover:
 	recover_err_str(ret);
 	free_recover_superblock(&recover);
-	/* check if we have freed fs_devices in close_ctree() */
-	if (!root)
-		btrfs_close_devices(recover.fs_devices);
 	return ret;
 }
 
-- 
1.9.1

