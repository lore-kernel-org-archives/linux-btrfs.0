Return-Path: <SRS0=Oo12=3N=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0955AC32771
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Jan 2020 14:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D41FC2077C
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Jan 2020 14:33:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="RK8txTPJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391955AbgAXOds (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 24 Jan 2020 09:33:48 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46561 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404581AbgAXOdq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Jan 2020 09:33:46 -0500
Received: by mail-qk1-f196.google.com with SMTP id g195so2152463qke.13
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2020 06:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZyvR/29E2jaJfcsrXDpaKI230YXqgH46fp1QGEE+fWU=;
        b=RK8txTPJ9CxzuPDb7pXtJPFg098AdnH2bHyLBafbqvw9r5K0SKrCFy4TImhncmmhmy
         o0ztnYTm+n38J29N6Y4ttf/rm705FfSA5SxbBmQx0AK9eq+SIfjOmo4KXfF9UI8bD01O
         iMMeLV0XZ/NV3+kcPxaYTwASDq6pDrMt9E8fr2BnZ+GbvlurH87QWHnKopYtkdHJz446
         7oEdxLTHaxik9txGW55iT0NGaWsDrSo4rNKuliWFaUmSu5fqmbCL9hh546qnHfs4ZSF+
         qtRHbUFYziMev95fS7W47ngi9oD8BmoigMc9vyvI8ZuMOwf4pCAx03JQ6DG4KA/6TH/B
         sljA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZyvR/29E2jaJfcsrXDpaKI230YXqgH46fp1QGEE+fWU=;
        b=moKCgT4zWqcoSJJfGTmix9d/x7l0KGQZe0eM+n97se7sWLaNbsudbCIEVd/1x2mRuF
         xyVqsKBd+pR5hfxgm0tEtNwrhnxhluO+q1PV++37+ToR3rtzSvYrptsv0p8zYnU4V3eA
         PcJ1mfboX2LlvXZgpOlOaevDA5Z2ffMNMKtMLRiPpHkuySexs8rORJBJbEIiqc7We5g2
         Ff71gc57mN24nYnhZh2wkPlMOGBT+FE+XUOjk5U5yAtbs3hQ06KHxcKKHti395Jrh1Iz
         RNYB+8a83+nmXJjjr5RHHO2b8cxsqmJpVUc7ccx9fr/udgdhvRc8chzDCWmfEzfEPNbJ
         ZdvA==
X-Gm-Message-State: APjAAAWQ/M1k3AB3/fvByN4joK57WqSBvD5M5Jt12aak9fP2qSBTOwB9
        1g1YXRw0j/cC38iWuxsQa6KEkQ==
X-Google-Smtp-Source: APXvYqyjjPPUNyAMNj2Vd5H8Wao24Am+9qIE8vSir5mIb+RaB8q8UcgZ8ENZeNPfJDeFZ65rYNm2hw==
X-Received: by 2002:a05:620a:20db:: with SMTP id f27mr2525339qka.78.1579876425367;
        Fri, 24 Jan 2020 06:33:45 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id a24sm3117282qkl.82.2020.01.24.06.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 06:33:44 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 25/44] btrfs: hold a ref on the root in find_data_references
Date:   Fri, 24 Jan 2020 09:32:42 -0500
Message-Id: <20200124143301.2186319-26-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200124143301.2186319-1-josef@toxicpanda.com>
References: <20200124143301.2186319-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We're looking up the data references for the bytenr in a root, we need
to hold a ref on that root while we're doing that.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/relocation.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 9b61fdc89af7..0c75ae09a3a8 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3708,7 +3708,11 @@ static int find_data_references(struct reloc_control *rc,
 	root = read_fs_root(fs_info, ref_root);
 	if (IS_ERR(root)) {
 		err = PTR_ERR(root);
-		goto out;
+		goto out_free;
+	}
+	if (!btrfs_grab_fs_root(root)) {
+		err = -ENOENT;
+		goto out_free;
 	}
 
 	key.objectid = ref_objectid;
@@ -3821,6 +3825,8 @@ static int find_data_references(struct reloc_control *rc,
 
 	}
 out:
+	btrfs_put_fs_root(root);
+out_free:
 	btrfs_free_path(path);
 	return err;
 }
-- 
2.24.1

