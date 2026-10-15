Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9762A3C5855
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075433; cv=none; b=FCVhiwuE72jOT+8Hq7qDxeIXO40VhF2/5swC4eDhDNaeNQrfIFPAY0Lq/6JYEesGq058unuXHSud5Xu3Yxi9D5hTRh1Rixa10rXurY3kEZa6x7AHEGGsUB9iDW8+DBHiwhI3HaipJOIq2lIuFn+C9Fb8hRD+ICxbZcr7M9ReqAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075433; c=relaxed/simple;
	bh=rTZzQ2a96A9lf5YW3hyxm+4Hhlv3XhfAOtWqXfOLQK8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PtMu2FvqIJuo36Ve93AZ43XqxHzTKHZyEh0+4v+DRVDWvE5GCmAJMvVAF/etKx7cB4gj8nBqgyOz/6nvM496plXOPNLdaOIZd8eWvZlGzdIYXkVOtHqeNFlHPdnY0+ttr1CY4aNVRN+ATrRxyY64HPyoHkDWmWwS6cr9YdGEzxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Ns/v8Jhg; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=DHEWCTAU; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Ns/v8Jhg";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="DHEWCTAU"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FEYAlm1419272
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=sXpy
	/3ffel3dUUklWIUvdxbmuTLROOFL9w6Ftgsfktg=; b=Ns/v8Jhgcr/gPPEw/oBl
	HF5SgI6WrX+FAZZghAERpCOojypFrouSclu4bB/vBkjwClM3OsbHmj+KUyDhaYVn
	FftbVDzQHSMq1tccx/++8aK9u6Paq3oatzbls4FFQ8DNp46w8jMWJOLqx6p8TJ1V
	QbwJb3ipuIsazlM/WhgZhTSMcmWYvDYNBNhJ/Tt7cV7LUUf9SbQ156al8lh1eXQd
	4aWe60ZtZbfdGBZ8i+VuCoASpb4yFSK04WkII7CTMynoE+DhP+gbIk6hVVJL5iv7
	F9SmX/UpFEjyOnRJg+Z9/gF3OvadQIjoTrO2ZW19u9tLfgB4dzj/cakTkRsiVEqL
	0Q==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hagkhn7uk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:50 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91b7e7d5f56so96917916d6.3
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 07:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792075430; x=1792680230; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sXpy/3ffel3dUUklWIUvdxbmuTLROOFL9w6Ftgsfktg=;
        b=DHEWCTAUnYh6bSdspLFzdCQ+mStJeWncetEKKBRkp2DgOeaXzLJDTbRwJV2K7qFoo9
         6vEIucbj3qlIEZhJnJSqoPyuoQv4ynRy5U//jVk8jw47vLSbG46BN5wbItHfcK9M0/aj
         JUkfK+QMrEJBGwz16OSXNTPh3lYBymK2i/xyWvAc44r8qodBv5L4nJMax7f3odXmwXaY
         qRo9oXmrJh3wkhwHX4VLQ4rApG4oOOtuRQll22/ybO2r+YCE8q4ygAB+z0WWyXsSJjU/
         mbZd4rW0ttVxPpRBfo9cz36oLQgnphT9qT7YAu8K/YFOfoyFWQs7/NIL2OuyriB5q0lQ
         kn8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075430; x=1792680230;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sXpy/3ffel3dUUklWIUvdxbmuTLROOFL9w6Ftgsfktg=;
        b=lUfDs+n2QH/rhM77xvPxA+kmkEX1rr0yeQyCNap4ksRsbZ5L2t7FdBpiw0N7FFQqTq
         TT9e4b3XU9/j6MYIdI+SajjAaNas4F9hgGFVcY6Hkawxv1erEmEo27QmVHIfbKwwuOhA
         5ZZFXGMMqT8YnshfSf7SatpIOfK1W+2ZyoJuQvEin1iNO00L7Ou8nwhrll4WKo56L71D
         +3DBXUTjCl9PGUI4zqhOslQZRSZOx9WdZw6JjEiLD7dMd1Iy4G0KZC+laUChgdOIqd42
         X/bY0W34JfPaat0n9+KNiOe0zpAqx6m7B59DbOL/ChEksZkjDK7w9soLc6DcdJIaUra5
         kHcA==
X-Gm-Message-State: AFq9FYKMLeJOd6COn7+mxm1q1PaazzNAtGu9OodSqmBfEVS0Nq2nQo+q
	SYIDeOVshucHHtOBY1zVgOvIgxEGXlhO882QohLK25PqRbJoM8q7ao5otiys3j+DWk7lf6WxPDD
	cO0Flincbhl+sm9lrHCiwjfgBECiq7g/ThtqwrATb0d3oJIBRvPltOTEUj9Lp
X-Gm-Gg: AYBFou0vxJLHyEWmBZFTC+2TLHbfX1+cAeVVYghJCirz3RpLZaHctPQFMjX5Pep/5R9
	2B5hN6POGSsX4/J1JNNkJv+iWS+ZE9rYd6s2CC6IAEwqYxe91z59xyAKFuqxSNhJehzLhgCbNxT
	SXo4GhSlyU1dcsQGTwX/acyWx97BdonEoKPQcM8CIXMA0Db/x7sam5pwWOsj2ydB2ulDXPNXB3J
	bJu+O66MS6sND7nnwleTtcS86Epxa6xoAw1HKs7GskHknYwupwkxlv+jT11MiG5RvSsXpN2xdsi
	OtBTR5K/rHQFz1KtLZq7BF5NS6Dh6yOL51KG0J5NjnNvusCyBJnLx8WKsoJkmDX3lTqzsIeGnO0
	suV1BmsOZeWH53dM9hWiI71BjQtH/O/3fCQk1zgBw13K/
