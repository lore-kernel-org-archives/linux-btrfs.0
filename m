Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F08248A8B1
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 16:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822521; cv=none; b=ZZExEAcEaoQ5333V4nX3dXNAaIILFEan+H7Ee0h8+ZcjSxJjIp9AZRgYTV166JvA3nigC8PYBc+fHtEgnWUqPf5rmXBRzELb2j8mNMyug2G4kUczeP1dUwryT10jvULzGomSNZ7f/PhtKyIxj9H5pwhvnScw34BZsHIYgRjln2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822521; c=relaxed/simple;
	bh=/YVchR5S3fOPoSd+UmzY7VKVC0VbZwLGaXSm4yMwpNo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MekmK9WprogHQaC6c21WX65/ZlKoqjO7ABy3gXYOeKIXUKBQkBEi2L8hIKHLmyLie9xxjjy7CA4EkP9sArkjJeVQs832kvzei7Yith5N7JNyyhnxvcGeghgfg/dUu2RKLl6lJ06R6HOWAJoAb0c2aeF4H9ixJedFWXPMR5mJGgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=phThMy88; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=ppBNYQrq; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="phThMy88";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="ppBNYQrq"
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CFPNOX850028
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=1Vlj
	D14SGV60YqPS66evjcrTKWDc5maRvVHUTEkO6jo=; b=phThMy88yBXJn3+Yw0Gt
	ioLx281j04HK9hfLfB7rH4tp2vrODKOXg7+YyVPIhSfn5Iyu1f04I+2pws3f00GT
	FSEv6ea7jjcRsmTzxLyVOf89DwXmVy43s4GnNjtcV9uOMcSmMc4AzE7qzsNSPytD
	hVUuZ3yuBaC2ZsPt1n7kXsmGZtjcOLoGlxW00/ZnXS0v2CurGJUc2FF0q9+VSVFa
	LictV7GwCx+y0HT3TW129sOpVQ0IyKP3wBsdSuYAk1Bn+CNbM2ghkpkulNTKzwru
	2RGMEux93XGwh6Z7+h3azpN6FhTgEDD6ccKJqoT3NGoOM9QL/UoXOEKzkEa5Bba6
	qg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4h92680q01-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:38 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5350bf63ba3so63780461cf.3
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791822518; x=1792427318; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1VljD14SGV60YqPS66evjcrTKWDc5maRvVHUTEkO6jo=;
        b=ppBNYQrq+qZlkS1ugVXAnUaCEnXXebsYNx+qRacqAW4jQqULjcEUZ7YpZng3/kfjjy
         jTxT4VWIbZziPIFSviujJloegicZyR6/JjLoIH0zijDV6ezsFMURKHTxFQaIxj6e7DZZ
         +zpKu6d9kC5C5cMvUs3ghyGDIHGQp2YAvP6vdWcn26hswhUCTR5FQGE7bc0A+vtrmAK0
         73JzfteIUTn8QdRrdH/0yiZSPkiwOAPl/rb3NR+Nz1kn6wrGocj7PKVzRX9fZiuxEd3g
         8kEeHEEhOtSr1rghBDmLGLGPtf0snxLchOw96mq9JvPtmhXKn0MentRic9j9VpjYfyOx
         JgvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791822518; x=1792427318;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1VljD14SGV60YqPS66evjcrTKWDc5maRvVHUTEkO6jo=;
        b=PY55y8Iyy0GlYTwWh3gCWVyNakp82KcwkDxobMqVYCWfpUuW8Ttg+1MocSsvS8BUSl
         4/bOzZqyn0KDU0XBvclGC9D4IUe6vAKbG5gspZzV2lbMhtTVyZqHHg4fuWq+DGXH78uO
         T9In7enrD500EwGb4d0lX0SPC5CwojiP0RLF6/jSQSUD9CcixPQkd8/ebUC2TITEKzVV
         o2WrjdpWjkT7ZraD2C2fcLxlJi6R3um5DjI4TO7cZeImW7lDrAFglyGWq7ZlWesZi/HL
         LlrT46vx2ooVc3qxwKRbnp9Qej81AJ903+CPZ30+Vyq3UT8EGU6q61f9cMbhD1t9yHmz
         zX5g==
