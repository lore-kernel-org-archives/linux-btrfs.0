Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253423AA510
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Sep 2026 22:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788733797; cv=none; b=iqsPh/Gxacgxzut6fkcqBcdl2W8lZZXggOww4Lo7YrGMDOYK2i3CnB9uDFzN7KdV9+4bgDnD7fsOEaFu3Pkwd3heZ4t7U34qUVeXYi8p00/HbJETkcyOmFvQKFkk5cnCGcnI1OUBSBwFFMYa8XTYNjE6vNbU29kIVIyECTpN2L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788733797; c=relaxed/simple;
	bh=UHIoCpUOr80B6OIjSfLBsPGPRqzcBDnVz7IzGXpufHs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=r3dz4u1RJnBNOsm90Tgutjnanm3tAYtaEZm/FWJrjKx0shhcc/4hzE/31xBS648gBDwiLmX5Zs0SL+kILQVabJZoBXZ5s9dKE28jOEb1RuauKQ7ntCUMzJxVq1xjbSgr7Va8seIAvfb9Ugqg3LCh8rWI+gstYAK0TKSx1e+ZnOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=SjH1XWZz; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=XN/EGOBL; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="SjH1XWZz";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="XN/EGOBL"
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 686KRKrP358802
	for <linux-btrfs@vger.kernel.org>; Sun, 6 Sep 2026 18:29:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=HKdH
	npaiIBGa9ZODJMzu07Ab1f2StwCUuRXZsINXD8Q=; b=SjH1XWZzpWstXiLzLxLr
	NtvsgTvirJXay/1MmbBZz/Xe/fwI7wKty95M3n//aAR9aKIiO8+byWzqvIda6zqp
	r0dfKdsWIyz7VzaFbnMD+OGsf9MXI9PAjECCq4wfSXrnwQJdk7qfN9hJ90fqLXfk
	W6l2VNcQ92neJ1b9vkm5EGkGZVKjDYLHaN853SyX7B78L2J7GRdEv3DzS+Wo1enP
	MSrxUCTaOQrhqyHT3LCjBGbADNJxRtK7gzO2rULh44SmzJiFmfLcic+AQqIAo4SF
	Cck2sXyMSQxFuJSZTfboMj+hbG5lfSiYp2xQCDGwCWILgOkUAfasT+bbGy4S7VPh
	zA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ghf7qgc9p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 18:29:53 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-530006c6d43so53966851cf.2
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Sep 2026 15:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788733793; x=1789338593; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HKdHnpaiIBGa9ZODJMzu07Ab1f2StwCUuRXZsINXD8Q=;
        b=XN/EGOBLvPb0YHo6jPHvI2EFzWO/i2zyy+xd7ad/ZMgAT2U6LummZWO5nPrabkANsc
         jMADz9YVLM6hYGoKXOYkObPZQwyxSCJLoDXnrfsOKQBUL+Oq/QctoF6YMUzk3wAcFqwN
         yRNtgKTWZTO509JfeIO9tKBBkOyyAxWdAyv7DUEpuhY3NLOwNBSRQvOV7Z2VUJVW0TAQ
         qSjvVH4FYQ+hTKqcPmSC2/ziGhB8He4lZfR6ttcq7wiT9khR949yEebvfz28mTHjFsIi
         aF77rdiUM8qH6gjKbOg33jNNKwtYJB4Od72qX0Vy/zW+qkV/+B++olNrSPeg6gn5eK6f
         e9tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788733793; x=1789338593;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HKdHnpaiIBGa9ZODJMzu07Ab1f2StwCUuRXZsINXD8Q=;
        b=Wk7lWUHht6FvRy3uaukWqRdQQ3gGRPXER5enZy8o1jEqlJpdvARvh1pKxV2PFq4Af2
         3hIG8fFHgRt7ilkkADISARVdK1izNh7Ww6gNYCrpby2ijAmANBt5jM1Ee+Xuzk8TDF5F
         8ux5MVhy2YLozVad1U0Xf1eb+XowlJ1TMOICdoUnJgI98n+Gs4zUK9CMFrtcMimWAlPi
         wLwSJVT0+n32AiBlagoYL6/pdVM5kmvepcxqsCW2jSI5ELfGUN8dCwKUIysDryGKez4v
         d7BBLukuozlYoAnPL5rMsVDHlY9phszx8yPbwAZJwApQZPboNbUP9JLPw7khcUBQVql2
         sEiw==
