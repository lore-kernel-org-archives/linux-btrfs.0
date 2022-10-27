Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC0DFA3740
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Oct 2022 06:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbiJ0GUh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 02:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbiJ0GUf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2022 02:20:35 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EFBC8201;
        Wed, 26 Oct 2022 23:20:32 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VTA2Yka_1666851624;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VTA2Yka_1666851624)
          by smtp.aliyun-inc.com;
          Thu, 27 Oct 2022 14:20:30 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     clm@fb.com
Cc:     josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH 1/2] btrfs: Fix kernel-doc
Date:   Thu, 27 Oct 2022 14:20:14 +0800
Message-Id: <20221027062014.54543-2-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
In-Reply-To: <20221027062014.54543-1-jiapeng.chong@linux.alibaba.com>
References: <20221027062014.54543-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

No functional modification involved.

fs/btrfs/ioctl.c:4358: warning: expecting prototype for Try to acquire fs_info:(). Prototype was for btrfs_try_lock_balance() instead.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2604
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 fs/btrfs/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ab847c4ffede..718f9aa3234b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4344,8 +4344,8 @@ void btrfs_update_ioctl_balance_args(struct btrfs_fs_info *fs_info,
 }
 
 /**
- * Try to acquire fs_info::balance_mutex as well as set BTRFS_EXLCOP_BALANCE as
- * required.
+ * btrfs_try_lock_balance - Try to acquire fs_info::balance_mutex as well as set
+ * BTRFS_EXLCOP_BALANCE as required.
  *
  * @fs_info:       the filesystem
  * @excl_acquired: ptr to boolean value which is set to false in case balance
-- 
2.20.1.7.g153144c

