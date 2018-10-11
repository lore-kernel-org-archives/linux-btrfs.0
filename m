Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81061C6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 401C720835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="Qt5t8ogI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 401C720835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbeJLDXr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:47 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:32925 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDXq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:46 -0400
Received: by mail-qt1-f195.google.com with SMTP id q40-v6so11375492qte.0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=ZS+Ro2q0p6YcbYs63sQ3GFXPklxc57Dq9Ikc/xk3dZs=;
        b=Qt5t8ogIpodUYLCziHQQlZV9/oqDYrsme07kKhebrZ8JermHmoM/uXQwzufxEod3iB
         Ym9JBgikuUrcOFC2KoNdNT0X4XCn0Hc2pI18kWJd3vtQpgEBhi5eU33yjHop5bX8xb4w
         mz4DLbQuOT7mOa9AG+iIlVk5ynWFvaBllU9V57tXeJcxmzAyNJwYiLLRWY6CbIDvmHKl
         UXkKUDEa9lrULfG8i8FX8BNMIibDHUgc+6P0DVDNOzJ0ylCOf2WFMRPpkfeqHrgmR0YF
         QfyNKwm7lE5E6ChlmVMTZrLjk73er2XEsTdrVl3nMwYbMH7kn2OqQm9MOPkw019EkBmM
         QrXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=ZS+Ro2q0p6YcbYs63sQ3GFXPklxc57Dq9Ikc/xk3dZs=;
        b=qbcNaHHx3xFJbPXNpn4Nus//DBrtiRK/UpjUpRnRHTvbhdzK1v4WjOuWu8TG9DLfa/
         5SOMjkuiJyI+SH8QSfedyQcp3BmOUj+bHfMJdoQZ8pE0FJ/7J77pOn3zqHS61Xdead+P
         xo6dwQb6GITGRZSJb4x1Cpy7HuEqReaI2kLggEtJVG+8zqpD7lEPaaCFhF0JXwAlmVgR
         lxGd4dhkbBCoA0XiWHAlk+YalMIHvP7n3ejQvYrJ3WJssqDibHMZ+cQUsWlJSxtt5gNN
         UKFklf69lBLMswvyv9SLUhzplzO3xqxHOTRVfxR79QvJm2n5sqI44Za8PfovMTBwdIG1
         ucqQ==
X-Gm-Message-State: ABuFfojrwo+gkdOAGM0dVEa6viqFR7POlpcF0dqBk0jh+SKkhoVMKmiq
        zSCm+ZVpcyX45IDhpYOGhVq7Vg==
X-Google-Smtp-Source: ACcGV62K7vrB3Dzt18/m5LTCJi65nt2NGYLNEI7QR/CVp/s/V74mMlgrsa/UNVjpMbc8xwQYZ8cHDg==
X-Received: by 2002:ac8:276a:: with SMTP id h39-v6mr3008270qth.274.1539287700676;
        Thu, 11 Oct 2018 12:55:00 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id a68-v6sm4854073qka.54.2018.10.11.12.54.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:54:59 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 14/42] btrfs: reset max_extent_size properly
Date:   Thu, 11 Oct 2018 15:54:03 -0400
Message-Id: <20181011195431.3441-15-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If we use up our block group before allocating a new one we'll easily
get a max_extent_size that's set really really low, which will result in
a lot of fragmentation.  We need to make sure we're resetting the
max_extent_size when we add a new chunk or add new space.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index cd2280962c8c..f84537a1d7eb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4573,6 +4573,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
 			goto out;
 	} else {
 		ret = 1;
+		space_info->max_extent_size = 0;
 	}
 
 	space_info->force_alloc = CHUNK_ALLOC_NO_FORCE;
@@ -6671,6 +6672,7 @@ static int btrfs_free_reserved_bytes(struct btrfs_block_group_cache *cache,
 		space_info->bytes_readonly += num_bytes;
 	cache->reserved -= num_bytes;
 	space_info->bytes_reserved -= num_bytes;
+	space_info->max_extent_size = 0;
 
 	if (delalloc)
 		cache->delalloc_bytes -= num_bytes;
-- 
2.14.3

