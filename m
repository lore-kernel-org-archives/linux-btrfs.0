Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30202 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594AbbFDVRh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Jun 2015 17:17:37 -0400
Received: from pps.filterd (m0004347 [127.0.0.1])
	by m0004347.ppops.net (8.14.5/8.14.5) with SMTP id t54LGnNT012359
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Jun 2015 14:17:36 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0004347.ppops.net with ESMTP id 1utumu0acn-9
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2015 14:17:36 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: use received_uuid of parent during send
Date: Thu, 4 Jun 2015 17:17:25 -0400
Message-ID: <1433452645-7904-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Neil Horman pointed out a problem where if he did something like this

receive A
snap A B
change B
send -p A B

and then on another box do

recieve A
receive B

the receive B would fail because we use the UUID of A for the clone sources for
B.  This makes sense most of the time because normally you are sending from the
original sources, not a received source.  However when you use a recieved subvol
its UUID is going to be something completely different, so if you then try to
receive the diff on a different volume it won't find the UUID because the new A
will be something else.  The only constant is the received uuid.  So instead
check to see if we have received_uuid set on the root, and if so use that as the
clone source, as btrfs receive looks for matches either in received_uuid or
uuid.  Thanks,

Reported-by: Neil Horman <nhorman@redhat.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/send.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index a1216f9..947d91c 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2328,8 +2328,12 @@ static int send_subvol_begin(struct send_ctx *sctx)
 	TLV_PUT_U64(sctx, BTRFS_SEND_A_CTRANSID,
 		    le64_to_cpu(sctx->send_root->root_item.ctransid));
 	if (parent_root) {
-		TLV_PUT_UUID(sctx, BTRFS_SEND_A_CLONE_UUID,
-				sctx->parent_root->root_item.uuid);
+		if (!btrfs_is_empty_uuid(parent_root->root_item.received_uuid))
+			TLV_PUT_UUID(sctx, BTRFS_SEND_A_CLONE_UUID,
+				     parent_root->root_item.received_uuid);
+		else
+			TLV_PUT_UUID(sctx, BTRFS_SEND_A_CLONE_UUID,
+				     parent_root->root_item.uuid);
 		TLV_PUT_U64(sctx, BTRFS_SEND_A_CLONE_CTRANSID,
 			    le64_to_cpu(sctx->parent_root->root_item.ctransid));
 	}
@@ -4508,8 +4512,21 @@ verbose_printk("btrfs: send_clone offset=%llu, len=%d, clone_root=%llu, "
 	if (ret < 0)
 		goto out;
 
-	TLV_PUT_UUID(sctx, BTRFS_SEND_A_CLONE_UUID,
-			clone_root->root->root_item.uuid);
+	/*
+	 * If the parent we're using has a received_uuid set then use that as
+	 * our clone source as that is what we will look for when doing a
+	 * receive.
+	 *
+	 * This covers the case that we create a snapshot off of a received
+	 * subvolume and then use that as the parent and try to receive on a
+	 * different host.
+	 */
+	if (!btrfs_is_empty_uuid(clone_root->root->root_item.received_uuid))
+		TLV_PUT_UUID(sctx, BTRFS_SEND_A_CLONE_UUID,
+			     clone_root->root->root_item.received_uuid);
+	else
+		TLV_PUT_UUID(sctx, BTRFS_SEND_A_CLONE_UUID,
+			     clone_root->root->root_item.uuid);
 	TLV_PUT_U64(sctx, BTRFS_SEND_A_CLONE_CTRANSID,
 		    le64_to_cpu(clone_root->root->root_item.ctransid));
 	TLV_PUT_PATH(sctx, BTRFS_SEND_A_CLONE_PATH, p);
-- 
1.8.3.1

