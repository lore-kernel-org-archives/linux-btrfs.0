Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab3JGVnQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 17:43:16 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r97LhFkt000519
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 17:43:16 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 03/12] btrfs-progs: don't overrun name in find-collisions
Date: Mon,  7 Oct 2013 14:42:56 -0700
Message-Id: <1381182185-10896-4-git-send-email-zab@redhat.com>
In-Reply-To: <1381182185-10896-1-git-send-email-zab@redhat.com>
References: <1381182185-10896-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

find_collision() allocates name_len bytes for its sub array so the index
must be less than name_len.  This was found by static analysis.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 btrfs-image.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-image.c b/btrfs-image.c
index b05cf07..7474642 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -314,11 +314,11 @@ static char *find_collision(struct metadump_struct *md, char *name,
 		if (val->sub[i] == 127) {
 			do {
 				i++;
-				if (i > name_len)
+				if (i >= name_len)
 					break;
 			} while (val->sub[i] == 127);
 
-			if (i > name_len)
+			if (i >= name_len)
 				break;
 			val->sub[i]++;
 			if (val->sub[i] == '/')
-- 
1.7.11.7

