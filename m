Return-Path: <SRS0=i4Ze=4J=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25919C35646
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Feb 2020 13:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0623224672
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Feb 2020 13:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbgBUNCh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 08:02:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:39962 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727876AbgBUNCg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Feb 2020 08:02:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2AECBB01E;
        Fri, 21 Feb 2020 13:02:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D373CDA70E; Fri, 21 Feb 2020 14:02:17 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 2/3] btrfs: use ioctl args support mask for subvolume create/delete
Date:   Fri, 21 Feb 2020 14:02:17 +0100
Message-Id: <4b8a60420b7da2f62f04969541b3405fc14914e6.1582289899.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <cover.1582289899.git.dsterba@suse.com>
References: <cover.1582289899.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Using the defined mask instead of flag enumeration in the ioctl handler
is preferred. No functional changes.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7305e6770157..a7872cacd0aa 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1838,9 +1838,7 @@ static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
 		return PTR_ERR(vol_args);
 	vol_args->name[BTRFS_SUBVOL_NAME_MAX] = '\0';
 
-	if (vol_args->flags &
-	    ~(BTRFS_SUBVOL_CREATE_ASYNC | BTRFS_SUBVOL_RDONLY |
-	      BTRFS_SUBVOL_QGROUP_INHERIT)) {
+	if (vol_args->flags & ~BTRFS_SUBVOL_CREATE_ARGS_MASK) {
 		ret = -EOPNOTSUPP;
 		goto free_args;
 	}
-- 
2.25.0

