Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC2DC07E85
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9656B223DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 07:47:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="hHMhWbdJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9656B223DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730966AbeKNRtU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 12:49:20 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38744 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728391AbeKNRtU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 12:49:20 -0500
Received: by mail-pf1-f196.google.com with SMTP id v76-v6so4653854pfa.5
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 23:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tT0L3WXhX6CWb7+LLMy+cVe4RqqwSuboJ9m0Yzn+cEA=;
        b=hHMhWbdJHkMRIqR7alLuzGyWHKeYcHi//TAbMfYFgD1cRqfjBt38nlCmDeEMFtcoco
         WjH+msOUINzO5ky8LK66JjHyMEs0bXNN5MsK0Y6MsQeOjszOHg91DMJMD69ldGBwKcsY
         3NUuixFUs7iSQiVlpgTGZQcFizWj0iF2j+pFUXInvJ0GLtPaQgJwofr1Nrx0VWsgwxfL
         pW4Qg1ZksV1eF5sNHWb08R09zk2xA8QR6PN1mcQUkqmANbUiP5X2JvoVhE3ntHGnoKYq
         g5M8X4VzHyLUiCEz83qYDE/eaijLW/xuZi7LOaSKE9GvFZ2JFXSILeBczPhtvqLLv8f4
         TISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tT0L3WXhX6CWb7+LLMy+cVe4RqqwSuboJ9m0Yzn+cEA=;
        b=XOD0JSLUudH2G63edNsLasKJFi9fqRj/nJKHZk/bsBXLQObJ5q8HNJSlcrUykRrfog
         hxqxR17grncbdIDKxQV7pPRpsFYUCysm62Ng7oLyf+sHnwY10wl2HRQDr1ZII2d/QLej
         0LcxCzpFvxh2OfiyY+coeMhjkvB9X489wWCU1yAEozLDK9855WJA+DmCkRRqxn8y5PoD
         fscCcjE+hE9cbsOdQyOYXVmpO6QFVnyCizyhpZpE3u7U7Iy45k8rg1eXHleEOLoKXKDF
         ObIEL4/D4hfHBNDYAG8SSStYdsTTyL/ZCV/4sgYZ3kTDMp8u7WhnbfTj6YhIvEHBexRt
         GkJg==
X-Gm-Message-State: AGRZ1gL6EJ9I/zeC0d88E9CpZGtsiit81zPAB5y8tSK4HvmzaozhEHti
        mQ/QvenmLVqGMOmGigyuI+03+PBBX4TsiA==
X-Google-Smtp-Source: AJdET5fzPu4hggHD4AZ12NloR8SYaMDyF/eUXPRYHUYuu7OAatcJxENVf317/MU+cFYC9HtfnKrXiA==
X-Received: by 2002:a63:fd53:: with SMTP id m19mr810966pgj.340.1542181634415;
        Tue, 13 Nov 2018 23:47:14 -0800 (PST)
Received: from vader.psav.com ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id 18-v6sm34835727pfu.129.2018.11.13.23.47.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 23:47:14 -0800 (PST)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 01/10] libbtrfsutil: use top=0 as default for SubvolumeIterator()
Date:   Tue, 13 Nov 2018 23:46:56 -0800
Message-Id: <5289ed9c7a0beffba53a5ebacc1bad7a07a41000.1542181521.git.osandov@fb.com>
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

Right now, we're defaulting to top=5 (i.e, all subvolumes). The
documented default is top=0 (i.e, only beneath the given path). This is
the expected behavior. Fix it and make the test cases cover it.

Reported-by: Jonathan Lemon <bsd@fb.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 libbtrfsutil/python/subvolume.c             | 2 +-
 libbtrfsutil/python/tests/test_subvolume.py | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/libbtrfsutil/python/subvolume.c b/libbtrfsutil/python/subvolume.c
index 069e606b..6ecde1f6 100644
--- a/libbtrfsutil/python/subvolume.c
+++ b/libbtrfsutil/python/subvolume.c
@@ -525,7 +525,7 @@ static int SubvolumeIterator_init(SubvolumeIterator *self, PyObject *args,
 	static char *keywords[] = {"path", "top", "info", "post_order", NULL};
 	struct path_arg path = {.allow_fd = true};
 	enum btrfs_util_error err;
-	unsigned long long top = 5;
+	unsigned long long top = 0;
 	int info = 0;
 	int post_order = 0;
 	int flags = 0;
diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
index 93396cba..0788a564 100644
--- a/libbtrfsutil/python/tests/test_subvolume.py
+++ b/libbtrfsutil/python/tests/test_subvolume.py
@@ -353,6 +353,7 @@ class TestSubvolume(BtrfsTestCase):
                 with self.subTest(type=type(arg)):
                     self.assertEqual(list(btrfsutil.SubvolumeIterator(arg)), subvols)
             self.assertEqual(list(btrfsutil.SubvolumeIterator('.', top=0)), subvols)
+            self.assertEqual(list(btrfsutil.SubvolumeIterator('foo', top=5)), subvols)
 
             self.assertEqual(list(btrfsutil.SubvolumeIterator('.', post_order=True)),
                              [('foo/bar/baz', 258),
@@ -365,6 +366,7 @@ class TestSubvolume(BtrfsTestCase):
             ]
 
             self.assertEqual(list(btrfsutil.SubvolumeIterator('.', top=256)), subvols)
+            self.assertEqual(list(btrfsutil.SubvolumeIterator('foo')), subvols)
             self.assertEqual(list(btrfsutil.SubvolumeIterator('foo', top=0)), subvols)
 
             os.rename('foo/bar/baz', 'baz')
-- 
2.19.1

