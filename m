Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:16249 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbeHXGIe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Aug 2018 02:08:34 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id A314CAC0110
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Aug 2018 11:35:57 +0900 (JST)
Subject: [PATCH] btrfs: ctree.h: Fix suspicious rcu usage warning in
 btrfs_debug_in_rcu()
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>
CC: Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>
References: <22614.1535039351@warthog.procyon.org.uk>
 <450873e0-2a8a-d757-4c68-f24e6a0466a1@jp.fujitsu.com>
Message-ID: <c79f9ff1-e451-d2b4-a800-738053e47df8@jp.fujitsu.com>
Date: Fri, 24 Aug 2018 11:35:28 +0900
MIME-Version: 1.0
In-Reply-To: <450873e0-2a8a-d757-4c68-f24e6a0466a1@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit 672d599041c8 ("btrfs: Use wrapper macro for rcu string to remove
duplicate code") replaces some open coded rcu string handling with macro.

It turns out that btrfs_debug_in_rcu() is used for the first time and
the macro lacks lock/unlock of rcu string for non debug case
(i.e. when message is not printed), leading suspicious RCU usage warning
when CONFIG_PROVE_RCU is on.

Fix this by adding a wrapper to call lock/unlock for non debug case too.

Fixes: 672d599041c8 ("btrfs: Use wrapper macro for rcu string to remove
duplicate code")
Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/ctree.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 53af9f5253f4..cc8b4ff8dcea 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3390,9 +3390,9 @@ do {									\
 #define btrfs_debug(fs_info, fmt, args...) \
 	btrfs_no_printk(fs_info, KERN_DEBUG fmt, ##args)
 #define btrfs_debug_in_rcu(fs_info, fmt, args...) \
-	btrfs_no_printk(fs_info, KERN_DEBUG fmt, ##args)
+	btrfs_no_printk_in_rcu(fs_info, KERN_DEBUG fmt, ##args)
 #define btrfs_debug_rl_in_rcu(fs_info, fmt, args...) \
-	btrfs_no_printk(fs_info, KERN_DEBUG fmt, ##args)
+	btrfs_no_printk_in_rcu(fs_info, KERN_DEBUG fmt, ##args)
 #define btrfs_debug_rl(fs_info, fmt, args...) \
 	btrfs_no_printk(fs_info, KERN_DEBUG fmt, ##args)
 #endif
@@ -3404,6 +3404,13 @@ do {							\
 	rcu_read_unlock();				\
 } while (0)
 
+#define btrfs_no_printk_in_rcu(fs_info, fmt, args...)	\
+do {							\
+	rcu_read_lock();				\
+	btrfs_no_printk(fs_info, fmt, ##args);		\
+	rcu_read_unlock();				\
+} while (0)
+
 #define btrfs_printk_ratelimited(fs_info, fmt, args...)		\
 do {								\
 	static DEFINE_RATELIMIT_STATE(_rs,			\
-- 
2.14.4
