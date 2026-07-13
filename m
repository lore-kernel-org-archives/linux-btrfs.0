Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F15E3AB466
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 12:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783944428; cv=none; b=q4b+D5PEpJ8GpWEtOHl28fz6xE3VIiB9tUuY3FFir4z998iBKGxeh1QMLt8eHE91d551fwH5IqCGf+GO0MiuPXwataLBCK9DBXGnc0reAfla5LQCHxoFHpytlqqM6vvldI9mKOsEwhzJ64z6XPhyGHDZ9ESJdKbqq1nLbKDOFqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783944428; c=relaxed/simple;
	bh=g7EsUKvE8zqZLMWE/BCh0mDt1rDKCFtDfFYmKcH0Kxc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=e+nTraOb/0iqSQoDHOuV6wcy11vzbikab/6Sy3vpAvTVjFpy8mYuUXZj6Oep9JdD9gnMHgq5k4G9euiwAbDPjYZHjTikj8nyLxQfQgzKN2OffefhIubAY2hKFpgEpvbQmUW4RjV34FwB7gak686R0ieeikXp1rQDYe8nVfPxcSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=O5buODqa; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="O5buODqa"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66D6gPf01669232;
	Mon, 13 Jul 2026 12:07:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=pDlm1i0GNbuXU1ryX8rDg+MC+37c
	Gilu+fmQJ5Wjd4A=; b=O5buODqaRCnTgMNR6K9QZ+Jd6g7QbnMgNGvhDzMKv9qD
	RlO7h4IjN1PI6sDYFjvt3hVKJ4UiqQULuo3uNUaOVamMdWBikh5ZU78c9UOTjhrz
	HTWk1MtUnQyPRvIclVJCidRnXnAWIpQekyAvxEWg/tKwn7xE1aDRqGCV3k8kUP1c
	VsprDezO29T8DaS4X5av2C4znuy5ILsrv8xAkTx+exjME+lHxfIjg8N+a/7BGOvJ
	kG1gVLPvUb8TnJ5EaLCUERgrCzTLZqYbTmFjs18NqoG6qiy7Sq28lJHgn0A1dBTK
	dPB7SbLdpjcV4sWdwrsIgsDP5cMV/wmgqaJmo/rszQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fbexwg3f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 12:07:05 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66DC4apd026328;
	Mon, 13 Jul 2026 12:07:04 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fc2uxw7va-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 12:07:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66DC72RL46268876
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 12:07:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9002F20043;
	Mon, 13 Jul 2026 12:07:02 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7715E20040;
	Mon, 13 Jul 2026 12:07:02 +0000 (GMT)
Received: from [9.224.77.173] (unknown [9.224.77.173])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 13 Jul 2026 12:07:02 +0000 (GMT)
Message-ID: <5a9d9847-4ae6-43c4-afdc-6e5fa51d6117@linux.ibm.com>
Date: Mon, 13 Jul 2026 14:07:01 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
From: Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: btrfs lockdep issue
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IkxcpffFznYW6Hh2IGTKQKX6Xv0K3nKV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDEyMiBTYWx0ZWRfX365fnO56AuaM
 UfXIWvbxiDjPc/SxDca2egb5mAyWcpxV2v3gdwrvGdC+DGqAIHGmUvGyDHCC0rvXE4NxbkjpsY3
 joNCSlW/cyt/4XmfWGgDm5XXNPjGZpOmCDp+qZaF1pQ42q6GQa5M+MyzXqT5DCZoCkayHofcOvn
 OZoJwxW4aAACCkRmDUPU4bly3wtPktSsnQX4C8D9pb8uQQs60pmSIXw2QGQu2/0De9UsZXhkynv
 bqnGL7syKa5I5AUiQy/4118YSZmaAMCAvpTPP14FpgEwAvnDcP2P6L2ZNYVJ/+X7vSoNYqhfdX5
 9Gq8Rqxt/opIZ1bVgDvkRM8zs1ag3StvVI+i6VyOz+g/vFuIfx8wWL6hC5xYHFbE4PgEpo4N6Wo
 2UcAvIL13y7mxh1dPAX4WFU4u2GuuN4+Y+G1Ijz2E2CTeuyR7l9d6sr83+zG5SBxZkTGHxTDUwo
 9ucAhek/vvyx4+GUSDQ==
