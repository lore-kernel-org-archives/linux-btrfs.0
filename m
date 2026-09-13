Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D018396B9A
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 21:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334504; cv=none; b=ulrKmHjkHws0PTBm5LuJZqtp9Q64Rzt5hJ/uy3teICJgldBaFcL3WtBCzrDbuc+Lff4AHbtidEVBSEjTgYstX3W7ncdMn+5Czv36N+ZpRA41kItMzGfR+pF90tmbtbCUm76+xJz3z2ox2rG4lcQPad7tXdze8uc/aspAYCvHzEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334504; c=relaxed/simple;
	bh=dkg0MwKLg1iLy+Etq/q2Hvf0oO7DoeoyOqsWTmh7O0I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YmYem8fufqLYyEcO0ZCztZ/O0+MIlcLKa83sQ/GYl/BND7QDeznUyw0W1sA01ga+14GsVylbdBJ+jpERwnuUvBrPlxOO2O+nvinxfl0wSvzm9JEroCPs42M5dBPh+mUsGXlzeEOWEpSqtKhy7VGg+zy6Llalh2UHnjWSqvWBzNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=uQc4+Cml; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=r+oqpklu; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="uQc4+Cml";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="r+oqpklu"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DKaHOd563538
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=V0ci
	pskccyeD14O9cgglEpzzEgLikHPr63hXXeLz4FI=; b=uQc4+Cmlja9URfRzCMMt
	N0Fj4IJECCkO1PINxnegaVEAULeM+/vietsKVtAeEHyY2Mdmj5+s34ftS9A3y3Pr
	B867D13YA/3fOIzBhwJZqR4CpWNbJz9NpeQickEVJqp71v1KIkZLtuAF0a7nUyr0
	/TR8cnlQng1EoWz2RBfLzjoIsBUk6riUWex6NTrOJcMAnNuogHjYSWruK4WbF3BX
	kcHrz4QSjrOi6kxUxE3XpR6ynBNFfVHeOGPm5JC75ShirFCuzyVLkGGYYMKAgLSa
	HeZWCqJSjE8HZ284jRE4x0tw9/OUe8tyqtEeOrNv7sW5pt7PgW8FsTUq8hAmAozp
	KA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gp2yv05qn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:40 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-9308eafb465so693533285a.2
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 14:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789334500; x=1789939300; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V0cipskccyeD14O9cgglEpzzEgLikHPr63hXXeLz4FI=;
        b=r+oqpklud08boTACTrILEFKm6SVYrMzY3rGrQCFBB3IFiJ+ztKrP6QSu24DcgzVS9j
         lW+rvwhkowoVfaF+Ko6n3gpHIpqPFxiXZqa06BFr24TOPOmcngLbnwDelYoBkZj0IdoX
         A1idPsif8qRzGwSZRiq5dMP3LMV19Wa6lFf8ImcwLYHDUd/izKAeUER1WkAVcsaFd9xa
         8joQNerpBRQKsUiGSJ0WRBfhOKTMN9nX+G0tQzvjbug1q4ziZ00Uf6d6L3vbj0ZFM4Ap
         LS24okoBqifIffoHj3BJetxiPalvTo+GjzpKYVftltoe0UqOaZnOr/4Eu/ZHimv/wM1C
         BYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334500; x=1789939300;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V0cipskccyeD14O9cgglEpzzEgLikHPr63hXXeLz4FI=;
        b=lDH6vwpNAlcqUQhQ/3/Aq81ud4EiatVcSfEVtO0t/3L0Uj/r2N1PxOhaRvRSm+QisK
         fMk0/YpgfRK+u8R+0zJtn4H73fsHE0sGehMhldNiOJtrbeJnNab4tuASLUz2bWXt7H0K
         kD7NqLTGwlRa7e0PD1/8NgD6EkWO4GYf2lXAMKKoU4J/AoF4E6YBA10R9d3Ho3HjGvqL
         mSxiyqALeDc/QBFpahmHo4owcVMV7aYCWQB6cwMWxzqL+tJME4+qCXUt5NOfNsONtuer
         ILVuAvxxauTDoUkxAqb/7LcMN9uxdh8DvWycXi2hJ3o1aNtXdmTE3Lqf4suY4Fal6X+n
         mC9w==
X-Gm-Message-State: AFuF++nFvCaScvRVnwTf5r2aJ9Yktdv5xNtqdtJ3tnAIZfqb8DMsLJ5C
	lRWboDVUdKGpoXC4QjZrvZcy1D7E1iOb8QVnkc9gGn7dFQlwdApiXjaz7G3NcTh07bkbKok6vaD
	DYabRqwWf99znxzkAcFNQeEuWkXWlvqPnZq0kBxPUBJ0kSqCYtZ0zpXktw7UG+n19E55l18Y=
X-Gm-Gg: AYBFou3uDKHiJlqxvGH5Ovs43trxXrtSMUK/8lmjyuM4BMjYHyJ7pmcNQmWs10L44Or
	fsFDufZUjKa2RWc6Ka5SS53tl4W0t8Y/Xq+rK6wV6Gqgws4tJoiUY/360DcWg7YitZja4j5vmAA
	XtcDCGKz8fBMQbizmc6QJcy8OsoXMjfqn7MgaUY7ka2vFHrjiDqONNNTUZv+Ub2M14i3TonM0H3
	DNtRAnxj2+FuqgcUDMXbItFwXhKD3zpnpgisPA1TNpezjCj4kUgpMm9eWin0SZp7+Mbbay5DP4n
	rG0l/ZCwU2mvKVPYOe7BxLxeuwD0QTS3TzZA6Zhu97WX1u4xU7IbbTMkA+Ru37XGE9K7vu8QN9G
	2JFT55S7T6IB/kbuoTYgW/wlK2VLLmiJP4ybW7hMHOyAEBVj78hFZqA==
