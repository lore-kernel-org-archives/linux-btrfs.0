Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73ED7377EC8
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 16:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774886840; cv=none; b=Bi46sTKMOWjQQ1v/RGnfRIy4UD8o86AiJ+ymL908wKS/WjX8Py8ux7yTC4UDQox9+EjcBP3JqULnn/k8u+hl3abA3cldnOUThJBXAlIRxsKWg7jblYa/PkmFvGVQ4gwe0y+Svh6mHvowhgcx4EqHaoysRG+69vtmevzv696rnfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774886840; c=relaxed/simple;
	bh=Ghx2tGbJf1wo1QTnmla0fnQTwouWwVNikDh1hRjTZis=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oiHDdRa3cO+/gyR43PVNFlMgtGTLYcVFI8Xwvwd3xDF6ovqtncXxPI6VpAqO2eXFYcuGcheGKrX2GyeIGwsGPBO4HRrkpdgKACkNkQ6FH41VVYYO2tKeouIvl7UPd/k/+sprYfBZ+QYfI18ltuJD6PXyThjXZOV40+UX/+DVzYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=SRH6gE7h; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="SRH6gE7h"
Received: from pps.filterd (m0528007.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62U6pWBr4099522
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 09:07:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=OxZ19gzNrgl6tdZCMn
	XNFa/i+IFfHSeu/+rz5MKYTj0=; b=SRH6gE7hrNEwsE0t+J5Nj9oNmaQv5JfZ9I
	HJw3Hlti2VhHPDwjFkIirt6EV35o8VryDlQUBh0DKh1xs7P80O2dbZO36dkXah3D
	1A4bUUEKqPXa6lds7j6CNDQdgoj9FmmmeGkM/YETecSX/dGSUa+QUdDrqs9UP4Ud
	qk07l2cYDMOV6GIodcBJGr5ZGKEvqT/pNV8YzjJ0l/07OK7rHBBFRhYkbFUmwwZU
	5/hYoUzNL/atDXUM7oSeXMb5y7Fe6qfzS0aeXQYEfqsJ8XFq9AXPruSWWTh13kIn
	YMCxZyKFf3MH29+2Wm/Nute2UfukdztYDx4UCmB4IY8OKmDXsfBg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4d730qwu5e-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 09:07:17 -0700 (PDT)
Received: from twshared75248.15.frc2.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Mon, 30 Mar 2026 16:07:07 +0000
Received: by devvm36217.lla0.facebook.com (Postfix, from userid 240176)
	id 992D322746C09; Mon, 30 Mar 2026 09:06:52 -0700 (PDT)
From: Michal Grzedzicki <mge@meta.com>
To: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Michal
 Grzedzicki <mge@meta.com>
Subject: [PATCH] btrfs: fix silent IO error loss in encoded writes and zoned split
Date: Mon, 30 Mar 2026 09:06:44 -0700
Message-ID: <20260330160644.3678224-1-mge@meta.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: qDyWApOzxXn142fTgUAzIPHMYSKFnkBz
X-Authority-Analysis: v=2.4 cv=d6n4CBjE c=1 sm=1 tr=0 ts=69ca9fb5 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=4h92JMTCafKA-fb_NiOh:22 a=VabnemYjAAAA:8 a=bGAskgYhJPmu6S7Wcf8A:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: qDyWApOzxXn142fTgUAzIPHMYSKFnkBz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMwMDEyOSBTYWx0ZWRfXzcjMsn/WgUTM
 lExqT1LDwDIUnScSFInoXdVqqZ6X8gG2RO2YeM6C7gIn1Oy/wvFJwMUjHmA1EILvb8mxNHBz7Xm
 Lt+mmSWAwI4bZogx9Bafyoj13H95iBPpIsHg/SToIqXnuxCoJCInp5YBvz8pczjhx11jSkCiUNN
 oa0D5Q3KEV6u0ULlfiorkf9koSaYfArq41+ipr+1ahF3IjLuJDy2tXwID/7WZjYmStMwN37eSVW
 ti+CvhDLcQuDeG7akO+xOdkMMMpYUif1xjYh1PSP6t8OyGuTYT1GGx6TM0BmSGLxDGCnIVE2QZK
 l32TgVI7qC4iCBv/OKBfj+rqZoK9M9yMls3C/Jw5YGz7PUnFEmJTO0NqOjLhv9DXqFnenRB8ToN
 99oSSUDZlEkM9fWyURMJc6gtHneYndQGvJxGJqfbFPYqDqOOLpxUGnbswM2t/cx5F4WeyOnWIWH
 SOtgkMPgqenHEBAlxZw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-29_05,2026-03-28_01,2025-10-01_01

can_finish_ordered_extent() and btrfs_finish_ordered_zoned() set
BTRFS_ORDERED_IOERR via bare set_bit(). Later,
btrfs_mark_ordered_extent_error() in btrfs_finish_one_ordered() uses
test_and_set_bit(), finds it already set, and skips
mapping_set_error(). The error is never recorded on the inode's
address_space, making it invisible to fsync. For encoded writes this
causes btrfs receive to silently produce files with zero-filled holes.

Fix: replace bare set_bit(BTRFS_ORDERED_IOERR) with
btrfs_mark_ordered_extent_error() which pairs test_and_set_bit() with
mapping_set_error(), guaranteeing the error is recorded exactly once.

Signed-off-by: Michal Grzedzicki <mge@meta.com>
---
 fs/btrfs/ordered-data.c | 2 +-
 fs/btrfs/zoned.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 5df02c707aee..b65c1f1e2956 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -385,7 +385,7 @@ static bool can_finish_ordered_extent(struct btrfs_or=
dered_extent *ordered,
 	}
=20
 	if (!uptodate)
-		set_bit(BTRFS_ORDERED_IOERR, &ordered->flags);
+		btrfs_mark_ordered_extent_error(ordered);
=20
 	if (ordered->bytes_left)
 		return false;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 0cd7fd3fcfa3..d728c3bafc09 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2136,7 +2136,7 @@ void btrfs_finish_ordered_zoned(struct btrfs_ordere=
d_extent *ordered)
 			continue;
 		}
 		if (!btrfs_zoned_split_ordered(ordered, logical, len)) {
-			set_bit(BTRFS_ORDERED_IOERR, &ordered->flags);
+			btrfs_mark_ordered_extent_error(ordered);
 			btrfs_err(fs_info, "failed to split ordered extent");
 			goto out;
 		}
--=20
2.52.0

