Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BEADC04EBF
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 16:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0112120834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 16:06:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="FU0rH9gQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0112120834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbeLCQHD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 11:07:03 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:37099 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbeLCQHD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 11:07:03 -0500
Received: by mail-yw1-f67.google.com with SMTP id h193so5592661ywc.4
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 08:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=N45SWvepwcroEPnphEt+dLodfsACU/p3srtHQgF6qi4=;
        b=FU0rH9gQbSljlZfnV/pawU4pC8zqF3RzyBgj2ELHdiuHMjUoqLraBsNaEDxqKgx1r2
         Ybt1ZDjJUMTPimmVoDYYNP8wmYcDHdu04yZi9k6ooSO2w8UNYvx65Zlop5TajCcJhFyX
         VohcJtbQXdfgD8uUpb+FjvOCPwvFfGmYzZD68FfIvLtjHHGqgMJO0jrZ4WC7yIrSx6Cv
         R6Znw9P0xLaRzngGCSsDcTz3f08M9wul8M7KMO0EudLBkXcrhyj/R7/cXyB8M1bAJeUB
         hLYhReJEmO9hxr6hrLi5KKwqNB5LeVcEwCIx8z1qoW70RGGXVmtK4LWeNtE0IeC5ET1Z
         rh6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=N45SWvepwcroEPnphEt+dLodfsACU/p3srtHQgF6qi4=;
        b=dZGfCV3J2VoaJUVIQV6J5r8Bp7AqaAYXQmp4htqpDx1I5JKqESj9Ym/l0nh6a3l324
         o58FeYC2/SLwkyOpxCo1lLUpGi4sbY6Jvd0kjIKP7jD3yQbi0m2fT11FuImDuD+9JbCu
         vSLGjbQgK3D6aiqX2WxZgJyUyPj1qWUP4UaChxnw/9a8dAQfLL053XevxsSMw3V/2sD0
         926FpiNRTN0PHpjvoaYiVxTTwaGe/7fw122juAk07uZIwXEmJNvEi+aQfq5BNHVJ8BxT
         /5IHIgqfzFkUMfqZcsGbZk7eWr6hLPWVLLK2rojEJSmO7F5tVyuy+HdT9WoVVJcXh67A
         S+zw==
X-Gm-Message-State: AA+aEWaoX50b/cISIH71YUiwGIXSGb06d72X4TJIukIKpqHJkZgfS4RE
        06tsgNdi7LZPMpkOnahNRQ5xqoYVUgs=
X-Google-Smtp-Source: AFSGD/VrTabPseuABf/kIEvn7F2sjQVfHmQr0OIuYifC/p5u4dX/8FmbevwU2WbRtT8B0GsxX3c03w==
X-Received: by 2002:a81:3685:: with SMTP id d127mr5296960ywa.71.1543853216231;
        Mon, 03 Dec 2018 08:06:56 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id v191sm4602919ywc.102.2018.12.03.08.06.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 08:06:55 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 1/3] btrfs: run delayed iputs before committing
Date:   Mon,  3 Dec 2018 11:06:50 -0500
Message-Id: <20181203160652.25078-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203160652.25078-1-josef@toxicpanda.com>
References: <20181203160652.25078-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Delayed iputs means we can have final iputs of deleted inodes in the
queue, which could potentially generate a lot of pinned space that could
be free'd.  So before we decide to commit the transaction for ENOPSC
reasons, run the delayed iputs so that any potential space is free'd up.
If there is and we freed enough we can then commit the transaction and
potentially be able to make our reservation.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/extent-tree.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8dfddfd3f315..0127d272cd2a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4953,6 +4953,15 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 			ret = 0;
 		break;
 	case COMMIT_TRANS:
+		/*
+		 * If we have pending delayed iputs then we could free up a
+		 * bunch of pinned space, so make sure we run the iputs before
+		 * we do our pinned bytes check below.
+		 */
+		mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
+		btrfs_run_delayed_iputs(fs_info);
+		mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
+
 		ret = may_commit_transaction(fs_info, space_info);
 		break;
 	default:
-- 
2.14.3

