Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A28C43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 16:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 148832081B
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 16:35:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HuTtW7Ky"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfCGQfr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 11:35:47 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43729 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfCGQfr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2019 11:35:47 -0500
Received: by mail-ed1-f68.google.com with SMTP id m35so13987016ede.10;
        Thu, 07 Mar 2019 08:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GdUy4oVpdiBp3EhX/Iu+EhgW75mPomojv0VK4+bVFxo=;
        b=HuTtW7Ky5MQBuSpT+Xa1749TcW5sE/ffXNNa86pxrhNnQ41EYDvQxONtGjaVlYJ9hU
         5vSQiwx987JL6JHz86vPU82FhCxN9ZUYCEzUqN8XiB1oYcoPNuBoqZGxoZFaiSOeE/iM
         6s5cU3OrlgqQYACGjs/xq/GxmvQENGQkSiCKvtOKWoqRGTJ0u8t9ZeEN9bGs5blAfVIW
         ut6Qn+Zd28n956zWYA3jrR97+ZBSI0CUqCUatGhJ0iRAqnmjzxfO8MYMKhnYHY679mNg
         FNJHV1r8rXVvfVpDYboxVfSwFhRqv92YVPcy1A2dwNoxjFilVriQahbLzKI6cCKKpIao
         uMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GdUy4oVpdiBp3EhX/Iu+EhgW75mPomojv0VK4+bVFxo=;
        b=MqQCKEsnnYsrWcABE1EPHv/UQDpj3kHIoMRnNfD4d0Hhv4HP37LmmvoH+g3ZVa3+dJ
         MYjBAGWLu1jwDdIu1gTTTQUCSzvnok1UYRhUbuHcPifh2W7xI4GRwHqH3ahBYw0pCGjp
         6ixW/Vjsoas2xr0gvuGAdCBUaEiEcTHoOJGAVgHqrkRLliDjHoowBZZMPifSdqC0IqT4
         CVBwzIC5llbTC3yV/YJ2x7pepGQ23YPdVsGzgWoHkATmr14fCRflz94TetbaFz3sX6He
         voiqZLbJxfmWvrlYQXQgADTG/FrkGIoO+T9UqyCaqR7aOb311LpnzHxhnqqFlGw6o+W4
         pIqg==
X-Gm-Message-State: APjAAAUwHCm9rN5Ja4qyjWrbNzOGP1c8p0k+0pjd7GS0icrFNz69Mahz
        /MZJ7OUx/thW/0NQmSykPbE=
X-Google-Smtp-Source: APXvYqyJ/5qr6xRUR2+rbnrylfOODM7V6l12KoSH8eVpBmApmGtb9AsG6D0R6SF11FJG1YEC2Ynpsg==
X-Received: by 2002:a50:b6e6:: with SMTP id f35mr29034003ede.94.1551976544824;
        Thu, 07 Mar 2019 08:35:44 -0800 (PST)
Received: from localhost.localdomain ([2a01:4f9:2a:1fae::2])
        by smtp.gmail.com with ESMTPSA id d10sm986947ejr.64.2019.03.07.08.35.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 08:35:44 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH] btrfs: Turn an 'else if' into an 'else' in btrfs_uuid_tree_add
Date:   Thu,  7 Mar 2019 09:35:15 -0700
Message-Id: <20190307163515.2168-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When building with -Wsometimes-uninitialized, Clang warns:

fs/btrfs/uuid-tree.c:129:13: warning: variable 'eb' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
fs/btrfs/uuid-tree.c:129:13: warning: variable 'offset' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]

Clang can't tell that all cases are covered with this final else if.
Just turn it into an else so that it is clear.

Link: https://github.com/ClangBuiltLinux/linux/issues/385
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 fs/btrfs/uuid-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index 3b2ae342e649..c1cc9a5c0024 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -126,7 +126,7 @@ int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans, u8 *uuid, u8 type,
 		slot = path->slots[0];
 		offset = btrfs_item_ptr_offset(eb, slot);
 		offset += btrfs_item_size_nr(eb, slot) - sizeof(subid_le);
-	} else if (ret < 0) {
+	} else {
 		btrfs_warn(fs_info,
 			   "insert uuid item failed %d (0x%016llx, 0x%016llx) type %u!",
 			   ret, (unsigned long long)key.objectid,
-- 
2.21.0

