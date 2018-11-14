Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B40C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 306CB21780
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="DXLjx1bf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 306CB21780
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731958AbeKNRt0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 12:49:26 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44815 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731740AbeKNRtZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 12:49:25 -0500
Received: by mail-pl1-f193.google.com with SMTP id s5-v6so7361742plq.11
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 23:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HYPLnZDCvaVvSQB145OMPWIPX93p2819tuIQsu7ruDY=;
        b=DXLjx1bf2caN12rxFJ7gosC8jC1+qMqU04n+W1lswPmcnflKnfM8I/T78tkGGUXrXm
         TTCr9wc5R+z3DiB2KN/d0LwC8nCDjtCh1JtaNBnMJqDZnenBtJ5/SJjQC7lrirEJvv8o
         Mh25eJK7AMLPgEQjj0Ijqqbz83fjt3gnQpQdruXUrsng3Xrli4qLiJ+MlP2LyIEwTpGy
         EzdvkuUfNWvQi+VagWmNauXpNw53GrdBE5yS47fsMvFBu3HA8cv5jTTB+OVSrNpYRXkM
         hWPdXKGAHWlF8/eXXwbjUnjvnSqjXsu5nh+6wzigDM6hYQznUcj/f4ecK8wXuZgdhjp/
         V89Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HYPLnZDCvaVvSQB145OMPWIPX93p2819tuIQsu7ruDY=;
        b=hhNMPk7BG5KDMdKjBvu10t0DWpRYZCn1WVrFRs01gPg4nAb22G0zYbi56gGaAes32D
         l7Lj7zCAGXCg0ueLsjAZ9eWfsHrOhUgjQh5K/n4G8b9RHo8tPLhnOWSeV6C45quM16Lk
         cDsbj7759V88wz4IoeDVKBO+2hhXuXpaN4Qm96GpLHNgw7c/+ZAQfOcwIg1/EMosmyKJ
         Ye6w//yjyUGbAyYQIvrIBFDoVlFGPdwR7mivhZ2pl2fgLtkQmhILj0CqXV7fj1pYlAvj
         hhSvi4IpEwzfFReZUxG7MsVcxVlsOIkVzLLHO9NNVrXxY4hrT4wi3m2JFzFL0gB2d5R/
         GT4A==
X-Gm-Message-State: AGRZ1gJKGLIDSJ4dr/fiMt5wfm9r3T0PhGlhaYnVpfc2X5s0SlQTkoPQ
        zJ6fXdCk//oN6qr57JHFZmJX3rhrrsypaQ==
X-Google-Smtp-Source: AJdET5e7xsD4wtW3lrVONrNlKXQkUTHA3787HZYEy9Psdm0zK1CDUa1xFNP+PD04TfJuIyU2SShSWw==
X-Received: by 2002:a17:902:7848:: with SMTP id e8mr909009pln.100.1542181640011;
        Tue, 13 Nov 2018 23:47:20 -0800 (PST)
Received: from vader.psav.com ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id 18-v6sm34835727pfu.129.2018.11.13.23.47.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 23:47:19 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 08/10] libbtrfsutil: relax the privileges of subvolume iterator
Date:   Tue, 13 Nov 2018 23:47:03 -0800
Message-Id: <3d78112bacc2c466cc2dd6dd3b4b9914033cbd43.1542181521.git.osandov@fb.com>
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

We can use the new BTRFS_IOC_GET_SUBVOL_ROOTREF and
BTRFS_IOC_INO_LOOKUP_USER ioctls to allow non-root users to list
subvolumes.

This is based on a patch from Misono Tomohiro but takes a different
approach (mainly, this approach is more similar to the existing tree
search approach).

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/btrfsutil.h                    |  15 +-
 libbtrfsutil/errors.c                       |   6 +
 libbtrfsutil/python/tests/test_subvolume.py | 180 +++++++---
 libbtrfsutil/subvolume.c                    | 354 +++++++++++++++++---
 4 files changed, 450 insertions(+), 105 deletions(-)

diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
index c1925007..d88c39e5 100644
--- a/libbtrfsutil/btrfsutil.h
+++ b/libbtrfsutil/btrfsutil.h
@@ -64,6 +64,9 @@ enum btrfs_util_error {
 	BTRFS_UTIL_ERROR_START_SYNC_FAILED,
 	BTRFS_UTIL_ERROR_WAIT_SYNC_FAILED,
 	BTRFS_UTIL_ERROR_GET_SUBVOL_INFO_FAILED,
+	BTRFS_UTIL_ERROR_GET_SUBVOL_ROOTREF_FAILED,
+	BTRFS_UTIL_ERROR_INO_LOOKUP_USER_FAILED,
+	BTRFS_UTIL_ERROR_FS_INFO_FAILED,
 };
 
 /**
@@ -507,6 +510,12 @@ struct btrfs_util_subvolume_iterator;
  * @flags: Bitmask of BTRFS_UTIL_SUBVOLUME_ITERATOR_* flags.
  * @ret: Returned iterator.
  *
+ * Subvolume iterators require appropriate privilege (CAP_SYS_ADMIN) unless @top
+ * is zero and the kernel supports BTRFS_IOC_GET_SUBVOL_ROOTREF and
+ * BTRFS_IOC_INO_LOOKUP_USER (kernel >= 4.18). In this case, subvolumes which
+ * cannot be accessed (e.g., due to permissions or other mounts) will be
+ * skipped.
+ *
  * The returned iterator must be freed with
  * btrfs_util_destroy_subvolume_iterator().
  *
@@ -555,7 +564,8 @@ int btrfs_util_subvolume_iterator_fd(const struct btrfs_util_subvolume_iterator
  * Must be freed with free().
  * @id_ret: Returned subvolume ID. May be %NULL.
  *
- * This requires appropriate privilege (CAP_SYS_ADMIN).
+ * This requires appropriate privilege (CAP_SYS_ADMIN) for kernels < 4.18. See
+ * btrfs_util_create_subvolume_iterator().
  *
  * Return: %BTRFS_UTIL_OK on success, %BTRFS_UTIL_ERROR_STOP_ITERATION if there
  * are no more subvolumes, non-zero error code on failure.
@@ -574,7 +584,8 @@ enum btrfs_util_error btrfs_util_subvolume_iterator_next(struct btrfs_util_subvo
  * This convenience function basically combines
  * btrfs_util_subvolume_iterator_next() and btrfs_util_subvolume_info().
  *
- * This requires appropriate privilege (CAP_SYS_ADMIN).
+ * This requires appropriate privilege (CAP_SYS_ADMIN) for kernels < 4.18. See
+ * btrfs_util_create_subvolume_iterator().
  *
  * Return: See btrfs_util_subvolume_iterator_next().
  */
diff --git a/libbtrfsutil/errors.c b/libbtrfsutil/errors.c
index cf968b03..d39b38d0 100644
--- a/libbtrfsutil/errors.c
+++ b/libbtrfsutil/errors.c
@@ -47,6 +47,12 @@ static const char * const error_messages[] = {
 	[BTRFS_UTIL_ERROR_WAIT_SYNC_FAILED] = "Could not wait for filesystem sync",
 	[BTRFS_UTIL_ERROR_GET_SUBVOL_INFO_FAILED] =
 		"Could not get subvolume information with BTRFS_IOC_GET_SUBVOL_INFO",
+	[BTRFS_UTIL_ERROR_GET_SUBVOL_ROOTREF_FAILED] =
+		"Could not get rootref information with BTRFS_IOC_GET_SUBVOL_ROOTREF",
+	[BTRFS_UTIL_ERROR_INO_LOOKUP_USER_FAILED] =
+		"Could not resolve subvolume path with BTRFS_IOC_INO_LOOKUP_USER",
+	[BTRFS_UTIL_ERROR_FS_INFO_FAILED] =
+		"Could not get filesystem information",
 };
 
 PUBLIC const char *btrfs_util_strerror(enum btrfs_util_error err)
diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index 55ebf34d..99ec97bc 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -20,6 +20,7 @@ import errno
 import os
 import os.path
 from pathlib import PurePath
+import subprocess
 import traceback
 
 import btrfsutil
@@ -27,6 +28,8 @@ from tests import (
     BtrfsTestCase,
     drop_privs,
     HAVE_PATH_LIKE,
+    NOBODY_UID,
+    regain_privs,
     skipUnlessHaveNobody,
 )
 
@@ -354,69 +357,136 @@ class TestSubvolume(BtrfsTestCase):
             with self.subTest(type=type(arg)):
                 self.assertEqual(btrfsutil.deleted_subvolumes(arg), [256])
 
