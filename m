Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D823A7F57;
	Wed, 22 Jul 2026 09:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784712604; cv=none; b=cFeUSx5WVG8sdZqlkJMegEV5DqKmOKcwbKYj/8pxmmztEp/gSuab9f2eNqCsUkhX4uWdrBZwPe6IG6Z6kQHLycnw3FjUweFdyPE55RbT/skn2SEdVqMBUDzFNhXznJqk7y3NTIOcYk32EI/UThldr6Lf6Mpwg2mN9z0OUtTIJVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784712604; c=relaxed/simple;
	bh=JkfAdIzyNsw8WMMq+mi464SPw1EFDAa8P72tVz4PdQI=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=m53eNnqtGWOuwtqo4y01+6ybIqxXH/MiKy0Qbmzuv+RWl0y4uUWvp2naIFe6YvdGLJ+flbWyD9Ypi06UyfJsO8pFpUQdxJlBMzQYdDwX8jiGLbs1/Ttqupw2eo1jrzYL3EYffolUVAzPmhQKFhahwNgQjPaMLoiZwBGwSLpvWIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DRAolk1k; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DRAolk1k"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M9Bcbn3662518;
	Wed, 22 Jul 2026 09:29:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=8A0Dd01/1z7STbmzKw4n87DtiETOan
	xjT7SJfVerPzU=; b=DRAolk1kk5AX1/21Es+AZR06iSQnejfd7AQ/2ndD6C95az
	rATdgQtRVr57Yme+WVRi7gC6LQ3m1UnNkcaAhf0UBDFb2zMb7rlZEJ4Gjul8x+9a
	MX/srizRC+IL2/mGeCbHb0fmUOxcRgXgtjiFrIq3YdebCj4Ye/f+P478dra0pPyu
	Gkds+y81NzHv15Rq57nTNgQyAghrv+ZlGB9fp2X7UhYhkxTk3Qg1PFrSzEpAI+Ea
	BSvICPn4WiqebS7nEZhMQvQ9XPzPyP/wn2Gmt9Gg9uoahpxO0Rq9zgZG7eA+nFm6
	JpagTMB4tdrGnm4SVIoBCDiqxxzdDrBJ/cN7/O5A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7abhc6u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 09:29:40 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66M9JeZl012933;
	Wed, 22 Jul 2026 09:29:39 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgm6w6qd7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 09:29:39 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66M9Tb5b48955758
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jul 2026 09:29:37 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3DE0A20043;
	Wed, 22 Jul 2026 09:29:37 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9325720040;
	Wed, 22 Jul 2026 09:29:36 +0000 (GMT)
Received: from [9.224.77.173] (unknown [9.224.77.173])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Jul 2026 09:29:36 +0000 (GMT)
Content-Type: multipart/mixed; boundary="------------uGF6w02qFA3LZDIF9td4sMgh"
Message-ID: <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
Date: Wed, 22 Jul 2026 11:29:36 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc()
 for folios dirtied behind btrfs' back
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
 <20260721191152.101118-2-borntraeger@linux.ibm.com>
 <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
 <83290932-cb8b-4741-bff0-6a7d8df2c637@linux.ibm.com>
 <224d56d2-fcad-41bf-afe3-6f5f5108172a@gmx.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <224d56d2-fcad-41bf-afe3-6f5f5108172a@gmx.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDA4NyBTYWx0ZWRfX8J4GrKze0+Ep
 mt78fnLCLbQRmugAgtmILiYB4zbbRo5VXBkXty3NVKXZM9uz3p3qqD5403NOauqrQPW/40la//J
 ZYUEKQgVbYjs44BiRPJxezE4qwtiC+yy/x5aPjI4X3u/xkVfT1kBAbEairkRjCboDjr2Gz95GXi
 rOuzLB4z3hPqy5XBoAsTtvQgUgujpnozbjARliSa3ACURcTufZ9Wz3aT+3VAmobD8XYpy69q2sH
 hG1y+xHHYFURdXgZ/NFIt0DvGuRb/9wbbjmZmegF+dkqEoj+dVmmQjv46Corrgo4V1Ho60dmOTK
 g87QyAilUKfq4S3NPWy/QWTA2WFvrb9DvXFcNKSvqRh/25xZ4wr95VIMeCR2XbFJ70JYV206exZ
 uEM/Q86peAg0lqml7u+cJoQ8rlBbnUEdZbvH9MgVp4rGXXAE+wCLzGjedBa0bwiVB03gdK4TbaK
 8x1jv8CzlNV8Qx99dyQ==
X-Authority-Analysis: v=2.4 cv=F7ZnsKhN c=1 sm=1 tr=0 ts=6a608d85 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=r77TgQKjGQsHNAKrUKIA:9 a=PrgrqC_M_MTsSvafbmIA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=yz1lJfyc6laaJMd4pNoA:9
 a=JMNH9X61SiQA:10
X-Proofpoint-ORIG-GUID: U3i6O-zkGp4m8fu6yclLwcPU6FDggnbG
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDA4NyBTYWx0ZWRfX1PMvxxiOnIml
 7RmJbdn8LdU2gEAKiMkbhHEE46UbKQuOjkFAhyMOlfOw81Ywl0LLne+8dJSCix0saKLoy/A/qbP
 8hMAh0oS3+sDKyHEpfak3RpB02k6OqI=
X-Proofpoint-GUID: 9CTY8Ih_ti3YJd1FxqUl6nPxNBFuIZyC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1011 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220087

