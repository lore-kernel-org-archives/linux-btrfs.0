From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] btrfs-progs: kill check for /'s in labels
Date: Thu, 22 Jan 2009 15:01:49 -0500
Message-ID: <20090122200148.GA18830@unused.rdu.redhat.com>
References: <1232652344-3637-1-git-send-email-jbacik@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232652344-3637-1-git-send-email-jbacik@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 22, 2009 at 02:25:44PM -0500, Josef Bacik wrote:
> This patch kills a check in mkfs's label stuff which doesn't allow labels that
> have /'s in them.  This causes problems for Anaconda which try to label volumes
> with their mountpoints.  Thanks,
>

Arrgh sorry, forgot to kill the int i part.  Here's the updated patch, thanks,

Josef

 
diff --git a/mkfs.c b/mkfs.c
index d664254..138bcc9 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -294,7 +294,6 @@ static u64 parse_profile(char *s)
 
 static char *parse_label(char *input)
 {
-	int i;
 	int len = strlen(input);
 
 	if (len > BTRFS_LABEL_SIZE) {
@@ -302,12 +301,6 @@ static char *parse_label(char *input)
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
 
