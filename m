Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35787 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934017AbdDHA6w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 20:58:52 -0400
From: Deepa Dinamani <deepa.kernel@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: tglx@linutronix.de, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org,
        andreas.dilger@intel.com, arnd@arndb.de, bfields@fieldses.org,
        clm@fb.com, davem@davemloft.net, dsterba@suse.com, dushistov@mail.ru,
        eparis@redhat.com, jaegeuk@kernel.org, jbacik@fb.com,
        jlayton@poochiereds.net, john.stultz@linaro.org,
        jsimmons@infradead.org, mingo@redhat.com, oleg.drokin@intel.com,
        paul@paul-moore.com, rostedt@goodmis.org, yuchao0@huawei.com,
        ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-audit@redhat.com, linux-btrfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-security-module@vger.kernel.org, lustre-devel@lists.lustre.org,
        netdev@vger.kernel.org, samba-technical@lists.samba.org,
        y2038@lists.linaro.org
Subject: [PATCH 11/12] time: Delete CURRENT_TIME_SEC and CURRENT_TIME
Date: Fri,  7 Apr 2017 17:57:09 -0700
Message-Id: <1491613030-11599-12-git-send-email-deepa.kernel@gmail.com>
In-Reply-To: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
References: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All uses of CURRENT_TIME_SEC and CURRENT_TIME macros have
been replaced by other time functions. These macros are
also not y2038 safe.
And, all their use cases can be fulfilled by y2038 safe
ktime_get_* variants.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Acked-by: John Stultz <john.stultz@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/time.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 23f0f5c..c0543f5 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -151,9 +151,6 @@ static inline bool timespec_inject_offset_valid(const struct timespec *ts)
 	return true;
 }
 
-#define CURRENT_TIME		(current_kernel_time())
-#define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
-
 /* Some architectures do not supply their own clocksource.
  * This is mainly the case in architectures that get their
  * inter-tick times by reading the counter on their interval
-- 
2.7.4

