Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7283CBE6D
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 06:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784789368; cv=none; b=gBXgp26Cw8Qw1qETL/xWx+GRhfnM1V4UsgSuwspB4rrLP6q6itmbF/XTKeus9CHhGLIVVAKLiLysamBd32ExRq3iNz49zgMPw8lGnUZNywc7/kKm/GIpupBN0NoFIz/ojpQEUNDJoSD+NI5gCVX75CHlHh2CufIBvLFtZKEHU8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784789368; c=relaxed/simple;
	bh=1phmm5YvjLat5nUC6gH0u+Whsw3zqxLqU6OC2D4VKP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HPwaIL5S+mdhhjSpeDDFJtsJTXPEZ5O4kBEJt7RPeyb5urfakgnD4Z2YWOD4xtNd4YKPH/gmKUk78KWFhDw5diK0C/O3ktcNcz/GbPy/7ahbOWdoqrow6+LXBe7aQScm8/cYclusp0DUyMcPsC5fxF+CJlPr1aLE9tLATVC/sUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Kk9eh9kz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Kk9eh9kz"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N5BYXN191404;
	Thu, 23 Jul 2026 06:49:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=4W8SgK
	huDbjb2uA7V729opEtZTUkvS51d8iIHLsG7jg=; b=Kk9eh9kzPe3rxRi4ZfchPp
	K72yoE06ZUbUIdgLvFUW0ptFvozK0GPHYJ74hHy8yw6MQ4Oz/bzbt2majGsP1UtG
	qwUhDfYRLCddzsZtu90f06KvZuhM7YoxoE6yaygoENuKQpVr79bFzkdQ8/GAnXL8
	gG/WZKkuo2kbv2Vk0J3IhchgyunSbohUXsWZlQCYbiSpdxS4wRJGWepgbxpg6j7H
	XetbEmypp2PDHY1jK1ZzkSJureG7FKsG1RMuh9z1trXmlQWlqcUP2XHdPiWGW/Xh
	0ftYEXTUD46CVwDvw79JrNFR3Ge8C5BxzS+XiQQRVS48Wih0xkFIsrzTiuYaZNgg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg77ap5h2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 06:49:21 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66N6Yb3q011123;
	Thu, 23 Jul 2026 06:49:20 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgmtk2y1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 06:49:20 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N6nIpn14745994
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 06:49:18 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D1CF20043;
	Thu, 23 Jul 2026 06:49:18 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 178D220040;
	Thu, 23 Jul 2026 06:49:18 +0000 (GMT)
Received: from [9.224.77.173] (unknown [9.224.77.173])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 06:49:18 +0000 (GMT)
Message-ID: <9b1d42c4-2c3f-410e-aceb-92400b8bc24f@linux.ibm.com>
Date: Thu, 23 Jul 2026 08:48:40 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] btrfs: disable direct reads to avoid dirty folios
 without fs knowing
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <c6dfdac9fc51c94183e51a861eec269185239660.1784787211.git.wqu@suse.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <c6dfdac9fc51c94183e51a861eec269185239660.1784787211.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IiA6g2MTWtnHHq9jdSigOm0UpTRrgFWz
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA2NiBTYWx0ZWRfX9XuslmJ1Pp9U
 b7PoHE7JYj1k6f1PDg9UNzzs3PP2FCmGqPzNU7uN8IqLAmJ8OSh4X84pUd4ZIeXXgRbeW81BAZw
 b8pn5faJqiuAdWl7nHEQc56YLR36Sj4=
