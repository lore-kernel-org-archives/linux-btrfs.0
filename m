Return-Path: <SRS0=ik6r=2A=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91697C43603
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Dec 2019 07:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 694652073B
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Dec 2019 07:14:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=fau.de header.i=@fau.de header.b="ZsYJR4+Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfLJHOL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Dec 2019 02:14:11 -0500
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:56211 "EHLO
        mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727347AbfLJHOL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Dec 2019 02:14:11 -0500
Received: from mx-rz-smart.rrze.uni-erlangen.de (mx-rz-smart.rrze.uni-erlangen.de [IPv6:2001:638:a000:1025::1e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mx-rz-1.rrze.uni-erlangen.de (Postfix) with ESMTPS id 47XBBT2RxQz8tk0;
        Tue, 10 Dec 2019 08:14:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fau.de; s=fau-2013;
        t=1575962049; bh=QweQbOSJileAMKUFJQuTNlDwqHXJ0pgzAvz586Nr1QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From:To:CC:
         Subject;
        b=ZsYJR4+YBc5HAqcJ7VFh4x8j8Os+PJyLDG0+aaJ2b7IPtcrOvzcgLcPEs53CAmxy8
         GvxdOOQUjcULY1izVUzB/x/jADm00G8CGO0QC7I6LEP6tjASWQFVMdg9knUcyWT79C
         94oma2Ew3/Dah+mPFNylPbnY/ZYutEfyKLIyj9Vu7O7RPs7X31MIWAZuQmeucTEMHC
         fDwkt9Na0LpVzrBjsrEHpYY0TYtpdS8VrV0cn4Y+KAj5sEw0PeQBWQgxQ9T1BwNVj8
         eKWcu1LXq503Z9sbAtKFOmjZmd2MkdlxuYwv1KsXnzfpag9s8HREzjs5l97dXDzfIn
         qPUnD5qmfRV0w==
X-Virus-Scanned: amavisd-new at boeck4.rrze.uni-erlangen.de (RRZE)
X-RRZE-Flag: Not-Spam
X-RRZE-Submit-IP: 131.188.22.146
Received: from localhost.localdomain (firewall.henke.stw.uni-erlangen.de [131.188.22.146])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: U2FsdGVkX18r2981Z7ukXRMkI10nOmLAe7dg0v+W9+U=)
        by smtp-auth.uni-erlangen.de (Postfix) with ESMTPSA id 47XBBQ6hYJz8v8y;
        Tue, 10 Dec 2019 08:14:06 +0100 (CET)
From:   Sebastian <sebastian.scherbel@fau.de>
To:     dsterba@suse.com
Cc:     josef@toxicpanda.com, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@i4.cs.fau.de,
        Sebastian Scherbel <sebastian.scherbel@fau.de>,
        Ole Wiedemann <ole.wiedemann@fau.de>
Subject: [PATCH 3/5] fs_btrfs_ref-verify: code cleanup
Date:   Tue, 10 Dec 2019 08:13:55 +0100
Message-Id: <20191210071357.5323-4-sebastian.scherbel@fau.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191210071357.5323-1-sebastian.scherbel@fau.de>
References: <20191210071357.5323-1-sebastian.scherbel@fau.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Sebastian Scherbel <sebastian.scherbel@fau.de>

This patch changes several instances in ref-verify where the coding style
is not in line with the Linux kernel guidelines to improve readability.

1. inline keyword moved between storage class and type
2. missing space before the open parenthesis added

Signed-off-by: Sebastian Scherbel <sebastian.scherbel@fau.de>
Co-developed-by: Ole Wiedemann <ole.wiedemann@fau.de>
Signed-off-by: Ole Wiedemann <ole.wiedemann@fau.de>
---
 fs/btrfs/ref-verify.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ref-verify.c b/fs/btrfs/ref-verify.c
index b57f3618e58e..be735e774d3a 100644
--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -218,11 +218,11 @@ static void __print_stack_trace(struct btrfs_fs_info *fs_info,
 	stack_trace_print(ra->trace, ra->trace_len, 2);
 }
 #else
-static void inline __save_stack_trace(struct ref_action *ra)
+static inline void __save_stack_trace(struct ref_action *ra)
 {
 }
 
-static void inline __print_stack_trace(struct btrfs_fs_info *fs_info,
+static inline void __print_stack_trace(struct btrfs_fs_info *fs_info,
 				       struct ref_action *ra)
 {
 	btrfs_err(fs_info, "  ref-verify: no stacktrace support");
@@ -242,7 +242,7 @@ static void free_block_entry(struct block_entry *be)
 		kfree(re);
 	}
 
-	while((n = rb_first(&be->refs))) {
+	while ((n = rb_first(&be->refs))) {
 		ref = rb_entry(n, struct ref_entry, node);
 		rb_erase(&ref->node, &be->refs);
 		kfree(ref);
-- 
2.20.1

