Return-Path: <SRS0=3GAk=OX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8345C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 19:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6D1E2080F
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 19:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544817022;
	bh=ctV5TY61Ai2F1w0R0ImuJg9axVRoYYjyc0bqNL2rNtc=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sPXCQhPW5ZjANdN59ektJKMlLE020fyYUBLMtrcoaH/lSnnDUwfmZJCWEsruLDtAX
	 Gj8zsIyL11tuMrnE+KwcZoBvMJdXYw0uCvfm7I62fGN6scOhVph/oLpQmntcjFpTZC
	 xzKyrD7RKNl/7mmCu0LerXMbCIUgyL3ZVdZSLrsk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730566AbeLNTuU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Dec 2018 14:50:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:52796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730123AbeLNTuU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Dec 2018 14:50:20 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A03122080F
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Dec 2018 19:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544817021;
        bh=ctV5TY61Ai2F1w0R0ImuJg9axVRoYYjyc0bqNL2rNtc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=V8UspAV7/63jO5JLI2l5hWJpxwNPEnQDbPUmZh6vN0lwFwhZH2FeHAY1RXMe4jN4L
         HLgmAHzJhBinbTPw0uxnWmpsYSlqGN1zXmRDgUZKpTPXkOpM3NYaXYgMUjPTlZUCS7
         o9Hh8doNQaUwJYab2eJMpFEKiyWv3jNEADKXEcT8=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: do not overwrite scrub error with fault error in scrub ioctl
Date:   Fri, 14 Dec 2018 19:50:17 +0000
Message-Id: <20181214195017.17822-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181214194459.21691-1-fdmanana@kernel.org>
References: <20181214194459.21691-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

If scrub returned an error and then the copy_to_user() call did not
succeed, we would overwrite the error returned by scrub with -EFAULT.
Fix that by removing the call to copy_to_user() as there is no need
to do it at all.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Leave to copy_to_user() call since progress needs to be reported back
    to user space.

 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3a27efa2b955..4c05d9c4fe3d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4301,7 +4301,7 @@ static long btrfs_ioctl_scrub(struct file *file, void __user *arg)
 			      &sa->progress, sa->flags & BTRFS_SCRUB_READONLY,
 			      0);
 
-	if (copy_to_user(arg, sa, sizeof(*sa)))
+	if (ret == 0 && copy_to_user(arg, sa, sizeof(*sa)))
 		ret = -EFAULT;
 
 	if (!(sa->flags & BTRFS_SCRUB_READONLY))
-- 
2.11.0

