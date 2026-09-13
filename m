Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40048394EA6
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 21:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334504; cv=none; b=q26r5XUgHPau42mCiYcjIdOyZotw5HArvciKzRt1AGDyfBsLBUyDOawEelfscoudBothkjUz7JPff3eOLboTe88xwkBrLMYztmIqYD1spbtDSM4n7Y205DSOJRpVOpkdSwZ58poUUOPsVDUYgxTR16cZkQmuLmZUOfaJSd+UQIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334504; c=relaxed/simple;
	bh=oYP7pv2FTTOlOSBcQhESw9fz2W/r6y0ZOZU2Sr5Vr8I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=O4R2UTZU4pVyNaToTIF/LeE2fic4JaWeDC6a+/RFPWFY+V1gbSU+BuKpaa3ejkWYEZEe6g5IdwGLoy4dzZPQPNWrbPyPn4Je35FRqIB3dEo4DM7vPI7eB4ATPQNqc6OL+GuP+7gJfikssBWVfc8HJyz/cLUITK656y+TXbCGdFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=ZpyIR9rE; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=L9lytLI4; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="ZpyIR9rE";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="L9lytLI4"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DKZ50L560895
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=i3P/
	srcPAEWDlqUpM+pY7VuFwWMYCOBkTHbn0K5TBeY=; b=ZpyIR9rE+ftYR8wBS1KX
	ikURwiBWifNPzs/AdEEsNuxp6QfbyaR0NeIQCIgkFisImlYd+dsvEAlc1TZksXYf
	R+mlJvmhdN7oPaEB0dPlOazx2ctKcfzdJWBxzF7rtDwqIi7eGLLri2MjJQK27Ynv
	Z9+RdSUdLBn5lnJHaahY6D2qALZI/T1fyUyv3/+KSNqQ/cqGwyCc+r886pl/e+4P
	b0M8YacrSwqqJilSaxeExO9os49nHtzcuVqjgbUQpaVBR4y0uAFODrSDoVDH44NF
	FtI8OdzukOEkTnwD1EGf1wT0+8SBsuDRJSGQhtBQ1Z2BvIH8OAAGVE7kDTUuF8Ew
	4w==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gp2yv05qh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:38 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-530e7acf9ddso32500171cf.2
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 14:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789334498; x=1789939298; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i3P/srcPAEWDlqUpM+pY7VuFwWMYCOBkTHbn0K5TBeY=;
        b=L9lytLI4sM/dj6aBCQdKQdseMaMIcPOVEh77hVA7f23LG93pIssX7wHE41fbLsGN7c
         WJhc+zYLRt8binnYP7EiYCU556Km3bXZUryrXv0RgKyjBZkPuhPApMDVtUpcSrmlaJQS
         6XVfu3U86+aRNu+nksX95nK0QL1K2jMZI5WKXDnkD+ZC1wZKzg0mSLDv2X9jgLWLkafS
         eftk5/RelQRSpml0sVhjhTHi68hTPHh1GOCFXdxrp8UMyBCsTawaYqTLBdTOiNb8GYZn
         +Lu21HQeK5TZTN9dFeIyBzxB799TLP3XQQ+tNVrIuJo7pJ2e6kEVS88vAZMgFaB/ZeXC
         6ssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334498; x=1789939298;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i3P/srcPAEWDlqUpM+pY7VuFwWMYCOBkTHbn0K5TBeY=;
        b=f8CyFcRoZGfR6r/pL1bEKcHMFcc3TYi2gZ9MEccKiSFTW/BVh6/E/ztHetaeZ0u7Hw
         TYtJ1BOk2lOQRZfeKl+mUQHMAb8kab8ezagYaRBfjipY1MCSA+Rz16v/ruBu9KlE7hCa
         81jHKBBBD+7WhdFWdl2YXrTRcbbetbySnEgFnzrTwGrwtXKbLyTcLLnMx2gIe7g1n69Q
         /kTPnLwr+YyB7rERq7yibAFO0JfI1WN/AL1wIqqJWlE0pWcR7J+RsmlcHt6/gDU4DrjU
         6/8kAX5j+64XI7jR8TWUBp9sl2Bl1VhhazLfvIH1E8uc6h+rbaMfl5HfcDUQCD2p8eTZ
         gvjA==
X-Gm-Message-State: AFuF++n+N24O+/1L7uqXQWhm69HjknXd5p8ng383Oq53F0W/42A4E3gf
	LmmwQzzZ2hrFcIr2O8wNSaBpOSXIZ7bViZrXsXwNBhm/2zviJioJzUQ1NILHtIw6EtmVUHygRV9
	EaqoH6dIjxF4ggDKDETl4t7HD+dS6RQlFjT1Ix/+/wqr6Xd7UztW/SrztM6ZR
X-Gm-Gg: AYBFou0xtqI4UpwtFYS4HqnLwwc/Kr8oaMuIAICY/87o8vLM5h6X2IEZZ/IzZF0PUCI
	naJYXvDubborHrMCxWwhVi6XwkrhhHnMLUmUku4E1Tx50iW7ggIhDM8snbq8iF23VMzLjZDWmkk
	/Hv0Vv0AkzDWIlIXNIM509oYwJBqG01QzfAvr6TkI4I7HG7KaITLucrcMXqDwRtu/llSf4OnSkc
	PQgTdKJXCWnHg4kF+dIEccWNElaj/BCKlUNP4AVxisExXe9kZpOPKwM0oHfyBfrJL2GZI/mIlev
	39y5jhKZ937Bl6ZdaHaExydef0FXaUjt81ql1iKD2/d4nd8mYmx+HrCXRwLyjZTuDvlch1ro0Sj
	2NrFydVsGesFmVHr2Z8TNsMwzdx42Wzl0Qy7H8NwDpzekLIlge0WBIw==
