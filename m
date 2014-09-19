Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38961 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaISJBq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 05:01:46 -0400
Received: by mail-pa0-f46.google.com with SMTP id kq14so3448887pab.5
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 02:01:45 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] Return a value from printk_ratelimited
Date: Fri, 19 Sep 2014 02:01:29 -0700
Message-Id: <3629aa32fd3e434e41e5e5f4a97ab50adb8edcdc.1411116672.git.osandov@osandov.com>
In-Reply-To: <cover.1411116672.git.osandov@osandov.com>
References: <cover.1411116672.git.osandov@osandov.com>
In-Reply-To: <cover.1411116672.git.osandov@osandov.com>
References: <cover.1411116672.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

printk returns an integer; there's no reason for printk_ratelimited to swallow
it.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 include/linux/printk.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index d78125f..67534bc 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -343,12 +343,14 @@ extern asmlinkage void dump_stack(void) __cold;
 #ifdef CONFIG_PRINTK
 #define printk_ratelimited(fmt, ...)					\
 ({									\
+	int __ret = 0;							\
 	static DEFINE_RATELIMIT_STATE(_rs,				\
 				      DEFAULT_RATELIMIT_INTERVAL,	\
 				      DEFAULT_RATELIMIT_BURST);		\
 									\
 	if (__ratelimit(&_rs))						\
-		printk(fmt, ##__VA_ARGS__);				\
+		__ret = printk(fmt, ##__VA_ARGS__);			\
+	__ret;								\
 })
 #else
 #define printk_ratelimited(fmt, ...)					\
-- 
2.1.0

