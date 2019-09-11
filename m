Return-Path: <SRS0=wB72=XG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DBE3C5ACAE
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Sep 2019 15:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 532E9207FC
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Sep 2019 15:26:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="KEzj8n75"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbfIKP0T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 11 Sep 2019 11:26:19 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36275 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfIKP0T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Sep 2019 11:26:19 -0400
Received: by mail-qt1-f193.google.com with SMTP id o12so25779710qtf.3
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2019 08:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gO+w/U8hMDaFUu707WWbHk/4OoJIRUYRlEDKwVJjTag=;
        b=KEzj8n751DTKS9eivR/Xfdx6ubLsz9JqTG0zKBAGMt6EgEdjZM9ynz9KiHONnFt04H
         OsEU2rbsxblo9sc5Ua4I26I7h794IxVtA8bmYmzqHFsaFDOFe7C4nD8RQBr2fYc9upPU
         HYYiW4lNZ5pRoruX2aHh36dQBhvqziTT/PXz9RtDtdcgYVa+Uy0/JqDdPq2AD2qGdqbf
         5nc3vtDX9LgjrD3iBkr66+ScvBsyYWADk/cM9Cw9bxLuEUbRIxXKOZajZG0rOX2hkgw9
         KfMFmnw+UCP9guZAhf9Hzvw5ZQlaiKSKtziLhDs50HannIVacjKWxxGujQJc+Hxt8FR/
         4z/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gO+w/U8hMDaFUu707WWbHk/4OoJIRUYRlEDKwVJjTag=;
        b=CmCXZ3P5xcpRQY1u6hAMXOtrddoA5AeC+MmEeSQJQIIxBIVzGd+rtkLPRHlKUdTzV3
         LVULExizvx4yU1TKCx3SYi6We1YTeeGeSKS2gCRg5W77OmctXQXQj2IEM0Qf/FtwtYbW
         FT6ZEmindOIQcdn44vJudxJ9+MwpndJlhRsUstwCd/9OnBqki8C0cgSuvd7iV4ZTmYSF
         0e4njhakXmTF0sVjsCKb/BboDWW+xg7qiWFxesfneNCctuwNTb+z5I392izNix/eyjE7
         N7V8y8ns2uEZtlthOAqUeHX3exJkFVuoeZa+4utk2ojE9aLcvKbW1aqx8IRz3iXfgcDf
         rXMg==
X-Gm-Message-State: APjAAAUtnOCaG5m0MpQE9AspfabYd2UikKX5rP8JfI664xwLmnzfx0kZ
        R6+qKlpBzlIScnNaGvQKgz7q5ET2qc5RJw==
X-Google-Smtp-Source: APXvYqwC9Bzr1a8oMIUJgKFqi46/GHdKfyNYyCvQHix6ooKTcYjM8yduye5FVohME4G8QWMM5sZhvQ==
X-Received: by 2002:a0c:9369:: with SMTP id e38mr22730127qve.25.1568215576505;
        Wed, 11 Sep 2019 08:26:16 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id m19sm10749954qke.22.2019.09.11.08.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 08:26:15 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 1/9] btrfs: separate out the extent leak code
Date:   Wed, 11 Sep 2019 11:26:03 -0400
Message-Id: <20190911152611.3393-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190911152611.3393-1-josef@toxicpanda.com>
References: <20190911152611.3393-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We check both extent buffer and extent state leaks in the same function,
separate these two functions out so we can move them around.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent_io.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4dc5e6939856..b4b786a9d870 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -60,7 +60,19 @@ void btrfs_leak_debug_del(struct list_head *entry)
 }
 
 static inline
-void btrfs_leak_debug_check(void)
+void btrfs_extent_buffer_leak_debug_check()
+{
+	while (!list_empty(&buffers)) {
+		eb = list_entry(buffers.next, struct extent_buffer, leak_list);
+		pr_err("BTRFS: buffer leak start %llu len %lu refs %d bflags %lu\n",
+		       eb->start, eb->len, atomic_read(&eb->refs), eb->bflags);
+		list_del(&eb->leak_list);
+		kmem_cache_free(extent_buffer_cache, eb);
+	}
+}
+
+static inline
+void btrfs_extent_state_leak_debug_check(void)
 {
 	struct extent_state *state;
 	struct extent_buffer *eb;
@@ -74,14 +86,6 @@ void btrfs_leak_debug_check(void)
 		list_del(&state->leak_list);
 		kmem_cache_free(extent_state_cache, state);
 	}
-
-	while (!list_empty(&buffers)) {
-		eb = list_entry(buffers.next, struct extent_buffer, leak_list);
-		pr_err("BTRFS: buffer leak start %llu len %lu refs %d bflags %lu\n",
-		       eb->start, eb->len, atomic_read(&eb->refs), eb->bflags);
-		list_del(&eb->leak_list);
-		kmem_cache_free(extent_buffer_cache, eb);
-	}
 }
 
 #define btrfs_debug_check_extent_io_range(tree, start, end)		\
@@ -105,7 +109,8 @@ static inline void __btrfs_debug_check_extent_io_range(const char *caller,
 #else
 #define btrfs_leak_debug_add(new, head)	do {} while (0)
 #define btrfs_leak_debug_del(entry)	do {} while (0)
-#define btrfs_leak_debug_check()	do {} while (0)
+#define btrfs_extent_buffer_leak_debug_check()	do {} while (0)
+#define btrfs_extent_state_leak_debug_check()	do {} while (0)
 #define btrfs_debug_check_extent_io_range(c, s, e)	do {} while (0)
 #endif
 
@@ -235,7 +240,8 @@ int __init extent_io_init(void)
 
 void __cold extent_io_exit(void)
 {
-	btrfs_leak_debug_check();
+	btrfs_extent_buffer_leak_debug_check();
+	btrfs_extent_state_leak_debug_check();
 
 	/*
 	 * Make sure all delayed rcu free are flushed before we
-- 
2.21.0

