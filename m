Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162C5C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8C5D215F0
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 11:18:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="bO5G6ngR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8C5D215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbeI1Rlw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 13:41:52 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36762 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbeI1Rlw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 13:41:52 -0400
Received: by mail-qt1-f196.google.com with SMTP id e26-v6so6166408qtq.3
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2018 04:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=+yz3n6lATRx6h1PNpaQrCmKxcZVsI4n1UZsZzxSFbKc=;
        b=bO5G6ngR++XHgU44+SKOdWJukr5NSQEZcLXI+x7Nml4y9xTrtAmfH1CpY+A5v3WOlv
         0Lno1jdwYApAMdSYktk5a/ZLKzJ0JY8bkuzlEOchT24M26wZK6tVNLPbG2ZM+ycZJhvJ
         /BYHkieJpfKXZhqZ2ER93utgIRnbO7k+waFjw8x16IYSM5UIMIrVsUhb3DOSNC6kZSeH
         npfbELIyba6uOTvjEmKyNr0lTv40M/x4TP0S6f58hMwYBGU0lZu8dcK2Q6ttzS4zSZRR
         ZsqmkfiZ/0nmTiBIiFInFt6T6eFID330lF5y25Mr/QJJnyfkOX9nLdmstpvD9CsuyyOS
         +3LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=+yz3n6lATRx6h1PNpaQrCmKxcZVsI4n1UZsZzxSFbKc=;
        b=C+Fdw8fS5OMaLAooh82atpnBDIAfL25m6gbAFaNx4TMqh53fYI9ewrXoRZ4Fu1tKlW
         sB066TLBMJW2YYMuLqy3e0CduHhhWgjiNbW3JWPiE5aZp7SfTP57DL4a9u9GLQ4KNnHf
         g17gmVtFe4p+4VwT6x0ZTHQHKKHg0lMxh5Ro4ZtnFhpSL8dekfbES/aae93OtAWc5lxo
         wt7Sv8peEAbyDrKRt6EGPy3EzF0oroo/Kteth9mq+aQD61G920GdF8x/XjrSsxp2RFwo
         dXsORBQlAfCuwk92vCBhAF8EBfz1NpXva9CoTHMPAzB7PWY+4jzwhtZRJdAJXHOaqYZy
         mgyQ==
X-Gm-Message-State: ABuFfoiEcgvvJDnF4jsDGVtzzevj5dF+ptnlADgpCQ2kWwzdd8Y61QHY
        apapHe0+9GVRPNsUR9YpmYdsCQ==
X-Google-Smtp-Source: ACcGV62FF7eZXKYHoRGNG7KrwXbNds6BUJlkfW1nPGZpSiRV3ubFsb0XXINuQg0rNR3BxkZl3Swkeg==
X-Received: by 2002:aed:3c07:: with SMTP id t7-v6mr8950304qte.192.1538133514251;
        Fri, 28 Sep 2018 04:18:34 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id f184-v6sm2610593qkc.23.2018.09.28.04.18.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:18:33 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 05/42] btrfs: only count ref heads run in __btrfs_run_delayed_refs
Date:   Fri, 28 Sep 2018 07:17:44 -0400
Message-Id: <20180928111821.24376-6-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20180928111821.24376-1-josef@toxicpanda.com>
References: <20180928111821.24376-1-josef@toxicpanda.com>
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

