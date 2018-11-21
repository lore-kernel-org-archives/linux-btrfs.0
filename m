Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3D0C04EBA
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9362F2151B
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:09:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="NUWTIAXP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9362F2151B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388438AbeKVFpB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:45:01 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44684 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729345AbeKVFpB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:45:01 -0500
Received: by mail-yw1-f65.google.com with SMTP id h138-v6so868028ywa.11
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=6GppKIwq2/h2o1Ul1elzGUlH3S2sHH63CRbE+1FM6ZY=;
        b=NUWTIAXPWyNiDN2oI1WAV2B1g6l5yUUxae/gc1NDbPO2TI4U67gJPYEyIkd/V/amOY
         GA6vojD+UaSrfryUDSUYvNRRmSgCFUx/OghUmChpcQjICbQLLHLC4Qm1/83/sT7/mz1b
         GWUaBqmwO6L5CHO+DAongE2mTqcwj+cgD4uMu1LAlPgdvq5NLhQa9RJ2iKwhszwbbI8/
         835tsXcZErck7zGLZ/gOf2ldS9uLcujXTahqyC6r2ZzV+Baz65a7HAH2WsjxEIUsHDKQ
         7OFCD5U621D78q80DiGZFwU/WANtm+XnBp7J/Gvs+h/DJewKMVW2OGBB1HRhXh6EClPy
         MYDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=6GppKIwq2/h2o1Ul1elzGUlH3S2sHH63CRbE+1FM6ZY=;
        b=Ama3Rmfgp3DMEW/LG/WHUuao/ffuv5ksePf7pha7tpSSOMWPK9SRP5lYWTKUvztGrZ
         zPFquLbc/eup1EyAEqbHnaNBOA0PtHSGOoO5WENLn6oFixaCaxAN0Y1frtYO3nCSbEMe
         gXQSMOsWyoairMiCeKjXjiL7CRBz1Y3TbV4LnTrVKiwixXO2/SXVqYbL2dQUdQ5yqUnA
         diJLfT7aDZAb4vJpQUduw0TGnmlQ/nhuCcdfncQrK40t7mInY57O+hj1DBlKG68Cstc7
         RRKZJpdQySJ5VPiCRW4AFXEotf3JaemnvILSSi30IiNF2CFO73dbig5nd2QC+7EjU6NZ
         ej+A==
X-Gm-Message-State: AGRZ1gKvahlVLVS5tVu/svI91EM47DNvk3gWhe2d4Zl4Oj8mh3M8uCRi
        GO6kwOiUo6o/ITIuC4SVjp3soxp8tYo=
X-Google-Smtp-Source: AJdET5c50NXi7JJI/4Vx6TJuRSUJcLfqbxEKV3fknRW5B1NgG5POAgPLhOPTDvCb6kCjzBSt10zB4g==
X-Received: by 2002:a81:66d4:: with SMTP id a203mr8027454ywc.39.1542827367499;
        Wed, 21 Nov 2018 11:09:27 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id z74sm10873896ywz.51.2018.11.21.11.09.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:09:26 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 2/3] btrfs: wakeup cleaner thread when adding delayed iput
Date:   Wed, 21 Nov 2018 14:09:21 -0500
Message-Id: <20181121190922.25038-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190922.25038-1-josef@toxicpanda.com>
References: <20181121190922.25038-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The cleaner thread usually takes care of delayed iputs, with the
exception of the btrfs_end_transaction_throttle path.  The cleaner
thread only gets woken up every 30 seconds, so instead wake it up to do
it's work so that we can free up that space as quickly as possible.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3da9ac463344..3c42d8887183 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3264,6 +3264,7 @@ void btrfs_add_delayed_iput(struct inode *inode)
 	ASSERT(list_empty(&binode->delayed_iput));
 	list_add_tail(&binode->delayed_iput, &fs_info->delayed_iputs);
 	spin_unlock(&fs_info->delayed_iput_lock);
+	wake_up_process(fs_info->cleaner_kthread);
 }
 
 void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info)
-- 
2.14.3

