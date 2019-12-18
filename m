Return-Path: <SRS0=fY3M=2I=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB133C43603
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Dec 2019 01:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0BB12176D
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Dec 2019 01:17:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vp5r/xir"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfLRBRQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 20:17:16 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:36312 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbfLRBRQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Dec 2019 20:17:16 -0500
Received: by mail-wm1-f52.google.com with SMTP id p17so114795wma.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2019 17:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K7vMeQtHp2pTdLZp29RRySuDsZeGdh3N0jZOEktKHu8=;
        b=Vp5r/xirn6LGxltCmUgNkX4+ge4YhcTmAkSymeXVX1jwLPTcQqxC5qWJucmbVwGNoK
         GhD8RMpFAOMXz9/fxU1fYXTgJX3kYH3wu8eh085yhUeg/jajrwQNbF8reVtQhz6WzAaa
         lh40tvjneHWZmQ5Qio/e7u8AwcXFvGD2xsdcUvNueKZI8VWCkxM4Jp+0VYzgdomccb8p
         KDBxro3pVq5i1LuKozYzby+KCFxB005WEtd+WYRo2svyF7QwXlD0YhR5eY13fTcHtrg/
         9nqkt6Uw+WZvl+Hc2RINge5jSprk94tuiWiYVML5HLuzO/esTD4UpFfkCOtNXFrFvljz
         4yCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K7vMeQtHp2pTdLZp29RRySuDsZeGdh3N0jZOEktKHu8=;
        b=isLCNvMpiQved5SC2ekaIG2p4iC6KTuZCUw/3LFecmD8mLwY5VczzCUr5IhUcIa91w
         30O45KCpom7ICMV7cqoUNjf35PMr1UQW1gY+WAAZquGz4Yog/modxKhQpZjgfrp8lR+o
         NmLdz6QedwGSVVfOh2XwN8oM4TueW5u3XXxw3Tz3tIoN4ks0QxhuZwA959hMS1AjKX//
         XTwJq7QMEdXzH87t7LaUPAFApvMtGpLs2Cp676RKxjghrDZW/PWbzXw9/yH1VxXm2jJs
         fy9zC4bMHUJmhT3W/+xuG8ccLcqvR2ctUfi+qR3ghkHW5qr08/4iOXbk4/ds+ZQ53UP0
         dFzQ==
X-Gm-Message-State: APjAAAXQt0FZ3fPGWYai5woMK3ggwNeSCKo3MRK0kI2j7AiBnzu/Khm3
        i8mbhvBuj1IKaTZZRVi/eV16JXjQ
X-Google-Smtp-Source: APXvYqyJgLJD4oMAVuRFxk5kG5yedZxsDHJu2IhJ8F8Eymwp1jm+Qim+qWupq7kst1lAVpnAbj4gKw==
X-Received: by 2002:a1c:9c08:: with SMTP id f8mr12955wme.171.1576631834841;
        Tue, 17 Dec 2019 17:17:14 -0800 (PST)
Received: from hephaestus.suse.de ([179.185.209.78])
        by smtp.gmail.com with ESMTPSA id g25sm4782854wmh.3.2019.12.17.17.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 17:17:14 -0800 (PST)
From:   Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc:     dsterba@suse.com, linux-btrfs@vger.kernel.org,
        Marcos Paulo de Souza <mpdesouza@suse.com>, wqu@suse.com
Subject: [btrfs-progs PATCHv2 3/4] tests: mkfs: 005: Use check_dm_target_support helper
Date:   Tue, 17 Dec 2019 22:19:24 -0300
Message-Id: <20191218011925.19428-4-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191218011925.19428-1-marcos.souza.org@gmail.com>
References: <20191218011925.19428-1-marcos.souza.org@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

This way we ensure the linear target is available and skip the test.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tests/mkfs-tests/005-long-device-name-for-ssd/test.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh b/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh
index e7a1ac45..329deaf2 100755
--- a/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh
+++ b/tests/mkfs-tests/005-long-device-name-for-ssd/test.sh
@@ -5,6 +5,7 @@ source "$TEST_TOP/common"
 
 check_prereq mkfs.btrfs
 check_global_prereq dmsetup
+check_dm_target_support linear
 
 setup_root_helper
 prepare_test_dev
-- 
2.23.0

