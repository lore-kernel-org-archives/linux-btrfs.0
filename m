Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA2EC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA85821780
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="P0sLY/BY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA85821780
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731825AbeKNRtZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 12:49:25 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36859 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731593AbeKNRtY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 12:49:24 -0500
Received: by mail-pl1-f195.google.com with SMTP id w24-v6so7387750plq.3
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 23:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=krj07n1JV41ibN1KZEpU+Ux0fw41vf3pKm1+kXnPgNM=;
        b=P0sLY/BY7KpKaAriq8m+qRGalqXd/Sm8kRT2Pl31GD8faDHS8kYemSR41/SFPbPHTS
         qHTg1UeTw0P8+TKIIzkhsOtih0iyZBiUsNWH8Ry2qwIs99hbBNz85OMa02KiF8Sv44e7
         fd+hVi5Bvz8KwvxCZE5sD8W22gjsMSqKyGRYkHwhTj93lzVYMR4pn4l3PtomXii/eUXY
         Ii9t6eQn/XbnWIkccoj0FtHL4DjSLaIb0B7nbez6MJ80krpQQY9E1c41EDQIhCRzGMEC
         w4YNz8w6RDWm3V/y8U85nyst9IPKfwBRQSt8uaXzE7/M30WW867FE8rr8ClQMEQAyL+e
         HDHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=krj07n1JV41ibN1KZEpU+Ux0fw41vf3pKm1+kXnPgNM=;
        b=kvAmgOhv59rmy0VFcrzLlb0HNlsST5XAFndQ3CcRRMyq8qaIEvfTlETltq7e7wpmQ3
         VjEyREN+ul60geDF6QO5++2lBrF8rjWzPKnqeFYI/B+jCMlIFZL1js9QKSDPBDM+SRy5
         WmISK/ghpnVhZ7cT1LkCJjU2zB2hG4tFD5JcPC390UAz0fXykK5mnmbHN5RLzLFkaiGA
         q302MI8NQ5YwWJ9qlKPDzzip8VnuD/rwtu4hsJ86dxmgikrLG7lGwZ7QSeF27/XHO0cH
         hWVd5CKMLNYA//kkzjsZD2e+wNq74e9A5ZUuLb005WLGrzGZiHYkBCA1Xdiiy6iTVFyP
         An4g==
X-Gm-Message-State: AGRZ1gIYgd5iw8ioBmWMhKxoGWLwiRENsm1wuW2wdxO6Po7a9qiPmQyF
        8mZFc1F11AyNhvH+uRLbOesWlh1rnXj6PA==
X-Google-Smtp-Source: AJdET5fOZoBYD+kA9NKY9oYjOZWJ0oXrZCgpnS66r9rJ5ZonTOUJkXo9HxNxaW1skpkVWTMMf5Mrbw==
X-Received: by 2002:a17:902:1124:: with SMTP id d33-v6mr884658pla.125.1542181639177;
        Tue, 13 Nov 2018 23:47:19 -0800 (PST)
Received: from vader.psav.com ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id 18-v6sm34835727pfu.129.2018.11.13.23.47.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 23:47:18 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 07/10] libbtrfsutil: relax the privileges of subvolume_info()
Date:   Tue, 13 Nov 2018 23:47:02 -0800
Message-Id: <4412561bf224e10c32bd9851f9281f291f7d3879.1542181521.git.osandov@fb.com>
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

Attempt to use the BTRFS_IOC_GET_SUBVOL_INFO ioctl (added in kernel
4.18) for subvolume_info() if not root. Also, rename
get_subvolume_info_root() -> get_subvolume_info_privileged() for
consistency with further changes.

This is based on a patch from Misono Tomohiro.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/btrfsutil.h                    |  4 +-
 libbtrfsutil/errors.c                       |  2 +
 libbtrfsutil/python/tests/test_subvolume.py | 42 ++++++++++++----
 libbtrfsutil/subvolume.c                    | 53 +++++++++++++++++++--
 4 files changed, 89 insertions(+), 12 deletions(-)

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index 6d655f49..c1925007 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -63,6 +63,7 @@ enum btrfs_util_error {
 	BTRFS_UTIL_ERROR_SYNC_FAILED,
 	BTRFS_UTIL_ERROR_START_SYNC_FAILED,
 	BTRFS_UTIL_ERROR_WAIT_SYNC_FAILED,
+	BTRFS_UTIL_ERROR_GET_SUBVOL_INFO_FAILED,
 };
 
 /**
@@ -266,7 +267,8 @@ struct btrfs_util_subvolume_info {
  * to check whether the subvolume exists; %BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND
  * will be returned if it does not.
  *
- * This requires appropriate privilege (CAP_SYS_ADMIN).
+ * This requires appropriate privilege (CAP_SYS_ADMIN) unless @id is zero and
+ * the kernel supports BTRFS_IOC_GET_SUBVOL_INFO (kernel >= 4.18).
  *
  * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
  */
