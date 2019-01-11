Return-Path: <SRS0=hHgh=PT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92152C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 15:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63E4F20675
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 15:21:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="K9b0ezpf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731143AbfAKPVK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jan 2019 10:21:10 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36510 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbfAKPVJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jan 2019 10:21:09 -0500
Received: by mail-qk1-f193.google.com with SMTP id o125so6716448qkf.3
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2019 07:21:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=N45SWvepwcroEPnphEt+dLodfsACU/p3srtHQgF6qi4=;
        b=K9b0ezpfviPiMF9CQEWVfp7Bgvof66OOoTF9Z/MoYvejLFjFGa85KZx/jmjE4f8ofY
         HiAmko6NfKVnckdOrj2Zbvfo6V48Tg2eJlDuabILdSHXHB1WRNPd+qnva9DAqO25/dAv
         asT1HW+ywJXZM09s1F1lePlwqnKSF+W1xgKbMRcdJDLyi0BiIZ7ck6qbaz92L1KtXNJG
         8nEolBMwfkrwI7INONaRhvhWWWzAUp+ub6RpV4tcRgljnL8pxCXV6gH4rhxyIZEc9ndl
         PBAfy8qiM8gPI0+ZdjkJlaNflkSooNfGx2iWTRb+1NSh37GCPKK6NcWyA8nRMX6FpMKM
         INQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=N45SWvepwcroEPnphEt+dLodfsACU/p3srtHQgF6qi4=;
        b=gyw0Geyh1hBYlV/F+0ZiR52txvN8VdXkTFaaaIbYLVxmHHc71ejRKvOWo1AnXrMxxm
         rgEpVzDtKpQEminQoyYFGzlvWZPLgIQ8/UJNxyZWhU5PS0DUmFjuK6U+t6Gadr7ejVqW
         6s7DNP3TsqF8hM+FkF+G5+yWf+oRIaWGlS5azXdxQzhtXtupjIMEf0hSZ3iY7c70FYBI
         2YEZtAouJsnaRqJfhP0MOWlUmMifxf2Gw1gfjuAC6IoApHOInLVEVEGfqCN2JNpUuNxJ
         XpRh1mHesN3GQNgwhntTOMMhx6kkxpp0h01TTrCL0j4LRXtOkFkNCbRfzdBRZDlTIgHW
         fmAA==
X-Gm-Message-State: AJcUukfipyUsJqryiwCCq9f5aJwPjKbyoJ1Sh+gHesxXXPKvQw+a5U6U
        tju3sqWVLXpcjLHoN89nVq7D20XdXoA=
X-Google-Smtp-Source: ALg8bN6ogrHeFAEK6Ny5olSrx5lu9JLjNzz1PlpjVlzX6Uc2zw5hrnKL5oFZWUFnd8uO7xzDaTWECw==
X-Received: by 2002:a37:96c2:: with SMTP id y185mr12728016qkd.239.1547220068250;
        Fri, 11 Jan 2019 07:21:08 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id w34sm46564659qtj.27.2019.01.11.07.21.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Jan 2019 07:21:07 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 1/3] btrfs: run delayed iputs before committing
Date:   Fri, 11 Jan 2019 10:21:01 -0500
Message-Id: <20190111152103.17001-2-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20190111152103.17001-1-josef@toxicpanda.com>
References: <20190111152103.17001-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Delayed iputs means we can have final iputs of deleted inodes in the
queue, which could potentially generate a lot of pinned space that could
be free'd.  So before we decide to commit the transaction for ENOPSC
reasons, run the delayed iputs so that any potential space is free'd up.
If there is and we freed enough we can then commit the transaction and
potentially be able to make our reservation.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/extent-tree.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8dfddfd3f315..0127d272cd2a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4953,6 +4953,15 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 			ret = 0;
 		break;
 	case COMMIT_TRANS:
+		/*
+		 * If we have pending delayed iputs then we could free up a
+		 * bunch of pinned space, so make sure we run the iputs before
+		 * we do our pinned bytes check below.
+		 */
+		mutex_lock(&fs_info->cleaner_delayed_iput_mutex);
+		btrfs_run_delayed_iputs(fs_info);
+		mutex_unlock(&fs_info->cleaner_delayed_iput_mutex);
+
 		ret = may_commit_transaction(fs_info, space_info);
 		break;
 	default:
-- 
2.14.3

