Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6933F9F2F;
	Fri, 31 Jul 2026 10:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785495471; cv=none; b=fI07+B6FgoVdcxBUwEPkvKVghXUbjrfta88lXApybgjyCOvCOGYqQQ091XQd8nrjfEwemD9PCUBDN2YYk5Bz62P3idb5kOYR8k2YM/98pOspIwzD0bbKR1ct2KVt71Sd8LCEEZGhP1F6rn6RqBpX2AhHrjwvBr2e5pdwN1GhZXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785495471; c=relaxed/simple;
	bh=OZ3eJgWHYwOzgpDhF/C7xDxI08wsWFoq/40bE8+DXlM=;
	h=Content-Type:Message-ID:Date:MIME-Version:From:Subject:To:Cc; b=CsMl8+heqNET4yElyd6Odl4joxCsja1tEvd67H3aHe/1LiTlgYx2UDwRh8t2WTknA91YXgLWTH/TUDEfArr/xp29+uSsMHUnU/VOPYpVn0x4/nfBaK61PlW5eg0RihqCgqPUpOjfYnMfWAjLPCQUPVvEWQAFAeyZUU9VmGocI/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mGO9ezlR; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mGO9ezlR"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V8HolU1230524;
	Fri, 31 Jul 2026 10:57:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:message-id:mime-version:subject:to; s=
	pp1; bh=hTSAO5usqLyDAUp3IriR+h+FTkGCiv5KIVg8fueo9Lk=; b=mGO9ezlR
	7T4KReRfiDcheiKq31NU47jvijs+QD3B7LnfLeDTXLgiK4J8TTeydBdI9H4LSZLk
	hGAxDg6DtT6JYxs3CYjrV14LR9nCV1+1ZMQO4+rNqYRjidh3hXJBuFGpRihH2Irr
	UaxQSPRYrixZPe4pOEnThOZkzFXhEl1IDYCmIWTu9xYGD1wzRyBYERHkZzvWHCxi
	njWVRhz2pIvof6IaeGZF6mB1mZ607KDlOTaFKPUIHH3sTR7gDEFjP+HLwN6W6VD2
	aUlnNuukR5PY9cF3i/ZXFYWLCyQx/TCdQFDtBKofOkZ1Ez931LALGr6Guk1XP4Kf
	SVWIecIKNqGjlA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0p3k4e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 10:57:41 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66VAuMnC013305;
	Fri, 31 Jul 2026 10:57:40 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn7uwfpy8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 10:57:40 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66VAvctq33030616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 10:57:38 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4120B20043;
	Fri, 31 Jul 2026 10:57:38 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12D2D20040;
	Fri, 31 Jul 2026 10:57:38 +0000 (GMT)
Received: from [9.224.77.173] (unknown [9.224.77.173])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jul 2026 10:57:38 +0000 (GMT)
Content-Type: multipart/mixed; boundary="------------3UKbpMePDERMLhfk6SlHEQGp"
Message-ID: <782c4d5c-d93b-42b3-b4ca-58deb3d8a894@linux.ibm.com>
Date: Fri, 31 Jul 2026 12:57:37 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Lockdep circular dependency: btrfs_swap_activate() calls
 sysfs_notify()
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA4MSBTYWx0ZWRfX/3Va+omlJnhC
 wLzllWRV9c4aqlaVH4+FNzJpPH7TMslzkfuHLxxsRWWLwIIGc4Q3JTxZsSCtLLyDdbVfZJGlnAX
 ZJ7UEcUDFREtLVGr7trqJsqRBzz36g8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA4MSBTYWx0ZWRfX5pla2oagFarS
 7FStVDGJp+LTVxg3NfvHlGAdE6fgLrzUrxaRketRYGEtJrUWo3P5pwMbg3E5QQB4gCMrXSIVdkU
 iDrl50+ffYaPj0fgrwchqjkmfDzRGqQnxWPhQDvqoJzL2qEZ8wjlbYSGvc6X5aVC8LxNmoJRnvi
 Ujr/FusbxIrQLYuvyxZOZE97/dM8nPisYR2xvTneQAR7K22/CfUHeYFLiyxWiinwUwDK897Jce0
 slwrjqjH2UZfhEXYStAp/hOdKFF7pOFo/C6r0aQ9e5EqJrFDqWlDFaaZKIbW1ShryF7BbtukFDv
 0slGHIoRh6fqahp/H9uz3s5HPcJv6Z61nMnQYiZkSwyOGlJatcr0rOsZ5oaI0sPfZHFhjgZ2A5L
 6UNPyvxiY7tnefef0/PY5wrvVluLdplf8XZuLqvLZiw8nZIFdjzjK2lrmjTQ78QAU1hhi7bo4Nn
 4kJAvgcSbmNoutqGkhA==
