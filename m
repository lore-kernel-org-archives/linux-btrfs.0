Return-Path: <SRS0=yR0V=2H=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C43DC2D0D1
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Dec 2019 15:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00A1524655
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Dec 2019 15:37:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="YkEpmER4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbfLQPhH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 10:37:07 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:38913 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728266AbfLQPhH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Dec 2019 10:37:07 -0500
Received: by mail-qv1-f68.google.com with SMTP id y8so4330188qvk.6
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2019 07:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Em1wD5xLTxNTJX+7khPl9BkwuAHENTwYnPCkG17ZnDE=;
        b=YkEpmER4m1WYVwPxvaCGhI7ZScYG8fJaa/i5gbir+0gUHHd+x3Dc8DM+DUwsHeq6Kp
         jioBxcYY77BQvilA4c2QARzL2lRntSE2SuIffFeFmTmWweR05D6W/nusnu0FLra2V++k
         XUSO38Gm340st60kmUoxHYRZgfGg2RH8dnUC1R/714BLIt2tyBlAlAGmpgGt7v3wh+aC
         fAjiFUlI0dnKw91GHXRdurpFUTcUcSwBiwdT4hzXh32CjSo/iAbi+psMDwSNfzXgwsnf
         aqfSgMUAqFKO7ekqhfe3R+2fuBXr17VO3DSYkO3SrFO6AZ8TI5O3rUJuPRGJYzAxg3fP
         vayw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Em1wD5xLTxNTJX+7khPl9BkwuAHENTwYnPCkG17ZnDE=;
        b=MN15inPakGRB8TbPdnrw5XgxZRjj40jki6wxE0GB+BfIWe5SywzU/pZoLTohkaPOtc
         IHzWbozGgFZu5ZZaZ/InRA51Con2QFC5XB+GhOj1w++4VFwhYYla+hxGge+XuPurEKmN
         nkIJ7Kv13ciIwZ0/dgV/7I34zWwYHR3/RYNFjwNyRCUvX471h8944uhsoz9EJ11MMu/p
         AllgPr7mzKFDiXrXhgab0gpGFoHGOoj53aUuv+WQS33PbGo00KvuvFNg/ksUIoi9MB3U
         /2yVuF4uKKrVTOc1jMrWTTUuJzskC0qiGbCNBZfGkIYglQEI38fN+g2sk5yb5LOlvUVm
         i0gg==
X-Gm-Message-State: APjAAAUfAB3GtNWxRX2BGRJdF8UsEnFrOb73JJR1osv5mC/80afuJpri
        UPCw9NG2suzUplay+Q2f7FFcTmsYuZU2SA==
X-Google-Smtp-Source: APXvYqwwOIWHZjzMg+yqo01GktzE7ZP0UkX0DvtpKyUIkyCDsTIQrXkmTUz4dsB+9hydh/MxhYtyGg==
X-Received: by 2002:a0c:d4aa:: with SMTP id u39mr5172130qvh.76.1576597025564;
        Tue, 17 Dec 2019 07:37:05 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id d5sm7184003qke.130.2019.12.17.07.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 07:37:04 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 15/45] btrfs: grab a ref on the root in relink_extent_backref
Date:   Tue, 17 Dec 2019 10:36:05 -0500
Message-Id: <20191217153635.44733-16-josef@toxicpanda.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191217153635.44733-1-josef@toxicpanda.com>
References: <20191217153635.44733-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We're doing an arbitrary lookup on an fs_root, we need to hold a ref on
that root.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 88f3d6eace7a..d46e3ec6ba30 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2711,8 +2711,12 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 		return PTR_ERR(root);
 	}
 
+	if (!btrfs_grab_fs_root(root))
+		return 0;
+
 	if (btrfs_root_readonly(root)) {
 		srcu_read_unlock(&fs_info->subvol_srcu, index);
+		btrfs_put_fs_root(root);
 		return 0;
 	}
 
@@ -2722,6 +2726,7 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 	key.offset = 0;
 
 	inode = btrfs_iget(fs_info->sb, &key, root);
+	btrfs_put_fs_root(root);
 	if (IS_ERR(inode)) {
 		srcu_read_unlock(&fs_info->subvol_srcu, index);
 		return 0;
-- 
2.23.0

