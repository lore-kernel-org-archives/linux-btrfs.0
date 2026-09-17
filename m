Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3D53D953A
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 04:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789617654; cv=none; b=PMYfdV+8rfueQD4I8JGm99Xtyi6lyKgiOb9rDsCn9EGwiwC9bQ8kJLTchtbM8gvu1DwfeN4U2/VVBpdy03FuZiol47gqG1iy7gNaCiCmQDb94btpi3EpRTbb4D9GCI0rNbxLN0VK6kG1hod62reSWZ525C2n07Z+qqO08ySKqu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789617654; c=relaxed/simple;
	bh=ZPOc8twdoJYnvUc7fRjG1xN2c4tNuhM2PWHVMpPgEr4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RXnBepP4jsDV2+6xI7RW0BdF9mBGGNEcFx1TzwTL5CU/VXI9rv0BqnrqRaYRGvAQopmsuqM0EZDn35dFK2RGprOi9OSf1ou9aNQWXuqqux3yg82hLhl4rVEx9T8ViGnauUkodG7Df3s8BOhHrRuqAlzyPWmQOL1I+/aNnakl+Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=aP3XNQcb; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=V0V2/tE5; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="aP3XNQcb";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="V0V2/tE5"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H2YA8w202731
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Z75e
	wDbISR2PJ+Wj16J7HvLLuCXx+W5s4xQMYYFw36Y=; b=aP3XNQcbiU5L9MmssMz5
	VAo4YbqpIV/7CYx3YsRhOjqQHScQoFK+6UMGybCQG7PzUWgrO0Y0g1+qfGN3DYps
	tsn3DrWWzxcJ+rMHdeFnQAoUFLSNA9F/wMbdauPOqEQqn8HP/spvejewV9Em5PuZ
	XPoddc58nGpFGnjlDevmOM70GlnkwMLhVK2va4BCkQcK9CBMtaolqo77tvhtNFUs
	wxTYGYiSGoKRp4eegXd+5Bvws5lhsa/0zd1ydVieR+d35gYLBr3DKBJ91PKENFuN
	tHvfQfcTeq+N+Ma/0EE/lMlG+bw6rftNEeXVIAmgphNRj2oucvBIENUwbtOhca6S
	6Q==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gr1x6adqk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:45 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90e8341cfb4so9567206d6.0
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789617644; x=1790222444; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z75ewDbISR2PJ+Wj16J7HvLLuCXx+W5s4xQMYYFw36Y=;
        b=V0V2/tE5I1mkmraAWtyOb0DtiS7fl9QFOGpQXF6GQrqATIufJBAl3IleLvbKWIpG+z
         d6FZdQkrJhpqtT63SdGoOGM4wsL3KSPI9+ONX87GcyEYryTQFxviNAVG7LiomHzFKw+q
         v+76kSW+JW217JoNRj7i7rb/5jd8GFRN4Oh/rxO0c2ldz4bLb0LLOimQCPxA9xoh7mhj
         YYsQjlVhjtu514waLeZT1B541GgSb6ZDwocU+ld2t44WX0uqjKRWm//36UI/k4fGOkkm
         k0mYGL/onQu8qFUTTzMfbYcdNEQf/O/ybAPeiwU/dh6pOFhweJRu3+OX9xuA2J6JxQQL
         jQKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617644; x=1790222444;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z75ewDbISR2PJ+Wj16J7HvLLuCXx+W5s4xQMYYFw36Y=;
        b=yHqRQvN/xBRQ3U1R5qsXeoDNhcPlt84t6P30NHy0L4XQxDr5mhu2ba9gKBjfBi+TgH
         A77oaw0vElTIZv/Ohy/qUb3sW1gHEEeIGU+8YCGQHe4/+UQU7yRfbokzvja+26bFlCwO
         NCGnALp5RI0iH9QUXEJNSe5f96J7b/bEDVJWIq4crZTnhj53dISCf7ihG/4CFBvucaBS
         hgOiSVU/JJeZ6vhCXxjjilSCwAkdBqf5AqJXiF7qYE9KBmGlvTl1g5BG7Qejc6vX3EhV
         4a0QLfYWkrjY1h0AweBcuWCF8pWM7VjwwnDSO+1jDGFExpQnZ2H6xfykcuZEkOf82f5B
         YRFg==
