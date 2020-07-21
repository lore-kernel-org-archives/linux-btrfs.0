Return-Path: <SRS0=UEav=BA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9A6C433EA
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF18220702
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 Jul 2020 14:22:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="QGFGlXkx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgGUOWx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 10:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGUOWw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Jul 2020 10:22:52 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786D3C061794
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2020 07:22:52 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id x62so16244417qtd.3
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2020 07:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WorHgh3XdORBwTTO2L96ZEeCw22GHFGFH11maoGi0Bg=;
        b=QGFGlXkxPeJG3ELaUBiAqavmzxpGRwzZoXl7dA72J3nFgyU3pUbWQwkexy9uMKPRy4
         ylwgUe0wSk6KhbBtFlfEGv0BQLvUDIMHyiKyVdseVtY5k7RNwef5RcrOba6S5TPvVU/o
         FXQHrLBmHlE13Q25j4aYhwgbTC1bf+KkpVNLHf2+2sua38slCQfVDx+wH1hnG/A94+QQ
         r4O9ZwOT+1WkYbwdbRqusUpKtKF1ppQ3ovHhWpYaRSpz52HSVQYUU7g6Nk5cFYzZ8UAH
         za1kLjxSTl95BV7sCqebbX5KDnv9WEBJellO7Xxfbt5uH4A/gqbEVGdczwjnmNkvAhKI
         tr3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WorHgh3XdORBwTTO2L96ZEeCw22GHFGFH11maoGi0Bg=;
        b=W+hzPAO2QIbNAylzB04kW+Sg9JN/2Pn+g/7LfoVFMbWbEOFC89QQwRDV4MVMH2hp7n
         52W2eLACHH2pd4EloqUJCgFT6rSWasTQFBgIxAVbh0Fh9qzXnAY/4HnUVPWLjjZ6LZ7f
         xUl0x3qyIObtJFyDtFcI4dJZOvey6/2llhhj0yRAB5qznmzwZ/JwCdlQzZKaxsls9XO3
         xcX6zZeH+stP+P/7p+lS4fzMOCsv87OEQwoU+vCCz/09/TqpiWF8Rw7opurcm20twUiF
         cv4KHL52NnyNob9lPL755FF+tw3KpF/rvpXSe7jpDI/QkaMXeme3D+Mq5XRorm/wQU75
         aQxw==
X-Gm-Message-State: AOAM530ToVZX1p+Z2oeDLfsI80jZK3lpMJ+q31AYI+/ErtRQFq8KRrU5
        VmekIKTCf6k+KB3W6FjTDW6A8Bd5I10skA==
X-Google-Smtp-Source: ABdhPJxTREqwkHwh2CHZiF/XQcrFauVcLe8yw1NiJ0CU6o0FF+TUZEk0T2keLcBufEL2PeTidHzcmw==
X-Received: by 2002:ac8:c8:: with SMTP id d8mr30745544qtg.221.1595341371348;
        Tue, 21 Jul 2020 07:22:51 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id n184sm2510839qkn.49.2020.07.21.07.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 07:22:50 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 07/23] btrfs: call btrfs_try_granting_tickets when unpinning anything
Date:   Tue, 21 Jul 2020 10:22:18 -0400
Message-Id: <20200721142234.2680-8-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200721142234.2680-1-josef@toxicpanda.com>
References: <20200721142234.2680-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When unpinning we were only calling btrfs_try_granting_tickets() if
global_rsv->space_info == space_info, which is problematic because we
use ticketing for SYSTEM chunks, and want to use it for DATA as well.
Fix this by moving this call outside of that if statement.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 61ede335f6c3..fcef024a2934 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2844,11 +2844,10 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 				len -= to_add;
 			}
 			spin_unlock(&global_rsv->lock);
-			/* Add to any tickets we may have */
-			if (len)
-				btrfs_try_granting_tickets(fs_info,
-							   space_info);
 		}
+		/* Add to any tickets we may have */
+		if (!readonly && return_free_space && len)
+			btrfs_try_granting_tickets(fs_info, space_info);
 		spin_unlock(&space_info->lock);
 	}
 
-- 
2.24.1

