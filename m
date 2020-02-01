Return-Path: <SRS0=V5Z0=3V=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DC2C33C9E
	for <linux-btrfs@archiver.kernel.org>; Sat,  1 Feb 2020 03:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9D7B206D3
	for <linux-btrfs@archiver.kernel.org>; Sat,  1 Feb 2020 03:51:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aNWXTKAT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgBADvk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 31 Jan 2020 22:51:40 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:50654 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgBADvk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Jan 2020 22:51:40 -0500
Received: by mail-pj1-f67.google.com with SMTP id r67so3831555pjb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jan 2020 19:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KeIXCrwHcHdvpxpnsBGJesWcBaTKXzcV+n6XTWh7I2g=;
        b=aNWXTKATusjuICcwVeR2xGCxZQbE0p4JzJHK9R67Y6lZoRTF9HEWHGMMX9LbRdCDWj
         WKhjVAQlXQMZAPDLCpMjVhFVxmqKCzCnqzA51yZmsbT/71HRzu5M0Rq6QlR+feNEKGd+
         AVsFlOcG3Mad56Dq7VuRr3XT4tRU5n/uL9qfKvSUTjTUvfyYe3DDWJTv5ssyEhREBCxq
         lKDB9jVHek0eszVBLTrr0fNkSF/kknHWLHqnQJlR7lgWzgdsumREecECulw4VJpv12oa
         AM4ipN99Dy+DIiuY04N3GSDJRFiko1xjvQ1fh96cxB5QO5smC7ZizMxQ8af3aJQwDerp
         MuOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KeIXCrwHcHdvpxpnsBGJesWcBaTKXzcV+n6XTWh7I2g=;
        b=dP02NyOSWzOKA2DoZ7cHATlOFKHcFIiBVK/1wG2ym8RPcLbpTK0qAeLW+NTP6NugCK
         EJ4feNV5CwX8sbH8PSNvCf+tpXE+QQokifxMx0HxYXjp1gH6lZjc7h2JWhoPP499PHVk
         QEFmRi6CXzTvk6POWzYdJAVQSH9DQbIDScWEigIY9ip5kXO290tKygizXm7dFJDAAaYe
         zHw7k+mdXqkPkvwQdDfzrzM4gRTpXAw/eXZ3oqaXVIahqfORa7CAAV+S9QuKDWJFty4C
         DKUNZSuf71oDdxOQUpFBd2KYJYSimqGgYWgM3VtFZnFBqi+BvGtL1m59lXe67JSp3z6O
         F/Uw==
X-Gm-Message-State: APjAAAXVjq1JtKw3GfgWMKVbN4qRiM8f/uHPLJIqaKe9viRVl4Z29mBx
        C7jQKfaeYTwdxuEykRhAqtY=
X-Google-Smtp-Source: APXvYqwhsr2xwBmskxddn7qbFP2sRr8NHaRvHJfFOGAEJvpByLyY8OEqo8wpkKQ7FsNEX1E8coBnsQ==
X-Received: by 2002:a17:90a:9285:: with SMTP id n5mr16953328pjo.58.1580529098367;
        Fri, 31 Jan 2020 19:51:38 -0800 (PST)
Received: from localhost ([43.224.245.179])
        by smtp.gmail.com with ESMTPSA id v15sm11604277pju.15.2020.01.31.19.51.37
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 31 Jan 2020 19:51:37 -0800 (PST)
From:   qiwuchen55@gmail.com
To:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        trivial@kernel.org
Cc:     linux-btrfs@vger.kernel.org, chenqiwu <chenqiwu@xiaomi.com>
Subject: [PATCH] btrfs: remove trivial nowait check
Date:   Sat,  1 Feb 2020 11:51:33 +0800
Message-Id: <1580529093-26170-1-git-send-email-qiwuchen55@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: chenqiwu <chenqiwu@xiaomi.com>

Remove trivial nowait check for btrfs_file_write_iter(),
since buffered writes will return -EINVAL if IOCB_NOWAIT
passed in the follow-up function generic_write_checks().

Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
---
 fs/btrfs/file.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a16da27..320af95 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1896,10 +1896,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	loff_t oldsize;
 	int clean_page = 0;
 
-	if (!(iocb->ki_flags & IOCB_DIRECT) &&
-	    (iocb->ki_flags & IOCB_NOWAIT))
-		return -EOPNOTSUPP;
-
 	if (iocb->ki_flags & IOCB_NOWAIT) {
 		if (!inode_trylock(inode))
 			return -EAGAIN;
-- 
1.9.1

