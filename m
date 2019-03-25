Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E7EC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EEDF206DF
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:18:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="k4ZcUZXS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbfCYSSE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:18:04 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:39730 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730086AbfCYSSE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:18:04 -0400
Received: by mail-pg1-f179.google.com with SMTP id k3so3272283pga.6
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 11:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k9jNmHA1qFep3iOscs1CEtcGDGAj9oKbLwgfGtQQXpE=;
        b=k4ZcUZXSz9qqAl2y7p/s0SVhhgTnMTZ4TGZnrUgxLRzY16eKPda7Fw8DJJ9iwrlO9c
         VMjrD/I8kpbQ5MVDtjc0GdAfPrcE6ScmqYVHyGwJCvKOcjELi74Vs3rCU74T3hnzPhHy
         dcaRFNou631zLIHPsiujiylnb3jKbi6Pk5w/UIS06gCfnsTlmG5/DrO3+n4ht7dDZoNF
         wZTIy/7uIJLsPOCWtxQRsXx88r2jUSXv+3ECy/NdruMzoNOP6iE1dMpEC0inom4osl51
         1ZQHAcKNbo1cZDmzCSDUwZqwRYNw97qOY+dMW/iBybXUXBx9cnpS23wv492riKzyVMDi
         3isg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k9jNmHA1qFep3iOscs1CEtcGDGAj9oKbLwgfGtQQXpE=;
        b=bvitA9gn0/VHyq1HMlK8+h7SfAHufkj5qd6THsVU027Bg4nNvMfZGsXK4Ci6zUm0vj
         eeoHBE59yi5UkVQwnG2WmGrr8bqkaos4CuQT1ZDmV+PrH5Xflmwz6uEXFQvSvFWIW/CC
         75n9Ais/3BZh3uDSYJ+BLhYRRjgOGUASlzcw17RYnvqGit/OFHPW622J7nnSIneI4ovb
         ZLy7hjD+tMSdnNaKQsVCW3NxJXCQIfjmxOzgSnZTjJidhy/VIjR3FI15RMFFIC6qW4Tx
         l0NCVIhU8hBJr6prVp96ieTCvCaHYbnnmDeUepDz7A8tXnapk04JtJmE/cgB+2G9QjTq
         WjNg==
X-Gm-Message-State: APjAAAXewANdX2Wu1BoiMktVIQgV3Vlf5gnGl6H//GTGShsfDsc6UB6r
        +XOQ9vqMjH3gdKjFeNoYE8yEKqttcPk=
X-Google-Smtp-Source: APXvYqzSTgfAyAGp7QE7/v24NLjQ/4bDMoaTGN2QAu8LHyQQQ0VV9KO96BnNk72MgFabrRN6Za7QMw==
X-Received: by 2002:a62:2bc8:: with SMTP id r191mr25579745pfr.102.1553537883244;
        Mon, 25 Mar 2019 11:18:03 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:200::3:b619])
        by smtp.gmail.com with ESMTPSA id j1sm19184279pgp.84.2019.03.25.11.18.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Mar 2019 11:18:02 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com
Subject: [PATCH] libbtrfsutil: don't close fd on error in btrfs_util_subvolume_id_fd()
Date:   Mon, 25 Mar 2019 11:17:56 -0700
Message-Id: <e9d3e2fd757f1a797089fa1122d4a7faa85c2ec8.1553537796.git.osandov@fb.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

The caller owns the fd passed to btrfs_util_subvolume_id_fd(), so we
shouldn't close it on error. Fix it, add a regression test, and bump the
library patch version.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Based on the devel branch.

 libbtrfsutil/btrfsutil.h                    |  2 +-
 libbtrfsutil/python/tests/test_subvolume.py | 12 ++++++++++++
 libbtrfsutil/subvolume.c                    |  4 +---
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index ad4f043e..0442af6e 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -27,7 +27,7 @@
 
 #define BTRFS_UTIL_VERSION_MAJOR 1
 #define BTRFS_UTIL_VERSION_MINOR 1
-#define BTRFS_UTIL_VERSION_PATCH 0
+#define BTRFS_UTIL_VERSION_PATCH 1
 
 #ifdef __cplusplus
 extern "C" {
diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index b06a1d3d..61055f53 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -64,6 +64,18 @@ class TestSubvolume(BtrfsTestCase):
             with self.subTest(type=type(arg)):
                 self.assertEqual(btrfsutil.subvolume_id(arg), 5)
 
+    def test_subvolume_id_error(self):
+        fd = os.open('/dev/null', os.O_RDONLY)
+        try:
+            btrfsutil.subvolume_id(fd)
+        except Exception:
+            pass
+        finally:
+            # btrfs_util_subvolume_id_fd() had a bug that would erroneously
+            # close the provided file descriptor. In that case, this will fail
+            # with EBADF.
+            os.close(fd)
+
     def test_subvolume_path(self):
         btrfsutil.create_subvolume(os.path.join(self.mountpoint, 'subvol1'))
         os.mkdir(os.path.join(self.mountpoint, 'dir1'))
diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index 60ab9f9d..f794868f 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -122,10 +122,8 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_id_fd(int fd,
 	int ret;
 
 	ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
-	if (ret == -1) {
-		close(fd);
+	if (ret == -1)
 		return BTRFS_UTIL_ERROR_INO_LOOKUP_FAILED;
-	}
 
 	*id_ret = args.treeid;
 
-- 
2.21.0

