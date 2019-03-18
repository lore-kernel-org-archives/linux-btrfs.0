Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28CDC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAE7E20854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfCRQs6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:48:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:55862 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727130AbfCRQs6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:48:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5C8C0ACFA
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:48:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8F281DA8A7; Mon, 18 Mar 2019 17:50:12 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 03/22] btrfs: tests: print file:line for error messages
Date:   Mon, 18 Mar 2019 17:50:12 +0100
Message-Id: <a11970cc8c40c04d803cfe99c47ecadfa4bc14d4.1552927639.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1552927639.git.dsterba@suse.com>
References: <cover.1552927639.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For better diagnostics print the file name and line to locate the
errors. Sample output:

[    9.052924] BTRFS: selftest: fs/btrfs/tests/extent-io-tests.c:283 offset bits do not match

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/btrfs-tests.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
index 70ff9f9d86a1..bb9e9c234535 100644
--- a/fs/btrfs/tests/btrfs-tests.h
+++ b/fs/btrfs/tests/btrfs-tests.h
@@ -10,7 +10,8 @@
 int btrfs_run_sanity_tests(void);
 
 #define test_msg(fmt, ...) pr_info("BTRFS: selftest: " fmt "\n", ##__VA_ARGS__)
-#define test_err(fmt, ...) pr_err("BTRFS: selftest: " fmt "\n", ##__VA_ARGS__)
+#define test_err(fmt, ...) pr_err("BTRFS: selftest: %s:%d " fmt "\n",	\
+		__FILE__, __LINE__, ##__VA_ARGS__)
 
 struct btrfs_root;
 struct btrfs_trans_handle;
-- 
2.21.0

