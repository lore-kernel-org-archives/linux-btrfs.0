Return-Path: <SRS0=zmxC=27=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A49E1C282DD
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 Jan 2020 16:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A6F7206ED
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 Jan 2020 16:11:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="Vq8LXbHI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgAJQLe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 10 Jan 2020 11:11:34 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:34918 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728408AbgAJQLe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Jan 2020 11:11:34 -0500
Received: by mail-qv1-f67.google.com with SMTP id u10so970448qvi.2
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jan 2020 08:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=x1r5PP7jrkEsWxnGsLBMiexU6JkQnQrA7yNTkY+BxaU=;
        b=Vq8LXbHIUJF2DMlh5NjtWxbW4MxngBSQdeU+UvyuEja3EChdbgkVX+LLjclj/S49qk
         3GAIZHgAqevx3Zdb485cS+vbrimQ8Ec0ABr+wJjsS8qqkKuz8mKNG1jk0bPCe1mmtvB5
         634TTwED+AeTbNXr7ZN0RVA7mcUDHv94Brz1sIrvMe3Xi8hsVAKDF07Mp+nZdVRCKgBU
         rfym7U5T8TLguv3mc4/S/+Qy9lF5vyry0UdiNiUunXCpdbq3JeEV8fWa965vbnXFFelj
         GIf7lMKXIeMCKkJleTsB/IPvTyRn693ZH3JNaPwEyGviieiS5qQeexAIBsIOhVM6993i
         7p8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x1r5PP7jrkEsWxnGsLBMiexU6JkQnQrA7yNTkY+BxaU=;
        b=dx+abW+IuV4yHZ6uCcreNHe2oXqhj0zKSw2WxUf/akb/TSbzkOvvDkKU9YY7xUB6Dr
         sXWsUOtEkbF4KkKNChbepdPm/tGp5+WMhXeu+eKZtMAb7arDk/cBKyJDW9GQAr4a9cn2
         kOtAmonq0tfCamvU6CDtyUEwdJMtkNJ1T22fd+eLayJQQ1IlI5HsR6qVDsKLz7H8cimb
         G9FawAuhNbeoZQB12tCwjwFzAiKszpRd9JisoKPUb3SMFwO3pUf3jnQlFQ8KMtois+It
         3hyRonwkP90Od39jLp8yRTNKq9YaTTnArWE9PbHYB53sIerbqOxLViGppcNPHJaNGAnt
         3MUw==
X-Gm-Message-State: APjAAAXTOC9tqMVVV+IdzzKRjTYStP3r6nLMPlt4adlgB7HzL/VmwSzy
        iSRv1uLM/8vIzhkZXc5/NwxbxKaLrHbEWA==
X-Google-Smtp-Source: APXvYqwWlegbaylHpOUaO3rqa+bARK7S1kzCVXFt0zYWNUzLM6+7mt8cjwbb5eMWUHPNeQuT7B+HvQ==
X-Received: by 2002:ad4:4b6a:: with SMTP id m10mr3345276qvx.116.1578672693105;
        Fri, 10 Jan 2020 08:11:33 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id t2sm1045610qkc.31.2020.01.10.08.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 08:11:32 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 1/5] btrfs: check rw_devices, not num_devices for restriping
Date:   Fri, 10 Jan 2020 11:11:24 -0500
Message-Id: <20200110161128.21710-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110161128.21710-1-josef@toxicpanda.com>
References: <20200110161128.21710-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

While running xfstests with compression on I noticed I was panicing on
btrfs/154.  I bisected this down to my inc_block_group_ro patches, which
was strange.

What was happening is with my patches we now use btrfs_can_overcommit()
to see if we can flip a block group read only.  Before this would fail
because we weren't taking into account the usable un-allocated space for
allocating chunks.  With my patches we were allowed to do the balance,
which is technically correct.

However this test is testing restriping with a degraded mount, something
that isn't working right because Anand's fix for the test was never
actually merged.

So now we're trying to allocate a chunk and cannot because we want to
allocate a RAID1 chunk, but there's only 1 device that's available for
usage.  This results in an ENOSPC in one of the BUG_ON(ret) paths in
relocation (and a tricky path that is going to take many more patches to
fix.)

But we shouldn't even be making it this far, we don't have enough
devices to restripe.  The problem is we're using btrfs_num_devices(),
which for some reason includes missing devices.  That's not actually
what we want, we want the rw_devices.

Fix this by getting the rw_devices.  With this patch we're no longer
panicing with my other patches applied, and we're in fact erroring out
at the correct spot instead of at inc_block_group_ro.  The fact that
this was working before was just sheer dumb luck.

Fixes: e4d8ec0f65b9 ("Btrfs: implement online profile changing")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/volumes.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7483521a928b..a92059555754 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3881,7 +3881,14 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	num_devices = btrfs_num_devices(fs_info);
+	/*
+	 * rw_devices can be messed with by rm_device and device replace, so
+	 * take the chunk_mutex to make sure we have a relatively consistent
+	 * view of the fs at this point.
+	 */
+	mutex_lock(&fs_info->chunk_mutex);
+	num_devices = fs_info->fs_devices->rw_devices;
+	mutex_unlock(&fs_info->chunk_mutex);
 
 	/*
 	 * SINGLE profile on-disk has no profile bit, but in-memory we have a
-- 
2.24.1

