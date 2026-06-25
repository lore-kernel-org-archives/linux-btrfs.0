Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1789B3A9851;
	Thu, 25 Jun 2026 02:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782353706; cv=none; b=tf2sY7XxMJymJI42qqPoOyX3ys6Cb+ijqrl5blACUfR9hMkoi1D+G0pYaMGXD/UQ2JsQNDwLQDR7FNk6DKOsNHgGxNknJQe2bbTA4cgWJzYoUVEZ5d7zRUHbbPUBbtkIHKL/QTtqO7V6CSEZgNNSI+NV8ETTU1XlWsyfIhmNZu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782353706; c=relaxed/simple;
	bh=zK6Zn8LZ2Un8EN81JVk870RLyySFBAXebNbi6a6lYzw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Lz+J2rPqLuci5g/WG82Yom+4nXGbz2Xe56XTzYrjEy1VtXbAoqhicx+mXNSR88IHlb3sdMi5nVvTXbsgmeesAS2qByOrDNNXAbUpC4Quc7DQXYndMRcodAk9X9hrNYG/zbmBrg8ZxaozfPMs4O7gmbn2SEus7A94F/Knc28idIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=n0PO6fZZ; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="n0PO6fZZ"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65P1oIKv149666;
	Wed, 24 Jun 2026 19:14:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=cPqeWAudA
	RVJ29E5EnnfOswfH6/SDRoH4ZhZxaZohCE=; b=n0PO6fZZ9Qcnalr1IJc2a+N+7
	w9RkRaDszhe1d75gNV468iVk1yacdtNaZl3xZhaXRuATkl4Bkv1DuUVFJAX3EO6o
	mOAMVT8sJTo4X+FccIenzFoZpI2vAxy9MUtVmX6ctbdB1rAemitt3/0d/rlEZ737
	jGOdO9RMP9j4r7Bv6swUkl8QjvqH51IRFbW7fJY04OALT15mKJQkuKUYKLbZb1UR
	U1XPrTMDpefkE/0AsbJNQ88jzYl2eQ/TO7kiggKRTp2WeHHQYkDjnHUjZcAnfjfI
	PjBVlyH9SwpHRjf1QFttp1/N0Ql5JtNTx9aMoSRt90mCpB4Q5KWwd9RGgI3qw==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f0t06g2m0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 24 Jun 2026 19:14:59 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Wed, 24 Jun 2026 19:14:58 -0700
Received: from pek-yzhou-d3.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Wed, 24 Jun 2026 19:14:57 -0700
From: Yun Zhou <yun.zhou@windriver.com>
To: <clm@fb.com>, <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yun.zhou@windriver.com>
Subject: [PATCH] btrfs: wait for ordered extents before buffered write fallback in direct IO
Date: Thu, 25 Jun 2026 10:14:56 +0800
Message-ID: <20260625021456.724803-1-yun.zhou@windriver.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI1MDAxNyBTYWx0ZWRfXxmBzYo6ljRSV
 HZfJUqLC7te2H5h9QYXtF1l6LFSD0mpurtWE82LllukhnRlJbdjeJnxCSkUon7iPPkLqktuecpt
 TSvoNZOycP4VZFDJxJOr1fNi5MbiJkBZUzpc43t/3WD2Qh0TN6Yg
