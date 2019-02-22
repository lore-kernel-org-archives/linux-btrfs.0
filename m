Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BBEC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 19:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7873A206BB
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 19:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550865240;
	bh=Y9/1XaDpEwK1uk0tM+fxW5jNSzm2QLmE6P4opnhaG3Q=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Eo2n1AH9m11T7dkoqK/SbiVVkxsHp3s2/2okh7pMUfibcY68k4mGvBa8GrDOt3meD
	 TlzOX0u8OsmcDkdr9fxF7MIoDk4NkhNKuK4rlfr0y2t+oUTZVuvC6lw+jRkkE/+keC
	 glOXG/HuOZzEPuj2+2gkVbqQe5NElTdEJJ8ltYYY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbfBVTxx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 14:53:53 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:43528 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfBVTxw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 14:53:52 -0500
Received: by mail-yw1-f68.google.com with SMTP id u200so1273759ywu.10;
        Fri, 22 Feb 2019 11:53:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zkPpT+9dCP/TcVlbEruBGqv/abmVjMaoKctylj2pCEk=;
        b=n0/NVYBZgp1fZ1NdKt8oM551QGYkq9/N9ig8Pv+e1nJqX3DzXekttvLbNWEJOkdv81
         BDFMwX9kiHdNmDMi/Tx3JCo0gInuZtp+aKCnb1IVMZspXLUgkn14mohK7dusIxDKrsDH
         oCLS3lzGuTdlQTpua+F/qn7JbD/102pHSfQwQZHQ5Olx0amSKVFFgCT11RSk76D5shco
         kouzvdNCRAKrDfYuuHr/ZvNyiy2+ZuE0YA73UBMKFFiM0Yk6Y1vgQnm2Wxp/RHX4NG8S
         8W9OeNYn1aXKINAFy/RZaopn7NjFPCZ2++UseDNe/s/wLof/VbkDDRUw5L0TYqPruWf8
         hR7A==
X-Gm-Message-State: AHQUAuZRNZk8+0S8SBEJw1T/lysOpA1PrlB2LxCCWqBUXvB5Dh37KXCI
        jxZWX5K9R+Kn+BTXM0AWucY=
X-Google-Smtp-Source: AHgI3IZi4MrPo9AdhuB2wEVaC4tnR/WdHH6JQAjEnkNQ+XiRdjpcQXBwbgkslchKAl0/5LYLm90Mow==
X-Received: by 2002:a81:c70e:: with SMTP id m14mr4776321ywi.16.1550865232017;
        Fri, 22 Feb 2019 11:53:52 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.133])
        by smtp.gmail.com with ESMTPSA id t136sm704832ywe.101.2019.02.22.11.53.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 22 Feb 2019 11:53:50 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH v2] btrfs: zstd ensure reclaim timer is properly cleaned up
Date:   Fri, 22 Feb 2019 14:53:48 -0500
Message-Id: <20190222195348.2728-1-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The timer function, zstd_reclaim_timer_fn(), reschedules itself under
certain conditions. When cleaning up, take the lock and remove all
workspaces. This prevents the timer from rearming itself. Lastly, switch
to del_timer_sync() to ensure that the timer function can't trigger as
we're unloading.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
v2:
- cleanup workspaces and then disable the timer

 fs/btrfs/zstd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 3e418a3aeb11..6b9e29d050f3 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -195,8 +195,7 @@ static void zstd_cleanup_workspace_manager(void)
 	struct workspace *workspace;
 	int i;
 
-	del_timer(&wsm.timer);
-
+	spin_lock(&wsm.lock);
 	for (i = 0; i < ZSTD_BTRFS_MAX_LEVEL; i++) {
 		while (!list_empty(&wsm.idle_ws[i])) {
 			workspace = container_of(wsm.idle_ws[i].next,
@@ -206,6 +205,9 @@ static void zstd_cleanup_workspace_manager(void)
 			wsm.ops->free_workspace(&workspace->list);
 		}
 	}
+	spin_unlock(&wsm.lock);
+
+	del_timer_sync(&wsm.timer);
 }
 
 /*
-- 
2.17.1

