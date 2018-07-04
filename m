Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:54872 "EHLO
        mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752889AbeGDTcD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2018 15:32:03 -0400
From: =?UTF-8?q?St=C3=A9phane=20Lesimple?= <stephane_btrfs@lesimple.fr>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?St=C3=A9phane=20Lesimple?= <stephane_btrfs@lesimple.fr>
Subject: [PATCH 1/2] btrfs-progs: fix nanosecs in task_period_start
Date: Wed,  4 Jul 2018 21:20:13 +0200
Message-Id: <1530732014-5449-2-git-send-email-stephane_btrfs@lesimple.fr>
In-Reply-To: <1530732014-5449-1-git-send-email-stephane_btrfs@lesimple.fr>
References: <1530732014-5449-1-git-send-email-stephane_btrfs@lesimple.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a single-line fix on the preexisting task_period_start function.

Signed-off-by: Stéphane Lesimple <stephane_btrfs@lesimple.fr>
---
 task-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/task-utils.c b/task-utils.c
index 12b0002..284cbb3 100644
--- a/task-utils.c
+++ b/task-utils.c
@@ -102,7 +102,7 @@ int task_period_start(struct task_info *info, unsigned int period_ms)
 	info->periodic.wakeups_missed = 0;
 
 	sec = period_ms / 1000;
-	ns = (period_ms - (sec * 1000)) * 1000;
+	ns = (period_ms - (sec * 1000)) * 1000 * 1000;
 	itval.it_interval.tv_sec = sec;
 	itval.it_interval.tv_nsec = ns;
 	itval.it_value.tv_sec = sec;
-- 
2.7.4

