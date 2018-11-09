Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D09FC43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 23:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3624B20827
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 23:12:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=rasmusvillemoes.dk header.i=@rasmusvillemoes.dk header.b="L0qMGqCQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3624B20827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rasmusvillemoes.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbeKJIzC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 10 Nov 2018 03:55:02 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43306 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728855AbeKJIyC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Nov 2018 03:54:02 -0500
Received: by mail-lf1-f67.google.com with SMTP id u18so2482992lff.10
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Nov 2018 15:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lsgMgygo+bKUNjEuYg81iTooxPuNEFXNyVxX3YHOF7s=;
        b=L0qMGqCQlWAsJz2kWOzOsR61qdGYeI2Yl90qRkJ0akHq4cbeMGAC0AtBZo8u3qcEgd
         4d308ELwzCfeDvUQYSB7PkIXikjbncqC/IB77FBPP/xjce4gX5HeAPanK4ZcXj05y7D2
         sw2oN/0gXxFpNpqMrJmObf8DVukmxOB0lSqA8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lsgMgygo+bKUNjEuYg81iTooxPuNEFXNyVxX3YHOF7s=;
        b=sppCVZ+C6y3PzS8ZjOrxJrxSSH/vD407OlROyGVHS+krxUEwsk3WldcQDCMLuxA7k/
         D815cCGE3TXipRG7ylr7KA0D5+ouDMygfyuPVwzl6Umrb9QQUuxqD5EH1w4VU1xENhiW
         CoOZYShXXW9iuLElNMAC2tKYNemOI/MyWvML9/xw1Wobz+7mrL0aMMM2wc6u3qjitXbN
         huCo5yVbs3fOsEN+Mfe1Asg2Rw/kDOxpkgcGZ4Fjyi9Zo4k9m+a0J6z55R6fl12jMGqV
         qV/JEAxKHUo403SlRuTVd1r7RUAVOEhGenZzu/uDRXQIr2zHLKMUgdXPn0PjiKHr3NJF
         ZXMA==
X-Gm-Message-State: AGRZ1gLxWaqa5KKVQMEEnyeC8RJe7er0S9bFQhKSwuupdwwmO1QoIplc
        B3i1pnX278qvdtuhqQGNCoATAw==
X-Google-Smtp-Source: AJdET5fs8/NrIQG9kDl06bPcF53Bk1yNW+bqJdnjFcXVIr9+cVoH/wp7HtGweU9OJ+rrtZdZ1wps+g==
X-Received: by 2002:a19:d445:: with SMTP id l66mr6814388lfg.26.1541805077046;
        Fri, 09 Nov 2018 15:11:17 -0800 (PST)
Received: from prevas-ravi.prevas.se (dhcp-5-186-114-252.cgn.ip.fibianet.dk. [5.186.114.252])
        by smtp.gmail.com with ESMTPSA id x16sm1584012lff.26.2018.11.09.15.11.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 09 Nov 2018 15:11:16 -0800 (PST)
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@akamai.com>
Cc:     linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH v3 14/23] btrfs: implement btrfs_debug* in terms of helper macro
Date:   Sat, 10 Nov 2018 00:10:12 +0100
Message-Id: <20181109231021.11658-15-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.19.1.6.gbde171bbf5
In-Reply-To: <20181109231021.11658-1-linux@rasmusvillemoes.dk>
References: <20181009112013.14238-1-linux@rasmusvillemoes.dk>
 <20181109231021.11658-1-linux@rasmusvillemoes.dk>
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
index 80953528572d..0d55bf56872f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3334,31 +3334,17 @@ void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...);
 
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
2.19.1.6.gbde171bbf5

