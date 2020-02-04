Return-Path: <SRS0=SPQA=3Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D2CAC35247
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Feb 2020 16:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F47520730
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Feb 2020 16:20:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="G0wofboj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgBDQUJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 11:20:09 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33688 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbgBDQUI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Feb 2020 11:20:08 -0500
Received: by mail-qt1-f196.google.com with SMTP id d5so14783149qto.0
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Feb 2020 08:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Blx3eAMp+gzcUocGHJIc4wKHOGiqJuOcxYr+ABuflNA=;
        b=G0wofbojJwumNCUMwir8L9IVZiFqUdMSUb+7fOVpuGrd1WJuIif29DA27bRuhB7UEE
         ceXdgWKB1Gb8N0YrjdpL6rqNtEXUdzZwYXXNZhnfekM7bP8TdxtmkgzJ+Q3JBtaYyZRd
         8LASRJXgIAkMhEGhOMLuNT9vOT2RNDaIKQpBpUrgkjoR3EtLsI6COvgyNcZapmEiU6qW
         ZWpjw9IytBHxkaqLDov1e3NJqCU+YOg2bCOgeqYL8ed8fbcQCCP4RO93hOSsbdlpyveF
         pm217qMKLiho7UuoReQ++rnpOBTtsTk4EScwA5e/TwKChXZsWkcVcNgjp3WoZ3HqmpJd
         K4ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Blx3eAMp+gzcUocGHJIc4wKHOGiqJuOcxYr+ABuflNA=;
        b=uAZv6JPXhilut7byiTxddGK8IcWwvPGtbFdkWo20YbOMNInCQWe+zCMV2tIQQlbOu8
         M0RpqrjsgUBRz+Dqv/iEd1zVmafM9KXdAH0knNRO4y9sc9KFFkboEgULRw8dSwDjKjYU
         5b6KO/cfKQQD8L1NMNBBAt0ER7dlJyPZX3IeTY4tZzI0NQvdYHLyqFftHsZGGe7EpGJG
         p8UF5aFMM+/F5cl6yarBdbdHdNbzqcr6sdqmX1tCs/BBlDn/hRioV9tSkcx0KTioceKl
         0nuBnnB5bF3BtgRCQkRqv5m3J1EduZse51Nucg3DsZ9tzzaDLS9L2smrSmfG30jwJWpN
         hbIw==
X-Gm-Message-State: APjAAAVGttGSjD3P9NkTCurfdIbZWqrRLwZdUzMlZQkfx1m8CUNmda0s
        iIe7dU12aFTjqvc+Kqt/zzLUeGlj7eN48w==
X-Google-Smtp-Source: APXvYqxOEUFZEsDjGSOKxmZ8uzxeM2eLNth0ZO+ZvMq35wfTocsSEPxv5xfKEzfRyfk9wIglY/jQgw==
X-Received: by 2002:ac8:4b50:: with SMTP id e16mr27995537qts.89.1580833207694;
        Tue, 04 Feb 2020 08:20:07 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id l6sm12087647qti.10.2020.02.04.08.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 08:20:06 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 08/23] btrfs: call btrfs_try_granting_tickets when reserving space
Date:   Tue,  4 Feb 2020 11:19:36 -0500
Message-Id: <20200204161951.764935-9-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200204161951.764935-1-josef@toxicpanda.com>
References: <20200204161951.764935-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If we have compression on we could free up more space than we reserved,
and thus be able to make a space reservation.  Add the call for this
scenario.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Tested-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/block-group.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 616d0dd69394..aca4510f1f2d 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2899,6 +2899,13 @@ int btrfs_add_reserved_bytes(struct btrfs_block_group *cache,
 						      space_info, -ram_bytes);
 		if (delalloc)
 			cache->delalloc_bytes += num_bytes;
+
+		/*
+		 * Compression can use less space than we reserved, so wake
+		 * tickets if that happens.
+		 */
+		if (num_bytes < ram_bytes)
+			btrfs_try_granting_tickets(cache->fs_info, space_info);
 	}
 	spin_unlock(&cache->lock);
 	spin_unlock(&space_info->lock);
-- 
2.24.1

