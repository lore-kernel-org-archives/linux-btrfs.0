Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF15C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 19:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 460C42184D
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 19:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553888131;
	bh=UKDZLimjZ//0SXyz19I+gzyboi6C9DFV6Nn2SHUYQyw=;
	h=From:To:Subject:Date:List-ID:From;
	b=fgC+jXRuLQmHtqpC6swOZmJ2YF+0QU8XcyTn607Z8kuv/nOikMnfoN0vt0UoDp3eq
	 NAmCpoNWkZyDv5tQJOXRjgFoa0CnOuDBPkAQXTVSNIhZafl6BYGhH3WhvqWZYouV4H
	 Jgka8ZzIpiRSDEaZua1+DF/i7LsE75PTAc5bp59Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbfC2Tfa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 15:35:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729380AbfC2Tfa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 15:35:30 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D29A2184D
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 19:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553888129;
        bh=UKDZLimjZ//0SXyz19I+gzyboi6C9DFV6Nn2SHUYQyw=;
        h=From:To:Subject:Date:From;
        b=JD1n/OQf7upVEg7LtbHF/MmR+3/mZossPdmzcbRJLNYRxrfNoznkrzkliiPWxI5rn
         xpJ8Px2kPgDA2gonFPVpIyXQCzqj3ygg01lcBHh3UZe8ZA1EXdNhKF8psqub2riRrp
         mdUh+8pxavFmf1+sQwZPssvhcIq7sSu/lRQUtkts=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: receive, add debug information to write and clone commands
Date:   Fri, 29 Mar 2019 19:35:26 +0000
Message-Id: <20190329193526.21315-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Currently, when operating in a more verbose mode (-vv), the receive command
does not mention any write or clone commands, unlike other commands.

This change adds debug messages for the write and clone operations, that do
not include data but only offsets and lengths, as this is actually very
useful to debug a send stream and I use it frequently.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 cmds-receive.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/cmds-receive.c b/cmds-receive.c
index 3888149a..5d06f286 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -704,6 +704,10 @@ static int process_write(const char *path, const void *data, u64 offset,
 	if (ret < 0)
 		goto out;
 
+	if (g_verbose >= 2)
+		fprintf(stderr, "write %s - offset=%llu length=%llu\n",
+			path, offset, len);
+
 	while (pos < len) {
 		w = pwrite(rctx->write_fd, (char*)data + pos, len - pos,
 				offset + pos);
@@ -808,6 +812,11 @@ static int process_clone(const char *path, u64 offset, u64 len,
 		goto out;
 	}
 
+	if (g_verbose >= 2)
+		fprintf(stderr,
+			"clone %s - source=%s source offset=%llu offset=%llu length=%llu\n",
+			path, clone_path, clone_offset, offset, len);
+
 	clone_args.src_fd = clone_fd;
 	clone_args.src_offset = clone_offset;
 	clone_args.src_length = len;
-- 
2.11.0

