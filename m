Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AAA415F25;
	Tue, 21 Jul 2026 19:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661124; cv=none; b=uRvqjrxlAqHntQCwy1jsdashQOLfVqktQBY3WFYwj1wLqSm1eqb8p3GPMakkgfmpz+DsZkoykB9wKAMyHIBP038AfHT1+DMJwOewm0axXoX3E7dg/sbGP0EsKBWljeDo6mv+/xa66reEc8EQZ6qbUOMAEBFcxOY/js2AG/Vr3dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661124; c=relaxed/simple;
	bh=6fBQSd3rhXMTgm2/xnktQ08BvOUZrV0kaMTJ+7aTDpk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WlPy30E0WZQFLx9L+QuMET4BTSe1aDZkfX8XGwqV7y055P8CZlpYcdO2KvUn24jMrFacnUFMagtqdGNMBTeRSlG0pUkGc65YueOgc1its3EWsYQTVREdaoIXTVig0H/I2WXH9Od8exfxcK9XKEfDxC+m15bDIV5NgKVUinx9He0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gbUpgQKZ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gbUpgQKZ"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LHCB0K1568426;
	Tue, 21 Jul 2026 19:11:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=DB46XAlEYXQKQeeGBiWmIDBkDvp6
	DjOu8A7n43W30WI=; b=gbUpgQKZYhwsba8FDlpLgxnkpctFBzq2NAwfAz861I76
	75mQ2lfbh1I6Zt6rxkeUB4hmYkYSJhyTKUQdeoYpa0oQvbmOXxQDS3CC8w76xQt5
	cevsF2R0GNLPeMKHobwP8Tp8/5XUWHL9xemF6L5GPTPy/uUPNRkOatRFbSPZACFM
	pFOfDb7CEp2XEUSz8fSOlA1xKGRuq3ApnDIMRtY0aagrVphBiqyyzuAZDJjwWukW
	Hfch83YOmaNjKUWabXeZ2T9UOLLr+Jg5kIemJXt6TUIRxZCy7vpdbwXcJhTCU2dm
	HcEi5m8xNz/ZExeGVOVLqo4wvVXBZm8qQ6/i9t023A==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg77k610g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 19:11:57 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66LJ4ZTL031448;
	Tue, 21 Jul 2026 19:11:56 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgp1gbn72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 19:11:56 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66LJBul130737134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jul 2026 19:11:56 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 09ADA58057;
	Tue, 21 Jul 2026 19:11:56 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D998C58058;
	Tue, 21 Jul 2026 19:11:53 +0000 (GMT)
Received: from li-d98989cc-2c66-11b2-a85c-93ab83b7dd53.ibm.com.com (unknown [9.111.46.140])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Jul 2026 19:11:53 +0000 (GMT)
From: Christian Borntraeger <borntraeger@linux.ibm.com>
To: linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Cc: borntraeger@linux.ibm.com, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: 7.2-rc1 regression Folio lock leak in writepage_delalloc()
Date: Tue, 21 Jul 2026 21:11:50 +0200
Message-ID: <20260721191152.101118-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=HJXz0Itv c=1 sm=1 tr=0 ts=6a5fc47d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=y3d_oAMl_fJeGFfO30oA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDIwMSBTYWx0ZWRfX0fBDewFNWRcL
 Lchr+aiMbMIPxNG77EYfc9F+haGkIo31FmDifI71/x+r3ENZ3yQuKKB/TZc1Qp05IngSQhMOtN4
 YKYaOSdndD1w/uoDRc4S5+3+Udn3wUXSuNvivAfPkO+LDpABxnekYpdURVMDF8J8jM0xwJfoiJJ
 bwrrnjT72ZkZ0Ih9PR0Q+AcbD1gYN29XamyS3I/62vARmxFAsTZoj3phczPWZJe5KIpMHuXUK0/
 FETX+3cciw3X1f4cXVGCkLH7FTdyf5v4gEy/lRUB+QqkmtsItAR+ZvIZvL9bx8ahDqzhV2G3fiC
 65zKAlzVGpQwGl6cqObLfpOKuIPs6knjcrNITG0P7yGq22/YFqTSOhudNLh4T5frv3juPhUfRJs
 P7peeN+T+hEhHr4iqK6DCakl9s3GVTp5bidVa2TaYUt36zL0UtExh4iiCQ20R30iJhwnAocGuhr
 UHU5ht/SemqIb8E7AYA==
