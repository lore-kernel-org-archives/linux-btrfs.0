Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58483B5820
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075423; cv=none; b=gYFShgtuPkxHjVFSdH5peMuTjKKoxoxspYe3jqxvdVGV6E1KL/Bh6VX7WAXtKPNqKjYJxS8bDdpfQbmw5knWtVHWTD/phsrej9qy6sGyBHWWwL+H1OJmCECFdNgbbu/vxKd7EeOP3ZUx25Pc3DX5Fmx2j3gXWUQ2DSG17LYvpkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075423; c=relaxed/simple;
	bh=FNL3pqb5oRavQZB5jolcB6p6ETy9y4EQsUqUJBYrM24=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=D+5xrQ4Jrh42rF/OjtOpcogTnLJY9r92YkI8Cw62EHKW0cTt20pr4tT7VujSzx6bRbFqOYTIm1B5lWAy6L9OYi2qYkRSZTW2AqXglgJZ6+J8v4tL4UwL1C+Qjeg4gLoy0aJM+48ICk6+2Vypb09DPrwJXhnr/dCgAaIn8zeof24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=oCWIbQmS; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=3tUbb83A; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="oCWIbQmS";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="3tUbb83A"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FEYAFl2220684
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=+w/4
	3zQJVGFpJlES+uyIlRWVtjSFTbm88i4qyzkgrz0=; b=oCWIbQmSPN0cNh5Z7ctl
	EH1bNKxoL2ZguiPLLJS30DT3tL/KcOrKppETZ9ov/fKz6rs2M2LiGXbqJR8HLZhV
	jj2seMotHjjt2SRgD07rD8mlob6FDcrvjYJK0fIlG6e/6QNr8Z1uqXqeEMuEc+Xh
	MGe6Z6xW1Oax8eLQe+Lzsb/by95GKNJAM47IV7qyC02Astz/JMtVciKt4Tz3j+37
	ZhCBGOVBHPclzWhp6Vdod6CoBDHSDfHNY3WAyLlO94Hj+2fA27ZU5hglgPdEhWUv
	9Gd+wbKFy6+YvE5OuxdoVtlkDyX2lsmV/f3jAXm8V+1l9ZSPrrhmH8gzxresekny
	XQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4havrsjadu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:40 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e82060977so9244885a.1
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 07:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792075420; x=1792680220; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+w/43zQJVGFpJlES+uyIlRWVtjSFTbm88i4qyzkgrz0=;
        b=3tUbb83AbfvhoIirXtgG/TZDsynoWFTTJkbajSg6jZ01g1wHtLsYCZ2BB1v726sFbd
         73iWjHYNlNrJTgt95pFZNPvMBRJqMgoWWJIXsz/M8mZsuhhukyyOVWTnrV7TryY5P7yI
         V1ZHdkZgfEzNjeUqXiBbGYMrOZaL0B8SkKuCdYC3o/HjywpkcA7144jMtiHZwvJGGPWv
         Qf3+kC4XXObjy/97733b703BC6ueBZLMftoyFCPg5gAorjhGZTnGoE+wfpMsA/InMBpI
         MwGpkobbTQ6lVOrwOzWSIV3zikJnDr2vWHPU58A6bryUjAkXY68q4Z31NeoWBCKsnwnJ
         VOWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075420; x=1792680220;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+w/43zQJVGFpJlES+uyIlRWVtjSFTbm88i4qyzkgrz0=;
        b=y2glJQws/GFoKCHlPzvtVMoCnndxPPFeM3O718ZwSbCTqedn7kGehu78Qi7aBt4oWJ
         XoxkrnuM5VOl8gLgPkp62FFuvVfOjNoVe2Z1IoajnH8Pp6szKMvQYh6CyfZAwlORv36W
         zQZjN0jMrrAkKenfBRodf+abRqN+Jo1P5a5vL+JKPE1sv9+1CUOFXAR5kb/ygfsF37+O
         4C9/J1TsRhAjlRntiu+/nC2bbQBl6mK+DOS/EPPwxiqVivitHnfnv+OUd2AJjzGm45R8
         e7NzsLWkU8ihEBQ597MHtpkMOcyZCso8aYpSFPL02NHT73NqLXhCYxBX1LpCzNRSeLlH
         cvXw==
