Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDED5C6FA90
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Sep 2022 12:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbiIWMGb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 08:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbiIWMET (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2022 08:04:19 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBB77D1F2
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Sep 2022 05:00:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2FBB321A15
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Sep 2022 12:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663934407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KmoUjGJDsDW8gleYy63Kx9L8pehGG8kHHs44UClwEg0=;
        b=rB4ozTcfajrwgW/edOBRi8cbXm3BjdmFfKZUtiZjQpVu7aR5e6P95qMEg7z3GHFgQrelqQ
        2S7b2kBEdkMozI3lhdAMSgAjiNWlVxJaR25QzAkeJxVlcqsb0ev1feEw4wtQxzJ3qGKki9
        TN7ik1f8/I9IDJACDCtYtaLlXe3PmH0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 771C813A00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Sep 2022 12:00:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eEWmD8afLWMqaAAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Sep 2022 12:00:06 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: remove duplicated leakde extent buffer reporst
Date:   Fri, 23 Sep 2022 19:59:45 +0800
Message-Id: <c9de45c3147af14dfe57ce9dc029a3f0b5fd080c.1663934243.git.wqu@suse.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1663934243.git.wqu@suse.com>
References: <cover.1663934243.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
When transaction is aborted halfway, we can have extent buffer leaked,
and in that case, the same leaked extent buffer can be reported for
multiple times:

  ERROR: failed to clear free space cache v2: -1
  extent buffer leak: start 30441472 len 16384
  WARNING: dirty eb leak (aborted trans): start 30441472 len 16384
  extent buffer leak: start 30720000 len 16384
  extent buffer leak: start 30425088 len 16384
  extent buffer leak: start 30425088 len 16384 << Duplicated
  WARNING: dirty eb leak (aborted trans): start 30425088 len 16384

Note that 30425088 line is reported twice (not accounting the "dirty eb
leak" line).

[CAUSE]
When we detected a leaked eb, we call free_extent_buffer_nocache(), but
free_extent_buffer_nocache() can only remove the eb when its reduced
refs is 0.

If the eb has refs 2, it will need two free_extent_buffer_nocache()
calls to remove it from the cache.

[FIX]
Just reset the eb->refs to 1 so that free_extent_buffer_nocache() can
remove it from cache for sure.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/extent_io.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel-shared/extent_io.c b/kernel-shared/extent_io.c
index a34616c9e783..f10acc3595c3 100644
--- a/kernel-shared/extent_io.c
+++ b/kernel-shared/extent_io.c
@@ -81,6 +81,11 @@ void extent_io_tree_cleanup(struct extent_io_tree *tree)
 	while(!list_empty(&tree->lru)) {
 		eb = list_entry(tree->lru.next, struct extent_buffer, lru);
 		if (eb->refs) {
+			/*
+			 * Reset extent buffer refs to 1, so the
+			 * free_extent_buffer_nocache() can free it for sure.
+			 */
+			eb->refs = 1;
 			fprintf(stderr,
 				"extent buffer leak: start %llu len %u\n",
 				(unsigned long long)eb->start, eb->len);
-- 
2.37.3

