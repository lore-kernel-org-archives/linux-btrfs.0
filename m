Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 097CBC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5706214D9
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:05:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="EV+q0NxW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5706214D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732108AbeKVFlY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:41:24 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:39205 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730172AbeKVFlY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:41:24 -0500
Received: by mail-yw1-f67.google.com with SMTP id v8-v6so2679928ywh.6
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=xMNYjYZWLpf7m1COoaNSNiw8vw9MswDKLqZGSLeZQig=;
        b=EV+q0NxW1ZGbtiCbJzkuEZUNTI9t0gRMYo266x27S4eLEpF5O5EEqkeSBjhXTZNTpf
         9RFEwHJmuuP4iJmY81Lt5opsVpmPH9YJVu2ZOb4reY5RYxyAjkD8dKqyl0F32Yc3zdSL
         W5ummRX7mRsFvQMoYoIGe5r3IzpGk/+LceuBLqVh0V1SQou7rXCR5pqEOCsBJMWcIBEd
         3Dz7a6yfIJrlQfIekAGBJybZ1T5+T2OQ+JG0gsRJX3Cr+e5b0WupxKh2CFoWY6kPTkEV
         Wy26Yztxs58cajx4gH376bVC7JM61gGlu/iNvp4EormSNOv0gaPiKB+0KGtNgYNnsH6C
         hRQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=xMNYjYZWLpf7m1COoaNSNiw8vw9MswDKLqZGSLeZQig=;
        b=J5kA/lt9GVYd2us80vhv8OeHCCEozq1U6NINBB0JoC/jml0B8L0t0OmzxXQGSdIMxb
         LWU8V44n7YyYFLC2zB58LjsECS7hDidXyBBpf+uSMglezs6yW8v3JmjFavDgBwNzciHC
         CJhnqUbESMRFvhvl/mQoErZwfUToOv428fFY1I8Whr7SLhwgUE1wSRXnTHRznwpQ9gYu
         XF6w0WyWsEfGprfaYpKV+IQhS57NsNr8SMNZPWGlJuAFJqVF0GBztrlj8KCTvuRMYHXx
         n8yJiqKPGNuXiV9Ft5O7QCJmLqBYCpz0I6Q+XDtBPg3AN82+vkJ9/zer35pnwEHxWySC
         hG9Q==
X-Gm-Message-State: AA+aEWYf/po1kjwS+S6Oa+fecZo5Qf2w7wulCnR0sPxljtlnz87TYXkK
        StlyqAz3tZZ/Mix8JYTW1OiD49L14Yk=
X-Google-Smtp-Source: AFSGD/UfWWT7fF1F+jIMeLby+fb62YFlZgUTz6ZAu5DGOnr3znq0kk17iEOWmL2F/dyRqBcjI16abw==
X-Received: by 2002:a81:b54f:: with SMTP id c15mr6181576ywk.274.1542827151195;
        Wed, 21 Nov 2018 11:05:51 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 131sm12377908ywn.88.2018.11.21.11.05.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:05:50 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 2/7] btrfs: make btrfs_destroy_delayed_refs use btrfs_delete_ref_head
Date:   Wed, 21 Nov 2018 14:05:40 -0500
Message-Id: <20181121190545.24798-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181121190545.24798-1-josef@toxicpanda.com>
References: <20181121190545.24798-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Instead of open coding this stuff use the helper instead.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f062fb0487cd..7d02748cf3f6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4215,12 +4215,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 		if (head->must_insert_reserved)
 			pin_bytes = true;
 		btrfs_free_delayed_extent_op(head->extent_op);
-		delayed_refs->num_heads--;
-		if (head->processing == 0)
-			delayed_refs->num_heads_ready--;
-		atomic_dec(&delayed_refs->num_entries);
-		rb_erase_cached(&head->href_node, &delayed_refs->href_root);
-		RB_CLEAR_NODE(&head->href_node);
+		btrfs_delete_ref_head(delayed_refs, head);
 		spin_unlock(&head->lock);
 		spin_unlock(&delayed_refs->lock);
 		mutex_unlock(&head->mutex);
-- 
2.14.3

