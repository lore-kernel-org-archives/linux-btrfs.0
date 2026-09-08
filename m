Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B291C2FC037
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 01:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788830422; cv=none; b=E2OytP62TSYsYhK/bCnPa8v/rdUdgXHplO+S6YPpTLIf7bQeEVMjWwBKPoYhz8lyd861X/WsmckOIBz2JrWtib+8es4zXAU2YNNvIZPgUDSegKtEni07S6dMP42VVIqpUXJ89b00UjWdwLxy5NtOXcUi95N16UJCk9wH06nzloc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788830422; c=relaxed/simple;
	bh=s/LxtVbEHOVYU4ldcfT6uxuIsoUevA4AeoG9wWw8HQM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=j3PWoDdMqCFGydrqtmeSQXD8VGshwm3ler2klpdUbPuBs4mMGlHCJjNXuOw0GvyEPZdeEwYVlLaJOuQu9EGEBtGsWa+yGc1+EpnFGpyJd83cfGPKMAVIZnAKzPHK5NAio/mMxOjqKugSaJD6UgE1w1udNltj5fIrlwuEmx0WTuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=pYD6c9Et; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=PRoK9h44; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="pYD6c9Et";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="PRoK9h44"
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6880uY103474058
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 21:20:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=l/YP
	Y/lrskj2rohGcIbRXYzqjPjjZ5iVqxwDPnvnGKU=; b=pYD6c9EtKYnTj9nXe0Na
	9YZJZnyW24qrY6yC5DjwNbjHBl9RTd24VeGfItcnxdoaUnnAtv/Peb4tBrns8gUf
	cr42QCf+CGABkjOAAuveh+w5DcBxh49ikCdVWB2NcZl8i9G30V4d4G2loGvIKcO0
	MuGg7XtodF4UMedboRUiZl2+2AfzsQdjXnaER1tTEoV0r+VUFn9Tx1ldZFn4Z5LE
	U7c+GtjSz4Ioj//sCvE8FYBeeZCzaSplpFAi140tTNgC8KFyRC1T1SHEinzxV7vV
	PIYDRodBfwBZ5BraG+4DEdIDlqKOWb4clEgNtckOIgmj9LvFnAqEhP9JEtBERHXu
	8Q==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj50j10qv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 21:20:02 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-90e7db8d191so91527036d6.1
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 18:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788830401; x=1789435201; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l/YPY/lrskj2rohGcIbRXYzqjPjjZ5iVqxwDPnvnGKU=;
        b=PRoK9h44pIKiPivj8TPWwjneVR+ILgDHOycEE3lW4S3EMR0VEuSnuXL1oBIqFOU3a8
         h/hki7xqStY1tMYDBXZkHW0mSYPWtO/4UEv1ztEGSg77ePZRBTVm2tb16O1/AZrQHmL5
         XSgpnUsgSj7TSmKIelLNnwD34nmR+EhDvxarQRCKssq3mwnoABBG7KNfm+YIyiROth5q
         QqpHpmUMtLCZ8afx5+l60lLtniUyYdFr+J2u0HdfAD+IVEHjdlccZFjxRGrdobvMR5Ic
         l2Yov6t1MSm5dfk7Pon+AKAIpQ6rXPv+CIDISoNC9u8vAHp7N9kn6X6VbN2uPAS6NnDU
         FYyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788830401; x=1789435201;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l/YPY/lrskj2rohGcIbRXYzqjPjjZ5iVqxwDPnvnGKU=;
        b=n5uWoM08P5cCq4By1RVno1BrODDYDWOh3Gpk5hUJs5KP5KlCHGAkMHgdwdQv49Ofuh
         wH8vA8s3LKCpyhGbZzFX0JK87aVFKyqLl4ugevUibqXG4BBob4mtAhX06m+kiqRT2maX
         twvxi1twfJ1FcSpZtrWsM9dFg02x9IAIvIzlDeMKn+bfpT0qX0/+b2+1xMk4kKh9Emdv
         1NSZ7HWvmq7DR4mWQqIRSI76RdS6zpMFWa4L7ymh1VEy1QtrkHnkK2qM6+yCkkxfJmCJ
         AZfHUzcD/+XKurg5vqWw8OETM+3fL41acYekyMmfEmw7ppedD38m3QLed2fMOgGeI6fp
         x99A==
X-Gm-Message-State: AFuF++lIVJGKvU3GJytP2szEaFJWn/K0U/yFeSXinHgi9FNdgDpXLHUP
	ttTK2hbnS1QYl4GDck1TOoDBQTPg04166v5M4HT5Okaunv4j13SUanbqLuahq9m+Cj41Vj2ZTkS
	qRIAAM047aPQifVBpJYaBvKGlcyZfZ7maxVTHQKMTUwGB9KgDdBRyQD981rmF
