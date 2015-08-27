Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35182 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbbH0Pic (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 11:38:32 -0400
Received: by pacdd16 with SMTP id dd16so29303815pac.2
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 08:38:32 -0700 (PDT)
Received: from arch-nb.localdomain ([175.118.89.137])
        by smtp.gmail.com with ESMTPSA id vw6sm2844831pab.14.2015.08.27.08.38.30
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 27 Aug 2015 08:38:31 -0700 (PDT)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: fix memory leak in btrfs-convert main()
Date: Fri, 28 Aug 2015 00:38:16 +0900
Message-Id: <1440689898-35178-2-git-send-email-bhlee.kernel@gmail.com>
In-Reply-To: <1440689898-35178-1-git-send-email-bhlee.kernel@gmail.com>
References: <1440689898-35178-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs-convert main(), strdup() allocates memory to fslabel but that
memory is not freed. We could fix it by adding free() calls to every
return point, but that would make the code messy because there are
several return paths.
So I fix it by changing the code using strdup() with local array and
strncpy().

And btrfs-convert main() guarantees that string length of fslabel is not
to exceed 'BTRFS_LABEL_SIZE', so it's enough to use strcpy() instead of
strncpy() to copy fslabel in do_convert().

Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
---
 btrfs-convert.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 917bbc1b74d2..25ae424ea73b 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2428,7 +2428,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 		fprintf(stderr, "copy label '%s'\n",
 				root->fs_info->super_copy->label);
 	} else if (copylabel == -1) {
-		strncpy(root->fs_info->super_copy->label, fslabel, BTRFS_LABEL_SIZE);
+		strcpy(root->fs_info->super_copy->label, fslabel);
 		fprintf(stderr, "set label to '%s'\n", fslabel);
 	}
 
@@ -2868,7 +2868,7 @@ int main(int argc, char *argv[])
 	int usage_error = 0;
 	int progress = 1;
 	char *file;
-	char *fslabel = NULL;
+	char fslabel[BTRFS_LABEL_SIZE+1];
 	u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
 
 	while(1) {
@@ -2910,8 +2910,9 @@ int main(int argc, char *argv[])
 				break;
 			case 'l':
 				copylabel = -1;
-				fslabel = strdup(optarg);
-				if (strlen(fslabel) > BTRFS_LABEL_SIZE) {
+				fslabel[BTRFS_LABEL_SIZE] = 0;
+				strncpy(fslabel, optarg, sizeof(fslabel));
+				if (fslabel[BTRFS_LABEL_SIZE]) {
 					fprintf(stderr,
 						"warning: label too long, trimmed to %d bytes\n",
 						BTRFS_LABEL_SIZE);
-- 
2.5.0