X-Received: by 2002:a05:622a:192a:b0:530:d7c6:16d9 with SMTP id d75a77b69052e-530d7c619fdmr205147811cf.25.1789334498348;
        Sun, 13 Sep 2026 14:21:38 -0700 (PDT)
X-Received: by 2002:a05:622a:192a:b0:530:d7c6:16d9 with SMTP id d75a77b69052e-530d7c619fdmr205147491cf.25.1789334497862;
        Sun, 13 Sep 2026 14:21:37 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d3a50sm78432696d6.40.2026.09.13.14.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:21:37 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 13 Sep 2026 17:21:24 -0400
Subject: [PATCH v2 12/16] btrfs: remove the free space inode ordered extent
 special cases
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-btrfs-remove-v1-space-cache-v2-12-186767a7e106@columbia.edu>
References: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
In-Reply-To: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789334484; l=6340;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=oYP7pv2FTTOlOSBcQhESw9fz2W/r6y0ZOZU2Sr5Vr8I=;
 b=4CWplzF+UtYHlQLXmA8E4PG1BlU+kWV1Ofbrzj2WHS2AH/7bHWXbdO//jsBRmL7ZsW8L4hhvB
 IFk+fAOcy7CA1/oQ29y5Q4PD7nclgUDs9wn6XujMeIW5Ff1U+QvLNCC
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=HtPjiETS c=1 sm=1 tr=0 ts=6aa713e3 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=Rsr-QhNx__N08eNVIAUA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: zJvQtpWY7Nk-Yz-F8SdjibbD4VdKQuIg
X-Proofpoint-GUID: zJvQtpWY7Nk-Yz-F8SdjibbD4VdKQuIg
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDMwNSBTYWx0ZWRfX/avRjfAV3rFD
 xxU0qQPtTx8ihes/fIFB7FQ61eVqNardDvOfqd073kkJBbh5JdSU4C5Mx7p4gRkWa8C6FPEeG9y
 WED6pd2j+CQ555u9uHhIVaEoGZR0FmeWfnrN8e6hMllSDjUN40pm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDMwNSBTYWx0ZWRfXzMQubK4J2FJv
 +8+S5HBGgmZP24EAUlBJYI9XBQ21LNtmRyqNkBrEY2lSeTLN3j4z+5jBiZWqpKXHB3URfwSlFIC
 v11JAn9KE7e77tijFqO9KvwjnaYIA3Ma494lJiPiM772J1xTRlecNSwZ5N4XpG0WO8ARR0QLDZ0
 gDToeB7Z8oilro6uB+l8LtHoTGDM1tQuZ62+veOPZ2k3CDmPRk8/1EqGtLmq2R11CjOMmfjcFQF
 IwFNP3eYKyieg/XmY4zwjwujSml/DkfMDNawo1i0dsmCDDgMMbieXqv/amRnoLULDAXVGzpPT1k
 M7sxaIYA1gibxrRBbuuDyOdSLO77kEm/daTChZXPZ8kqVtzzHOs+M0eJb2z3sy+azFDVss+Cu2v
 Gpwm4GXcmxYwlSOKFVnl+qra5rwoHnAPgWx8ERduh+lbR6ccN5yZ+BCh5/j4gs+gjAah8ISLFhT
 92MW5/NMEiOZoG+RFUA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 priorityscore=1501 malwarescore=0 suspectscore=0
 spamscore=0 clxscore=1015 adultscore=0 impostorscore=10 bulkscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609130305

Free space inodes never have ordered extents anymore. Drop the lockdep
exceptions for them and btrfs_join_transaction_spacecache(), which was
only used to finish their ordered extents during a commit.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/inode.c        | 20 +++-----------------
 fs/btrfs/ordered-data.c | 20 ++------------------
 fs/btrfs/transaction.c  |  6 ------
 fs/btrfs/transaction.h  |  1 -
 4 files changed, 5 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0539f27776e1..dec1a848c7ca 100644
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
@@ -8131,7 +8125,6 @@ void btrfs_destroy_inode(struct inode *vfs_inode)
 	struct btrfs_ordered_extent *ordered;
 	struct btrfs_inode *inode = BTRFS_I(vfs_inode);
 	struct btrfs_root *root = inode->root;
-	bool freespace_inode;
 
 	WARN_ON(!hlist_empty(&vfs_inode->i_dentry));
 	WARN_ON(vfs_inode->i_data.nrpages);
@@ -8154,12 +8147,6 @@ void btrfs_destroy_inode(struct inode *vfs_inode)
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
@@ -8169,8 +8156,7 @@ void btrfs_destroy_inode(struct inode *vfs_inode)
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
index e49d83d3148f..ccc8d5840355 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -853,12 +853,6 @@ struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root)
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
index d6a2eafd162e..d2e2dd6101bc 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -288,7 +288,6 @@ struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 					struct btrfs_root *root,
 					unsigned int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
-struct btrfs_trans_handle *btrfs_join_transaction_spacecache(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nostart(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_attach_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_attach_transaction_barrier(

-- 
2.39.5

