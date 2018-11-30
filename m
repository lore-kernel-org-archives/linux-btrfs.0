Return-Path: <SRS0=Nx1q=OJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F092C64EB4
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 16:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFF8C20867
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 16:52:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="KvCLEA5D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFF8C20867
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbeLAECQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Nov 2018 23:02:16 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:34871 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbeLAECQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Nov 2018 23:02:16 -0500
Received: by mail-yb1-f193.google.com with SMTP id z2-v6so2465977ybj.2
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2018 08:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YafhEERTli8qMT9FDPqqH8cgoD5ts4/0PmcAj1r+z9c=;
        b=KvCLEA5D/2btoWolOwjR+E+RsJbGZgZEVkE4FTvUnzjAPsI/Q7emDOJSCuHRZZP13w
         0CzNtKZC9I9aW8SIuWXc+YdbOchneDK9kJ6DTnCUhRQIwAqT97piDkAfBCf5NGnn6doE
         PC8475noJdxShb9EpoYNrfoNrUFLRoz2NAjz1zj6iQdIiAdZ0caghTDPpxfeSg5yQYoH
         iBkGy2r7ZT0RVIVcvEDO1UfpiS+J8+3tQfDEkic2MWfCwyCSy+gNKAEJtrLT9ByEtX2x
         HiHGC6hrkZdLOeKQtKvNtzHOp6N+8ZWLp6QkviKhwtiICjtsSKCrn0/RbhHPwMZL8EOa
         K9uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YafhEERTli8qMT9FDPqqH8cgoD5ts4/0PmcAj1r+z9c=;
        b=Yg+rSddPQlQpdrvObySfKalduN7rQO6SR6ozuqtUZLPWgIs0Fpp3K+KCckbRmGONoq
         9qmRgHSzte2bSOm1QmoY7eS7SwVvmmZIF3P4R96Ip30Bs/TnjjDeROO0qFiVgQBrWfm9
         4/GC8b8HCl2nGJ4cVzdO5wn10Cn1zmoI7Z7ncJWIAgbol4jRGQ3QPqyNOCOwUSqQpDiB
         +1ypyYoT1Rr6Sm3noMG6fzmtL5nJdQYj0R90Y7mHLWI6T+rsP3HD8eFGuvST007n7oh+
         tAo2So8gBVhg7VdImLUDZzRVT6cJ+m0utWxmlXcXuwyDpXHqWaFHI7yRFdP/XlBmeGWN
         lqBA==
X-Gm-Message-State: AA+aEWaFP9tPlShTue+1d3da0rMXERzGBw9yREH1FBXRXvUUPG5GYfwn
        T7A9xVg7WbUJYYSbtVa908mi/7N+ESo=
X-Google-Smtp-Source: AFSGD/WuOf3Q5mie3X4tVbtl8nTiyf74b8d+LPgvkK2orqLMWNSj/Lr2gkXF91IuFdEmIC6PEoISbg==
X-Received: by 2002:a25:4b81:: with SMTP id y123-v6mr5926935yba.275.1543596740698;
        Fri, 30 Nov 2018 08:52:20 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id x4sm8472802ywj.80.2018.11.30.08.52.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 30 Nov 2018 08:52:19 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] btrfs: run delayed items before dropping the snapshot
Date:   Fri, 30 Nov 2018 11:52:14 -0500
Message-Id: <20181130165214.17883-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181130165214.17883-1-josef@toxicpanda.com>
References: <20181130165214.17883-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

With my delayed refs patches in place we started seeing a large amount
of aborts in __btrfs_free_extent

BTRFS error (device sdb1): unable to find ref byte nr 91947008 parent 0 root 35964  owner 1 offset 0
Call Trace:
 ? btrfs_merge_delayed_refs+0xaf/0x340
 __btrfs_run_delayed_refs+0x6ea/0xfc0
 ? btrfs_set_path_blocking+0x31/0x60
 btrfs_run_delayed_refs+0xeb/0x180
 btrfs_commit_transaction+0x179/0x7f0
 ? btrfs_check_space_for_delayed_refs+0x30/0x50
 ? should_end_transaction.isra.19+0xe/0x40
 btrfs_drop_snapshot+0x41c/0x7c0
 btrfs_clean_one_deleted_snapshot+0xb5/0xd0
 cleaner_kthread+0xf6/0x120
 kthread+0xf8/0x130
 ? btree_invalidatepage+0x90/0x90
 ? kthread_bind+0x10/0x10
 ret_from_fork+0x35/0x40

This was because btrfs_drop_snapshot depends on the root not being modified
while it's dropping the snapshot.  It will unlock the root node (and really
every node) as it walks down the tree, only to re-lock it when it needs to do
something.  This is a problem because if we modify the tree we could cow a block
in our path, which free's our reference to that block.  Then once we get back to
that shared block we'll free our reference to it again, and get ENOENT when
trying to lookup our extent reference to that block in __btrfs_free_extent.

This is ultimately happening because we have delayed items left to be processed
for our deleted snapshot _after_ all of the inodes are closed for the snapshot.
We only run the delayed inode item if we're deleting the inode, and even then we
do not run the delayed insertions or delayed removals.  These can be run at any
point after our final inode does it's last iput, which is what triggers the
snapshot deletion.  We can end up with the snapshot deletion happening and then
have the delayed items run on that file system, resulting in the above problem.

This problem has existed forever, however my patches made it much easier to hit
as I wake up the cleaner much more often to deal with delayed iputs, which made
us more likely to start the snapshot dropping work before the transaction
commits, which is when the delayed items would generally be run.  Before,
generally speaking, we would run the delayed items, commit the transaction, and
wakeup the cleaner thread to start deleting snapshots, which means we were less
likely to hit this problem.  You could still hit it if you had multiple
snapshots to be deleted and ended up with lots of delayed items, but it was
definitely harder.

Fix for now by simply running all the delayed items before starting to drop the
snapshot.  We could make this smarter in the future by making the delayed items
per-root, and then simply drop any delayed items for roots that we are going to
delete.  But for now just a quick and easy solution is the safest.

Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index dcb699dd57f3..965702034b22 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9330,6 +9330,8 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		goto out_free;
 	}
 
+	btrfs_run_delayed_items(trans);
+
 	if (block_rsv)
 		trans->block_rsv = block_rsv;
 
-- 
2.14.3

