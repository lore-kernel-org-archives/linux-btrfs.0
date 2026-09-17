Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1E53BFAFA
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 04:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789617646; cv=none; b=VqifjzkgnP4we00rzh9X8WWxUAMh2lEhYe0NMv5z1wyCCUBeDZJYTBPKKW+m5N9sDZSgiRWn7MFQNudxQrfgCmT84JNhjYjp5Rb7tXCZGrXVWrVyCMpYJhGFEro8jyX9xrMKn0y3VFBjQ96U7+/3R9BLpASzvDIrJF+aOfGc+xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789617646; c=relaxed/simple;
	bh=jr6iJ2XTm/NeDYB0AKM6kJjSve8LKKcse8zyC1ifnUs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SNbD3iJLQz3JcFWUhlNOKUAXPNKzY0+JHlECSquA5heXN9QGp5LVBJGzzTuwTJWUIN9in20TrWzhhTSX0qoUPpB1Yi7MrVnD9kKlXRu2QjRvXbPI2NonAFjMODZpNH/TUU8IM3jbECOf0gvpAXPpFTpE1jB8YChIEt1TgX2UeOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=mY8otQUF; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=K2G+fdoX; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="mY8otQUF";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="K2G+fdoX"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H2YJgt202991
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=536N
	Ckbz27nIuI5cL7oJVN519+z6T8yl7KtS+93Yvp4=; b=mY8otQUFAu6Y0GzgUaCc
	5hixLy8VYh/o8DHhbnpl5hOoUYxRQTiiEE0S0H1aVaT6hRIMDsiLiFSeBDIK713R
	l8CyejAf0Eq9geky9TqvMM6jbL/GWlbNOpXd5Eaz5yWOUFOAvIri6CcGMNX3SGD9
	x0rLc9JLc7cUkstr11DdZSYDZAfnE0RB0VqA5fy6AugPIqjWHqfsSpqVyU/E6TMW
	5D0ubwDkxLRBiM57/UmSHpz3nn/+Gpx/Vs+2h/J44GGumZo9LNntqnughbHMG4iN
	/zSlJLeSX3qraqpgH5h+q9hUMAL24kkcHayqczv588bjxLSohqMuLXtPaqWfh74w
	4g==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gr1x6adq1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:42 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-939f248907fso38057385a.3
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789617641; x=1790222441; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=536NCkbz27nIuI5cL7oJVN519+z6T8yl7KtS+93Yvp4=;
        b=K2G+fdoXKBHnddxOMYaSxNg/UJnFzE7Lp5CW+hX6PJMM2RIut+ifjnItQV6+rILmya
         1B4f7iv4ltT/2fNKFwmEM0tkZAc1dv87Gd+SGHWh9V82C6PLHd45/iS1kHwwYbQxuk1M
         ZhdQyrG3qUt/P07ObX7yR2h6WHPEsAnhk/OZcXpSW5gXZ85bJZ2onL8H9lI3iCC+xw7T
         OuAcGSeTX7hy0DZaUaTf6qPxIw1+GJOeMdCdrbypGlUH0cHertKTS17QqpmjZEduRnhd
         2rlHwmNR5/qQLuXKMMkr4uO+N9LPWBrKvfm4xC1oIVFYrnm1x3HR01zfEB+49IVOP/68
         DgqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617641; x=1790222441;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=536NCkbz27nIuI5cL7oJVN519+z6T8yl7KtS+93Yvp4=;
        b=FUnE37jS7JyPCXfC0nqXIjzQke9IY7TZj6l6TZUPD6RK7Wqw7TJi5xeEPNyzsl6CcA
         hZvfuAs8TcLBZWkxFK4mLQdPH0cDE+xb+ahTdQvURTfGeRxGon49TdfCZfF3WnHrfxDO
         R2xAel5w2sL9gxxC2Z7I/hozvMSjZfKbNym0KVU4S/7l5oteFagosiqPNZJqw2Wt3OXe
         ZDuRDrieHoZDoMknB9ZYNMHJlVLI5HtgwXxIk3gc18uIz4kkC0bgx3zWV44rJ3np9NJM
         j1oGUqDuQFx3ASqv94P6QsMVM8KWSQO8sP6/CtqBIJTH0g5JTanPcYlZt4uWpw1YRaqX
         5eWw==
X-Gm-Message-State: AFuF++nofkn9OSLA/3KX0tfjStUQT9c8p31KpYJtPXCtTOSKihB9scVj
	z7wdzLoawQHUgJ/vKQggx6KO5Mi5ofWT9Q8me+a0l+IBaRUpOJvy9vdKcLvr2vfktW2y/kVMzza
	dLDv5uvUdUPo6LC4mXp9JqeBNvQ9KItU6DpCEj6tojCooVQsI+2mv3Lbp7xW2
