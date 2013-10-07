Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab3JGVnS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 17:43:18 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r97LhIci031199
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 17:43:18 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 10/12] btrfs-progs: don't overflow colors[] in fragments
Date: Mon,  7 Oct 2013 14:43:03 -0700
Message-Id: <1381182185-10896-11-git-send-email-zab@redhat.com>
In-Reply-To: <1381182185-10896-1-git-send-email-zab@redhat.com>
References: <1381182185-10896-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stop iteration at the number of elements in the colors[] array when
initializing the elements.  Rather than a magic number.  This was found
by static analysis.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 btrfs-fragments.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-fragments.c b/btrfs-fragments.c
index 4dd9470..cedbc57 100644
--- a/btrfs-fragments.c
+++ b/btrfs-fragments.c
@@ -283,7 +283,7 @@ list_fragments(int fd, u64 flags, char *dir)
 				white = gdImageColorAllocate(im, 255, 255, 255);
 				black = gdImageColorAllocate(im, 0, 0, 0);  
 
-				for (j = 0; j < 10; ++j)
+				for (j = 0; j < ARRAY_SIZE(colors); ++j)
 					colors[j] = black;
 
 				init_colors(im, colors);
-- 
1.7.11.7

