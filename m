Return-Path: <SRS0=yR0V=2H=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65091C43603
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Dec 2019 15:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 398B424655
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Dec 2019 15:37:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="rzFhDkXH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbfLQPhO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 10:37:14 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43812 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728150AbfLQPhO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Dec 2019 10:37:14 -0500
Received: by mail-qt1-f193.google.com with SMTP id b3so9010653qti.10
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2019 07:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HltDQJl7stAB1vD8G+8gZKXtWOW2fcNixCaDMOY4h3g=;
        b=rzFhDkXHgWOZlUF8I+t7BYcSW9U1HYAGI1NO7yYh5uwB9nnKZrsM1IHqdw/lmsDhGV
         ksj7UKvfRRpCCKeHHphpr4XpReEQ+PGkkMvNsL3iUQODLpoGwKp0ZnDOHHDyzYoL0Ie3
         YaXy8MFiJlXtgo5ASw6DPH4xpVliKTsbO2fY0PX/BIM5mkaR38WCo3EngWEl9d8XWv1w
         T7fB8piPwqFvJO2NmLZ0o7gQ64hN9/HS50MQiIUFRKJJESWe2PkYZ+xQYZQoxe1bABX4
         UYKZp7wecA/cQCsXWJjR+qkmJgs0w0IJ8xdEhghm7TT2Hhk2rs+XMTeUXFvh8I3XQmYn
         SSwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HltDQJl7stAB1vD8G+8gZKXtWOW2fcNixCaDMOY4h3g=;
        b=WU31jvO9VqcNd9D0LvbeDlsNMugE1myHrljbJyO3ZFv309G+zLInJWmmuq/8tmmJa5
         WvBh0jV8hCNosGfPjNP6uNCFPRsJP+vbBxBC3pzAfhyH9h2k2P82UgWLsfnnxIgVLOma
         1/Gg6YVG3aMshQ5l9qh9cZOfSO1VT8sV+8/o6GHJJdvkD8Ii/d28qjqfn3GhvmlENc43
         yBZNjGeK3eyMpFWqX3c7qZ5xvLbumzYdhNXGYHBFrhaFmsiaPC/sKboBoCI3xZj4/Xtu
         oB9v5tRmlI96aDUu5lv1JG+tOSAIN67VjkxqecX/48rbK4/fLSyPdHubuesNauGzPTjz
         S2oQ==
X-Gm-Message-State: APjAAAW6CHmt+jV+vo8WOGEFXcvjcckMHRJsMywIB48f+r05nYniE1lf
        NTNKQFs6tMTiSGjkWqKb6pWbNHezGptw3Q==
X-Google-Smtp-Source: APXvYqxUHyJYLY93hkXTUx369h2g/ZpNd/YZPk2brNdakEkXGXsIGfGPXtLaFLlZv2hGE1NoGuiI2A==
X-Received: by 2002:ac8:7297:: with SMTP id v23mr4951091qto.135.1576597032826;
        Tue, 17 Dec 2019 07:37:12 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id x6sm7180220qkh.20.2019.12.17.07.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 07:37:12 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 19/45] btrfs: hold a ref on the root in btrfs_search_path_in_tree
Date:   Tue, 17 Dec 2019 10:36:09 -0500
Message-Id: <20191217153635.44733-20-josef@toxicpanda.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191217153635.44733-1-josef@toxicpanda.com>
References: <20191217153635.44733-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We look up an arbitrary fs root, we need to hold a ref on it while we're
doing our search.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ioctl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e01363cd2bbe..b8b5432423e6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2328,6 +2328,12 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 	root = btrfs_get_fs_root(info, &key, true);
 	if (IS_ERR(root)) {
 		ret = PTR_ERR(root);
+		root = NULL;
+		goto out;
+	}
+	if (!btrfs_grab_fs_root(root)) {
+		ret = -ENOENT;
+		root = NULL;
 		goto out;
 	}
 
@@ -2378,6 +2384,8 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 	name[total_len] = '\0';
 	ret = 0;
 out:
+	if (root)
+		btrfs_put_fs_root(root);
 	btrfs_free_path(path);
 	return ret;
 }
-- 
2.23.0

