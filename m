Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6389C6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B7B320835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="vXUEaHu6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B7B320835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbeJLDYF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:05 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39930 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDYF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:05 -0400
Received: by mail-qk1-f195.google.com with SMTP id q5-v6so6273722qki.6
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=5ErWA8iDFY+6lz4JimjzCOpUtgurbUZk5oK0tyfx1Sk=;
        b=vXUEaHu6EI4QOrztq8r6jxGq+TwWOTeI5byEwAKRUsqU6R+X3VvX2+B21eEhzqbzL2
         ORwT6hHFL5iVETNhjVOdNvUA05cawKOW+IfZzVMu1CtdBuCSrsIG5W9lVdtaJ2bHdhrl
         QtmjTMEm7eOEuEitlHTkdtIEElAawnS/PoRkKWxQq5MD4g7TYxXqDqs5PsURMJ256CJE
         RsqVCZjkAM1OIvEPoz0L0+KxBIxuTpY6CbZx6JZJYUD+fTSg4jaUQNvNQ6Y/0nZ8zT7G
         u/8OX117Djh4JvsqvmGgzys7mvnf28cZ/0ZTzhbnahXUTEZcsu75hRMnA0V7Sjamp0bX
         bFIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=5ErWA8iDFY+6lz4JimjzCOpUtgurbUZk5oK0tyfx1Sk=;
        b=UclJKpTyHX2yyqgI+bZ7mUi2xTdOBY+e0C+Sv/jDCrLNAoPscMFFZMFN+Wdtxayqnr
         KX5OTrZlDDas+zkaGqcPH2TVSKH3f8Ht4SKr7gs7rV5pUD3MUe3AzYVYufr7oMtM1u8Y
         pcWdq11uFnrGnZ5rJPKXVodIg9ryIADNTPH8DqTyefMQjAtb1K7kGZpVgTrB7W4adyT6
         Dr3YdaPuWGlrQFKTDI0zsTOpJCIBa8d3TxbLC1XcUdRDkqq4JZVajfCHMBJ/30zotFd9
         k30q+6jr2vB4w1erEKfEsLHgVlLLmuu7mhClgwU7RYwQhg/+rulqiqDp9CbHMQyK7Omb
         dkLA==
X-Gm-Message-State: ABuFfoj8IPSYzTieNLjw2isiSOKu/dmBFjcchOnsquvkfOAFM55f6LE9
        gjrJpm/ujdGcimaL9TMpv3Xui1jZLlg=
X-Google-Smtp-Source: ACcGV62fJ6FlKbyoJqiIJ0PeckMX20CGJ9vAC/RdcRZ6skbM4XjsJJNg8FDE5w1BWq2JIDo6iJIt0w==
X-Received: by 2002:a37:aa44:: with SMTP id t65-v6mr3049606qke.121.1539287719398;
        Thu, 11 Oct 2018 12:55:19 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 18-v6sm18686875qtm.13.2018.10.11.12.55.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:18 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 24/42] btrfs: assert on non-empty delayed iputs
Date:   Thu, 11 Oct 2018 15:54:13 -0400
Message-Id: <20181011195431.3441-25-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I ran into an issue where there was some reference being held on an
inode that I couldn't track.  This assert wasn't triggered, but it at
least rules out we're doing something stupid.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 377ad9c1cb17..39bd158466cd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3979,6 +3979,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 	kthread_stop(fs_info->transaction_kthread);
 	kthread_stop(fs_info->cleaner_kthread);
 
+	ASSERT(list_empty(&fs_info->delayed_iputs));
 	set_bit(BTRFS_FS_CLOSING_DONE, &fs_info->flags);
 
 	btrfs_free_qgroup_config(fs_info);
-- 
2.14.3