X-Gm-Message-State: AFuF++lDgve+IlfPafBgZbAZ4B+XYz8HNXIvXcKsZQ6oQ867UThUaPeA
	PlbRljelQ75z1uXgp9FkfFamGbSUJG6DqirSAY8mp/cIaEMdLAhYz0BZgltQw5WPMiJ/9QW7F5u
	MU/pwq8YqXlVhbDSOnRIaTrzvBKWZnE8ROIBSQ1SzQUcPpDr5TIJ/0/BVcSo3VKIFe6uC
X-Gm-Gg: AYBFou1MMT4FLTirZG7VUZeIZcgEG2bD13lmMJuik5Peb+XqBwgD9oS97UXjP6sCofi
	Vc4zs1JlrJUBYfEN1rP5x69x9hGSScpf+OKdcuDCObzFMZ3PD3wuYyetjwOjlbQCXhATx2pzBvg
	edwyCgJKmUqBjbLjZth+iAMp8DhISZApgM//CB7YEKavQJp6FSW3IaIhs2Y3Gieb0yVXtqSHowr
	V4qe55c/JFcBQIzNCy9f9nhZ7lP8aaKXqvy3aA50EWZThExlbvk9WA+odbp3odVoS2u2B8BLUZQ
	+J62anEfnOcNwoJGt+D+pqlE01Y8wukBmhbJ1CvA9LG62TEby9gT//HohRj4j26HOkGyar3Jq2v
	ouTUvvxI4odGhAMO6kz+AtqPX48mbsDQLqrj10H/sbhbymA==
X-Received: by 2002:a05:6214:2d44:b0:912:35a6:3bc5 with SMTP id 6a1803df08f44-9123d7ad39amr105291206d6.22.1789617644296;
        Wed, 16 Sep 2026 21:00:44 -0700 (PDT)
X-Received: by 2002:a05:6214:2d44:b0:912:35a6:3bc5 with SMTP id 6a1803df08f44-9123d7ad39amr105290576d6.22.1789617643858;
        Wed, 16 Sep 2026 21:00:43 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123beadde6sm41748766d6.35.2026.09.16.21.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 21:00:43 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 17 Sep 2026 00:00:13 -0400
Subject: [PATCH v3 17/17] btrfs: remove TRANS_JOIN_NOLOCK
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-btrfs-remove-v1-space-cache-v3-17-10ebde03b96f@columbia.edu>
References: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
In-Reply-To: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789617622; l=3141;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ZPOc8twdoJYnvUc7fRjG1xN2c4tNuhM2PWHVMpPgEr4=;
 b=jfup3H0MxW0SR3BgpvfgxVCp/Fl6/Fw5j8+MGSE2EPYtLP6QaEDhbiYnINB44R0Qcz8djKYlZ
 yG7M0cHyO3UBYnZ3QWAeyHiEvhL8Pq8X8LQRqSzqkaudYn2Mz4KsXU7
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX0y4a/3vvfeqi
 jSB5mLiwAN7V/xBq2+BuUl/eDZw9v71VDBMMrbffA1tPMuZzot1J2lCG1hb1IyQzybJGITJ7r80
 ykeRct+fV7/ZXVYVW3W+QWlYeA/1+7WNrkmrChKMP7dz2luJsx/r
