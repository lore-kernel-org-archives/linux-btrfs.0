Return-Path: <SRS0=RJN2=AN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD05AC433E0
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jul 2020 01:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CDF2206BE
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jul 2020 01:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593653649;
	bh=Con61WNuWQAr5TO/MbZ6p7QE5r9Yg5CGIDIyLLHtmSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LAJeB+YLtIcNIxOOTltZ9fjez+xNAxttV0/2EHcPLq31HiggWVKjsw7xgqZNuKl/U
	 SCLZASEUAo/4+JA3O912R5+Jc666X3A2zZ5iPeMzDO0ORCG8k8DNWOcDALSCheBNyj
	 oxkme/EmX+uSAkO/H0OZvX9iBUPA0e9aOHK3D7rA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgGBBZh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 21:25:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728822AbgGBBZe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Jul 2020 21:25:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1830B20874;
        Thu,  2 Jul 2020 01:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653134;
        bh=Con61WNuWQAr5TO/MbZ6p7QE5r9Yg5CGIDIyLLHtmSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wR/qan006fDkICug1tMfa3vTYft3RwpdjJvUcS3SIzoVtjnTG3gSI21PeWA3Uo7FX
         BKgyqvuIKToBEETWkTmDhU1M08GfnmRQZfBkv3GO/jaqwlDBaBi1kABvA347Z7iwzd
         ZHl3a11CLfteRe04pDg9N4hxzL15QSxy1o+mGUfg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Waiman Long <longman@redhat.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/40] btrfs: use kfree() in btrfs_ioctl_get_subvol_info()
Date:   Wed,  1 Jul 2020 21:23:29 -0400
Message-Id: <20200702012402.2701121-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012402.2701121-1-sashal@kernel.org>
References: <20200702012402.2701121-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit b091f7fede97cc64f7aaad3eeb37965aebee3082 ]

In btrfs_ioctl_get_subvol_info(), there is a classic case where kzalloc()
was incorrectly paired with kzfree(). According to David Sterba, there
isn't any sensitive information in the subvol_info that needs to be
cleared before freeing. So kzfree() isn't really needed, use kfree()
instead.

Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d88b8d8897cc5..08d8bb421848a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2735,7 +2735,7 @@ static int btrfs_ioctl_get_subvol_info(struct file *file, void __user *argp)
 
 out:
 	btrfs_free_path(path);
-	kzfree(subvol_info);
+	kfree(subvol_info);
 	return ret;
 }
 
-- 
2.25.1

