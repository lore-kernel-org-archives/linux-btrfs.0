Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88900C43334
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Jul 2022 07:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiGEHiW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 03:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiGEHiP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jul 2022 03:38:15 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4877813D05
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Jul 2022 00:38:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 07BC1224C4
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Jul 2022 07:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657006692; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4K3OOKL3xPcmTQ8M3SZS2NHCdqXLzRWaV7h5dGOjVyU=;
        b=CX9p1XwwkmIrC3BIVP+vK0Q55OXblKLS1SFGMii8ax8pPKdEw/AvwlOuD93FTOHjWTUrsM
        PQFfdhz0Qxt13SWQia5e6werDhytZ7Kqh6SH1UsddKJQz+i5b2o1YYmphI+gV9Ff2mVRhL
        GAeBt7k1YjXJZR3huyhDacKXt5drAvs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 57BF21339A
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Jul 2022 07:38:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yPE8CWPqw2JTOwAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jul 2022 07:38:11 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/8] btrfs-progs: print-tree: support btrfs_super_block::reserved_bytes
Date:   Tue,  5 Jul 2022 15:37:43 +0800
Message-Id: <0cbdab998ab2a6d42ab4a9763f432ef381ed2a57.1657006141.git.wqu@suse.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657006141.git.wqu@suse.com>
References: <cover.1657006141.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This only needs two things:

- Add readable flags for EXTRA_SUPER_RESERVED flag

- Add optional output for reserved_bytes

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 kernel-shared/print-tree.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
index db486553f448..918ebe02144a 100644
--- a/kernel-shared/print-tree.c
+++ b/kernel-shared/print-tree.c
@@ -1668,6 +1668,7 @@ struct readable_flag_entry {
 static struct readable_flag_entry compat_ro_flags_array[] = {
 	DEF_COMPAT_RO_FLAG_ENTRY(FREE_SPACE_TREE),
 	DEF_COMPAT_RO_FLAG_ENTRY(FREE_SPACE_TREE_VALID),
+	DEF_COMPAT_RO_FLAG_ENTRY(EXTRA_SUPER_RESERVED),
 };
 static const int compat_ro_flags_num = sizeof(compat_ro_flags_array) /
 				       sizeof(struct readable_flag_entry);
@@ -2051,6 +2052,11 @@ void btrfs_print_superblock(struct btrfs_super_block *sb, int full)
 	printf("block_group_root_level\t%llu\n",
 	       (unsigned long long)btrfs_super_block_group_root_level(sb));
 
+	if (btrfs_super_compat_ro_flags(sb) &
+	    BTRFS_FEATURE_COMPAT_RO_EXTRA_SUPER_RESERVED)
+		printf("reserved_bytes\t\t%u\n",
+			btrfs_super_reserved_bytes(sb));
+
 	uuid_unparse(sb->dev_item.uuid, buf);
 	printf("dev_item.uuid\t\t%s\n", buf);
 
-- 
2.36.1

