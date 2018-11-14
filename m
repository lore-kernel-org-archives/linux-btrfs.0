Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F27CC07E85
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0833921780
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="v8f/7Hwa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0833921780
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731549AbeKNRtW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 12:49:22 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34703 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbeKNRtW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 12:49:22 -0500
Received: by mail-pl1-f196.google.com with SMTP id f12-v6so7391749plo.1
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 23:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=foxWeLr8j1S5w+DIGd1S4EO8mom91i5V/iHD3e+qfus=;
        b=v8f/7HwafB0m1i8Q1aSfHBo39uzgLNS+w3oi0rQMOFl5jVGG93db4lRy5ZPQD+25vu
         J/xOPsxbYzT6abE8N/pj8FWzE1oe2xaQm1LOlQXX8ZRKCniSfkNCM0v+RMK9aGPITPMn
         14DqliTXxYOVqtDl+VsS4V9cbYBWA9wI6KpDh8JKu/ihiUPsojHUW85W+34B2ydnzscj
         2/WLcEDKD41UkPfOwr+5UuURKpe8jINJAwUrk7E1Tcxj2j4C/4LNMNx0QKjea5TwW3Zr
         qScAail3HNoCBx3HoCvtrZGFx3d49IN9sqLVO0chiBkmhmvB4pUH2Fcd8KFiG8WFtXVa
         nCzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=foxWeLr8j1S5w+DIGd1S4EO8mom91i5V/iHD3e+qfus=;
        b=VhJowgZHBlBTKmZOijRFPdvBRIBswIRVgUK0v7PO+AWMcgq/3rftFBIcJ7xP5tbNOa
         25su+YMmnbziJyrNykqkvJfsW8EjzvSSRnD3JGvqQAM4zDctKSZi8Rag5/+8lRfTY/Mu
         CM5qh6bV044Bi9ekwk/i1CC7x3sgtb2ELhBphghpKqKdf2lBVeKJtcSbrTzfE8XMArRI
         BWmcmuSeb2ENo4CNFrzLnPXkcSkurzGbxD6wc5CfwHe+ukbyL1gwUG8OzCygiTcZxdxB
         MIydnTmKbMQXtSw5YqS/kc0dZzwWxo2z+WSVRbRhCwFh+9rpPbF7epw8aDjuuAYpJS7Q
         zMrg==
X-Gm-Message-State: AGRZ1gKa4atRY1pw+5HspwyBUkCJrmsPW9k2mS2XayhST1zOub4Yhvpa
        FDSjOlD60O2UGHgbhkueAaOsvS2hww6Qew==
X-Google-Smtp-Source: AJdET5fjd6owpS/wAcsPWfuirfOjp6kS1ck5r5NhD8pECYZUK9SRWlhfeqnWEsOeVbQQLC8Be8aVKw==
X-Received: by 2002:a17:902:5e4:: with SMTP id f91-v6mr864433plf.75.1542181636599;
        Tue, 13 Nov 2018 23:47:16 -0800 (PST)
Received: from vader.psav.com ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id 18-v6sm34835727pfu.129.2018.11.13.23.47.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 23:47:16 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 04/10] libbtrfsutil: use SubvolumeIterator as context manager in tests
Date:   Tue, 13 Nov 2018 23:46:59 -0800
Message-Id: <94a9460115633511dc90023dd74748b25f479797.1542181521.git.osandov@fb.com>
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

We're leaking file descriptors, which makes it impossible to clean up
the temporary mount point created by the test.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/python/tests/test_subvolume.py | 51 ++++++++++++---------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index f2a4cdb8..4049b08e 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -334,11 +334,13 @@ class TestSubvolume(BtrfsTestCase):
             os.chdir(self.mountpoint)
             btrfsutil.create_subvolume('foo')
 
-            path, subvol = next(btrfsutil.SubvolumeIterator('.', info=True))
-            self.assertEqual(path, 'foo')
-            self.assertIsInstance(subvol, btrfsutil.SubvolumeInfo)
-            self.assertEqual(subvol.id, 256)
-            self.assertEqual(subvol.parent_id, 5)
+            with btrfsutil.SubvolumeIterator('.', info=True) as it:
+                path, subvol = next(it)
+                self.assertEqual(path, 'foo')
+                self.assertIsInstance(subvol, btrfsutil.SubvolumeInfo)
+                self.assertEqual(subvol.id, 256)
+                self.assertEqual(subvol.parent_id, 5)
+                self.assertRaises(StopIteration, next, it)
 
             btrfsutil.create_subvolume('foo/bar')
             btrfsutil.create_subvolume('foo/bar/baz')
@@ -350,30 +352,37 @@ class TestSubvolume(BtrfsTestCase):
             ]
 
             for arg in self.path_or_fd('.'):
-                with self.subTest(type=type(arg)):
-                    self.assertEqual(list(btrfsutil.SubvolumeIterator(arg)), subvols)
-            self.assertEqual(list(btrfsutil.SubvolumeIterator('.', top=0)), subvols)
-            self.assertEqual(list(btrfsutil.SubvolumeIterator('foo', top=5)), subvols)
-
-            self.assertEqual(list(btrfsutil.SubvolumeIterator('.', post_order=True)),
-                             [('foo/bar/baz', 258),
-                              ('foo/bar', 257),
-                              ('foo', 256)])
+                with self.subTest(type=type(arg)), btrfsutil.SubvolumeIterator(arg) as it:
+                    self.assertEqual(list(it), subvols)
+            with btrfsutil.SubvolumeIterator('.', top=0) as it:
+                self.assertEqual(list(it), subvols)
+            with btrfsutil.SubvolumeIterator('foo', top=5) as it:
+                self.assertEqual(list(it), subvols)
+
+            with btrfsutil.SubvolumeIterator('.', post_order=True) as it:
+                self.assertEqual(list(it),
+                                 [('foo/bar/baz', 258),
+                                  ('foo/bar', 257),
+                                  ('foo', 256)])
 
             subvols = [
                 ('bar', 257),
                 ('bar/baz', 258),
             ]
 
-            self.assertEqual(list(btrfsutil.SubvolumeIterator('.', top=256)), subvols)
-            self.assertEqual(list(btrfsutil.SubvolumeIterator('foo')), subvols)
-            self.assertEqual(list(btrfsutil.SubvolumeIterator('foo', top=0)), subvols)
+            with btrfsutil.SubvolumeIterator('.', top=256) as it:
+                self.assertEqual(list(it), subvols)
+            with btrfsutil.SubvolumeIterator('foo') as it:
+                self.assertEqual(list(it), subvols)
+            with btrfsutil.SubvolumeIterator('foo', top=0) as it:
+                self.assertEqual(list(it), subvols)
 
             os.rename('foo/bar/baz', 'baz')
-            self.assertEqual(sorted(btrfsutil.SubvolumeIterator('.')),
-                             [('baz', 258),
-                              ('foo', 256),
-                              ('foo/bar', 257)])
+            with btrfsutil.SubvolumeIterator('.') as it:
+                self.assertEqual(sorted(it),
+                                 [('baz', 258),
+                                  ('foo', 256),
+                                  ('foo/bar', 257)])
 
             with btrfsutil.SubvolumeIterator('.') as it:
                 self.assertGreaterEqual(it.fileno(), 0)
-- 
2.19.1

