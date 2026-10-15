Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B8338E8C3
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075414; cv=none; b=HU4U55eJYEAgMJw+Vv4hIhjINC661VTmb10cJOUesvi5vinrFGloukdo2WzmCrB/Ri9jg451eZlWZaXX3qC4raB4j3LzSNLMguIxl9HyTNMZWazbmjC6S0PTP1U6ip9F8MAHCN8t0vv9+bipLcMYLM9ffonhbfiJUFSxiPjcVvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075414; c=relaxed/simple;
	bh=/YVchR5S3fOPoSd+UmzY7VKVC0VbZwLGaXSm4yMwpNo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZBFVquos7JdQ0oDDfB+4rY9zD78m0HHbou1jffcjzsFhf0igyqUF3A3mPdedrNNzC6I0tKBxK4ugZZFmDwU+i9ZlODETvJ24LRUtFLnFFMSw5q4NohXDiSGMZmXT8adZvZlxRbaiivXddsL2h97MAhS3sXdP0W4TOhZ18EBEzvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Zo8VbI2x; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=MNlwPPsE; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Zo8VbI2x";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="MNlwPPsE"
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FEYBN91621648
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=1Vlj
	D14SGV60YqPS66evjcrTKWDc5maRvVHUTEkO6jo=; b=Zo8VbI2xIm4X55ggdmxn
	doLs5FP2WenkB+5Vc9WdtJFEJQV/C3Q9jc2nC/vizJgfBwTVQfY2sPt61e6YbNzZ
	eW5d+2aZL/9PxqBi22AuQhkLtYcOVsXFx05rCUX6fXVqJFE0M2+UgoM+q+zYRdAw
	tcMPROvt3i6HTfCZQDMVmLf6kEsplzqRPobymrQeGZfnLjUO2UeJ0gOXRG2AGzsf
	Ni6tBB/Z/7jjl6BdYahua0zoWYT6LRbfexUfqefgOt/IP1hBTr9XA4NMKDcFsOaZ
	DBBhfX6TljPDTOTWVoPFZ2cTzwqMb99MoI/mMyykgq5ADBfwittehgs7ynpz5vPj
	Sg==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hah8evweh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:31 -0400 (EDT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-9179a556c43so110882686d6.3
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 07:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792075411; x=1792680211; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1VljD14SGV60YqPS66evjcrTKWDc5maRvVHUTEkO6jo=;
        b=MNlwPPsEYNktOVlT1dywwzVanlXBGStyWXQyaxqXHMdECXr5vA+zNShSwNbo+hN6C4
         Lift4umWLGqcewCHYJdwMDCCOjeztvsJJMVnTQ3BJP4UJYm7/tDL9xGT2RmavFf34lVI
         c1RHatpYCJ1RpYbaUaw6WVVbJiYvIercmOv6Wn0W8DZ1wiFxD58UQn2W3vIungZq5eNr
         krxpih+Rpu+OUxQ30vt70ZFQcQXlPoTTioZb8tizoIoP7nGePt0z9H9N2I2NQXMKCo4Y
         /YKlTG1JW4zct2DHnvvh+gW97/cWSFnn/DDAK5cPYw0gL/MoN9ur+vi8mqxn8g8HpyZC
         aD4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075411; x=1792680211;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1VljD14SGV60YqPS66evjcrTKWDc5maRvVHUTEkO6jo=;
        b=HiFueoEPFnEZwOgtv/U9EERVPnba0HUlL1qYZGze/WFrLZ1kS4LxZ4zqI2SAEhl1lv
         uus7LRRCnsXPBSzpFSNwH1PAm/qTmbnnAMGk6jq3WQIEeyYIXQWngOOAup4DlZs76pXC
         WHCHwxKr1UI3X4PcjU4RQJPusWpoPEIUp3Lv0PXZ+Jt4tv6z97uH7MAvXLNlxUlXDjAk
         GhatuB85iyTH+EZc7booBlJPH2Mqb2qs8Tvnw8JVcIyJzA2dvTW+IVldCb6aFa5sqe7R
         U4JN/6THHWrpZWKX9ZT/EMLD4UWHjimCRd3UKsJ6KhqqEKiattzpeQ3krtRgq68MKid/
         V5WQ==
X-Gm-Message-State: AFq9FYJk1WuPRkV+HcHtA1MrN13zhXZBlNLdhwVCAbYtei+htF4ZN7WY
	XQUzIOX33UV02KEcAHEdqxPas2WctJ8jFkzFaq5c1BU1BJZmGpV1imNgDRWdMRJzeXrKEGadsGx
	s2rVzlvNXAuSePgbGbCTCgzytzWbnuFu/Sd20F/vwiuz38Z6OEsEq4OzUGMTt
X-Gm-Gg: AYBFou3RxxZNmp7IoTVfJc1PXz2RVXPwCf0b7gjB2SbJddRv/6rnVPIrHbmq9kEaIxI
	AamebTN9Q8tRu+jODrEO7LB5AlY2uoPR0T9noMDE+Wst9Uo1hdmp4WQgdLoj+VQEz8WWhA63MyX
	ByDuQmbzk8EebaGClt2I7Z3F7+jXwbtyUh2TS/KDhfNk/VQErmzWfkVhs05nhK2EdPQFOn4eJs0
	HkVUkMtSq5vT2wVD8fJsiS/oKwMZ2PQe7iyckU/7qWMseCTXa69s3yDsyWS/LMu6NPkK7zY83xj
	iSvIqzo8J80Ls1yfrLOu4xaJYgAks1ydhIWrvPzJpgUv70bPfZ2QYcR0n3RcJ36EMIB4nCpvRk8
	M5fV+0gaTSC6xDqGqvjm0A/1Q5wzHdsRPcx4ta8bgJP8o
X-Received: by 2002:a05:6214:c68:b0:919:557c:f0a1 with SMTP id 6a1803df08f44-91b554d5321mr342797236d6.24.1792075410816;
        Thu, 15 Oct 2026 07:43:30 -0700 (PDT)
X-Received: by 2002:a05:6214:c68:b0:919:557c:f0a1 with SMTP id 6a1803df08f44-91b554d5321mr342796296d6.24.1792075409414;
        Thu, 15 Oct 2026 07:43:29 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b5f323sm83026476d6.20.2026.10.15.07.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:43:27 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 10:43:15 -0400
Subject: [PATCH v5 02/19] btrfs: update the inode item when removing a free
 space inode
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-btrfs-remove-v1-space-cache-v5-2-6b31347d9998@columbia.edu>
References: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
In-Reply-To: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792075404; l=3386;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=/YVchR5S3fOPoSd+UmzY7VKVC0VbZwLGaXSm4yMwpNo=;
 b=73vndTBFmmKrcX/0t5Ui4FucgAi84ospKylKF7iKPRNV1TEuTPM6xNeZPwCuLc0VUcEYnHTQl
 9/jAJCp4FHoDTrOS+In2JaVndjXraBsT4OcbQxs1eIZpovsvyi2BD+c
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: PXx4SwcXSaAlkGp6bTGIFNRsrNIW_w3f
X-Proofpoint-ORIG-GUID: PXx4SwcXSaAlkGp6bTGIFNRsrNIW_w3f
X-Authority-Analysis: v=2.4 cv=Ob8NnRTY c=1 sm=1 tr=0 ts=6ad0e693 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=ETvl6l8LCy5A8MvIX8EA:9 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX7/GgeNwEJ+Kd
 AzgW6dwVRyPv4ZZEltXpl9aWbXQt08nzK1VXILzXGqMeBXtbZvTnXObK3+6osq0lYo+vWshprtG
 cwExLum/xkuZrSja28FARFRTzMxcNKDMvqvN/QAw7FsQ+hYNEWQn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX8aV/hyofT8dc
 Ei6nH3B17Ea/QxZSX3frpkbz5WKbBy4hw1HNNazGC9nrwKOMsBPgi5dEsrJ7JklciSfA1x0XyMC
 dCpVM8o9LbmPu3JWvkUWWBstOmcDuBqVl3qmkV50pNkAcWmDHAJ6Kp+nwDj2MoVGQqAptlIpaFJ
 SpXLS4t4yy3Cvrq9QoZpW7puUczIf78aIpJ1x+enh5SzwmKnAikH2ZTrrmITrRkUl58UxBfgHmG
 ehZZneTeg7dy++s2yHLiXlFodSTVJHJ9ATAw9FGktowRTDDBrVhFttf1L69TrQc9SLBDFRXcWc/
 ZR9zVuH8MYNPoYRGMeBOFKCLiRQv6YPHNCYhNkcJVTFRzi29Q84K1QpM8wnkk0bzLhavImtah4z
 M2zCwFesW8Y6fQNI4uCeSqg1TPsvgLopW8vRy59iYnFDBtwPHfoWUbHerM6VsvS8ajuFfP8kG7w
 VIfZ7UyHAy4W3eL4/zA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 clxscore=1015 malwarescore=0 suspectscore=0 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=10 spamscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150057

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

