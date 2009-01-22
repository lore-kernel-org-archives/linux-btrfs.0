From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] btrfs-progs: kill check for /'s in labels
Date: Thu, 22 Jan 2009 14:25:44 -0500
Message-ID: <1232652344-3637-1-git-send-email-jbacik@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <>
List-ID: <linux-btrfs.vger.kernel.org>

This patch kills a check in mkfs's label stuff which doesn't allow labels that
have /'s in them.  This causes problems for Anaconda which try to label volumes
with their mountpoints.  Thanks,

Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 mkfs.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index d664254..5ed44cc 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -302,12 +302,6 @@ static char *parse_label(char *input)
 			BTRFS_LABEL_SIZE);
 		exit(1);
 	}
-	for (i = 0; i < len; i++) {
-		if (input[i] == '/' || input[i] == '\\') {
-			fprintf(stderr, "invalid label %s\n", input);
-			exit(1);
-		}
-	}
 	return strdup(input);
 }
 
-- 
1.5.4.3

