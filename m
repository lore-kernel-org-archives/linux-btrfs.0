Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE2CC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 447C221780
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="ODQLt8sV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 447C221780
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731738AbeKNRtX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 12:49:23 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41835 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731593AbeKNRtX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 12:49:23 -0500
Received: by mail-pf1-f194.google.com with SMTP id e22-v6so7473402pfn.8
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 23:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z3KEbsNXMDJXke++pFrtNJZ/jKBUqXD0BWpyFfXPrzk=;
        b=ODQLt8sVr047fz0ueJPV6QWJpb/v6QSAFgCHuPhkWrGsjFNjUT9bZOCcUognTeos8x
         e46DF2O8NaOecrOgyUruW7URfBv2pGMSx3C6ZrKZhw5IPAgcZLqaOPK3gwMwGmYPbPcy
         x0h3r+eXBoTD4DzvognFEkBI7X03Mcam0brmDWUhZrBVztB8KzYj0reBaUjw3Xd+RJW5
         rNDdEK9I2GsbYVXpX4BOw0IJgluW4YY4r2h81558E8DflUc0vvbpi5h90u+LxAZQRU5M
         ohgkxIXvm7Z4Jk+rIeiH0j8sbkgThYBC/4jry4ALqkKJ2Wca0JdDHWKliQYim52plKWD
         a/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z3KEbsNXMDJXke++pFrtNJZ/jKBUqXD0BWpyFfXPrzk=;
        b=qMuggg8A/eCKmYa9QaO0VvzTCwiTVMcCdGQRH0LqIP+D0pOgHZ48AsbLJZTqYFvaY5
         46Ax7qbBCW61QHxhZh7U1v6EBD5eK3IyL7AsXcdpsk15qPfWsfUVRQIbHEJVIPFpINQ6
         72uNDyQ2I3Bd/Wl9LfGPIvTUxVRMOuP/NVyMreWaGoL2ZSdClE7pc+6rmvNwctTZ/+HG
         ev4wIXPvM0Vg+MDlzRrwFAH4TM91ONzi++4Po/kdV98jaHlp8CY7z2chF5b0T9gYfJCW
         nvWuOicpnzCc8q8pENQp8q5OsndpKWaEpQFs3iERBks6FU+MjuXmPL90VcVtxpEVVsUq
         NBIA==
X-Gm-Message-State: AGRZ1gJgxg+yLqv9NGe5/D82+3uFXBA6krIu1oK66VrkrE8NC9C0T3nc
        W5HqNQE+M0Omwm/nTswDRQteoK2ADyl0Mg==
X-Google-Smtp-Source: AJdET5cC3ey/BRoZBnON10U9xBdcH+ARCqGM2rSLKQAvT4h0zOLjZr62YGL9EvwT3VlaJWPaAZeVoQ==
X-Received: by 2002:a63:5722:: with SMTP id l34mr801689pgb.118.1542181637456;
        Tue, 13 Nov 2018 23:47:17 -0800 (PST)
Received: from vader.psav.com ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id 18-v6sm34835727pfu.129.2018.11.13.23.47.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 23:47:16 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 05/10] libbtrfsutil: add test helpers for dropping privileges
Date:   Tue, 13 Nov 2018 23:47:00 -0800
Message-Id: <c3f53eb2e4cc9bae5abacf0f54ce68b6be3f0f7b.1542181521.git.osandov@fb.com>
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

These will be used for testing some upcoming changes which allow
unprivileged operations.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/python/tests/__init__.py | 31 ++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/libbtrfsutil/python/tests/__init__.py b/libbtrfsutil/python/tests/__init__.py
index 35550e0a..4bc11990 100644
--- a/libbtrfsutil/python/tests/__init__.py
+++ b/libbtrfsutil/python/tests/__init__.py
@@ -15,14 +15,44 @@
 # You should have received a copy of the GNU Lesser General Public License
 # along with libbtrfsutil.  If not, see <http://www.gnu.org/licenses/>.
 
+import contextlib
 import os
 from pathlib import PurePath
+import pwd
 import subprocess
 import tempfile
 import unittest
 
 
 HAVE_PATH_LIKE = hasattr(PurePath, '__fspath__')
+try:
+    NOBODY_UID = pwd.getpwnam('nobody').pw_uid
+    skipUnlessHaveNobody = lambda func: func
+except KeyError:
+    NOBODY_UID = None
+    skipUnlessHaveNobody = unittest.skip('must have nobody user')
+
+
+@contextlib.contextmanager
+def drop_privs():
+    try:
+        os.seteuid(NOBODY_UID)
+        yield
+    finally:
+        os.seteuid(0)
+
+
+@contextlib.contextmanager
+def regain_privs():
+    uid = os.geteuid()
+    if uid:
+        try:
+            os.seteuid(0)
+            yield
+        finally:
+            os.seteuid(uid)
+    else:
+        yield
 
 
 @unittest.skipIf(os.geteuid() != 0, 'must be run as root')
@@ -67,4 +97,3 @@ class BtrfsTestCase(unittest.TestCase):
             yield fd
         finally:
             os.close(fd)
-
-- 
2.19.1

