Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CBC5304AA
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 14:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075438; cv=none; b=sruZCz7k6/fGjs7AvNBsJ8Nz5/NG6KB12OH2g5wakFKiId3azF64o0xRfj8YWT5V+z69y2YW9TFVFUOPFCRCjM5sGlgUMX56UvaEodNMvCsBxqJ+CsCWJfhCtSpTh/Z2iONO2PMAcyfVMEi/D3CrMiM8YvCIIiFHdp6YhtgQQ98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075438; c=relaxed/simple;
	bh=rNSnaClTLXC84bceWmGxm4/sCU3gLiaNxuPCtIlu03c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mDtCSZ6hbY3MKR4nrt1CYpAeyVwaxT+StbukC7wxjlGoUzcUSZI0E/WU30XVuMWYpMJ7Zvte5zxrHbEHaLanDV5jkrbyncvs0nhuDSsXvDbAsZ/VXX5iXmH5nd8xck4b067jgx64IAaniAAPCujy1puWqXLdvN2JJ0I7zkk7oD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=bcfHw/84; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=v0fhHKyz; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="bcfHw/84";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="v0fhHKyz"
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FEY8jQ1879328
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=QdPA
	IjpBqYLU00NM6mxpol3m84+3CsnU+LPG1JSnV48=; b=bcfHw/84SzPAQ2/yASJ9
	dqSfaXKKX5kqxgvk2/mmRCZ1nsxzsPbY4N9lA7MaJz6LjIVib19JjVy96OEvroI9
	siqnui89NltbbJLgT8sh9djzc8JNk4BBjzzIFbH2BXBgjc8R0fq6h9URpf+FssWQ
	Ne+QrNJJp4FLKAqKn9/Ct2L6qdDUNe5OHvAlQDfRG0YGGOw/sTW68FwcNOgw6uR3
	eAp0iDeDabdbk/omDRZ7dlhxT4ACxDt30LfL2UUF8n6B/mytIYXusGTpA6kPV/9C
	czWuRDugMPR9JYDmWR8QONla4ujlxZW+BKRNX0Imyot4beN45r5JgvXILA2IvCp5
	9w==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hayffh2e2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 10:43:56 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5352436cd78so14030981cf.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 07:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1792075435; x=1792680235; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QdPAIjpBqYLU00NM6mxpol3m84+3CsnU+LPG1JSnV48=;
        b=v0fhHKyzPSZ03NADY2H/4gjErj3Chr5PNQzd003N68zbkL2AsHm+k0kjwDf/vHpXdI
         6FU0z9xIedutksCJIAxISm+DTmGTBkx+5eDabryU5CQWhrWdFocMmrI731P9aVCdfdaG
         Uer11aa4GPw+2Rq/aN30e5w7x6o8Qx/fZcqNrZrA04d1FSsX7wDB+WC6jtgPivyR/KSb
         kEU+arCVkCV6sjvzth3r9vQVl/WzfRfgKSJCPak+Q4r6VNJeJ6aTrQ7a1oUPDNDP8Lei
         iUiBbD8CZhujxtO5ubifmQ8ywkmwXnuRodk4kLWjdce+XBnWCq1roC4joZ6jJy/Mq6D6
         hLug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792075435; x=1792680235;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QdPAIjpBqYLU00NM6mxpol3m84+3CsnU+LPG1JSnV48=;
        b=pFv8+FFC05wXGtKsR8qnhSswXaNdDfKwpw0nZnmG93dlNjRGyNAuWG0V7wzXtqXWUL
         NiywfUU6+f3IjqRM6TQiY+RZ1rexx/OhQM+ljMb1EDRY5SVQHGRdOs+SR1ExJmgDjBEp
         AqXZy/hVLDLHnLlh3G4Mf3UGpgWCPtcSSeKVmvi9abckjvKnKnJ/N7r4ezJ7UvdbRAii
         0RMwqVEszgl1iIxqFUbNy76Ljjx5hFOFZooFiZbAUTD9EKPJn2T4Q0g20UFLH5wdgyPq
         tENUMaoLVqsFHHNlkTVkbMSXvbv89aumhToXTZbtwqcLiho73gzlVkUhPcwe31Eu5fiK
         e2MQ==
