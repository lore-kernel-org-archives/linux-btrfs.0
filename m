Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CF1516175
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075436; cv=none; b=m3OCDfzDdMEqmOKveCYDDoDw3mg9+2dUAhtOd7L2RcvfIrR8C0zJX1Xlf9hJRSuWxyQydgek/zBUTfXzBg1sHII+AlwBZhRqP8rOkyni/2xZI+1BL5ftXHGbBkhC7OUu8MpS1YH+kHvfsCF3cf1kFrhf4BEy4n0AAdozgCxOQ7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075436; c=relaxed/simple;
	bh=ZYplXoKTv6BJOxJh1fhHUVD+9p8O0QyONZE+oHmu1QA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ITqqTLgVzXbMKhBOZ6uA3AoNQ5uP5skZyQUw/612bYSF2KipMQ53yXxPXM9wcT56TY0U/v4ee1b/RPuKHZLksYBQHo3rRk6WWdHFtb+7yFoc5FsHSa/Te+HkVEJ37ugr4498HKAnE38qAch00UhAqEmNiu/Scz7EVGIWNEtJ9sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=Gu5LY3v0; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=MHDcwYS3; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="Gu5LY3v0";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="MHDcwYS3"
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FEY6vt854641
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=mqAV
	kb8kP4svMzZz/7/8LyAY1suBjGK0iRLSg4soUIU=; b=Gu5LY3v0waTp8wpnQV6i
	ENWsqvghhfWtZeHr4KyUqyezk30kG35qATefzCKtEB/Et4IHEQPmAabl2uOwSxbQ
	q+h7LuaL2H2GI6LBiutk0fm3LLhLWob1Gg0SPVulwSg2yaPkpP55FMIfSl3riwZc
	SbyNDfANRQNrMKzpbDnuFNDy+NvNf71TXlcRAT+ZV+2JshvJvRo0le1WfUWIdBZI
	w0rK+VdgOyTGeiXI72UIv3ODb/wT2bbNkjWg82A62caTj0JLW07ZDBL+IW4WOtjc
	i6U1etrr/i+ZdlFWZVcQLCvoo2LPZxP/zpuB8X+tfZIkX1tVSCxWl3iF9W4PluF0
	FQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hatthjceg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:53 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-535213e3a7aso111854811cf.1
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 07:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792075433; x=1792680233; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mqAVkb8kP4svMzZz/7/8LyAY1suBjGK0iRLSg4soUIU=;
        b=MHDcwYS3MGsgH4E/OXOyFAtlZOAHI1g3FCU1Ed2qEibm3ZjYwYc7dImB6dmxSe1pZ/
         r62lwTbQrj8ubdJvWqLuFW4MMUu/nCbN5tQsGilqyU5a/SYEXIeW7dZtqawXDHeQLdUT
         xVmNMIx360nFJw6Hq+gsoYmUJTIuG1ArbsaW/oMMxXHY8kN0XOm1/bSmOBs4bx6UiDkp
         PCyw9TBSCbmSvF5xb8t+SUIGtN3d0KkiiwQ1VQHvqo0+y1RxWWmztmFbH/OE64WDWQSM
         /1SNZbdRQFOn1j3JjbPKdaXYS+LGDGoP6agnACtuou3ScGe7RiGUmITQwtHeh15PkcLK
         gnZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075433; x=1792680233;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mqAVkb8kP4svMzZz/7/8LyAY1suBjGK0iRLSg4soUIU=;
        b=ZtJi/AOUD3s2FKtjunnTfTkIIJFnsyIRyEDS3fCWBexIso3I7NSmrXr897p81uqjUM
         6vfyPAvD2e6+V2LD/3MGcp8qjlgnjzj88mu9BURhyoMbzqKeH9Z4CNgCGq5ULCRq2hIZ
         1DTaXsz1vr3uffhXxEpqdE8WGNkFzku6A47R0nDKLBooTWyHWbtCiQjni7983eqzDvGJ
         fXaaD199TmAVParxjajHJs5H0lEdbzwKS74WYEw7Z6Wvbu3O0j4jR7FVGUVccgvfEvKf
         erB6B4wlTb7t5GeychGnp32gwvqUKXUzoDpmfHh7rUMOIpwNCs+NYgXEq/XOspFbvr75
         C+eg==
X-Gm-Message-State: AFq9FYKEiCUY7GcIbPFdWgkluahvjDd1Fi2qRVO6jn7uNOP44xQjNCNK
	DlnN0MVMPeIPS2rR//KWXkTQwAHMgO1otrF1aqrLZeERT7HtR5qFU0X5LZR8jatC3eGbpQHdZhb
	nZKMOoR1BfafHSbFwBKJesocrdUOIxtelv4uANQpb0FPJuk0F+DCeg/moyxgi
X-Gm-Gg: AYBFou3yyVhoLccIn/0F8XnOBGSeE9FJGRPgWvsjhTJVMKcoRYnvd13wXQ1A2xw94lo
	QIhYDHg4KH64Q6wMSTSXKdnan7l19tSpS7/kg1wuqVmAX/06ygY5jVS8Go+UvCB8x2w7T3Vcx6e
	PUi2N5SJrWAlqVM/4ET18z+KXb1ISHGX/CspkpFmFgqrDxpQC4LAp8bJFzsILVddg+wxq2EOCYG
	fy9VyLdDHG6m1zE8SNI91Erk93cg2w9G95sDIQi5W5GA6eqRUpc6RPP7911fn/NOgsJMbiJy2/w
	1gsV7C/QwaqO5VTwoXBO6fw8S57v/YvMO6yODifB3V0Xf41GtX1rejytPHcGu4PiPaJBis3oFsO
	gskASRedLGQUksFQlVRp4NDx3i4JFmmB+9OTsuMIy/ncV
