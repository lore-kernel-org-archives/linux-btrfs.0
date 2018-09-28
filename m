Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A76C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85CE3215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:19:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="UQIBHyfd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85CE3215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbeI1Rmq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:42:46 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]:45735 "EHLO
        mail-qk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729513AbeI1Rmq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:42:46 -0400
Received: by mail-qk1-f170.google.com with SMTP id q20-v6so3532266qkc.12
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=o3aniGDG3zSjx1n1+LpysocBJ3oenkOpLCURB29A0Uc=;
        b=UQIBHyfdBnZqPJN7DSbVKETuAVs5PBIMQ2I17Y+LLv4XxcJ0y2bNuvNMn/YZzDitzK
         EYUnttxSlLB+0PDk6d075ESYOzDwCfX2WDEruq8047iwRmOaYe0dj+Li/pjQHe2QgAJa
         iwEUg2LqgwNDbK1O8kxm1bS3cNE/lvlDYeZFHmZ10vB/yJbF0qUGfCg37892YAaIlDSl
         NfaIXWGMsesX+BpsETT5/HEcYaGSnzAuKbo0X9av3DwU16QtIpG7ZLWp6iklFrrxaN6p
         xzxMw6OtIBZf0aEC2Y42UsK3KyV1GOUGAd2d8SG1k6BMZQ0yA6bpUy0evQRc9+RzR500
         sRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=o3aniGDG3zSjx1n1+LpysocBJ3oenkOpLCURB29A0Uc=;
        b=tyCb0uNGIUsoOb5kvUMStDC0XMXiyqKJJl4FwAhW8Cj38VHDkhL73814U6dL3ocgCJ
         Qr/1HLrqm8NEbDsZs2wyDu6RPFJR+pj/S/PJRbu+/2rJOMxk+IUFy1bVTiaRIQsqb01Z
         4m85agtdJKY4j0SvGIXlzB2aUDfDIIfzL7QuhQLO6Wn+UBmuHL+ZiTSQydhOaLctT4pu
         uufDZt/WOtCDKllfTX9rrr59ps2Np/6Sq9J1kuqVYkyX1upc639HzRTmQzDEZgJDi5hw
         9sxR6TMaOZfNoIXDt3AwqJTEcx/0io25JJoNxqPVvcjdKTq2EOKMsFEytfISPoLj7eoC
         Ru+w==
X-Gm-Message-State: ABuFfog+he36F833KHsslKP2jRmZefZ2jfL/BJTKBy77qEGzoHjtWgvv
        tXyuP+7jBpZQrMV9J36FeBDOjA==
X-Google-Smtp-Source: ACcGV62GK5armn7lzfc7ddpxfG54iB7hyzfkp2sOm4L1KmtecpR2HCIGIinjBFpO5l0/xAwccNYUcA==
X-Received: by 2002:a37:8406:: with SMTP id g6-v6mr11210070qkd.148.1538133568068;
        Fri, 28 Sep 2018 04:19:28 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id f53-v6sm3221242qtk.40.2018.09.28.04.19.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:19:27 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 34/42] btrfs: wait on ordered extents on abort cleanup
Date:   Fri, 28 Sep 2018 07:18:13 -0400
Message-Id: <20180928111821.24376-35-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
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
index 54fbdc944a3f..51b2a5bf25e5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4188,6 +4188,14 @@ static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
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