X-Forwarded-Encrypted: i=1; AKwUvBztYb0dGIiAov5yJFS5L2F52bterNG0/XVu+HBtwotn7vB/+BHKQRtUn/pobgM73w1akqIlzCS86xcLTA==@vger.kernel.org
X-Gm-Message-State: AFuF++m0ZIUjm31pvPF0JY/PsjRsp+xYRoPDdytvUQhKCYT064CW5xQ4
	apDPkJUfybZVYh+WUjFw5wnJzqJge9jfaklQzKx2mNKaQF1PBzisZ0qU3Sshka1/bBiT+uj465v
	HS1hc9os5is2jli2N76o6HaEu9lWEu5MyhFnvCqIRIlvyaaATvgNwJPIdpkjnLenPShlaUqM=
X-Gm-Gg: AYBFou1lntAHZmRV5DrN6u2muGmuaSWDrSiteOdHJiOIVgVPxvdqckCrDhWfh17RKzE
	73+0VGnR+nuA5sOsxgUs6ahPIWbir3/fqQFjFKLYQx0HpWdN31X4GxrRZwSGAG1cGvkAFUALyV8
	nwBL7oqEIGnFUItF9ryvf8AQ44cf5mMuvk/ofJa2CrXXkOQdFV2DQCsqtUBn4EzV4sBnZPEbDlR
	s2JMBRPUQpXxu3XSFU42r0fNy5D3qqT6IArXkf9Jh0RYwaQij/OgaRS1nS5CKaHPVMK7OaU3BPv
	gJmP4bhunqTlqWWvY3K57llwXf1j1a+8VvuLFePwf6T4MQ4WK64Xi2ZoAmKJBzlSpXznVpcKMuP
	1K1klj4ii1g1Gb6gRTelXsHJ7aj/9lcbeiu0kElVjvZc+xRnq
X-Received: by 2002:a05:622a:d6:b0:52d:4ea9:b3d8 with SMTP id d75a77b69052e-530547f86c0mr210852941cf.3.1788733793528;
        Sun, 06 Sep 2026 15:29:53 -0700 (PDT)
X-Received: by 2002:a05:622a:d6:b0:52d:4ea9:b3d8 with SMTP id d75a77b69052e-530547f86c0mr210852741cf.3.1788733793118;
        Sun, 06 Sep 2026 15:29:53 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-176-104.net.columbia.edu. [128.59.176.104])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305402a7b7sm73048541cf.3.2026.09.06.15.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 15:29:52 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 06 Sep 2026 18:29:28 -0400