X-Received: by 2002:a05:622a:17c7:b0:530:dc5e:27c6 with SMTP id d75a77b69052e-5359fb6b618mr284052891cf.41.1792075433008;
        Thu, 15 Oct 2026 07:43:53 -0700 (PDT)
X-Received: by 2002:a05:622a:17c7:b0:530:dc5e:27c6 with SMTP id d75a77b69052e-5359fb6b618mr284052531cf.41.1792075432500;
        Thu, 15 Oct 2026 07:43:52 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b5f323sm83026476d6.20.2026.10.15.07.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:43:51 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 10:43:30 -0400
Subject: [PATCH v5 17/19] btrfs: stop special-casing free space inodes in
 the delalloc accounting
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-btrfs-remove-v1-space-cache-v5-17-6b31347d9998@columbia.edu>
References: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
In-Reply-To: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792075404; l=2876;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ZYplXoKTv6BJOxJh1fhHUVD+9p8O0QyONZE+oHmu1QA=;
 b=TZDIonbspB+Hh38+ewtSWkICjdrnXUtWEAAkmSv12GLavtx/AxDihA90af0PFwDAxSPW+PHfn
 E3VgvYCJiN/DuM7mzJiSE/s3xNvelSgp9gzeDCd1/ASIkQOq1gYnAsK
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: ukAeg2EVTVUayomPEv1cWEzlEZex2kMO
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX41y4Y041yodj
 sX3ZCm5IwJDDfg5NFhjA9MEmW/WnczBTJkIRtsSmP/udoNP12aNyYesQwCCqDHkWk9mrxFpo8Jp
 GgNq961LuMMn13PtJ6mkki/vo/f1Z+wqdTFFibGYouTi3Sda6Y2V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX+W2PAwHp/ETi
 D9Yjb3GUxUdXyKyPVFc9m3ltitRk2ykNlKzO/DhehlJTBzPPDO7WkEUTJ09+esOajrSO4oN7yuq
 BY32iNVGYZlbKToJSh1QshhqIEL7w7xL0H9BPcqMxfEhEfx+tczNSKPvgqe3s08P1avwbpxH4pJ
 tEUBb/30/ylLjGdv7gzRXRVODciitRBclBAd8uSU2t4MO2zibaDvWepv6CmKY6iu4/J1CTCTU+X
 UWk4ZsYaCdjVz/XUQQAtXp32FhO4vfSSZ6oXNjsOmjgczUZKzy96fo3yLKRs9mUVn6hjw4fVem5
 xpjK+jHJKZFTj5lveALunToNn8zpn2flgDuhqbjtXPDpyMraQ/kC7cqBnBXAGuIsoyGzauuvKKo
 IFl2Fp4adDKTpu/eup59iNyCSH120KGfSXUeR/ERxKSfwV86EWs8RfyphBUpFnlNXP9sTHQU9gy
 OcvkarlY95gd+/srQPQ==
X-Authority-Analysis: v=2.4 cv=WJvqzXsR c=1 sm=1 tr=0 ts=6ad0e6a9 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=bn-TaVTt-omw3cABb-QA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: ukAeg2EVTVUayomPEv1cWEzlEZex2kMO
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 impostorscore=10 lowpriorityscore=10
 bulkscore=10 priorityscore=1501 adultscore=0 clxscore=1015 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150057

Free space inodes never have delalloc or outstanding extents any more,
so they don't need to be kept off the root's delalloc inode list, out of
the outstanding extents tracepoint, or exempt from the delalloc metadata
release, which skipped the tree root since free space inodes are its
only inodes with data.

Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/btrfs_inode.h |  2 --
 fs/btrfs/inode.c       | 13 +++----------
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index d1c014da52a3..f7aa0d145185 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -409,8 +409,6 @@ static inline void btrfs_mod_outstanding_extents(struct btrfs_inode *inode,
 {
 	lockdep_assert_held(&inode->lock);
 	inode->outstanding_extents += mod;
-	if (btrfs_is_free_space_inode(inode))
-		return;
 	trace_btrfs_inode_mod_outstanding_extents(inode->root, btrfs_ino(inode),
 						  mod, inode->outstanding_extents);
 }
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3fa632a6c920..fd8962000096 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2632,7 +2632,7 @@ void btrfs_set_delalloc_extent(struct btrfs_inode *inode, struct extent_state *s
 		 * and are therefore protected against concurrent calls of this
 		 * function and btrfs_clear_delalloc_extent().
 		 */
-		if (!btrfs_is_free_space_inode(inode) && prev_delalloc_bytes == 0)
+		if (prev_delalloc_bytes == 0)
 			btrfs_add_delalloc_inode(inode);
 	}
 
@@ -2676,13 +2676,7 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode *inode,
 		btrfs_mod_outstanding_extents(inode, -num_extents);
 		spin_unlock(&inode->lock);
 
-		/*
-		 * We don't reserve metadata space for space cache inodes so we
-		 * don't need to call delalloc_release_metadata if there is an
-		 * error.
-		 */
-		if (bits & EXTENT_CLEAR_META_RESV &&
-		    root != fs_info->tree_root)
+		if (bits & EXTENT_CLEAR_META_RESV)
 			btrfs_delalloc_release_metadata(inode, len, true);
 
 		/* For sanity tests. */
@@ -2690,7 +2684,6 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode *inode,
 			return;
 
 		if (!btrfs_is_data_reloc_root(root) &&
-		    !btrfs_is_free_space_inode(inode) &&
 		    !(state->state & EXTENT_NORESERVE) &&
 		    (bits & EXTENT_CLEAR_DATA_RESV))
 			btrfs_free_reserved_data_space_noquota(inode, len);
@@ -2708,7 +2701,7 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode *inode,
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