X-Gm-Message-State: AFq9FYLbvsBSR4U/JQecvMStGkp9hYhyCjmEr2sXYe0ihTzPyeA52JEe
	twyc5DPu55jvXzqeje9spHswXwPnuZptNLpKkp65nX2uPDT1TCu7uuR7Jr/EDAk0TDjQtdKKPJ3
	20Kztqebjv8V3bQiO2/ytON2EPwamTnWoN0xMmA8Ep3liEhYNHMHdkZ80om7E
X-Gm-Gg: AYBFou1SnkQ+nv7cYJmCiJw8mcwy1WGPH0lmJd/XplMTeWMyIRgWQqk+6pzlen/l7uT
	MuvctEeRty5r3P9r2sSF+KWlfYQFk3ltTzNheIliO5ZWxu0g+y3EfoVPxzls7ZZUOe9RQvLreT0
	bf9bE8XMclEPMirj9trKjiZwUZkPp+ydis/uejVk2/GDZiL5ONuD5nB7kOktrI55gcJuY3LMexp
	J3DGn41ZX/LvAvQqzVwsdoiheUymojxFLwWWARqORCWnrcZZUswuG0MFJy+Vjb8WGwmwlQ7msuR
	RknQtiDq5vZk8YJrYPk0Z5daYtJ6Cru0WZVZEzaXxNXQv/oybC8pPEpweJrlTUN6CR5o7+xzf0k
	1VxC6oRQgmr6rcODH8frQietd49wqXPW4uH2SbEztHQKp
X-Received: by 2002:a05:620a:439f:b0:93c:b895:6109 with SMTP id af79cd13be357-93f17ec6971mr44588085a.9.1792075419684;
        Thu, 15 Oct 2026 07:43:39 -0700 (PDT)
X-Received: by 2002:a05:620a:439f:b0:93c:b895:6109 with SMTP id af79cd13be357-93f17ec6971mr44582785a.9.1792075419175;
        Thu, 15 Oct 2026 07:43:39 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b5f323sm83026476d6.20.2026.10.15.07.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:43:38 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 10:43:21 -0400
Subject: [PATCH v5 08/19] btrfs: drop the transaction handle from the
 prealloc helpers
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-btrfs-remove-v1-space-cache-v5-8-6b31347d9998@columbia.edu>
References: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
In-Reply-To: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792075404; l=4684;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=FNL3pqb5oRavQZB5jolcB6p6ETy9y4EQsUqUJBYrM24=;
 b=o2VbuweaWK3dGwL8LyJvHBx6AVQ8cELv+KB6nBCGrqwLaIeZvaUlahDxH/NUvZ3XPaJjuuXoA
 SeMk0J5s0SbCIr8FD51zcVt3F1l1iQU3i+1Nwj9CM0/T9FlCqPt/Ewz
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: SS-ENUjBRQ8sgK9Q8rvRycrvSa9cIGSf
X-Authority-Analysis: v=2.4 cv=L/KI0OT8 c=1 sm=1 tr=0 ts=6ad0e69c cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=u1qPvHribVpbYRjuRIMA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: SS-ENUjBRQ8sgK9Q8rvRycrvSa9cIGSf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX22KLLvHO2HuW
 r6ens+X2PHX5uxY/KFMzuYjHD8ISMby0EEXjtdnkPkXPwA38KVGS0QPld64/sSStzQbyKq9c1tO
 ZJEGX6ngr4IBAP+grJu4d8qes6TnXCPGHf3ZIS7Oy9btHc6Q6RQ6h4kcLMwGwnfQ/5eMe1zHApF
 qKuNV6v438/xO6OmNARXWteR5rj40HAy1LW17njSn3/aC/UWsfk/ukdwOBTDb+LpvcwkAHkCajZ
 CTJF7oRUUrgDNV94ozAr0dau29NH3k3qWnuozNBld+jft3mP+1ZHpZGsqv48UdH2l47yaQx++Qe
 mDqB7d973x42OjQUOE24YDOs2j/AfIpiWl5a4QY2VVLgyHqcnDDqQaZsVMkUMiiYTcDnXdI9KU0
 kH6FXSDil2ylqXwVAyCNSPCJ/E6XPaocWcfcM/mJGboDx8xhsh9EXxvuKn6illS+VspfwFdQPg1
 2u73LoFPpgqp79vYvRg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX6kcwsxgCxfxa
 7eIUqsBz5+DJfPkn9RDiyA+0KC1GpQsv9k8JC+uxp99H5E/WyKdOpmWe9UdI1+Wf7rkWYzuIYV5
 qdun7a5Y9SAIsLSn8xf2i0qmMkcMULP+oiW1lg8ki8tS1SsurehW
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=10 adultscore=0
 spamscore=0 bulkscore=10 lowpriorityscore=10 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150057

