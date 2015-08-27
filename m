Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33403 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbbH0Pif (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 11:38:35 -0400
Received: by pacti10 with SMTP id ti10so29973273pac.0
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 08:38:34 -0700 (PDT)
Received: from arch-nb.localdomain ([175.118.89.137])
        by smtp.gmail.com with ESMTPSA id vw6sm2844831pab.14.2015.08.27.08.38.32
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 27 Aug 2015 08:38:33 -0700 (PDT)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: fix memory leak in btrfs-map-logical main()
Date: Fri, 28 Aug 2015 00:38:17 +0900
Message-Id: <1440689898-35178-3-git-send-email-bhlee.kernel@gmail.com>
In-Reply-To: <1440689898-35178-1-git-send-email-bhlee.kernel@gmail.com>
References: <1440689898-35178-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs-map-logical main(), strdup() allocates memory to output_file,
but that memory is not freed.
So add missing free() calls before return.

Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
---
 btrfs-map-logical.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index a88e56e39dbb..d9fa6b29d3c9 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -262,6 +262,7 @@ int main(int ac, char **av)
 	root = open_ctree(dev, 0, 0);
 	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
+		free(output_file);
 		exit(1);
 	}
 
@@ -354,6 +355,7 @@ out_close_fd:
 	if (output_file && out_fd != 1)
 		close(out_fd);
 close:
+	free(output_file);
 	close_ctree(root);
 	if (ret < 0)
 		ret = 1;
-- 
2.5.0

