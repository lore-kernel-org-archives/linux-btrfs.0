Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5417C2F6918
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 01:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788830416; cv=none; b=WyPgr4Oy4BS2bpWGGw9xglZbi6S1yayEaTXCAdKg4LYtaCcm0cwM6RbhzuzboPVJ/vEPpMwxiSowdGEu4OX2TXLLPFX7DCuwfHoZDx1ZgTJylVerCPtLlDFkjVvBF2XTHShVJ+9ZV2/wlamquSRvMoe4fXv+PpWi7QPNe4x7nGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788830416; c=relaxed/simple;
	bh=s0Ur7xTjy0MIOogA8x9okj5s/rWZB+OdHIcqrKhE0cI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FrSNFIuqkD2RTP5Ny250a6WbfV+r+b2esIKLKenFFmgMgty69BRS7PewsKfNZjaS2fJkKZxF0e75PJZLh+QCPL2Q4ZRQFvA89PbX7RhYSxap0lIbNmmZwSAPrMO5HdYcUmV1xzv1dVqgzDBAlL1nJOrfZVJFa2I7yiJiWPv+w4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Kep4N3/1; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=jFIsZsUU; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Kep4N3/1";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="jFIsZsUU"
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6880uYiW3743847
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 21:20:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=2M9D
	4jxfFcsmtV2iS1rQuymkdk6W31/RYk8FxRcByY0=; b=Kep4N3/1tOLaluOXMW1D
	kuw9Rk3Ya8HYQmyYytY1yu97wMKRg2JnvxU4feK8ZD8V56Miu8T0XuCy/VxDHiRu
	gbNZspFvz7tbcGeQhfJWnKJZBMEBaX0OsxIEbspz1R8aC/acsg2v93Uqq/CkfFQS
	HeUAItuYT2euhFFuPGx71hsXXNq5zpWmz1TBD6j+AadPWqojPHvw6IZ9KcLhctYf
	Z81YvOIQDHOrul/gw+G4Ayg6cQTG73dZQ8WOTVvUeTJPGwOfJetguy9p9SdTJl6i
	LoSOPI+rZppjuczRwswVAaWLk1AfXvAOvBb03SnAvVaba5ruNh/P6OUw2Kg3u/Xc
	dQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4b995aa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 21:20:04 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-52fc3bff8bdso72078751cf.3
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 18:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788830403; x=1789435203; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2M9D4jxfFcsmtV2iS1rQuymkdk6W31/RYk8FxRcByY0=;
        b=jFIsZsUU2pQ22E0lOQ70vXDk95hlXJl/CYgsBl1y127o+hUedF9Y8lASic1DT4gl8g
         m908QvCoHfenZ++ozqSVRtc4mCd+7blTfqaEmY6yXdBCU0dNSGvuVdq7j2PQoBbTqriS
         oT7F/ck7xjz/fPTwkWc771RCdQ9Go+U6y+Pjy8DcL1oLxJXCz/4USL3yNpco2hzVXX9k
         4dT0bKHK6D6VUYc47wInekYI/8uXQYKDcOzvHsz64P0oHhRoaTi6Mmk+IFdn3WHYv5y4
         SWAX/NZu+VBMfCq4uGm1umdpCK5Esqy4pw8lLy8QsaSn46e9sPQY7PHIlW5iYg4SJAN+
         aLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788830403; x=1789435203;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2M9D4jxfFcsmtV2iS1rQuymkdk6W31/RYk8FxRcByY0=;
        b=VoJapQThqFcfjwLvjMnhih9cAGRtANhIW0/w4A5WzXvixJTMc0HagKNx7ARpTwBvWA
         +rKPI1OG1fPpqcLT5GpkR9PKI22LiXIxP3Nu5bdzt2w2dH0NVdnRylmBBprn+nX1KvvM
         L+Sb4h0nWsDsLetMckJ8Ki5PgGXubJmpX61tq1Lou8EKLb0/iXvdijmPwmO7IJ7RerOt
         Zt+g/IaTSZStCtLPmKUojEi24ppKzKNgtfUESj7D69UJFFbh743mdUapzmdth71hdyUi
         t8ioQ0V3qhyoutnZDKkTB9sF5lIgvWD1lHM5d9UuVZeWRcmSPccTkx8f8k8UuT02BY7e
         j/0g==
X-Gm-Message-State: AFuF++nbgFZEOj4HZyzCcpPyd4Td5t7YCLHi+ck53ODx+Aq5pZOjZFj3
	f3GQoHXWh64tSqNjwZTKRFMQo4QHc4z7nim2aNd1Ezh7LvXkxHY0Y1X8YUaXP7bSo6xkdQzQSG7
	U6AyuOi/VF1zEdnd+30CsouNhdQZ7PruNcrsTeIt/wNEa1kHnlnMJn2AFHhy3
