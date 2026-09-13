Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52992386C25
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 21:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334493; cv=none; b=P8DsGP7W/btcguZDL1AzK3brNO5HJYIJwq41KoQjxkvNmf7Xmd3acK3BEfyKfJ66ILX3aI5v1/ttgaxrAyOlFtdpQE5vdtZgDD+OVVm8ky/gNI9/s2HYLJlgt74nZN7iRQaQqbYX/bKLivHvHN8KnU5a8R9qyHDXR79TsTSJEKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334493; c=relaxed/simple;
	bh=Qw6xRMsVJw4t9/S/x7rsDKrF7fU3/zyJMoJYbzy1IwE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Nmw86Z+31YkRMZCTkicGQUZfZA8L35oxw9osxgxId2k/yGgOOA8JVimDrpoh7S54cNOaeX/oIrm4lzc8FPTYvv9KjOdrufpYG1yS87sZZCWrBzxIK/8mezemkHMBAHpYPSircqQ6/tyiQIAAa9XELkNcAqGwiK3xg+RZNQV3v2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Hv3lmAbS; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=wCin/d/4; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Hv3lmAbS";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="wCin/d/4"
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DKueQZ598968
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=8Wyh
	q5ssihSK9up1ann73uoMasXeNXwKo64Ka9RS2oA=; b=Hv3lmAbSlYoNgDU1tJP2
	RPzwjcgSE8v8B2pyvCdwxqFGx+WiVHGDqNneEqqnczeHZB1C8TQZe6+XbHa1EWss
	bFcOwC6YTO3QgraY/NMh1R6PeggYaVb5k864u9kGwfyV/CsYcfFO55EBA1pTfCOR
	Y5Zb7Lyc5a26yNZp94/7FD5AnIvt1PxjWCpJLUemnHC/Ps5tNNsw0EqPw7jtp3Y/
	qcWd+sLKqz8jERzc1yK2Rw4fmb3MiB6qCPQu09Iv56PhCJOvmgeu886UVEW0jk1G
	d068qUovcAcIWNhzOu50WHb1zN72QJmpJ5v2uRpmCfc+M2sOrJL6WdKZK8z67VSB
	bw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gp3ah83fk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 17:21:29 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-530ef845909so26650031cf.1
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Sep 2026 14:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789334489; x=1789939289; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8Wyhq5ssihSK9up1ann73uoMasXeNXwKo64Ka9RS2oA=;
        b=wCin/d/42++bHfby+wlc9z/U4646qUU5os22adlZKnFDXrlPLIHyzB96ssIQXSEbFS
         XhaYOEbmHc2iLB+8N/vuhrOyUm3KCDRduGGNEu6Se0zrDKV262yhQaVP4f8a6lrsb0n3
         MV+oAaVzEcJT6EBST68Jc4Uhcn+VBhalB40WgNfEL/eWrvt89b3Jzh5uxX9hCojH5pR/
         KS51X9mqzMaTQSrn7sHY2d2ubVJ7P2RAGHgOa5BDY5Xf43zR/6kouH1QNkFge+bEd+lV
         GpXX9ilAfiE410nq5R64WDrPBP36zZYkMnRkH0N/pA1yr9dR+aaYkU41VD0iwB8kgK1R
         II3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334489; x=1789939289;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8Wyhq5ssihSK9up1ann73uoMasXeNXwKo64Ka9RS2oA=;
        b=Mubk9FFclDWrucsY/9SDf6WvPopKQ1L39tqN/r19KGrxoHVFQphvLK4L2wVZd/lONW
         0r4F/UKHsUEn5hJVfusG/3fUW+FPc90MnVcMeAIDzUyay5t2JE5UqvvKBAylb9g03RHf
         3M2v2OrMoX4zU6l1nxF7QxDBsvW/p9QHQ/Gp/g5VCyVfDITJRB5WqvrnaBrGBPmYsUWR
         +vhbBdmoyDJ4E9r3Wqx2qT6OmWlhxgxD3XHfmRwDjlAHBNqqQOObUSox18wk2JYxL76t
         PLJEMH1ipnHXkcXUDmZKdoNFD1yGFooopUrduU6ZQJ+LyOhObkhQhSntY9A4/BnCKGfG
         eMPQ==
X-Gm-Message-State: AFuF++lbD7U0U/IgIPv8mQfJmTglhV/DLRRj/w4g0U6uI3VBQZBIMgfV
	Oip5FNmnKeNf9hdEVg3XKY15w7LrmksGTqvMKZLt0ywbtC0a8SROiBGrQa0P+OMmmYAlq93gX+y
	LMEqNx2EFpBz2MRl/xasoyqmAxR8040p6lvk+zJPntCgMxxyeN9Hu5MJbBDo4
