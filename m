Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B0CC677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DA0120835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="voITN7rg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DA0120835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbeJLDYE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:04 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34424 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDYE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:04 -0400
Received: by mail-qt1-f194.google.com with SMTP id o17-v6so11373378qtr.1
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=hXRxupQSb58mFrmcwAlimg01JbJ9bnLWSvle0nmy4+w=;
        b=voITN7rgg3K8b1R3/0Z09264yrhpbzEHh/yNkWu643tNCx7G8l7PuBbh05DZ9ASrZ7
         uVlRoRG174TyzbGc+kRfFYRzfTkb7IZZVZbYTN3rCt4DoEyqY7VfamO8W0K+6X6ztyzF
         w512998YtuvrbRo5muEwo2RU4qaSvBGBw1OhzrdQRDZ5qJCDDcB7Q6kfnh4OSlwO8EI9
         trx5IdCn8n+yjrIO6paHups9D8aTPyOrpMmVQcbDSXbSWFMcKAzE3zwj4wdxtt1RATuB
         QZciaGqgQzLV+SsljFK1DH4RIW2DaSP2o0tiGncYl2DflEGuJcnhuuVdZnje+YNb3EHR
         1ugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=hXRxupQSb58mFrmcwAlimg01JbJ9bnLWSvle0nmy4+w=;
        b=hqSz4TgRLACFd/79TrFQFB3uzPF2szaeO0HpB+UcW4bf4BoaPl0NUzjpqOsVYQgbsC
         7fXn3+HrMg7ZyNRYhhNqiyRUyDadLJZ4FosH2viDAY4HibRzIgbkwtc1k148gqH/Z+h5
         lDFiL5774k6RReS7f/FPgb0qRYFdm8rd2NywKqkJ2XIakFEauQpmoVpvjX9sC6oOrkwN
         wFda1lrgn7HIhSfBZIqXxiMx5WErpWsRI/MNE5CbmuNcAcmYmf1KTQzbuPqown4PkjUp
         Dv9xwukh9ZWjKpL5ZYXrJv4bqerMFKAiJLlkYkw28xhHQlRNnvXb7qJdB8kmiddae+vc
         NQbw==
X-Gm-Message-State: ABuFfohRCotD8ZdkWT7lhImLZXlVs3thUkBSjki91bFHwZjNZzfe7cce
        fEIo/BGkj6cwqhO8AGzUehb3wA==
X-Google-Smtp-Source: ACcGV60IDSUNSGjj88YJouuKkpHI00Y3a2AxMlpkQANy7w+zoOvxOU8XqQ9qf4fO8/q+9itEkJ1PFQ==
X-Received: by 2002:a0c:f98b:: with SMTP id t11mr812683qvn.146.1539287717585;
        Thu, 11 Oct 2018 12:55:17 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 144-v6sm14006454qkk.63.2018.10.11.12.55.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:16 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 23/42] btrfs: make sure we create all new bgs
Date:   Thu, 11 Oct 2018 15:54:12 -0400
Message-Id: <20181011195431.3441-24-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Allocating new chunks modifies both the extent and chunk tree, which can
trigger new chunk allocations.  So instead of doing list_for_each_safe,
just do while (!list_empty()) so we make sure we don't exit with other
pending bg's still on our list.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4f48d047a1ec..ec8ede2b1dec 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10361,7 +10361,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_block_group_cache *block_group, *tmp;
+	struct btrfs_block_group_cache *block_group;
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct btrfs_block_group_item item;
 	struct btrfs_key key;
@@ -10369,7 +10369,10 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 	bool can_flush_pending_bgs = trans->can_flush_pending_bgs;
 
 	trans->can_flush_pending_bgs = false;
-	list_for_each_entry_safe(block_group, tmp, &trans->new_bgs, bg_list) {
+	while (!list_empty(&trans->new_bgs)) {
+		block_group = list_first_entry(&trans->new_bgs,
+					       struct btrfs_block_group_cache,
+					       bg_list);
 		if (ret)
 			goto next;
 
-- 
2.14.3

