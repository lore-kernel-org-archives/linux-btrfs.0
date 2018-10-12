Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AE5C6787C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 637D52087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="ydruAyxW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 637D52087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbeJMDH4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:56 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45929 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbeJMDH4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:56 -0400
Received: by mail-qk1-f196.google.com with SMTP id m8-v6so8341282qka.12
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=5ErWA8iDFY+6lz4JimjzCOpUtgurbUZk5oK0tyfx1Sk=;
        b=ydruAyxWw+sUhnZcgM3UxK9ILhXYl9GXsn+wElfZY/6XMO248WlkjgELKSeFSmiSQN
         6yj2YBIgiDYNf0jHxGMECdtPffvzDYzgQHxLyvSrJxWwbF1U+bBmImpF1eijV+vJnEhK
         HHS5XjYrw6akh/M1q188dOAHfxZGP1H5O5uootp4Co09VWTita7iGdkGMIScsGT3zoAB
         n9b6xIoljiik3dKZHI1KUYYwzUeX69VKkeBpoTgfO/O5NPpF6SSb//8eNcz5ZSh2e92K
         H8Olz8ADTwakb4bYev17999S9kVpOgL2FSfUN8gatB5/cDBjuV+OY6tqnS0i7sdrCSAe
         N6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=5ErWA8iDFY+6lz4JimjzCOpUtgurbUZk5oK0tyfx1Sk=;
        b=QL3a4KE6N2aT91RmCvXkJ7AIYZAGjOYHZqemLNIh+pkTomSbRMzP+pJlr5lz68ZP9j
         OUDGqJsRA+PnKw4fTSIjuxZ7WWUMuYGm/m6ymZb3ATV5cmiZIc/7f7ZDedleNMC7rxCl
         kMWX+yPS1dO5PeryNkz97CjIBOUALnXfVpRTahitLhoZXpRStwK+a4fh4+F3I4oGdLhB
         7sDTEgB8CRBfohz4kLmtpLEhO+bwZZuma/JeagU4ZYAAaOSspmFXjIA3U3eFy/hzxeTT
         qg8hrKrid3MbHJpwMbrde1sjLDEhI9bR2iic4uhyzlLb507wRjhGzJw0R8CvSiiwAUXD
         NLuQ==
X-Gm-Message-State: ABuFfojgsQeg2tdEPZ7QWuqVKlCpTUGZqgHaQKDaBbAzfw5JMUBRvB3M
        JKWA5nbw7sBT3oFSBIkR5wjQSRYcLUQ=
X-Google-Smtp-Source: ACcGV63AuLgDwZuzC5DuzX3Y84SdKZEKU4qP5MvkPLiFahqMuOpWeQ0d+vq7l3ORt+BPDyowQR+94A==
X-Received: by 2002:a37:b345:: with SMTP id c66-v6mr7214202qkf.47.1539372835019;
        Fri, 12 Oct 2018 12:33:55 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id e2-v6sm1093970qkb.41.2018.10.12.12.33.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:54 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 24/42] btrfs: assert on non-empty delayed iputs
Date:   Fri, 12 Oct 2018 15:32:38 -0400
Message-Id: <20181012193256.13735-25-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I ran into an issue where there was some reference being held on an
inode that I couldn't track.  This assert wasn't triggered, but it at
least rules out we're doing something stupid.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 377ad9c1cb17..39bd158466cd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3979,6 +3979,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	kthread_stop(fs_info->transaction_kthread);
 	kthread_stop(fs_info->cleaner_kthread);
 
+	ASSERT(list_empty(&fs_info->delayed_iputs));
 	set_bit(BTRFS_FS_CLOSING_DONE, &fs_info->flags);
 
 	btrfs_free_qgroup_config(fs_info);
-- 
2.14.3