X-Gm-Gg: AYBFou2SzvL0XZlx8ijG/7wSjO4FozzWLjCEIhE5gQrl5tdPRmj6DTKOtrWlzbWzA7w
	J1xYXO2FEh3EFmGwFgiUZiYXw+GdF3zn2jcjHBCRxrAmVZIj/Kk117m41veYpuOaFR/rbjWmbY6
	TsNV5td+Yc9lcQvc0j4S9N6sIyBfhliL6NbEk4GMoBUoBotGmv5d23voi1nB9wVx+3O7ZkBLd73
	frOttMkUBO6VFHTXUJYYsUzUnq0NP+EcYPLeUjEEiXzo7SfrpDR86on4PoKyhbY645HmUVFhgtI
	uPhXK4WE8xrFN/8Ndg8r2GzyvNYgkNeXGv+CSGufYINO1HOHPoOm58uqrvFhAAKb/zfBZS8RPqi
	Tqb7hj5Kn16neH0zM17znixi81YW+Ru2FdQrsy6IpIpYM45udp18=
X-Received: by 2002:a05:6214:2d44:b0:910:3179:733d with SMTP id 6a1803df08f44-9103efa0f2dmr347751566d6.25.1788830400971;
        Mon, 07 Sep 2026 18:20:00 -0700 (PDT)
X-Received: by 2002:a05:6214:2d44:b0:910:3179:733d with SMTP id 6a1803df08f44-9103efa0f2dmr347751096d6.25.1788830400465;
        Mon, 07 Sep 2026 18:20:00 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040694543sm104322656d6.33.2026.09.07.18.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 18:19:59 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 07 Sep 2026 21:19:27 -0400
Subject: [PATCH 12/15] btrfs: remove the free space inode ordered extent
 special cases
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-btrfs-remove-v1-space-cache-v1-12-5f9a5ba352a7@columbia.edu>
References: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
In-Reply-To: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788830387; l=8736;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=s/LxtVbEHOVYU4ldcfT6uxuIsoUevA4AeoG9wWw8HQM=;
 b=kFlzncNEXuP05FmgxaKPgQZYgjbI2ohfym11arl5rQVpOk7ZvF2RKvdixZKmKJkVWAlWbjb8R
 QzP2rF1uk0cCxPjOUXmhIduFSpH1Xl6EPC2n8Tdoaz70PB5JRXLjJBB
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDAxMiBTYWx0ZWRfX8qCdt7bstAvk
 msva30faTcW56WuUWEjmwHNB3H5J2D5UAUHzwKWvTcMYh0Q3/3wyZPKlteeFtgYUb+EG9+w99ra
 m2A5U0oiEPo5V90oDYLOcAewfQfBG50xWlPPUS3vk3S4hpDnuRo2+XVMj7/mwdVXwM+ZCZ/rLXi
 lkeFICBgToeAmRqVAPWqcne+PpFui3f8DAHN+h/5r4L31jskloLghJ+CmfCpuqT3YqKyKhQD3/n
 lx9GZONJFdp07904tSWd4ADUUx+a98rp7QeviGd0HiaALrMkjUY7FNsueALolD/SXNJArKkF9RB
 P8Ayeva5K7FaR3CFaXSGMqYavuvqD1YW0cgCDA1v6NcaAngdUD9j06V79XMxnpabxXc/zelk0Zz
 wFGd4+9l/PSYOPc5In82CZjXoGoyjxtHkAtqBHn7nEhHclvCPqg33g+/D4GlpZ7ui/yxWji85OW
 K/vn9sLPvsuACUEJGaQ==
X-Proofpoint-ORIG-GUID: IYUGHi9qEwiHpdEXK5ISBQB-cDhr1e_P
X-Proofpoint-GUID: IYUGHi9qEwiHpdEXK5ISBQB-cDhr1e_P
X-Authority-Analysis: v=2.4 cv=O7gJeh9W c=1 sm=1 tr=0 ts=6a9f62c2 cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=m-LKR5TgjiErI9wjomMA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDAxMiBTYWx0ZWRfX0SpviwhbuXHo
 14o+4bwPwD8ecDp4DVkYCzi1QxD1JLHy/DgwxZ2BaXUAbcoytL5n1XkdVfsMRot8DvRQQLGzYaH
 ycOfb8y+pmC72nb4kYXeBKcgghIoezMPQs4r+eF+k8JzeGdTyLB1
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 clxscore=1015 malwarescore=0 bulkscore=10
 adultscore=0 priorityscore=1501 spamscore=0 impostorscore=10
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080012

