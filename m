Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 809D4C71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B3482087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="BWZukbTM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B3482087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbeJMDHK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:10 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35780 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbeJMDHK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:10 -0400
Received: by mail-qt1-f194.google.com with SMTP id d21-v6so2674742qtq.2
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=+yz3n6lATRx6h1PNpaQrCmKxcZVsI4n1UZsZzxSFbKc=;
        b=BWZukbTMFhXPPTpyFXkRBYarxYItqcNa36ERumq0ge1fDZoUlBxkm01OTCay9SW969
         o7MUjGMgOW7J2EW3FkDDkUXB3IrK61JtiGG+NXms9qEPIv04Hx+OXhXiesJZT5lFtAai
         lAJi8ynOx5etN2jlpeNt/7rYANIdIPeeGBo0ykivI3SM0lmnjLTDf3qgudH8s8WppCAS
         LtPMK5GNr4nXjC1rGd19QHD/IMxsI78QtjSJ9VtiLz+1BV2diQLLOaDXYiavEfHBKDpy
         SyhSQg+bgWkri4sXTgt+gos3oKOMaDl5r2YChU5oy1DINp3rGewM7NcOOcUpARjnRM51
         Plbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=+yz3n6lATRx6h1PNpaQrCmKxcZVsI4n1UZsZzxSFbKc=;
        b=RFoT5ynVTwrDQW95UKlN4whyYt3z3oX/Fl5Ztld5mjCrhtVdTyXkayG13hLUJtJL8b
         QWkmHejZxaWbVetvwDOWaNiVsSyli2U9wrhlzuJmN/a1hjvXW0gey/mMPZgcH+YvsB6v
         J3b/56yXiYMuzTckfJuCvNy9nxUnMJjy6WWL06ybArzQFOZwHOetSwLYVE7SywMPA6wG
         PyG7S8dQ1gjYXqc5jh++txKGfujVkq9YaBPuDZrKT3BaAK+wL90YUVJURlTexoqX6n+L
         9+CmpCvSnLqJZ6wpuGlBCIZ9T5/krCiBN3TSf/Lp5HCVL6pUDqyQBgbhZEJy2vaCAHbq
         E3Ag==
X-Gm-Message-State: ABuFfohURAXhRYOB/vjUt0QYZtHj+gaQj5tLDNptAbNW8g6dfbmJkr60
        +rToJh1AG7idWsHB2hwj9ee7YTaANRw=
X-Google-Smtp-Source: ACcGV60Up3Gcj3ldfz+k1VoUHvYlgzZgyiOvC7Uu7AU5uZtK1dCUVB1fKhcc+TgM0Fq7P2NUg2RF5w==
X-Received: by 2002:aed:3eac:: with SMTP id n41-v6mr6892468qtf.196.1539372788991;
        Fri, 12 Oct 2018 12:33:08 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id v57-v6sm1347908qtk.51.2018.10.12.12.33.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:08 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 05/42] btrfs: only count ref heads run in __btrfs_run_delayed_refs
Date:   Fri, 12 Oct 2018 15:32:19 -0400
Message-Id: <20181012193256.13735-6-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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

