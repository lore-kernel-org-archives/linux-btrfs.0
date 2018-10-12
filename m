Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FCBC71123
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F10662087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:34:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="H3FabDKZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F10662087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbeJMDIC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:08:02 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40137 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbeJMDIB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:08:01 -0400
Received: by mail-qt1-f195.google.com with SMTP id b4-v6so15038146qtc.7
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=cvSqJmOxERWLztXjenJ/CRRumlDa3ZymappVew1ga8M=;
        b=H3FabDKZ7+9haDuK1v7H4BWbbHIWygwqdJADpInWsOKs1F17gRiIQW9SvI4xsOuOtR
         z3Pgpe6jBGR3wch19p9P6FgldZjpDggYyw9K/p1Mk9tXqX64zojh14dCl0BqDszG0AM6
         TJCU16aVxfGcHwjdBRQ7biWLK2s++TOGUkwqeZ8rb/YDlCNJNLA1WYgSEmtrh3OBJgPN
         bFubkolI0OuOdIwrgYrRf+hesVNUeIJthVB1FVQLkYJwrxg3o9hTyAtUw8LJK1KSKsDP
         pECrJnwzNy+X0Flurq7jDlDxqdEQ+C2I30sbNLlPGG+0K+DZEABGjp/OC2t6aWMjlNw0
         l2/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=cvSqJmOxERWLztXjenJ/CRRumlDa3ZymappVew1ga8M=;
        b=DusydO3F4LVXrEU39Zth48icKV81izL3IzsOvJBhJC+v7gSccK/YR4PtKFPYlNIPmS
         phYjD9SUO4tHRe2rEHMBlLx/m+j5QcJO3lEZ2F11Hnhv27shJA5J6ajE5fQ40ah8AOS8
         BDnikcbfXUMpPAo2fwk5fSZ70dLnFaJ7vy086o5Vom4cGi+pV3mb82UbnJmTan7QM+gW
         IpsavwLOluvQLe2Y3jVNCYEPvRhGkGofxFhR27TosXaKXi79gLs7iy0Rki7Jg8ffzPny
         CJYoWXzlP9buTGm1ZsqBCewvT8NkDoFqy6HY4Diiy9ohn4z7C3r3sHG3s1NuC3msMc7m
         EXOg==
X-Gm-Message-State: ABuFfojGRIfOMYwmXsqzvqB0ySY1h312pQkJ1YcXhn2RCahSH9wx2/9I
        pyRN9Rs6IuXh8K/RuJ8wnoUINLNaCWk=
X-Google-Smtp-Source: ACcGV60fTOPwEGE6nMGiQxE5aKG8MqtczbMeNmMOsnSOFVlmjCSRm0AzchGhppvsCpJGQfWEZ9f3MQ==
X-Received: by 2002:a0c:92f3:: with SMTP id c48mr7198912qvc.39.1539372840409;
        Fri, 12 Oct 2018 12:34:00 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id g127-v6sm942810qke.59.2018.10.12.12.33.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:59 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 27/42] btrfs: make btrfs_destroy_delayed_refs use btrfs_delete_ref_head
Date:   Fri, 12 Oct 2018 15:32:41 -0400
Message-Id: <20181012193256.13735-28-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
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