X-Received: by 2002:a05:6214:23c5:b0:91b:5480:ee2a with SMTP id 6a1803df08f44-91b557bda3amr304340376d6.41.1792075429762;
        Thu, 15 Oct 2026 07:43:49 -0700 (PDT)
X-Received: by 2002:a05:6214:23c5:b0:91b:5480:ee2a with SMTP id 6a1803df08f44-91b557bda3amr304339756d6.41.1792075429098;
        Thu, 15 Oct 2026 07:43:49 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b5f323sm83026476d6.20.2026.10.15.07.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:43:47 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 10:43:28 -0400
Subject: [PATCH v5 15/19] btrfs: remove the free space inode ordered extent
 special cases
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-btrfs-remove-v1-space-cache-v5-15-6b31347d9998@columbia.edu>
References: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
In-Reply-To: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792075404; l=6320;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=rTZzQ2a96A9lf5YW3hyxm+4Hhlv3XhfAOtWqXfOLQK8=;
 b=XyZtSLvX+XD0yufny3eG0W/t8oQZLv9fZx0jP1OLI3szjeIepX79FQxDwwICw6Wyccitos6l+
 GQsDarBZuI2DW9AYNyO0KoFe87Fgsln6HpbQi5Et1Nfd1WkRI56Ymy+
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Upr2pOwB c=1 sm=1 tr=0 ts=6ad0e6a6 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=OXerOaSWGyOIk54xot4A:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-ORIG-GUID: 8KL_PREvJKbL1o-MCCjnovzaEJZ2Vi_r
X-Proofpoint-GUID: 8KL_PREvJKbL1o-MCCjnovzaEJZ2Vi_r
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX/IPhd3naK2n5
 SBFmydJYx2RwFgxD07D/8i7KkQMonYdZUrXfKaCHFBnfhI1lrX/7nBGhrlhCN9I81mlB/tbjWMz
 SEB4RyWDbyi4QhI+0lvO8msPljt3i2qamLE/DeJUr3fma8PoeVDo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfXxi/TzF9uWjJC
 Ijhk0YaHdMKfBcuK0bL3y40MYBbuYsRgg9dvKDEQHQbWSnfTMF0y16pRPn++gvrEYwBa0NJ31VZ
 fD8N9ZqeAaKi55trspNdD6pD29czzG4pw/2Qf6mCtupclqQgsd5t1wuGfmaE2sjL2j+TjlnLdtE
 ZMTqPYL41fWLhLur0Cpy6amwQur9ZQ0prXummawPM4L/eEc/mGUe+z2d7UM1cWru0QVRw99whCv
 1VHv2nzQpLkW7BH0V2ddlK/e0bmOlyzJflI33bKdJQaaQUN69UzNNi8FulY3lMVaGRBjTN4t4yF
 igOQ7N9rc++FR3T+Gj0NbFIsQY1UQFlNRMRcmoaZdjxOVZkGG2KaPVPT1k7WL+U2jeGx9PC4Jty
 RCROUqxc1KF9hhVs00tZRjUSrcmtmBsr8LpMiLCiLYZDLqxgfxIZ4xgkjPc3oOHLcEvOlzfnPrZ
 C5u7Q4K6/fDKWOvnqpg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 bulkscore=10
 impostorscore=10 clxscore=1015 malwarescore=0 lowpriorityscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150057

Free space inodes never have ordered extents anymore. Drop the lockdep
exceptions for them and btrfs_join_transaction_spacecache(), which was
only used to finish their ordered extents during a commit.

Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/inode.c        | 20 +++-----------------
 fs/btrfs/ordered-data.c | 20 ++------------------
 fs/btrfs/transaction.c  |  6 ------
 fs/btrfs/transaction.h  |  1 -
 4 files changed, 5 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95ec6026f08b..0ca4952600c7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3221,7 +3221,6 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 	int compress_type = 0;
 	int ret = 0;
 	u64 logical_len = ordered_extent->num_bytes;
-	bool freespace_inode;
 	bool truncated = false;
 	bool clear_reserved_extent = true;
 	unsigned int clear_bits = 0;
@@ -3238,9 +3237,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 	if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags))
 		clear_bits |= EXTENT_DEFRAG;
 
-	freespace_inode = btrfs_is_free_space_inode(inode);
-	if (!freespace_inode)
-		btrfs_lockdep_acquire(fs_info, btrfs_ordered_extent);
+	btrfs_lockdep_acquire(fs_info, btrfs_ordered_extent);
 
 	if (unlikely(test_bit(BTRFS_ORDERED_IOERR, &ordered_extent->flags))) {
 		ret = -EIO;
@@ -3275,10 +3272,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
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
@@ -8137,7 +8131,6 @@ void btrfs_destroy_inode(struct inode *vfs_inode)
 	struct btrfs_ordered_extent *ordered;
 	struct btrfs_inode *inode = BTRFS_I(vfs_inode);
 	struct btrfs_root *root = inode->root;
-	bool freespace_inode;
 
 	WARN_ON(!hlist_empty(&vfs_inode->i_dentry));
 	WARN_ON(vfs_inode->i_data.nrpages);
@@ -8160,12 +8153,6 @@ void btrfs_destroy_inode(struct inode *vfs_inode)
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
@@ -8175,8 +8162,7 @@ void btrfs_destroy_inode(struct inode *vfs_inode)
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
index 93bc829881d1..7431a06f168d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -895,12 +895,6 @@ struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root)
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
index aa57c64a955d..684b46e5f2e9 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -287,7 +287,6 @@ struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 					struct btrfs_root *root,
 					unsigned int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
-struct btrfs_trans_handle *btrfs_join_transaction_spacecache(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nostart(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_attach_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_attach_transaction_barrier(

-- 
2.39.5