-    def test_subvolume_iterator(self):
-        pwd = os.getcwd()
-        try:
-            os.chdir(self.mountpoint)
-            btrfsutil.create_subvolume('foo')
-
-            with btrfsutil.SubvolumeIterator('.', info=True) as it:
-                path, subvol = next(it)
-                self.assertEqual(path, 'foo')
-                self.assertIsInstance(subvol, btrfsutil.SubvolumeInfo)
-                self.assertEqual(subvol.id, 256)
-                self.assertEqual(subvol.parent_id, 5)
-                self.assertRaises(StopIteration, next, it)
-
-            btrfsutil.create_subvolume('foo/bar')
-            btrfsutil.create_subvolume('foo/bar/baz')
-
-            subvols = [
-                ('foo', 256),
-                ('foo/bar', 257),
-                ('foo/bar/baz', 258),
-            ]
-
-            for arg in self.path_or_fd('.'):
-                with self.subTest(type=type(arg)), btrfsutil.SubvolumeIterator(arg) as it:
-                    self.assertEqual(list(it), subvols)
-            with btrfsutil.SubvolumeIterator('.', top=0) as it:
+    def _test_subvolume_iterator(self):
+        btrfsutil.create_subvolume('foo')
+
+        with btrfsutil.SubvolumeIterator('.', info=True) as it:
+            path, subvol = next(it)
+            self.assertEqual(path, 'foo')
+            self.assertIsInstance(subvol, btrfsutil.SubvolumeInfo)
+            self.assertEqual(subvol.id, 256)
+            self.assertEqual(subvol.parent_id, 5)
+            self.assertRaises(StopIteration, next, it)
+
+        btrfsutil.create_subvolume('foo/bar')
+        btrfsutil.create_subvolume('foo/bar/baz')
+
+        subvols = [
+            ('foo', 256),
+            ('foo/bar', 257),
+            ('foo/bar/baz', 258),
+        ]
+
+        for arg in self.path_or_fd('.'):
+            with self.subTest(type=type(arg)), btrfsutil.SubvolumeIterator(arg) as it:
                 self.assertEqual(list(it), subvols)
+        with btrfsutil.SubvolumeIterator('.', top=0) as it:
+            self.assertEqual(list(it), subvols)
+        if os.geteuid() == 0:
             with btrfsutil.SubvolumeIterator('foo', top=5) as it:
                 self.assertEqual(list(it), subvols)
 
-            with btrfsutil.SubvolumeIterator('.', post_order=True) as it:
-                self.assertEqual(list(it),
-                                 [('foo/bar/baz', 258),
-                                  ('foo/bar', 257),
-                                  ('foo', 256)])
+        with btrfsutil.SubvolumeIterator('.', post_order=True) as it:
+            self.assertEqual(list(it),
+                             [('foo/bar/baz', 258),
+                              ('foo/bar', 257),
+                              ('foo', 256)])
 
-            subvols = [
-                ('bar', 257),
-                ('bar/baz', 258),
-            ]
+        subvols = [
+            ('bar', 257),
+            ('bar/baz', 258),
+        ]
 
+        if os.geteuid() == 0:
             with btrfsutil.SubvolumeIterator('.', top=256) as it:
                 self.assertEqual(list(it), subvols)
