Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E3CC64EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 11:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FE91214C4
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 11:21:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rasmusvillemoes.dk header.i=@rasmusvillemoes.dk header.b="dvvBadQ/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FE91214C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rasmusvillemoes.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbeJIShG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 14:37:06 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44259 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727284AbeJIShF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2018 14:37:05 -0400
Received: by mail-ed1-f67.google.com with SMTP id z21-v6so1304534edb.11
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2018 04:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jlaMlnDD3Ii16jAg/Lcwqism2m+Mq3AaZpU6R5FfxQc=;
        b=dvvBadQ/+q7Cb75Rvd9fiLdENLJws6LhTvYLGKQ0Ew4swyM0YDHDbuYMT4xSxhf3Oj
         KXVPCStOXlBAau/HBk4c7udeXqXy/a5Z7M2xNzWKyaU6avLzC9wam3jlShc4TkUWCv5v
         CNV96/yOfdqEdtsJbWHAFHpSCNn5WLhJSrFtw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jlaMlnDD3Ii16jAg/Lcwqism2m+Mq3AaZpU6R5FfxQc=;
        b=bhfKkRhEyx8UjFpDCLymOWD7xQ71/2swDqD01I96TS+1ha5kWY7UDzepet62xE4ozc
         RCaS0E45fq6ZghprdeICKBlxsGfE8kiDeoS7zBxh4TWNf3o+VYJTLRbvl6kJ0sZR42UD
         vXbbl64+qDmJKFXigBG8ZitsL8xDFAAwBoSGS1xE/dp0liWAkBp8VRHvlPHrW7X/voU5
         SK+OvpyLUBlpVOKc53BZ3uV8pSF6kXXjzJcyQ7/00wnAI4fSjYoMD6sSTodmhI0n7qWw
         +eZSS+JwmbpOVGRKW4hKYvrCMddWqRs7GSx7DQtIMS7BXCi9jcfBTMUy85dvEJJWwcid
         dUZg==
X-Gm-Message-State: ABuFfohQtI6AvkLQM4KpvrFyQmYWA7kyMW0hDM3Slpor5yFf5GwMLKoY
        JZNVaEdSTLpJ1n3LcTIaMa5fQw==
X-Google-Smtp-Source: ACcGV61DncgNN/5DWqDyjRnBSiYjlO+bnhuy12hsYOkefhzFr0Njo5CZh8/n9Ic+E5i5f2m4Jx7Z9A==
X-Received: by 2002:a50:b404:: with SMTP id b4-v6mr13233795edh.141.1539084034556;
        Tue, 09 Oct 2018 04:20:34 -0700 (PDT)
Received: from prevas-ravi.vestasvisitor.net ([193.47.71.171])
        by smtp.gmail.com with ESMTPSA id n23-v6sm3595821eja.41.2018.10.09.04.20.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 09 Oct 2018 04:20:34 -0700 (PDT)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Jason Baron <jbaron@akamai.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 14/23] btrfs: implement btrfs_debug* in terms of helper macro
Date:   Tue,  9 Oct 2018 13:20:04 +0200
Message-Id: <20181009112013.14238-15-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.19.1.4.g721af0fda3
In-Reply-To: <20181009112013.14238-1-linux@rasmusvillemoes.dk>
References: <20180919220444.23190-1-linux@rasmusvillemoes.dk>
 <20181009112013.14238-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

First, the btrfs_debug macros open-code (one possible definition of)
DYNAMIC_DEBUG_BRANCH, so they don't benefit from the HAVE_JUMP_LABEL
optimization.

Second, changes on x86-64 later in this series require that all struct
_ddebug descriptors in a translation unit use distinct identifiers.

Using the new _dynamic_func_call_no_desc helper macro from
dynamic_debug.h takes care of both of these.

Cc: linux-btrfs@vger.kernel.org
Acked-by: David Sterba <dsterba@suse.com>
Acked-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 fs/btrfs/ctree.h | 34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2cddfe7806a4..7ae6cdad5b38 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3353,31 +3353,17 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...);
 
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
2.19.1.3.g1d92a00e68

