Return-Path: <SRS0=tPet=5Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD405C2BA1A
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Apr 2020 10:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1890208E4
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Apr 2020 10:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586342158;
	bh=8QVO30BHDBcabGdLbwR5eUB3BhOHkhInXscyDaLbJgA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Z8rga8898UNhMW20i4dSMnwDeBPLuGHBNazNd9DVqlhKKw4+kxzcu/brZ1QOketHh
	 Auky/LByjZHruaBziDzTw12wD3sfnIs1oBL0UfK+dYGFmP51Papl5X1GdK+VwYUFDY
	 3gk43wro5LLNVZnUuE/h7ZLhPjlfoNHFhHxmWmaU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgDHKf6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 06:35:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgDHKf6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Apr 2020 06:35:58 -0400
Received: from debian6.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D135020753;
        Wed,  8 Apr 2020 10:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586342157;
        bh=8QVO30BHDBcabGdLbwR5eUB3BhOHkhInXscyDaLbJgA=;
        h=From:To:Cc:Subject:Date:From;
        b=Z2na5MJXqpI4DKs9VTBs1gY9P8tIJ35TdPmku/9D0zW8RIi/xuIh5+nuIpmQSQtTB
         4xDYScXoZSRChS6N1NP+NveywC0MKxpo8s7mw/IGwG3TANRJDknxwVz22uzrNlRIVp
         2pY0VoRRb91aNkWUxzraDkgNjzBI8uoAs4cr1ugY=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 1/4] fsx: add missing file size update on zero range operations
Date:   Wed,  8 Apr 2020 11:35:52 +0100
Message-Id: <20200408103552.11339-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When a zero range operation increases the size of the test file we were
not updating the global variable 'file_size' which tracks the current
size of the test file. This variable is used to for example compute the
offset for a source range of clone, dedupe and copy file range operations.

So just fix it by updating the 'file_size' global variable whenever a zero
range operation does not use the keep size flag and its range goes beyond
the current file size.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 ltp/fsx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 9d598a4f..fa383c94 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -1212,6 +1212,8 @@ do_zero_range(unsigned offset, unsigned length, int keep_size)
 	}
 
 	end_offset = keep_size ? 0 : offset + length;
+	if (!keep_size && end_offset > file_size)
+		file_size = end_offset;
 
 	if (end_offset > biggest) {
 		biggest = end_offset;
-- 
2.11.0

