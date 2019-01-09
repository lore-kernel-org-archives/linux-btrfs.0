Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D08DC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDD0920821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:28:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KZnWVwX6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbfAIB1v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:27:51 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36692 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729698AbfAIB1u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:50 -0500
Received: by mail-wr1-f67.google.com with SMTP id u4so6021867wrp.3;
        Tue, 08 Jan 2019 17:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eu8YGlhuvRnxMnAUAS9Ae7ho2XqM5HTbQGR4QdPi7hE=;
        b=KZnWVwX61+mAQhekiakSF4VoPknhUSZTnbemgwQLv2TtanYvbYS3zAYe3ehvsu1jKu
         Ng9ZikyBfELTkzpncGOsFD2tXBXda0IQIpIh/1UDArON6DUjGfflmVSskEdq/IEwZjyz
         5dKNLQubn0YT/NA9v53BY19nA03inW5VLWsHiABHd3xEPO33ZzaQswERw73YTIYY5QjP
         hTPYl5X5D/XoQnemYw+k3aOmczKjKjCSvHXi7wX1kP7Uws+tb1YNPOPm5XIHig0V2UQV
         1G4wc/SDnDeVHAv9OE+i1fDT3oq55ABt9dB9l4UUKcuP6IjaW4Qkp7MPPfEK+AhrVADR
         fqIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=eu8YGlhuvRnxMnAUAS9Ae7ho2XqM5HTbQGR4QdPi7hE=;
        b=cVJt0/fRlkLwDIy1UM+p6wDnanouCBe06O+HD/qDJt9EwWQ8PP37j6u5zggGDxgWxm
         weLjaTLC+rkjl4mfbQ3J+6+fqfULObgtpR4fL5Ez1W2bgHxhn242D0PDdmeA7Ad112If
         ndba459FKnsWNpPmGsLCbLkP1rVlPoORl7loSMq8KgPEm9QkbM65HytcRbxRKBnZfB4o
         ujahiJVS8C2Ho1U6XrdjTUpB6RZLQF6UX/b0QjtbXspTanDuC8GH4/vPMY2FdxRumM/W
         a4Z0vbDwySA6ByhJgzmSGAiXHbGIbj3fTc077C0vob2ZeWV7XREe7e0qZlB2r17kdLo2
         KlaA==
X-Gm-Message-State: AJcUukfOIY9OQc0wZxY3p7RuPkXmiLuacCZ0ccbaZPE0k74qwnqHup7H
        gJOzPCqtWBoCLluJQydsTK6cjXQ9KRc=
X-Google-Smtp-Source: ALg8bN4yy4pkoXHsGtnRWH2T6iivY8MFzeF0QsqWcwCY5OkkZgBbco/TLQEHg18FxVPlCwtnOQRVxA==
X-Received: by 2002:adf:b102:: with SMTP id l2mr3008134wra.296.1546997269048;
        Tue, 08 Jan 2019 17:27:49 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:48 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 18/19] btrfs: return encrypted flag to statx
Date:   Wed,  9 Jan 2019 01:27:00 +0000
Message-Id: <20190109012701.26441-18-mark@harmstone.com>
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
 fs/btrfs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8f58f492abc8..beaeeafe467a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9637,11 +9637,14 @@ static int btrfs_getattr(const struct path *path, struct kstat *stat,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (bi_flags & BTRFS_INODE_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
+	if (bi_flags & BTRFS_INODE_ENCRYPT)
+		stat->attributes |= STATX_ATTR_ENCRYPTED;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
 				  STATX_ATTR_IMMUTABLE |
-				  STATX_ATTR_NODUMP);
+				  STATX_ATTR_NODUMP |
+				  STATX_ATTR_ENCRYPTED);
 
 	generic_fillattr(inode, stat);
 	stat->dev = BTRFS_I(inode)->root->anon_dev;
-- 
2.19.2

