Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AADE2C636C8
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Jul 2021 18:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BA7C61029
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Jul 2021 18:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhGTRV7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Jul 2021 13:21:59 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:59956 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhGTRV4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jul 2021 13:21:56 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4C782202F8;
        Tue, 20 Jul 2021 18:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1626804153; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=LaU4b0lkV2DAzm547SG3vChDSaDssKW+s40xfvGTod4=;
        b=uze8pxiESsPp0bWmhu6d6g3efNmV+1EueOfpBROAgjBD0dsa8iXfYNKUQu6M5sMD8Dez/R
        WChrEaKBEQjnP2caN1xnTn4GoBFMYtpOjlkx/3uwQueYJYRpALT+Tpq9QsSzLhS78d5dmr
        4s/JMRQe4XKUUirOIPE5eMACbHM0HzM=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 2E28C13B9D;
        Tue, 20 Jul 2021 18:02:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id TEalObcP92AAVAAAGKfGzw
        (envelope-from <mpdesouza@suse.com>); Tue, 20 Jul 2021 18:02:31 +0000
From:   Marcos Paulo de Souza <mpdesouza@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.com, Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH] btrfs: Use NULL in btrfs_search_slot as trans if we only want to search
Date:   Tue, 20 Jul 2021 15:02:47 -0300
Message-Id: <20210720180247.16802-1-mpdesouza@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Using a transaction in btrfs_search_slot is only useful when if are
searching to add or modify the tree. When the function is only used for
searching, insert length and mod arguments are 0, there is no need to
use a transaction.

No functional changes, changing for consistency.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 fs/btrfs/backref.c     | 2 +-
 fs/btrfs/extent-tree.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 7a8a2fc19533..0602c1cc7b62 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1211,7 +1211,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 again:
 	head = NULL;
 
-	ret = btrfs_search_slot(trans, fs_info->extent_root, &key, path, 0, 0);
+	ret = btrfs_search_slot(NULL, fs_info->extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
 	BUG_ON(ret == 0);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d296483d148f..d8d5fb9fb77a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -153,7 +153,7 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	else
 		key.type = BTRFS_EXTENT_ITEM_KEY;
 
-	ret = btrfs_search_slot(trans, fs_info->extent_root, &key, path, 0, 0);
+	ret = btrfs_search_slot(NULL, fs_info->extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out_free;
 
-- 
2.26.2