X-Gm-Message-State: AFq9FYJ2ZM4O7VfZ6gBOSQpBVeLwfw4OKOjRzoEDSNTLupMX8P4gVykB
	T5ywmKFApvpOmv67vP4KOg7OR8SVYkEcrmofz0PPpW9yZXMDpHIB6zseRWzuJaNeo9AKPGMYK7R
	wg49gaEgjkmkxrynKp1c+9gvysIZQOtbdPFRAuzLfEJVmGJiBh2+eVSb+7vM8oOJxvNfB
X-Gm-Gg: AYBFou1TFtg9m4sdAiV3OmiSBL6UyQJUs9yUKsI+HK0VFIV5g8WnKKNpRxwD8afunGj
	ZnozL7LZnRdJz5AcXNR/aDNOKiV+FZ/j552IpFz0Eq/O/gLDveRDPesULIqKop73ct4mNmvTSmt
	YnFi0M8Uv4bMNBqKSc8qj9Qynbiv/pYCi217kCzRkFUdKF8puQWlf32SXfmqgr7Ge85JioISl1c
	A1kYdCNwMM4vAwfWzZRvf7Cl9do8OKdb4i+/JL/h94TZTAgdHYnEyaXL4Ocqe7QzpQPrHS86eg3
	I/3qzjs77YZEUSwL9mkDoZ/VixfuBGhptD8McDnkn2FMhzGswgBtLFJq3ivZZIeZf4vrPU7RM50
	cAtEjGXW/qx6E0Ub1gpfz66ogoNVCcL6hJOe5Ll8P0VlB
X-Received: by 2002:a05:622a:4d48:b0:534:e675:4712 with SMTP id d75a77b69052e-5359fb7db5bmr306004201cf.52.1792075435436;
        Thu, 15 Oct 2026 07:43:55 -0700 (PDT)
X-Received: by 2002:a05:622a:4d48:b0:534:e675:4712 with SMTP id d75a77b69052e-5359fb7db5bmr306003851cf.52.1792075434926;
        Thu, 15 Oct 2026 07:43:54 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-51.net.columbia.edu. [128.59.176.51])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b5f323sm83026476d6.20.2026.10.15.07.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:43:53 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 15 Oct 2026 10:43:32 -0400
Subject: [PATCH v5 19/19] btrfs: remove TRANS_JOIN_NOLOCK
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-btrfs-remove-v1-space-cache-v5-19-6b31347d9998@columbia.edu>
References: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
In-Reply-To: <20261015-btrfs-remove-v1-space-cache-v5-0-6b31347d9998@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792075404; l=2612;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=rNSnaClTLXC84bceWmGxm4/sCU3gLiaNxuPCtIlu03c=;
 b=2eROf9FSmdpLkfCt7xwPDrmdtoN6d+A7ELc3fv1nL10z5tTGYM5ue9ovZsS65yds4GHy/6c6P
 Dk0My4Dmp0jBBfqyN5ub6q8igx8dRIXQmSWkREIHSFLkC4IVVAeIj8y
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX+kXtoDy55KHL
 MPjSzpgu1rc8J6mkVJaWQdpfcT+dsu9UzEvw0TXEoxEPjPs/5RbecoJXzAerDWhttKKIbh2UCWv
 AYy1qDujAMTpwJDml7CsVI78WZdgts0ZPGkcypKWrrHlQYNRziG9
