Return-Path: <SRS0=8E82=Z3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE755C2D0C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Dec 2019 13:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B346320675
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 Dec 2019 13:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575552014;
	bh=8grJxlwtuw6DJoz7a+ESOcH6rCdL6YgzcmSif1H4+Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=OObMFEmIrzULss1xkFWRuuPrFthxw/pMRD5UMtbZIcbkzaEF6vzxCHz5isb3PE50Y
	 8p82PSqUmIwkfzJQhdQEr//E29+6KglChp9GLz7cg9XcndfvXWouDYpf0A/A+JQuby
	 2dxCTS3OmkoR3wk5nJbupBVjLV8sggIkEfzDFGZo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbfLENUJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 08:20:09 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51144 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729398AbfLENUI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Dec 2019 08:20:08 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so3778942wmg.0
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Dec 2019 05:20:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uCd5U7DoG4qBbFN1jQxLirgCPg7xjdQna64hhlRmvlI=;
        b=goAwKeAwFCyRyFk1Cw717Qb6c0SEXkQEWYiuc+0HtkQytpSjGbE+1799j2zhC3+UDf
         mIuMnQ/X155hFY5jLZd3DVHxjBPSL0dPwBlFMgVSC2tAA90nEJK4xLwh5EvEH2qBtS0n
         iccEOj/Fc1fGF72g/BZpBhyOnWj5PoCY6AU9rmK4m8+urwghAXyWtAUavL1x4nnu7Yas
         8f7Yw1qm/Nv8irTxYGrCLT40f3SWsBV8GpbpyBsR8Z8dITkY47aXvUuXK2Q+9Q8HQZjy
         shhBSF7R2rCsW+Whl6HkqbLnPoqAV9Djpl/MAgCqxQEef1NrHwaqiL6wozmw4mddZPhR
         6KrQ==
X-Gm-Message-State: APjAAAX5v93/uHiBsrRVZBjZEwYXKU/ifCSVCldSsjP7lVtPQuGsegGJ
        CCX7hUwT/OEYTxxcVrDM3pw=
X-Google-Smtp-Source: APXvYqxEcwRjRhT26Y4VJ/emPseadGTe4SKoCj/kc8ci9HztGBQITvQ4gA6w8jbaB4ERjQSBRWvMcA==
X-Received: by 2002:a05:600c:204:: with SMTP id 4mr5557063wmi.1.1575552006689;
        Thu, 05 Dec 2019 05:20:06 -0800 (PST)
Received: from localhost.localdomain (ppp-46-244-194-187.dynamic.mnet-online.de. [46.244.194.187])
        by smtp.gmail.com with ESMTPSA id f67sm10482515wme.16.2019.12.05.05.20.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Dec 2019 05:20:06 -0800 (PST)
From:   Johannes Thumshirn <jth@kernel.org>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jth@kernel.org>
Subject: [PATCH 1/3] btrfs: fix possible NULL-pointer dereference in integrity checks
Date:   Thu,  5 Dec 2019 14:19:57 +0100
Message-Id: <20191205131959.19184-2-jth@kernel.org>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20191205131959.19184-1-jth@kernel.org>
References: <20191205131959.19184-1-jth@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

A user reports a possible NULL-pointer dereference in
btrfsic_process_superblock(). We are assigning state->fs_info to a local
fs_info variable and afterwards checking for the presence of state.

While we would BUG_ON() a NULL state anyways, we can also just remove the
local fs_info copy, as fs_info is only used once as the first argument for
btrfs_num_copies(). There we can just pass in state->fs_info as well.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=205003
Signed-off-by: Johannes Thumshirn <jth@kernel.org>
---
 fs/btrfs/check-integrity.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 0b52ab4cb964..72c70f59fc60 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -629,7 +629,6 @@ static struct btrfsic_dev_state *btrfsic_dev_state_hashtable_lookup(dev_t dev,
 static int btrfsic_process_superblock(struct btrfsic_state *state,
 				      struct btrfs_fs_devices *fs_devices)
 {
-	struct btrfs_fs_info *fs_info = state->fs_info;
 	struct btrfs_super_block *selected_super;
 	struct list_head *dev_head = &fs_devices->devices;
 	struct btrfs_device *device;
@@ -700,7 +699,7 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
 			break;
 		}
 
-		num_copies = btrfs_num_copies(fs_info, next_bytenr,
+		num_copies = btrfs_num_copies(state->fs_info, next_bytenr,
 					      state->metablock_size);
 		if (state->print_mask & BTRFSIC_PRINT_MASK_NUM_COPIES)
 			pr_info("num_copies(log_bytenr=%llu) = %d\n",
-- 
2.21.0 (Apple Git-122)