Free space inodes never have ordered extents any more. Drop the lockdep
exceptions for them and btrfs_join_transaction_spacecache(), which was
only used to finish their ordered extents during a commit, along with
TRANS_JOIN_NOLOCK.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/inode.c        | 20 +++-----------------
 fs/btrfs/ordered-data.c | 20 ++------------------
 fs/btrfs/transaction.c  | 23 +----------------------
 fs/btrfs/transaction.h  |  3 ---
 4 files changed, 6 insertions(+), 60 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 699a321fc43b..5e4ecd1fe194 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3203,7 +3203,6 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 	int compress_type = 0;
 	int ret = 0;
 	u64 logical_len = ordered_extent->num_bytes;
-	bool freespace_inode;
 	bool truncated = false;
 	bool clear_reserved_extent = true;
 	unsigned int clear_bits = 0;
@@ -3220,9 +3219,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 	if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags))
 		clear_bits |= EXTENT_DEFRAG;
 
-	freespace_inode = btrfs_is_free_space_inode(inode);
-	if (!freespace_inode)
-		btrfs_lockdep_acquire(fs_info, btrfs_ordered_extent);
+	btrfs_lockdep_acquire(fs_info, btrfs_ordered_extent);
 
 	if (unlikely(test_bit(BTRFS_ORDERED_IOERR, &ordered_extent->flags))) {
 		ret = -EIO;
@@ -3257,10 +3254,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 				       &cached_state);
 	}
 
-	if (freespace_inode)
-		trans = btrfs_join_transaction_spacecache(root);
-	else
-		trans = btrfs_join_transaction(root);
+	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		trans = NULL;
@@ -8116,7 +8110,6 @@ void btrfs_destroy_inode(struct inode *vfs_inode)
 	struct btrfs_ordered_extent *ordered;
 	struct btrfs_inode *inode = BTRFS_I(vfs_inode);
 	struct btrfs_root *root = inode->root;
-	bool freespace_inode;
 
 	WARN_ON(!hlist_empty(&vfs_inode->i_dentry));
 	WARN_ON(vfs_inode->i_data.nrpages);
@@ -8139,12 +8132,6 @@ void btrfs_destroy_inode(struct inode *vfs_inode)
 	if (!root)
 		return;
 
-	/*
-	 * If this is a free space inode do not take the ordered extents lockdep
-	 * map.
-	 */
-	freespace_inode = btrfs_is_free_space_inode(inode);
-
 	while (1) {
 		ordered = btrfs_lookup_first_ordered_extent(inode, (u64)-1);
 		if (!ordered)
@@ -8154,8 +8141,7 @@ void btrfs_destroy_inode(struct inode *vfs_inode)
 				  "found ordered extent %llu %llu on inode cleanup",
 				  ordered->file_offset, ordered->num_bytes);
 
-			if (!freespace_inode)
-				btrfs_lockdep_acquire(root->fs_info, btrfs_ordered_extent);
+			btrfs_lockdep_acquire(root->fs_info, btrfs_ordered_extent);
 
 			btrfs_remove_ordered_extent(ordered);
 			btrfs_put_ordered_extent(ordered);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index e9f1cbeb555a..df74c75d6c29 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -654,13 +654,6 @@ void btrfs_remove_ordered_extent(struct btrfs_ordered_extent *entry)
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct rb_node *node;
 	bool pending;
-	bool freespace_inode;
-
-	/*
-	 * If this is a free space inode the thread has not acquired the ordered
-	 * extents lockdep map.
-	 */
-	freespace_inode = btrfs_is_free_space_inode(btrfs_inode);
 
 	btrfs_lockdep_acquire(fs_info, btrfs_trans_pending_ordered);
 	/* This is paired with alloc_ordered_extent(). */
@@ -735,8 +728,7 @@ void btrfs_remove_ordered_extent(struct btrfs_ordered_extent *entry)
 	}
 	spin_unlock(&root->ordered_extent_lock);
 	wake_up(&entry->wait);
-	if (!freespace_inode)
-		btrfs_lockdep_release(fs_info, btrfs_ordered_extent);
+	btrfs_lockdep_release(fs_info, btrfs_ordered_extent);
 }
 
 static void btrfs_run_ordered_extent_work(struct btrfs_work *work)
