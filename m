Return-Path: <SRS0=SPQA=3Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162CDC3524F
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Feb 2020 16:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D604920730
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Feb 2020 16:20:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="sXV30neZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgBDQUO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 11:20:14 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:46375 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727433AbgBDQUN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Feb 2020 11:20:13 -0500
Received: by mail-qt1-f194.google.com with SMTP id e25so14714269qtr.13
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Feb 2020 08:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6YJNeRnmW5saOUDz5gDMgBXKImELGK23YsPUBKP0RFE=;
        b=sXV30neZ2vXoeDCtsrf6rWQD1Thlt+D9XvqlNbCCbIJcdtqGY5x6/i7ggdFms61A2Z
         4MkelA1ETbQr58uVx4/HTZNCfNgj7gEEE8AVEEU7YKwyyGSHm/IqWcGtTyAfO182010j
         o7p27c3CWaVooyuZCwOWTfxnVvu9CxYA6PhaY4+187GwufBYRAFEtEr8kkfqJRbRyPOf
         WtMiDGfhqRKdLzmzEH3mOW5KDfE2erbC57WCQfvbws61bcff92N87qJLAM0tWJ6vS4i6
         at7JlH5MHOyY6FJ6Xz6i44jyfqPvsm/kWvojhNlf0dsO8KLZWwXOkNHHjvr60J99ZjO4
         JeiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6YJNeRnmW5saOUDz5gDMgBXKImELGK23YsPUBKP0RFE=;
        b=c+5Udnplg2PkmGiAHEXR18TPUA22RpgV1fbTvJghDg9X7E+1CTMDWJvx+cF+lfSJXX
         iEco/lRxJBk9l1VtfIQFBa8JNOlwymnIEwVS2EhhOgcGkfvaJLpsfJ2LyB2L7VpITrM4
         6p1Y5Hy/L4u28N1Olfkx+Dkzg34EXfAMgjnRvcYo6rfbLfcFabUqYrfG//p7P1dn/RFD
         UULaadYMhg2nNnjCVTDGWNS85RRf++SQQZbNe9KxbDKjbm2G3ktUNg+Cmpv46drPGePU
         Mw1z8KONogoFPNtdKSJ9YZhFZbuMMlu3Il/SjWBJxFbgApufo8HSBWKhy0QHDEUlGscK
         vGDA==
X-Gm-Message-State: APjAAAUvJKO3Nd27IUBje2wcowpv4sxFMopFuTdujg3mxuwdpu5RxqA/
        Kqy6kdd68MP+k2UvhxM95/RHcEUbF6Ta5Q==
X-Google-Smtp-Source: APXvYqwIDLcmkIfqhrLor9I2TlIsZtjCmjXgQ4IzxZcVoIXiB83knnYTsX9Q72q4QcEIQNQpjKhTyQ==
X-Received: by 2002:ac8:4085:: with SMTP id p5mr29514823qtl.132.1580833212472;
        Tue, 04 Feb 2020 08:20:12 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id u12sm12524488qtj.84.2020.02.04.08.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 08:20:11 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 11/23] btrfs: check tickets after waiting on ordered extents
Date:   Tue,  4 Feb 2020 11:19:39 -0500
Message-Id: <20200204161951.764935-12-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200204161951.764935-1-josef@toxicpanda.com>
References: <20200204161951.764935-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Right now if the space is free'd up after the ordered extents complete
(which is likely since the reservations are held until they complete),
we would do extra delalloc flushing before we'd notice that we didn't
have any more tickets.  Fix this by moving the tickets check after our
wait_ordered_extents check.

Tested-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/space-info.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index a69e3d9057ff..955f59f4b1d0 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -378,14 +378,6 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info,
 	while ((delalloc_bytes || dio_bytes) && loops < 3) {
 		btrfs_start_delalloc_roots(fs_info, items);
 
-		spin_lock(&space_info->lock);
-		if (list_empty(&space_info->tickets) &&
-		    list_empty(&space_info->priority_tickets)) {
-			spin_unlock(&space_info->lock);
-			break;
-		}
-		spin_unlock(&space_info->lock);
-
 		loops++;
 		if (wait_ordered && !trans) {
 			btrfs_wait_ordered_roots(fs_info, items, 0, (u64)-1);
@@ -394,6 +386,15 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info,
 			if (time_left)
 				break;
 		}
+
+		spin_lock(&space_info->lock);
+		if (list_empty(&space_info->tickets) &&
+		    list_empty(&space_info->priority_tickets)) {
+			spin_unlock(&space_info->lock);
+			break;
+		}
+		spin_unlock(&space_info->lock);
+
 		delalloc_bytes = percpu_counter_sum_positive(
 						&fs_info->delalloc_bytes);
 		dio_bytes = percpu_counter_sum_positive(&fs_info->dio_bytes);
-- 
2.24.1

