Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475212F12A1
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 01:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788830416; cv=none; b=cBjolECq2Q5FXliDYNqQUq0it0y8uy+V/2vxg2pq1ZXzfnBW71R8jI9qnCZd4P6ghgwoKk2PCjH301iDB3d59kRvueOSxi1sNzEeYCfvOfuoajRUMyho3xPQn7XIQS0KaYlnoo1SBbBX259jx1A8aVULgG1O1F/I7uVov8aBzBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788830416; c=relaxed/simple;
	bh=rTEatSh2afYJTS/R+S9oth9gqbiO3TcMxRS2cWJg+9I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZK4Ei89iVu/hmMMgVSuXVlblE9K9mri5pKKQDkjAFZoESPkFe5LWvGRPUO6w8G11Y0P/TZeZxKrJD0TY1zhnIwTCNcvFkoaLp3BzEoIgMACtRh0Y1JXCpyIkYVfRq1n/nDIqigjJ+8JUD5sD4xJjnl2vJSSHjtiD+PyqGDdNom8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=F7n8Ve79; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=wsvbUJrI; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="F7n8Ve79";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="wsvbUJrI"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6880vBBw3739958
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 21:20:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=GK6I
	62eBP+KN+hKQKgUP5QjzfCNYZqmQtRtjxGM6l5s=; b=F7n8Ve79uCInyhpgZzFQ
	bnrcyOL8DNKFOCZfnuvfIceYivutmT8GhkYDKbmHw/mudxbsfWnrblVjwI6gWqRv
	bxnYch57eW+cC92baY077AjlaC8NXyMYmdm1/uDJAk/uTGtedSspwcWFMBcDbWxX
	ImDTnTyIV1UGBB4/c2DEv6cd2EqkfwVjS8tJGxV1a34/SFqGMpGRhd4VGu9PPmUa
	Tfv9fbMp4Lamb5QavYikj/4JPkGIqKdh99SQW3G+jXEIEKKtQ68coUKYrUVnuH7+
	vzKz+kqDeajk3QKR5y5CEoDIv+l0sZniKYbtccE5Lxj0vx89aghnVLCFXeKflnWw
	xQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4y98xxx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 21:20:01 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93917f4ccb4so483259185a.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 18:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788830401; x=1789435201; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GK6I62eBP+KN+hKQKgUP5QjzfCNYZqmQtRtjxGM6l5s=;
        b=wsvbUJrI+KerERenOxp2IozorD1NRqQbeYmJsPR7K8IIF+q6cSBxMAkQwAztIq/SJu
         DgkmYwZun88X54UGcBB15KvDdHQYGiuKqp4NtPt4BhW4QhC3WF4Mp2TyfyYsyeCueIYt
         mQ1AlI/WQj/ajsEMfGZ8xfwg4Y8JufT73HAKmfxtaEYl4k3hJZIMKQwZXHKrlnULo2Mc
         7IkbqbR1JuWThgxONJLvEOBQcqwwYPrZAoui1etnljt5uglKfueLbChcyRkEknyRLs2x
         BOMJ4Ip9fZw6XxnX0GeYG0zHD0PPih3VQNDSELxOAwb1Vnung8a6uznfob61kd9iuQCK
         Fubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788830401; x=1789435201;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GK6I62eBP+KN+hKQKgUP5QjzfCNYZqmQtRtjxGM6l5s=;
        b=qeQfvK6ADhDf7UdWzk9CeXuR3RIatEWU8J5QGtNW/2ga1gV4Ty3WKnsK8qunM/dhwd
         0WxhVR1ZklVdKhikS57XBswgE1u9ul1EOWCv/pXwSaJc0kVVux+wPJ1P5vxG6jfp5EnL
         MvchREG7VsG29HgVKu/bEE5FxwtyIhS0VEsl8UIW01pYmN5ZJ8PqjsqqWCYkyWyJlp4E
         h5o3e9ujyskn/CqqMFKrjjdo1I4+CCRZ/097LVCppzvnTevTXdLCFDi+hUQuDhBI1Nzb
         8A6kBm+3n4ZHGkZubYxRPbZL6+XY0sgAu+fykGpJPUOxY7mMsQAEvlJxIlecFuvbUN6O
         Jiqg==
