Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:32826 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933518AbdDHA6b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 20:58:31 -0400
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
Subject: [PATCH 01/12] fs: f2fs: Use ktime_get_real_seconds for sit_info times
Date: Fri,  7 Apr 2017 17:56:59 -0700
Message-Id: <1491613030-11599-2-git-send-email-deepa.kernel@gmail.com>
In-Reply-To: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
References: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

CURRENT_TIME_SEC is not y2038 safe.

Replace use of CURRENT_TIME_SEC with ktime_get_real_seconds
in segment timestamps used by GC algorithm including the
segment mtime timestamps.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/f2fs/segment.c | 2 +-
 fs/f2fs/segment.h | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 010324c..0531500 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2678,7 +2678,7 @@ static int build_sit_info(struct f2fs_sb_info *sbi)
 	sit_i->dirty_sentries = 0;
 	sit_i->sents_per_block = SIT_ENTRY_PER_BLOCK;
 	sit_i->elapsed_time = le64_to_cpu(sbi->ckpt->elapsed_time);
-	sit_i->mounted_time = CURRENT_TIME_SEC.tv_sec;
+	sit_i->mounted_time = ktime_get_real_seconds();
 	mutex_init(&sit_i->sentry_lock);
 	return 0;
 }
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 57e36c1..156afc3 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -692,8 +692,9 @@ static inline void set_to_next_sit(struct sit_info *sit_i, unsigned int start)
 static inline unsigned long long get_mtime(struct f2fs_sb_info *sbi)
 {
 	struct sit_info *sit_i = SIT_I(sbi);
-	return sit_i->elapsed_time + CURRENT_TIME_SEC.tv_sec -
-						sit_i->mounted_time;
+	time64_t now = ktime_get_real_seconds();
+
+	return sit_i->elapsed_time + now - sit_i->mounted_time;
 }
 
 static inline void set_summary(struct f2fs_summary *sum, nid_t nid,
-- 
2.7.4

