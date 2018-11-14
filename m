Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E10C43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0C4821780
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="xwfmpBQj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0C4821780
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731325AbeKNRtV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 12:49:21 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39140 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbeKNRtU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 12:49:20 -0500
Received: by mail-pg1-f195.google.com with SMTP id r9-v6so6980341pgv.6
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 23:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pR4fibd0T4/N6AQiNNQDrJGJeCZwSh47DF+fpOzjcjM=;
        b=xwfmpBQjjbhvOQsY+DtXQqT3qcOo8zttw6cPiAsE0cYLvpcrPVIvMN5fqQtkUEIDHV
         y6XIV3bhskdWhNHRaur27NgubRo7GDCfm830/Neg4yS9XfsNLijgUl3g60o9oI8zm2mF
         L4Efu3k/3+QwGqT7E0+I+t4OZmiHBCDyxjNfkfufC6As6HC4+i+iYTeSljZtVspOgcLb
         TM9FhQkOg2fXAgTMhF8OGFRUoTHzb9oBVgWE234YiescUbzFufsECoVZcl22+uDFWL1x
         c+WROd8jSCQ8pVLBxcZuRMfERP4x5fUFgNcF/3Hihi+gVLQ7+t2hnKcgFziRxu+98wLE
         Jvvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pR4fibd0T4/N6AQiNNQDrJGJeCZwSh47DF+fpOzjcjM=;
        b=DyZ5Wp7AYQAAPskW4MV+m1d3JXTH1UUmuX66jcSCbmER4FKXIRT0nW1kO2Exj4WecL
         SkfWKYmc3cQcXpjN8uPQfOC/i+vyujexqO+yPL9oxypu+Cj3vK11z+Yx1c77UQYf2xjt
         WrOMjD4CQj/laeaJf8XJAOxV1bQZ2MrJMrv5Mhf3bKul0Z6lkeDXdf03BcaMALUWWgGJ
         DDOlplDt4M8FkFwXzueoh0dGIFT5DO1NYyCSlOEC/kIGvAT7JYRuTifFo/iSHlnN5yeC
         i/fwJ/lS0BpQvbtH3CWeUJPBAdJneMFF7KOS7m3NwDfO/PmKZPBylTUBuouG9xt4/+b/
         cqyA==
X-Gm-Message-State: AGRZ1gL4wIPCOL/ucbm+kKtus6Rdk7WQBfwGcsfly9bDsA5N4YmDV5uQ
        XkaKSBGo10FVME9BJ1yn1Bi7lu+mp+sbJQ==
X-Google-Smtp-Source: AJdET5eyGrBQUYjVmZnFrt5Yybp382EyM4q7uzh+bEzRMRAaj73MIEO+ess9yMwycE9P9Rm/atE9Rw==
X-Received: by 2002:a63:df13:: with SMTP id u19mr799080pgg.294.1542181635153;
        Tue, 13 Nov 2018 23:47:15 -0800 (PST)
Received: from vader.psav.com ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id 18-v6sm34835727pfu.129.2018.11.13.23.47.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 23:47:14 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 02/10] libbtrfsutil: change async parameters to async_ in Python bindings
Date:   Tue, 13 Nov 2018 23:46:57 -0800
Message-Id: <4a54e26de572dd857f6cd356f71416226d8c58f2.1542181521.git.osandov@fb.com>
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

async became a keyword in Python 3.7, so, e.g., create_subvolume('foo',
async=True) is now a syntax error. Fix it with the Python convention of
adding a trailing underscore to the keyword (async -> async_). This is
what several other Python libraries did to handle this.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/python/module.c                | 8 ++++----
 libbtrfsutil/python/subvolume.c             | 4 ++--
 libbtrfsutil/python/tests/test_subvolume.py | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