X-Gm-Message-State: AFuF++nQAEj4xwKAQSXuMEvvZVuvVTvGF1UV+jq3oQevljgD2wezjLp7
	Wo5G8rpu8ibNOTNbql/693NQA9sdNS185tkZREmVkbKave2w/Q6OY4BiV6x3SMIKgw1O2jXIEnv
	MY2yKpBDMS/Cg2LthqetjWs+ysHIjE3d/RfjA56/eaziLsrNTyWRZkYxglqgs
X-Gm-Gg: AYBFou1qlCehbMF79Uz5QKeJh144D2pcQ2eNWKEXJ9HHRFw4sqM4qecqfYt/BmWtfWK
	N1bf5MUjCH4pVZIwf571u7iXxivuAYbnkgZFaOg2GeEXI57HiuviEKBBALVfbROwvXEQlr+zEeR
	PK2psKqddW9oZTCtPShpgsdKi6RA7EJ3jlHL/fzju5WtzwntRJCQBfmUqioQWkRtS29yY9c5HPQ
	fFBzas5cJ6J097AIhULXDas+IzuiIblbHg5hwljFFG/fjlxM7aXb9lVxyVTjVv+5YK8rWzsqgqP
	0vUlCHxVHGPHYK98jdMzTGRgjHBVEONp/7PrsLJpGv4mmR4xGxlWhrID4aLQ1RcCu8Velxl9fpr
	C+Bt8cIrFJ/E1T0yQVK2h2ee9i3XjhSx3rfjh58/vM68jWYAVMGU=
X-Received: by 2002:a05:620a:bcb:b0:939:ad19:c5a4 with SMTP id af79cd13be357-939ad19deadmr994377785a.39.1788830400959;
        Mon, 07 Sep 2026 18:20:00 -0700 (PDT)
X-Received: by 2002:a05:620a:bcb:b0:939:ad19:c5a4 with SMTP id af79cd13be357-939ad19deadmr994366585a.39.1788830399605;
        Mon, 07 Sep 2026 18:19:59 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040694543sm104322656d6.33.2026.09.07.18.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 18:19:59 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 07 Sep 2026 21:19:26 -0400
Subject: [PATCH 11/15] btrfs: remove BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-btrfs-remove-v1-space-cache-v1-11-5f9a5ba352a7@columbia.edu>
References: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
In-Reply-To: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788830387; l=3841;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=rTEatSh2afYJTS/R+S9oth9gqbiO3TcMxRS2cWJg+9I=;
 b=vyHSY9/TnUHDP9/BFrGyZaLEpHlN5VMmjY8Ad8G3nuY6mRdG8nF1FaffM2qYKd/uCWqJtnXMl
 V0z8FsHIzLECXsQ3Lm4inVw8kf6RLOP5i6SAjrF6RfPSIRAsZXJxrAi
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDAxMiBTYWx0ZWRfX9JUraJJOvj9/
 hucHV+HsviY20/h+ex8mJzcWxfYhBZF5Hkx5ruxmO1g44YrYrvP555Q/rs4KK1e3RSZ1wpFgZ6B
 2v+GRQlUnx6caecKjiUOOFHXceN+rFgN5ouwMJ0x3aTs7uaEGaVcM3Wl36akjuy1PRRHg7Wh7Gq
 CtNN9LN2njeeR4SM5vfmHrHSJLjZpcwCO1+uj9FwtJSYyI9MF61/386Pa9u4oZ2EGV2ui0vYQMa
 1cv2iH9M1kfOWI5acDoFLrUoCjFna1G/PZUvXLtC33WHbQlvAxVAMkvgPveJvJfdXda7SpO4Q3f
 G3cg9/iqTX0TDniNCL0FyBS2he1gJLmDIFOWUsW/DWldRiNzhyPos1Mnr85bPYaBqQeSv1iQHrd
 9HB8W6PESxgYHj3daHusTa6y+t3JOCv02ApkLRrTsAz4xnEBwfHwFhgLVZghb8OZ8+CiSVcog4r
 8f6dcx09enDctrhoCFg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDAxMiBTYWx0ZWRfX06jR/L2aHH1L
 d769GBXN+DkyiHThYkghEBV2ykXsEALa1vO9SAEjwZsZsk73K6jVZU7PD5W18fyxVXjZx6wYgN0
 HgBctcRPpgUxPzLQuayoTvCe1x3cWq4kwDwQwmDogOHlGDdPf4fT