X-Proofpoint-ORIG-GUID: 2VY4ZzgsEYi8w4iRIGTpv-fDXxyGK-uw
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDIwMSBTYWx0ZWRfXxZPepmNXXBqR
 /5gsjxvFiMQgtIge6UQkoJ2+F+Biy5/UXnnQono696Y4HjaXl3Qr+xaX0rj2wUCQPsu0N/RfAyf
 a/a95Lr3x4GFg7IQChPBsBfYp6u5cQ8=
X-Proofpoint-GUID: 2VY4ZzgsEYi8w4iRIGTpv-fDXxyGK-uw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607210201

We have seen random hangs in our daily CI run where qemu/KVM
processes  deadlocks guests with file-backed RAM on btrfs (large data folios)

With the help of claude I think we found the/one problem on an s390
KVM host running 7.2.0-rc3 (KASAN test kernel, but the issue is not
KASAN related). And to be honest here, most of the writeup was created
by claude and I added things where appropriate. Also the patch was
mostly done with the help of claude.

A KVM guest with its RAM backed by a file on btrfs (zstd compression
enabled) locked up together with the host's writeback: two vCPU
threads, an irqfd worker, two flusher workers, khugepaged and a
syncfs caller (dnf) were all stuck in D state for hours.  Analysis
of the crash dump shows a leaked folio lock in btrfs'
writepage_delalloc(); a proposed fix is in the reply mail.

I still need to verify that this patches fixes the deadlock in our
CI but wanted some feedback first.

Dump analysis (shortened)
-------------------------
All blocked tasks funnel into one 64-page (256K) large data folio of
the guest RAM file:

  folio 0x800083fb000, inode 1881035 (the 1.25G s390.ram file)
  flags: PG_locked | PG_waiters | PG_dirty | PG_private | PG_uptodate
         (PG_writeback NOT set)
  btrfs_folio_state: nr_locked == 0, subpage dirty bitmap empty
  still mapped (63/64 PTEs) and on the LRU, no outstanding block I/O

Waiters on that folio lock:
  - 2 vCPU threads + 1 irqfd kworker, all in
    btrfs_page_mkwrite() -> folio_lock, holding mmap_lock (read)
crash> bt 66448
PID: 66448    TASK: 9e934a00          CPU: 9    COMMAND: "CPU 1/KVM"
 #0 [b8b25dbe7d8] __schedule at c0b186d5e78
 #1 [b8b25dbe908] schedule at c0b186d7040
 #2 [b8b25dbe948] io_schedule at c0b186d723c
 #3 [b8b25dbe978] folio_wait_bit_common at c0b167e719c
 #4 [b8b25dbeaf0] btrfs_page_mkwrite at c0b172816fc
 #5 [b8b25dbec98] do_page_mkwrite at c0b168a4ada
 #6 [b8b25dbecf0] do_wp_page at c0b168b2350
 #7 [b8b25dbed70] handle_pte_fault at c0b168bfaf4
 #8 [b8b25dbee58] __handle_mm_fault at c0b168c003e
 #9 [b8b25dbefc0] handle_mm_fault at c0b168c09b6
#10 [b8b25dbf020] __get_user_pages at c0b16899cfc
#11 [b8b25dbf148] get_user_pages_unlocked at c0b1689af1c
#12 [b8b25dbf248] hva_to_pfn at c0a9711e20e [kvm]
#13 [b8b25dbf3f0] __kvm_faultin_pfn at c0a9711ea26 [kvm]
#14 [b8b25dbf4e8] kvm_s390_faultin_gfn at c0a971c092c [kvm]
#15 [b8b25dbf5f8] vcpu_post_run_handle_fault at c0a97148b5e [kvm]
#16 [b8b25dbf6f0] __vcpu_run at c0a9715c1f2 [kvm]
#17 [b8b25dbf808] kvm_arch_vcpu_ioctl_run at c0a9715d3e4 [kvm]
#18 [b8b25dbfbb8] kvm_vcpu_ioctl at c0a97117bd8 [kvm]
#19 [b8b25dbfdd8] __s390x_sys_ioctl at c0b16aa3614
#20 [b8b25dbfe40] __do_syscall at c0b186cdaee
#21 [b8b25dbfe98] system_call at c0b186ebd42
 USER-MODE INTERRUPT FRAME; pt_regs at b8b25dbff38:
 PSW:  0705000180000000 000003ff8a92662c (user space)
 GPRS: 000003ff627faf50 0000000000000036 ffffffffffffffda 000000000000ae80 
       0000000000000000 000003ff627fc8c0 000002aa1f8a7880 000003ff8a8ad310 
       000002aa1e1f3c60 0000000000000000 000000000000ae80 000002aa1f8a2f60 
       000003ff8d3adfa8 000003ff627fc8c0 000003ff627faff0 000003ff627fae88 


  - flusher: extent_write_cache_pages() -> folio_lock
  - delalloc space reclaim worker: same, while holding
    fs_info->delalloc_root_mutex (which in turn blocks
    btrfs_async_reclaim_metadata_space on the mutex)