X-Gm-Message-State: AFq9FYKXXYYu1VkdXo1rovQGK09cpU8NVlwomt6W3DS3ebwNPI52D2mw
	ANejmik1BlPJoMZDk3D5gpkIG6QS9L/HSC//isntezGOoM0DOdq8h0qQ21SqQJKY6k11lijK93U
	dz6aU76hLUA+Pl+HuPN9x3Poek/+lJypAP5w1VxWJeVxxdQRPoBWLF0dkCjoE
X-Gm-Gg: AYBFou0U97kh+1z7syrR8Y3LpogPiUeUUtIHZc8Koj9zkUFdI5tZDL8Qfm10CmB82l6
	MB+VRpCS4Av4BEyRJZX0oE4ZMC4eanZoUmd151hS28llfMhekIFYUh5SgK7VzAGflJzspSSE/ob
	AmLoP0kxqlC+zaQ9H/yHpYuKfnxhudINJDRK7jQdwzX3jL6dEVj39u8rQ6+TCHtuwYUmRs60qFj
	E2DMmFYIzvgwEjwPmV2gAgbA5CN1hTs7NjomfIY5M0XyWA8VeZkH+yZcGX97fDBSdTs3B3AkRyl
	Qu6fADOwBlHx7NzC7OgX3h6lcc32L2nQKFpricUxdRRgFCO1akitm0puOjIkuydVamUEt52ZGvQ
	cMZqwYpTegWH/rrzdhRGgPcAckGGhvzlpqnCd58DgtA5Cw3Q=
X-Received: by 2002:a05:622a:2483:b0:51c:1590:8e13 with SMTP id d75a77b69052e-5359f4892a6mr177199311cf.4.1791822517644;
        Mon, 12 Oct 2026 09:28:37 -0700 (PDT)
