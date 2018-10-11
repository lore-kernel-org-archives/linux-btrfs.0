Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA00C6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F267C20835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="aQqNZkgP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F267C20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbeJLDXk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:40 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34353 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDXj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:39 -0400
Received: by mail-qt1-f195.google.com with SMTP id o17-v6so11371760qtr.1
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=gKSGvLkh9Ok2LxOaudtm+P6nYNrWuwCgPKPCVFl6C1Q=;
        b=aQqNZkgPZHWGfdixvbmz4TJGZqGOkep+EDTJ8Rv4nj97sHPGG3AFJXNPw/zi2QFyFw
         U8c0dRtXIcUFN23pTycO8eCCmhlKPVUquC+wty3CqRkwvgzoTnDdbFj2HJ8CymkEY/XQ
         poxwGqx9DJGLtD5zIZCnoUveG7FfR0Z/ww8D0TQ0+E1rA480XMMU+jSeRUgGMGYvJZo3
         GJ560kzh58BybO5tB+cl6tjBXTu5wsgAKj6E8MBuEoBVZ721Ph7zotdsAp1qCoUfXVHd
         mvPVGsi9YqHiEk3dF+uRu0f5wy84wcm4sAUl3sOwTMn7s8RjYRny0cy/nQFr1Ralsfzm
         BYQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=gKSGvLkh9Ok2LxOaudtm+P6nYNrWuwCgPKPCVFl6C1Q=;
        b=aNlUiliGM6mG+mgA8ITadf5bXO3RsoLU75cxBoCCpk6uJNeZYyRSPpCUA8PbctAJtx
         2rnHIO/50zALrt3OIj7X7lIK3wa3EkdOqBqDWFyTAJ91h6ktLtpX46Yv90Q3YVoC2HDy
         cTs5ovJ8873eRmJW7F259/eTI9JnpP2N6nIUGVH9eYMjZwJ1kp4ejlAULaPuzj+8bm/7
         8EnY84BxqFsB1N5yuBXjpDFJfpoCq4HPwl+lXnqGr9c8c+LEkYkvr/5kgc53EQeDfeK0
         OGUjfbkV4OZrlC7xO2DLShUAS26cKlgGr7Gmy9WLmQwLObseoRFLCSqDs2x/WZ+WgtDv
         Mu6A==
X-Gm-Message-State: ABuFfojr8mUhnJoSMBwf9sJPTz8yFIjiQHN3NXPbWsNVgDZm2qQCj9VL
        81Wk5RvKy/gnJyMSNDZ3iizGvQ==
X-Google-Smtp-Source: ACcGV63DRo+LS9QI8qklLxJjLNf2gEgwwXsymY/Nd5tzoZ+OdZbn0YgnEhqTZrKiHgQa1T/VDJimlw==
X-Received: by 2002:aed:3445:: with SMTP id w63-v6mr3044414qtd.339.1539287692744;
        Thu, 11 Oct 2018 12:54:52 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id u38-v6sm15919995qtc.94.2018.10.11.12.54.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:54:51 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 10/42] btrfs: protect space cache inode alloc with nofs
Date:   Thu, 11 Oct 2018 15:53:59 -0400
Message-Id: <20181011195431.3441-11-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If we're allocating a new space cache inode it's likely going to be
under a transaction handle, so we need to use memalloc_nofs_save() in
order to avoid deadlocks, and more importantly lockdep messages that
make xfstests fail.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/free-space-cache.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index c3888c113d81..e077ad3b4549 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -10,6 +10,7 @@
 #include <linux/math64.h>
 #include <linux/ratelimit.h>
 #include <linux/error-injection.h>
+#include <linux/sched/mm.h>
 #include "ctree.h"
 #include "free-space-cache.h"
 #include "transaction.h"
@@ -47,6 +48,7 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 	struct btrfs_free_space_header *header;
 	struct extent_buffer *leaf;
 	struct inode *inode = NULL;
+	unsigned nofs_flag;
 	int ret;
 
 	key.objectid = BTRFS_FREE_SPACE_OBJECTID;
@@ -68,7 +70,13 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 	btrfs_disk_key_to_cpu(&location, &disk_key);
 	btrfs_release_path(path);
 
+	/*
+	 * We are often under a trans handle at this point, so we need to make
+	 * sure NOFS is set to keep us from deadlocking.
+	 */
+	nofs_flag = memalloc_nofs_save();
 	inode = btrfs_iget(fs_info->sb, &location, root, NULL);
+	memalloc_nofs_restore(nofs_flag);
 	if (IS_ERR(inode))
 		return inode;
 
-- 
2.14.3

