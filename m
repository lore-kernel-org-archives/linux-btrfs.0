Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCEF2C71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 874542087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="WXFF5zcw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 874542087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbeJMDHt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:49 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:32965 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbeJMDHt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:49 -0400
Received: by mail-qk1-f195.google.com with SMTP id 84-v6so8372084qkf.0
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=l5PjtYy8R8KZGhwEXTXGsXgmvOxQha2RMnXjcyOlSUU=;
        b=WXFF5zcwa0S4zbrj1/vMHw7MNq9HM4/q/GYYjj2QASJUyzDfv9QN20ieIz011tqLwX
         X/4aLk9dkILVKMe0kIudbMECme1yN/s0FDgDuMYFs7wosAnQRPM0MAEuxxdlJgEczd4i
         TGPIsLL6EU6D9JKbmkPSPCKyysvm/P7+SGZP6jv8UYTkgBTkWS2sGGXBcwoUTXktTNT3
         FiHuX7Nh3JGz0ADIe8q/tyacANvETtFMMehFNCKZhbsEZwEESfZpbE8lWV4dyELaQ5gI
         mRlrlky9H/BgvgScQMlSPIwNzZ4Ig8qk2inRYRgSyRux0ud0eZJogJp99dZZl4d1hRtG
         C8HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=l5PjtYy8R8KZGhwEXTXGsXgmvOxQha2RMnXjcyOlSUU=;
        b=tv5rqA3/tygEcksvvf7RM1OzbQJLOtRF/KXKHEe3eb/LacLFQ946yWiuBGdkCZgXGM
         tY5q/3tzItbrFn3he5OsYOSnvxcqwmHJ0taLnt5VPHbgvdtisDv2LrdASW1I0DH/UP0m
         uB/xo/cPEQqqhDJAzvpzcCtinLrLnPJ9X07gNku9k9jrwAPa328wwLvuAZtYQ0KHHSGA
         nW8nwzc9SL7e6iCbtV7/lCXkZBPheTuSCCt+HZu4C4kuNiJirSnqROhGB4++c0Cgd8KJ
         hUKAlu9xKroRqHMO1F30G3CIMmqmzU5VhhR90GYmT1zad5wG+XkeVtyqaKWd1hSoCluG
         RPbw==
X-Gm-Message-State: ABuFfogCdkrezdXxIfGd5Pp1X3hfFuf61z5g/B1qw5mhvZ6GCgUZOLDf
        9J3b71zn0FWgvs4BFMYQi5kNR6vy9N0=
X-Google-Smtp-Source: ACcGV63rcMzFFZKhPuH/crjgI1EgnyeFgIsOwPE10olzItQ8JDchuzqoXrPkMpa4mKy7Us++HdT1gg==
X-Received: by 2002:a37:a9cd:: with SMTP id s196-v6mr7059826qke.342.1539372827954;
        Fri, 12 Oct 2018 12:33:47 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id j18-v6sm1986821qkh.20.2018.10.12.12.33.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:47 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 21/42] btrfs: reset max_extent_size on clear in a bitmap
Date:   Fri, 12 Oct 2018 15:32:35 -0400
Message-Id: <20181012193256.13735-22-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

We need to clear the max_extent_size when we clear bits from a bitmap
since it could have been from the range that contains the
max_extent_size.

Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/free-space-cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 2dd773e96530..411acffbd45d 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1687,6 +1687,8 @@ static inline void __bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
 	bitmap_clear(info->bitmap, start, count);
 
 	info->bytes -= bytes;
+	if (info->max_extent_size > ctl->unit)
+		info->max_extent_size = 0;
 }
 
 static void bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
-- 
2.14.3

