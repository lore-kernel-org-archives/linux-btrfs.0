Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883E72853E9;
	Sun,  7 Jun 2026 05:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780810495; cv=none; b=MeY6yXDj/sbRb1VSAPdwvFwRRU0IJDCqfATJSUv3uftQo/VGDGyHcvexz1UjMtDdB5D2Ba8LJrog+N+nNGUMaNCg1eW4WWPbpVPd2Qsgr9DLGqE823mgzas26+qh8qQmlo/HhxmqfXzE6JSDoRq+E5FbywgUMBxcF/simjnJBSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780810495; c=relaxed/simple;
	bh=RrK5YmcgYjJ0bGP62+VZD8Rxpdu5X0IzbdXx7f8k6Ww=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OLUEHawEfzPgVrG4QcDoPiOHp9+BlmyBa9TYLypyYUiqwJ9zoulCf+3D6fOdYggORW6PJP5SlXbh/mevS5BGVddqNVjCpLIwXCty5G7SfZzSmmaBtwM4SePMzvMhQ2An2I1FP3L24gR8meEIUeW5NC0ZncUTLZDCtOZkLBEuYzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=JtZKuu49; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="JtZKuu49"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6575YIms1107068;
	Sat, 6 Jun 2026 22:34:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=ebCIbjC/S
	iGH/Wglp+hkHqKzk44aXz9rYr9cP5QdhFQ=; b=JtZKuu49tOgpqpZ/bDWjSk/gZ
	U48q9yGSL8inIqzvgABRqda9bB2Cwx6iwwO6WYUmBC5O6oQN2AQsQCxWHZBoadrB
	lJVa15iCNC9Yzn9aATKRS2SgYmKmpuSlZA2jwYSxO+8O7SbsIlo/+buZiuzbdZ6y
	fsF823/T6VARmxidmaFBuy8e48CCZ7wFfFNmC5LG5rZV9PxkZQ0ppHMauwFApdbW
	kHccpel8OPUqjgfRwElZPXDwt8mU9+NKeKsx9scDpV18ToR0kQkgEZPyT8/3bLgd
	teiGG/IP6VdccU5tD/KrLN7nvBsm2p2rF0JlejPJK3DUc7sr5g1EhyM13y/sQ==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4emety0w5f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 06 Jun 2026 22:34:44 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Sat, 6 Jun 2026 22:34:43 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Sat, 6 Jun 2026 22:34:42 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <clm@fb.com>, <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH] btrfs: fix use-after-free of reloc_control in btrfs_reloc_cow_block
Date: Sun, 7 Jun 2026 13:34:41 +0800
Message-ID: <20260607053441.1629853-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: P6wMdh5vGrFvkDhjZFexGOTVYiVPU0Oz
X-Authority-Analysis: v=2.4 cv=VKjtWdPX c=1 sm=1 tr=0 ts=6a2502f4 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=MHlOuU6TLEuX1EeffVEA:9 a=O8hF6Hzn-FEA:10 a=DcSpbTIhAlouE1Uv7lRv:22
 a=cQPPKAXgyycSBL8etih5:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA3MDA1MSBTYWx0ZWRfX64wiO4dot5dJ
 x+ebin/3FsCR5+eFuQdHrjEcU5hHdRDbQZuSlOluMlYbZzmq+9U9b8TokXFOc6KT6A8PNz5JtFo
 fqU2H0kM1c/osnOKSndy5is5453CvCIWVKRE4nuMdKArzvFESfvNi4P9tKX+scFQI/+qruqXL9d
 lnlHSwZ+p9TGOkkLYZNR3jj17c0fErox+KPGUMqhivbo2rvBInZ5aWTEx1pZAewPHSMk81iJRgK
 5GFIGlCkRNDd2uKvYOSCb8nfK32/24mKYDRGtCH5NOQ9T+wYFSfsJqtmwwTJkZYzbXKHgjtK1aX
 6m8M8llmTT5GdwpUTGixV9k8d4kv/3WEHNJHBz2LmSTROr7ZMsliWYv5DoyRZ6QxXNOh27OWTQw
 zwF/6baenaGtSxVdvB6YejxUZ9GBqeM4nkrz7A/fcu+RBxGYRSL6pxAf+rBq80XWA9s6D7Ak4vm
 5yZGRrE1PcE+S3pwjzw==
X-Proofpoint-GUID: P6wMdh5vGrFvkDhjZFexGOTVYiVPU0Oz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-07_01,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606070051

btrfs_reloc_cow_block() reads fs_info->reloc_ctl without holding any
lock and then uses the obtained rc pointer throughout the function
(including replace_file_extents which may sleep). Meanwhile, the
balance error path can concurrently call unset_reloc_control() followed
by free_reloc_control(), freeing rc while btrfs_reloc_cow_block() is
still using it.

The race window exists because btrfs_commit_current_transaction() in
relocate_block_group() may return immediately when the filesystem is in
error state (no running transaction to wait for), allowing
free_reloc_control() to execute while other threads still hold
references to rc obtained before unset_reloc_control().

Fix this by adding a btrfs_commit_current_transaction() call in
btrfs_relocate_block_group() right before free_reloc_control(). This
ensures that any concurrent thread that obtained rc via reloc_ctl
(which requires being in a transaction context) has completed its
transaction before rc is freed.

Reported-by: syzbot+0eea49bba18051dea35e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0eea49bba18051dea35e
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/btrfs/relocation.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 3ebaf5880125..a01262d0b2ab 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -5443,6 +5443,14 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start,
 	reloc_chunk_end(fs_info);
 out_put_bg:
 	btrfs_put_block_group(bg);
+	/*
+	 * Ensure no concurrent btrfs_reloc_cow_block() is still using rc.
+	 * After unset_reloc_control() new callers will see reloc_ctl == NULL
+	 * and return immediately. But callers that read reloc_ctl before unset
+	 * are still in a transaction. Wait for the current transaction to
+	 * complete so all such callers have finished using rc.
+	 */
+	btrfs_commit_current_transaction(fs_info->tree_root);
 	free_reloc_control(rc);
 	return ret;
 }
-- 
2.43.0

