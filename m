Return-Path: <SRS0=K7fm=6X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A5E5C28CBC
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 May 2020 05:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B13020736
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 May 2020 05:27:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PNXDweui"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgEIF12 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 9 May 2020 01:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728662AbgEIF12 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 May 2020 01:27:28 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D879AC061A0C;
        Fri,  8 May 2020 22:27:27 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z1so2095751pfn.3;
        Fri, 08 May 2020 22:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zoFA6VdYSfRZGFLq/UlQ0f7xhnJ9z2WuMaRDbctPxQk=;
        b=PNXDweuigCDujhsl3G5xltaia8JU6hyGMrYGgGSlfVTC1GEbxtRfx8nhEp9eQMzxDc
         hBy9IhKb1kSphs8Pv3SqwrZxlpnm2J228Dj1n0FFUAxgVbQ9t2cdGJllKvFTs06R6eny
         Bjll9TL05ACKnrcuXou06s+InixjwmOEZdiN/NZ4DdBazxcU5dQx8BSIUU3nDjmQi2vO
         df0LgF9zyzcVFVpozVp7khdwVZ7d3i6fqZ6XMcBF/+Y7mjLgD6YNCauTNeUt+lfBmsC6
         ImhUnP/muWY/ZMeArWpDdx+tgdkrQ69CJSP54DB4i00CB88IG06xR9vu4PHfaRfe82SG
         oHdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zoFA6VdYSfRZGFLq/UlQ0f7xhnJ9z2WuMaRDbctPxQk=;
        b=dcZdvgYTuSEdeLsRgbcYPgBBHyxlAmdLlDmWwXQkh9AJ7RYRTOzw6Mf+GN4G9CGAWj
         7lmqfI8w5C8QgNB+jchi8Tq+8oqjkruJAHMy4HccIA8jMviAZQ4A1zny0XAKQ+Tt5kLj
         aXQ3sQXTnFLIexNPPcyGO+pHsYgMvzKotPDok6V75xDuBsHCOnpA2WrTC9NIC9UvSpc2
         yVaF7NkAZsgpWtb8Sel1KeqsW84S70kOognQgX9imAsjRT5+ewaJAGUdCELiix5gKFo1
         zQkuUhRi0PzNsc9zpNmKBlcY5pseS4RhdL9/whs9wpuue5TQTIvhhty73S+YlB5AMOa7
         5dAg==
X-Gm-Message-State: AGi0PuaL7URWlGbpERqZE6Ru4dr/XYi0MVIQ48ndlLsExcBO38qD9aZo
        TpXZoyW6yimFuy/ko4p8G7I=
X-Google-Smtp-Source: APiQypIx21HMxoy9ECPPHjTHpK2Dui0Sorwd5J+JP8NkSEgfnnD6JgYSO3pVRM6Qh+AcS1XMplog9A==
X-Received: by 2002:aa7:83c8:: with SMTP id j8mr6447874pfn.272.1589002047407;
        Fri, 08 May 2020 22:27:27 -0700 (PDT)
Received: from localhost.localdomain ([223.72.62.216])
        by smtp.gmail.com with ESMTPSA id 141sm3558021pfz.171.2020.05.08.22.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 22:27:26 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 2/4] fs: btrfs: fix data races in extent_write_cache_pages()
Date:   Sat,  9 May 2020 13:27:01 +0800
Message-Id: <20200509052701.3156-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The function extent_write_cache_pages is concurrently executed with
itself at runtime in the following call contexts:

Thread 1:
  btrfs_sync_file()
    start_ordered_ops()
      btrfs_fdatawrite_range()
        btrfs_writepages() [via function pointer]
          extent_writepages()
            extent_write_cache_pages()

Thread 2:
  btrfs_writepages() 
    extent_writepages()
      extent_write_cache_pages()

In extent_write_cache_pages():
  index = mapping->writeback_index;
  ...
  mapping->writeback_index = done_index;

The accesses to mapping->writeback_index are not synchronized, and thus
data races for this value can occur.
These data races were found and actually reproduced by our concurrency 
fuzzer.

To fix these races, the spinlock mapping->private_lock is used to
protect the accesses to mapping->writeback_index.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 fs/btrfs/extent_io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 39e45b8a5031..8c33a60bde1d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4160,7 +4160,9 @@ static int extent_write_cache_pages(struct address_space *mapping,
 
 	pagevec_init(&pvec);
 	if (wbc->range_cyclic) {
+		spin_lock(&mapping->private_lock);
 		index = mapping->writeback_index; /* Start from prev offset */
+		spin_unlock(&mapping->private_lock);
 		end = -1;
 		/*
 		 * Start from the beginning does not need to cycle over the
@@ -4271,8 +4273,11 @@ static int extent_write_cache_pages(struct address_space *mapping,
 			goto retry;
 	}
 
-	if (wbc->range_cyclic || (wbc->nr_to_write > 0 && range_whole))
+	if (wbc->range_cyclic || (wbc->nr_to_write > 0 && range_whole)) {
+		spin_lock(&mapping->private_lock);
 		mapping->writeback_index = done_index;
+		spin_unlock(&mapping->private_lock);
+	}
 
 	btrfs_add_delayed_iput(inode);
 	return ret;
-- 
2.17.1

