Return-Path: <SRS0=lg0L=OQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2672AC04EB8
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 00:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5A642083D
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 00:29:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="QP2domEl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5A642083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbeLGA3n (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 19:29:43 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46778 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbeLGA3n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Dec 2018 19:29:43 -0500
Received: by mail-pf1-f196.google.com with SMTP id c73so988608pfe.13
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Dec 2018 16:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3159S+wR8//SPddIEvTuKtwW2RHscGZ8jla7fTuELNw=;
        b=QP2domElX++o02S3KAVxOUEvfJJXa2cSnOJSpIl1adsCc1UHPbgI2JfP6Jlm/6L2EL
         Yj3wJzbbmQ5UytY1IJ1OyYI4fWdAmoYJ5W4EBufDkJLhrKw6pY13GIG1xeeqcHNqFmH+
         pBG1InXO1608EDG7ti2/itxLyQQci8xmpYwwDF6gMGQ4+7IG5PRUYbWwO6IckDVh3myl
         cgyhnxIjfrzGi1u0S1bMaVN6xKzW8SCtWrStwx10ZmGmL7L/fI+r54YcxFLVpR4darHo
         07X3yq3peOZqrGpUFcdQ++KwffIcsopHsDoWvhy957a25cK0vKobya5zS1aGxrdeGYG3
         YmOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3159S+wR8//SPddIEvTuKtwW2RHscGZ8jla7fTuELNw=;
        b=Hcu271DT5r3pFzZH8srG29WYEh2w957rIOGvMgk1ei9cWVSFUW8yOspmA60JRc7n0V
         TnXPaVV1ljsmJLjlrdszkcdaoDqjcByMfoEGP3tAbM1cpmy5Fn5EyBLjvqiPywDLeZZJ
         zqZWyThnFYnF4Fv6Ui+en4/5vD3Wl2sw3zn36UVIZ27Aeeazu/HOUFzmCqvX9FNMU48k
         dYTC/iv1CShGaXVxa54mMuuvRNR8ble39DQ2q9rELUl6UYxJHmfsx9tOxL/d/1VddMDK
         lflFFFgI95YLGSzqVurOMxiMX78ou5hHQwbprK/jndKC0baXqFeII39u5elrtce054Rg
         A4RA==
X-Gm-Message-State: AA+aEWYvB7pxqqlqfvV7ld1IoMA99nAe6ttO49EJOdQoq/NGP7st+OGq
        XqcHZjJ1gIZ6rpScOOGJ72svS4DI2Iw=
X-Google-Smtp-Source: AFSGD/VjEV0KVu5mVxm1INx/F4AbLpFez21hWT0MFJ3/aHyKG1EPQK8qbmafZdrA6NOC9GPRdLHN0w==
X-Received: by 2002:a62:6143:: with SMTP id v64mr102678pfb.142.1544142581753;
        Thu, 06 Dec 2018 16:29:41 -0800 (PST)
Received: from vader.thefacebook.com ([2620:10d:c090:200::5:7ead])
        by smtp.gmail.com with ESMTPSA id x19sm2149017pfk.14.2018.12.06.16.29.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Dec 2018 16:29:40 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com
Subject: [PATCH] libbtrfsutil: fix unprivileged tests if kernel lacks support
Date:   Thu,  6 Dec 2018 16:29:32 -0800
Message-Id: <a75b30c33c1b7aa0abc4403338d19a03526303c1.1544142538.git.osandov@fb.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

I apparently didn't test this on a pre-4.18 kernel.
test_subvolume_info_unprivileged() checks for an ENOTTY, but this
doesn't seem to work correctly with subTest().
test_subvolume_iterator_unprivileged() doesn't have a check at all. Add
an explicit check to both before doing the actual test.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Based on the devel branch.

 libbtrfsutil/python/tests/test_subvolume.py | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index 99ec97bc..b06a1d3d 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -168,12 +168,13 @@ class TestSubvolume(BtrfsTestCase):
 
         with drop_privs():
             try:
-                self._test_subvolume_info(subvol, snapshot)
+                btrfsutil.subvolume_info(self.mountpoint)
             except OSError as e:
                 if e.errno == errno.ENOTTY:
                     self.skipTest('BTRFS_IOC_GET_SUBVOL_INFO is not available')
                 else:
                     raise
+            self._test_subvolume_info(subvol, snapshot)
 
     def test_read_only(self):
         for arg in self.path_or_fd(self.mountpoint):
@@ -487,6 +488,13 @@ class TestSubvolume(BtrfsTestCase):
         try:
             os.chdir(self.mountpoint)
             with drop_privs():
+                try:
+                    list(btrfsutil.SubvolumeIterator('.'))
+                except OSError as e:
+                    if e.errno == errno.ENOTTY:
+                        self.skipTest('BTRFS_IOC_GET_SUBVOL_ROOTREF is not available')
+                    else:
+                        raise
                 self._test_subvolume_iterator()
         finally:
             os.chdir(pwd)
-- 
2.19.2

