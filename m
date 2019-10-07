Return-Path: <SRS0=vnEf=YA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2331ECE58C
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Oct 2019 20:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AF62206C0
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Oct 2019 20:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570479498;
	bh=D31kpMZdemBL4AvwfO1SPZXqb63/b8azMJhrtAQDsaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
	 References:List-ID:From;
	b=qLKvav1D2XTwP2SdVaaVck2NqEXzl9kHJm3nZHdG8ukwO7qGrCEW40AKiTDdJEm2X
	 lHoSo+m3v/GfMaOfH/+nxc6s2IoSmoG7vpvc5shj9OIHIWxurM5biMLG5is7s1Sssv
	 Ye3cjFqzExrfK8Ekff9UiXA0FVk6bfzZ3BR6+Yv0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbfJGUSP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 16:18:15 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42487 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729005AbfJGUSN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2019 16:18:13 -0400
Received: by mail-qt1-f196.google.com with SMTP id w14so21099046qto.9
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Oct 2019 13:18:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=h6IDdT8ZUNSTQuRSOYxObXBD5gIilW4iPVId/v0phQU=;
        b=B9RKS25D8U+aSy87yyy3BxK5058OiNvSdK785rXpKVoADcYJ15uuGdx00uBfnHr66j
         03PuK5wSjqyk9PW1JfCwwRZQOV8iOWbA+/CUjSm5t5DdBAXscNMT7XKBWA9sGhRSUghx
         bN3/e00fE1n5uvOSG2hUSWxWL3nLN/n/7VoeoxedJgTke4YuN2xHwNBerQDF4njjL0TR
         9ARE7BokaTbsjwJUW8pav85WOghsJZCPaf3Gbk8C99Yd2m+yEKOrCiw8CDivw+R/7U57
         IjkAqo1lALK+JXtY/G7/RMu9iZY1u77pBIrrVDOHaF8sSWUqcSDFvw2+7xbR9NbCY6gk
         x7Mg==
X-Gm-Message-State: APjAAAWagYVLJUY3BHoH/lfsUfiCRcORM84Ns2q+owcFAaHF5ENDp8oi
        UBlcLqKgYPi2xoftousV5eY=
X-Google-Smtp-Source: APXvYqzp4fCKXNPmXgURk7DofpSCKHK8tG/AraAzvHzTm6nu/Bj4htVjWUxkLKI3Yo8CAY0Hu3tk4Q==
X-Received: by 2002:aed:32c6:: with SMTP id z64mr30969422qtd.202.1570479492407;
        Mon, 07 Oct 2019 13:18:12 -0700 (PDT)
Received: from dennisz-mbp.thefacebook.com ([163.114.130.128])
        by smtp.gmail.com with ESMTPSA id k2sm6904005qtm.42.2019.10.07.13.18.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 07 Oct 2019 13:18:11 -0700 (PDT)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@osandov.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 17/19] btrfs: add async discard header
Date:   Mon,  7 Oct 2019 16:17:48 -0400
Message-Id: <497ce83624b2d2947ce85a8381f39123bd4e7a53.1570479299.git.dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <cover.1570479299.git.dennis@kernel.org>
References: <cover.1570479299.git.dennis@kernel.org>
In-Reply-To: <cover.1570479299.git.dennis@kernel.org>
References: <cover.1570479299.git.dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Give a brief overview for how async discard is implemented.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 fs/btrfs/discard.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/fs/btrfs/discard.c b/fs/btrfs/discard.c
index f0088ca19d28..61e341685acd 100644
--- a/fs/btrfs/discard.c
+++ b/fs/btrfs/discard.c
@@ -1,6 +1,40 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (C) 2019 Facebook.  All rights reserved.
+ *
+ * This contains the logic to handle async discard.
+ *
+ * Async discard manages trimming of free space outside of transaction commit.
+ * Discarding is done by managing the block_groups on a LRU list based on free
+ * space recency.  Two passes are used to first prioritize discarding extents
+ * and then allow for trimming in the bitmap the best opportunity to coalesce.
+ * The block_groups are maintained on multiple lists to allow for multiple
+ * passes with different discard filter requirements.  A delayed work item is
+ * used to manage discarding with timeout determined by a max of the delay
+ * incurred by the iops rate limit, byte rate limit, and the timeout of max
+ * delay of BTRFS_DISCARD_MAX_DELAY.
+ *
+ * The first list is special to manage discarding of fully free block groups.
+ * This is necessary because we issue a final trim for a full free block group
+ * after forgetting it.  When a block group becomes unused, instead of directly
+ * being added to the unused_bgs list, we add it to this first list.  Then
+ * from there, if it becomes fully discarded, we place it onto the unused_bgs
+ * list.
+ *
+ * The in-memory free space cache serves as the backing state for discard.
+ * Consequently this means there is no persistence.  We opt to load all the
+ * block groups in as not discarded, so the mount case degenerates to the
+ * crashing case.
+ *
+ * As the free space cache uses bitmaps, there exists a tradeoff between
+ * ease/efficiency for find_free_extent() and the accuracy of discard state.
+ * Here we opt to let untrimmed regions merge with everything while only letting
+ * trimmed regions merge with other trimmed regions.  This can cause
+ * overtrimming, but the coalescing benefit seems to be worth it.  Additionally,
+ * bitmap state is tracked as a whole.  If we're able to fully trim a bitmap,
+ * the trimmed flag is set on the bitmap.  Otherwise, if an allocation comes in,
+ * this resets the state and we will retry trimming the whole bitmap.  This is a
+ * tradeoff between discard state accuracy and the cost of accounting.
  */
 
 #include <linux/jiffies.h>
-- 
2.17.1

