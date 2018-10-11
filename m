Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC4C4C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EC3820835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="nBDCdAUw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EC3820835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbeJLDY3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:29 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37663 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbeJLDY3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:29 -0400
Received: by mail-qk1-f196.google.com with SMTP id x8-v6so6281747qka.4
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=zZszbBJ2wYqnRaCO5pCUOw7tHC5U99aK2TNTpFeSZ9Q=;
        b=nBDCdAUw2Q0vveKaqzIG6aPL4eSDLhbWZWC8o2o9qvuYTE8wO/YzylvlKP0y+rse8M
         Npunmex3nMXrmgiUZ0qPNp6uUYUAyP9ZBHM48c//VPIjyLl2FfADll8KRaaRYTkwOKS9
         6UG7uZoy0hwFzYWwjMVKCDmroB/purcO1lnxNKTE+TjQlmd4eQ/Q3pD59jwyIetQKgwI
         L26UJ6YcyDqeccRth1UBHEH81DV1iCmYhl6LTuAnwaFU71bcVpt+eY84h059Sq/1f2n8
         G+lheiY6zR2oln9RVl76GANaO0bRC6M+WdX6VVvXWfZp0zsQIfnK116eleVZ/rwpt8Sb
         zxbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=zZszbBJ2wYqnRaCO5pCUOw7tHC5U99aK2TNTpFeSZ9Q=;
        b=Tv6AAqm65cpEUND57jte3vHOdFb2KQGYYm0zxn6tO8hnMVVRuHUw5cLgOfLppiccgO
         3KY21c+o/aE7qmq3km0vQc5yzwjPemFDUzHFIbeLubjf9GOAbIg3rmHRrG7WhUbKcrot
         1JFRSLPwV5jX9TBK+iWXLaVAv9075iKBwhFM59vRUzhimsFkWK9LA/Zg6eGDQjXnIayW
         OZHT1W+UzQ4ItQtrkhyc6vqUEWhOS7EsvAxBa3pTwJOD59EGUDdrAApyUL209J2N2Prr
         lM/MqJnB0jktJWEdCVJVsaXbhkjOWoqULHG0O/HJ6W0vPQUToWG3pUNc5Wa1dP/2Pz0Z
         YDyg==
X-Gm-Message-State: ABuFfohY9f7WMkNncGx12+3InuEQXP0qdNev8+xG/shi5+RRGXwa8Ufs
        3cmWA6HELJ9dOpGOFlpkblk46HddSNo=
X-Google-Smtp-Source: ACcGV63lQ7KJVLOL5Fo3+8fXiJi218vxi2wuRm8D5yRB7JuBFg9x5/9wHNKkN1DUKJI96jqqOD7Edw==
X-Received: by 2002:a37:c03:: with SMTP id 3-v6mr2825227qkm.51.1539287743005;
        Thu, 11 Oct 2018 12:55:43 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id m64-v6sm13210156qkf.18.2018.10.11.12.55.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:42 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 37/42] btrfs: wakeup cleaner thread when adding delayed iput
Date:   Thu, 11 Oct 2018 15:54:26 -0400
Message-Id: <20181011195431.3441-38-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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
index 2b257d14bd3d..0a1671fb03bf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3323,6 +3323,7 @@ void btrfs_add_delayed_iput(struct inode *inode)
 	ASSERT(list_empty(&binode->delayed_iput));
 	list_add_tail(&binode->delayed_iput, &fs_info->delayed_iputs);
 	spin_unlock(&fs_info->delayed_iput_lock);
+	wake_up_process(fs_info->cleaner_kthread);
 }
 
 void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info)
-- 
2.14.3