This is a multi-part message in MIME format.
--------------uGF6w02qFA3LZDIF9td4sMgh
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.07.26 um 10:59 schrieb Qu Wenruo:
> 
> 
> 在 2026/7/22 18:05, Christian Borntraeger 写道:
>> Am 21.07.26 um 23:07 schrieb Qu Wenruo:
>>
>> First, thank you for taking the time to look into this and trying to understand
>> things and trying to explain things. this is highly appreciated.
>> I am still trying to fully understand this myself. A question:
>>
>>> 在 2026/7/22 04:41, Christian Borntraeger 写道:
>>>> A folio can carry the folio-level dirty flag while its btrfs subpage
>>>> dirty bitmap is empty: btrfs data mappings use filemap_dirty_folio(),
>>>> so a generic folio_mark_dirty() call sets only the folio flag and the
>>>> xarray tag, without setting any subpage dirty bit and without a
>>>> delalloc reservation.  The typical source is set_page_dirty_lock() on
>>>> a GUP pin,
>>>
>>> Shouldn't such folio got its ->page_mkwrite() callback get called first?
>>
>> Isnt that called implicitely at pin time?
> 
> I have to admit, I'm not an expert on the MM part, I'm mostly a simple user of the existing MM interfaces.
> 
> AFAIK, the last time I brought this thing up, Christoph mentioned that dirtying-folio-without-notifying-fs is a bug, and fs should not and is not able to handle such situation anyway.
> 
> And that idea makes a lot of sense to me.
> 
> So adding MM list for more help.
So I now have an userspace O_DIRECT reproducer outside of KVM. (attached) which gave me (on an s390 system, though)