-            with btrfsutil.SubvolumeIterator('foo') as it:
-                self.assertEqual(list(it), subvols)
-            with btrfsutil.SubvolumeIterator('foo', top=0) as it:
-                self.assertEqual(list(it), subvols)
+        with btrfsutil.SubvolumeIterator('foo') as it:
+            self.assertEqual(list(it), subvols)
+        with btrfsutil.SubvolumeIterator('foo', top=0) as it:
+            self.assertEqual(list(it), subvols)
+
+        os.rename('foo/bar/baz', 'baz')
+        os.mkdir('dir')
+        btrfsutil.create_subvolume('dir/qux')
+        os.mkdir('dir/qux/dir2')
+        btrfsutil.create_subvolume('dir/qux/dir2/quux')
+
+        subvols = [
+            ('baz', 258),
+            ('dir/qux', 259),
+            ('dir/qux/dir2/quux', 260),
+            ('foo', 256),
+            ('foo/bar', 257),
+        ]
+
+        # Test various corner cases of the unprivileged implementation
+        # where we can't access the subvolume.
+        if os.geteuid() != 0:
+            with regain_privs():
+                # We don't have permission to traverse the path.
+                os.mkdir('directory_perms', 0o700)
+                btrfsutil.create_subvolume('directory_perms/subvol')
+
+                # We don't have permission to resolve the subvolume path.
+                os.mkdir('subvol_perms', 0o755)
+                btrfsutil.create_subvolume('subvol_perms/subvol')
+                os.chmod('subvol_perms/subvol', 0o700)
+
+                # The path doesn't exist.
+                os.mkdir('enoent', 0o755)
+                btrfsutil.create_subvolume('enoent/subvol')
+                subprocess.check_call(['mount', '-t', 'tmpfs', 'tmpfs', 'enoent'])
+
+                # The path exists but it's not a subvolume.
+                os.mkdir('notsubvol', 0o755)
+                btrfsutil.create_subvolume('notsubvol/subvol')
+                subprocess.check_call(['mount', '-t', 'tmpfs', 'tmpfs', 'notsubvol'])
+                os.mkdir('notsubvol/subvol')
+
+                # The path exists and is a subvolume, but on a different
+                # filesystem.
+                os.mkdir('wrongfs', 0o755)
+                btrfsutil.create_subvolume('wrongfs/subvol')
+                other_mountpoint, _ = self.mount_btrfs()
+                subprocess.check_call(['mount', '--bind', '--',
+                                       other_mountpoint, 'wrongfs/subvol'])
+
+                # The path exists and is a subvolume on the same
+                # filesystem, but not the right one.
+                os.mkdir('wrongsubvol', 0o755)
+                btrfsutil.create_subvolume('wrongsubvol/subvol')
+                subprocess.check_call(['mount', '--bind', 'baz', 'wrongsubvol/subvol'])
+
+
+        with btrfsutil.SubvolumeIterator('.') as it:
+            self.assertEqual(sorted(it), subvols)
+        with btrfsutil.SubvolumeIterator('.', post_order=True) as it:
+            self.assertEqual(sorted(it), subvols)
+
+        with btrfsutil.SubvolumeIterator('.') as it:
+            self.assertGreaterEqual(it.fileno(), 0)
+            it.close()
+            with self.assertRaises(ValueError):
+                next(iter(it))
+            with self.assertRaises(ValueError):
+                it.fileno()
+            it.close()
 
-            os.rename('foo/bar/baz', 'baz')
-            with btrfsutil.SubvolumeIterator('.') as it:
-                self.assertEqual(sorted(it),
-                                 [('baz', 258),
-                                  ('foo', 256),
-                                  ('foo/bar', 257)])
-
-            with btrfsutil.SubvolumeIterator('.') as it:
-                self.assertGreaterEqual(it.fileno(), 0)
-                it.close()
-                with self.assertRaises(ValueError):
-                    next(iter(it))
-                with self.assertRaises(ValueError):
-                    it.fileno()
-                it.close()
+    def test_subvolume_iterator(self):
+        pwd = os.getcwd()
+        try:
+            os.chdir(self.mountpoint)
+            self._test_subvolume_iterator()
+        finally:
+            os.chdir(pwd)
+
+    @skipUnlessHaveNobody
+    def test_subvolume_iterator_unprivileged(self):
+        os.chown(self.mountpoint, NOBODY_UID, -1)
+        pwd = os.getcwd()
+        try:
+            os.chdir(self.mountpoint)
+            with drop_privs():
+                self._test_subvolume_iterator()
         finally:
             os.chdir(pwd)
diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index 69654db4..60ab9f9d 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -749,13 +749,28 @@ PUBLIC enum btrfs_util_error btrfs_util_create_subvolume_fd(int parent_fd,
 #define BTRFS_UTIL_SUBVOLUME_ITERATOR_CLOSE_FD (1 << 30)
 
 struct search_stack_entry {
-	struct btrfs_ioctl_search_args search;
-	size_t items_pos, buf_off;
+	union {
+		/* Used for subvolume_iterator_next_tree_search(). */
+		struct {
+			struct btrfs_ioctl_search_args search;
+			size_t buf_off;
+		};
+		/* Used for subvolume_iterator_next_unprivileged(). */
+		struct {
+			uint64_t id;
+			struct btrfs_ioctl_get_subvol_rootref_args rootref_args;
+		};
+	};
+	/* Used for both. */
+	size_t items_pos;
 	size_t path_len;
 };
 
 struct btrfs_util_subvolume_iterator {
+	bool use_tree_search;
 	int fd;
+	/* cur_fd is only used for subvolume_iterator_next_unprivileged(). */
+	int cur_fd;
 	int flags;
 
 	struct search_stack_entry *search_stack;
@@ -766,6 +781,58 @@ struct btrfs_util_subvolume_iterator {
 	size_t cur_path_capacity;
 };
 
+static struct search_stack_entry *top_search_stack_entry(struct btrfs_util_subvolume_iterator *iter)
+{
+	return &iter->search_stack[iter->search_stack_len - 1];
+}
+
+/*
+ * Check that a path that we opened is the subvolume which we expect. It may not
+ * be if there is another filesystem mounted over a parent directory or the
+ * subvolume itself.
+ */
+static enum btrfs_util_error check_expected_subvolume(int fd, int parent_fd,
+						      uint64_t tree_id)
+{
+	struct btrfs_ioctl_fs_info_args parent_fs_info, fs_info;
+	enum btrfs_util_error err;
+	uint64_t id;
+	int ret;
+
+	/* Make sure it's a subvolume. */
+	err = btrfs_util_is_subvolume_fd(fd);
+	if (err == BTRFS_UTIL_ERROR_NOT_BTRFS ||
+	    err == BTRFS_UTIL_ERROR_NOT_SUBVOLUME) {
+		errno = ENOENT;
+		return BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND;
+	} else if (err) {
+		return err;
+	}
+
+	/* Make sure it's on the same filesystem. */
+	ret = ioctl(parent_fd, BTRFS_IOC_FS_INFO, &parent_fs_info);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_FS_INFO_FAILED;
+	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &fs_info);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_FS_INFO_FAILED;
+	if (memcmp(parent_fs_info.fsid, fs_info.fsid, sizeof(fs_info.fsid)) != 0) {
+		errno = ENOENT;
+		return BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND;
+	}
+
+	/* Make sure it's the subvolume that we expected. */
+	err = btrfs_util_subvolume_id_fd(fd, &id);
+	if (err)
+		return err;
+	if (id != tree_id) {
+		errno = ENOENT;
+		return BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND;
+	}
+
+	return BTRFS_UTIL_OK;
+}
+
 static enum btrfs_util_error append_to_search_stack(struct btrfs_util_subvolume_iterator *iter,
 						    uint64_t tree_id,
 						    size_t path_len)
@@ -786,24 +853,84 @@ static enum btrfs_util_error append_to_search_stack(struct btrfs_util_subvolume_
 		iter->search_stack = new_search_stack;
 	}
 
-	entry = &iter->search_stack[iter->search_stack_len++];
+	entry = &iter->search_stack[iter->search_stack_len];
 
-	memset(&entry->search, 0, sizeof(entry->search));
-	entry->search.key.tree_id = BTRFS_ROOT_TREE_OBJECTID;
-	entry->search.key.min_objectid = tree_id;
-	entry->search.key.max_objectid = tree_id;
-	entry->search.key.min_type = BTRFS_ROOT_REF_KEY;
-	entry->search.key.max_type = BTRFS_ROOT_REF_KEY;
-	entry->search.key.min_offset = 0;
-	entry->search.key.max_offset = UINT64_MAX;
-	entry->search.key.min_transid = 0;
-	entry->search.key.max_transid = UINT64_MAX;
-	entry->search.key.nr_items = 0;
+	memset(entry, 0, sizeof(*entry));
+	entry->path_len = path_len;
+	if (iter->use_tree_search) {
+		entry->search.key.tree_id = BTRFS_ROOT_TREE_OBJECTID;
+		entry->search.key.min_objectid = tree_id;
+		entry->search.key.max_objectid = tree_id;
+		entry->search.key.min_type = BTRFS_ROOT_REF_KEY;
+		entry->search.key.max_type = BTRFS_ROOT_REF_KEY;
+		entry->search.key.min_offset = 0;
+		entry->search.key.max_offset = UINT64_MAX;
+		entry->search.key.min_transid = 0;
+		entry->search.key.max_transid = UINT64_MAX;
+		entry->search.key.nr_items = 0;
+	} else {
+		entry->id = tree_id;
 
-	entry->items_pos = 0;
-	entry->buf_off = 0;
+		if (iter->search_stack_len) {
+			struct search_stack_entry *top;
+			enum btrfs_util_error err;
+			char *path;
+			int fd;
 
-	entry->path_len = path_len;
+			top = top_search_stack_entry(iter);
+			path = &iter->cur_path[top->path_len];
+			if (*path == '/')
+				path++;
+			fd = openat(iter->cur_fd, path, O_RDONLY);
+			if (fd == -1)
+				return BTRFS_UTIL_ERROR_OPEN_FAILED;
+
+			err = check_expected_subvolume(fd, iter->cur_fd,
+						       tree_id);
+			if (err) {
+				close(fd);
+				return err;
+			}
+
+			close(iter->cur_fd);
+			iter->cur_fd = fd;
+		}
+	}
+
+	iter->search_stack_len++;
+
+	return BTRFS_UTIL_OK;
+}
+
+static enum btrfs_util_error pop_search_stack(struct btrfs_util_subvolume_iterator *iter)
+{
+	struct search_stack_entry *top, *parent;
+	int fd, parent_fd;
+	size_t i;
+
+	if (iter->use_tree_search || iter->search_stack_len == 1) {
+		iter->search_stack_len--;
+		return BTRFS_UTIL_OK;
+	}
+
+	top = top_search_stack_entry(iter);
+	iter->search_stack_len--;
+	parent = top_search_stack_entry(iter);
+
+	fd = iter->cur_fd;
+	for (i = parent->path_len; i < top->path_len; i++) {
+		if (i == 0 || iter->cur_path[i] == '/') {
+			parent_fd = openat(fd, "..", O_RDONLY);
+			if (fd != iter->cur_fd)
+				SAVE_ERRNO_AND_CLOSE(fd);
+			if (parent_fd == -1)
+				return BTRFS_UTIL_ERROR_OPEN_FAILED;
+			fd = parent_fd;
+		}
+	}
+	if (iter->cur_fd != iter->fd)
+		close(iter->cur_fd);
+	iter->cur_fd = fd;
 
 	return BTRFS_UTIL_OK;
 }
