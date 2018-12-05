Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1859CC04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 17:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6F3F2082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 17:12:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="HOWsJZOz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6F3F2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbeLERMY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 12:12:24 -0500
Received: from mail-yb1-f179.google.com ([209.85.219.179]:43156 "EHLO
        mail-yb1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727695AbeLERMY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Dec 2018 12:12:24 -0500
Received: by mail-yb1-f179.google.com with SMTP id x144so4579280ybg.10
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Dec 2018 09:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=nS/Msg5VGoRKUWpEXNDIsgTgYJVKW0+Qtk4o2s13rOk=;
        b=HOWsJZOzk6NFtDn39CU69+pkaVn+qEJcKeFCErCZonaK1oJqBG2M5gG0wzdo4/BAMi
         d1m/PuwXsd+6KxxG3k0xGP+w2g/R7GUk3FU8uMN58WaiMMWlC1Lqyp7oSF2m/XwIJrc7
         gLs3wqQvSEGA4Q5oVaXASfQSikcaG4ofW/+q4q8W4ovwUNJ/b/owiT9VL6e/BNzd4oQG
         4LYviILZrGcvNmdql8eVoLL32uiXT1DEhijWUQJGQUY6omWwSlnbhrSEPysQOHyIgZ3V
         UsewnU/THF+AWDrwYHwBFNiw0Qia+GKDRVTMfDioYrUoVIS8Fq/MjnixOyhLeD+LrW+X
         PgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nS/Msg5VGoRKUWpEXNDIsgTgYJVKW0+Qtk4o2s13rOk=;
        b=T/OwRySL9CUxrGvnvtfndAdoGwzEH06N+t+lYk5l6S888WPAcahbUSt4N/t2oKig1q
         hWSSh1NDmMYZPF9b9XoPxLgoAQjkqwmzM4Mr5tKZ5EFrE9GYTOA+mzKexPbNcgxDLF4c
         IAjSSrCnV+EZorQ86xgNZO7Kn/f/F4LY8Fhkac9AZEdPn1MFW44wFY8dEhdFRPMngqiU
         fHahhyA9CMGGVmknohtRckoz8wqrhnBNHknkQLCgIS0UwICRu1ppDBrXZTxDHbIHmheV
         Tg/rmNsNRTpT1xdLYlnaA/sGef+Iy9c11WMnBq6D1L1dodMGp2B/DyqaBbQKkyOY/nGG
         uSQA==
X-Gm-Message-State: AA+aEWYmbqiRSFjeNzHgXcd46NjH3uP+y4ceT8pCPkocF2AnCWqoD++c
        xjHH94UlVcZu92yHJ831K4ipHj8SakY=
X-Google-Smtp-Source: AFSGD/WAsM/fcC41r/KBFrfPySWjH5W2ozVt/VbyaQirwn538fXcya2Gqo48d0S3f7VCST8V0Sl8MQ==
X-Received: by 2002:a0d:de87:: with SMTP id h129mr2163851ywe.337.1544029943627;
        Wed, 05 Dec 2018 09:12:23 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 141sm6450225yws.47.2018.12.05.09.12.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Dec 2018 09:12:22 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Cc:     Josef Bacik <jbacik@fb.com>, stable@vger.kernel.org
Subject: [PATCH][v2] btrfs: run delayed items before dropping the snapshot
Date:   Wed,  5 Dec 2018 12:12:21 -0500
Message-Id: <20181205171221.28777-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
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
v1->v2:
- check for errors from btrfs_run_delayed_items.
- Dave I can reroll the series, but the second version of patch 1 is the same,
  let me know what you want.

 fs/btrfs/extent-tree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index dcb699dd57f3..473084eb7a2d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9330,6 +9330,10 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 		goto out_free;
 	}
 
+	err = btrfs_run_delayed_items(trans);
+	if (err)
+		goto out_end_trans;
+
 	if (block_rsv)
 		trans->block_rsv = block_rsv;
 
-- 
2.14.3