X-Authority-Analysis: v=2.4 cv=eJ2GH3p1 c=1 sm=1 tr=0 ts=6ad0e6ac cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=NKoNGjn6KhAaSQkl0TXC/A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=mqiJWszMQxKhrdviAegA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX3RqnxxGeCizF
 8z0kq9iTPLVxWurCs2wWHkPSPPd+YAPG9AgHgirwCMLMdjIk6nhpk6+f24/tndv24cz18tHnh7Y
 rktkiKyS/6CRVQpDMtyG63pq2xlHaP3w8WA5XFnW9MdJJ04V62oW5SARrLomTTuWBnW6ZXTM9Sb
 tJi8D6epq/Y0qJVZoGGDDy1emW0RGCektpnhBVe1L+Fs6p+I9sh7psI473e8VkRatLtDNGBmKLs
 98lKpRhOFutdO+h3tGaJbQ7/wsSU04KoPTnQouGJnNXP51fUEsX9wZH3vKg5htW31SbF+h1lDye
 dfwqYTQG8uTdik4b4M4CeTCc5op6pv42XKycDHSHtXjFkH7STRj0Tbc/fDixTCQAMyFn2ObEs9x
 SKMLE5vgt2RaRftAlWz+54jq/nuUHUOzyMfeEwBhTUdgcASwECyr/8+Oy+GCu2FDrL4uMhYQHfz
 ltARSF+BOniyGHEDizA==
X-Proofpoint-ORIG-GUID: FU4A26400gbWe7eCl0bxH9qsTSqvrJRj
X-Proofpoint-GUID: FU4A26400gbWe7eCl0bxH9qsTSqvrJRj
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11936
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 clxscore=1015 suspectscore=0 impostorscore=10
 phishscore=0 adultscore=0 bulkscore=10 malwarescore=0 priorityscore=1501
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150057

btrfs_join_transaction_spacecache() was the only user of
TRANS_JOIN_NOLOCK and is gone, so remove the join type, its entries in
the blocked types table, and the special cases in join_transaction() and
start_transaction().

Assisted-by: LLM
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/transaction.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7431a06f168d..d265fac023e5 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -42,7 +42,6 @@ enum {
 	ENUM_BIT(TRANS_START),
 	ENUM_BIT(TRANS_ATTACH),
 	ENUM_BIT(TRANS_JOIN),
-	ENUM_BIT(TRANS_JOIN_NOLOCK),
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 	ENUM_BIT(TRANS_DUMMY),
 #endif
@@ -141,17 +140,14 @@ static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
 	[TRANS_STATE_UNBLOCKED]		= (TRANS_START |
 					   TRANS_ATTACH |
 					   TRANS_JOIN |
-					   TRANS_JOIN_NOLOCK |
 					   TRANS_JOIN_NOSTART),
 	[TRANS_STATE_SUPER_COMMITTED]	= (TRANS_START |
 					   TRANS_ATTACH |
 					   TRANS_JOIN |
-					   TRANS_JOIN_NOLOCK |
 					   TRANS_JOIN_NOSTART),
 	[TRANS_STATE_COMPLETED]		= (TRANS_START |
 					   TRANS_ATTACH |
 					   TRANS_JOIN |
-					   TRANS_JOIN_NOLOCK |
 					   TRANS_JOIN_NOSTART),
 };
 
@@ -342,12 +338,6 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	if (type == TRANS_ATTACH || type == TRANS_JOIN_NOSTART)
 		return -ENOENT;
 
-	/*
-	 * JOIN_NOLOCK only happens during the transaction commit, so
-	 * it is impossible that ->running_transaction is NULL
-	 */
-	BUG_ON(type == TRANS_JOIN_NOLOCK);
-
 	cur_trans = kmalloc_obj(*cur_trans, GFP_NOFS);
 	if (!cur_trans)
 		return -ENOMEM;
@@ -750,14 +740,8 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	/*
 	 * Only TRANS_START and TRANS_JOIN require sb intwrite lock.
 	 *
-	 * If we are JOIN_NOLOCK we're already committing a transaction and
-	 * waiting on this guy, so we don't need to do the sb_start_intwrite
-	 * because we're already holding a ref.  We need this because we could
-	 * have raced in and did an fsync() on a file which can kick a commit
-	 * and then we deadlock with somebody doing a freeze.
-	 *
 	 * If we are ATTACH, it means we just want to catch the current
-	 * transaction and commit it, so we needn't do sb_start_intwrite(). 
+	 * transaction and commit it, so we needn't do sb_start_intwrite().
 	 */
 	if (type & TRANS_SB_INTWRITER_MASK)
 		sb_start_intwrite(fs_info->sb);

-- 
2.39.5

