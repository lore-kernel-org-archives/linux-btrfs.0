Return-Path: <SRS0=Ri2p=4V=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004A0C3F2D1
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Mar 2020 16:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDBB521739
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Mar 2020 16:18:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="ZModImvC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388293AbgCDQSp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 11:18:45 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42788 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388282AbgCDQSo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Mar 2020 11:18:44 -0500
Received: by mail-qt1-f193.google.com with SMTP id r6so1755877qtt.9
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Mar 2020 08:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=52QuRYoyyZaAbgdd8ICEkLGKU9LCKKQnjvmxbkT+rQk=;
        b=ZModImvC9EYCeSfrNgTkZaCshLFEPiqRxwBKqSp4cViVgckV+i+GzwhY0SreJB4xb7
         lltVyysdUhVtjLFxKHcYlU1/vmjT1TK4GLq0Jf/dlPBhhVwdVP5E7iA6aqkPRGFLHiVx
         3XfL/++YKBYdzG0z5p++EeUrVVEbgvPkJEPjZwopPEwUpzT3Bg/L26GWCl8yWS8uOZ4s
         ug91Bv/lQtOkbsh9BmIaXIIhuuzumuH3f7ulRDaYm+vjL8YlDFnnDzo7JygUI2C3sKaW
         XBIQDG10WWCgpDgd8HQP/d//KKp0Zg7Ns7SMWPJX2nCU1rlLHjXobcS6n6Lc5hIJvIoC
         f5ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=52QuRYoyyZaAbgdd8ICEkLGKU9LCKKQnjvmxbkT+rQk=;
        b=S5MxAmRr8A1K5sjMMHo4Znn33lHq/uHS9W1R2H9+r+upQaK4nmnDpKAFUCNLx1Qpxp
         Q4Y6SW8TLddnUqLYrLd0UfX+hkzdlSMYj30CjpZ/GHMEHqgU5SEEHcg/MMOZj6xFIVdS
         opXwrpPqEAzIGMkB/vYKa56tDUVm/MCDiuR/O/087T6cOKW7avSSKiidQZpCswsPQxxv
         wknezwpDFBMBnGENCDa3qkh+NT0D7Hjj5DTTDWXYO371ubGltFHwPacs1i8XyvIDBCdC
         yh1T7/ylWd/IKCTLFDdiL7s3EI1hQVmIsBH1FM1MhmFjaVhZ7noyZTRyYGQZI1QD1QB7
         +Kig==
X-Gm-Message-State: ANhLgQ0x7e4bao5UrAY+HZy3Iq3xJiwVcCt6VNH05i1VVG9nZDkDE/pt
        YydBghCPjBvUJVmv171mNviCcSj1Hoo=
X-Google-Smtp-Source: ADFU+vtvnKUd2mPJuXYzTfMEj7IuOruFYk2/OZsmyydoXrRgSY8u0M4InV9bxpEq6ym0kBge2JJYdw==
X-Received: by 2002:ac8:6e88:: with SMTP id c8mr3205707qtv.40.1583338723505;
        Wed, 04 Mar 2020 08:18:43 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id a6sm12659991qkn.104.2020.03.04.08.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 08:18:42 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 6/8] btrfs: clear BTRFS_ROOT_DEAD_RELOC_TREE before dropping the reloc root
Date:   Wed,  4 Mar 2020 11:18:28 -0500
Message-Id: <20200304161830.2360-7-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304161830.2360-1-josef@toxicpanda.com>
References: <20200304161830.2360-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We were doing the clear dance for the reloc root after doing the drop of
the reloc root, which means we have a giant window where we could miss
having BTRFS_ROOT_DEAD_RELOC_TREE unset and the reloc_root == NULL.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/relocation.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 53509c367eff..ceb90d152cdd 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2291,18 +2291,19 @@ static int clean_dirty_subvols(struct reloc_control *rc)
 
 			list_del_init(&root->reloc_dirty_list);
 			root->reloc_root = NULL;
-			if (reloc_root) {
-
-				ret2 = btrfs_drop_snapshot(reloc_root, NULL, 0, 1);
-				if (ret2 < 0 && !ret)
-					ret = ret2;
-			}
 			/*
 			 * Need barrier to ensure clear_bit() only happens after
 			 * root->reloc_root = NULL. Pairs with have_reloc_root.
 			 */
 			smp_wmb();
 			clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
+
+			if (reloc_root) {
+
+				ret2 = btrfs_drop_snapshot(reloc_root, NULL, 0, 1);
+				if (ret2 < 0 && !ret)
+					ret = ret2;
+			}
 			btrfs_put_root(root);
 		} else {
 			/* Orphan reloc tree, just clean it up */
-- 
2.24.1