X-Authority-Analysis: v=2.4 cv=XJoAjwhE c=1 sm=1 tr=0 ts=6a54d4e9 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=-FzPey7Xm3bcQ9SF5egA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: IkxcpffFznYW6Hh2IGTKQKX6Xv0K3nKV
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDEyMiBTYWx0ZWRfX/W1ECtcgB0/3
 NonyEVebztALsqmNUTixafDSOVEX81b40o+Q6SoAe0XTPW32gnxlE3kL/76xaEH+xC9ad/zNQCe
 timYTWX29CFHc89DTSHotbnr/6y2SiE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_02,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 clxscore=1011 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130122

Chris,

in our CI we do get lockdep errors for btrfs:

======================================================
WARNING: possible circular locking dependency detected
7.2.0-20260712.rc2.git0.e3321fa3034d.300.fc44.s390x+debug #1 Not tainted
------------------------------------------------------
(udev-worker)/1653 is trying to acquire lock:
0000006919232220 (&type->i_mutex_dir_key#2){++++}-{3:3}, at: lookup_slow+0x3e/0x70
but task is already holding lock:
00000069238564d8 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: device_list_add.constprop.0+0x148/0xc60
which lock already depends on the new lock.
the existing dependency chain (in reverse order) is:
-> #5 (&fs_devs->device_list_mutex){+.+.}-{3:3}:
        lock_acquire+0x150/0x3f0
        __mutex_lock+0xba/0xdc0
        mutex_lock_nested+0x32/0x40
        write_all_supers+0x7a/0x670
        btrfs_sync_log+0xae6/0xdd0
        btrfs_sync_file+0x4fa/0x7a0
        __s390x_sys_fsync+0x52/0xa0
        __do_syscall+0x172/0x750
        system_call+0x72/0x90
-> #4 (&fs_info->tree_log_mutex){+.+.}-{3:3}:
        lock_acquire+0x150/0x3f0
        __mutex_lock+0xba/0xdc0
        mutex_lock_nested+0x32/0x40
        btrfs_sync_log+0xaba/0xdd0
        btrfs_sync_file+0x4fa/0x7a0
        __s390x_sys_fsync+0x52/0xa0
        __do_syscall+0x172/0x750
        system_call+0x72/0x90
-> #3 (btrfs_trans_num_extwriters){.+.+}-{0:0}:
        lock_acquire+0x150/0x3f0
        join_transaction+0x108/0x680
        start_transaction+0x21a/0x660
        btrfs_join_transaction+0x32/0x40
        btrfs_dirty_inode+0x52/0xf0
        touch_atime+0x90/0xc0
        filemap_read+0x446/0x450
        vfs_read+0x208/0x370
        ksys_read+0x88/0x120
        __do_syscall+0x172/0x750
        system_call+0x72/0x90
-> #2 (btrfs_trans_num_writers){.+.+}-{0:0}:
        reacquire_held_locks+0x14c/0x240
        __lock_release.isra.0+0xd8/0x380
        lock_release+0xf6/0x270
        percpu_up_read+0x28/0xf0
        __btrfs_end_transaction+0x178/0x1f0
        btrfs_dirty_inode+0x82/0xf0
        touch_atime+0x90/0xc0
        btrfs_file_mmap_prepare+0x8c/0xa0
        __mmap_region+0x214/0x780
        mmap_region+0x108/0x160
        do_mmap+0x402/0x5a0
        vm_mmap_pgoff+0x156/0x230
        ksys_mmap_pgoff+0x17e/0x220
        __s390x_sys_old_mmap+0xa8/0x140
        __do_syscall+0x172/0x750
        system_call+0x72/0x90
-> #1 (&mm->mmap_lock){++++}-{3:3}:
        lock_acquire+0x150/0x3f0
        __might_fault+0x7a/0xa0
        filldir64+0x11c/0x210
        offset_readdir+0x92/0x200
        iterate_dir+0xcc/0x2d0
        __do_sys_getdents64+0x7a/0x130
        __do_syscall+0x172/0x750
        system_call+0x72/0x90
-> #0 (&type->i_mutex_dir_key#2){++++}-{3:3}:
        check_prev_add+0x160/0xf40
        __lock_acquire+0x12aa/0x15a0
        lock_acquire+0x150/0x3f0
        down_read+0x5a/0x280
        lookup_slow+0x3e/0x70
        path_lookupat+0x1f0/0x370
        filename_lookup+0xce/0x1f0
        kern_path+0x48/0x70
        is_same_device+0x146/0x300
        device_list_add.constprop.0+0x1be/0xc60
        btrfs_scan_one_device+0x13a/0x2f0
        btrfs_control_ioctl+0x110/0x1e0
        __s390x_sys_ioctl+0xfa/0x130
        __do_syscall+0x172/0x750
        system_call+0x72/0x90
other info that might help us debug this:
Chain exists of:
   &type->i_mutex_dir_key#2 --> &fs_info->tree_log_mutex --> &fs_devs->device_list_mutex
  Possible unsafe locking scenario:
        CPU0                    CPU1
        ----                    ----
   lock(&fs_devs->device_list_mutex);
                                lock(&fs_info->tree_log_mutex);
                                lock(&fs_devs->device_list_mutex);
   rlock(&type->i_mutex_dir_key#2);
  *** DEADLOCK ***
2 locks held by (udev-worker)/1653:
  #0: 0000016c727051c8 (uuid_mutex){+.+.}-{3:3}, at: btrfs_control_ioctl+0x102/0x1e0
  #1: 00000069238564d8 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: device_list_add.constprop.0+0x148/0xc60
stack backtrace:
CPU: 2 UID: 0 PID: 1653 Comm: (udev-worker) Not tainted 7.2.0-20260712.rc2.git0.e3321fa3034d.300.fc44.s390x+debug #1 PREEMPT
Hardware name: IBM 3931 A01 701 (LPAR)
Call Trace:
  [<0000016c70680e3e>] dump_stack_lvl+0xae/0x108
  [<0000016c7078aa44>] print_circular_bug+0x1a4/0x230
  [<0000016c7078ac5c>] check_noncircular+0x18c/0x1b0
  [<0000016c7078c030>] check_prev_add+0x160/0xf40
  [<0000016c7078fbaa>] __lock_acquire+0x12aa/0x15a0
  [<0000016c7078fff0>] lock_acquire+0x150/0x3f0
  [<0000016c7180e2fa>] down_read+0x5a/0x280
  [<0000016c70b88dde>] lookup_slow+0x3e/0x70
  [<0000016c70b8f5d0>] path_lookupat+0x1f0/0x370
  [<0000016c70b900ae>] filename_lookup+0xce/0x1f0
  [<0000016c70b90218>] kern_path+0x48/0x70
  [<0000016c70f5b4a6>] is_same_device+0x146/0x300
  [<0000016c70f67cfe>] device_list_add.constprop.0+0x1be/0xc60
  [<0000016c70f688da>] btrfs_scan_one_device+0x13a/0x2f0
  [<0000016c70ed9cb0>] btrfs_control_ioctl+0x110/0x1e0
  [<0000016c70b97d0a>] __s390x_sys_ioctl+0xfa/0x130
  [<0000016c718004d2>] __do_syscall+0x172/0x750
  [<0000016c718155d2>] system_call+0x72/0x90



As I dont know the btrfs code, I fed this into the bob AI and it came
out with this.

---snip---
The issue occurs in device_list_add() when is_same_device() is called
while holding device_list_mutex. The is_same_device() function performs
kern_path() lookups which acquire directory inode locks (i_mutex_dir_key),
creating a potential deadlock scenario.

The lockdep chain:
   CPU0: holds device_list_mutex, tries to acquire i_mutex_dir_key
   CPU1: holds tree_log_mutex, tries to acquire device_list_mutex
   (tree_log_mutex -> i_mutex_dir_key dependency exists via fsync path)
---snip---

and proposes
---snip---
Replace the is_same_device() call with a direct comparison of dev_t
values (device->devt vs path_devt). This is sufficient to determine if
the device path refers to the same block device, and avoids the
problematic filesystem path lookup while holding the mutex.

The path_devt is already obtained earlier via lookup_bdev(), and
device->devt is set during device registration, making this comparison
both safe and more efficient than the original string-based path
comparison.


---
  fs/btrfs/volumes.c | 8 +++++++-
  1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1234567890ab..abcdef123456 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -895,7 +895,13 @@ static noinline struct btrfs_device *device_list_add(const char *path,
  				MAJOR(path_devt), MINOR(path_devt),
  				current->comm, task_pid_nr(current));
  
-	} else if (!device->name || !is_same_device(device, path)) {
+	/*
+	 * Check if device path changed by comparing devt instead of calling
+	 * is_same_device() which does kern_path() lookups while holding
+	 * device_list_mutex, causing potential circular locking dependency
+	 * with i_mutex_dir_key.
+	 */
+	} else if (!device->name || device->devt != path_devt) {
  		const char *old_name;
  
  		/*
---snip---


So if you want to fix this yourself, go for it, if you think the fix proposal is fine
and want a proper patch, let me know and I will respin this properly myself (and I will
also add that to our CI first).

Christian