The v1 space cache created its inode during the transaction commit, and
btrfs_prealloc_file_range_trans() existed so that preallocation could
reuse the open handle. It was the only caller passing a transaction, so
__btrfs_prealloc_file_range() and insert_prealloc_file_extent() now
always start their own. Fold the wrapper into
btrfs_prealloc_file_range() and drop the parameter.

Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/inode.c | 47 ++++++++++-------------------------------------
 1 file changed, 10 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4ffbf2a9dfbc..95ec6026f08b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9158,14 +9158,13 @@ static int btrfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
 }
 
 static struct btrfs_trans_handle *insert_prealloc_file_extent(
-				       struct btrfs_trans_handle *trans_in,
 				       struct btrfs_inode *inode,
 				       struct btrfs_key *ins,
 				       u64 file_offset)
 {
 	struct btrfs_file_extent_item stack_fi;
 	struct btrfs_replace_extent_info extent_info;
-	struct btrfs_trans_handle *trans = trans_in;
+	struct btrfs_trans_handle *trans;
 	struct btrfs_path *path;
 	u64 start = ins->objectid;
 	u64 len = ins->offset;
@@ -9186,15 +9185,6 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	if (trans) {
-		ret = insert_reserved_file_extent(trans, inode,
-						  file_offset, &stack_fi,
-						  true, qgroup_released);
-		if (ret)
-			goto free_qgroup;
-		return trans;
-	}
-
 	extent_info.disk_offset = start;
 	extent_info.disk_len = len;
 	extent_info.data_offset = 0;
@@ -9234,12 +9224,12 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	return ERR_PTR(ret);
 }
 
-static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
-				       u64 start, u64 num_bytes, u64 min_size,
-				       loff_t actual_len, u64 *alloc_hint,
-				       struct btrfs_trans_handle *trans)
+int btrfs_prealloc_file_range(struct inode *inode, int mode,
+			      u64 start, u64 num_bytes, u64 min_size,
+			      loff_t actual_len, u64 *alloc_hint)
 {
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
+	struct btrfs_trans_handle *trans;
 	struct extent_map *em;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_key ins;
@@ -9249,11 +9239,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 	u64 cur_bytes;
 	u64 last_alloc = (u64)-1;
 	int ret = 0;
-	bool own_trans = true;
 	u64 end = start + num_bytes - 1;
 
-	if (trans)
-		own_trans = false;
 	while (num_bytes > 0) {
 		cur_bytes = min_t(u64, num_bytes, SZ_256M);
 		cur_bytes = max(cur_bytes, min_size);
@@ -9279,8 +9266,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		clear_offset += ins.offset;
 
 		last_alloc = ins.offset;
-		trans = insert_prealloc_file_extent(trans, BTRFS_I(inode),
-						    &ins, cur_offset);
+		trans = insert_prealloc_file_extent(BTRFS_I(inode), &ins,
+						    cur_offset);
 		/*
 		 * Now that we inserted the prealloc extent we can finally
 		 * decrement the number of reservations in the block group.
@@ -9352,8 +9339,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 					range_start, range_end - range_start);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
-				if (own_trans)
-					btrfs_end_transaction(trans);
+				btrfs_end_transaction(trans);
 				break;
 			}
 
@@ -9365,15 +9351,11 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 
 		if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
-			if (own_trans)
-				btrfs_end_transaction(trans);
+			btrfs_end_transaction(trans);
 			break;
 		}
 
-		if (own_trans) {
-			btrfs_end_transaction(trans);
-			trans = NULL;
-		}
+		btrfs_end_transaction(trans);
 	}
 	if (clear_offset < end)
 		btrfs_free_reserved_data_space(BTRFS_I(inode), NULL, clear_offset,
@@ -9381,15 +9363,6 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 	return ret;
 }
 
-int btrfs_prealloc_file_range(struct inode *inode, int mode,
-			      u64 start, u64 num_bytes, u64 min_size,
-			      loff_t actual_len, u64 *alloc_hint)
-{
-	return __btrfs_prealloc_file_range(inode, mode, start, num_bytes,
-					   min_size, actual_len, alloc_hint,
-					   NULL);
-}
-
 /*
  * NOTE: in case you are adding MAY_EXEC check for directories:
  * we are marking them with IOP_FASTPERM_MAY_EXEC, allowing path lookup to

-- 
2.39.5

