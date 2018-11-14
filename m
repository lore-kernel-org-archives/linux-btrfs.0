Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 506A2C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16B8321780
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="qTRlSds+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16B8321780
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731880AbeKNRtZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 12:49:25 -0500
Received: from mail-pf1-f171.google.com ([209.85.210.171]:33199 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbeKNRtX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 12:49:23 -0500
Received: by mail-pf1-f171.google.com with SMTP id v68-v6so7491174pfk.0
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 23:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L4FYu0s+Pjrrtgf1CKL78vdtZqAqBMq0vesrvAkBMRc=;
        b=qTRlSds+x0DXI01TT7oPdU82ZYyMoz2xmS6CQVz1Jhn3gV2erf9zUhRXU29Fxk2GQi
         8a3/8NUwRv05cuShUDL1e/EJbirWr/gOoYb9I1ho9psEkpumaLAOU23n61KOnzJgYoP4
         ecnoG137ZGlfXqFz6hg55PKoMzPxjLv2BVsi5MpN9zzh3F+BVOC4A7Ugy8dzNEDDThSo
         wpkO43kEfUSUk4Hsb/PDusrMD4TJt46PrOVpP/+k+vlFOg0yGG/HK/I982DCpmoFC7CB
         XMXo1pqM2Frbm3zfAgpR1ZWHyyoYoXWkdVIXMz/n1xXtz5uX18aOA/pI40WWNOBIJBeQ
         yT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L4FYu0s+Pjrrtgf1CKL78vdtZqAqBMq0vesrvAkBMRc=;
        b=C+ajBd9B0YWJGknQldQqkizl9C1r99FIQvnhclwik10/7K2v/Fv2g1CJVEvJ4w3G0s
         ZSfvOCD+9nWJqp29iLtOrHxSqLyThJHY7YC3g+dXMozBDKAOLDysaFWwuCT8vm4zcjzB
         D4Tm7ymO8n7AFaAG+vxXw6RSX5Ej1io6hnhIdJSc0mVAKL2pidf6QbcaS1KDad0/UEwv
         dYkuU82iUlEJhZmiSgJRRRBKAA14wbc7T5UppNsyyy5LCrvx0dCWcRdyEJjyHjFoh5dE
         A0jzIVdl3s42x/mwx4NqSai/hUHEd7D+1DzUpQhW+ZSNTKWpFvUx2qSmuDUiEurY07pn
         YJMg==
X-Gm-Message-State: AGRZ1gIrqkgO2GP2hf+zEuCD3HEtyCFVXyeprmIjUPcnIPuwAKJwpjVn
        bQj9yUuEkz54aofAWNdkPnWga3iChaFUuw==
X-Google-Smtp-Source: AJdET5e0SrhLAhC+BOkTb4EmBCQQumGmne0egEJ0LEdZ2Vgv9782nWL9rxYlJCAUkOp/wU9cN+2ITw==
X-Received: by 2002:a63:c0f:: with SMTP id b15mr800554pgl.314.1542181638092;
        Tue, 13 Nov 2018 23:47:18 -0800 (PST)
Received: from vader.psav.com ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id 18-v6sm34835727pfu.129.2018.11.13.23.47.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 23:47:17 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 06/10] libbtrfsutil: allow tests to create multiple Btrfs instances
Date:   Tue, 13 Nov 2018 23:47:01 -0800
Message-Id: <430c01a9d6a0ebdd4dbeb91e029d56328fc751fd.1542181521.git.osandov@fb.com>
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

Some upcoming tests will need to create a second Btrfs filesystem, so
add support for this to the test helpers.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/python/tests/__init__.py | 35 +++++++++++++++++----------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/libbtrfsutil/python/tests/__init__.py b/libbtrfsutil/python/tests/__init__.py
index 4bc11990..9fd6f6de 100644
--- a/libbtrfsutil/python/tests/__init__.py
+++ b/libbtrfsutil/python/tests/__init__.py
@@ -57,14 +57,18 @@ def regain_privs():
 
 @unittest.skipIf(os.geteuid() != 0, 'must be run as root')
 class BtrfsTestCase(unittest.TestCase):
-    def setUp(self):
-        self.mountpoint = tempfile.mkdtemp()
+    def __init__(self, *args, **kwds):
+        super().__init__(*args, **kwds)
+        self._mountpoints = []
+
+    def mount_btrfs(self):
+        mountpoint = tempfile.mkdtemp()
         try:
             with tempfile.NamedTemporaryFile(delete=False) as f:
                 os.truncate(f.fileno(), 1024 * 1024 * 1024)
-                self.image = f.name
+                image = f.name
         except Exception as e:
-            os.rmdir(self.mountpoint)
+            os.rmdir(mountpoint)
             raise e
 
         if os.path.exists('../../mkfs.btrfs'):
@@ -72,19 +76,24 @@ class BtrfsTestCase(unittest.TestCase):
         else:
             mkfs = 'mkfs.btrfs'
         try:
-            subprocess.check_call([mkfs, '-q', self.image])
-            subprocess.check_call(['mount', '-o', 'loop', '--', self.image, self.mountpoint])
+            subprocess.check_call([mkfs, '-q', image])
+            subprocess.check_call(['mount', '-o', 'loop', '--', image, mountpoint])
         except Exception as e:
-            os.remove(self.image)
-            os.rmdir(self.mountpoint)
+            os.rmdir(mountpoint)
+            os.remove(image)
             raise e
 
+        self._mountpoints.append((mountpoint, image))
+        return mountpoint, image
+
+    def setUp(self):
+        self.mountpoint, self.image = self.mount_btrfs()
+
     def tearDown(self):
-        try:
-            subprocess.check_call(['umount', self.mountpoint])
-        finally:
-            os.remove(self.image)
-            os.rmdir(self.mountpoint)
+        for mountpoint, image in self._mountpoints:
+            subprocess.call(['umount', '-R', mountpoint])
+            os.rmdir(mountpoint)
+            os.remove(image)
 
     @staticmethod
     def path_or_fd(path, open_flags=os.O_RDONLY):
-- 
2.19.1

