Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACA032D0F5
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 16:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783958981; cv=none; b=qFeD/L7VC9Ho+EtNVll3HtEHCvyYacWh3Xmppx1ThPTYFAQcrmayHCY0sjofRhfasBiYdcCjBT1Ez9KoU4HFNtO+KQPMtns1HbCqdngHphQWiiSh4BuhAGospEbfQe2P+k6iumkkMcc+DQJCv0172Q1VMQkzlbDZ6KgrPb/SYfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783958981; c=relaxed/simple;
	bh=s8w9VfSHAdI6tOsd/o3bKxrQ55C1CPICE3ClYQ0NYTQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=CdtzOeJ2qrcVQHtChOqawoId9Q3BohYrfqdI7oHR4qGhP2gpD5U8ZIy6p58yJWComX2X1bnHyCAndk33KLhOhsDFpKxKObnmY565UwMroAKXCF6oU9Ne9XZ5wQft89Fe9dKRcxTGAqvD6HhOxPmzQBhOtaAx4plOmtobJWBld+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YiiWY6ql; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YiiWY6ql"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DFER962774024;
	Mon, 13 Jul 2026 16:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=UbHk0o
	LS8T+8YPRbqDue+fKpI70AtEJm0oKyyoetT8w=; b=YiiWY6qlLaFgmwAa6FeNv5
	beHkTyKGU2n8i8pV+rHsUX7SaqeMABxPYmthYR6MdDI1iX52uqAOgDdnvydz3VTR
	pnaOI1ESAxbQlw4b++CWLCFvk4j/7YHhQhfPDUfe5s3nhwJbSeaVQ/NekUnRSREP
	84jE4ds4MVLtgogSdbGGTaoiggRnOyMPZcLkPElLNBAOHgI2zpFyyexhjYmhpt8r
	B+PZMxF2oFPLBwVLgTNpPFoaAtB1oqPrsI1T6Mp5+ckOeU4WHmj12Vwo1nCUCawB
	LcNULVEpfouqoc2c1FFvW079QwPqD4rfDtH4c0EEQJ+kckJjvfndNFLXSjcQpfkA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fbf2a179r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 16:09:36 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66DG4aFV027590;
	Mon, 13 Jul 2026 16:09:35 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fc2uxx6qf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 16:09:35 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66DG9XPB61800882
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 16:09:33 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 86DFE20049;
	Mon, 13 Jul 2026 16:09:33 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 46FBB20040;
	Mon, 13 Jul 2026 16:09:33 +0000 (GMT)
Received: from [9.111.32.211] (unknown [9.111.32.211])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 13 Jul 2026 16:09:33 +0000 (GMT)
Message-ID: <8cff9612-e5f4-4621-843e-0582493119fe@linux.ibm.com>
Date: Mon, 13 Jul 2026 18:09:32 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: btrfs lockdep issue
From: Christian Borntraeger <borntraeger@linux.ibm.com>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
References: <5a9d9847-4ae6-43c4-afdc-6e5fa51d6117@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <5a9d9847-4ae6-43c4-afdc-6e5fa51d6117@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDE2MyBTYWx0ZWRfXz1bGlca2PrZ+
 FheEDEzHdObz7KkqWQnfYoyxbUUaqGdO1iHlUGyHqcCzrsnGGvhenjbhYbNtSLc5nSlw3BUVq0N
 jQvSoTNOMCulRTdcPHFJCbQ6sjDz5eg=
X-Proofpoint-GUID: gbow-90xrARTgZOJdJ6vSZq22OylZs3G
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDE2MyBTYWx0ZWRfX3SSIOj9e1nof
 Qsz4vj1Pgi2sI/cHVP4+sjo3+91yq/11x+m6RSNeOJJJf1THw/04z4/RwplFu+JL99FvIucPuc7
 iDXYm7n2CdaSaeIROxJJcdLK2jfLS8Ym1rUE/iNei5BgupxVjSPwMmbzZtG0qqsBRElWr94AaX8
 ruHIF9cOPccBfkiN0F9vP6mmV3LSHCazj1VlvYg9ZiZYDiNWha4ppdnuqN7dLktrYBYMiBYWt2F
 LQ2VkxT/rT3Hlp7hPC4L0ixfvozHra62RB0bzIu+mIP3gTpb2RCXnNfglh8AdaVTO2VkjW1TCkJ
 aWnBOyP9h82yK73WioldcL5njphdoO+lX0Drpsssi/S4jia4LR7kUSjq9uQRCuJpVoKstamy3uB
 TgXMXLQVZ2ucbQA10JHSsVkVANRQU0PmwMPU0VgBXg8ywGLlrTrnGpJZ8uweWwQWPQ2smtyVwIp
 eAOoBROspl8V3wAOYeg==
X-Proofpoint-ORIG-GUID: gbow-90xrARTgZOJdJ6vSZq22OylZs3G
X-Authority-Analysis: v=2.4 cv=PvajqQM3 c=1 sm=1 tr=0 ts=6a550dc0 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=pxOOfproQsSi8mq9Or4A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_04,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0
 clxscore=1011 lowpriorityscore=0 spamscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607130163

Am 13.07.26 um 14:07 schrieb Christian Borntraeger:
[...]

>   Possible unsafe locking scenario:
>         CPU0                    CPU1
>         ----                    ----
>    lock(&fs_devs->device_list_mutex);
>                                 lock(&fs_info->tree_log_mutex);
>                                 lock(&fs_devs->device_list_mutex);
>    rlock(&type->i_mutex_dir_key#2);
>   *** DEADLOCK ***
> 2 locks held by (udev-worker)/1653:
>   #0: 0000016c727051c8 (uuid_mutex){+.+.}-{3:3}, at: btrfs_control_ioctl+0x102/0x1e0
>   #1: 00000069238564d8 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: device_list_add.constprop.0+0x148/0xc60    

So some additional detauls
-------
            
this was a udev-triggered btrfs device scan (BTRFS_IOC_SCAN_DEV) of
/dev/dm-8. The scanned device belongs to the mounted btrfs root filesystem
(multipath, the path flapped between /dev/mapper/mpathg2 and /dev/dm-8),

---snip---
BTRFS info: devid 1 device path /dev/mapper/mpathg2 changed to /dev/dm-8 scanned by (udev-worker) (1653)
---snip---
            
Could this be due to  commit 2e8b6bc0ab41ce41e6dfcc204b6cc01d5abbc952
("btrfs: avoid unnecessary device path update for the same device")
?
