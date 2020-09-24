Return-Path: <SRS0=iRg2=DB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD16EC4727D
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Sep 2020 15:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A373D2311A
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Sep 2020 15:33:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="wrEUSbcO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbgIXPdF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 11:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728538AbgIXPdA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Sep 2020 11:33:00 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A877FC0613D3
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2020 08:33:00 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id b2so3264337qtp.8
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2020 08:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=jfjglTCoup5k7um3ixkgbD99pAW0YWdv2A4fHlezTzY=;
        b=wrEUSbcO5WF03DSwd2iVM44FbxzBfVDQlpikGeXiWCBeDRpcHDo6YJC0PAVf20z2YF
         H5thQfd0hF1g2NeupGMFYi7WY+sLFyxJ6ROJr9kBJttYUxE1Yrf754PtmkxR4zxnaagU
         vRDi7yvb/wvKIqNViSJyLD2MlrK2/4jRnAjSFLEKP0yWkmAy14q1F9yIKS81mezWC3TT
         yrypF6EIPgesIaV6kXogk9m1U7USDkOPSENggxs46gH1DfH/OrzjWsNbJTgEkp+I642g
         bbrSPmnWA6H48OwlqMk7a4pTIkqXAMaSfPxkte9hw5Ow0/c2IZT0/JijNCMENp0vjZrv
         ABhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jfjglTCoup5k7um3ixkgbD99pAW0YWdv2A4fHlezTzY=;
        b=f65Tk5hOxtSx6K5wjEn48Mc90RIiA0kiKJlaWiytYEZtlhrV2ljIXy24lkPE31gNCj
         ZKarfKrd5fGTTAkGoG3MCwFsWtWdFAvMRg6yMry56lVzjUKhbNiY5i9KgyCf8Tj4ajOR
         7rsXlRWa58SchUQM71km6FUnmJBhoiVsv2L1bqzpdF8g3p47UsVMbMPbQ2LkNOamJpzS
         hAmnpLtgsSVmRPOUM9dicF0WNPZbY2+qRXX0pDUX0rjaGLjFjr8kJo76s6AiGzr/qG50
         Djq/rWBOtR/6GzhV2VF0sKNFWI91Dw5dDRzX8ND9+IbRYQeyJdzl3bNrHLnqJvTmdNdM
         bl+Q==
X-Gm-Message-State: AOAM530vNkjjh510GjMeUh7AfrI5B3n9Dk3K8OzwwLpahtD/vSDHeuXx
        eFykR3X/SSinAAbY/Vl7pHWAiV5U5grTVnDw
X-Google-Smtp-Source: ABdhPJwGHZ5XosxBNccLx9vIs7XmIjxWLsrT+MZGAGpR88F1HaDiO9++5vCMR2rctF49Fv7enEnzXg==
X-Received: by 2002:ac8:6ec2:: with SMTP id f2mr92429qtv.159.1600961579567;
        Thu, 24 Sep 2020 08:32:59 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id s20sm2207465qkg.65.2020.09.24.08.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 08:32:58 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 1/5] btrfs: unify the ro checking for mount options
Date:   Thu, 24 Sep 2020 11:32:50 -0400
Message-Id: <d307f1d95415232dabfb700e79cda73618aa7d50.1600961206.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1600961206.git.josef@toxicpanda.com>
References: <cover.1600961206.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We're going to be adding more options that require RDONLY, so add a
helper to do the check and error out if we don't have RDONLY set.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/super.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8840a4fa81eb..f99e89ec46b2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -458,6 +458,17 @@ static const match_table_t rescue_tokens = {
 	{Opt_err, NULL},
 };
 
+static bool check_ro_option(struct btrfs_fs_info *fs_info, unsigned long opt,
+			    const char *opt_name)
+{
+	if (fs_info->mount_opt & opt) {
+		btrfs_err(fs_info, "%s must be used with ro mount option",
+			  opt_name);
+		return true;
+	}
+	return false;
+}
+
 static int parse_rescue_options(struct btrfs_fs_info *info, const char *options)
 {
 	char *opts;
@@ -968,14 +979,12 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 		}
 	}
 check:
-	/*
-	 * Extra check for current option against current flag
-	 */
-	if (btrfs_test_opt(info, NOLOGREPLAY) && !(new_flags & SB_RDONLY)) {
-		btrfs_err(info,
-			  "nologreplay must be used with ro mount option");
+	/* We're read-only, don't have to check. */
+	if (new_flags & SB_RDONLY)
+		goto out;
+
+	if (check_ro_option(info, BTRFS_MOUNT_NOLOGREPLAY, "nologreplay"))
 		ret = -EINVAL;
-	}
 out:
 	if (btrfs_fs_compat_ro(info, FREE_SPACE_TREE) &&
 	    !btrfs_test_opt(info, FREE_SPACE_TREE) &&
-- 
2.26.2