diff --git a/libbtrfsutil/errors.c b/libbtrfsutil/errors.c
index 634edc65..cf968b03 100644
--- a/libbtrfsutil/errors.c
+++ b/libbtrfsutil/errors.c
@@ -45,6 +45,8 @@ static const char * const error_messages[] = {
 	[BTRFS_UTIL_ERROR_SYNC_FAILED] = "Could not sync filesystem",
 	[BTRFS_UTIL_ERROR_START_SYNC_FAILED] = "Could not start filesystem sync",
 	[BTRFS_UTIL_ERROR_WAIT_SYNC_FAILED] = "Could not wait for filesystem sync",
+	[BTRFS_UTIL_ERROR_GET_SUBVOL_INFO_FAILED] =
+		"Could not get subvolume information with BTRFS_IOC_GET_SUBVOL_INFO",
 };
 
 PUBLIC const char *btrfs_util_strerror(enum btrfs_util_error err)
diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index 4049b08e..55ebf34d 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -23,7 +23,12 @@ from pathlib import PurePath
 import traceback
 
 import btrfsutil
-from tests import BtrfsTestCase, HAVE_PATH_LIKE
+from tests import (
+    BtrfsTestCase,
+    drop_privs,
+    HAVE_PATH_LIKE,
+    skipUnlessHaveNobody,
+)
 
 
 class TestSubvolume(BtrfsTestCase):
@@ -87,7 +92,7 @@ class TestSubvolume(BtrfsTestCase):
         finally:
             os.chdir(pwd)
 
-    def test_subvolume_info(self):
+    def _test_subvolume_info(self, subvol, snapshot):
         for arg in self.path_or_fd(self.mountpoint):
             with self.subTest(type=type(arg)):
                 info = btrfsutil.subvolume_info(arg)
@@ -100,7 +105,7 @@ class TestSubvolume(BtrfsTestCase):
                 self.assertEqual(info.parent_uuid, bytes(16))
                 self.assertEqual(info.received_uuid, bytes(16))
                 self.assertNotEqual(info.generation, 0)
-                self.assertEqual(info.ctransid, 0)
+                self.assertGreaterEqual(info.ctransid, 0)
                 self.assertEqual(info.otransid, 0)
                 self.assertEqual(info.stransid, 0)
                 self.assertEqual(info.rtransid, 0)
@@ -109,9 +114,6 @@ class TestSubvolume(BtrfsTestCase):
                 self.assertEqual(info.stime, 0)
                 self.assertEqual(info.rtime, 0)
 
-        subvol = os.path.join(self.mountpoint, 'subvol')
-        btrfsutil.create_subvolume(subvol)
-
         info = btrfsutil.subvolume_info(subvol)
         self.assertEqual(info.id, 256)
         self.assertEqual(info.parent_id, 5)
@@ -132,19 +134,43 @@ class TestSubvolume(BtrfsTestCase):
         self.assertEqual(info.rtime, 0)
 
         subvol_uuid = info.uuid
-        snapshot = os.path.join(self.mountpoint, 'snapshot')
-        btrfsutil.create_snapshot(subvol, snapshot)
 
         info = btrfsutil.subvolume_info(snapshot)
         self.assertEqual(info.parent_uuid, subvol_uuid)
 
         # TODO: test received_uuid, stransid, rtransid, stime, and rtime
 
+    def test_subvolume_info(self):
+        subvol = os.path.join(self.mountpoint, 'subvol')
+        btrfsutil.create_subvolume(subvol)
+        snapshot = os.path.join(self.mountpoint, 'snapshot')
+        btrfsutil.create_snapshot(subvol, snapshot)
+
+        self._test_subvolume_info(subvol, snapshot)
+
         for arg in self.path_or_fd(self.mountpoint):
             with self.subTest(type=type(arg)):
                 with self.assertRaises(btrfsutil.BtrfsUtilError) as e:
                     # BTRFS_EXTENT_TREE_OBJECTID
                     btrfsutil.subvolume_info(arg, 2)