X-Proofpoint-GUID: IiA6g2MTWtnHHq9jdSigOm0UpTRrgFWz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA2NiBTYWx0ZWRfXx4ZBbcBbKxe2
 vzk8F+I16/qlxZkq4whZ4Ebj5EdlWShf33QeGbBZQM6DmfX95YBKq18Nrgj5taKluyGpYA9tooL
 e05n2HPn8qVIXRH4sL3AxcP+POmFNz7wj0vsc2wSxtq8BxmLGBY+jctB+T1SuqNWSn4TUqNQikE
 s45+cyPMQmjv8AZV6jFt8qBcLcyvkxSBuumCYhp5CV+Jcg0K1aJPIdqm9E3pPu34u7o+T3xe6zb
 esw+078GKr/DZlaIW+pr5x2YJ0W8NY0f69wXUiRfB5wwqH8lTnZ/al7pw8HPkhK4Z3z0CoVFEAd
 2xA1OkZec3+Zxvb681VPc28/PqNRsQ/TgqIF46eBY13Om8CQxr87nR+n0vCaD4fqMxH27eOhwXc
 H7aqJPhYkjfrCXFWRJko/zSNwgeEms1d5OIwC4Z9D6Lgbo4E6a8kRrM5Og19t3fy1T2otQbnfyv
 VVXNIMEoy/QPvSBYYAQ==
X-Authority-Analysis: v=2.4 cv=K7AS2SWI c=1 sm=1 tr=0 ts=6a61b971 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=iox4zFpeAAAA:8 a=sVdqr26G1iB9TVzeq4kA:9 a=QEXdDO2ut3YA:10
 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607230066

Am 23.07.26 um 08:13 schrieb Qu Wenruo:
> There is a bug report that a reproducer which doing the following
> workloads in two threads:
> 
> - Direct read into memory mapped from page cache
> - Sync the above range
> 
> This can lead to dirty folios without fs knowing, this can be a huge
> problem for btrfs, as even on the very basic bs == ps cases without
> large folios, such reproducer can screw up the ordered extent accounting
> already:
> 
>   ------------[ cut here ]------------
>   WARNING: fs/btrfs/ordered-data.c:390 at can_finish_ordered_extent.isra.0+0x56/0x1f0 [btrfs], CPU#1: kworker/u42:0/68
>   CPU: 1 UID: 0 PID: 68 Comm: kworker/u42:0 Tainted: G            E       7.2.0-rc4-custom+ #415 PREEMPT(full)  74dbeafab12c410178747d5bec9fb200ae56949f
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
>   Workqueue: btrfs-endio simple_end_io_work [btrfs]
>   RIP: 0010:can_finish_ordered_extent.isra.0+0x56/0x1f0 [btrfs]
>   Call Trace:
>    <TASK>
>    btrfs_finish_ordered_extent+0x39/0xd0 [btrfs 7d1ffd99bb9696179883f257e5fd838e2d1a0ca3]
>    end_bbio_data_write+0x1ff/0x280 [btrfs 7d1ffd99bb9696179883f257e5fd838e2d1a0ca3]
>    btrfs_bio_end_io+0x76/0xf0 [btrfs 7d1ffd99bb9696179883f257e5fd838e2d1a0ca3]
>    process_one_work+0x198/0x380
>    worker_thread+0x1c8/0x330
>    kthread+0xee/0x120
>    ret_from_fork+0x28f/0x310
>    ret_from_fork_asm+0x11/0x20
>    </TASK>
>   ---[ end trace 0000000000000000 ]---
>   BTRFS critical (device dm-3): bad ordered extent accounting, root=5 ino=257 OE offset=3465216 OE len=2826240 to_dec=319488 left=135168
> 
> Unfortunately we have removed cow fixup mechanism, which is to work
> around such dirty folios by re-dirtying them and reserve space for them,
> across several kernel releases, meaning we can not easily revert a
> single commit to bring it back.
> And without doubt, that old cow fixup mechanism is not support larger
> folios.
> 
> As a hot fix, disable btrfs direct reads for non-experimental builds for
> now, so this can buy some time before we find out a proper way to address
> this.
> 
> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Link: https://lore.kernel.org/linux-btrfs/f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com/
> Signed-off-by: Qu Wenruo <wqu@suse.com>


Wow that is a big hammer. Doesnt that break typical usecases (like databases on a file,
qemu/kvm aio+direct image files etc)?

Even worse, this does not fix the other GUP use cases that still exist? So its only
a partial fix. Have you considered to add my RFC patch on top to close another
problem that I can reproduce easily.

