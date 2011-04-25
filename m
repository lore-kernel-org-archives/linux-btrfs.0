From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: [PATCH 2/5] Support the new parameters in do_clone(int argc, char** argv).
Date: Mon, 25 Apr 2011 15:47:58 +0200
Message-ID: <1303739282-1675-3-git-send-email-philipp.andreas@gmail.com>
References: <1303733730-sup-9388@think>
 <1303739282-1675-1-git-send-email-philipp.andreas@gmail.com>
Cc: Andreas Philipp <philipp.andreas@gmail.com>,
	chris.mason@oracle.com, dcrmorgado@gmail.com, lizf@cn.fujitsu.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303739282-1675-1-git-send-email-philipp.andreas@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Now 'btrfs subvolume snapshot' takes not two but only at least two
parameters. Additionally, the help message is updated accordingly.

Signed-off-by: Andreas Philipp <philipp.andreas@gmail.com>
---
 btrfs.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 46314cf..f70d64b 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -44,9 +44,9 @@ static struct Command commands[] = {
 	/*
 		avoid short commands different for the case only
 	*/
-	{ do_clone, 2,
-	  "subvolume snapshot", "<source> [<dest>/]<name>\n"
-		"Create a writable snapshot of the subvolume <source> with\n"
+	{ do_clone, -2,
+	  "subvolume snapshot", "[-r] <source> [<dest>/]<name>\n"
+		"Create a writable/readonly snapshot of the subvolume <source> with\n"
 		"the name <name> in the <dest> directory."
 	},
 	{ do_delete_subvolume, 1,
-- 
1.7.4.1

