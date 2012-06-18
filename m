Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab2FRNXU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jun 2012 09:23:20 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5IDNJul032062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2012 09:23:20 -0400
Received: from localhost.localdomain.com (vpn-8-138.rdu.redhat.com [10.11.8.138])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q5IDNJpZ017897
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2012 09:23:19 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: add a missing spin_lock
Date: Mon, 18 Jun 2012 09:23:18 -0400
Message-Id: <1340025798-2169-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When fixing up the locking in the delayed ref destruction work I accidently
broke the locking myself ;(.  Add back a spin_lock that should be there and
we are now all set.  Thanks,
Btrfs: add a missing spin_lock

When fixing up the locking in the delayed ref destruction work I accidently
broke the locking myself ;(.  Add back a spin_lock that should be there and
we are now all set.  Thanks,

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/disk-io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e1890b1..7b845ff 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3426,6 +3426,7 @@ int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				mutex_unlock(&head->mutex);
 				btrfs_put_delayed_ref(ref);
 
+				spin_lock(&delayed_refs->lock);
 				continue;
 			}
 
-- 
1.7.7.6

