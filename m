Return-Path: <SRS0=P1qN=ZO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B43C43215
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Nov 2019 06:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA1E420708
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Nov 2019 06:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574403455;
	bh=D7hjSmdXK7WHeWT3wuT6ycmjaZRsL2baVYrJHqcHwl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=qiU1Od0hPQHYacDwhT9a2WH71CLwe/ybJ4TahQw1mo6WkJbIKDIlPregMvc5hdqLw
	 vEOf/i0z2Q6UEdBgT8LmGThnnhTRksfKxljKS2XODrwXEdfT4/RgcUcLtqoNeTJ4x/
	 MWXZV1Q1PlDIlLGs/x+WVgMCqD6Wwbl40Xcrwz5s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbfKVGRd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 01:17:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729305AbfKVGNZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Nov 2019 01:13:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F85820714;
        Fri, 22 Nov 2019 06:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403205;
        bh=D7hjSmdXK7WHeWT3wuT6ycmjaZRsL2baVYrJHqcHwl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtlT0FKILjt0Jc7+ZHpHDD4sYAgFJCF5tf5Mr6wFzgxcjhIemf0A8Vymbt3rwIjun
         3iJMMbl9ZJ+y4Q8X3Hpf5xb3ic8nFb6ZMQeA1ThsltdLmvHIFkamJUiL4miHCHkPwd
         sQfUgWk270wuJFL65gJqucf3yzfEeDSNohfeNunQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 21/68] btrfs: only track ref_heads in delayed_ref_updates
Date:   Fri, 22 Nov 2019 01:12:14 -0500
Message-Id: <20191122061301.4947-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

[ Upstream commit 158ffa364bf723fa1ef128060646d23dc3942994 ]

We use this number to figure out how many delayed refs to run, but
__btrfs_run_delayed_refs really only checks every time we need a new
delayed ref head, so we always run at least one ref head completely no
matter what the number of items on it.  Fix the accounting to only be
adjusted when we add/remove a ref head.

In addition to using this number to limit the number of delayed refs
run, a future patch is also going to use it to calculate the amount of
space required for delayed refs space reservation.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-ref.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index e06dd75ad13f9..a2f165029ee62 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -193,8 +193,6 @@ static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
 	ref->in_tree = 0;
 	btrfs_put_delayed_ref(ref);
 	atomic_dec(&delayed_refs->num_entries);
-	if (trans->delayed_ref_updates)
-		trans->delayed_ref_updates--;
 }
 
 static bool merge_ref(struct btrfs_trans_handle *trans,
@@ -444,7 +442,6 @@ add_delayed_ref_tail_merge(struct btrfs_trans_handle *trans,
 add_tail:
 	list_add_tail(&ref->list, &href->ref_list);
 	atomic_inc(&root->num_entries);
-	trans->delayed_ref_updates++;
 	spin_unlock(&href->lock);
 	return ret;
 }
-- 
2.20.1

