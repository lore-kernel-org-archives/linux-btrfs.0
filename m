Return-Path: <SRS0=iEal=RZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D8AEC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 14:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55C2321874
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 14:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfCVOIn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:08:43 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:49477 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727487AbfCVOIn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Mar 2019 10:08:43 -0400
Received: from wuerfel.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MC2o9-1hHSly04XV-00CPFR; Fri, 22 Mar 2019 15:07:55 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nikolay Borisov <nborisov@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: work around false-positive -Wsometimes-uninitialized warning
Date:   Fri, 22 Mar 2019 15:07:47 +0100
Message-Id: <20190322140753.286171-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:CSYo6DUUj4yfxJ2QTSL1M70TqeZn/gI2tHJcjNE7Bi4lNZg1sPl
 oc0yZzTWg8ego/C1EoZfkAFaWGqm5IhLsSCFcHk57Hsl8Kfw0bFwosz1sCFl998qSLWUTC2
 /rtQd4qujE2vdeZXSdE40Rt3GS5uSE6nhY9TwBKsLnZsXXZv+ZBNJ0i88IhULXr37zaL0Dh
 7Wnt333AzMDK/6xV/iQYg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:5WWCgDRAZuM=:dSc3pDc6/RclNdtuOPPtqH
 jLO0ArEpOVUpdEdKPUr6Iv45fPwhtkZ9bCb+Yop3y7leu4D1Vw/MaO+NiPHQaPINty0F3W6ts
 Hl3WcGVH4QQxDZ97xvrQMLe2HpblHBsx95Rn+YXTAdTfBVY8zrY1jGXxUSh7vTpAmO0XzFWxW
 LdLnLHJtBJdmMCnGqqdXhz1eAk+BFYmvZEZYhYTqra9QaugVjwO76dhEFENlSXWM3cMBxaAqE
 +/+aVlRxq+AFCkTGZd38HmU3zRq/5GUlmmnhCGsU8E3u660VefDIjaRDvJAETT2/Qxd5Tl5Lv
 8WQT5fPHZrZ6tc7Xx0NqhDsDC7sn6EWl/DxgckxXctCwOZ1szffDLhz0XuXpdmqDLEXkKBVY3
 EN9kpCvLKQGBPxJx1Six9IOyUdgOr8pYfIH9ZFvS9oJlA0kyAomtnFm4lLsSGfeWVOv7pZTrL
 Jn5llM4L3iQZvHN5g2a1ufN0xRC18A1CnIvm/im5qU7VvUJZ49pvVXH4jrG+D+lKAUSnzidd9
 cwyTEvQpnewkCC0Ay7u8CT8MAEPlteJKkuRBDceN17HvHKhKvi2+y/ThsU568R3oGbIJcJC7N
 YEejDu+dJdlLUGLfsGzxfcZ+sy+dYdvuGLnAaFhHEcACj8ghxAGkSJVkwEwoEpT5F2wfkKfvc
 ObherSYh7YCqVaJ5eXLHyuvyBKY3YFhmwgCuFqbQpVajUlEribRMFFUblmOJFbQM10JHhSvJV
 lerV3FkjiGcb/KgK6kngzDWc3VkKKJa1toMKew==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

clang fails to see that the last 'else if() in btrfs_uuid_tree_add()
is always true, so 'eb' is always initialized correctly:

fs/btrfs/uuid-tree.c:129:13: error: variable 'eb' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
        } else if (ret < 0) {
                   ^~~~~~~
fs/btrfs/uuid-tree.c:139:22: note: uninitialized use occurs here
        write_extent_buffer(eb, &subid_le, offset, sizeof(subid_le));
                            ^~
fs/btrfs/uuid-tree.c:129:9: note: remove the 'if' if its condition is always true
        } else if (ret < 0) {
               ^~~~~~~~~~~~~
fs/btrfs/uuid-tree.c:90:26: note: initialize the variable 'eb' to silence this warning
        struct extent_buffer *eb;
                                ^
                                 = NULL

Change it into a plain 'else' to shut up that warning.

Link: https://bugs.llvm.org/show_bug.cgi?id=41197
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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
2.20.0