Subject: [PATCH 01/10] btrfs: tests: rename process_page_range() to
 process_folio_range()
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-btrfs-folio-conversions-v1-1-834b9d7b06f5@columbia.edu>
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
In-Reply-To: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788733791; l=2475;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=UHIoCpUOr80B6OIjSfLBsPGPRqzcBDnVz7IzGXpufHs=;
 b=pfUCaFVwyjCkzvfcd1YxXFAp3sEb+tjEvyba7nAGOpkPYOhih10JIwU/Rj75RZOw7jUA30O9k
 Lz9Iay/syZbBBFeGk2+SXm/+6SxrDxkadGwUyFKDW3AeQGRNA0tlsyR
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: FJ-a3dBk4aZPmbAlKjnEvUo4QXVt4ZEM
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDI1MiBTYWx0ZWRfX/6EwJKq0MAPE
 65zYYEUtBk8BQIXF9y0sXFufMSz07rVMpiOb14Z3j66JU5bluiLab80oPu/YPYYuWeYBIBl+h/x
 C7HF1QAME5YNzh+TTnC/omh1RjsrpK9sIF2RHNxxziKZlX0ZCjz3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDI1MiBTYWx0ZWRfX8wHRwDCNi09P
 d4OJ6oBDj8w8KWvzo7bXJJFE+1l27lvvQnQg/715ZN/7KLrlCx0jkQZHLnRnSpbYn5a6tSGBqdt
 prQFvfjLG852TLccEk8zvjg2qgGe1DEANXLgFvDKNkqNkW7dCYbQWTBbJJGTf+VY2TwwM/FNGcz
 pfQUl+pD/MxdaRlTDHNdIT+JaEOGvb55MY6oYyVQQenf3zeio9jM4DeO2sahneRBc5HDxyb8Msw
 SGrbK12wl/imw9rfvB+V+vDTGBuRlSAqMgiMC8QEmg6mxWZsd3CIhwIF7g7S3fg/F+3Wp1BYWfb
 Thq6/vEJVTH92XjZfOw0sDhXQLWKrsLJWwlSW4QDTgJtNdkwJnqnx69a6h5gwHn1RuQCzf+mpPi
 8FkUIxafmNVgzZUwl12i+SkPIFF5PCSMPS8cUlLSiOfRWJLsWoP6N5Zprw0FHsSteyZm8QNsKIm
 knuvOv1B3Co0U7N0yFQ==
X-Authority-Analysis: v=2.4 cv=N94Z0W9B c=1 sm=1 tr=0 ts=6a9de962 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=aNLBvxxoObQFLnBXsbaGlA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=pFsSI43hCpC9wVlfDdoA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: FJ-a3dBk4aZPmbAlKjnEvUo4QXVt4ZEM
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11898
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=10 suspectscore=0 clxscore=1011 impostorscore=10
 malwarescore=0 lowpriorityscore=10 phishscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609060252

It already operates on folios. No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/btrfs/tests/extent-io-tests.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 23459cd4e503..6eb55bfb2bd4 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -18,8 +18,8 @@
 #define PROCESS_RELEASE		(1U << 1)
 #define PROCESS_TEST_LOCKED	(1U << 2)
 
-static noinline int process_page_range(struct inode *inode, u64 start, u64 end,
-				       unsigned long flags)
+static noinline int process_folio_range(struct inode *inode, u64 start, u64 end,
+					unsigned long flags)
 {
 	int ret;
 	struct folio_batch fbatch;
@@ -221,8 +221,8 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 				test_start, max_bytes - 1, start, end);
 		goto out_bits;
 	}
-	if (process_page_range(inode, start, end,
-			       PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
+	if (process_folio_range(inode, start, end,
+				PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
 		test_err("there were unlocked pages in the range");
 		goto out_bits;
 	}
@@ -276,8 +276,8 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 			 test_start, total_dirty - 1, start, end);
 		goto out_bits;
 	}
-	if (process_page_range(inode, start, end,
-			       PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
+	if (process_folio_range(inode, start, end,
+				PROCESS_TEST_LOCKED | PROCESS_UNLOCK)) {
 		test_err("pages in range were not all locked");
 		goto out_bits;
 	}
@@ -317,8 +317,8 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 			 test_start, test_start + PAGE_SIZE - 1, start, end);
 		goto out_bits;
 	}
-	if (process_page_range(inode, start, end, PROCESS_TEST_LOCKED |
-			       PROCESS_UNLOCK)) {
+	if (process_folio_range(inode, start, end, PROCESS_TEST_LOCKED |
+				PROCESS_UNLOCK)) {
 		test_err("pages in range were not all locked");
 		goto out_bits;
 	}
@@ -330,8 +330,8 @@ static int test_find_delalloc(u32 sectorsize, u32 nodesize)
 out:
 	if (locked_page)
 		put_page(locked_page);
-	process_page_range(inode, 0, total_dirty - 1,
-			   PROCESS_UNLOCK | PROCESS_RELEASE);
+	process_folio_range(inode, 0, total_dirty - 1,
+			    PROCESS_UNLOCK | PROCESS_RELEASE);
 	iput(inode);
 out_root_info:
 	btrfs_free_dummy_root(root);

-- 
2.39.5

