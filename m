Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933414Ab3HNXRX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 19:17:23 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7ENHN9P014651
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:23 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7ENHKSt017824
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:22 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/15] btrfs-progs: fix qgroup realloc inheritance
Date: Wed, 14 Aug 2013 16:16:40 -0700
Message-Id: <1376522205-16992-11-git-send-email-zab@redhat.com>
In-Reply-To: <1376522205-16992-1-git-send-email-zab@redhat.com>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

qgroup.c:82:23: warning: memcpy with byte count of 0
qgroup.c:83:23: warning: memcpy with byte count of 0

The inheritance wasn't copying qgroups[] because a confused sizeof()
gave 0 byte memcpy()s.  It's been like this for the year since it was
merged, so I guess this isn't a very important thing to do :).

Signed-off-by: Zach Brown <zab@redhat.com>
---
 qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/qgroup.c b/qgroup.c
index 038c4dc..86fe2b2 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -74,7 +74,7 @@ qgroup_inherit_realloc(struct btrfs_qgroup_inherit **inherit, int n, int pos)
 
 	if (*inherit) {
 		struct btrfs_qgroup_inherit *i = *inherit;
-		int s = sizeof(out->qgroups);
+		int s = sizeof(out->qgroups[0]);
 
 		out->num_qgroups = i->num_qgroups;
 		out->num_ref_copies = i->num_ref_copies;
-- 
1.7.11.7