X-Received: by 2002:a05:620a:3188:b0:939:5cd3:75ce with SMTP id af79cd13be357-93a0364c9c3mr1117786885a.8.1789334500267;
        Sun, 13 Sep 2026 14:21:40 -0700 (PDT)
X-Received: by 2002:a05:620a:3188:b0:939:5cd3:75ce with SMTP id af79cd13be357-93a0364c9c3mr1117784485a.8.1789334499712;
        Sun, 13 Sep 2026 14:21:39 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d3a50sm78432696d6.40.2026.09.13.14.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:21:39 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 13 Sep 2026 17:21:26 -0400
Subject: [PATCH v2 14/16] btrfs: stop special-casing free space inodes in
 the delalloc accounting
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-btrfs-remove-v1-space-cache-v2-14-186767a7e106@columbia.edu>
References: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
In-Reply-To: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789334484; l=2215;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=dkg0MwKLg1iLy+Etq/q2Hvf0oO7DoeoyOqsWTmh7O0I=;
 b=KdeJK5DOxzGkfTa0NRh3Nqvj7e4CiCfIO2wKWAoWJ60UCAPZ4iVFaElD6mntCkUkz0aSh9dbg
 YR/CWxQej+AAOAI0E4EckQ3Qtg5kZQ5L+Uvu8pJLYgqwhnTnue0JHtM
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=HtPjiETS c=1 sm=1 tr=0 ts=6aa713e4 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=bn-TaVTt-omw3cABb-QA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: TJx0oQ-73Q-datsFvGOMi4VU5jF8mD33
X-Proofpoint-GUID: TJx0oQ-73Q-datsFvGOMi4VU5jF8mD33
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDMwNSBTYWx0ZWRfX0Dd8+XbTPM9D
 aTSQlvpIamFaG4mJP2PQ+R2R/YySaZ2pBL2W8Omnf4zNK79RliUXS0XGumvdS9vGqICDtXVIdu9
 NwlubhmyKSPog3MbeU6RStOY+5bQBzxh/hkmSZ6dJl9XOt09MUBW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDMwNSBTYWx0ZWRfX4UYLD+MOowXF
 vow4zVTdGrXi9syjAnbyM/r11ZsD0kUMc8Yz45rTNNpJnqoWxYWM1G8EqI2CxhXhPyMJfiKuCXb
 JDFMC0UlJgDaQm7FN4atYWGODWQ9lHi/kRyt/YGPmGwHgJXVJSldy0A33m6MkZTe6DwhebofCX9
 R/BfasNoJpfPcudmqFefahg+asK5ewbTbfjmLLXxHMPBadbvsz2vJUDkTnYbTvJoAC7eh/n4Q/z
 3pmO66cpQsMPm+bJWw3KOuhwkUB8xQzG6GFsMc0iPbMu5a0/xNOtKNqYzBJFXWsNocw6uCk0Wf4
 0s9LmoGzQmdrJbrW6Q4iCIXX7VDCuj1/xxo7nnkUpOQ5rUic1LFyR43oQvrBn7zvb2gfa1oPCzg
 UMJzOk1m5ScX2+qY+mCUG+nwxtRv3tdavbxtut+fsAENUwR57R3yWPAVzWTo63CJyVM2yR8xqhl
 XpFfGCc44G7IJrtE0EQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 priorityscore=1501 malwarescore=0 suspectscore=0
 spamscore=0 clxscore=1015 adultscore=0 impostorscore=10 bulkscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609130305

Free space inodes never have delalloc or outstanding extents any more,
so they don't need to be kept off the root's delalloc inode list or out
of the outstanding extents tracepoint.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/btrfs_inode.h | 2 --
 fs/btrfs/inode.c       | 5 ++---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 26cc5d1aca4c..795bb222a2d0 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -402,8 +402,6 @@ static inline void btrfs_mod_outstanding_extents(struct btrfs_inode *inode,
 {
 	lockdep_assert_held(&inode->lock);
 	inode->outstanding_extents += mod;
-	if (btrfs_is_free_space_inode(inode))
-		return;
 	trace_btrfs_inode_mod_outstanding_extents(inode->root, btrfs_ino(inode),
 						  mod, inode->outstanding_extents);
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c8292174b550..89b50d4e0400 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2614,7 +2614,7 @@ void btrfs_set_delalloc_extent(struct btrfs_inode *inode, struct extent_state *s
 		 * and are therefore protected against concurrent calls of this
 		 * function and btrfs_clear_delalloc_extent().
 		 */
-		if (!btrfs_is_free_space_inode(inode) && prev_delalloc_bytes == 0)
+		if (prev_delalloc_bytes == 0)
 			btrfs_add_delalloc_inode(inode);
 	}
 
@@ -2672,7 +2672,6 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode *inode,
 			return;
 
 		if (!btrfs_is_data_reloc_root(root) &&
-		    !btrfs_is_free_space_inode(inode) &&
 		    !(state->state & EXTENT_NORESERVE) &&
 		    (bits & EXTENT_CLEAR_DATA_RESV))
 			btrfs_free_reserved_data_space_noquota(inode, len);
@@ -2690,7 +2689,7 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode *inode,
 		 * and are therefore protected against concurrent calls of this
 		 * function and btrfs_set_delalloc_extent().
 		 */
-		if (!btrfs_is_free_space_inode(inode) && new_delalloc_bytes == 0) {
+		if (new_delalloc_bytes == 0) {
 			spin_lock(&root->delalloc_lock);
 			btrfs_del_delalloc_inode(inode);
 			spin_unlock(&root->delalloc_lock);

-- 
2.39.5

