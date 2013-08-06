Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab3HFStH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 14:49:07 -0400
Date: Tue, 6 Aug 2013 11:49:04 -0700
From: Zach Brown <zab@redhat.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: don't overrun "answer" array in cmds-chunk.c
Message-ID: <20130806184904.GN12314@lenny.home.zabbo.net>
References: <52006509.1060207@redhat.com>
 <20130806035757.GL12314@lenny.home.zabbo.net>
 <5200905A.4080607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5200905A.4080607@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > If you're in here, want to reimplement this thing in a few lines of
> > scanf(%s) and strcasecmp()?  I can give it a go if you don't want to.
> 
> I think it is better that moving it to utils.c because the other commands
> may use it in the future.

I disagree.  Let's stick to only writing the code that we need.
Implementing and testing code that meets future needs that we make up
isn't a good use of our time.  If someone has to tweak this in the
future, so be it.  They'll actually be in a position to implement and
test their needs.

Anyway, here's how I'd do a trivial y/n prompt.

- z

>From 2c46c2b81061f1c55de07a80d9d177a7df7b33cb Mon Sep 17 00:00:00 2001
From: Zach Brown <zab@redhat.com>
Date: Tue, 6 Aug 2013 11:30:21 -0700
Subject: [PATCH] btrfs-progs: simplify ask_user()

Eric noticed the trivial stack overflow bug in ask_user().  I went to
see the context for that fix and found that ask_user() was a bit much.

This fixes the overflow bug that Eric found, endless spinning on scanf()
errors, removes dead code, and leaves us with a trivial helper.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 cmds-chunk.c | 65 +++++++++++++-----------------------------------------------
 1 file changed, 14 insertions(+), 51 deletions(-)

diff --git a/cmds-chunk.c b/cmds-chunk.c
index 03314de..35a5c69 100644
--- a/cmds-chunk.c
+++ b/cmds-chunk.c
@@ -1307,58 +1307,22 @@ fail_close_fd:
 	return ret;
 }
 
-static int ask_user(char *question, int defval)
+/*
+ * This reads a line from the stdin and only returns non-zero if the
+ * first whitespace delimited token is a case insensitive match with yes
+ * or y.
+ */
+static int ask_user(char *question)
 {
-	char answer[5];
-	char *defstr;
-	int i;
-
-	if (defval == 1)
-		defstr = "[Y/n]";
-	else if (defval == 0)
-		defstr = "[y/N]";
-	else if (defval == -1)
-		defstr = "[y/n]";
-	else
-		BUG_ON(1);
-again:
-	printf("%s%s? ", question, defstr);
-
-	i = 0;
-	while (i < 4 && scanf("%c", &answer[i])) {
-		if (answer[i] == '\n') {
-			answer[i] = '\0';
-			break;
-		} else if (answer[i] == ' '){
-			answer[i] = '\0';
-			if (i == 0)
-				continue;
-			else
-				break;
-		} else if (answer[i] >= 'A' && answer[i] <= 'Z') {
-			answer[i] += 'a' - 'A';
-		}
-		i++;
-	}
-	answer[5] = '\0';
-	__fpurge(stdin);
-
-	if (strlen(answer) == 0) {
-		if (defval != -1)
-			return defval;
-		else
-			goto again;
-	}
+	char buf[30] = {0,};
+	char *saveptr = NULL;
+	char *answer;
 
-	if (!strcmp(answer, "yes") ||
-	    !strcmp(answer, "y"))
-		return 1;
-
-	if (!strcmp(answer, "no") ||
-	    !strcmp(answer, "n"))
-		return 0;
+	printf("%s [y/N]: ", question);
 
-	goto again;
+	return fgets(buf, sizeof(buf) - 1, stdin) &&
+	       (answer = strtok_r(buf, " \t\n\r", &saveptr)) &&
+	       (!strcasecmp(answer, "yes") || !strcasecmp(answer, "y"));
 }
 
 static int btrfs_get_device_extents(u64 chunk_object,
@@ -1752,8 +1716,7 @@ static int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
 	}
 
 	if (!rc.yes) {
-		ret = ask_user("We are going to rebuild the chunk tree on disk, it might destroy the old metadata on the disk, Are you sure",
-			       0);
+		ret = ask_user("We are going to rebuild the chunk tree on disk, it might destroy the old metadata on the disk, Are you sure?");
 		if (!ret) {
 			ret = BTRFS_CHUNK_TREE_REBUILD_ABORTED;
 			goto fail_close_ctree;
-- 
1.7.11.7