X-Proofpoint-GUID: QpQUNrWYPvrqXfBSCkkTfJS3eGxXduob
X-Proofpoint-ORIG-GUID: QpQUNrWYPvrqXfBSCkkTfJS3eGxXduob
X-Authority-Analysis: v=2.4 cv=J66aKgnS c=1 sm=1 tr=0 ts=6a9f62c1 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=BlyEiQbNVX7t3OJdSnkA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=10 suspectscore=0 impostorscore=10
 adultscore=0 lowpriorityscore=10 malwarescore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080012

Free space inodes no longer reserve data or delalloc space, as nothing
writes to them. Remove the flush mode and the special cases that
selected it.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/delalloc-space.c | 13 ++-----------
 fs/btrfs/space-info.c     |  2 --
 fs/btrfs/space-info.h     |  4 ----
 3 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index d357ed7efd99..77781852e417 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -132,9 +132,7 @@ int btrfs_alloc_data_chunk_ondemand(const struct btrfs_inode *inode, u64 bytes)
 	/* Make sure bytes are sectorsize aligned */
 	bytes = ALIGN(bytes, fs_info->sectorsize);
 
-	if (btrfs_is_free_space_inode(inode))
-		flush = BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE;
-	else if (btrfs_is_zoned(fs_info) && btrfs_is_data_reloc_root(root))
+	if (btrfs_is_zoned(fs_info) && btrfs_is_data_reloc_root(root))
 		flush = BTRFS_RESERVE_FLUSH_ZONED_RELOCATION;
 
 	return btrfs_reserve_data_bytes(data_sinfo_for_inode(inode), bytes, flush);
@@ -155,8 +153,6 @@ int btrfs_check_data_free_space(struct btrfs_inode *inode,
 
 	if (noflush)
 		flush = BTRFS_RESERVE_NO_FLUSH;
-	else if (btrfs_is_free_space_inode(inode))
-		flush = BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE;
 
 	ret = btrfs_reserve_data_bytes(data_sinfo_for_inode(inode), len, flush);
 	if (ret < 0)
@@ -326,15 +322,10 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 	int ret = 0;
 
 	/*
-	 * If we are a free space inode we need to not flush since we will be in
-	 * the middle of a transaction commit.  We also don't need the delalloc
-	 * mutex since we won't race with anybody.  We need this mostly to make
-	 * lockdep shut its filthy mouth.
-	 *
 	 * If we have a transaction open (can happen if we call truncate_block
 	 * from truncate), then we need FLUSH_LIMIT so we don't deadlock.
 	 */
-	if (noflush || btrfs_is_free_space_inode(inode)) {
+	if (noflush) {
 		flush = BTRFS_RESERVE_NO_FLUSH;
 	} else {
 		if (current->journal_info)
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 39a28e1bec8a..01018152c054 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -1704,7 +1704,6 @@ static int handle_reserve_ticket(struct btrfs_space_info *space_info,
 						evict_flush_states,
 						ARRAY_SIZE(evict_flush_states));
 		break;
-	case BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE:
 	case BTRFS_RESERVE_FLUSH_ZONED_RELOCATION:
 		priority_reclaim_data_space(space_info, ticket);
 		break;
@@ -1968,7 +1967,6 @@ int btrfs_reserve_data_bytes(struct btrfs_space_info *space_info, u64 bytes,
 	int ret;
 
 	ASSERT(flush == BTRFS_RESERVE_FLUSH_DATA ||
-	       flush == BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE ||
 	       flush == BTRFS_RESERVE_FLUSH_ZONED_RELOCATION ||
 	       flush == BTRFS_RESERVE_NO_FLUSH, "flush=%d", flush);
 	ASSERT(!current->journal_info || flush != BTRFS_RESERVE_FLUSH_DATA,
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index aa836e8a9d4a..d0130c8ba3dd 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -66,7 +66,6 @@ enum btrfs_reserve_flush_enum {
 	 * Can be interrupted by a fatal signal.
 	 */
 	BTRFS_RESERVE_FLUSH_DATA,
-	BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE,
 	BTRFS_RESERVE_FLUSH_ALL,
 
 	/*
@@ -82,9 +81,6 @@ enum btrfs_reserve_flush_enum {
 	 * priority flushing for this, because otherwise we can deadlock on
 	 * waiting for a ticket, that cannot be granted, because we cannot do
 	 * any allocations.
-	 *
-	 * Apart from being specific to zoned relocation, it is equal to
-	 * BTRFS_FLUSH_FREE_SPACE_INODE.
 	 */
 	BTRFS_RESERVE_FLUSH_ZONED_RELOCATION,
 

-- 
2.39.5