index 2dbdc7be..625cc9c6 100644
--- a/libbtrfsutil/python/module.c
+++ b/libbtrfsutil/python/module.c
@@ -233,22 +233,22 @@ static PyMethodDef btrfsutil_methods[] = {
 	 "this ID instead of the given path"},
 	{"create_subvolume", (PyCFunction)create_subvolume,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "create_subvolume(path, async=False)\n\n"
+	 "create_subvolume(path, async_=False)\n\n"
 	 "Create a new subvolume.\n\n"
 	 "Arguments:\n"
 	 "path -- string, bytes, or path-like object\n"
-	 "async -- create the subvolume without waiting for it to commit to\n"
+	 "async_ -- create the subvolume without waiting for it to commit to\n"
 	 "disk and return the transaction ID"},
 	{"create_snapshot", (PyCFunction)create_snapshot,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "create_snapshot(source, path, recursive=False, read_only=False, async=False)\n\n"
+	 "create_snapshot(source, path, recursive=False, read_only=False, async_=False)\n\n"
 	 "Create a new snapshot.\n\n"
 	 "Arguments:\n"
 	 "source -- string, bytes, path-like object, or open file descriptor\n"
 	 "path -- string, bytes, or path-like object\n"
 	 "recursive -- also snapshot child subvolumes\n"
 	 "read_only -- create a read-only snapshot\n"
-	 "async -- create the subvolume without waiting for it to commit to\n"
+	 "async_ -- create the subvolume without waiting for it to commit to\n"
 	 "disk and return the transaction ID"},
 	{"delete_subvolume", (PyCFunction)delete_subvolume,
 	 METH_VARARGS | METH_KEYWORDS,
diff --git a/libbtrfsutil/python/subvolume.c b/libbtrfsutil/python/subvolume.c
index 6ecde1f6..0f893b91 100644
--- a/libbtrfsutil/python/subvolume.c
+++ b/libbtrfsutil/python/subvolume.c
@@ -322,7 +322,7 @@ PyObject *set_default_subvolume(PyObject *self, PyObject *args, PyObject *kwds)
 
 PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds)
 {
-	static char *keywords[] = {"path", "async", "qgroup_inherit", NULL};
+	static char *keywords[] = {"path", "async_", "qgroup_inherit", NULL};
 	struct path_arg path = {.allow_fd = false};
 	enum btrfs_util_error err;
 	int async = 0;
@@ -352,7 +352,7 @@ PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds)
 PyObject *create_snapshot(PyObject *self, PyObject *args, PyObject *kwds)
 {
 	static char *keywords[] = {
-		"source", "path", "recursive", "read_only", "async",
+		"source", "path", "recursive", "read_only", "async_",
 		"qgroup_inherit", NULL,
 	};
 	struct path_arg src = {.allow_fd = true}, dst = {.allow_fd = false};
diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index 0788a564..f2a4cdb8 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -202,7 +202,7 @@ class TestSubvolume(BtrfsTestCase):
         btrfsutil.create_subvolume(subvol + '6//')
         self.assertTrue(btrfsutil.is_subvolume(subvol + '6'))
 
-        transid = btrfsutil.create_subvolume(subvol + '7', async=True)
+        transid = btrfsutil.create_subvolume(subvol + '7', async_=True)
         self.assertTrue(btrfsutil.is_subvolume(subvol + '7'))
         self.assertGreater(transid, 0)
 
@@ -265,7 +265,7 @@ class TestSubvolume(BtrfsTestCase):
         btrfsutil.create_snapshot(subvol, snapshot + '2', recursive=True)
         self.assertTrue(os.path.exists(os.path.join(snapshot + '2', 'nested/more_nested/nested_dir')))
 
-        transid = btrfsutil.create_snapshot(subvol, snapshot + '3', recursive=True, async=True)
+        transid = btrfsutil.create_snapshot(subvol, snapshot + '3', recursive=True, async_=True)
         self.assertTrue(os.path.exists(os.path.join(snapshot + '3', 'nested/more_nested/nested_dir')))
         self.assertGreater(transid, 0)
 
-- 
2.19.1

