Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71B7C6780C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEA8820835
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 19:55:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="bViF86CA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEA8820835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbeJLDYY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 23:24:24 -0400
Received: from mail-qt1-f171.google.com ([209.85.160.171]:41216 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbeJLDYX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 23:24:23 -0400
Received: by mail-qt1-f171.google.com with SMTP id l41-v6so11344407qtl.8
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 12:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=o3aniGDG3zSjx1n1+LpysocBJ3oenkOpLCURB29A0Uc=;
        b=bViF86CAKld+3GCaFGw6VsagrED0khahvoZpu8hkBNPk8rc365CJUf7/4Pwf6VNJrg
         70dqZCAfvvYvY2ioSk33LC507qWuj1b4jWl/DOFzLFWYSSwYTUrojYHY2Sha2AHunY1L
         pNxpUjKADA+lcLl2uM4KFAqWppHym+Yp7qPV0SsIm4IvMdlIk4ndGwCaSMZf1682XQc5
         nQo9UirqLK3fYeQj4i4eqkryz+V+8xy2mx1h1O3DcHglture3YgGc7EqJ2L3MvuI057s
         dRX0XzIqEVDWhUKQiELguyrxtrXXnMkx3f1jKbtlrUPy+b+Km6ftmEjWjp3V7n4WbQWT
         Rkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=o3aniGDG3zSjx1n1+LpysocBJ3oenkOpLCURB29A0Uc=;
        b=akstax8A/buwRp12/t+1N8ZTMRAoX54CpnZ9bVJS47G1xXVA9bXJ2GtaENZ3W3WwrT
         y9ijvauLrR1XTiTsW3UzovHYjTfw0STy9VpO47GU8JdTIF74zB7YUrj8LcE4aOou9Yfm
         E2DwmKhAE5pnw+8P8X6aNrP9lH4sDm75s6w395ns+GlJohHXzi5U6I7NOK4FBOYENNCM
         PgeQzKh4s2Y+z8WF6rDMpV0TGtcN+n+50v5MU9s6piWkPKmMEgtHu218Lam5xYOtnEtq
         NJp8xsr9AMRa56uFpVYSl37i1nmITwgCmEdZMSPOrbKVUpsw5v5jdh5RPxoItrY+4iDK
         E26w==
X-Gm-Message-State: ABuFfojuhi7U7oEiB7blbU4iTOZsLs2Ptuf2PaJSmI3ONrP1dBjPlBWS
        v4cSo4ICLMwsFngdHCT7yPA0Rw==
X-Google-Smtp-Source: ACcGV62O16I73fvmLDVlSN1JT8ifVX0h1nfSA9JZYVeE0e35kNtfDbtFNMlETRJ2WHTCrhPXBW+RdQ==
X-Received: by 2002:ac8:7697:: with SMTP id g23-v6mr3035221qtr.117.1539287737376;
        Thu, 11 Oct 2018 12:55:37 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id y20-v6sm13867785qkb.46.2018.10.11.12.55.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 12:55:36 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 34/42] btrfs: wait on ordered extents on abort cleanup
Date:   Thu, 11 Oct 2018 15:54:23 -0400
Message-Id: <20181011195431.3441-35-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181011195431.3441-1-josef@toxicpanda.com>
References: <20181011195431.3441-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If we flip read-only before we initiate writeback on all dirty pages for
ordered extents we've created then we'll have ordered extents left over
on umount, which results in all sorts of bad things happening.  Fix this
by making sure we wait on ordered extents if we have to do the aborted
transaction cleanup stuff.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/disk-io.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 54fbdc944a3f..51b2a5bf25e5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4188,6 +4188,14 @@ static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
 		spin_lock(&fs_info->ordered_root_lock);
 	}
 	spin_unlock(&fs_info->ordered_root_lock);
+
+	/*
+	 * We need this here because if we've been flipped read-only we won't
+	 * get sync() from the umount, so we need to make sure any ordered
+	 * extents that haven't had their dirty pages IO start writeout yet
+	 * actually get run and error out properly.
+	 */
+	btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
 }
 
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
-- 
2.14.3

