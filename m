Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D15646D2D2;
	Tue, 21 Jul 2026 19:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661125; cv=none; b=TcusKNAxjqNJLoDZAUp0GFywfLRNvp6yHaVcA3faT/+a3Pl2/qEoTIxd0qgYoF7panEfZNdkT4TcBCBvES207HzoDLXLh/LhPx1fKao5o4xGHQUQbzHflRarIdiwBuwQJAyyF0jm2orEsVcKA2ECIiJ2gQHbYp+vAWYJP+GMLd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661125; c=relaxed/simple;
	bh=SVtmnrDgzmytYmgKNyzSjghshMKzRFwGY/OrdOkrf4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6tSpADxyH34Rn5lCOPRw9gxHsWqTKLJNMy0Fc6jrCcUpQSpHfsZf4Mnlmutht7gplxaiEcgVaZJCXWPWFhDRPAp1/ui/2YjzGr+/LP8pmfaHm0b+dbgH4anUbp8WPbjb6mi6q/w9mt17YWxAI5l2p41MKFS4ONwG7B7/zIOIV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZCChT56S; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZCChT56S"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LHC3Rh1568250;
	Tue, 21 Jul 2026 19:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=CoJISaD0xwBlW+UzH
	HDwvt4good2ZbyBj1uK4Oh/9Qk=; b=ZCChT56S5jmi7OksOjCIz66zzkPczeoPT
	K0wr1PG9IYcyK9VXdmcJTuAre6RhVbPT/mxJ1hC1ZO/Ph9tA1Sa/3NU99RWE1z6p
	5mqZ8gnO6Bduc253GZv8GcS/itQIIO9Oe63NiDHUsfMwk4xkU/7VspzcKTEVsyFb
	xF8Z2ERqrASrjS4i25PziNahpmCecgclNQvRV0ALynaPJSk6laIk7ji8JuCScQbs
	ZKpFqve684voa3njzmepgawxnPYux6nf6HeYhWJqE2cn/qbHUfcYKko5Lus9xRQA
	B6dQtPYOF1kMC6r2ouv8ZAbzALXzWss3UkeffEBDE1Cu2MZSpLkag==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg77k6111-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 19:11:59 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66LJ4ZTM031448;
	Tue, 21 Jul 2026 19:11:59 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgp1gbn79-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 19:11:59 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66LJBwZi8258244
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jul 2026 19:11:58 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 797C758059;
	Tue, 21 Jul 2026 19:11:58 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E92058057;
	Tue, 21 Jul 2026 19:11:56 +0000 (GMT)
Received: from li-d98989cc-2c66-11b2-a85c-93ab83b7dd53.ibm.com.com (unknown [9.111.46.140])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Jul 2026 19:11:56 +0000 (GMT)
From: Christian Borntraeger <borntraeger@linux.ibm.com>
To: linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Cc: borntraeger@linux.ibm.com, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc() for folios dirtied behind btrfs' back
Date: Tue, 21 Jul 2026 21:11:51 +0200
Message-ID: <20260721191152.101118-2-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721191152.101118-1-borntraeger@linux.ibm.com>
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=HJXz0Itv c=1 sm=1 tr=0 ts=6a5fc47f cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=xlj9eoMxhFQeLdX-qC0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDIwMSBTYWx0ZWRfX5KAfUXpIsyfb
 AvsGCYktYaYVVGPwyYgXHK/TTLgT3JpAX2DJnf8q6TjdDs2374/QMIZE+iQ0283R4Y3plg5GsQv
 Dzic38K/ueTzQ5DmQI+8O8CSwrcYm3nSHc/FufBwYmMsux+WLnSK/ZWImbQYdjPb/uegi/Ea7co
 6fySj4SUgNbtM4fhKppqXSA+1Rx4sCG6TuYAe/aQ1qmB5PqQAmHOS904Ki2MLXg6w6OJmPVQZmM
 VBnxW+Qw/Ipl4pWykNhtHq8Ay2ZeGsCXUxrlAdrCBD5qhPUbvGVzQvof77VR0ZLC6e7rdA0qZSO
 KnldLxODLi4UzI+xhYQh+jYAhcIHZxN6pArYD8QyYha5Pob5pfHbG9eMrqDdirKCJUK1iMplpMm
 qXoL1t3i/Sq84jKLciiyyernCmqo4IyMcNs5OkV6TVmqJTKBeLklmnVmgDmhA05G/f6e+pYWgve
 xAIrJYw92ag9q5az4Bw==
X-Proofpoint-ORIG-GUID: KASWj20T1B80BHBgiDUsCdqpLUqlU5pv
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDIwMSBTYWx0ZWRfX2tsC7K51Gzl3
 n3qMXMXn+WiboeFPPWm4MfXaq7twIihIPDdRGu/cFSo5IleIF4EErzJqoWTt+n/21xSxauUFq81
 mpb1hhj+bUMtlKP+ELC+P/n2EWgc78c=
X-Proofpoint-GUID: KASWj20T1B80BHBgiDUsCdqpLUqlU5pv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607210201

