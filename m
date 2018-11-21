Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6654DC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DA79214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:06:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="v5hoo/Hd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DA79214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732250AbeKVFlc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:41:32 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:42733 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFlc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:41:32 -0500
Received: by mail-yb1-f195.google.com with SMTP id o204-v6so2631975yba.9
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=ChDhmHleKb4VZu9DLBBdualiLEzB3kbTWeFT8Vil964=;
        b=v5hoo/Hd9i8mxyHynQcrpKJc59+79guNfS/aXoUkOk3bsFK4EiPcSqcQ/9mbMtTKaP
         4v8LQRz+Zp1ACfkXob7ZFgBqyHXiKBhO5bzMN0PdxlMG7UY6dbmchNF9ODxI9c8l56TT
         CUvV6Tj/5CN4+9fPN/eONx6oSsKrqbk0aeKhg4LqABALDKI5dTbNVIu5zhbxlXWp2Rn/
         I7y4Ho/3xVQcWHC4lWqMV1Oi6unYUN+d3zDecj574/T0Th54Ls6oZrkQOCSwpLwsDikW
         Lh8A+SWxF61+5vSn8wRAFurwD9v20iyxoX2oKh6MRT9xH6Cz7t0KkHTQupyK0ZLxLOcm
         PBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=ChDhmHleKb4VZu9DLBBdualiLEzB3kbTWeFT8Vil964=;
        b=jbs/PFRACMHesx773aIrrfpz0Ch/QMs+Ga7x/WrxqAbH1tkLCWTgUkD9T6MqIRru0z
         Yjzi2rdmb0+EwohWzUNC3Zhy6Y77QUovnV9i9cpC0ayzXmvFCKuxOBPb9OpwX0uTmX4z
         OEvwNEuiaxiOJy+zO9YScomAKXmHosz3BoDfbcrUsZE9oyl+/FkY8osAJJNEJINTOI3T
         zXoGiG4av4v4Zq8W8uYFLc5PY+Ggcu5puGcH5+tHoVHaxpOUxtvXimxVhTepPpzqd3sf
         4qUvKoootyUKbLfQafQzMQw0OybVFdjqlBuDqCC83BAs+3fKN4VrKwbhaOx3DRsYkxRr
         jZaw==
X-Gm-Message-State: AA+aEWZta9gpCx/x1EV8M4t3B+RQwWdENmzPLiPCLJu/MkwaDzI1cmwM
        mpO38ibYII35t6GG2AqrdIFlddOZSww=
X-Google-Smtp-Source: AFSGD/VnYaf3h7bFfu5iBNIxutxtI10wQAxh/YLf0a3j93puqjkL4ZUKt6aFyNcM9o4A06qnbbp6DA==
X-Received: by 2002:a25:aae2:: with SMTP id t89-v6mr7530049ybi.200.1542827159701;
        Wed, 21 Nov 2018 11:05:59 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id d138sm9746967ywb.44.2018.11.21.11.05.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:05:59 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 7/7] btrfs: wait on ordered extents on abort cleanup
Date:   Wed, 21 Nov 2018 14:05:45 -0500
Message-Id: <20181121190545.24798-8-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190545.24798-1-josef@toxicpanda.com>
References: <20181121190545.24798-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If we flip read-only before we initiate writeback on all dirty pages for
ordered extents we've created then we'll have ordered extents left over
on umount, which results in all sorts of bad things happening.  Fix this
by making sure we wait on ordered extents if we have to do the aborted
transaction cleanup stuff.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8e7926c91e35..c5918ff8241b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4171,6 +4171,14 @@ static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
 		spin_lock(&fs_info->ordered_root_lock);
 	}
 	spin_unlock(&fs_info->ordered_root_lock);
+
+	/*
+	 * We need this here because if we've been flipped read-only we won't
+	 * get sync() from the umount, so we need to make sure any ordered
+	 * extents that haven't had their dirty pages IO start writeout yet
+	 * actually get run and error out properly.
+	 */
+	btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
 }
 
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
-- 
2.14.3