X-Authority-Analysis: v=2.4 cv=b5WCJNGx c=1 sm=1 tr=0 ts=6a6c7fa5 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=r77TgQKjGQsHNAKrUKIA:9 a=KIJsKDi8WnJBS--jecsA:9
 a=QEXdDO2ut3YA:10 a=C8Se8zBF2xe4tgw-GKoA:9 a=E-yladNfQNEA:10
X-Proofpoint-GUID: xmDK4Gda0yeSvsqh62V46KIxA7A-hsif
X-Proofpoint-ORIG-GUID: xmDK4Gda0yeSvsqh62V46KIxA7A-hsif
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310081

This is a multi-part message in MIME format.
--------------3UKbpMePDERMLhfk6SlHEQGp
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit

One or more of the following files ( btrfs-swapon-kernfs-repro.sh ) violates IBM policy and all attachment(s) have been removed from the message.

**********************************************************************
We had the calltrace at the bottom of this mail in our CI logs
I also attached an AI generated reproducer that triggers this easily.

For convenience, here is what AI came up with analysing the log, but
I would like your take on it. Let me know if you want to see the
AI proposed fix.

----

btrfs_swap_activate() takes the inode's i_mmap_lock for write very
early (inode.c:10120) and holds it across the entire function; the
comment there explains the intent, which is to keep mmap writes from
racing with the delalloc flush and the extent range lock.

There are three btrfs_exclop_finish() calls inside that window:

   fs/btrfs/inode.c:10181   error path, swapfile on a rw subvolume
                            with an active snapshot
   fs/btrfs/inode.c:10202   error path, could not lock the snapshot drew
                            lock
   fs/btrfs/inode.c:10399   the common "out:" path -- taken on both
                            success and failure

and btrfs_exclop_finish() (fs/btrfs/fs.c:224) ends with an unconditional
sysfs_notify().  So the offending edge is taken on *every* successful
swapon of a btrfs swap file, not only on an error path.

The sysfs_notify() itself does nothing but a kernfs lookup plus a poll
wakeup for userspace watching the "exclusive_operation" attribute.  It
has no dependency whatsoever on i_mmap_lock, or on the inode at all.


Both kernfs_rwsem acquisitions in the cycle are read acquisitions
({++++}), so the two of them alone cannot deadlock.  A real hang needs a
third task waiting to take kernfs_rwsem for write, because rwsem
write-fairness makes a later down_read() block behind a queued writer:

   T_swapon:  holds i_mmap_lock(write)
              blocks in down_read(kernfs_rwsem)   [queued behind T_w]
   T_w:       blocks in down_write(kernfs_rwsem)  [waiting for T_dir]
              e.g. any sysfs node create/remove -- device hotplug,
              module load, cgroup or block-device attribute changes
   T_dir:     holds kernfs_rwsem(read) in kernfs_fop_readdir
              faults on the user dirent buffer -> mmap_lock
              -> btrfs_page_mkwrite -> down_read(i_mmap_lock)
              blocks behind T_swapon's write holder

   -> three-way deadlock.

That is a narrow race, which is consistent with this having gone
unnoticed for years, but every step of it is ordinary system activity.
The dependency is genuine and worth fixing rather than annotating away.

Suggested fix is to get the sysfs_notify() out from under i_mmap_lock


real life log found in our CI:
----------------------------
LOCKDEP_CIRCULAR (suite: tela-distro, case: tests/test_mempig/test_mempig)
WARNING: possible circular locking dependency detected
7.2.0-20260730.rc5.git10.af7a8a7752eb.300.fc44.s390x+debug #1 Not tainted
------------------------------------------------------
swapon/172010 is trying to acquire lock:
000002ea80a485a0 (&root->kernfs_rwsem){++++}-{3:3}, at: kernfs_find_and_get_ns+0x3c/0x80
but task is already holding lock:
000002ebc465d270 (&ei->i_mmap_lock){++++}-{3:3}, at: btrfs_swap_activate+0x9a/0x1240
which lock already depends on the new lock.
the existing dependency chain (in reverse order) is:
-> #3 (&ei->i_mmap_lock){++++}-{3:3}:
        lock_acquire+0x150/0x3f0
        down_read+0x5a/0x280
        btrfs_page_mkwrite+0x258/0x870
        do_page_mkwrite+0x60/0x160
        do_wp_page+0x128/0x750
        __handle_mm_fault+0x1be/0x590
        handle_mm_fault+0xa2/0x370
        do_exception+0x292/0x590
        __do_pgm_check+0x168/0x430
        pgm_check_handler+0x114/0x160