X-Proofpoint-ORIG-GUID: ojhDkRswJcXkSPiL2eJ4laUGzTW4lumP
X-Authority-Analysis: v=2.4 cv=M6t97Sws c=1 sm=1 tr=0 ts=6a3c8f23 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=iKiJcTA2PjBS6x5JeXcw:22 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8
 a=ryBk4klh6G634kjHyfkA:9 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: ojhDkRswJcXkSPiL2eJ4laUGzTW4lumP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI1MDAxNyBTYWx0ZWRfXw+es6f4yuUFs
 Hg8digURHH/P7jv5fHBtyLg4mOwe86bCf6wc7kJ1jUAjlK3c6EdFBIatEaDdmq07Jhe8aVh01fJ
 XZN+SfPmtbJqufgcHDPxedQDzx9Ewvlc6KjdIjtiSB8HQbWkGhHKPulFO3vRSfiARX2YGGL7l1J
 ZUXlPmZtQ+mtM4U0zHKkMY8TrlGsOk69qFPiTy4hWOSx6KSzgnlCnPXwmPyJG0M3M9HU8tVTYhi
 SG9tPMEACgn/8G2E7iWC9vjA+x9hW1rAc/ptvtCaMaiH7hx9qUdl2WshTdPWaqNZQ9BqkX1ZqYR
 8G0Fv10AsECtRjvWrkhyXzCXBGwH+8rnaNtYl492ilzoHirGIdT2N+2wD/FAmsirwR0LvyP0hKm
 eJFb4v7T6PacfmDrl0OYNlTTnHS40fm5o/QokeEsRa6d4EweMaYigdHvcsGRCH2upXpXrJCHhMe
 zcm6ePT0XsEwxBOSG9g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-24_04,2026-06-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 adultscore=0 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606250017

When btrfs_direct_write() falls back to buffered IO after a failed DIO
attempt, it may race with the asynchronous completion of DIO ordered
extents.  This leads to a BUG_ON in insert_ordered_extent() due to
overlapping ordered extents in the per-inode rb-tree.

The race sequence is:
 1. DIO creates an ordered extent via btrfs_dio_iomap_begin()
 2. Page fault occurs (nofault=true), no bio is submitted (submitted=0)
 3. btrfs_dio_iomap_end() truncates and finishes the OE asynchronously
    via btrfs_finish_ordered_extent() which queues work
 4. iomap returns 0, retry logic faults in pages and retries DIO
 5. Second DIO attempt also fails, code reaches buffered: label
 6. btrfs_buffered_write() dirties pages for the same range
 7. btrfs_fdatawrite_range() triggers writeback
 8. run_delalloc_nocow() -> fallback_to_cow() -> cow_file_range()
    tries to insert a new ordered extent for the same file offset
 9. The DIO ordered extent hasn't been removed from the rb-tree yet
    (btrfs_finish_ordered_io running async in workqueue) -> BUG_ON

Fix this by waiting for any pending ordered extents in the target range
before starting the buffered write.

Reported-by: syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ba2afde329fc27e3f22e
Fixes: acf9ed3a6c00 ("btrfs: retry faulting in the pages after a zero sized short direct write")
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
---
 fs/btrfs/direct-io.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 460326d34143..e8ac9492844c 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -844,6 +844,7 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
+	struct btrfs_ordered_extent *ordered;
 	loff_t pos;
 	ssize_t written = 0;
 	ssize_t written_buffered;
@@ -1025,6 +1026,29 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	pos = iocb->ki_pos;
+
+	/*
+	 * The DIO path may have created ordered extent(s) that are still being
+	 * processed asynchronously in a work queue.  We must wait for them to
+	 * be fully completed and removed from the rb-tree before doing a
+	 * buffered write to the same or overlapping range; otherwise the
+	 * buffered writeback path (run_delalloc_nocow -> fallback_to_cow ->
+	 * cow_file_range) may try to insert a new ordered extent that conflicts
+	 * with the still-pending DIO one, triggering a BUG_ON in
+	 * insert_ordered_extent().
+	 *
+	 * This happens when DIO creates an ordered extent but has a short write
+	 * (submitted < length in btrfs_dio_iomap_end()), which truncates and
+	 * finishes the ordered extent asynchronously while we fall back to
+	 * buffered IO for the same range.
+	 */
+	while ((ordered = btrfs_lookup_ordered_range(BTRFS_I(inode),
+				(u64)(pos - written),
+				(u64)written + iov_iter_count(from))) != NULL) {
+		btrfs_start_ordered_extent(ordered);
+		btrfs_put_ordered_extent(ordered);
+	}
+
 	written_buffered = btrfs_buffered_write(iocb, from);
 	if (written_buffered < 0) {
 		ret = written_buffered;
-- 
2.43.0