@@ -867,16 +859,9 @@ void btrfs_start_ordered_extent_nowriteback(struct btrfs_ordered_extent *entry,
 	u64 start = entry->file_offset;
 	u64 end = start + entry->num_bytes - 1;
 	struct btrfs_inode *inode = entry->inode;
-	bool freespace_inode;
 
 	trace_btrfs_ordered_extent_start(inode, entry);
 
-	/*
-	 * If this is a free space inode do not take the ordered extents lockdep
-	 * map.
-	 */
-	freespace_inode = btrfs_is_free_space_inode(inode);
-
 	/*
 	 * pages in the range can be dirty, clean or writeback.  We
 	 * start IO on any dirty ones so the wait doesn't stall waiting
@@ -896,8 +881,7 @@ void btrfs_start_ordered_extent_nowriteback(struct btrfs_ordered_extent *entry,
 		}
 	}
 
-	if (!freespace_inode)
-		btrfs_might_wait_for_event(inode->root->fs_info, btrfs_ordered_extent);
+	btrfs_might_wait_for_event(inode->root->fs_info, btrfs_ordered_extent);
 	wait_event(entry->wait, test_bit(BTRFS_ORDERED_COMPLETE, &entry->flags));
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d2ff3b568eed..232cfa37d2d8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -125,17 +125,14 @@ static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
 	[TRANS_STATE_UNBLOCKED]		= (__TRANS_START |
 					   __TRANS_ATTACH |
 					   __TRANS_JOIN |
-					   __TRANS_JOIN_NOLOCK |
 					   __TRANS_JOIN_NOSTART),
 	[TRANS_STATE_SUPER_COMMITTED]	= (__TRANS_START |
 					   __TRANS_ATTACH |
 					   __TRANS_JOIN |
-					   __TRANS_JOIN_NOLOCK |
 					   __TRANS_JOIN_NOSTART),
 	[TRANS_STATE_COMPLETED]		= (__TRANS_START |
 					   __TRANS_ATTACH |
 					   __TRANS_JOIN |
-					   __TRANS_JOIN_NOLOCK |
 					   __TRANS_JOIN_NOSTART),
 };
 
@@ -310,12 +307,6 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	if (type == TRANS_ATTACH || type == TRANS_JOIN_NOSTART)
 		return -ENOENT;
 
-	/*
-	 * JOIN_NOLOCK only happens during the transaction commit, so
-	 * it is impossible that ->running_transaction is NULL
-	 */
-	BUG_ON(type == TRANS_JOIN_NOLOCK);
-
 	cur_trans = kmalloc_obj(*cur_trans, GFP_NOFS);
 	if (!cur_trans)
 		return -ENOMEM;
@@ -708,14 +699,8 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	}
 
 	/*
-	 * If we are JOIN_NOLOCK we're already committing a transaction and
-	 * waiting on this guy, so we don't need to do the sb_start_intwrite
-	 * because we're already holding a ref.  We need this because we could
-	 * have raced in and did an fsync() on a file which can kick a commit
-	 * and then we deadlock with somebody doing a freeze.
-	 *
 	 * If we are ATTACH, it means we just want to catch the current
-	 * transaction and commit it, so we needn't do sb_start_intwrite(). 
+	 * transaction and commit it, so we needn't do sb_start_intwrite().
 	 */
 	if (type & __TRANS_FREEZABLE)
 		sb_start_intwrite(fs_info->sb);
@@ -853,12 +838,6 @@ struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root)
 				 true);
 }
 
-struct btrfs_trans_handle *btrfs_join_transaction_spacecache(struct btrfs_root *root)
-{
-	return start_transaction(root, 0, TRANS_JOIN_NOLOCK,
-				 BTRFS_RESERVE_NO_FLUSH, true);
-}
-
 /*
  * Similar to regular join but it never starts a transaction when none is
  * running or when there's a running one at a state >= TRANS_STATE_UNBLOCKED.
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 889babc76b68..51633af27894 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -100,7 +100,6 @@ enum {
 	ENUM_BIT(__TRANS_START),
 	ENUM_BIT(__TRANS_ATTACH),
 	ENUM_BIT(__TRANS_JOIN),
-	ENUM_BIT(__TRANS_JOIN_NOLOCK),
 	ENUM_BIT(__TRANS_DUMMY),
 	ENUM_BIT(__TRANS_JOIN_NOSTART),
 };
@@ -108,7 +107,6 @@ enum {
 #define TRANS_START		(__TRANS_START | __TRANS_FREEZABLE)
 #define TRANS_ATTACH		(__TRANS_ATTACH)
 #define TRANS_JOIN		(__TRANS_JOIN | __TRANS_FREEZABLE)
-#define TRANS_JOIN_NOLOCK	(__TRANS_JOIN_NOLOCK)
 #define TRANS_JOIN_NOSTART	(__TRANS_JOIN_NOSTART)
 
 #define TRANS_EXTWRITERS	(__TRANS_START | __TRANS_ATTACH)
@@ -288,7 +286,6 @@ struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 					struct btrfs_root *root,
 					unsigned int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
-struct btrfs_trans_handle *btrfs_join_transaction_spacecache(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nostart(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_attach_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_attach_transaction_barrier(

-- 
2.39.5

