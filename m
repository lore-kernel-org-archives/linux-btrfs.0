Return-Path: <SRS0=h89n=3F=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35CF6C33CB1
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 Jan 2020 11:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0811C2073A
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 Jan 2020 11:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579174165;
	bh=NT2d5CX4L46jJCW5koSPA0DKaDabEBZqchxuBFNist8=;
	h=From:To:Subject:Date:List-ID:From;
	b=vPdhOoumpb33D/9QCrnGo4g4JM5EnlKJ5hhQOqk17fxzgDyzKYxtJ33zpDpmSXpA7
	 e6q7htqcUvSUuGLirjR5UvItdDY01/3f1kgpZykvhcbgYwmizDJahUG17+QkEIxOfG
	 yVj+Zv8nZbtDlgIcV3zUS7HAGcS+NpCcBa/af6q0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgAPL3Y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 16 Jan 2020 06:29:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgAPL3Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Jan 2020 06:29:24 -0500
Received: from debian5.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F4542073A
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jan 2020 11:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579174163;
        bh=NT2d5CX4L46jJCW5koSPA0DKaDabEBZqchxuBFNist8=;
        h=From:To:Subject:Date:From;
        b=GPjgpFnDxBMiUBTyH8SOlKs5eQNcnTzi86p+vaqyYWkRtFK9mmWfznqK080+5nRsg
         NBUF8eXJYWV3am28Y+q0l0foEjFi1f1q1CiVrE+auybE5ToUQ8xgBMB0dOSqLQRD94
         d8IClO+hoSjDkgmp9mgQOyx55zR9ocdDLMDZWZ4o=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: always copy scrub arguments back to user space
Date:   Thu, 16 Jan 2020 11:29:20 +0000
Message-Id: <20200116112920.30400-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

If scrub returns an error we are not copying back the scrub arguments
structure to user space. This prevents user space to know how much progress
scrub has done if an error happened - this includes -ECANCELED which is
returned when users ask for scrub to stop. A particular use case, which is
used in btrfs-progs, is to resume scrub after it is canceled, in that case
it relies on checking the progress from the scrub arguments structure and
then use that progress in a call to resume scrub.

So fix this by always copying the scrub arguments structure to user space,
overwriting the value returned to user space with -EFAULT only if copying
the structure failed to let user space know that either that copying did
not happen, and therefore the structure is stale, or it happened partially
and the structure is probably not valid and corrupt due to the partial
copy.

Reported-by: Graham Cobb <g.btrfs@cobb.uk.net>
Link: https://lore.kernel.org/linux-btrfs/d0a97688-78be-08de-ca7d-bcb4c7fb397e@cobb.uk.net/
Fixes: 06fe39ab15a6a4 ("Btrfs: do not overwrite scrub error with fault error in scrub ioctl")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3a4bd5cd67fa..173758d86feb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4253,7 +4253,19 @@ static long btrfs_ioctl_scrub(struct file *file, void __user *arg)
 			      &sa->progress, sa->flags & BTRFS_SCRUB_READONLY,
 			      0);
 
-	if (ret == 0 && copy_to_user(arg, sa, sizeof(*sa)))
+	/*
+	 * Copy scrub args to user space even if btrfs_scrub_dev() returned an
+	 * error. This is important as it allows user space to know how much
+	 * progress scrub has done. For example, if scrub is canceled we get
+	 * -ECANCELED from btrfs_scrub_dev() and return that error back to user
+	 * space. Later user space can inspect the progress from the structure
+	 * btrfs_ioctl_scrub_args and resume scrub from where it left off
+	 * previously (btrfs-progs does this).
+	 * If we fail to copy the btrfs_ioctl_scrub_args structure to user space
+	 * then return -EFAULT to signal the structure was not copied or it may
+	 * be corrupt and unreliable due to a partial copy.
+	 */
+	if (copy_to_user(arg, sa, sizeof(*sa)))
 		ret = -EFAULT;
 
 	if (!(sa->flags & BTRFS_SCRUB_READONLY))
-- 
2.11.0