[  189.067731] sysrq: Show Blocked State
[  189.067872] task:kworker/u1665:5 state:D stack:0     pid:1363  tgid:1363  ppid:2      task_flags:0x4208060 flags:0x00000000
[  189.067877] Workqueue: writeback wb_workfn (flush-btrfs-1)
[  189.067884] Call Trace:
[  189.067886]  [<000003a8b2e19284>] __schedule+0x374/0x900
[  189.067891]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
[  189.067894]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
[  189.067896]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
[  189.067902]  [<000003a8b263e2e8>] extent_write_cache_pages+0x348/0x4d0
[  189.067907]  [<000003a8b263ea0a>] btrfs_writepages+0x6a/0xd0
[  189.067910]  [<000003a8b21ad444>] do_writepages+0xd4/0x190
[  189.067915]  [<000003a8b2324590>] __writeback_single_inode+0x50/0x310
[  189.067917]  [<000003a8b2324b1a>] writeback_sb_inodes+0x2ca/0x690
[  189.067919]  [<000003a8b2324f36>] __writeback_inodes_wb+0x56/0x140
[  189.067921]  [<000003a8b2325498>] wb_writeback+0x368/0x460
[  189.067923]  [<000003a8b23258c6>] wb_do_writeback+0x336/0x3d0
[  189.067925]  [<000003a8b2325d2a>] wb_workfn+0x5a/0x1d0
[  189.067927]  [<000003a8b1f0cee2>] process_one_work+0x1d2/0x480
[  189.067932]  [<000003a8b1f0df30>] worker_thread+0x210/0x420
[  189.067935]  [<000003a8b1f190b8>] kthread+0x148/0x170
[  189.067939]  [<000003a8b1e90358>] __ret_from_fork+0x48/0x220
[  189.067941]  [<000003a8b2e2426a>] ret_from_fork+0xa/0x30
[  189.067994] task:oob-dirty-repro state:D stack:0     pid:8152  tgid:8151  ppid:7260   task_flags:0x400040 flags:0x00000800
[  189.067997] Call Trace:
[  189.067998]  [<000003a8b2e19284>] __schedule+0x374/0x900
[  189.068050]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
[  189.068052]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
[  189.068054]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
[  189.068057]  [<000003a8b263e2e8>] extent_write_cache_pages+0x348/0x4d0
[  189.068061]  [<000003a8b263ea0a>] btrfs_writepages+0x6a/0xd0
[  189.068063]  [<000003a8b21ad444>] do_writepages+0xd4/0x190
[  189.068066]  [<000003a8b2199dec>] filemap_writeback+0xbc/0x100
[  189.068069]  [<000003a8b2199e5a>] filemap_fdatawrite_range+0x2a/0x40
[  189.068072]  [<000003a8b2637d3c>] btrfs_start_ordered_extent_nowriteback+0x18c/0x1d0
[  189.068074]  [<000003a8b26260ce>] btrfs_page_mkwrite+0x22e/0x8d0
[  189.068079]  [<000003a8b21f89d0>] do_page_mkwrite+0x60/0xf0
[  189.068084]  [<000003a8b21ffa64>] do_wp_page+0x134/0x660
[  189.068086]  [<000003a8b2206584>] __handle_mm_fault+0x1c4/0x5a0
[  189.068088]  [<000003a8b22069f0>] handle_mm_fault+0x90/0x230
[  189.068090]  [<000003a8b1ebfbd0>] do_exception+0x190/0x560
[  189.068094]  [<000003a8b2e136c0>] __do_pgm_check+0x1b0/0x370
[  189.068098]  [<000003a8b2e243a4>] pgm_check_handler+0x114/0x160
[  189.068101]  [<000003a8b283135e>] _copy_to_iter+0x6e/0x870
[  189.068106]  [<000003a8b2831c4a>] copy_page_to_iter+0xea/0x160
[  189.068108]  [<000003a8b219ff8c>] filemap_read+0x1ec/0x400
[  189.068109]  [<000003a8b22d0a70>] vfs_read+0x210/0x370
[  189.068112]  [<000003a8b22d1694>] ksys_pread64+0xa4/0xd0
[  189.068114]  [<000003a8b2e13b7e>] __do_syscall+0x14e/0x590
[  189.068117]  [<000003a8b2e24242>] system_call+0x72/0x90
[  189.068120] task:oob-dirty-repro state:D stack:0     pid:8153  tgid:8151  ppid:7260   task_flags:0x400040 flags:0x00000000
[  189.068123] Call Trace:
[  189.068124]  [<000003a8b2e19284>] __schedule+0x374/0x900
[  189.068126]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
[  189.068128]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
[  189.068130]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
[  189.068133]  [<000003a8b263e2e8>] extent_write_cache_pages+0x348/0x4d0
[  189.068136]  [<000003a8b263ea0a>] btrfs_writepages+0x6a/0xd0
[  189.068138]  [<000003a8b21ad444>] do_writepages+0xd4/0x190
[  189.068141]  [<000003a8b2199dec>] filemap_writeback+0xbc/0x100
[  189.068144]  [<000003a8b2199e5a>] filemap_fdatawrite_range+0x2a/0x40
[  189.068146]  [<000003a8b2637d3c>] btrfs_start_ordered_extent_nowriteback+0x18c/0x1d0
[  189.068149]  [<000003a8b26260ce>] btrfs_page_mkwrite+0x22e/0x8d0
[  189.068152]  [<000003a8b21f89d0>] do_page_mkwrite+0x60/0xf0
[  189.068154]  [<000003a8b21ffa64>] do_wp_page+0x134/0x660
[  189.068156]  [<000003a8b2206584>] __handle_mm_fault+0x1c4/0x5a0
[  189.068158]  [<000003a8b22069f0>] handle_mm_fault+0x90/0x230
[  189.068160]  [<000003a8b1ebfbd0>] do_exception+0x190/0x560
[  189.068163]  [<000003a8b2e136c0>] __do_pgm_check+0x1b0/0x370
[  189.068165]  [<000003a8b2e243a4>] pgm_check_handler+0x114/0x160
[  189.068168]  [<000003a8b283135e>] _copy_to_iter+0x6e/0x870
[  189.068170]  [<000003a8b2831c4a>] copy_page_to_iter+0xea/0x160
[  189.068172]  [<000003a8b219ff8c>] filemap_read+0x1ec/0x400
[  189.068174]  [<000003a8b22d0a70>] vfs_read+0x210/0x370
[  189.068176]  [<000003a8b22d1694>] ksys_pread64+0xa4/0xd0
[  189.068178]  [<000003a8b2e13b7e>] __do_syscall+0x14e/0x590
[  189.068181]  [<000003a8b2e24242>] system_call+0x72/0x90
[  189.068184] task:oob-dirty-repro state:D stack:0     pid:8154  tgid:8151  ppid:7260   task_flags:0x400040 flags:0x00000000
[  189.068187] Call Trace:
[  189.068188]  [<000003a8b2e19284>] __schedule+0x374/0x900
[  189.068190]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
[  189.068192]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
[  189.068193]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
[  189.068196]  [<000003a8b26260fc>] btrfs_page_mkwrite+0x25c/0x8d0
[  189.068199]  [<000003a8b21f89d0>] do_page_mkwrite+0x60/0xf0
[  189.068202]  [<000003a8b21ffa64>] do_wp_page+0x134/0x660
[  189.068203]  [<000003a8b2206584>] __handle_mm_fault+0x1c4/0x5a0
[  189.068206]  [<000003a8b22069f0>] handle_mm_fault+0x90/0x230
[  189.068208]  [<000003a8b1ebfbd0>] do_exception+0x190/0x560
[  189.068210]  [<000003a8b2e136c0>] __do_pgm_check+0x1b0/0x370
[  189.068213]  [<000003a8b2e243a4>] pgm_check_handler+0x114/0x160
[  189.068215]  [<000003a8b283135e>] _copy_to_iter+0x6e/0x870
[  189.068218]  [<000003a8b2831c4a>] copy_page_to_iter+0xea/0x160
[  189.068219]  [<000003a8b219ff8c>] filemap_read+0x1ec/0x400
[  189.068221]  [<000003a8b22d0a70>] vfs_read+0x210/0x370
[  189.068223]  [<000003a8b22d1694>] ksys_pread64+0xa4/0xd0
[  189.068225]  [<000003a8b2e13b7e>] __do_syscall+0x14e/0x590
[  189.068228]  [<000003a8b2e24242>] system_call+0x72/0x90
[  189.068231] task:oob-dirty-repro state:D stack:0     pid:8155  tgid:8151  ppid:7260   task_flags:0x400040 flags:0x00000000
[  189.068234] Call Trace:
[  189.068235]  [<000003a8b2e19284>] __schedule+0x374/0x900
[  189.068237]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
[  189.068239]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
[  189.068241]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
[  189.068244]  [<000003a8b263e2e8>] extent_write_cache_pages+0x348/0x4d0
[  189.068246]  [<000003a8b263ea0a>] btrfs_writepages+0x6a/0xd0
[  189.068249]  [<000003a8b21ad444>] do_writepages+0xd4/0x190
[  189.068252]  [<000003a8b2199dec>] filemap_writeback+0xbc/0x100
[  189.068255]  [<000003a8b2199e5a>] filemap_fdatawrite_range+0x2a/0x40
[  189.068257]  [<000003a8b2637d3c>] btrfs_start_ordered_extent_nowriteback+0x18c/0x1d0
[  189.068260]  [<000003a8b26260ce>] btrfs_page_mkwrite+0x22e/0x8d0
[  189.068263]  [<000003a8b21f89d0>] do_page_mkwrite+0x60/0xf0
[  189.068265]  [<000003a8b21ffa64>] do_wp_page+0x134/0x660
[  189.068267]  [<000003a8b2206584>] __handle_mm_fault+0x1c4/0x5a0
[  189.068269]  [<000003a8b22069f0>] handle_mm_fault+0x90/0x230
[  189.068271]  [<000003a8b1ebfbd0>] do_exception+0x190/0x560
[  189.068274]  [<000003a8b2e136c0>] __do_pgm_check+0x1b0/0x370
[  189.068277]  [<000003a8b2e243a4>] pgm_check_handler+0x114/0x160
[  189.068279]  [<000003a8b283135e>] _copy_to_iter+0x6e/0x870
[  189.068281]  [<000003a8b2831c4a>] copy_page_to_iter+0xea/0x160
[  189.068283]  [<000003a8b219ff8c>] filemap_read+0x1ec/0x400
[  189.068285]  [<000003a8b22d0a70>] vfs_read+0x210/0x370
[  189.068287]  [<000003a8b22d1694>] ksys_pread64+0xa4/0xd0
[  189.068289]  [<000003a8b2e13b7e>] __do_syscall+0x14e/0x590
[  189.068292]  [<000003a8b2e24242>] system_call+0x72/0x90
[  189.068294] task:oob-dirty-repro state:D stack:0     pid:8156  tgid:8151  ppid:7260   task_flags:0x400040 flags:0x00000000
[  189.068297] Call Trace:
[  189.068298]  [<000003a8b2e19284>] __schedule+0x374/0x900
[  189.068300]  [<000003a8b2e1984c>] schedule+0x3c/0xf0
[  189.068302]  [<000003a8b2e1996c>] io_schedule+0x2c/0x40
[  189.068304]  [<000003a8b219d158>] folio_wait_bit_common+0x198/0x3b0
[  189.068307]  [<000003a8b263e2e8>] extent_write_cache_pages+0x348/0x4d0
[  189.068310]  [<000003a8b263ea0a>] btrfs_writepages+0x6a/0xd0
[  189.068313]  [<000003a8b21ad444>] do_writepages+0xd4/0x190
[  189.068315]  [<000003a8b2199dec>] filemap_writeback+0xbc/0x100
[  189.068318]  [<000003a8b2199e5a>] filemap_fdatawrite_range+0x2a/0x40
[  189.068320]  [<000003a8b232bbf2>] sync_file_range+0x122/0x150
[  189.068323]  [<000003a8b232bc84>] ksys_sync_file_range+0x64/0xb0
[  189.068326]  [<000003a8b232bd0a>] __s390x_sys_sync_file_range+0x3a/0x50
[  189.068328]  [<000003a8b2e13b7e>] __do_syscall+0x14e/0x590
[  189.068331]  [<000003a8b2e24242>] system_call+0x72/0x90
--------------uGF6w02qFA3LZDIF9td4sMgh
Content-Type: text/x-csrc; charset=UTF-8; name="oob-dirty-repro.c"
Content-Disposition: attachment; filename="oob-dirty-repro.c"
Content-Transfer-Encoding: base64

Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAKLyoKICogb29iLWRpcnR5LXJl
cHJvLmMgLSByZXByb2R1Y2Ugb3V0LW9mLWJhbmQgZGlydHkgZm9saW9zIG9uIGJ0cmZzCiAq
ICAgICAgICAgICAgICAgICAgICAgKGZvbGlvIGxvY2sgbGVhayBpbiB3cml0ZXBhZ2VfZGVs
YWxsb2MoKSkKICoKICogRGVtb25zdHJhdGVzIHRoYXQgYSAiZm9saW8tbGV2ZWwgZGlydHkg
ZmxhZyBzZXQsIGZzIG5ldmVyIG5vdGlmaWVkIgogKiBzdGF0ZSBjYW4gYmUgcHJvZHVjZWQg
b24gYW55IGFyY2hpdGVjdHVyZSB3aXRoIHNhbmN0aW9uZWQsIGluLXRyZWUKICogQVBJcyAt
IG5vIHMzOTAsIG5vIEtWTSByZXF1aXJlZDoKICoKICogICAxLiBBIGZpbGUgb24gYnRyZnMg
aXMgd3JpdHRlbiB3aXRoIGxhcmdlIGJ1ZmZlcmVkIHdyaXRlcyBzbyB0aGUKICogICAgICBw
YWdlIGNhY2hlIGJhY2tzIGl0IHdpdGggbGFyZ2UgZGF0YSBmb2xpb3MgKHY3LjItcmMxKyku
CiAqICAgMi4gVGhlIGZpbGUgaXMgbW1hcCdlZCBNQVBfU0hBUkVELgogKiAgIDMuIFRocmVh
ZCBBIGxvb3BzIE9fRElSRUNUIHJlYWRzICppbnRvKiB0aGF0IG1hcHBpbmcuICBUaGUgZGly
ZWN0CiAqICAgICAgSS9PIHJlYWQgcGF0aCBwaW5zIHRoZSBkZXN0aW5hdGlvbiBwYWdlcyAo
R1VQOyB0aGUgaW5pdGlhbAogKiAgICAgIGZhdWx0IHJ1bnMgLT5wYWdlX21rd3JpdGUoKSBh
bmQgcmVzZXJ2ZXMgZGVsYWxsb2MgcHJvcGVybHkpCiAqICAgICAgYW5kIG9uIGJpbyBjb21w
bGV0aW9uIHJlLWRpcnRpZXMgdGhlbSB2aWEKICogICAgICBiaW9fY2hlY2tfcGFnZXNfZGly
dHkoKSAtPiBiaW9fcmVsZWFzZV9wYWdlcyh0cnVlKQogKiAgICAgIC0+IHVucGluX3VzZXJf
cGFnZXNfZGlydHlfbG9jaygpIC0+IHNldF9wYWdlX2RpcnR5X2xvY2soKS4KICogICA0LiBU
aHJlYWQgQiBsb29wcyBzeW5jX2ZpbGVfcmFuZ2UoV1JJVEV8V0FJVCkgb24gdGhlIHRhcmdl
dCBmaWxlLgogKiAgICAgIFdoZW5ldmVyIGEgZnVsbCBjbGVhbiBjeWNsZSAoY2xlYXJfcGFn
ZV9kaXJ0eV9mb3JfaW8oKSwKICogICAgICB3cml0ZWJhY2ssIGJpdHMgY2xlYXJlZCkgY29t
cGxldGVzIGluc2lkZSB0aHJlYWQgQSdzCiAqICAgICAgc3VibWlzc2lvbi0+Y29tcGxldGlv
biB3aW5kb3csIHRoZSBjb21wbGV0aW9uLXRpbWUKICogICAgICBzZXRfcGFnZV9kaXJ0eV9s
b2NrKCkgaGl0cyBhICpjbGVhbiogZm9saW86IGZpbGVtYXBfZGlydHlfZm9saW8oKQogKiAg
ICAgIHNldHMgb25seSB0aGUgZm9saW8gZmxhZyBhbmQgdGhlIHhhcnJheSB0YWcgLSBubyBi
dHJmcyBzdWJwYWdlCiAqICAgICAgZGlydHkgYml0LCBubyBkZWxhbGxvYyByZXNlcnZhdGlv
bi4gIFNlZSB0aGUgMjAteWVhci1vbGQgY29tbWVudAogKiAgICAgIGFib3ZlIGJpb19zZXRf
cGFnZXNfZGlydHkoKSBpbiBibG9jay9iaW8uYyBkZXNjcmliaW5nIGV4YWN0bHkKICogICAg
ICB0aGlzICgib3RoZXIgY29kZSAoZWcsIGZsdXNoZXIgdGhyZWFkcykgY291bGQgY2xlYW4g
dGhlIHBhZ2VzIikuCiAqICAgNS4gVGhlIG5leHQgd3JpdGViYWNrIG9mIHRoYXQgZm9saW8g
ZW50ZXJzIHdyaXRlcGFnZV9kZWxhbGxvYygpCiAqICAgICAgd2l0aCBhbiBlbXB0eSBzdWJw
YWdlIGRpcnR5IGJpdG1hcCwgdGFrZXMgdGhlCiAqICAgICAgYml0bWFwX2VtcHR5KCkgLT4g
cmV0dXJuIDEgcGF0aCBhbmQgbGVha3MgdGhlIGZvbGlvIGxvY2suCiAqICAgICAgRXZlcnkg
c3Vic2VxdWVudCBsb2NrZXIgKG1rd3JpdGUgZmF1bHRzLCBzeW5jLCBmbHVzaGVyKSB0aGVu
CiAqICAgICAgaGFuZ3MgaW4gRCBzdGF0ZS4KICoKICogVGhyZWFkIEMgc3RvcmVzIGludG8g
dGhlIG1hcHBpbmcgKG1rd3JpdGUgdHJhZmZpYywgbGlrZSBLVk0gdkNQVXMpCiAqIGFuZCBh
IHdhdGNoZG9nIHJlcG9ydHMgd2hlbiBhbGwgdGhyZWFkcyBzdG9wIG1ha2luZyBwcm9ncmVz
cy4KICoKICogVXNhZ2U6ICBnY2MgLU8yIC1wdGhyZWFkIC1XYWxsIC1vIG9vYi1kaXJ0eS1y
ZXBybyBvb2ItZGlydHktcmVwcm8uYwogKiAgICAgICAgIC4vb29iLWRpcnR5LXJlcHJvIDxk
aXItb24tYnRyZnM+IFtydW50aW1lLXNlY29uZHNdCiAqCiAqIEV4cGVjdGVkIG9uIDcuMi1y
YyAobGFyZ2UgZGF0YSBmb2xpb3MgZW5hYmxlZCk6IHdpdGhpbiBtaW51dGVzIHRoZQogKiB3
YXRjaGRvZyByZXBvcnRzIGEgc3RhbGw7IHRoZSBzeW5jL3N0b3JlL2lvIHRocmVhZHMgYXJl
IGluIEQgc3RhdGUsCiAqICJlY2hvIHcgPiAvcHJvYy9zeXNycS10cmlnZ2VyIiBzaG93cyB0
aGVtIHF1ZXVlZCBvbiBhIGZvbGlvIGxvY2sKICogKGZvbGlvX3dhaXRfYml0X2NvbW1vbiA8
LSBidHJmc19wYWdlX21rd3JpdGUgLyBleHRlbnRfd3JpdGVfY2FjaGVfcGFnZXMpLgogKiBP
biBrZXJuZWxzIHdpdGhvdXQgbGFyZ2UgZGF0YSBmb2xpb3MgdGhlIGxlYWsgcGF0aCBpcyBu
b3QgcmVhY2hhYmxlCiAqIChzaW5nbGUtYmxvY2sgZm9saW9zIGdldCBiaXQgMCBmb3JjZWQg
aW4gYnRyZnNfY29weV9zdWJwYWdlX2RpcnR5X2JpdG1hcCgpKTsKICogdGhlIHNhbWUgcmFj
ZSB0aGVuIHByb2R1Y2VzIHRoZSBvdXQtb2YtYmFuZCBzdGF0ZSB0aGF0IHRoZSAocmVtb3Zl
ZCkKICogQ09XIGZpeHVwIC8gInJlamVjdCBvdXQtb2YtYmFuZCBkaXJ0eSBmb2xpb3MiIGNv
ZGUgdXNlZCB0byBjYXRjaC4KICoKICogV0FSTklORzogb24gYWZmZWN0ZWQga2VybmVscyB0
aGlzIHdlZGdlcyB3cml0ZWJhY2sgb2YgdGhlIHRhcmdldAogKiBmaWxlc3lzdGVtICh1bmtp
bGxhYmxlIEQtc3RhdGUgdGFza3MsIHN5bmNmcyBoYW5ncykgdW50aWwgcmVib290LgogKiBS
dW4gaXQgb24gYSBzY3JhdGNoIG1hY2hpbmUuCiAqLwojZGVmaW5lIF9HTlVfU09VUkNFCiNp
bmNsdWRlIDxlcnJuby5oPgojaW5jbHVkZSA8ZmNudGwuaD4KI2luY2x1ZGUgPGxpbnV4L2Zz
Lmg+CiNpbmNsdWRlIDxzeXMvaW9jdGwuaD4KI2luY2x1ZGUgPHB0aHJlYWQuaD4KI2luY2x1
ZGUgPHN0ZGF0b21pYy5oPgojaW5jbHVkZSA8c3RkaW50Lmg+CiNpbmNsdWRlIDxzdGRpby5o
PgojaW5jbHVkZSA8c3RkbGliLmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2luY2x1ZGUgPHN5
cy9tbWFuLmg+CiNpbmNsdWRlIDxzeXMvc3RhdC5oPgojaW5jbHVkZSA8c3lzL3N0YXRmcy5o
PgojaW5jbHVkZSA8dGltZS5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CgojZGVmaW5lIEJUUkZT
X1NVUEVSX01BR0lDIDB4OTEyMzY4M0UKCiNkZWZpbmUgVEFSR0VUX1NaCSgxNlVMIDw8IDIw
KQkvKiBtbWFwJ2VkIHRhcmdldCBmaWxlICAgICAgICAgICovCiNkZWZpbmUgU1JDX1NaCQko
NFVMIDw8IDIwKQkvKiBPX0RJUkVDVCByZWFkIHNvdXJjZSAgICAgICAgICovCiNkZWZpbmUg
SU9fU1oJCSgyVUwgPDwgMjApCS8qIHBlci1yZWFkIHNpemUgKHdpZGUgd2luZG93KSAgKi8K
I2RlZmluZSBXUklURV9DSFVOSwkoMVVMIDw8IDIwKQkvKiBidWZmZXJlZCBpbml0IHdyaXRl
cyAobGFyZ2UgZm9saW9zKSAqLwojZGVmaW5lIFNUQUxMX1NFQ1MJMjAKI2RlZmluZSBOUl9J
T19USFJFQURTCTQKCnN0YXRpYyBjaGFyICptYXA7CnN0YXRpYyBpbnQgdGFyZ2V0X2ZkLCBz
cmNfZmQ7CnN0YXRpYyBhdG9taWNfdWxvbmcgaW9faXRlcnMsIHN5bmNfaXRlcnMsIHN0b3Jl
X2l0ZXJzOwpzdGF0aWMgYXRvbWljX2ludCBzdG9wOwpzdGF0aWMgdW5zaWduZWQgbG9uZyBy
dW50aW1lID0gNjAwOwoKc3RhdGljIHZvaWQgZGllKGNvbnN0IGNoYXIgKndoYXQpCnsKCXBl
cnJvcih3aGF0KTsKCWV4aXQoMSk7Cn0KCnN0YXRpYyB2b2lkICppb190aHJlYWQodm9pZCAq
YXJnIF9fYXR0cmlidXRlX18oKHVudXNlZCkpKQp7CgkvKgoJICogT25seSB0aGUgbG93ZXIg
aGFsZjogYnRyZnMgdmVyaWZpZXMgcmVhZCBjc3VtcyBpbiB0aGUgKHBpbm5lZCkKCSAqIGRl
c3RpbmF0aW9uIHBhZ2VzIGFmdGVyIERNQSwgc28gdGhlIHN0b3JlIHRocmVhZCBtdXN0IG5v
dCBwb2tlCgkgKiB0aGUgc2FtZSBwYWdlcywgYW5kIHRoZSBOT0NPVyBzb3VyY2UgYXZvaWRz
IGNzdW1zIGFsdG9nZXRoZXIuCgkgKi8KCXVuc2lnbmVkIGxvbmcgbnJhbmdlcyA9IChUQVJH
RVRfU1ogLyAyKSAvIElPX1NaOwoKCXdoaWxlICghYXRvbWljX2xvYWQoJnN0b3ApKSB7CgkJ
b2ZmX3Qgb2ZmID0gKHJhbmRvbSgpICUgbnJhbmdlcykgKiBJT19TWjsKCQlzc2l6ZV90IHIg
PSBwcmVhZChzcmNfZmQsIG1hcCArIG9mZiwgSU9fU1osIDApOwoKCQlpZiAociA8IDAgJiYg
ZXJybm8gIT0gRUlOVFIgJiYgZXJybm8gIT0gRUlPKQoJCQlkaWUoIk9fRElSRUNUIHByZWFk
IGludG8gbWFwcGluZyIpOwoJCWF0b21pY19mZXRjaF9hZGQoJmlvX2l0ZXJzLCAxKTsKCX0K
CXJldHVybiBOVUxMOwp9CgpzdGF0aWMgdm9pZCAqc3luY190aHJlYWQodm9pZCAqYXJnIF9f
YXR0cmlidXRlX18oKHVudXNlZCkpKQp7Cgl3aGlsZSAoIWF0b21pY19sb2FkKCZzdG9wKSkg
ewoJCWlmIChzeW5jX2ZpbGVfcmFuZ2UodGFyZ2V0X2ZkLCAwLCBUQVJHRVRfU1osCgkJCQkg
ICAgU1lOQ19GSUxFX1JBTkdFX1dBSVRfQkVGT1JFIHwKCQkJCSAgICBTWU5DX0ZJTEVfUkFO
R0VfV1JJVEUgfAoJCQkJICAgIFNZTkNfRklMRV9SQU5HRV9XQUlUX0FGVEVSKSA8IDApCgkJ
CWRpZSgic3luY19maWxlX3JhbmdlIik7CgkJYXRvbWljX2ZldGNoX2FkZCgmc3luY19pdGVy
cywgMSk7Cgl9CglyZXR1cm4gTlVMTDsKfQoKc3RhdGljIHZvaWQgKnN0b3JlX3RocmVhZCh2
b2lkICphcmcgX19hdHRyaWJ1dGVfXygodW51c2VkKSkpCnsKCXN0cnVjdCB0aW1lc3BlYyB0
cyA9IHsgMCwgMTAwMDAwMCB9OwkvKiAxbXMgKi8KCgl3aGlsZSAoIWF0b21pY19sb2FkKCZz
dG9wKSkgewoJCXVuc2lnbmVkIGxvbmcgb2ZmID0gVEFSR0VUX1NaIC8gMiArCgkJCShyYW5k
b20oKSAlIChUQVJHRVRfU1ogLyAyIC8gNDA5NikpICogNDA5NjsKCgkJbWFwW29mZl0gXj0g
MTsJCQkvKiBta3dyaXRlIGZhdWx0IHRyYWZmaWMgKi8KCQlhdG9taWNfZmV0Y2hfYWRkKCZz
dG9yZV9pdGVycywgMSk7CgkJbmFub3NsZWVwKCZ0cywgTlVMTCk7Cgl9CglyZXR1cm4gTlVM
TDsKfQoKaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQp7CgljaGFyIHBhdGhbNDA5
Nl0sICpidWY7CglzdHJ1Y3Qgc3RhdGZzIHNmczsKCXB0aHJlYWRfdCBpb1tOUl9JT19USFJF
QURTXSwgc3ksIHN0OwoJdW5zaWduZWQgbG9uZyBsYXN0X2lvID0gMCwgbGFzdF9zeW5jID0g
MDsKCXVuc2lnbmVkIGxvbmcgZWxhcHNlZCA9IDAsIHN0YWxsZWQgPSAwOwoKCXNldHZidWYo
c3Rkb3V0LCBOVUxMLCBfSU9MQkYsIDApOwoJaWYgKGFyZ2MgPCAyKSB7CgkJZnByaW50Zihz
dGRlcnIsICJ1c2FnZTogJXMgPGRpci1vbi1idHJmcz4gW3J1bnRpbWUtc2Vjc11cbiIsCgkJ
CWFyZ3ZbMF0pOwoJCXJldHVybiAxOwoJfQoJaWYgKGFyZ2MgPiAyKQoJCXJ1bnRpbWUgPSBz
dHJ0b3VsKGFyZ3ZbMl0sIE5VTEwsIDApOwoKCWlmIChzdGF0ZnMoYXJndlsxXSwgJnNmcykg
PCAwKQoJCWRpZSgic3RhdGZzIik7CglpZiAoKHVuc2lnbmVkIGludClzZnMuZl90eXBlICE9
IEJUUkZTX1NVUEVSX01BR0lDKQoJCWZwcmludGYoc3RkZXJyLCAid2FybmluZzogJXMgaXMg
bm90IG9uIGJ0cmZzLCAiCgkJCSJ0aGUgd3JpdGVwYWdlX2RlbGFsbG9jKCkgcGF0aCB3aWxs
IG5vdCBiZSBoaXRcbiIsCgkJCWFyZ3ZbMV0pOwoKCS8qIFRhcmdldCBmaWxlOiBsYXJnZSBi
dWZmZXJlZCB3cml0ZXMgLT4gbGFyZ2UgZGF0YSBmb2xpb3MuICovCglzbnByaW50ZihwYXRo
LCBzaXplb2YocGF0aCksICIlcy9vb2ItdGFyZ2V0LmRhdCIsIGFyZ3ZbMV0pOwoJdGFyZ2V0
X2ZkID0gb3BlbihwYXRoLCBPX1JEV1IgfCBPX0NSRUFUIHwgT19UUlVOQywgMDYwMCk7Cglp
ZiAodGFyZ2V0X2ZkIDwgMCkKCQlkaWUoIm9wZW4gdGFyZ2V0Iik7CglidWYgPSBhbGlnbmVk
X2FsbG9jKDQwOTYsIFdSSVRFX0NIVU5LKTsKCWlmICghYnVmKQoJCWRpZSgiYWxpZ25lZF9h
bGxvYyIpOwoJbWVtc2V0KGJ1ZiwgMHg1YSwgV1JJVEVfQ0hVTkspOwoJZm9yICh1bnNpZ25l
ZCBsb25nIG8gPSAwOyBvIDwgVEFSR0VUX1NaOyBvICs9IFdSSVRFX0NIVU5LKQoJCWlmIChw
d3JpdGUodGFyZ2V0X2ZkLCBidWYsIFdSSVRFX0NIVU5LLCBvKSAhPSBXUklURV9DSFVOSykK
CQkJZGllKCJwd3JpdGUgdGFyZ2V0Iik7CglpZiAoZnN5bmModGFyZ2V0X2ZkKSA8IDApCgkJ
ZGllKCJmc3luYyB0YXJnZXQiKTsKCgkvKiBTb3VyY2UgZmlsZSBmb3IgdGhlIE9fRElSRUNU
IHJlYWRzLiAqLwoJc25wcmludGYocGF0aCwgc2l6ZW9mKHBhdGgpLCAiJXMvb29iLXNyYy5k
YXQiLCBhcmd2WzFdKTsKCXNyY19mZCA9IG9wZW4ocGF0aCwgT19SRFdSIHwgT19DUkVBVCB8
IE9fVFJVTkMgfCBPX0RJUkVDVCwgMDYwMCk7CglpZiAoc3JjX2ZkIDwgMCkKCQlkaWUoIm9w
ZW4gc291cmNlIChPX0RJUkVDVCkiKTsKCXsJLyogTk9DT1cvbm9kYXRhc3VtOiBrZWVwIGNz
dW0gdmVyaWZpY2F0aW9uIG91dCBvZiB0aGUgcGljdHVyZSAqLwoJCWludCBhdHRyID0gMDsK
CgkJaW9jdGwoc3JjX2ZkLCBGU19JT0NfR0VURkxBR1MsICZhdHRyKTsKCQlhdHRyIHw9IEZT
X05PQ09XX0ZMOwoJCWlvY3RsKHNyY19mZCwgRlNfSU9DX1NFVEZMQUdTLCAmYXR0cik7Cgl9
Cglmb3IgKHVuc2lnbmVkIGxvbmcgbyA9IDA7IG8gPCBTUkNfU1o7IG8gKz0gV1JJVEVfQ0hV
TkspCgkJaWYgKHB3cml0ZShzcmNfZmQsIGJ1ZiwgV1JJVEVfQ0hVTkssIG8pICE9IFdSSVRF
X0NIVU5LKQoJCQlkaWUoInB3cml0ZSBzb3VyY2UiKTsKCWlmIChmc3luYyhzcmNfZmQpIDwg
MCkKCQlkaWUoImZzeW5jIHNvdXJjZSIpOwoJZnJlZShidWYpOwoKCW1hcCA9IG1tYXAoTlVM
TCwgVEFSR0VUX1NaLCBQUk9UX1JFQUQgfCBQUk9UX1dSSVRFLCBNQVBfU0hBUkVELAoJCSAg
IHRhcmdldF9mZCwgMCk7CglpZiAobWFwID09IE1BUF9GQUlMRUQpCgkJZGllKCJtbWFwIik7
CgoJcHJpbnRmKCJydW5uaW5nOiBPX0RJUkVDVCByZWFkcyBpbnRvIE1BUF9TSEFSRUQgYnRy
ZnMgbWFwcGluZyB2cy4gIgoJICAgICAgICJzeW5jX2ZpbGVfcmFuZ2UsICVsdXMgbWF4XG4i
LCBydW50aW1lKTsKCglmb3IgKGludCBuID0gMDsgbiA8IE5SX0lPX1RIUkVBRFM7IG4rKykK
CQlwdGhyZWFkX2NyZWF0ZSgmaW9bbl0sIE5VTEwsIGlvX3RocmVhZCwgTlVMTCk7CglwdGhy
ZWFkX2NyZWF0ZSgmc3ksIE5VTEwsIHN5bmNfdGhyZWFkLCBOVUxMKTsKCXB0aHJlYWRfY3Jl
YXRlKCZzdCwgTlVMTCwgc3RvcmVfdGhyZWFkLCBOVUxMKTsKCglmb3IgKGVsYXBzZWQgPSAw
OyBlbGFwc2VkIDwgcnVudGltZTsgZWxhcHNlZCArPSA1KSB7CgkJdW5zaWduZWQgbG9uZyBp
LCBzLCB3OwoKCQlzbGVlcCg1KTsKCQlpID0gYXRvbWljX2xvYWQoJmlvX2l0ZXJzKTsKCQlz
ID0gYXRvbWljX2xvYWQoJnN5bmNfaXRlcnMpOwoJCXcgPSBhdG9taWNfbG9hZCgmc3RvcmVf
aXRlcnMpOwoJCXByaW50ZigiICB0PSU0bHVzIGlvPSVsdSBzeW5jPSVsdSBzdG9yZT0lbHVc
biIsCgkJICAgICAgIGVsYXBzZWQgKyA1LCBpLCBzLCB3KTsKCgkJaWYgKGkgPT0gbGFzdF9p
byAmJiBzID09IGxhc3Rfc3luYykgewoJCQlzdGFsbGVkICs9IDU7CgkJCWlmIChzdGFsbGVk
ID49IFNUQUxMX1NFQ1MpIHsKCQkJCXByaW50ZigiXG4qKiogaW8rc3luYyBUSFJFQURTIFNU
QUxMRUQgZm9yICV1cyAtICIKCQkJCSAgICAgICAiZm9saW8gbG9jayBsZWFrIHJlcHJvZHVj
ZWQ/ICoqKlxuIgoJCQkJICAgICAgICJDaGVjazogIGdyZXAgLWwgLiAvcHJvYy8lZC90YXNr
Lyovc3RhY2sgIgoJCQkJICAgICAgICJ8IHhhcmdzIGNhdFxuIgoJCQkJICAgICAgICIgICAg
ICAgIGVjaG8gdyA+IC9wcm9jL3N5c3JxLXRyaWdnZXI7ICIKCQkJCSAgICAgICAiZG1lc2cg
fCB0YWlsIC0xMDBcbiIKCQkJCSAgICAgICAiRXhwZWN0OiBmb2xpb193YWl0X2JpdF9jb21t
b24gPC0gIgoJCQkJICAgICAgICJidHJmc19wYWdlX21rd3JpdGUgL1xuIgoJCQkJICAgICAg
ICIgICAgICAgIGV4dGVudF93cml0ZV9jYWNoZV9wYWdlcyBpbiAiCgkJCQkgICAgICAgIkQt
c3RhdGUgdGhyZWFkcy5cbiIsCgkJCQkgICAgICAgU1RBTExfU0VDUywgZ2V0cGlkKCkpOwoJ
CQkJLyogbGVhdmUgdGhlIGh1bmcgcHJvY2VzcyBmb3IgaW5zcGVjdGlvbiAqLwoJCQkJcGF1
c2UoKTsKCQkJfQoJCX0gZWxzZSB7CgkJCXN0YWxsZWQgPSAwOwoJCX0KCQlsYXN0X2lvID0g
aTsKCQlsYXN0X3N5bmMgPSBzOwoKCX0KCglhdG9taWNfc3RvcmUoJnN0b3AsIDEpOwoJZm9y
IChpbnQgbiA9IDA7IG4gPCBOUl9JT19USFJFQURTOyBuKyspCgkJcHRocmVhZF9qb2luKGlv
W25dLCBOVUxMKTsKCXB0aHJlYWRfam9pbihzeSwgTlVMTCk7CglwdGhyZWFkX2pvaW4oc3Qs
IE5VTEwpOwoJcHJpbnRmKCJmaW5pc2hlZCB3aXRob3V0IHN0YWxsIC0gbm90IHJlcHJvZHVj
ZWQgaW4gJWx1cyAiCgkgICAgICAgIih0cnkgYSBsb25nZXIgcnVudGltZTsgdGhlIHJhY2Ug
d2luZG93IGlzXG4iCgkgICAgICAgInN1Ym1pc3Npb24tPmNvbXBsZXRpb24gb2YgdGhlIE9f
RElSRUNUIHJlYWQgdnMuIG9uZSBmdWxsICIKCSAgICAgICAid3JpdGViYWNrIGN5Y2xlKVxu
IiwgcnVudGltZSk7CglyZXR1cm4gMDsKfQo=

--------------uGF6w02qFA3LZDIF9td4sMgh--