+                self.assertEqual(e.exception.btrfsutilerror,
+                                 btrfsutil.ERROR_SUBVOLUME_NOT_FOUND)
+
+    @skipUnlessHaveNobody
+    def test_subvolume_info_unprivileged(self):
+        subvol = os.path.join(self.mountpoint, 'subvol')
+        btrfsutil.create_subvolume(subvol)
+        snapshot = os.path.join(self.mountpoint, 'snapshot')
+        btrfsutil.create_snapshot(subvol, snapshot)
+
+        with drop_privs():
+            try:
+                self._test_subvolume_info(subvol, snapshot)
+            except OSError as e:
+                if e.errno == errno.ENOTTY:
+                    self.skipTest('BTRFS_IOC_GET_SUBVOL_INFO is not available')
+                else:
+                    raise
 
     def test_read_only(self):
         for arg in self.path_or_fd(self.mountpoint):
diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index 0d7ef5bf..69654db4 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -31,6 +31,11 @@
 
 #include "btrfsutil_internal.h"
 
+static bool is_root(void)
+{
+	return geteuid() == 0;
+}
+
 /*
  * This intentionally duplicates btrfs_util_is_subvolume_fd() instead of opening
  * a file descriptor and calling it, because fstat() and fstatfs() don't accept
@@ -295,8 +300,8 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_info(const char *path,
 	return err;
 }
 
-static enum btrfs_util_error get_subvolume_info_root(int fd, uint64_t id,
-						     struct btrfs_util_subvolume_info *subvol)
+static enum btrfs_util_error get_subvolume_info_privileged(int fd, uint64_t id,
+							   struct btrfs_util_subvolume_info *subvol)
 {
 	struct btrfs_ioctl_search_args search = {
 		.key = {
@@ -383,6 +388,45 @@ static enum btrfs_util_error get_subvolume_info_root(int fd, uint64_t id,
 	return BTRFS_UTIL_OK;
 }
 
+static enum btrfs_util_error get_subvolume_info_unprivileged(int fd,
+							     struct btrfs_util_subvolume_info *subvol)
+{
+	struct btrfs_ioctl_get_subvol_info_args info;
+	int ret;
+
+	ret = ioctl(fd, BTRFS_IOC_GET_SUBVOL_INFO, &info);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_GET_SUBVOL_INFO_FAILED;
+
+	subvol->id = info.treeid;
+	subvol->parent_id = info.parent_id;
+	subvol->dir_id = info.dirid;
+	subvol->flags = info.flags;
+	subvol->generation = info.generation;
+
+	memcpy(subvol->uuid, info.uuid, sizeof(subvol->uuid));
+	memcpy(subvol->parent_uuid, info.parent_uuid,
+	       sizeof(subvol->parent_uuid));
+	memcpy(subvol->received_uuid, info.received_uuid,
+	       sizeof(subvol->received_uuid));
+
+	subvol->ctransid = info.ctransid;
+	subvol->otransid = info.otransid;
+	subvol->stransid = info.stransid;
+	subvol->rtransid = info.rtransid;
+
+	subvol->ctime.tv_sec = info.ctime.sec;
+	subvol->ctime.tv_nsec = info.ctime.nsec;
+	subvol->otime.tv_sec = info.otime.sec;
+	subvol->otime.tv_nsec = info.otime.nsec;
+	subvol->stime.tv_sec = info.stime.sec;
+	subvol->stime.tv_nsec = info.stime.nsec;
+	subvol->rtime.tv_sec = info.rtime.sec;
+	subvol->rtime.tv_nsec = info.rtime.nsec;
+
+	return BTRFS_UTIL_OK;
+}
+
 PUBLIC enum btrfs_util_error btrfs_util_subvolume_info_fd(int fd, uint64_t id,
 							  struct btrfs_util_subvolume_info *subvol)
 {
@@ -393,6 +437,9 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_info_fd(int fd, uint64_t id,
 		if (err)
 			return err;
 
+		if (!is_root())
+			return get_subvolume_info_unprivileged(fd, subvol);
+
 		err = btrfs_util_subvolume_id_fd(fd, &id);
 		if (err)
 			return err;
@@ -404,7 +451,7 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_info_fd(int fd, uint64_t id,
 		return BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND;
 	}
 
-	return get_subvolume_info_root(fd, id, subvol);
+	return get_subvolume_info_privileged(fd, id, subvol);
 }
 
 PUBLIC enum btrfs_util_error btrfs_util_get_subvolume_read_only_fd(int fd,
-- 
2.19.1