X-Gm-Gg: AYBFou0NUVDhRPJTG0THTY7pZCghTGrgo84fHRGNNw1ce1a2w3hnH6f3GNOC9GbuDo9
	T1idBOKIwznU80xjvp1+bftOQSzeDY40ZQuCPf9WG3+WnjQlG4aGELnmM35J8RtDYSdKqmJjlAp
	0V2EnoPnXETh2+rGAkS7/01se/cvlAWcnTwGwodm9regVMnhUH7Idz2Zy2pJLGghRqy6aboFYzR
	sbuY38xEt44ukQtmcDiyXTviKHF0jSIjSP1ybR7nqqG7Y0LxOs7Q5IiFmlHwJudWDgb1lzI/Ol0
	je1gfjZqoV48yva+uq3LlwDK+UnuiHh6JZJrncOmcOR7URqwkrjkOGI7+SYoesujDLnklyCimRm
	vp+GLbM0gH9hPEjC3ycxKFtaAmlcspwtgtudhSkSMFMacahIkKXjQzQ==
X-Received: by 2002:a05:622a:2617:b0:530:42e4:f282 with SMTP id d75a77b69052e-530c876f236mr268834031cf.43.1789334489445;
        Sun, 13 Sep 2026 14:21:29 -0700 (PDT)
