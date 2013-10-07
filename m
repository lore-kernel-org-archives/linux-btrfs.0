Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab3JGVnR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 17:43:17 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r97LhHcw017194
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 17:43:17 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 07/12] btrfs-progs: free eb in fixup_chunk_tree_block()
Date: Mon,  7 Oct 2013 14:43:00 -0700
Message-Id: <1381182185-10896-8-git-send-email-zab@redhat.com>
In-Reply-To: <1381182185-10896-1-git-send-email-zab@redhat.com>
References: <1381182185-10896-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This was found by static analysis.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 btrfs-image.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/btrfs-image.c b/btrfs-image.c
index 03ad4e9..d10447f 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -1541,6 +1541,7 @@ next:
 		bytenr += mdres->leafsize;
 	}
 
+	free(eb);
 	return 0;
 }
 
-- 
1.7.11.7

