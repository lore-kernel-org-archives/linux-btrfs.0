Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B391C6787C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D68572087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="jUygUYNC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D68572087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbeJMDHz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:55 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:32975 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbeJMDHy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:54 -0400
Received: by mail-qk1-f196.google.com with SMTP id 84-v6so8372233qkf.0
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=iwqcae1qLLQVCE/PGD/ciqt8xARB3jAN063PUm5bmoo=;
        b=jUygUYNCoAdq7AmY6YYV50mJYxEK/WS2R6yrI4RrID34sJraCcho+G+ofSKFRrIQEs
         RLNyz1hzS5B0KoCI9gG5JD5IAsVFqWVtae0ePr+4FbjGgjFfho831MEhqw40OxNGViNa
         3/jEDcQtdK+rAvyyWxpCI6LH5RIG0PETDb+1LY0nFx9e7pAWidBp1HXC2TTKHWy6wY+M
         zGYCN0I4DukWncXLWHUtVQoVjVtmP8IfPAwjx2Bo7bX5viLD4FgfLOgEPcYc7sWAltkJ
         wZUVy4VKvGYB8HGVzOXYNFh3crtADL58LzqzM1XX3ceZOzRuqv8cQLTzgbzTraoISV3W
         9B9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=iwqcae1qLLQVCE/PGD/ciqt8xARB3jAN063PUm5bmoo=;
        b=mhcRnpV/gTruwUldd+6pgrdTgOXnl/HG0QpuhAV/G33JZWF0DxfPrGDjVEoUiSeN/6
         C/3KkwbfExUnyOW2r+HusRt1TR4EJhOAN9J6b627FAnACKh6kWXkqsbKZOb41W5BHULS
         G7ilfxSmX2NbQr8gouTbCsQ8xN1YbJOUTJ319Z+hEkkW2tUxHFy9ri+RTk/QHR+nXKpF
         +XgFqtZLUAL2/FTbeJTu/mJqlYvjbJf+xB0jury++aM0kbd+vexgVoljtWyc4iIKaZFr
         JqdlFctWS3GUrMrTZWQFsP5ez8T9OKsSuqChPYxEK62oa9/vKzWmHerbzQc+YBTwzCOV
         stQQ==
X-Gm-Message-State: ABuFfojwCR4Fky86VscYt6z3INpnFYikKE+52Y6jLeTEZlWnMftCJ5i3
        tc/SSWB9b6cveJUNhbMRjMW2C6XCXxA=
X-Google-Smtp-Source: ACcGV60pKON7m2wnEkI6zhaGBwM9xhZRFr/y5bFkpj86wk8l01z6Abl3lTdvxmBBeGSltdr/+/t3dQ==
X-Received: by 2002:a37:8305:: with SMTP id f5-v6mr7090298qkd.230.1539372833218;
        Fri, 12 Oct 2018 12:33:53 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id r78-v6sm1605656qki.16.2018.10.12.12.33.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:52 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 23/42] btrfs: make sure we create all new bgs
Date:   Fri, 12 Oct 2018 15:32:37 -0400
Message-Id: <20181012193256.13735-24-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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
index 6721698ab8aa..0d7fc07c34ab 100644
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