X-Received: by 2002:a05:622a:2617:b0:530:42e4:f282 with SMTP id d75a77b69052e-530c876f236mr268833671cf.43.1789334488994;
        Sun, 13 Sep 2026 14:21:28 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-215.net.columbia.edu. [128.59.179.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d3a50sm78432696d6.40.2026.09.13.14.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:21:28 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 13 Sep 2026 17:21:15 -0400
Subject: [PATCH v2 03/16] btrfs: remove the free space cache endio
 workqueue
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-btrfs-remove-v1-space-cache-v2-3-186767a7e106@columbia.edu>
References: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
In-Reply-To: <20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789334484; l=5247;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Qw6xRMsVJw4t9/S/x7rsDKrF7fU3/zyJMoJYbzy1IwE=;
 b=qmNOH8C/39Y7ZBnAqLnxFxa0VekU2u+K+Cv8RGX7D0U/nxWC2+AUDko/sizVzUdMDG8WflsvL
 /pp0RPcmnNOBdWed6hk/izV4Bcyo76bUTV6n8vWu5qUhnT3+YAECr7s
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfX7d3zK5zRutIj
 g2YVs8H+1Txn/PXTKMzpniomCgeTkv3zjqm9x1R3qIzeobl+mfdkKnbtCn1Grvw8/t4/RaHtYVR
 KdOYTeLt+wo/CTRlAJNdU8KMTAxKHpcKnGspikv5K7hf5P3Lf++H
X-Authority-Analysis: v=2.4 cv=Z4x5j3RA c=1 sm=1 tr=0 ts=6aa713da cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=2jelXx5xVcRIF5zNctN5Qg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=MjXS7SgsmouH5g4WD6EA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-ORIG-GUID: Tvjr-6fM9vN_JbZx9qgq5kqH9ntyGkae
X-Proofpoint-GUID: Tvjr-6fM9vN_JbZx9qgq5kqH9ntyGkae
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDMwNCBTYWx0ZWRfXz27HFp+Gamx/
 hxUOd8ibUR7BCyrfJuwryBA96VkJBNDotpKx+1TAsUiowhlBeGaVWyACu3pRVcD+pskAXiCyfY6
 Ju88Xu94KZ+baHkcMqaNajJtCBl7t5m3+qIAi0ot77alJH1rxEbEj+ujcwt2Et0cxOm+gjTwF46
 3Jbg/mggPJ8d7iOxxZeZn2DmY0hzgWRxgWIZE6H2sosBwPJF0G8hZXUmYCxNT4uha6YpuxEKqZz
 7EheCM/zPJR1+U9m0JODJ6vtNFOX++USqLMudnPJiATip9O8+KZdRpJ1ojtMYeI0m+DqyTFFy2s
 9fqkV/Qmm3batZA7Bpg7HEltv/0wQJCmBVoJkWVo3neM95gPb16eZqqeqGq01xEbek9TjALNWC8
 QlQjepqMQ9son0vTQcFMQohddCLHG3DCKxYk2l7K/NhaLzVd3hdxqYW2EX6Q1g92JOkDSOS1KMy
 lP2Wo87CWkxK5k8bfuA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11904
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 clxscore=1015 spamscore=0 suspectscore=0 adultscore=0
 impostorscore=10 bulkscore=10 phishscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609130304

Free space inodes are no longer written to, so nothing queues ordered
extent completion on endio_freespace_worker. Remove it and always use
endio_write_workers in btrfs_queue_ordered_fn().

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/disk-io.c      | 14 +++-----------
 fs/btrfs/fs.h           |  1 -
 fs/btrfs/ordered-data.c |  7 ++-----
 fs/btrfs/super.c        |  1 -
 4 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f544c457d4ab..f256a91f58b4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1769,7 +1769,6 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	if (fs_info->rmw_workers)
 		destroy_workqueue(fs_info->rmw_workers);
 	btrfs_destroy_workqueue(fs_info->endio_write_workers);
-	btrfs_destroy_workqueue(fs_info->endio_freespace_worker);
 	btrfs_destroy_workqueue(fs_info->delayed_workers);
 	btrfs_destroy_workqueue(fs_info->caching_workers);
 	btrfs_destroy_workqueue(fs_info->flush_workers);
@@ -1980,9 +1979,6 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 	fs_info->endio_write_workers =
 		btrfs_alloc_workqueue(fs_info, "endio-write", flags,
 				      max_active, 2);
-	fs_info->endio_freespace_worker =
-		btrfs_alloc_workqueue(fs_info, "freespace-write", flags,
-				      max_active, 0);
 	fs_info->delayed_workers =
 		btrfs_alloc_workqueue(fs_info, "delayed-meta", flags,
 				      max_active, 0);
@@ -1995,8 +1991,7 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 	if (!(fs_info->workers &&
 	      fs_info->delalloc_workers && fs_info->flush_workers &&
 	      fs_info->endio_workers && fs_info->endio_meta_workers &&
-	      fs_info->endio_write_workers &&
-	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
+	      fs_info->endio_write_workers && fs_info->rmw_workers &&
 	      fs_info->caching_workers && fs_info->fixup_workers &&
 	      fs_info->delayed_workers && fs_info->qgroup_rescan_workers &&
 	      fs_info->discard_ctl.discard_workers)) {
@@ -4442,9 +4437,8 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	 * to finish an ordered extent - end_bbio_compressed_write()
 	 * calls btrfs_finish_ordered_extent() which in turns does a call to
 	 * btrfs_queue_ordered_fn(), and that queues the ordered extent
-	 * completion either in the endio_write_workers work queue or in the
-	 * fs_info->endio_freespace_worker work queue. We flush those queues
-	 * below, so before we flush them we must flush this queue for the
+	 * completion in the endio_write_workers work queue. We flush that
+	 * queue below, so before we flush it we must flush this queue for the
 	 * workers of compressed writes.
 	 */
 	flush_workqueue(fs_info->endio_workers);
@@ -4470,8 +4464,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	 * btrfs_finish_ordered_io() when we are unmounting).
 	 */
 	btrfs_flush_workqueue(fs_info->endio_write_workers);
-	/* Ordered extents for free space inodes. */
-	btrfs_flush_workqueue(fs_info->endio_freespace_worker);
 	/*
 	 * Run delayed iputs in case an async reclaim worker is waiting for them
 	 * to be run as mentioned above.
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 10e15a319b93..96cc8c50af82 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -712,7 +712,6 @@ struct btrfs_fs_info {
 	struct workqueue_struct *endio_meta_workers;
 	struct workqueue_struct *rmw_workers;
 	struct btrfs_workqueue *endio_write_workers;
-	struct btrfs_workqueue *endio_freespace_worker;
 	struct btrfs_workqueue *caching_workers;
 
 	struct workqueue_struct *fixup_workers;
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index b32d4eabe0ab..e9f1cbeb555a 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -417,13 +417,10 @@ static bool can_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
 
 static void btrfs_queue_ordered_fn(struct btrfs_ordered_extent *ordered)
 {
-	struct btrfs_inode *inode = ordered->inode;
-	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	struct btrfs_workqueue *wq = btrfs_is_free_space_inode(inode) ?
-		fs_info->endio_freespace_worker : fs_info->endio_write_workers;
+	struct btrfs_fs_info *fs_info = ordered->inode->root->fs_info;
 
 	btrfs_init_work(&ordered->work, finish_ordered_fn, NULL);
-	btrfs_queue_work(wq, &ordered->work);
+	btrfs_queue_work(fs_info->endio_write_workers, &ordered->work);
 }
 
 void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 77443ded6db3..b44b16970a62 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1243,7 +1243,6 @@ static void btrfs_resize_thread_pool(struct btrfs_fs_info *fs_info,
 	workqueue_set_max_active(fs_info->endio_workers, new_pool_size);
 	workqueue_set_max_active(fs_info->endio_meta_workers, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->endio_write_workers, new_pool_size);
-	btrfs_workqueue_set_max(fs_info->endio_freespace_worker, new_pool_size);
 	btrfs_workqueue_set_max(fs_info->delayed_workers, new_pool_size);
 }
 

-- 
2.39.5

