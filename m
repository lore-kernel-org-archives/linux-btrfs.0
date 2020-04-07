Return-Path: <SRS0=vrAS=5X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FDAC2BB1D
	for <linux-btrfs@archiver.kernel.org>; Tue,  7 Apr 2020 10:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A50CC20644
	for <linux-btrfs@archiver.kernel.org>; Tue,  7 Apr 2020 10:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586255941;
	bh=aAeqOZ2i4NH1NOh+evabn+pf6BwZ5V7SBjrEnHuFZk0=;
	h=From:To:Subject:Date:List-ID:From;
	b=H+sEh5x06T0SMywp/JZqM6xV5/HU0r3JZUaS/pZjNC08IGCu5J4I97SXK0KQH1/QM
	 4g4HlPcMSIucFOYPDf1GRd9pqnxMj1D5Gb6A2GUSZp9E21FINhjCvjia36+m1gC8Nz
	 BzmuJ15tpNmCgvXbHzgTE1ItBJcy/w5Etz5pCqZU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgDGKjB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 06:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgDGKjA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Apr 2020 06:39:00 -0400
Received: from debian6.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BED120644
        for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2020 10:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255940;
        bh=aAeqOZ2i4NH1NOh+evabn+pf6BwZ5V7SBjrEnHuFZk0=;
        h=From:To:Subject:Date:From;
        b=j27vFAdkHiWwBHmstsJpQBePebjB9/Wp+Xshp5zpkxHW+nZupckwhkUCO4HFRRx9Y
         XlWu3OHDygvxDd6V5hRNmkC+XKRaFviGaqdbJjel/PLskEz0jdCQ5TQjb9MHHMtR0W
         tm7nKXVTsIdaD/l7F/EZMUkB24121Q8fso65OLAA=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: remove pointless assertion on reclaim_size counter
Date:   Tue,  7 Apr 2020 11:38:58 +0100
Message-Id: <20200407103858.31029-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The reclaim_size counter of a space_info object is unsigned. So its value
can never be negative, it's pointless to have an assertion that checks
its value is >= 0, therefore remove it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/space-info.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index ff17a4420358..88d7dea215ff 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -1198,7 +1198,6 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 	 * the list and we will do our own flushing further down.
 	 */
 	if (ret && flush != BTRFS_RESERVE_NO_FLUSH) {
-		ASSERT(space_info->reclaim_size >= 0);
 		ticket.bytes = orig_bytes;
 		ticket.error = 0;
 		space_info->reclaim_size += ticket.bytes;
-- 
2.11.0

