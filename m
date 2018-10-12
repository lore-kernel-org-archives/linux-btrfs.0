Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AA2C71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A24F2087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="jhMkBXMP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3A24F2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbeJMDHU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:20 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45048 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbeJMDHT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:19 -0400
Received: by mail-qt1-f195.google.com with SMTP id c56-v6so15043555qtd.11
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=gKSGvLkh9Ok2LxOaudtm+P6nYNrWuwCgPKPCVFl6C1Q=;
        b=jhMkBXMPf5+C0w4bcEUFX1qSF/Koy9dEJNUXrEwpYkkS/b7yHxx3OGllE8ohfg1wV8
         J9IwVXafhWNiA3+PQvtwQGp3FxyWqN+S5X6YqXAhVqlDCUpppcJm0L5Kgw7Mb78QAqnb
         PKpsuI/F1jkoXBnDqYCtfkBcSPxT+YLOvPqxV1LRFCsDkf9vzZu+z+oJDVccJM+f6HwY
         vCFaB1fQXpEvem1QIeJK0aS0VDJ/QVyWfc3cBIgqfdEaHB77xgO1enFFqO3WHwFBBH5D
         c4F4qTAEjIENBUL7ug8cdV6grXZ31TefXwYFtx2h1MC5R+eWbEKcborcyfkAOcHLMu7C
         Uqrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=gKSGvLkh9Ok2LxOaudtm+P6nYNrWuwCgPKPCVFl6C1Q=;
        b=k3pz3E6JaK70O8Ag+fl/LaXwjJ7l8PVbWZ71EwoVGxueGGB2Hz9ohknsRagd44FOVL
         g1RIh7I909UwbLaWnIerak5id9Ye+t3bNpjQ65Cf5WXgmircKH3/Bz37iTRN8udw81v7
         sPdvjij46B5O2aECJHLKPpZP9MQKiUsMEu8Pzc3LY9ZLLzJ1HP2nYy5h2IHar3jxaUef
         18mrk0BTNODrnpERAp7h24HLb9kDviiZcrkR291m+YaP7EXPOBRmUH4UYZ3egaKbf3t4
         OogyCX50Nt/Phd3dsBIamXKP8vAVYSxIVdwF3sTNj64ohEkh9tBVjHtq+PPF4lAv4hwn
         d6rA==
X-Gm-Message-State: ABuFfohaD+Wq8lrAsV3Vru4iuEwY9dK/aoGO8ZTKPN8T43MwsRRjd8zD
        5oOZsJzSwPFRLd78DYMzUuCiz9HnEio=
X-Google-Smtp-Source: ACcGV63KeDpZYcxEm/V4nRr2/c8OpXmMx9UcW4j8S597gdVYmluw+pxKDuD+m0qxrqk7PIhxR4iGhg==
X-Received: by 2002:aed:3b7b:: with SMTP id q56-v6mr6837893qte.51.1539372798712;
        Fri, 12 Oct 2018 12:33:18 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id w5-v6sm1437897qkw.69.2018.10.12.12.33.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:17 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 10/42] btrfs: protect space cache inode alloc with nofs
Date:   Fri, 12 Oct 2018 15:32:24 -0400
Message-Id: <20181012193256.13735-11-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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

