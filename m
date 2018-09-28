Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26363C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D22A3215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="wtuOPbf1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D22A3215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbeI1RmJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:09 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39830 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbeI1RmJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:09 -0400
Received: by mail-qk1-f193.google.com with SMTP id q5-v6so594886qki.6
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=ZS+Ro2q0p6YcbYs63sQ3GFXPklxc57Dq9Ikc/xk3dZs=;
        b=wtuOPbf1NvjgvZlWJJ2Oy3XrETx92rphs2HxZgfxllIPsXBXQ5gyDeX9Ioffvnd6g7
         54U5tcmY/MJDXC4C5rDgtCgSBbSF7NFGFW3nhElTsQpJzz0c+rRd7iyPmsf/ccrFb7rP
         owzlRgbTMH21bTN2AyKrY0fbj4bCTkeSvfNDvAC/gGVQxoKAaX5Rqh2VxmSuzJxABklY
         Q0oP71KGgMKRojASwC2nZGUjcoL8rRNVOBJifR3dZYkWdPJA5TPvVw0QJaia7Zusak3l
         saQa7nOoby+wJraGYLHgVe54LS9z6xELSMdFQNiFSE4tzlUQcqzN7Souc4fH7+w5d2YO
         38KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=ZS+Ro2q0p6YcbYs63sQ3GFXPklxc57Dq9Ikc/xk3dZs=;
        b=hG3/U30AOOJfiUMEB9lsT76oM2IBPCnCWe5EuRBaLoShWpJotkyZ9jqsIKisqEeJxW
         UTanNbY7lYv4Ajgi0QO0VRgoyY3L1pVpk8WB7jpprP0WemVTI/gzB1pUKYMojWFHK9Dt
         rv5nnIA/AcZLuyZ3Y1BoQVrqPydMmhKn45wvAFeDcNziYYKm1l+BAXKTYdbU+C1Nt96B
         banscu9ngSBhsEKryefETK7NIIjirTDwxldCJ/xLjAd8kEog5klx0pzpD4+hZfgGuVK4
         A1dxmeNeE2StV6YmbiBRjvkZPG7bi6IxngpR1TOJv+xB+I+PU56dR5GHWh/Bp8nY0ZSM
         JX4w==
X-Gm-Message-State: ABuFfojsIWlJuxuMmrWN2y+RAZt36mBXjyKL5h/zhr1NI69BC28m1I0R
        0fjqSh7qETzKsNzkfC9aPZ2jcFLTvjA=
X-Google-Smtp-Source: ACcGV615TvH/T83Xqjkds7Vkw/li72+fuPhRPjh4yhpNWAfEmFOCc/CW8HdWvTybvbgf8nPF3hLiVA==
X-Received: by 2002:ae9:ef11:: with SMTP id d17-v6mr11503904qkg.80.1538133531641;
        Fri, 28 Sep 2018 04:18:51 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id o5-v6sm3213326qtc.63.2018.09.28.04.18.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:50 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 14/42] btrfs: reset max_extent_size properly
Date:   Fri, 28 Sep 2018 07:17:53 -0400
Message-Id: <20180928111821.24376-15-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
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

