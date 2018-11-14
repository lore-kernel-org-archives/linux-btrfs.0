Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB82FC18DF5
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B39DB21780
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="vh+8/G6k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B39DB21780
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731394AbeKNRtW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 12:49:22 -0500
Received: from mail-pl1-f182.google.com ([209.85.214.182]:36043 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728391AbeKNRtV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 12:49:21 -0500
Received: by mail-pl1-f182.google.com with SMTP id w24-v6so7387680plq.3
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 23:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bBcch75tUrNhQYuGSysBzFq1NancArmqbGRGhZuKqZA=;
        b=vh+8/G6kxCfnPFt0b0wh69zm9FCW5P9bMhvrZYhoelU5ZKRh17qqoPo40wutCjbVoP
         xP7novKQG+tb+JfNWz5Wzwq442Z02wj4bPp+3mrnY7kxRKyZ7LCdVtqllG4txEWasmWK
         U1avG2ad3EgB2u3LnVBYIqVB+SyLUEng14vLFHSP5rrQY7gipc1BuN5jfFzSqDjIj8Z1
         4mP5f9zyeXMwx2HARoa0R68QsS+d3gkYF5ttJ9c1TT7YO96dWF6usFxFrDzcEPzuKl9p
         PoYZEWQoM4X2YkuH9HaDcYN1DIroFmLH3pn3Wh0ap2OhJE4yGN/UvNIdfP3ckl7gCD9J
         wMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bBcch75tUrNhQYuGSysBzFq1NancArmqbGRGhZuKqZA=;
        b=qM1rRkzWx8eC/JsTGlhkeIo0yzfI4rgVjBfmltgnjvJ9hDTIIDsu2JzxkC+MTIbBPj
         4okKzu+EidBoj7jmavwIbMRGZXX3MsxPn+Qj1W5v+oua5+icZ5dkojgd5sv4wdEpmijZ
         G9LKUgo7Oz7g0k60QBDjX0lvON38ca+TKw36conLdjIlAkm9rMUzTcsHl1ZV/x2mmp+t
         YXeqiTCp1eLFYBcjPqk6kHHqert7bRAGK9cntFqZw5b6S2k5vxNOMNA8Mu0dcIc38gjW
         aJg37Bxi5sW1cNv2HuLuNXSEyGhBbEQvjTNl/QK2T6Zw1EiFPDWMYHVa8WdXSEPezgbx
         j6GA==
X-Gm-Message-State: AGRZ1gJIknm8bMfR48CYnPng0hvzfE5ibHm256WCtHhqY6gqj7Zrwk+O
        iuVLNFt0OwZPPjbwESxsaKSGx9bz2g8Wiw==
X-Google-Smtp-Source: AJdET5eCFcfh7qzHbvaBXLsTiLf6T/k1z+3WCxt/oE2gON4cT10Fbuzaroni1Flkv7E9DsjbtWrRfg==
X-Received: by 2002:a17:902:7442:: with SMTP id e2mr853765plt.67.1542181635868;
        Tue, 13 Nov 2018 23:47:15 -0800 (PST)
Received: from vader.psav.com ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id 18-v6sm34835727pfu.129.2018.11.13.23.47.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 23:47:15 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 03/10] libbtrfsutil: document qgroup_inherit parameter in Python bindings
Date:   Tue, 13 Nov 2018 23:46:58 -0800
Message-Id: <e0f6366a1a56f9ebfef731a2907002ecf08db333.1542181521.git.osandov@fb.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1542181521.git.osandov@fb.com>
References: <cover.1542181521.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

This has been supported since day one, but it wasn't documented.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/python/module.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
index 625cc9c6..f8260c84 100644
--- a/libbtrfsutil/python/module.c
+++ b/libbtrfsutil/python/module.c
@@ -233,15 +233,18 @@ static PyMethodDef btrfsutil_methods[] = {
 	 "this ID instead of the given path"},
 	{"create_subvolume", (PyCFunction)create_subvolume,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "create_subvolume(path, async_=False)\n\n"
+	 "create_subvolume(path, async_=False, qgroup_inherit=None)\n\n"
 	 "Create a new subvolume.\n\n"
 	 "Arguments:\n"
 	 "path -- string, bytes, or path-like object\n"
 	 "async_ -- create the subvolume without waiting for it to commit to\n"
-	 "disk and return the transaction ID"},
+	 "disk and return the transaction ID\n"
+	 "qgroup_inherit -- optional QgroupInherit object of qgroups to\n"
+	 "inherit from"},
 	{"create_snapshot", (PyCFunction)create_snapshot,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "create_snapshot(source, path, recursive=False, read_only=False, async_=False)\n\n"
+	 "create_snapshot(source, path, recursive=False, read_only=False,\n"
+	 "                async_=False, qgroup_inherit=None)\n\n"
 	 "Create a new snapshot.\n\n"
 	 "Arguments:\n"
 	 "source -- string, bytes, path-like object, or open file descriptor\n"
@@ -249,7 +252,9 @@ static PyMethodDef btrfsutil_methods[] = {
 	 "recursive -- also snapshot child subvolumes\n"
 	 "read_only -- create a read-only snapshot\n"
 	 "async_ -- create the subvolume without waiting for it to commit to\n"
-	 "disk and return the transaction ID"},
+	 "disk and return the transaction ID\n"
+	 "qgroup_inherit -- optional QgroupInherit object of qgroups to\n"
+	 "inherit from"},
 	{"delete_subvolume", (PyCFunction)delete_subvolume,
 	 METH_VARARGS | METH_KEYWORDS,
 	 "delete_subvolume(path, recursive=False)\n\n"
-- 
2.19.1

