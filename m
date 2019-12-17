Return-Path: <SRS0=yR0V=2H=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C6CC43603
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Dec 2019 15:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69A8F24655
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Dec 2019 15:37:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="RjPJnR0y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbfLQPhB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 10:37:01 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33983 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbfLQPhB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Dec 2019 10:37:01 -0500
Received: by mail-qt1-f196.google.com with SMTP id 5so9055391qtz.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2019 07:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=jfbRXZ/5/MBFQWWw54MEoM9lTLz/KmX5CXwHy/coLzY=;
        b=RjPJnR0yMps+levKWrQPbjXrTjaY9wQL7LyAzOgI4txpIknMFGhinf8aAiZaSCs1Da
         kU5P7NeRUSP4OJMFKQNPB1Jp4ddWITuiBUaIa9yS4RKGTw1S9NiJJkX2dTzQniZIGidZ
         +oDKP8kenrR0kYcDt3T60DlJjcWu1CTt2v3Mgy80UP7gVowDFCHEPSbvTeMAfQsZPvcY
         HFdprSYivD3WkObfrmpj5vx6U8ewI6F5A3C6/KTXzEgzALPWYYhuIcUD1j1DJUQ/s6U0
         J9/brhrCuENfPbTh1cKoTQ1z4iBu8yWodiH80fibdUq+rDHZI+Y1G6fGGrxtzU18Yrns
         E7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jfbRXZ/5/MBFQWWw54MEoM9lTLz/KmX5CXwHy/coLzY=;
        b=R4g8aKdC+IvvypxwitNiOh9wAUrimw3y56Gg8KSnR4PZCxZBHBBK9PDbBcz/2xUxPn
         kVK/3Qe5KTL2fSVyjpHtbrZwJzQPUJKGHKTbJrrjKfdeMt86eCMyD097yqTNFhiqNpYm
         vUR6icRVowp3ki4PXCN/RX3uyh5xDnw9pwS8cRtUn79uu1rb4tuOkTJSa5Pza1ck4qU2
         3W5FTSlShqzZ7KwzBmDHA8yQupTOOlwUvs2sWPbaaGyCHBoiStfYX+jQdv99jnXl7sU8
         t2/qq8EhOsZdbCHwn06QB+Oh9Rby0iisp5r+x206o0uHCQbnCSvj3II/SzB7qL66FE0N
         hb/Q==
X-Gm-Message-State: APjAAAVrWhNuU8TIrXresugW4w1yXWeeR/vvCKTxe5c5budwDxwI0Gis
        G50Qk05W3oxnpYKCtLCMQ68g+FB1t3twSQ==
X-Google-Smtp-Source: APXvYqxLP9uDseBucxwtIIRZbCqN3v2QMTrLg7310OL/6oT5kAgrc8pYZDsoaUMhIgMTsz4oIIQmDA==
X-Received: by 2002:ac8:4117:: with SMTP id q23mr5135825qtl.66.1576597019897;
        Tue, 17 Dec 2019 07:36:59 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c6sm7120858qka.111.2019.12.17.07.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 07:36:59 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 12/45] btrfs: hold a root ref in btrfs_get_dentry
Date:   Tue, 17 Dec 2019 10:36:02 -0500
Message-Id: <20191217153635.44733-13-josef@toxicpanda.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191217153635.44733-1-josef@toxicpanda.com>
References: <20191217153635.44733-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Looking up the inode we need to search the root, make sure we hold a
reference on that root while we're doing the lookup.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/export.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 08cd8c4a02a5..eba6c6d27bad 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -82,12 +82,17 @@ static struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
 		err = PTR_ERR(root);
 		goto fail;
 	}
+	if (!btrfs_grab_fs_root(root)) {
+		err = -ENOENT;
+		goto fail;
+	}
 
 	key.objectid = objectid;
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 
 	inode = btrfs_iget(sb, &key, root);
+	btrfs_put_fs_root(root);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		goto fail;
-- 
2.23.0