A folio can carry the folio-level dirty flag while its btrfs subpage
dirty bitmap is empty: btrfs data mappings use filemap_dirty_folio(),
so a generic folio_mark_dirty() call sets only the folio flag and the
xarray tag, without setting any subpage dirty bit and without a
delalloc reservation.  The typical source is set_page_dirty_lock() on
a GUP pin, e.g. the s390 KVM irq adapter path
(adapter_indicators_set()) which pins guest indicator pages living in
a file-backed guest RAM file, sets a bit and marks the page dirty.

When writeback then picks up such a folio, writepage_delalloc()
copies the empty subpage dirty bitmap into
bio_ctrl->submit_bitmap, sets up no range locks (nr_locked stays 0),
finds no delalloc range, and finally hits

	if (bitmap_empty(bio_ctrl->submit_bitmap, blocks_per_folio)) {
		wbc->nr_to_write -= delalloc_to_write;
		return 1;
	}

which is meant for "all dirty ranges were submitted asynchronously,
the async paths own the folio unlock".  But nothing was submitted at
all, so extent_writepage() returns without anybody ever unlocking the
folio.  The folio stays locked forever and every subsequent locker
(page faults through btrfs_page_mkwrite(), other flushers, delalloc
space reclaim which then parks holding fs_info->delalloc_root_mutex,
syncfs, ...) blocks in D state.

This was debugged from a crash dump of a hung s390 KVM host: a KVM
guest with its RAM backed by a file on btrfs (zstd compression),
where a 64-page (256K) large data folio of the guest RAM file was
found locked and dirty, with an empty subpage dirty bitmap,
nr_locked == 0, no PG_writeback set and no outstanding block I/O,
with two vCPU threads, the irqfd worker, two flusher workers,
khugepaged and syncfs all queued behind it.

Small folios are not affected because
btrfs_copy_subpage_dirty_bitmap() unconditionally reports bit 0 set
for single-block folios.  Affected are subpage setups (sectorsize <
PAGE_SIZE, e.g. 64K page size kernels with 4K sectorsize) since the
introduction of the submission bitmap in v6.12, and - much easier to
hit - 4K page size systems since btrfs gained large data folio
support, which makes every large folio take the subpage paths.

Fix it by detecting the empty-at-entry case right after the dirty
bitmap has been copied, before any range lock is set up: there is
nothing that can be submitted for such a folio, so clear the stale
folio-level dirty flag (nothing will ever be written back for it,
and all dirty flag setters serialize on the folio lock we hold, so
this cannot race with a new dirtier) and unlock the folio.  Since
folio_clear_dirty_for_io() intentionally leaves PAGECACHE_TAG_DIRTY
in the xarray, also run the same set/clear writeback dance that
extent_writepage_io() uses for the submitted-nothing case, so the
stale tag is dropped and the inode can go clean again.

The data written through the GUP pin is not lost; it sits in the
mapped page cache page.  It is simply not persisted until a proper
btrfs write path dirties the folio again - the same long-standing
semantics as any pin_user_pages() write to a file mapping that the
filesystem was not informed about.

Fixes: bd610c0937aa ("btrfs: only unlock the to-be-submitted ranges inside a folio")
Assisted-by: Claude 
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7d604524e83c3..6a4a00ad43321 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1492,6 +1492,33 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 	/* Save the dirty bitmap as our submission bitmap will be a subset of it. */
 	btrfs_copy_subpage_dirty_bitmap(fs_info, folio, bio_ctrl->submit_bitmap);
 
+	/*
+	 * The dirty bitmap can be empty even though the folio is dirty: data
+	 * mappings use filemap_dirty_folio(), so a generic folio_mark_dirty()
+	 * call (e.g. set_page_dirty_lock() after GUP) only sets the folio
+	 * flag, without any subpage dirty bit nor a delalloc reservation.
+	 *
+	 * There is nothing to submit for such a folio.  Bail out now,
+	 * otherwise the bitmap_empty() check at the end would mistake it for
+	 * "all ranges submitted asynchronously" and return with the folio
+	 * lock never released, deadlocking every subsequent locker.
+	 *
+	 * Also clear the stale dirty flag: with no subpage dirty bits nothing
+	 * will ever be written back for it, and leaving the flag would make
+	 * writeback rescan the folio forever.  All dirty flag setters hold
+	 * the folio lock, which we own, so this cannot race with a new
+	 * dirtier.  As folio_clear_dirty_for_io() keeps PAGECACHE_TAG_DIRTY,
+	 * use the same set/clear writeback dance as extent_writepage_io() to
+	 * also drop the stale tag, otherwise the inode would never go clean.
+	 */
+	if (unlikely(bitmap_empty(bio_ctrl->submit_bitmap, blocks_per_folio))) {
+		folio_clear_dirty_for_io(folio);
+		btrfs_folio_set_writeback(fs_info, folio, page_start, folio_size(folio));
+		btrfs_folio_clear_writeback(fs_info, folio, page_start, folio_size(folio));
+		folio_unlock(folio);
+		return 1;
+	}
+
 	for_each_set_bitrange(start_bit, end_bit, bio_ctrl->submit_bitmap,
 			      blocks_per_folio) {
 		u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
-- 
2.51.0