X-Gm-Gg: AYBFou0dGVcmtaOisOylP2YkwJBDbZLz4DUekj3/PCvGqJN9vYF/DBQxNg9vPyIgZ8b
	EJ62+kc2TyTjeFuS3hpbxVihQy4sE9LapzvQNz+RlPjsPIMFLTWz4SUdDZR4rXCeENJUrJy9Gu8
	pwyBUkkQ0KpXCTtUETp/n9eeLRw1d+bjqGTRu14qk8wxaEkjhMDutcI6M/bQtevSTP3RU25YnWD
	nCImAe89DFp6Y0zcv5tqBqoxAsiUIUqfM9xwa0a6Agjs2TLngqesKvmDeSBS+Qq/Kp+DQqjAGG1
	qFPddVtFDLoH0lbYgQkT84jZS7mOMo1uDrnoU3mtwIKl6VF1xs0OenIzBrEDuO4Olhb2dJchc73
	bYxsvOgxsJO210Ot/9R3T7IxsP194Z+EDn142LwDm5NILWg==
X-Received: by 2002:a05:622a:e09a:10b0:532:8827:a9bd with SMTP id d75a77b69052e-5328827c71cmr48229341cf.39.1789617641208;
        Wed, 16 Sep 2026 21:00:41 -0700 (PDT)
X-Received: by 2002:a05:622a:e09a:10b0:532:8827:a9bd with SMTP id d75a77b69052e-5328827c71cmr48228861cf.39.1789617640579;
        Wed, 16 Sep 2026 21:00:40 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123beadde6sm41748766d6.35.2026.09.16.21.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 21:00:39 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 17 Sep 2026 00:00:09 -0400
Subject: [PATCH v3 13/17] btrfs: remove the free space inode ordered extent
 special cases
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-btrfs-remove-v1-space-cache-v3-13-10ebde03b96f@columbia.edu>
References: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
In-Reply-To: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789617622; l=6340;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=jr6iJ2XTm/NeDYB0AKM6kJjSve8LKKcse8zyC1ifnUs=;
 b=Czz96l7+/3AIFybi5cswH0U6OQ+ybUU1Q6Q4DWlLU6hD85Wv2IEeFDFisZyoGXLSn1awqYCcG
 KbupOA3ZEM3D35nU+ZaeYjUjL1BxHE8+6UwRuyyKL/ICA45fP/1h8Ef
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX0Ju+wMb0RJwX
 JMpkmG62NDzfkE2+rwOzcb6BhOVlz46XG8pTC3Pbc6IG5ofyPdLuvBvU0gltkPIK3TgWb9erpQW
 eottcyujy0rZ15VjfrZDDlP14UxOdRcvI62zuUSWhO0SgXsHIyIF
X-Proofpoint-ORIG-GUID: bg4jXtmiziFv4M1F5dS-uxQH6CUhmPOM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX1LHKb0+gRmlh
 vD424cXXmkwOITsD/HFO6pQX6oWcQTC5h/pxpZGBQFKrI/B2Yb4elhWj2Cq6NAPU4UJPTDAc7va
 olU7hgSREZTtUgAZFmSxjE8ZaPymZIw0rwIvB3c/6J1Mjcy8oHoMRYElvQQAdSyLSsH5zPYgtFi
 n0MLnUbVjyA7AXPju7XGvQBBZdxTLNKVCVJ/BHiyLFkQaL/aWQTE7coDuOsYzhY6XoE63nQ0G/X
 yz40ZoljY6J5YdtTMI5HuvkTrggYTy5CyrRX92xIQC6PedWRIq4Oe95NQc8we0UatGgtcnkrAm0
 rvpC/It6R36YpVivUd7L96IuaZrnAMqufrNjDW1/D9swainRlC2YvYKX5eJRvvlt2A+/IS2fvQz
 CYY17aCwf4Vzt7cVCPlJOtuE5jLbN7bZ4A0MzDqHWDnakpzcxJMgMC7ROReROnfGm13JOBgkVIi
 ClXgTQ+40brVlfBDhmg==
X-Proofpoint-GUID: bg4jXtmiziFv4M1F5dS-uxQH6CUhmPOM
X-Authority-Analysis: v=2.4 cv=CLS/zhrD c=1 sm=1 tr=0 ts=6aab65ea cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=Rsr-QhNx__N08eNVIAUA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11907
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 malwarescore=0 impostorscore=10 spamscore=0 suspectscore=0
 lowpriorityscore=10 clxscore=1015 priorityscore=1501 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170047

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
index 0ea984d641e0..fb026d81414b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -854,12 +854,6 @@ struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root)
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
index 33a1884c5765..6b0da4eaa0fa 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -294,7 +294,6 @@ struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 					struct btrfs_root *root,
 					unsigned int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
-struct btrfs_trans_handle *btrfs_join_transaction_spacecache(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nostart(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_attach_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_attach_transaction_barrier(

-- 
2.39.5