@@ -836,12 +963,14 @@ PUBLIC enum btrfs_util_error btrfs_util_create_subvolume_iterator_fd(int fd,
 {
 	struct btrfs_util_subvolume_iterator *iter;
 	enum btrfs_util_error err;
+	bool use_tree_search;
 
 	if (flags & ~BTRFS_UTIL_SUBVOLUME_ITERATOR_MASK) {
 		errno = EINVAL;
 		return BTRFS_UTIL_ERROR_INVALID_ARGUMENT;
 	}
 
+	use_tree_search = top != 0 || is_root();
 	if (top == 0) {
 		err = btrfs_util_is_subvolume_fd(fd);
 		if (err)
@@ -857,7 +986,9 @@ PUBLIC enum btrfs_util_error btrfs_util_create_subvolume_iterator_fd(int fd,
 		return BTRFS_UTIL_ERROR_NO_MEMORY;
 
 	iter->fd = fd;
+	iter->cur_fd = fd;
 	iter->flags = flags;
+	iter->use_tree_search = use_tree_search;
 
 	iter->search_stack_len = 0;
 	iter->search_stack_capacity = 4;
@@ -1166,6 +1297,8 @@ PUBLIC void btrfs_util_destroy_subvolume_iterator(struct btrfs_util_subvolume_it
 	if (iter) {
 		free(iter->cur_path);
 		free(iter->search_stack);
+		if (iter->cur_fd != iter->fd)
+			SAVE_ERRNO_AND_CLOSE(iter->cur_fd);
 		if (iter->flags & BTRFS_UTIL_SUBVOLUME_ITERATOR_CLOSE_FD)
 			SAVE_ERRNO_AND_CLOSE(iter->fd);
 		free(iter);
@@ -1177,32 +1310,14 @@ PUBLIC int btrfs_util_subvolume_iterator_fd(const struct btrfs_util_subvolume_it
 	return iter->fd;
 }
 
-static struct search_stack_entry *top_search_stack_entry(struct btrfs_util_subvolume_iterator *iter)
-{
-	return &iter->search_stack[iter->search_stack_len - 1];
-}
-
 static enum btrfs_util_error build_subvol_path(struct btrfs_util_subvolume_iterator *iter,
-					       const struct btrfs_ioctl_search_header *header,
-					       const struct btrfs_root_ref *ref,
-					       const char *name,
+					       const char *name, size_t name_len,
+					       const char *dir, size_t dir_len,
 					       size_t *path_len_ret)
 {
-	struct btrfs_ioctl_ino_lookup_args lookup = {
-		.treeid = header->objectid,
-		.objectid = le64_to_cpu(ref->dirid),
-	};
 	struct search_stack_entry *top = top_search_stack_entry(iter);
-	size_t dir_len, name_len, path_len;
+	size_t path_len;
 	char *p;
-	int ret;
-
-	ret = ioctl(iter->fd, BTRFS_IOC_INO_LOOKUP, &lookup);
-	if (ret == -1)
-		return BTRFS_UTIL_ERROR_INO_LOOKUP_FAILED;
-
-	dir_len = strlen(lookup.name);
-	name_len = le16_to_cpu(ref->name_len);
 
 	path_len = top->path_len;
 	/*
@@ -1220,33 +1335,75 @@ static enum btrfs_util_error build_subvol_path(struct btrfs_util_subvolume_itera
 		path_len++;
 	path_len += name_len;
 
-	if (path_len > iter->cur_path_capacity) {
-		char *tmp = realloc(iter->cur_path, path_len);
+	/* We need one extra character for the NUL terminator. */
+	if (path_len + 1 > iter->cur_path_capacity) {
+		char *tmp = realloc(iter->cur_path, path_len + 1);
 
 		if (!tmp)
 			return BTRFS_UTIL_ERROR_NO_MEMORY;
 		iter->cur_path = tmp;
-		iter->cur_path_capacity = path_len;
+		iter->cur_path_capacity = path_len + 1;
 	}
 
 	p = iter->cur_path + top->path_len;
 	if (top->path_len && dir_len)
 		*p++ = '/';
-	memcpy(p, lookup.name, dir_len);
+	memcpy(p, dir, dir_len);
 	p += dir_len;
 	if (top->path_len && !dir_len && name_len)
 		*p++ = '/';
 	memcpy(p, name, name_len);
 	p += name_len;
+	*p = '\0';
 
 	*path_len_ret = path_len;
 
 	return BTRFS_UTIL_OK;
 }
 
-PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next(struct btrfs_util_subvolume_iterator *iter,
-								char **path_ret,
-								uint64_t *id_ret)
+static enum btrfs_util_error build_subvol_path_privileged(struct btrfs_util_subvolume_iterator *iter,
+							  const struct btrfs_ioctl_search_header *header,
+							  const struct btrfs_root_ref *ref,
+							  const char *name,
+							  size_t *path_len_ret)
+{
+	struct btrfs_ioctl_ino_lookup_args lookup = {
+		.treeid = header->objectid,
+		.objectid = le64_to_cpu(ref->dirid),
+	};
+	int ret;
+
+	ret = ioctl(iter->fd, BTRFS_IOC_INO_LOOKUP, &lookup);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_INO_LOOKUP_FAILED;
+
+	return build_subvol_path(iter, name, le16_to_cpu(ref->name_len),
+				 lookup.name, strlen(lookup.name),
+				 path_len_ret);
+}
+
+static enum btrfs_util_error build_subvol_path_unprivileged(struct btrfs_util_subvolume_iterator *iter,
+							    uint64_t treeid,
+							    uint64_t dirid,
+							    size_t *path_len_ret)
+{
+	struct btrfs_ioctl_ino_lookup_user_args args = {
+		.treeid = treeid,
+		.dirid = dirid,
+	};
+	int ret;
+
+	ret = ioctl(iter->cur_fd, BTRFS_IOC_INO_LOOKUP_USER, &args);
+	if (ret == -1)
+		return BTRFS_UTIL_ERROR_INO_LOOKUP_USER_FAILED;
+
+	return build_subvol_path(iter, args.name, strlen(args.name),
+				 args.path, strlen(args.path), path_len_ret);
+}
+
+static enum btrfs_util_error subvolume_iterator_next_tree_search(struct btrfs_util_subvolume_iterator *iter,
+								 char **path_ret,
+								 uint64_t *id_ret)
 {
 	struct search_stack_entry *top;
 	const struct btrfs_ioctl_search_header *header;
@@ -1273,7 +1430,10 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next(struct btrfs_uti
 				top->buf_off = 0;
 
 				if (top->search.key.nr_items == 0) {
-					iter->search_stack_len--;
+					/*
+					 * This never fails for use_tree_search.
+					 */
+					pop_search_stack(iter);
 					if ((iter->flags & BTRFS_UTIL_SUBVOLUME_ITERATOR_POST_ORDER) &&
 					    iter->search_stack_len)
 						goto out;
@@ -1293,7 +1453,8 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next(struct btrfs_uti
 
 		ref = (struct btrfs_root_ref *)(header + 1);
 		name = (const char *)(ref + 1);
-		err = build_subvol_path(iter, header, ref, name, &path_len);
+		err = build_subvol_path_privileged(iter, header, ref, name,
+						   &path_len);
 		if (err)
 			return err;
 
@@ -1320,6 +1481,100 @@ out:
 	return BTRFS_UTIL_OK;
 }
 
+static enum btrfs_util_error subvolume_iterator_next_unprivileged(struct btrfs_util_subvolume_iterator *iter,
+								  char **path_ret,
+								  uint64_t *id_ret)
+{
+	struct search_stack_entry *top;
+	uint64_t treeid, dirid;
+	enum btrfs_util_error err;
+	size_t path_len;
+	int ret;
+
+	for (;;) {
+		for (;;) {
+			if (iter->search_stack_len == 0)
+				return BTRFS_UTIL_ERROR_STOP_ITERATION;
+
+			top = top_search_stack_entry(iter);
+			if (top->items_pos < top->rootref_args.num_items) {
+				break;
+			} else {
+				ret = ioctl(iter->cur_fd,
+					    BTRFS_IOC_GET_SUBVOL_ROOTREF,
+					    &top->rootref_args);
+				if (ret == -1 && errno != EOVERFLOW)
+					return BTRFS_UTIL_ERROR_GET_SUBVOL_ROOTREF_FAILED;
+				top->items_pos = 0;
+
+				if (top->rootref_args.num_items == 0) {
+					err = pop_search_stack(iter);
+					if (err)
+						return err;
+					if ((iter->flags & BTRFS_UTIL_SUBVOLUME_ITERATOR_POST_ORDER) &&
+					    iter->search_stack_len)
+						goto out;
+				}
+			}
+		}
+
+		treeid = top->rootref_args.rootref[top->items_pos].treeid;
+		dirid = top->rootref_args.rootref[top->items_pos].dirid;
+		top->items_pos++;
+		err = build_subvol_path_unprivileged(iter, treeid, dirid,
+						     &path_len);
+		if (err) {
+			/* Skip the subvolume if we can't access it. */
+			if (errno == EACCES)
+				continue;
+			return err;
+		}
+
+		err = append_to_search_stack(iter, treeid, path_len);
+		if (err) {
+			/*
+			 * Skip the subvolume if it does not exist (which can
+			 * happen if there is another filesystem mounted over a
+			 * parent directory) or we don't have permission to
+			 * access it.
+			 */
+			if (errno == ENOENT || errno == EACCES)
+				continue;
+			return err;
+		}
+
+		if (!(iter->flags & BTRFS_UTIL_SUBVOLUME_ITERATOR_POST_ORDER)) {
+			top = top_search_stack_entry(iter);
+			goto out;
+		}
+	}
+
+out:
+	if (path_ret) {
+		*path_ret = malloc(top->path_len + 1);
+		if (!*path_ret)
+			return BTRFS_UTIL_ERROR_NO_MEMORY;
+		memcpy(*path_ret, iter->cur_path, top->path_len);
+		(*path_ret)[top->path_len] = '\0';
+	}
+	if (id_ret)
+		*id_ret = top->id;
+	return BTRFS_UTIL_OK;
+}
+
+PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next(struct btrfs_util_subvolume_iterator *iter,
+								char **path_ret,
+								uint64_t *id_ret)
+{
+	if (iter->use_tree_search) {
+		return subvolume_iterator_next_tree_search(iter, path_ret,
+							   id_ret);
+	} else {
+		return subvolume_iterator_next_unprivileged(iter, path_ret,
+							    id_ret);
+	}
+}
+
 PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next_info(struct btrfs_util_subvolume_iterator *iter,
 								     char **path_ret,
 								     struct btrfs_util_subvolume_info *subvol)
@@ -1331,7 +1586,10 @@ PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next_info(struct btrf
 	if (err)
 		return err;
 
-	return btrfs_util_subvolume_info_fd(iter->fd, id, subvol);
+	if (iter->use_tree_search)
+		return btrfs_util_subvolume_info_fd(iter->fd, id, subvol);
+	else
+		return btrfs_util_subvolume_info_fd(iter->cur_fd, 0, subvol);
 }
 
 PUBLIC enum btrfs_util_error btrfs_util_deleted_subvolumes(const char *path,
-- 
2.19.1

