Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B7EC2BBCD
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Dec 2020 16:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA1DC23A6C
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Dec 2020 16:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730305AbgLHQZ3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 11:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730210AbgLHQZ3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2020 11:25:29 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A848C061285
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Dec 2020 08:24:23 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id z11so7250524qkj.7
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Dec 2020 08:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pg4Rs440j7qytVG8dQXueQyKh7OJmkNUbqs81SrLs48=;
        b=hkcpAIm2qE6pwXMGDDKXeRM+T3NKXGuHdAnLGVtQ6/Alp2F3WW3QM31RVxG26eJnGk
         zfutMpFtMAvPMG5oqTbvxRHs5SQ8j3vjZTuS2qVBNReHn/tcDU9qmIBtbBDOTK9IzpYP
         HOOkxTbXW3iCMI8ncH46PXoXMpdNJgwBahWtTc5lgFka9Lsnf3NKNbnFJjtOyaNC4CD3
         4YP3uC87kE+OXESvWuhfNjMETdrtjsnSPdf2zNxlraMSE+JFncbLzjKQvbIxzm39pGuT
         LST+8pEKphl+vNeHk+gwCDsoGvSD0NBYhaRrTGGlaEd7AJbVuF6JTJz3aTig5znaCe+o
         84pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pg4Rs440j7qytVG8dQXueQyKh7OJmkNUbqs81SrLs48=;
        b=IAdRR3bdcxTACtW+enPHZpSuGOywiW04WAIqOHU2ZeZoYP5wx8hvnB/xBEF0pukFVP
         8JGf0mOePlaifQ0sKQGYH+G67VQhIulh5xzJp234LrBUWZ3X1S31x4l7yJfinxHit4ar
         BntqOcDKGZiUDbSCqpak0Qm8FB3bTaRD2PzBmNFkQyiaLiRzbBz2DO4DEsN2D76qpkW6
         czSvpd1/QImpkN/Oby2Ae6RQNTkxTVYtB/F1lmtcEIFo9ZoTO54I39Aytz1rVtayouE2
         Kz+ccVKOYXkErW1LwfZg8FmK84OrH5cGa6BDE6qOTMBhBJnlGvIlARctS7bDv9UYaF+c
         MnUQ==
X-Gm-Message-State: AOAM531Wr/T6sxymXEmNBm5qT+EvoxPlypl8V1CNc1+6ubo5qLBjlm7a
        cTHeQDU89GeGy+RTwi7Fg98g8kf4FCPiOVkc
X-Google-Smtp-Source: ABdhPJwHsE4gcclr+Et3k41OQ55bua5KTNbwTnbcmkpV3nu27cW7JHa0opSPLK+BJ1mdHszL5G/zig==
X-Received: by 2002:a37:6403:: with SMTP id y3mr31092036qkb.204.1607444662000;
        Tue, 08 Dec 2020 08:24:22 -0800 (PST)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id o68sm9054547qkf.84.2020.12.08.08.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 08:24:21 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v6 09/52] btrfs: don't clear ret in btrfs_start_dirty_block_groups
Date:   Tue,  8 Dec 2020 11:23:16 -0500
Message-Id: <3531541c898a12776c7770d70bb4887b738b2e57.1607444471.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1607444471.git.josef@toxicpanda.com>
References: <cover.1607444471.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If we fail to update a block group item in the loop we'll break, however
we'll do btrfs_run_delayed_refs and lose our error value in ret, and
thus not clean up properly.  Fix this by only running the delayed refs
if there was no failure.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/block-group.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 52f2198d44c9..0886e81e5540 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2669,7 +2669,8 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 	 * Go through delayed refs for all the stuff we've just kicked off
 	 * and then loop back (just once)
 	 */
-	ret = btrfs_run_delayed_refs(trans, 0);
+	if (!ret)
+		ret = btrfs_run_delayed_refs(trans, 0);
 	if (!ret && loops == 0) {
 		loops++;
 		spin_lock(&cur_trans->dirty_bgs_lock);
-- 
2.26.2