Behind those: khugepaged in down_write(mmap_lock), and syncfs.

No task in the system owns the folio lock; nothing references the
folio except the six waiters.  The lock was leaked.

Root cause
----------
A folio can carry the folio-level dirty flag with an EMPTY btrfs
subpage dirty bitmap.  btrfs data mappings use filemap_dirty_folio(),
so a generic folio_mark_dirty() sets only the folio flag and xarray
tag - no subpage dirty bits, no delalloc reservation.  On s390 this
happens all the time: the KVM irq adapter path
(arch/s390/kvm/interrupt.c, adapter_indicators_set()) pins the guest
interrupt indicator page with pin_user_pages_remote(FOLL_WRITE),
sets the indicator bit and calls set_page_dirty_lock().  Once a
previously written folio has gone through one complete writeback
cycle (subpage dirty bitmap empty again), the next adapter interrupt
re-dirties it with only the folio flag.

Writeback then does:

  extent_write_cache_pages(): folio_lock(), folio is dirty -> proceed
  extent_writepage() -> writepage_delalloc():
    - btrfs_copy_subpage_dirty_bitmap() -> submit_bitmap is EMPTY
    - the btrfs_folio_set_lock() loop sets nothing (nr_locked stays 0)
    - find_lock_delalloc_range() finds nothing -> goto out
    - out: bitmap_empty(submit_bitmap) is true -> return 1

The "return 1" path means "all dirty ranges were submitted
asynchronously, the async submission owns the folio unlock" - but
nothing was submitted, so extent_writepage() returns and the folio
stays locked forever.  This matches every flag of the dump folio
(locked, dirty, nr_locked == 0, no writeback, still mapped/LRU).

Verifying this in the dump:

- uptodate = 0xffffffffffffffff — all 64 blocks uptodate (consistent with PG_uptodate)
- dirty = 0x0 — the subpage dirty bitmap is EMPTY, exactly as the root cause predicts
- writeback = 0x0 — no writeback in flight (consistent with PG_writeback clear)


Exposure
--------
- Single-block folios are immune: btrfs_copy_subpage_dirty_bitmap()
  unconditionally reports bit 0 for blocks_per_folio == 1.
- Subpage setups (e.g. 64K page size with 4K sectorsize) have been
  exposed since the submission bitmap rework in v6.12
  (bd610c0937aa "btrfs: only unlock the to-be-submitted ranges
  inside a folio").
- 4K page size systems became exposed with large data folio support
  in v7.2-rc1, which routes every large folio through the subpage
  machinery.  That is why we only started seeing this now.

Any GUP-style dirtier can trigger it (KVM adapter interrupts on
s390, vfio, RDMA, io_uring fixed buffers, ...) as long as the target
is a multi-block folio of a btrfs data mapping that was clean at the
time of set_page_dirty_lock().

Reproducer outline: KVM guest on s390 with memory-backend-file on
btrfs + virtio devices using irqfd adapter indicators; hangs within
~25 minutes of guest uptime in our setup.  A targeted reproducer
should also work on x86: mmap a file on btrfs, write it, fsync, let
writeback finish, then pin_user_pages(FOLL_WRITE) +
set_page_dirty_lock() on a page of a large folio and trigger sync.

Proposed fix
------------
Detect the empty-at-entry bitmap right after it has been copied,
before any range lock is set up, clear the stale folio dirty flag
(nothing can ever be written back for it; all dirty flag setters
serialize on the folio lock we hold) and unlock the folio.  Patch
attached below; it survives our compile test and we are preparing a
test run on the affected machine.  Comments welcome - especially on
whether clearing the folio dirty flag is the desired semantic here,
versus e.g. routing such folios through the cow fixup worker to
actually persist GUP-written data.

Thanks

Christian




