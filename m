Return-Path: <SRS0=UIME=2X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EB2C2D0DC
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jan 2020 16:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82D7B206E6
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jan 2020 16:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577981722;
	bh=SUJTN8LHH7poXGA3+roZmMr/sEdlYNhIPVks5/l6GzU=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=05MjhAPVvqkbhPEmdMiHSMuJZkBwFtQjRGerRDXpooxbTPeLOg09rvriY5dc0UaG9
	 Qy1WKUn9JTexToAYyUTBkuoOzyH06rFFQ+NPtWbzuVrSETPeKBks1xeFMKKUABLjEm
	 QFou+F4/osPd3+0lbTBbJi48LqYxgd6mzABEGx+E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbgABQPV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 11:15:21 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54174 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728678AbgABQPV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jan 2020 11:15:21 -0500
Received: by mail-wm1-f65.google.com with SMTP id m24so6015920wmc.3
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jan 2020 08:15:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l8v6C688TIVJTw3O8eWCTzCbWz/Q23pzcfkpTuC1Qfo=;
        b=ubIIPr7JDGhnw/rXrcBInfDLh3klrwRChayG2cQq/oBHNHPkzyoswXPQnt0//+Gpm3
         QPuvjWqiU9ZxSGXKKPp9YDnsxF6Wu9YF+9Xyk2kv527jHGma01+ZbTSvK0gzFe3wh548
         MPn6ebEePwzoRIjs57q+HmBF8+Uoq7XdvbI+mPzBxuzcJz5oxU5OsUwjBEiX1dkZVag6
         xO0fkyhSyIjvAcEbPCPdQW1oJHAd8blCrnu6F/qe6jtScXpniiK3jox11Grpfjkms8d8
         8IIdindiJ9xyLWUmzGTjjZM6uOt7TPneGsaB3MyzJwZuuIlDuk7V0f+A31iXHPiYmuJi
         EPww==
X-Gm-Message-State: APjAAAX/5dmlahO1NmU/kmoKWOCBvGPeLWf2xA6lp6d2spz5k7cwBtlz
        Kn9aK2hQGWHfgFlDmxwIA0Idk8bS
X-Google-Smtp-Source: APXvYqwDGhP44UOn0XdO5h4lU3fu9shbSkVyFIpXmurn1ZJayIZZn81nQer15nfQu3Noxim1r8OFlg==
X-Received: by 2002:a7b:c416:: with SMTP id k22mr14115903wmi.10.1577981719149;
        Thu, 02 Jan 2020 08:15:19 -0800 (PST)
Received: from linux-t19r.fritz.box (ppp-46-244-197-144.dynamic.mnet-online.de. [46.244.197.144])
        by smtp.gmail.com with ESMTPSA id s1sm9291166wmc.23.2020.01.02.08.15.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Jan 2020 08:15:18 -0800 (PST)
From:   Johannes Thumshirn <jth@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     linux-btrfs@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>
Subject: [PATCH] btrfs: remove unnecessary wrapper get_alloc_profile
Date:   Thu,  2 Jan 2020 17:14:57 +0100
Message-Id: <20200102161457.20216-1-jth@kernel.org>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_get_alloc_profile() is a simple wrapper over get_alloc_profile().
The only difference is btrfs_get_alloc_profile() is visible to other
functions in btrfs while get_alloc_profile() is static and thus only
visible to functions in block-group.c.

Let's just fold get_alloc_profile() into btrfs_get_alloc_profile() to
get rid of the unnecessary second function.

Signed-off-by: Johannes Thumshirn <jth@kernel.org>
---
 fs/btrfs/block-group.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 66fa39632cde..bdd6485c3120 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -95,7 +95,7 @@ static u64 btrfs_reduce_alloc_profile(struct btrfs_fs_info *fs_info, u64 flags)
 	return extended_to_chunk(flags | allowed);
 }
 
-static u64 get_alloc_profile(struct btrfs_fs_info *fs_info, u64 orig_flags)
+u64 btrfs_get_alloc_profile(struct btrfs_fs_info *fs_info, u64 orig_flags)
 {
 	unsigned seq;
 	u64 flags;
@@ -115,11 +115,6 @@ static u64 get_alloc_profile(struct btrfs_fs_info *fs_info, u64 orig_flags)
 	return btrfs_reduce_alloc_profile(fs_info, flags);
 }
 
-u64 btrfs_get_alloc_profile(struct btrfs_fs_info *fs_info, u64 orig_flags)
-{
-	return get_alloc_profile(fs_info, orig_flags);
-}
-
 void btrfs_get_block_group(struct btrfs_block_group *cache)
 {
 	atomic_inc(&cache->count);
-- 
2.16.4

