Return-Path: <SRS0=f83N=ZT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CBF8C432C3
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Nov 2019 04:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CE47207DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Nov 2019 04:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfK0EoK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 23:44:10 -0500
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48368 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfK0EoK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Nov 2019 23:44:10 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Nov 2019 23:44:09 EST
X-Envelope-Mail-From: zblaxell@waya.furryterror.org
X-Envelope-Mail-From: zblaxell@waya.furryterror.org
Received: from waya.furryterror.org (waya.vpn7.hungrycats.org [10.132.226.63])
        by james.kirk.hungrycats.org (Postfix) with ESMTP id 4CF294F8A7A;
        Tue, 26 Nov 2019 23:37:45 -0500 (EST)
Received: from zblaxell by waya.furryterror.org with local (Exim 4.92)
        (envelope-from <zblaxell@waya.furryterror.org>)
        id 1iZp5E-0003PU-UZ; Tue, 26 Nov 2019 23:37:44 -0500
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs-progs: inspect: increase logical-resolve default buffer size to 64K
Date:   Tue, 26 Nov 2019 22:55:08 -0500
Message-Id: <20191127035509.15011-6-ce3g8jdj@umail.furryterror.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191127035509.15011-1-ce3g8jdj@umail.furryterror.org>
References: <20191127035509.15011-1-ce3g8jdj@umail.furryterror.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Filesystems with nontrivial snapshots or dedupe will easily overflow
a 4K buffer.  Bump the size up to the largest size supported by the
V1 ioctl.

Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
---
 cmds/inspect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds/inspect.c b/cmds/inspect.c
index 81eb8125..c3c41905 100644
--- a/cmds/inspect.c
+++ b/cmds/inspect.c
@@ -151,7 +151,7 @@ static int cmd_inspect_logical_resolve(const struct cmd_struct *cmd,
 	int bytes_left;
 	struct btrfs_ioctl_logical_ino_args loi;
 	struct btrfs_data_container *inodes;
-	u64 size = 4096;
+	u64 size = SZ_64K;
 	char full_path[PATH_MAX];
 	char *path_ptr;
 	DIR *dirstream = NULL;
-- 
2.20.1

