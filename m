Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34343 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaK3I07 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 03:26:59 -0500
Received: by mail-pa0-f45.google.com with SMTP id lj1so9143989pab.32
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 00:26:59 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 1/3] rcustring: clean up botched __rcu annotations
Date: Sun, 30 Nov 2014 00:26:47 -0800
Message-Id: <7e64d06eeb464f70319ef85a19e3d7095fbdc2f8.1417335583.git.osandov@osandov.com>
In-Reply-To: <cover.1417335583.git.osandov@osandov.com>
References: <cover.1417335583.git.osandov@osandov.com>
In-Reply-To: <cover.1417335583.git.osandov@osandov.com>
References: <cover.1417335583.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The rcu_string returned by rcu_string_strdup isn't technically under RCU yet,
and it makes more sense not to treat it as such. Additionally, an rcu_string
passed to rcu_string_free should already be rcu_dereferenced and therefore not
in the __rcu address space.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 include/linux/rcustring.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/rcustring.h b/include/linux/rcustring.h
index 67277ab..28bd9bc 100644
--- a/include/linux/rcustring.h
+++ b/include/linux/rcustring.h
@@ -37,8 +37,7 @@ struct rcu_string {
  * @src: The string to copy
  * @flags: Flags for kmalloc
  */
-static inline struct rcu_string __rcu *rcu_string_strdup(const char *src,
-							 gfp_t flags)
+static inline struct rcu_string *rcu_string_strdup(const char *src, gfp_t flags)
 {
 	struct rcu_string *ret;
 	size_t len = strlen(src) + 1;
@@ -54,7 +53,7 @@ static inline struct rcu_string __rcu *rcu_string_strdup(const char *src,
  * rcu_string_free() - free an RCU string
  * @str: The string
  */
-static inline void rcu_string_free(struct rcu_string __rcu *str)
+static inline void rcu_string_free(struct rcu_string *str)
 {
 	if (str)
 		kfree_rcu(str, rcu);
-- 
2.1.3