X-Proofpoint-ORIG-GUID: ebTXCwIp8jWL_7RGmGB3Gm4CkY-NbLjO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX28F7lsca0Mo2
 vfB6EZ2p3t2kSNxGuWlLmb30ox8tCuFUhCU09QF0ZiX40K4Ou1yZjgqRfya1iDVv06MWPbxBlb7
 lNgmOaFIlgxqBvwxeILbMyv8K58OmmT2Vwr9glYZKjb/60ozVg14q3oTpj1iQR7N7Zww6hOWuLs
 PwFrj/E3sBEkJ1U5AbyKBD3nlrRBWIideDJfEiDH+3kLfdlGCeSjHdL+zs5UQJhWC77JxAkiz8o
 GjVLcqHsuKh6keL5tiKf2SNzyhH5+R/NrQhZh3qV/+YBbBjEt/kNJpB6GBu94zWu30nY/u49qKb
 QRigNYC7NiB6c2++Q9Jlc/y27zsi5CdfrtPVMZgPMvzfc8Kazt8FqMKFv98vc0CV16OwjdEYWGr
 xxqPufm5bW9G1AjEbhx1XAX3fLHjowf3s5W6DGlPMc5UPIcJejIqIr/UcKa3N6ylsGEKTRW18H1
 iF8So6cZbWxn8y1+rmQ==
X-Proofpoint-GUID: ebTXCwIp8jWL_7RGmGB3Gm4CkY-NbLjO
X-Authority-Analysis: v=2.4 cv=CLS/zhrD c=1 sm=1 tr=0 ts=6aab65ed cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=bdDZCe7T2lofFMgrKTwA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11907
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 malwarescore=0 impostorscore=10 spamscore=0 suspectscore=0
 lowpriorityscore=10 clxscore=1015 priorityscore=1501 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170047

btrfs_join_transaction_spacecache() was the only user of
TRANS_JOIN_NOLOCK and is gone, so remove the join type, its entries in
the blocked types table, and the special cases in join_transaction() and
start_transaction().

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/transaction.c | 17 +----------------
 fs/btrfs/transaction.h |  2 --
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index fb026d81414b..e96dd99ce623 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -125,17 +125,14 @@ static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
 	[TRANS_STATE_UNBLOCKED]		= (__TRANS_START |
 					   __TRANS_ATTACH |
 					   __TRANS_JOIN |
-					   __TRANS_JOIN_NOLOCK |
 					   __TRANS_JOIN_NOSTART),
 	[TRANS_STATE_SUPER_COMMITTED]	= (__TRANS_START |
 					   __TRANS_ATTACH |
 					   __TRANS_JOIN |
-					   __TRANS_JOIN_NOLOCK |
 					   __TRANS_JOIN_NOSTART),
 	[TRANS_STATE_COMPLETED]		= (__TRANS_START |
 					   __TRANS_ATTACH |
 					   __TRANS_JOIN |
-					   __TRANS_JOIN_NOLOCK |
 					   __TRANS_JOIN_NOSTART),
 };
 
@@ -310,12 +307,6 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
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
@@ -709,14 +700,8 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	}
 
 	/*
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
 	if (type & __TRANS_FREEZABLE)
 		sb_start_intwrite(fs_info->sb);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 6b0da4eaa0fa..556c094eadb9 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -106,7 +106,6 @@ enum {
 	ENUM_BIT(__TRANS_START),
 	ENUM_BIT(__TRANS_ATTACH),
 	ENUM_BIT(__TRANS_JOIN),
-	ENUM_BIT(__TRANS_JOIN_NOLOCK),
 	ENUM_BIT(__TRANS_DUMMY),
 	ENUM_BIT(__TRANS_JOIN_NOSTART),
 };
@@ -114,7 +113,6 @@ enum {
 #define TRANS_START		(__TRANS_START | __TRANS_FREEZABLE)
 #define TRANS_ATTACH		(__TRANS_ATTACH)
 #define TRANS_JOIN		(__TRANS_JOIN | __TRANS_FREEZABLE)
-#define TRANS_JOIN_NOLOCK	(__TRANS_JOIN_NOLOCK)
 #define TRANS_JOIN_NOSTART	(__TRANS_JOIN_NOSTART)
 
 #define TRANS_EXTWRITERS	(__TRANS_START | __TRANS_ATTACH)

-- 
2.39.5

