Return-Path: <SRS0=Oo12=3N=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A483FC2D0DB
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Jan 2020 14:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B04E2077C
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Jan 2020 14:34:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="aHknNs1v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404667AbgAXOeK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 09:34:10 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42101 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390638AbgAXOeJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Jan 2020 09:34:09 -0500
Received: by mail-qt1-f195.google.com with SMTP id j5so1625474qtq.9
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2020 06:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7dXPcLtcCSCDRGETr4vm+QgKm0KbD9S2RIf4ehLy/AM=;
        b=aHknNs1vYy4c796nT4joO5f+xrpJX44v66v4fQ/nSWRNNUqxqIR967pid6byoAIvRb
         qZ9YzUWhtmnXmuBkXEyQk6hgkquuhFpxImLh66aCqjJZFyeQKlBy+2r3fO3N+YC5NZ3b
         Glrkai+Kx/7Ee8A0ZbK4L8AJ+p8brqha3N5Iw/35syr98AGVIRtBeecY5cgCI9DWJ4/U
         2eN5J4aPTZ6XNdhnk9MdIOuTxn7LW4nqi5JYuPR0wuLaKEGJ+o6A5uoHJqIp/ApsBtDl
         0lpDp6BDLqTyhc2uitUnKGIlo+nQIyGu5a683TKtlkjrqDUux8Zdkr/WHOh8jtt/Kkby
         b5lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7dXPcLtcCSCDRGETr4vm+QgKm0KbD9S2RIf4ehLy/AM=;
        b=ObPpy6dMfiZTfDrmc1m2IZne0kxq3O4bcXxtj1IXv2FES1+59powqCL+O5K40CsCB2
         cW4HovAbZp3zniOfxRWvgYqV6AgcKcr1cDsSKrTnZfWiun844iEqp+ov7bn+64bKeObW
         S0mdap69y8SGCz8r99h6tnZsSjL3KElxQyjpjtfTMwsKjLtfm5nV8QqIqmPkJbjrVRqc
         FL2FvaYOoyr/zDui7mfdOWq8U9so/ksCMPWG5DD9MnhYJFWr6E1UbS7VGprHkTajRxDe
         uLyldcwxJGdPNEDFEpWVed02Q0EGhuUpicQLLzB8otK3gw/OuxySGwAxBQJrzaZNtyHM
         RImw==
X-Gm-Message-State: APjAAAXH+wUnL+hsmeHTiSIILGc4jnLcW8BR/kb/+F+uhMqqERItDYbF
        gceom9KGdKcaqRobq+LJtUrK2Q==
X-Google-Smtp-Source: APXvYqxPepp8gJYxm/GoWW3ZccToAAQWSTJl8A4cIxMPR5/GN+Nz0+Dgt2iDFPFzeNP+aOp/VuyWkw==
X-Received: by 2002:ac8:43ce:: with SMTP id w14mr2366286qtn.256.1579876448040;
        Fri, 24 Jan 2020 06:34:08 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id t29sm2995410qkm.27.2020.01.24.06.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 06:34:07 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 35/44] btrfs: hold a ref on the root in btrfs_check_uuid_tree_entry
Date:   Fri, 24 Jan 2020 09:32:52 -0500
Message-Id: <20200124143301.2186319-36-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200124143301.2186319-1-josef@toxicpanda.com>
References: <20200124143301.2186319-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We lookup the uuid of arbitrary subvolumes, hold a ref on the root while
we're doing this.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/volumes.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ce3eff93c366..527b0b41ebdc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4382,6 +4382,10 @@ static int btrfs_check_uuid_tree_entry(struct btrfs_fs_info *fs_info,
 			ret = 1;
 		goto out;
 	}
+	if (!btrfs_grab_fs_root(subvol_root)) {
+		ret = 1;
+		goto out;
+	}
 
 	switch (type) {
 	case BTRFS_UUID_KEY_SUBVOL:
@@ -4394,7 +4398,7 @@ static int btrfs_check_uuid_tree_entry(struct btrfs_fs_info *fs_info,
 			ret = 1;
 		break;
 	}
-
+	btrfs_put_fs_root(subvol_root);
 out:
 	return ret;
 }
-- 
2.24.1

