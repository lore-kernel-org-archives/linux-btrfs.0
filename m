Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C960C6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3212A20835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="bakCm/W7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3212A20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbeJLDYL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:11 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45882 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbeJLDYL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:11 -0400
Received: by mail-qt1-f194.google.com with SMTP id e10-v6so11332168qtq.12
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=cvSqJmOxERWLztXjenJ/CRRumlDa3ZymappVew1ga8M=;
        b=bakCm/W7dzitw8SXDNZKH1WgGK+mvuyoB2OWMM4Dh3zT74C5AfJbfpH7LWHSe7rNhM
         RjvAQtqV/xv1WtTad4f7nyeoFksT6J2Iplw9cvE0jjPzuUPkFVhQugvMG7+u2n7G0Uwf
         hG4jFjWqyJRkucNw//U38BFDY0xDXxKl0ODr0Sj7QgXI+KZh8pmVXy1/G8XfzD7yxo1A
         c9GbJnryxxqzKmDXJR9N9U686mrjnsd/10g5I7G/rkKwQK83jleVq4FmpvIQ0jCmzhgQ
         2S1jWbZlpcFv8CPgwUugEztAK2KDEHaXvUCQ6O7jR2O8YIzC8n1YnwdcAdbYSVmh8t1M
         JxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=cvSqJmOxERWLztXjenJ/CRRumlDa3ZymappVew1ga8M=;
        b=BfBZn3tJlzhNhWNbsB1ZgUFIQx9Wa7P8t/0rXatP+/oaLpInwJ+dwoWVPnonY087Fb
         qCYaasLaM2qv4gx34tsaDHo2ad97ccjEBYIEn55m7waVfZUj0E2K/qfTI0MdK9xWM6f7
         vBsEWzQ9AfQ3oJYsh+6AeM0+8LGVnf5+zJbVsEv52o/85+5OWE0M8ohRnZEV+ZOY2PW+
         awHUKf71Ny7UPHsZiqXVrJfFYUO5AwyhIHSKltdymSgjERPUHyD9YZW4jYTZEXQLzM0t
         g6lithQStaSeyJ0jdi1ntKADj9vD3A8x3XScDtw/ICCJx2UudqOVvcuFKFM5wsXOUfcI
         rHPA==
X-Gm-Message-State: ABuFfohikjnN4ucJuyfil/LLtKRKIxPz9Nw0QRmHFywYJr+gy+NP0JBo
        x9ZO3VpwXyUekemu0W4FfTytaA==
X-Google-Smtp-Source: ACcGV60zGcToZZT86dT2a/zd2D/e7SbNSZNMKqHOPa8Ll82aXO+c7IsIeS4VyR+N2MYXNrUGk1MKoQ==
X-Received: by 2002:a0c:9925:: with SMTP id h34-v6mr3089852qvd.81.1539287724802;
        Thu, 11 Oct 2018 12:55:24 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id y28-v6sm9484497qtj.9.2018.10.11.12.55.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:23 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 27/42] btrfs: make btrfs_destroy_delayed_refs use btrfs_delete_ref_head
Date:   Thu, 11 Oct 2018 15:54:16 -0400
Message-Id: <20181011195431.3441-28-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
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
index 121ab180a78a..fe1f229320ef 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4232,12 +4232,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 		if (head->must_insert_reserved)
 			pin_bytes = true;
 		btrfs_free_delayed_extent_op(head->extent_op);
-		delayed_refs->num_heads--;
-		if (head->processing == 0)
-			delayed_refs->num_heads_ready--;
-		atomic_dec(&delayed_refs->num_entries);
-		rb_erase(&head->href_node, &delayed_refs->href_root);
-		RB_CLEAR_NODE(&head->href_node);
+		btrfs_delete_ref_head(delayed_refs, head);
 		spin_unlock(&head->lock);
 		spin_unlock(&delayed_refs->lock);
 		mutex_unlock(&head->mutex);
-- 
2.14.3

