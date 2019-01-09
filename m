Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0FEC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BE1620821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X1XoHCwr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbfAIB2C (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:28:02 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55009 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729463AbfAIB1w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:52 -0500
Received: by mail-wm1-f67.google.com with SMTP id a62so5982498wmh.4;
        Tue, 08 Jan 2019 17:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q3WmptICKfXlB5dcAMTAy/7mWZAxRLMmgl1h1L8VFgA=;
        b=X1XoHCwrB/2LLDhKYDpZ617OWEFSY41iJf7qBMKeiyv2zHCGNiDhTLIF1l5TjVkSPm
         CX7Gi8tavux/fbgfq42lh+T/tGuzzDkqPHOSJldZ8uclgY3C7jMipe1ekJcZK1lckra4
         S3OwlOO7yy1W8vZG8BvJg1GjEjVpLBRLI4imXIS0bJdc9TgCB9ayGjByzQ8MQ1/Vnk0c
         Ttju01DSLFYMGkCmXnWCTt31ulgltAKGJ2wepKC1TrSQKOIGM+StU5C6VyFquYKDuUIT
         8KZ/tlILFen/SHNVZ6BP/cJvsqA1DepuO1pcgebIgITS8QUehRsjF+gGLvODcx12IO3f
         CABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=q3WmptICKfXlB5dcAMTAy/7mWZAxRLMmgl1h1L8VFgA=;
        b=sIYluUqGOFKq0+Kc8mtvDgp4A52lrIppOWcyHhyPXKwp7/IHBSBh8lgPR6V5HwTBOD
         k/3bUwZPeg6RUDOA/ZPvqzB3qQIz55S/qVL+sRYjEnUpLoJIQQoKa6rqocidKFrh3G5p
         04gWvoFQKss5GLmlk5/FDjfNemuH2K133kMM8ydHscjPRUQEajdh4sTzpqNnyRJb3qpc
         cuN677M5/+6XqlPue39Lum+Px81mEDCI6u8QdKyNXZHYphvd9/NFLuMypikw6Memo5QP
         aSdrjGJnI+hrbe+VQC/2BXgbrgeYod55BOB5UHbeD08koo+E72hv3sL7ut0np9NfC88r
         8UiA==
X-Gm-Message-State: AJcUukfjJn0n64wPALfePXLad+rpwFusobbJv9loSoj1fbNCDRTAbryE
        0GUKKiFNEym/qOT04ZYGj9IOqeuhpDI=
X-Google-Smtp-Source: ALg8bN4gFiufyn9UrY03FHFbMFBZ/IJHe7oTVw3VW8RPZfIT9KC3C6RdIamY5MgkMLL27T7rznGD/w==
X-Received: by 2002:a1c:63d5:: with SMTP id x204mr3421798wmb.137.1546997270277;
        Tue, 08 Jan 2019 17:27:50 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:49 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 19/19] btrfs: translate encryption flag to FS_ENCRYPT_FL
Date:   Wed,  9 Jan 2019 01:27:01 +0000
Message-Id: <20190109012701.26441-19-mark@harmstone.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190109012701.26441-1-mark@harmstone.com>
References: <20190109012701.26441-1-mark@harmstone.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/ioctl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6589656e3988..af054390d78d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -123,6 +123,8 @@ static unsigned int btrfs_inode_flags_to_fsflags(unsigned int flags)
 		iflags |= FS_DIRSYNC_FL;
 	if (flags & BTRFS_INODE_NODATACOW)
 		iflags |= FS_NOCOW_FL;
+	if (flags & BTRFS_INODE_ENCRYPT)
+		iflags |= FS_ENCRYPT_FL;
 
 	if (flags & BTRFS_INODE_NOCOMPRESS)
 		iflags |= FS_NOCOMP_FL;
@@ -173,7 +175,7 @@ static int check_fsflags(unsigned int flags)
 		      FS_NOATIME_FL | FS_NODUMP_FL | \
 		      FS_SYNC_FL | FS_DIRSYNC_FL | \
 		      FS_NOCOMP_FL | FS_COMPR_FL |
-		      FS_NOCOW_FL))
+		      FS_NOCOW_FL | FS_ENCRYPT_FL))
 		return -EOPNOTSUPP;
 
 	if ((flags & FS_NOCOMP_FL) && (flags & FS_COMPR_FL))
-- 
2.19.2

