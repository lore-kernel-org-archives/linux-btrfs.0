Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbbB0Pcr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 10:32:47 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 80FA1AC77
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2015 15:32:46 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: convert: show progress by default
Date: Fri, 27 Feb 2015 16:32:45 +0100
Message-Id: <1425051165-23376-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Agreed by several people, showing progress by default makes sense as
conversion is a one-time and long running action.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 Documentation/btrfs-convert.txt | 2 +-
 btrfs-convert.c                 | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/btrfs-convert.txt b/Documentation/btrfs-convert.txt
index e508c34b4f66..170919706e71 100644
--- a/Documentation/btrfs-convert.txt
+++ b/Documentation/btrfs-convert.txt
@@ -30,7 +30,7 @@ set filesystem label during conversion.
 -L::
 use label from the converted filesystem.
 -p::
-Show progress of conversion.
+Show progress of conversion, on by default.
 
 EXIT STATUS
 -----------
diff --git a/btrfs-convert.c b/btrfs-convert.c
index da10ad668ea6..730fead4a86c 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2759,14 +2759,14 @@ fail:
 
 static void print_usage(void)
 {
-	printf("usage: btrfs-convert [-d] [-i] [-n] [-r] [-l label] [-L] device\n");
+	printf("usage: btrfs-convert [-d] [-i] [-n] [-r] [-l label] [-L] [-p] device\n");
 	printf("\t-d           disable data checksum\n");
 	printf("\t-i           ignore xattrs and ACLs\n");
 	printf("\t-n           disable packing of small files\n");
 	printf("\t-r           roll back to ext2fs\n");
 	printf("\t-l LABEL     set filesystem label\n");
 	printf("\t-L           use label from converted fs\n");
-	printf("\t-p           show converting progress\n");
+	printf("\t-p           show converting progress (default)\n");
 }
 
 int main(int argc, char *argv[])
@@ -2778,7 +2778,7 @@ int main(int argc, char *argv[])
 	int rollback = 0;
 	int copylabel = 0;
 	int usage_error = 0;
-	int progress = 0;
+	int progress = 1;
 	char *file;
 	char *fslabel = NULL;
 
-- 
2.1.3

