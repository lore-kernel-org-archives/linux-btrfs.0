Return-Path: <SRS0=8Hks=Z6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD680C43603
	for <linux-btrfs@archiver.kernel.org>; Sun,  8 Dec 2019 09:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8389920700
	for <linux-btrfs@archiver.kernel.org>; Sun,  8 Dec 2019 09:30:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ambroffkao-com.20150623.gappssmtp.com header.i=@ambroffkao-com.20150623.gappssmtp.com header.b="nQYlhfpJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfLHJa6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 8 Dec 2019 04:30:58 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34406 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfLHJa6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Dec 2019 04:30:58 -0500
Received: by mail-pg1-f193.google.com with SMTP id r11so5576605pgf.1
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Dec 2019 01:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ambroffkao-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qUTvM0fd97uzuS3vHyWuZTj7M6xT4JzX9ox7EaqmNPU=;
        b=nQYlhfpJo4aAIr8AgahoR0hSMXsGJLe1Mb85pokwY2QjopHgG/zAquuXkjdHlftc2m
         uzXS1gXLi+4raUKIuE8vrZeO7MRExZR8mdFH7AbkgGE/pGTyCfwHtdHV8GOMcdfwhovF
         LlzW+T9DlcQ/oeYVOLZyAAAyH558S5JuDOK59LR9X4lndVyP04oEFhxaVUXD3HNVcomz
         PtGw6KcngcEwwMnpGh+j8F5HjIi687cDBnM79lXUFdXbZtXVwHSlOV9ApjeQQxYAx2nt
         40W/YtOTsNappGV99yqk1QONrtFxh4XGHFLh/26CkDNAaX6AmZEr6gCzWjTbnuOekien
         IPaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qUTvM0fd97uzuS3vHyWuZTj7M6xT4JzX9ox7EaqmNPU=;
        b=efrDcv++JQeVCrRfqZqc/m2S77ZgbDK2U5+SyLqZdVdO7Rz95NH07IDU7+6khdjpu9
         jdS5zxJ1UX9TOgL/1Z6iLzc+WglJupZRxKqpjQxNCvONAE1yvNzxpi9vbBLw85XuKIGR
         +8C29bEStYW7bh9BrV+yqx5LqWCSzsyzUOwH0O4MChScAzWc5w3I+C8mioGhPM/qd9E1
         UmFEgD/xHuqwegD4lTVYffZUrOn8dJ7Vn/4pflUc43JhWcn5hyEyRYiWWc9XFn349tV2
         5xdTlph2Rryyez3xqux/KfM13DLdzds9s5xMb14T8qibCOJW5Q75CCis7rAXworL36U8
         IPQA==
X-Gm-Message-State: APjAAAUfzzNKTNoiUhHmRbxQi0o+caOvyLCOSUQ4cT89zoksvx9EPBDO
        KCgtel2HolBsQTXYMRgg2sZOk9mULJyPYA==
X-Google-Smtp-Source: APXvYqwc3//kAgl9ayVRim0N8m+6YtxsK0WJv/6IVdRRcz3q5OUaFzmCL4CVt38gHraXu7Qvn68kNQ==
X-Received: by 2002:a63:6a01:: with SMTP id f1mr12549899pgc.92.1575797456985;
        Sun, 08 Dec 2019 01:30:56 -0800 (PST)
Received: from localhost.localdomain ([66.234.200.130])
        by smtp.gmail.com with ESMTPSA id m127sm9077978pfm.167.2019.12.08.01.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Dec 2019 01:30:56 -0800 (PST)
From:   Kyle Ambroff-Kao <kyle@ambroffkao.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Kyle Ambroff-Kao <kyle@ambroffkao.com>
Subject: [PATCH 0/1] Support replacing a device with smaller one
Date:   Sun,  8 Dec 2019 01:30:44 -0800
Message-Id: <20191208093045.43433-1-kyle@ambroffkao.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is a pretty simple patch to address Bug 112741: "btrfs device
replace" should allow smaller devices if possible[1].

I have a followup patch for btrfs-progs related to this which updates
the validation and adds an extra prompt.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=112741

Kyle Ambroff-Kao (1):
  btrfs: Allow replacing device with a smaller one if possible

 fs/btrfs/dev-replace.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

-- 
2.20.1
