Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C625C2BB41
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Aug 2022 06:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiHPGn4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 02:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiHPGnk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Aug 2022 02:43:40 -0400
Received: from out20-206.mail.aliyun.com (out20-206.mail.aliyun.com [115.124.20.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514C4F53
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2022 18:37:06 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.05582384|-1;BR=01201311R371S22rulernew998_84748_2000303;CH=blue;DM=|CONTINUE|false|;DS=CONTINUE|ham_social|0.0422025-0.000509717-0.957288;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047211;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.OuFKfzA_1660613823;
Received: from T640.e16-tech.com(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.OuFKfzA_1660613823)
          by smtp.aliyun-inc.com;
          Tue, 16 Aug 2022 09:37:03 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Wang Yugui <wangyugui@e16-tech.com>
Subject: [PATCH] btrfs-progs: avoid redefined __bitwise__ warning
Date:   Tue, 16 Aug 2022 09:37:03 +0800
Message-Id: <20220816013703.72722-1-wangyugui@e16-tech.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

compile warning:
    ./kerncompat.h:142: warning: "__bitwise__" redefined
    #define __bitwise__

    In file included from ./kerncompat.h:35,
                    from check/qgroup-verify.c:24:
    /usr/include/linux/types.h:25: note: this is the location of the previous definition
    #define __bitwise__ __bitwise

Because  __bitwise__ is already defined in newer kernel-headers
(/usr/include/linux/types.h), so add #ifndef to avoid this warning.

Signed-off-by: Wang Yugui <wangyugui@e16-tech.com>
---
 kerncompat.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kerncompat.h b/kerncompat.h
index f6477990..15595500 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -139,8 +139,10 @@ static inline void bugon_trace(const char *assertion, const char *filename,
 #define __bitwise__ __attribute__((bitwise))
 #else
 #define __force
+#ifndef __bitwise__
 #define __bitwise__
 #endif
+#endif
 
 #ifndef __CHECKER__
 /*
-- 
2.36.2