X-Received: by 2002:a05:622a:2483:b0:51c:1590:8e13 with SMTP id d75a77b69052e-5359f4892a6mr177198971cf.4.1791822517168;
        Mon, 12 Oct 2026 09:28:37 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-231.net.columbia.edu. [128.59.178.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97c27146sm1411796d6.29.2026.10.12.09.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 09:28:36 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 12 Oct 2026 12:28:13 -0400
Subject: [PATCH v4 01/18] btrfs: update the inode item when removing a free
 space inode
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-btrfs-remove-v1-space-cache-v4-1-f125bd8c07f9@columbia.edu>
References: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
In-Reply-To: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791822515; l=3386;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=/YVchR5S3fOPoSd+UmzY7VKVC0VbZwLGaXSm4yMwpNo=;
 b=o61gil2HuJGikhBkTMmYmyLaqpFAo3Q5gX9p43e7UpT8ZMBZYoY6jUhmERZAhqdtC4LPmFOA9
 fY9zkBiC5cRDE1IDlYCX5rLRJRnmRxHfU8j0seN4abBNDcxC5Xpyfxb
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: IjLK2e73uJ1h-N7AIZ8RkLS_D7Hlc5wT
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfXy1Ok7pdhXB29
 7PWDgo66q6jrkyqMCGOkzs4RkT7jUoi34mnBV4foVuP4NXx36Nc7FfnN6Sz3gwnf9Izhgr4teQx
 MPVS9NnNNW63HZOmEecd6xf8F2AKlnNLaBn3skkshJWEJAPQAoXk
X-Authority-Analysis: v=2.4 cv=EbZd0/mC c=1 sm=1 tr=0 ts=6acd0ab6 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=9fnr1hFzp71kSIFw8uYQYA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=ETvl6l8LCy5A8MvIX8EA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: IjLK2e73uJ1h-N7AIZ8RkLS_D7Hlc5wT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX+9KZAXtUWaMc
 5/B9yJ1ocW67sbjGTxG69/7Dak4+UxIMzBsmaPSo8sQVxk/b1nXHTQnHh1jPIXOGf5/9tiaXCNT
 U2IGPfq1zHc6a4oQlcZaBpwFS5QvexE9nZtEhUus1YzLWoR/K1BUOCpuHVQ9xPV7+BhRL6IJIMj
 ep5+3zCp0URFUYADFTpA/XEdssr0nMabcRQXUwdjplop7fh6DWBXrhbdvlInKDl0F1g4KKFBAVR
 8Thv9sFAAwA5E++4GQSenLr8eYWIOFSydxcHER6suXY/wivVdgVM/5smkDeZ0Jr74kIPdAez4YQ
 WMhtWeU4Wc9+M8GbZ/4CKcnot9lwgxWSkrK1t1AN7KHJybgG+nZx6eRdNXlaOXWGeVuxbws9QYO
 GZ2XDpdGz4OMaElmBHbN7bzE2L+15HDQAZLSTKe1bITuWFQosS1oMPuFgmK4k6YX/orxJr06pTb
 cLlD0WvTI/dq13JXu/g==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11933
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=10 phishscore=0 spamscore=0 malwarescore=0 bulkscore=10
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610120065

btrfs_remove_free_space_inode() adds an orphan item for the free space
inode and clears its link count in memory, but never writes the inode
item. The item is only removed once the delayed iput evicts the inode,
which happens in a later transaction, from the cleaner thread or a
throttled transaction end.

If we crash in between, or if evict can't reserve space for the
truncation and leaves the orphan item for the next mount, the on-disk
inode still has a link count of 1. btrfs_orphan_cleanup() then treats it
as an inode with links and only deletes the orphan item. The free space
header item is already gone at that point, so nothing ever finds the
inode again, and its data extents are leaked.

Write the zero link count to the inode item in the same transaction as
the orphan item, so the orphan cleanup evicts the inode instead. Account
for the extra tree root item update when removing a block group.

Fixes: 455757c322cc ("Btrfs: delay iput when deleting a block group")
Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/block-group.c      |  6 ++++--
 fs/btrfs/free-space-cache.c | 10 ++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 8ff21dde9a46..c6caf63b6807 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1397,12 +1397,14 @@ struct btrfs_trans_handle *btrfs_start_trans_remove_block_group(
 	ASSERT(map->start == chunk_offset);
 
 	/*
-	 * We need to reserve 3 + N units from the metadata space info in order
+	 * We need to reserve 4 + N units from the metadata space info in order
 	 * to remove a block group (done at btrfs_remove_chunk() and at
 	 * btrfs_remove_block_group()), which are used for:
 	 *
 	 * 1 unit for adding the free space inode's orphan (located in the tree
 	 * of tree roots).
+	 * 1 unit for updating the free space inode's item (located in the tree
+	 * of tree roots).
 	 * 1 unit for deleting the block group item (located in the extent
 	 * tree).
 	 * 1 unit for deleting the free space item (located in tree of tree
@@ -1415,7 +1417,7 @@ struct btrfs_trans_handle *btrfs_start_trans_remove_block_group(
 	 * more device items and remove one chunk item), but this is done at
 	 * btrfs_remove_chunk() through a call to check_system_chunk().
 	 */
-	num_items = 3 + map->num_stripes;
+	num_items = 4 + map->num_stripes;
 	btrfs_free_chunk_map(map);
 
 	return btrfs_start_transaction_fallback_global_rsv(root, num_items);
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index e2af75a205ea..4572b3d64210 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -266,6 +266,16 @@ int btrfs_remove_free_space_inode(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 	clear_nlink(inode);
+	/*
+	 * Persist the zero link count, so that if the delayed iput below
+	 * doesn't get to evict the inode, the orphan cleanup on the next mount
+	 * evicts it instead of only deleting the orphan item.
+	 */
+	ret = btrfs_update_inode(trans, BTRFS_I(inode));
+	if (ret) {
+		btrfs_add_delayed_iput(BTRFS_I(inode));
+		return ret;
+	}
 	/* One for the block groups ref */
 	spin_lock(&block_group->lock);
 	if (test_and_clear_bit(BLOCK_GROUP_FLAG_IREF, &block_group->runtime_flags)) {

-- 
2.39.5

