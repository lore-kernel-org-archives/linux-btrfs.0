Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A253BC282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 21:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FE39222C0
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 21:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rasmusvillemoes.dk header.i=@rasmusvillemoes.dk header.b="e4LZ911i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731996AbfBLVmL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 16:42:11 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35485 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731944AbfBLVmK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 16:42:10 -0500
Received: by mail-ed1-f66.google.com with SMTP id b17so186940eds.2
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 13:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CmoKrMTX3KtaphXFuCz3MUJoOMIm8ylnTIRthObf8No=;
        b=e4LZ911iTSxJL41HEw51kDWlhyVHJ2WHAbUb6UT929aiJnKrea7GsueC4jmmKZTZDK
         kM8uvPgvAuXBGd2aZCeBf0UjTg2fntQWdLmMJ43jq/YE7yuIEj65XbVXm1UDG47UvxVf
         fC2Pvep0UHJk3RVanmqOkHzXoyShm026r7Geo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CmoKrMTX3KtaphXFuCz3MUJoOMIm8ylnTIRthObf8No=;
        b=SZ3slEbgnX83hNSqMpKzlcHaQO4OpiFdDDEKrDgrOUOOTJvah5PzFjbH0EPxq48XFW
         3nOyOG5P7g0ONXfU3ABgYsOiPvAxQMeFMgr2hRb0awaVRx0C0YxJWKmMMhA6evsF7T/t
         5kLMFmYO+ikqChZsBYfuhPWFRgglLP8Wy1FxcFMqVNxViP/KujcAHwID4JJLi3nYGTYq
         xiBoiucqHO2205NqL2sAqxxnyB8hk4fg38TKw923paD3fx9q6ysm5xX2TKmfzQT9qBtP
         iH0om5Pav55mAG/RpIMdforErCn0JJY2ZAPuzdHNsUk0bho1tQop5Imfp+vzCG8zA8WK
         Su2g==
X-Gm-Message-State: AHQUAuaJpG/A6k9LnRkGIdaZhZfCdOtuQNLmtyYtCfja4gGWpcN/2/XB
        UBvi/T6WUc+Jd5dhNDIRK7NJLuY/aI9O4wGw
X-Google-Smtp-Source: AHgI3IYlAeSMAxSsu1lcReSV3HW7jgwBnB3FnI+hSJ4+05/0LRshXXLvYrb96q+Kl5EpUl8uY4+NrQ==
X-Received: by 2002:a17:906:3654:: with SMTP id r20mr4236196ejb.239.1550007728437;
        Tue, 12 Feb 2019 13:42:08 -0800 (PST)
Received: from prevas-ravi.waoo.dk (ip-5-186-119-174.cgn.fibianet.dk. [5.186.119.174])
        by smtp.gmail.com with ESMTPSA id v1sm3697607eds.47.2019.02.12.13.42.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 13:42:07 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@akamai.com>
Cc:     linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH v4 11/14] btrfs: implement btrfs_debug* in terms of helper macro
Date:   Tue, 12 Feb 2019 22:41:47 +0100
Message-Id: <20190212214150.4807-12-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190212214150.4807-1-linux@rasmusvillemoes.dk>
References: <20190212214150.4807-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

First, the btrfs_debug macros open-code (one possible definition of)
DYNAMIC_DEBUG_BRANCH, so they don't benefit from the CONFIG_JUMP_LABEL
optimization.

Second, a planned change of struct _ddebug (to reduce its size on 64
bit machines) requires that all descriptors in a translation unit use
distinct identifiers.

Using the new _dynamic_func_call_no_desc helper macro from
dynamic_debug.h takes care of both of these. No functional change.

Cc: linux-btrfs@vger.kernel.org
Acked-by: David Sterba <dsterba@suse.com>
Acked-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 fs/btrfs/ctree.h | 34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7a2a2621f0d9..94618a028730 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3415,31 +3415,17 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...);
 
 #if defined(CONFIG_DYNAMIC_DEBUG)
 #define btrfs_debug(fs_info, fmt, args...)				\
-do {									\
-        DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         	\
-        if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))  	\
-		btrfs_printk(fs_info, KERN_DEBUG fmt, ##args);		\
-} while (0)
-#define btrfs_debug_in_rcu(fs_info, fmt, args...) 			\
-do {									\
-        DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt); 	        \
-        if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT)) 		\
-		btrfs_printk_in_rcu(fs_info, KERN_DEBUG fmt, ##args);	\
-} while (0)
+	_dynamic_func_call_no_desc(fmt, btrfs_printk,			\
+				   fs_info, KERN_DEBUG fmt, ##args)
+#define btrfs_debug_in_rcu(fs_info, fmt, args...)			\
+	_dynamic_func_call_no_desc(fmt, btrfs_printk_in_rcu,		\
+				   fs_info, KERN_DEBUG fmt, ##args)
 #define btrfs_debug_rl_in_rcu(fs_info, fmt, args...)			\
-do {									\
-        DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         	\
-        if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))  	\
-		btrfs_printk_rl_in_rcu(fs_info, KERN_DEBUG fmt,		\
-				       ##args);\
-} while (0)
-#define btrfs_debug_rl(fs_info, fmt, args...) 				\
-do {									\
-        DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);         	\
-        if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT))  	\
-		btrfs_printk_ratelimited(fs_info, KERN_DEBUG fmt,	\
-					 ##args);			\
-} while (0)
+	_dynamic_func_call_no_desc(fmt, btrfs_printk_rl_in_rcu,		\
+				   fs_info, KERN_DEBUG fmt, ##args)
+#define btrfs_debug_rl(fs_info, fmt, args...)				\
+	_dynamic_func_call_no_desc(fmt, btrfs_printk_ratelimited,	\
+				   fs_info, KERN_DEBUG fmt, ##args)
 #elif defined(DEBUG)
 #define btrfs_debug(fs_info, fmt, args...) \
 	btrfs_printk(fs_info, KERN_DEBUG fmt, ##args)
-- 
2.20.1

