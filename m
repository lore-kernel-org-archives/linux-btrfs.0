Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47731 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2KTG1C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Nov 2012 01:27:02 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so5628658obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2012 22:27:00 -0800 (PST)
Message-ID: <50AB22A6.6070203@gmail.com>
Date: Tue, 20 Nov 2012 14:26:46 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: print the right mount checking info in restore.c
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The mount status is checked against the arg <device> (argv[optind]),
not the <directory>. Correct the info printed on <device> mounted.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 restore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/restore.c b/restore.c
index b9e5381..a7580f8 100644
--- a/restore.c
+++ b/restore.c
@@ -827,7 +827,7 @@ int main(int argc, char **argv)
 			strerror(ret));
 		return ret;
 	} else if (ret) {
-		fprintf(stderr, "%s is currently mounted.  Aborting.\n", argv[optind + 1]);
+		fprintf(stderr, "%s is currently mounted.  Aborting.\n", argv[optind]);
 		return -EBUSY;
 	}

-- 
1.7.5.4
