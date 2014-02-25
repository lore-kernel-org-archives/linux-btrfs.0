Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:35552 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbaBYP2p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 10:28:45 -0500
Received: by mail-yh0-f47.google.com with SMTP id c41so7097802yho.34
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Feb 2014 07:28:45 -0800 (PST)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH] [RFC] btrfs-progs: Expand BUG_ON/WARN_ON Macros
Date: Tue, 25 Feb 2014 09:28:38 -0600
Message-Id: <1393342118-22771-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm providing this patch as an example of how to expand the
BUG_ON/WARN_ON macros to provide more information or extra
capabilities.

Josef Bacik has been working on working with a user on IRC
to recover data from a btrfs volume, and the 'work-in-progress'
solution involved expanding the BUG_ON/WARN_ON macros in a
different method that would lose the information on where
the BUG_ON/WARN_ON occured.

When the macro is structured like this patch, it will still
provide the location of the BUG_ON/WARN_ON in the code.

This patch also highlights that BUG_ON and WARN_ON are the
same thing in btrfs-progs.  All WARN_ONs are treated the same
as BUG_ONs, and the program is halted.

Should we convert all our btrfs-progs WARN_ONs to BUG_ONs to
allow us to implement a true WARN_ON functionality?

Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
---
 kerncompat.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kerncompat.h b/kerncompat.h
index f370cd8..79661f5 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -233,9 +233,19 @@ static inline long IS_ERR(const void *ptr)
 #define kstrdup(x, y) strdup(x)
 #define kfree(x) free(x)
 
-#define BUG_ON(c) assert(!(c))
-#define WARN_ON(c) assert(!(c))
+#define BUG_ON(c) do { \
+	if (c) { \
+		fprintf(stderr, "BUG_ON!\n"); \
+		assert(!(c)); \
+	} \
+} while (0)
 
+#define WARN_ON(c) do { \
+	if (c) { \
+		fprintf(stderr, "WARN_ON!\n"); \
+		assert(!(c)); \
+	} \
+} while (0)
 
 #define container_of(ptr, type, member) ({                      \
         const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
-- 
1.8.3.2