-> #2 (sb_pagefaults){.+.+}-{0:0}:
        lock_acquire+0x150/0x3f0
        percpu_down_read_internal.constprop.0+0x54/0x120
        btrfs_page_mkwrite+0xa6/0x870
        do_page_mkwrite+0x60/0x160
        do_fault+0x132/0x4a0
        __handle_mm_fault+0x1be/0x590
        handle_mm_fault+0xa2/0x370
        do_exception+0x1a0/0x590
        __do_pgm_check+0x168/0x430
        pgm_check_handler+0x114/0x160
-> #1 (&mm->mmap_lock){++++}-{3:3}:
        lock_acquire+0x150/0x3f0
        __might_fault+0x7a/0xa0
        filldir64+0x11c/0x210
        kernfs_fop_readdir+0x150/0x4c0
        iterate_dir+0xcc/0x2d0
        __do_sys_getdents64+0x7a/0x130
        __do_syscall+0x172/0x750
        system_call+0x72/0x90
-> #0 (&root->kernfs_rwsem){++++}-{3:3}:
        check_prev_add+0x160/0xf40
        __lock_acquire+0x12aa/0x15a0
        lock_acquire+0x150/0x3f0
        down_read+0x5a/0x280
        kernfs_find_and_get_ns+0x3c/0x80
        sysfs_notify+0x60/0xc0
        btrfs_swap_activate+0x83c/0x1240
        __do_sys_swapon+0x278/0x9c0
        __do_syscall+0x172/0x750
        system_call+0x72/0x90
other info that might help us debug this:
Chain exists of:
   &root->kernfs_rwsem --> sb_pagefaults --> &ei->i_mmap_lock
  Possible unsafe locking scenario:
        CPU0                    CPU1
        ----                    ----
   lock(&ei->i_mmap_lock);
                                lock(sb_pagefaults);
                                lock(&ei->i_mmap_lock);
   rlock(&root->kernfs_rwsem);
  *** DEADLOCK ***
2 locks held by swapon/172010:
  #0: 000002ebc465d3f0 (&sb->s_type->i_mutex_key#20){++++}-{3:3}, at: __do_sys_swapon+0x5be/0x9c0
  #1: 000002ebc465d270 (&ei->i_mmap_lock){++++}-{3:3}, at: btrfs_swap_activate+0x9a/0x1240
stack backtrace:
CPU: 6 UID: 0 PID: 172010 Comm: swapon Not tainted 7.2.0-20260730.rc5.git10.af7a8a7752eb.300.fc44.s390x+debug #1 PREEMPT
Hardware name: IBM 8561 T01 701 (z/VM 7.4.0)
Call Trace:
  [<000003f7d5ab4e3e>] dump_stack_lvl+0xae/0x108
  [<000003f7d5bbef24>] print_circular_bug+0x1a4/0x230
  [<000003f7d5bbf13c>] check_noncircular+0x18c/0x1b0
  [<000003f7d5bc0510>] check_prev_add+0x160/0xf40
  [<000003f7d5bc408a>] __lock_acquire+0x12aa/0x15a0
  [<000003f7d5bc44d0>] lock_acquire+0x150/0x3f0
  [<000003f7d6c447ca>] down_read+0x5a/0x280
  [<000003f7d60ad61c>] kernfs_find_and_get_ns+0x3c/0x80
  [<000003f7d60b3b70>] sysfs_notify+0x60/0xc0
  [<000003f7d635653c>] btrfs_swap_activate+0x83c/0x1240
  [<000003f7d5f1d268>] __do_sys_swapon+0x278/0x9c0
  [<000003f7d6c369a2>] __do_syscall+0x172/0x750
  [<000003f7d6c4baa2>] system_call+0x72/0x90
INFO: lockdep is turned off.

--------------3UKbpMePDERMLhfk6SlHEQGp--

