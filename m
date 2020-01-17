Return-Path: <SRS0=6qVc=3G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F5C0C33C9E
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Jan 2020 21:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 134812072E
	for <linux-btrfs@archiver.kernel.org>; Fri, 17 Jan 2020 21:26:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="ZoCaja3s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgAQV0f (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 17 Jan 2020 16:26:35 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45246 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAQV0e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Jan 2020 16:26:34 -0500
Received: by mail-qk1-f193.google.com with SMTP id x1so24105094qkl.12
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jan 2020 13:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hA4iNKOpd+uPQ09XByOlq3GwjvuYpxH5XpAmxRgdPC0=;
        b=ZoCaja3sLeNcJ+BWgERcud69owa1LWjcRMW015i5/toCV9BLdStEDMOEgnyTYQfTRV
         fqhErjt/gs/lacDSEQH9DdzobzNliUSugF43Wq6Q+Ba1hYjp0N2B6J77mNMzkJUqXcEd
         lEe0QOj1TkhOmWxqnQb2Z9/bg82izw1HM+Zw8resNvDI89n/wo95AOsbSX9Q9uUU21Ka
         OBJk942Pg/ad6RN2UoTNmNYo60LkFlUFjeqoXbrcvKXMFhRkKmJWwZ8/iHX6ASKg/FFW
         RHo4ge70QEmZ3sq6EuMP/YyUL46nFQYcUckMfBK34npktqGlsQTG53Ikzw+775LweX5h
         5kBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hA4iNKOpd+uPQ09XByOlq3GwjvuYpxH5XpAmxRgdPC0=;
        b=TKXxSYu1iKTQLQ6JmmlPQpB0fBEA8uPn/6uzNbatbuHC2bc6y3ygLqAfl2hZ8qZyOk
         rYM6PVPVxswftRZ00GCWjgyVsx4gbKfZtcXucObs4BTpyK4JoB6SbpTGL3nEBGFd/rPn
         a8GZIUZ5ZO7vgrnKXETBVf47UXX72k6UFskXiJS2P6y5GVfKqPJACXob1C5pPMqOtM/v
         HDhO8OMt4pkLmBVQP7ZwHEB7D6CmQtB9b+X0jxAKVo0ff4RtWpzwdYtetIHKsHDjK4+1
         NWCy3z4OS9xX/VVgBQGqImDXEQKfl2Bn7NSScOCyqZQfTSKjHvKfVxmXMLug/kN7SolW
         0nPw==
X-Gm-Message-State: APjAAAXRqipyrrssBEk7ZyZs4+7otWkJD/VeaQYuy5CESL+VYD8H3SRf
        ooTUB1+UHePvZcvLPev/4kBSWX6Hw0UKOw==
X-Google-Smtp-Source: APXvYqwajqwpHcUntCqjc62FF6S8IWhqlq0KmXTIGBGnKM/NCoZlFktVxIG6K0BNmLLLO7liU84ljw==
X-Received: by 2002:a37:a215:: with SMTP id l21mr35055065qke.87.1579296393394;
        Fri, 17 Jan 2020 13:26:33 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id s26sm13888282qtc.43.2020.01.17.13.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 13:26:32 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 15/43] btrfs: hold a ref on the root in create_subvol
Date:   Fri, 17 Jan 2020 16:25:34 -0500
Message-Id: <20200117212602.6737-16-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117212602.6737-1-josef@toxicpanda.com>
References: <20200117212602.6737-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We're creating the new root here, but we should hold the ref until after
we've initialized the inode for it.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 958c0245c363..b1d74cb09cb4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -672,10 +672,16 @@ static noinline int create_subvol(struct inode *dir,
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
 	}
+	if (!btrfs_grab_fs_root(new_root)) {
+		ret = -ENOENT;
+		btrfs_abort_transaction(trans, ret);
+		goto fail;
+	}
 
 	btrfs_record_root_in_trans(trans, new_root);
 
 	ret = btrfs_create_subvol_root(trans, new_root, root, new_dirid);
+	btrfs_put_fs_root(new_root);
 	if (ret) {
 		/* We potentially lose an unused inode item here */
 		btrfs_abort_transaction(trans, ret);
-- 
2.24.1

