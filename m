Return-Path: <SRS0=T3D7=7K=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9A8C433E0
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 May 2020 09:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E765C208E4
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 May 2020 09:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgE1JRH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 May 2020 05:17:07 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:36319 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728131AbgE1JRG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 May 2020 05:17:06 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1N8X9L-1j0LQY0Zgv-014XDs; Thu, 28 May 2020 11:16:51 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        YueHaibing <yuehaibing@huawei.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: select FS_IOMAP
Date:   Thu, 28 May 2020 11:16:42 +0200
Message-Id: <20200528091649.2874627-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:1RCAwsbUJxBHj6/DytZWx6WqX/auVpCNblg0m1QXWYAWdVjzO0R
 g0Bv9Zy+0Sg/69QeevX0kbtabicMUAbMBAZEokpkzRYNn+eLum0nLoj82PO0coTQCuUVjFL
 yPZtn7jGTwtFgxBbxGaOgAgPzERroDpfNoFfrPSYPQchwhlGbhlPU77zN76u5GANO69Sr/U
 clmnw/YSsxgElDrsp5jSg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:QLvzOYpbWcE=:mV5DkYQqhnvTb24PGVbrR2
 z3QGbUif0ll/rGKPh6EjIUh7OaFMeUaXJqeeS6C6xLhwzkPbLahI8OyF3eaWrAQ3NC00t1PeW
 1ZUUNIyQPc/GD7Z9pBRi+8gQ1vySXH3arTzNG+3uf1gbmxkq92WSQa1urbixz/7YodKtrmRgR
 4SWsf+05nyLBAEy9l4xa5sVOUR4B5pAX96GV7wcWF1kOpcVc0fAbUGmbLR/yL0pnL0JOUEHgm
 ZV8hozKoQVr1HZJPioxu6I0FtY3KCL78gsMTCYrFOhqRsK5O4gP/y9erLj0srMUjSfJY+GV1M
 Gk1oPsSkIHNSAbhQk1J19HhTgP0xND2zf1sVMEcCj3maSecfgqV1xkE+4kkT1bEdHWlFTfmBw
 loGhYotbJVrfZA6OEHGndFUSKVaqI84kh7JePQPJIWnxGlC43CYU7liCWYZU4Beeeeug9lJvk
 8OmPBVtL/Xl8EJCSJFmXG44Q3eysdB5DRhzxXzZFI/gTG5X1B60ZKx7YLLPKn36sezwuWrfeB
 /Yv3vG3r4D2x/4STINOcN9US4Y99yYgzzU7isCrwXrtvrcVbMIHNu9CKr3X0fI8CvEm15o5QI
 uiTIgRSqa+X9PRPr9DcCye/gUjERY8pmSK5Rzirh6cZqKF15jdozNC1RPxHcPupRFJMgg59Es
 8yXIKUMMRgXVz9DFxF4tip6ew2diyjqKul3H3AShselWXZyVX8M1oaFbrY756q0KAr+tnEEro
 BCL5I6fL/XF6EGSTHuuIsHoyPkf4SQ+vcmiVwcQpgzhNh9LQWArLIJBhPaxos6k12LpxlduOT
 ckbu/ilzt8uhq1Sqg5QGqxZ7+2drfvyKsJCjRK6iYIkBmo68zY=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

As btrfs now calls iomap_dio_rw, the helper code actually has
to be enabled to avoid a link error:

ERROR: modpost: "iomap_dio_rw" [fs/btrfs/btrfs.ko] undefined!

Fixes: f31e5f70919f ("btrfs: switch to iomap_dio_rw() for dio")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/btrfs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 575636f6491e..68b95ad82126 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -14,6 +14,7 @@ config BTRFS_FS
 	select LZO_DECOMPRESS
 	select ZSTD_COMPRESS
 	select ZSTD_DECOMPRESS
+	select FS_IOMAP
 	select RAID6_PQ
 	select XOR_BLOCKS
 	select SRCU
-- 
2.26.2

