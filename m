Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAFFC4332F
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Dec 2022 20:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbiLPUQJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Dec 2022 15:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbiLPUQH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2022 15:16:07 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F4461D51
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Dec 2022 12:16:06 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id k185so3394989vsc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Dec 2022 12:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xP87KjVFI1Zbqnjyi633dm3UZW8/Rhgu6zHUNNN3rlc=;
        b=YIFQjvZ8gxIOmsxaEG93zu4QRveahYuRZKSlxuhZ0lC+JuaWGRzdXVRTnP2CPBtnDK
         tC5m5Rh2Pozl2t2wMP2e1bmO+r3Y1J/H5+HqTnBuj+va4CTctiA//aVi4ZaJex9Lq8DK
         bvpCz/gJow3eOc19LQOE7rKWFtTLUFR1xR61jGzAWcAS33NKCe5cLHOhwb1UlJQBACsr
         MJ9AMGuAKKwI9dXZgo1vSfdpVstcYW9JV51K9A40PULjACO8iZ8h+hkP9VNqzWLW4mur
         S7qW8om5A6kHlixbhkdEOYmg3V9HCBPWsOgWMsOnj3HEnTOq3r6yT9r6lzE6hTOnv33j
         DlSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xP87KjVFI1Zbqnjyi633dm3UZW8/Rhgu6zHUNNN3rlc=;
        b=FHs0PrqZHCydpNAYDRMNKc8e1pM3DtQ0WXqOdXHlh+wtGGwZHy8ylL5wmr8LToeusb
         gcxO3TUvVaseyD7wy2LHpb6MJTqobW9vH2nh6VZkXAmY9J3joG+bJ8ErtgUtwulXMGCm
         CmSj02PUg2CdmxyqxD8bgNUOYmAZt+i8H+kb/VSx1CVDivZMHwDUAoS7gN/00omwFuiS
         lsOTXEkbsgr36bi+cASKUpC64vke+rRJTuGqyqnFmAIcGCtNb4ZFaO1Jmm9wP3Kiftis
         +mZAKZszbs5DbJvpGpoK9jvMTO1TIkloriaKUI5/2/sq5pWnjz1YoPu4C/pMxBsBwo3M
         mBXQ==
X-Gm-Message-State: ANoB5pmWG/Zjr5IQ2S0PQw/ZT/zVYioDNgLBOyTKC9X3excoj6MDNT5q
        iMxNlN3ATowpSkHewKXa7urbk5mpGaBe/p+ZJQE=
X-Google-Smtp-Source: AA0mqf5sVZzpwOI/OrWl6jfoC7CJycymivCYIcl7+cDjueSpWkNFk2JqnZEQZDzQB0Yd6Fssyi7wWA==
X-Received: by 2002:a67:ffcb:0:b0:3b1:48fc:e033 with SMTP id w11-20020a67ffcb000000b003b148fce033mr22907423vsq.2.1671221764858;
        Fri, 16 Dec 2022 12:16:04 -0800 (PST)
Received: from localhost (cpe-174-109-170-245.nc.res.rr.com. [174.109.170.245])
        by smtp.gmail.com with ESMTPSA id dt20-20020a05620a479400b006fbf88667bcsm2105656qkb.77.2022.12.16.12.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 12:16:04 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 3/8] btrfs: fix uninit warning from get_inode_gen usage
Date:   Fri, 16 Dec 2022 15:15:53 -0500
Message-Id: <aa2e624f5626b37a267ea123baf7db2d76be41ee.1671221596.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1671221596.git.josef@toxicpanda.com>
References: <cover.1671221596.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Anybody that calls get_inode_gen() can have an uninitialized gen if
there's an error.  This isn't a big deal because all the users just exit
if they get an error, however it makes -Wmaybe-uninitialized complain,
so fix this up to always init the passed in gen, this quiets all of the
uninitialized warnings in send.c.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/send.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 67f7c698ade3..25a235179edb 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -955,14 +955,12 @@ static int get_inode_info(struct btrfs_root *root, u64 ino,
 static int get_inode_gen(struct btrfs_root *root, u64 ino, u64 *gen)
 {
 	int ret;
-	struct btrfs_inode_info info;
+	struct btrfs_inode_info info = {};
 
-	if (!gen)
-		return -EPERM;
+	ASSERT(gen);
 
 	ret = get_inode_info(root, ino, &info);
-	if (!ret)
-		*gen = info.gen;
+	*gen = info.gen;
 	return ret;
 }
 
-- 
2.26.3

