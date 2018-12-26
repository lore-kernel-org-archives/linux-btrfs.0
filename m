Return-Path: <SRS0=cHbd=PD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7F0C43444
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Dec 2018 03:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BF3B2148D
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Dec 2018 03:46:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="bDK7+8ul"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbeLZDqh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Dec 2018 22:46:37 -0500
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:58220 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbeLZDqg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Dec 2018 22:46:36 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 4CE12AA6
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Dec 2018 03:46:35 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nYC6mOaIJXSG for <linux-btrfs@vger.kernel.org>;
        Tue, 25 Dec 2018 21:46:35 -0600 (CST)
Received: from mail-it1-f197.google.com (mail-it1-f197.google.com [209.85.166.197])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 210D29E7
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Dec 2018 21:46:35 -0600 (CST)
Received: by mail-it1-f197.google.com with SMTP id j3so17622011itf.5
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Dec 2018 19:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=TtSxfEQF5LcUD9sDnfZ8/Cq5qwU6OBjp2xesuZJmp30=;
        b=bDK7+8ulXPDCF6xXIo6GnyvOvEnaYz0RspwPrgXlrsxIcPGUnpcBJTxTCuo2XBuWzF
         2ocJRH8TAjz9guxrdXXXX8OanvnzZkH7o2IBjzK7kbPwQzdmFLVodA0qRN+ChXPwWAkz
         tip3Nbdht8ccBJdrFBqZeZO4dOUaIv8mNK/2I5L9lQmz2DWj2AcODoyEk34waVfv8Zv7
         ofhhLf4Zwiaf1QKVYGuZfBOg0WFjhqHXX2ZIz4ePqT2S0/JjK4x2MH8Sc1RQME052HRl
         Z4tJJO63qQ8MbIq5UOosYu0Rp56F03HnirRMG69cTrEboAASp9Kx8H6hs3EoNH8meLbi
         Sb2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TtSxfEQF5LcUD9sDnfZ8/Cq5qwU6OBjp2xesuZJmp30=;
        b=pivMoJ06h6BZ2Floj51hwWf1qaKqha8pGmOMCMj8Xows7DtVECFKog4t253dyr5fqu
         iJ5eM/gypUXiYmNJNAhMnoxIOeP87TX5eP0QXnh4vGvj8fqOm05zlGiilxDaBMHUdEP7
         nOjTDRTwM1XFeArq+bK+nKZnk88EwELtcshFX4m+SkbivMkggpReJuQyYVAT2cOAYk64
         Pe2UqfVie1QEHSgGV9Oya5o3pXNbcZusG3u4ra4/7INqthWrDMaoT/kHNCMLeVOSjcGe
         H+u/Jm+64H8W3iwKrZUgnaFSqkW7RJ/pc3GHxB3/P1rsCOOOyjwVx5uJGUeLeJZr2YHK
         zGkg==
X-Gm-Message-State: AJcUukca0ZfRFTrF8F9H7BMEyIWB33AA1gXDRK1Vml6ICsy7K5tX88Fs
        vwmfEyzuV0Pm92E2L8v6VVNXytZuN9cWz9YFRUL5bCBE8tH3cw7y5csrB9z5KUyMI8MCnIyDSpA
        YP+STnLlKVVg90pf/3KWdqLRvKS4=
X-Received: by 2002:a6b:1807:: with SMTP id 7mr11823310ioy.167.1545795993971;
        Tue, 25 Dec 2018 19:46:33 -0800 (PST)
X-Google-Smtp-Source: ALg8bN5ai2uAQEIacv8zjvRRrDGodWoIrj/VDxN35dP5YyRZ3O1o6xK1rwPNNSob0wxHSopDuJ9OIQ==
X-Received: by 2002:a6b:1807:: with SMTP id 7mr11823304ioy.167.1545795993728;
        Tue, 25 Dec 2018 19:46:33 -0800 (PST)
Received: from localhost.localdomain (host-173-230-104-22.mnmigsc.mn.minneapolis.us.clients.pavlovmedia.net. [173.230.104.22])
        by smtp.gmail.com with ESMTPSA id r21sm15723976ioc.18.2018.12.25.19.46.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 25 Dec 2018 19:46:33 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: add a check for sysfs_create_group
Date:   Tue, 25 Dec 2018 21:46:06 -0600
Message-Id: <20181226034607.73523-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In case sysfs_create_group fails, let's check its return value and
issues an error message.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 fs/btrfs/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 3717c864ba23..62529153a51a 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -889,6 +889,8 @@ void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
 	 */
 	sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
 	ret = sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
+	if (ret)
+		pr_err("failed to create btrfs_feature_attr_group.\n");
 }
 
 static int btrfs_init_debugfs(void)
-- 
2.17.2 (Apple Git-113)

