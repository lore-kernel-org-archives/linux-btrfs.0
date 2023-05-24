Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D193BC77B7A
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 May 2023 07:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240003AbjEXHl6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 May 2023 03:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239996AbjEXHl4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2023 03:41:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C8990
        for <linux-btrfs@vger.kernel.org>; Wed, 24 May 2023 00:41:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AC7221F750
        for <linux-btrfs@vger.kernel.org>; Wed, 24 May 2023 07:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1684914113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TwCuV9K7Q5EmcHwKTeEzeULyQ/1jtaO4uobNHQ/IGA4=;
        b=iqe2oG8+D4bug0OI9oIlXrR5OoNJgXMhvHBQkOKf3GD3dQIPvaHg/N1KliyeSSY32P6872
        WU4JDBdiECveInO6e6+V86YK7EJ6NzbALzbStfYZrOQSo1RPuLhUvUPelbVm3uObi/8JY2
        McBCI40O18qYSvGqpyyVMVcoRUZcnHQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0E4FA13425
        for <linux-btrfs@vger.kernel.org>; Wed, 24 May 2023 07:41:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MJSuMsC/bWSiRQAAMHmgww
        (envelope-from <wqu@suse.com>)
        for <linux-btrfs@vger.kernel.org>; Wed, 24 May 2023 07:41:52 +0000
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 5/7] btrfs-progs: tune: implement resume support for half deleted old csums
Date:   Wed, 24 May 2023 15:41:28 +0800
Message-Id: <e6ba13630eedc0b8a893520841342190a7297843.1684913599.git.wqu@suse.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1684913599.git.wqu@suse.com>
References: <cover.1684913599.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If the csum conversion is interrupted when old csums are being deleted,
we should resume by continue deleting the old csums.

The function delete_old_data_csums() can handle half deleted cases
already.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tune/change-csum.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tune/change-csum.c b/tune/change-csum.c
index aef3b05a0d9d..2ec2d6cc5271 100644
--- a/tune/change-csum.c
+++ b/tune/change-csum.c
@@ -876,6 +876,15 @@ static int resume_data_csum_change(struct btrfs_fs_info *fs_info,
 		goto new_data_csums;
 	}
 
+	/*
+	 * Both old and new csum exist, and old csum is a subset of the new ones.
+	 *
+	 * This means we're deleting the old csums.
+	 */
+	if (old_csum_found && new_csum_found && new_csum_first <= old_csum_first &&
+	    new_csum_last >= old_csum_last)
+		goto delete_old;
+
 	/* Other cases are not yet supported. */
 	return -EOPNOTSUPP;
 
@@ -886,6 +895,7 @@ new_data_csums:
 		error("failed to generate new data csums: %m");
 		return ret;
 	}
+delete_old:
 	ret = delete_old_data_csums(fs_info);
 	if (ret < 0)
 		return ret;
-- 
2.40.1

