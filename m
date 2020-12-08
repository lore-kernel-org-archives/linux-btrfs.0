Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F41C433FE
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Dec 2020 16:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F5EA23A75
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Dec 2020 16:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbgLHQ00 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 11:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730492AbgLHQ0Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2020 11:26:25 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7ACC06179C
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Dec 2020 08:25:51 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id z188so16427525qke.9
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Dec 2020 08:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kNOtAisk0hN8omuiH6mLCn6ZjHq8m2odxb3m+HFyoKQ=;
        b=dmzcHZQdj4y8kD1Pgv8kWgTgRjcXiUl03R2p85ersx2/w9+dVe8Sz0hdMABzlnRvcx
         aXOBQ2Ga2tMVS4DJMbtpIINstatgdo8mVmd31ahvGZj2ZjdQ7G+55maL54HkUxSt9QYA
         tPrwF/SmxSYBfD0PpSVGRv35RP5kSQ3GFOSY0oGBrGEI1mnsorRTkziaXHBq6kwKOSGC
         XLvJvMfI/egtGny74q/N2Kc75tM/SJ/KLzZ5DI92wS8OEt/2UC6/rr6jK7reMMBMGzG/
         q0CeNcbRZvbe0mQj68YCqd7ZTb/SNdY9dyJbF7UDb1UNIuWL9gjyMKlu+EGxxlRNs8zU
         tQsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kNOtAisk0hN8omuiH6mLCn6ZjHq8m2odxb3m+HFyoKQ=;
        b=V7gyRN7/EA4gbYWUxA3aWudQzOEOvfm5esKmKx9SkYBDb/mRkpImosjjVnzAXfWnGU
         oqdg1lca41YuhQ2ATo97GTPb3FvMs14Gxd2vPVdcR5viUrvLy6/BHLOxGldj/N36TTvl
         fgJ3mGEz+Eb4QJfxjO7ALA0cPGo6XONi2lBfZQy8Zp22ucuaMPsPxmx0QuZvTb4lBwtM
         4P8wYyPS/rcY7JV2AJ3G9n01insca28Lhdu9c4RyY1o9A76qspG/LUWqqTLe8ikgf5dg
         tvzAM26xSWwn2117PzxkNXe8/n2cDNvAtL9QuxxXGMJZ/XtEfBZkUwjCX9HT1YoTUFJX
         n3ew==
X-Gm-Message-State: AOAM530mbQqNrpDo6eQVZwu4ejcvFc5Kk7yn5ZhjsIbHyv5niQwEipGE
        qHN3dNwoxfB89rsGKxk7tJt38lT9x0S4b4db
X-Google-Smtp-Source: ABdhPJwppF1YBjkZXLsiZlg/o6yRzZzADqr3nbOdtmTWGG2VJACPMt8RaPe1tZC3q1V3su+Zgjbc8g==
X-Received: by 2002:a05:620a:6c8:: with SMTP id 8mr5577454qky.176.1607444750527;
        Tue, 08 Dec 2020 08:25:50 -0800 (PST)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id z125sm14778802qke.18.2020.12.08.08.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 08:25:49 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: [PATCH v6 49/52] btrfs: do not WARN_ON() if we can't find the reloc root
Date:   Tue,  8 Dec 2020 11:23:56 -0500
Message-Id: <ea51dfbaf5a1dd542cf0e887e612c53530f98462.1607444471.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1607444471.git.josef@toxicpanda.com>
References: <cover.1607444471.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Any number of things could have gone wrong, like ENOMEM or EIO, so don't
WARN_ON() if we're unable to find the reloc root in the backref code.

Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/backref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 56f7c840031e..525815d2914b 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2617,7 +2617,7 @@ static int handle_direct_tree_backref(struct btrfs_backref_cache *cache,
 		/* Only reloc backref cache cares about a specific root */
 		if (cache->is_reloc) {
 			root = find_reloc_root(cache->fs_info, cur->bytenr);
-			if (WARN_ON(!root))
+			if (!root)
 				return -ENOENT;
 			cur->root = root;
 		} else {
-- 
2.26.2

