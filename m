Return-Path: <SRS0=yR0V=2H=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11222C43603
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Dec 2019 20:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D66D3206E0
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Dec 2019 20:30:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tvanbSyF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbfLQUaN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 15:30:13 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:52097 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfLQUaM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Dec 2019 15:30:12 -0500
Received: by mail-wm1-f45.google.com with SMTP id d73so4264594wmd.1
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2019 12:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f2W5eTc6AxDAskmpcvhYL5t/lDA/xZVRqUFlVDhgwMA=;
        b=tvanbSyF8bY0EiOa6QEEq56pbEyKls1eA6+kwZW9fUXscIQiDm78V/KSmVnE/kXvDh
         rClJXR54CSlY7tnMXBJUDYtUxyTSz3L/DgQhPsPAWfhrW3wLh5LVAsK9KaOMeQ2Hryb6
         NqzbapJX4TZcxpTYG+mmJtm5gsIE1+RtJ8ehoEhSxyoz5CCUj/m71fK88EEn1xepCvK/
         bL0g0EkP4dJnri/xO07IsSrWIz2zbp7GWSHTwE+l9IhKHzh8Z1r3Ixh2HlI+myXaen3f
         2OJhVChNxtTzesg7Ne2ib67EprBT+PDlGXEIQS1SDybuDMQKlzvHBAN8qz8gicTx4a7t
         9jFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f2W5eTc6AxDAskmpcvhYL5t/lDA/xZVRqUFlVDhgwMA=;
        b=KEtESrPzELidsTVkQqA+luoJUcPJ0eE3DJ88AHk/8yyNk7trGdipjGN3AfUuaDZRoh
         qeH3a6qeIL9SlWXCGL49D+/WzweU85OHD22H3iIHHf8HDXYxCDl1cQkpPCyzmGFQTX6h
         yAM95+uBEUJj5ODjWMsZiKSuvZgMm4kbIp8QSYjToWiBbWFyXafJVCKi9OaWs3wlEoe1
         Zk4fn5tGBSvSn3uIIsRgw/77MD/UMJhq+LlYfhlk5tF4t3dsC8F9wmxW6lNBk6JlSJEC
         26tn5Rg0qEzrFeN3ZdGxh/GqCHwPntlaIblpTaSv36IyicjQvxVyY2to8Fi2xT2gzx/C
         W6xw==
X-Gm-Message-State: APjAAAXwYwxlSCjzW8OmhMAocVb7nfQjQKK86Zi0fvKY1dQrcTmXUh+O
        An+6kmrwKZjq/I3MCQ/ctP4Ph8L6
X-Google-Smtp-Source: APXvYqxAdEslDiq+47ksrN/xp5FwDFyW61PwIjgaFne27VFQrLH6MFx/AVsTKhmk1Vl1sjqTtnh6xg==
X-Received: by 2002:a1c:f213:: with SMTP id s19mr8089715wmc.42.1576614610751;
        Tue, 17 Dec 2019 12:30:10 -0800 (PST)
Received: from hephaestus.suse.de ([179.185.209.78])
        by smtp.gmail.com with ESMTPSA id h17sm27910619wrs.18.2019.12.17.12.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 12:30:10 -0800 (PST)
From:   Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc:     dsterba@suse.com, linux-btrfs@vger.kernel.org,
        Marcos Paulo de Souza <mpdesouza@suse.com>, wqu@suse.com
Subject: [btrfs-progs PATCH 2/4] tests: mkfs: 017: Use check_dm_target_support helper
Date:   Tue, 17 Dec 2019 17:31:53 -0300
Message-Id: <20191217203155.24206-3-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191217203155.24206-1-marcos.souza.org@gmail.com>
References: <20191217203155.24206-1-marcos.souza.org@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

If dm-thin or dm-linear are not supported, let's skip the test altogether
instead of throwing an error.

Issue: #192

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 .../017-small-backing-size-thin-provision-device/test.sh         | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/mkfs-tests/017-small-backing-size-thin-provision-device/test.sh b/tests/mkfs-tests/017-small-backing-size-thin-provision-device/test.sh
index 32640ce5..91851945 100755
--- a/tests/mkfs-tests/017-small-backing-size-thin-provision-device/test.sh
+++ b/tests/mkfs-tests/017-small-backing-size-thin-provision-device/test.sh
@@ -7,6 +7,7 @@ source "$TEST_TOP/common"
 check_prereq mkfs.btrfs
 check_global_prereq udevadm
 check_global_prereq dmsetup
+check_dm_target_support linear thin
 
 setup_root_helper
 prepare_test_dev
-- 
2.23.0

