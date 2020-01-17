Return-Path: <SRS0=6qVc=3G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF5C2C33C9E
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Jan 2020 21:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92BEE2072E
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Jan 2020 21:26:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="0wg7FUW8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgAQV0s (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 16:26:48 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36104 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAQV0s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Jan 2020 16:26:48 -0500
Received: by mail-qk1-f196.google.com with SMTP id a203so24179877qkc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jan 2020 13:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3pyxPNY94oOXrEeZK2hUi64+WTr11ylLgHcJGK8aNDE=;
        b=0wg7FUW8jT1XxFa8HcYBCqozt+bpbM4MDhhhjBcUgSS81SjOQATtXYBsJUUfvziUpb
         UetH7KcXhewrk+xi49htg6i6YEkCxMZP3SSlYgQf5Bi3xZUO137Hm8wolaVvhJXbuVxw
         d1hOvNTobFOHHYExMsKMGk76jP9XzD258Ma+2l7IJH4T42Qs5AhEgVk9fK+Es0f09Aj9
         qn0G4z/Qlfe4foFOdm41YTFVV7CTvcJ8l55UFwW5JTvVlyw3thnJwfaYVCYFXYVgthPy
         4QT3ByegWFs1XHy4ulbqTSyQiVMCSb4u75ElT9eU3pXzVDzSA/2JgkUft59sG6AmXAH9
         vIHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3pyxPNY94oOXrEeZK2hUi64+WTr11ylLgHcJGK8aNDE=;
        b=ilZ/nKxyqLQz2/VHg5Bn2F5AZ3QmjgBzK4L2DkbNAVS6mLR5fiz1MbPWf6NfLRxDqv
         tjV3hyVql9rO3bbB40YRj+qbrxhpXsOPK/Gwwvov/LdHeH/j9vQgJc8gV678WAZBSZh/
         F1x/qGs2B5ZlWZc7NC3PjiREiekn145EM3V5bNrZSNto1gI05BC+BjS2MqDWH5HOuwjv
         15z08tlJOgPbA0u/MxPtgk6qalHhTfUIFyD4fIk1skwXdIfOMj6vVan1DNN2uZzbfAyO
         a5+FkXIzu8InWk2Bj1K0buSX3dr/NmIbiPBBzcveMM4r9lJGgwTAkLl1jpBfMDS7s+Lo
         X5yQ==
X-Gm-Message-State: APjAAAVqBKmXTQZoScYwWdKqIw3TfZg8pMkcs841+O5drT7/FbkaHi3z
        +arsdqEjXgCsCnbFcyVr/YT/wEyG9h+oEQ==
X-Google-Smtp-Source: APXvYqzLwCpRV8Cqx6cXcBtKnWK+cwMGLhZBuykxu+0YepJhcQowOucwt1qyEOxNYj+VfDBmqpfD9Q==
X-Received: by 2002:a37:454d:: with SMTP id s74mr36100717qka.104.1579296406701;
        Fri, 17 Jan 2020 13:26:46 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id u16sm12355436qku.19.2020.01.17.13.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 13:26:46 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 23/43] btrfs: hold a ref on the root in merge_reloc_roots
Date:   Fri, 17 Jan 2020 16:25:42 -0500
Message-Id: <20200117212602.6737-24-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117212602.6737-1-josef@toxicpanda.com>
References: <20200117212602.6737-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We look up the corresponding root for the reloc root, we need to hold a
ref while we're messing with it.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/relocation.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 53df57b59bc3..79430a4245b5 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2546,10 +2546,13 @@ void merge_reloc_roots(struct reloc_control *rc)
 		if (btrfs_root_refs(&reloc_root->root_item) > 0) {
 			root = read_fs_root(fs_info,
 					    reloc_root->root_key.offset);
+			if (!btrfs_grab_fs_root(root))
+				BUG();
 			BUG_ON(IS_ERR(root));
 			BUG_ON(root->reloc_root != reloc_root);
 
 			ret = merge_reloc_root(rc, root);
+			btrfs_put_fs_root(root);
 			if (ret) {
 				if (list_empty(&reloc_root->root_list))
 					list_add_tail(&reloc_root->root_list,
-- 
2.24.1

