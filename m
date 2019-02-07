Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF76DC282C4
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 16:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F89B218D3
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 16:54:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="t4KZB1QL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfBGQyg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 11:54:36 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35975 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfBGQyf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2019 11:54:35 -0500
Received: by mail-qt1-f193.google.com with SMTP id r9so640702qtt.3
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Feb 2019 08:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=r/6ImBPT8TvXRqs28rQEyIJASHUeDfJVKp3+BViVXxs=;
        b=t4KZB1QL0DXS2g3JGEEkIdVXZeMd7+I1HTrTMz7TYXrgPpBFs7B5pNVeLmS81GlVIF
         LfViwtrZrID+gOPEqlEgbopsfvPHoOucxnxrMIpeLcF68D2Zpa08jW2K9GhDaYIgUaod
         eJl77oJYB3TE/xqXTYUu2abO92nDbMNXLPgjP3OC2FXdBhy5xzPehdHH1ddmqXdC3Dte
         twAf+eURk9X4njw/t/BCPZ3ahMae56ypsw8Dc/xGBuU2HXv1sAYk2Ty/KVxE7XJef9q/
         iRFvoHywHiF1juL5bXKcHxjZxMq8gsTvsJo4Uum7fu4pbJNmXyFHROvPFQq9ZMkWDHDg
         HjAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=r/6ImBPT8TvXRqs28rQEyIJASHUeDfJVKp3+BViVXxs=;
        b=idfaBGV2a+xTvdL+jWqPOYMM3rC8TajeKlxRthzkgbe11sPjK/N6G8b4voEcxlLk4g
         5Tv+3K0b42nQlvF/BVrBuIUA3/1A0zxUMYsNFCk8BdcKezgZPMq5HHTAQlbE5SAqOxbI
         lygE2JJDRknhrGU7UeZ9Y9ZN1+BCGdXpdSxk/IdGZvtqGMh8baVAIvmlBUeD/wQL+sGs
         Wch6p4mXEdnuOxawm/Hn9I24UomV+YthOoztPLgAHU5MjyuL+cXdbVT+iX5ttNbiE2eM
         P92eywp+F4cgegTCRSK30JySF0+NIAP0n8xcGXonvGYEAga8XhwQxdxW+fN+eRFDocIX
         XPHg==
X-Gm-Message-State: AHQUAuZpkftzpyPDB8HIPCKbVpdZszL+jWfKUOTpvV8mHVyUWenJscQ5
        ekJGKv0sUltA6tqh34YJb0ZaFu4ZVIo=
X-Google-Smtp-Source: AHgI3IbFTEAigPFj3NHZtGketrjwjaMtZ+v62L5zBsE74nI9wsygGZJqPdndTqSKmZPAv8XjFi9F1w==
X-Received: by 2002:a0c:c2ce:: with SMTP id c14mr13091713qvi.7.1549558474397;
        Thu, 07 Feb 2019 08:54:34 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 35sm8910736qtu.87.2019.02.07.08.54.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Feb 2019 08:54:33 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 2/2] btrfs: use the existing credit for our first prop
Date:   Thu,  7 Feb 2019 11:54:26 -0500
Message-Id: <20190207165426.15866-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20190207165426.15866-1-josef@toxicpanda.com>
References: <20190207165426.15866-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We're now reserving an extra items worth of space for property
inheritance.  We only have one property at the moment so this covers us,
but if we add more in the future this will allow us to not get bitten by
the extra space reservation.  If we do add more properties in the future
we should re-visit how we calculate the space reservation needs by the
callers.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/props.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index dc6140013ae8..b3d22fef8c92 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -291,6 +291,7 @@ static int inherit_props(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
 	int i;
+	bool need_reserve = false;
 
 	if (!test_bit(BTRFS_INODE_HAS_PROPS,
 		      &BTRFS_I(parent)->runtime_flags))
@@ -308,16 +309,31 @@ static int inherit_props(struct btrfs_trans_handle *trans,
 		if (!value)
 			continue;
 
-		num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
-		ret = btrfs_block_rsv_add(root, trans->block_rsv,
-					  num_bytes, BTRFS_RESERVE_NO_FLUSH);
-		if (ret)
-			goto out;
+		/*
+		 * Currently callers should be reserving 1 credit for
+		 * properties, since we only have 1 property that we currently
+		 * support.  If we add more in the future we need to try and
+		 * reserve more space for them.  But we should also revisit how
+		 * we do space reservations if we do add more properties in the
+		 * future.
+		 */
+		if (need_reserve) {
+			num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
+			ret = btrfs_block_rsv_add(root, trans->block_rsv,
+						  num_bytes,
+						  BTRFS_RESERVE_NO_FLUSH);
+			if (ret)
+				goto out;
+		}
 		ret = __btrfs_set_prop(trans, inode, h->xattr_name,
 				       value, strlen(value), 0);
-		btrfs_block_rsv_release(fs_info, trans->block_rsv, num_bytes);
-		if (ret)
-			goto out;
+		if (need_reserve) {
+			btrfs_block_rsv_release(fs_info, trans->block_rsv,
+						num_bytes);
+			if (ret)
+				goto out;
+		}
+		need_reserve = true;
 	}
 	ret = 0;
 out:
-- 
2.14.3

