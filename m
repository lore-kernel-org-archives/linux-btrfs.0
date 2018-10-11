Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB934C677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEAB220835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:54:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="xxbRFGkU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEAB220835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbeJLDX3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:23:29 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41907 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbeJLDX3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:23:29 -0400
Received: by mail-qt1-f195.google.com with SMTP id l41-v6so11340767qtl.8
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=+yz3n6lATRx6h1PNpaQrCmKxcZVsI4n1UZsZzxSFbKc=;
        b=xxbRFGkUyKXht8tR2XYFQb/KDSgNVi61b7NNQvgItAylgvO8JbopaYhkmtgiWDvSK8
         cJuDig3BLhK3KQQ5gFRynF/jQY7YEvN4gDkkGXMtyYdo5LfjmVj7uOya7L+F693Nfqsl
         KBlVMfcNkH5n0jBInbMTxxqO+08QocpbX6mHxZe/crvdGxNoPkcHLB0oHydu2w36tlkA
         BoFES1nX9TD/2f3Esw5iQ28CGh4skE6V9pugLOy1daLK9wjbDu5vklOND6VMYSFp7vfM
         2r+4uxStM6OnNyE/i3NCzcq3PNiovzYE5gbNVGxWk4YYib8HS75BsatUA75XQYiwkTrT
         JkfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=+yz3n6lATRx6h1PNpaQrCmKxcZVsI4n1UZsZzxSFbKc=;
        b=MRV2B8mPnP9Em5IjQlxVFEHlj1OgukMQaCSqQgY6wJdsqyP7Zj0vpSQj/zWSGydciz
         SdxhPFkf2dF6ZbMwNjI2ipnqpVMtxRLt7Kpd7JZLmvriAE4kKz/n/2oiRglHwTSnP+qx
         jklFVxzi7ztt0A31LGSrBaAd8p+H/V4lThtPWyBIkukMuNOtXOB0KDTBL7/9uNWnYqYe
         p2ddkDlSlNNNzVWw06qAjIBpJW+u3KB2L1Hqr++w20bLvG++xL36HznZa1/kipP2P71S
         lb0euTAOsDLUiydICiL8ub11uUxAH8lYcj5ZQ/cCxI32+6xvXA3btdZWMHuTZ48DhdR+
         4FBA==
X-Gm-Message-State: ABuFfojA9h60ppfDsJCY01OeDoB59Kbms8mjeGPdZ/nmJLZmz7YtCdIB
        9RqHtchDq9/0AW0gi4RebQn8Lw==
X-Google-Smtp-Source: ACcGV63xRggPBMfZ9q9vvcu69WcVMQOzHnLno6tuKjDOx4aVEgjhbdD3Mn4nX78Y0cimJKn2y1IHkg==
X-Received: by 2002:a0c:be01:: with SMTP id k1-v6mr3064601qvg.226.1539287683088;
        Thu, 11 Oct 2018 12:54:43 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id l18-v6sm16619240qki.83.2018.10.11.12.54.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:54:42 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 05/42] btrfs: only count ref heads run in __btrfs_run_delayed_refs
Date:   Thu, 11 Oct 2018 15:53:54 -0400
Message-Id: <20181011195431.3441-6-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We pick the number of ref's to run based on the number of ref heads, and
only make the decision to stop once we've processed entire ref heads, so
only count the ref heads we've run and bail once we've hit the number of
ref heads we wanted to process.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 98f36dfeccb0..b32bd38390dd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2592,6 +2592,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 				spin_unlock(&delayed_refs->lock);
 				break;
 			}
+			count++;
 
 			/* grab the lock that says we are going to process
 			 * all the refs for this head */
@@ -2605,7 +2606,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			 */
 			if (ret == -EAGAIN) {
 				locked_ref = NULL;
-				count++;
 				continue;
 			}
 		}
@@ -2633,7 +2633,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			unselect_delayed_ref_head(delayed_refs, locked_ref);
 			locked_ref = NULL;
 			cond_resched();
-			count++;
 			continue;
 		}
 
@@ -2651,7 +2650,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 				return ret;
 			}
 			locked_ref = NULL;
-			count++;
 			continue;
 		}
 
@@ -2702,7 +2700,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 		}
 
 		btrfs_put_delayed_ref(ref);
-		count++;
 		cond_resched();
 	}
 
-- 
2.14.3