X-Gm-Gg: AYBFou3csXCP9V8HlRUoswENk+dV8a97LnOK8FVOvUPTez3HOBsSj/HUsOvD0aAqznW
	NU/PFmFnne0bij+6qo1oYqanDXBhWnpqOjJy44C+gN7Zl3w1evrWTIdsDnl7zWCAkqt6XZB8s3w
	70My+kNpnwNPA8xgE6iQM76ie9i6A3rqtDxFRcYmIu41D1ls/xN6pHFl63vOy7rirEg0eQXA0fL
	RRtQ9cj9k2ZP7+94Fu73N8EUwheGQyxS1wl1N5AU1qrSYMloWrPWvIQlHul9MzKFq6SBwyKSkty
	WRYkjweeGZxsMw64mtE8Alnw/AEfFynajmBl+zYU7anfNtHqyBpaXqpx+9Ze4gNCearCowxz0Tm
	u2Iy7L6Ms68tdryBa6luPOJFLUK0amYZff/uxsR18MUSd61KybiY=
X-Received: by 2002:a05:622a:134d:b0:52f:f072:a1d1 with SMTP id d75a77b69052e-53054819272mr304914571cf.11.1788830403533;
        Mon, 07 Sep 2026 18:20:03 -0700 (PDT)
X-Received: by 2002:a05:622a:134d:b0:52f:f072:a1d1 with SMTP id d75a77b69052e-53054819272mr304914111cf.11.1788830403044;
        Mon, 07 Sep 2026 18:20:03 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040694543sm104322656d6.33.2026.09.07.18.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 18:20:01 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 07 Sep 2026 21:19:29 -0400
Subject: [PATCH 14/15] btrfs: stop special-casing free space inodes in the
 delalloc accounting
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-btrfs-remove-v1-space-cache-v1-14-5f9a5ba352a7@columbia.edu>
References: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
In-Reply-To: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788830387; l=2215;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=s0Ur7xTjy0MIOogA8x9okj5s/rWZB+OdHIcqrKhE0cI=;
 b=3NrwPqQr9ySlL7xE7GbnNqdtaMAJdSbZM3lZSMMw6Lqhxs3+Yw/iI8CL9N3bYX4lps0y3+y51
 7oe9i1IMDBQAbguWG1sUr/Qrq+m6GNR6+HMOcJIninNv7QdtSU4edqX
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDAxMiBTYWx0ZWRfXx7y2sGpQgP/o
 MbX0XyE2xwXC1VjHxC4DL8sg+Q5oSWJ+hStWk7/f1ebUYvSKu093MyN+xJ10zHfQag9Pbj2eri1
 LXRmiSUgWIaOhbRbAQaVy8kqHS6UIgmNyLmkAWHVF02A1vmumJOxgb3SMqBTN4g5z3gW/MPyT04
 Hfkv2+1/OKz9CeZkv0AXltz/Ob7rEDGyM+EIoEbL1r/bCOGykSekC7+Y8Rbub2kMzWX61hVv7Bd
 siRLL4AN7Njx0k4CiUgsyTo/GsR54QXWFKhivOUqX4TyNoc+B7mC6qCaCxJ1A3H9/SyFAf4r7MD
 7GaCabfaK0Fisdv79oqcGe18waNasncdCS++/C+SIZ6Dcfevm0hw89RH7CX1qIhSN/Q5lMnk5xP
 fgQEqGOii9i2Ht/SqfmAFSD18CT6ckBdDcwQql7VtjJj5rnWUp0g2Ulhh1s4btteMA60lcRHIux
 3Tug6Rveyta9q0TNZOw==
X-Proofpoint-GUID: IbAJ1axDROaIQtwt-eyYc3bzgaStdxEC
X-Proofpoint-ORIG-GUID: IbAJ1axDROaIQtwt-eyYc3bzgaStdxEC
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDAxMiBTYWx0ZWRfXxCXn65wmuOoN
 rbgHV2qRHv5tDTxGLM7venirjCBRzYkAx2L4OR7VbNqGey7xaRg3VRCR5Vq2TkbKhket9Wp4LYu
 5Mq/rBg10Lzhl9wHTE1Ut3NuHBAzLdzgYwEQMEHijih0buHcK+ZT
X-Authority-Analysis: v=2.4 cv=Yos/gYYX c=1 sm=1 tr=0 ts=6a9f62c4 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=bn-TaVTt-omw3cABb-QA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 spamscore=0 phishscore=0 bulkscore=10 lowpriorityscore=10
 malwarescore=0 clxscore=1015 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080012

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
index 389eadc5c28f..114a5c38afd3 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -403,8 +403,6 @@ static inline void btrfs_mod_outstanding_extents(struct btrfs_inode *inode,
 {
 	lockdep_assert_held(&inode->lock);
 	inode->outstanding_extents += mod;
-	if (btrfs_is_free_space_inode(inode))
-		return;
 	trace_btrfs_inode_mod_outstanding_extents(inode->root, btrfs_ino(inode),
 						  mod, inode->outstanding_extents);
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 137d2c1d9c97..3a1230b777e9 100644
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

