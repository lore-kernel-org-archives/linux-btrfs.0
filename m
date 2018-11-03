Return-Path: <SRS0=HXCT=NO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40AE8C6786F
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 15:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1151D2082E
	for <linux-btrfs@archiver.kernel.org>; Sat,  3 Nov 2018 15:40:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1151D2082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbeKDAwW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 3 Nov 2018 20:52:22 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:44343 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbeKDAwW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2018 20:52:22 -0400
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MhFpq-1ffnn81P50-00ePyg; Sat, 03 Nov 2018 16:39:44 +0100
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MhFpq-1ffnn81P50-00ePyg; Sat, 03 Nov 2018 16:39:44 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Changbin Du <changbin.du@gmail.com>,
        Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Qu Wenruo <wqu@suse.com>, Gu Jinxiang <gujx@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: avoid link error with CONFIG_NO_AUTO_INLINE
Date:   Sat,  3 Nov 2018 16:39:28 +0100
Message-Id: <20181103153941.1881966-1-arnd@arndb.de>
X-Mailer: git-send-email 2.18.0
X-Provags-ID: V03:K1:o0s43alg2CmSZfnHbceckR/8/LE9rv/C42zZLrgYHG1pe/hSYLS
 l7DsR63kDoDr8oejtdztazlLiftwKcou/yKTcE8ghJxPCEgm95spinPfGNYQ4QsrDOhRaPF
 ZFe6UZgU0IEoyMCW+qwANns0ONbznDXpDSan1JopqXEPbHy3ZuEl7K9H35H6IdsVCmhnPkE
 aqYyDq1lJYEEMYfv3gf7A==
X-UI-Out-Filterresults: notjunk:1;V01:K0:CfvA1z32yn0=:lgyLCsLsPtMfoX+ESveCQo
 WMNZlcHP+8dfgneCVsdgIQgDoO4Wd52RtSFkaYle/yqqLRltXA0lwYmKXtn+x9S3Y+paqt6k3
 ZGO89Thaytv3a7iX+CCISIsMN+CQOpXz6yZwPBoB+JmFmkTmb3NrJJojYL4HN5h9s7/31Wz1l
 K7Zg3R6x/tZNQXRws0V6S1rW3Vc7SGsBi5pZNTQMTlt/blKu7+g7Ncx0KklIh14cISmd/CRQ2
 iC3nWF2JLx/Kli1A6Ph5U+hYCgp8fBII0CKiCZSFr+qfk88qlmcUQHDnObymn2NXfz7MGc3p8
 xGdWaBI+y6tVvvk/TyFMmvLUOiNHnjpZM9LhSVVTiMxptbwaY5s1CBA27Lpg/CP9Rd0RGpsHF
 NsiugMS6tAbhS/ohr6QEGZ3CoiTY+JStiQtjLWgTegwxzVCjmyI0YS3YwfshnAJCBYoIm6Df4
 4NdquzF2YCt50+0h5iooD9Hl6Bq4ka1/Ep8klq3M5iUiS3fACxjjU04wM63OfykW71riuajhR
 uixFSuzPdTcpMUMgEzLbkkktNcBn1iAchlnZPey8PNMK1pwXg2qMKQwuT3zI+ZxZFP8qvgt2K
 dj9Mme1iYUKaUycZ0YgFVkhaRxVol/pFy+OuJ6SZ+1zwerTMjxyZTk74yiOgUICd3PlvEgfES
 JGBr/Rx68k+ePY+bxJaebKugYso/4yUpvc+8bqTGGwQxWt3WMErYu5k5jRnzZ6Jy6VHg=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 32-bit ARM with gcc-8, I see a link error with the addition of the
CONFIG_NO_AUTO_INLINE option:

fs/btrfs/super.o: In function `btrfs_statfs':
super.c:(.text+0x67b8): undefined reference to `__aeabi_uldivmod'
super.c:(.text+0x67fc): undefined reference to `__aeabi_uldivmod'
super.c:(.text+0x6858): undefined reference to `__aeabi_uldivmod'
super.c:(.text+0x6920): undefined reference to `__aeabi_uldivmod'
super.c:(.text+0x693c): undefined reference to `__aeabi_uldivmod'
fs/btrfs/super.o:super.c:(.text+0x6958): more undefined references to `__aeabi_uldivmod' follow

So far this is the only file that shows the behavior, so I'd propose
to just work around it by marking the functions as 'static inline'
that normally get inlined here.

The reference to __aeabi_uldivmod comes from a div_u64() which has an
optimization for a constant division that uses a straight '/' operator
when the result should be known to the compiler. My interpretation is
that as we turn off inlining, gcc still expects the result to be constant
but fails to use that constant value.

Cc: Changbin Du <changbin.du@gmail.com>
Fixes: 943b8435c3bd ("kernel hacking: add a config option to disable compiler auto-inlining")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/btrfs/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c3c1e7bee49d..b7af0b8936ad 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1922,7 +1922,7 @@ static int btrfs_remount(struct super_block *sb, int *flags,
 }
 
 /* Used to sort the devices by max_avail(descending sort) */
-static int btrfs_cmp_device_free_bytes(const void *dev_info1,
+static inline int btrfs_cmp_device_free_bytes(const void *dev_info1,
 				       const void *dev_info2)
 {
 	if (((struct btrfs_device_info *)dev_info1)->max_avail >
@@ -1951,8 +1951,8 @@ static inline void btrfs_descending_sort_devices(
  * The helper to calc the free space on the devices that can be used to store
  * file data.
  */
-static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
-				       u64 *free_bytes)
+static inline int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
+					      u64 *free_bytes)
 {
 	struct btrfs_device_info *devices_info;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
-- 
2.18.0

