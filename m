Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C0B3C5833;
	Fri, 14 Aug 2026 15:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786720754; cv=none; b=FI0ioaPKJUUADYx0V/yPm26e0gPzN8DDkSnWoZzUCnRlg9ndy/KkMUTx3H1MFeesBI5ef3uehblsRqy2wpVVrw+mlRH0EbcR11pnXaPJXthZQsIDtnNn7SPDzIgh3N9MVmPDuE2N03Gdb4LnYHGftSPTVQx+0yjWmnNshWO2Mk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786720754; c=relaxed/simple;
	bh=qu3TN8PARvQwbNE7zw5aXxH50NXsnT8muCVR8ElOsWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UEsqpO79D2gLm3fireKLzRnltMTLpDrkZ728LH8wQVR44mDS/oYePzztzmkifnycQ6VBP3nuqOLGfgICSDugfHZMciiSwCHfVg8tV1Xo3ugKiuIAAbQLnuWciZkPi1bZpRCeug4UtxNbe+bWYINf8o8mVu2tsno3lbWe4VdyhS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DlyDR/hO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DlyDR/hO"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EE5l0M230400;
	Fri, 14 Aug 2026 15:19:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=n3J942
	P/eq0B1uSt3EEMGOQ1xzenCKdLSHay2td+42M=; b=DlyDR/hOdiG3LfJZoBHndQ
	rZgD8YzoYC32r+l6WnkYISdzkZNzqoemo4bFR458ilcir5Z569Y1oqHDmRPE9KPS
	2Es1fwozUDAUk5ZpeKTY0TsRzCxqE3lR4LWLFWt65m9GRT6JDd5LQNC0DriFGt+2
	s1iV4IeNGQBQdS2yJKX2h9Ky1sTPXbsiB9HMi2NQGs3qOSzsOBCLopb22/Dmm9vK
	RE/tyXnCrmkOd60lGYvw997GptiddZ4Lyfh5rPqnC8bpSLgd02imuj/tcnqlU2BJ
	BbOU0U3sVJHBRunAi/tSN4JmWLrpqtiwvTr06TKfZGkxLjly9Ho4KGeh2lkURE8A
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fyb245ke1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 15:19:09 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67EFBWKZ021450;
	Fri, 14 Aug 2026 15:19:08 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fxg9hfqu1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 15:19:08 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67EFJ6gB47382988
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 15:19:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 91EA920043;
	Fri, 14 Aug 2026 15:19:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2AA8D20040;
	Fri, 14 Aug 2026 15:19:06 +0000 (GMT)
Received: from [9.224.77.173] (unknown [9.224.77.173])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 15:19:06 +0000 (GMT)
Message-ID: <95bcecaa-a5e3-48b0-a7d5-db6569370389@linux.ibm.com>
Date: Fri, 14 Aug 2026 17:19:05 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] s390x/css: Fix css stsch detection to go beyond 8192
 devices
To: linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20260814151759.1831153-1-borntraeger@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20260814151759.1831153-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=XqfK/1F9 c=1 sm=1 tr=0 ts=6a7f31ed cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=icbd4pwFJuYQJSJ-mEUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDExNCBTYWx0ZWRfX/sYM2M42pjyn
 /kA5Tq1JMASn8wOG+Mqlk/dEso/0U/GgqSlpzaItzhLdgq56AIknWYUEg7EbXrayJlytrp0W0Cm
 jN/BNF9tKBtEboTldJ2IfXU5/xI65Gtkch38xGRww2rShCI49CkRFMVCv7aUqyemlMTEIdVF5NP
 P98zNxASqwvq0pBd1X5dJ+6rWXGMf7cmgJjKdhFATpAFiGIe5g82+I+BENgLFAhcproutLBgvbn
 9HFx+X2RmxxUQzong9HrduV1ZfkT0w5Z53f2uV5ls3ut+duwhS0WUSFy96tyGKueLfffov9yzuW
 S2oKQB5CpcW3aCVAJwyWbP5JYY+oNJR7TDQUI6sNPZ5/RC5qMJpSdMZRvgl3wPa1JJWkdMb+ZNi
 tLFk7ehZEIUWUDnW4kDMG6XbUsj5QxmQuW6PCRrmUClkggOOjLT/9neoL1moB8VxqrZbhrGlBPT
 SbMxiwkyIt81d68Z8aQ==
X-Proofpoint-ORIG-GUID: -dTYWqZdcDC-KqsZkz-jYZ9lvb81qo5G
X-Proofpoint-GUID: -dTYWqZdcDC-KqsZkz-jYZ9lvb81qo5G
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDExNCBTYWx0ZWRfX65ZeR1fa8aNp
 ijxcPX+4OxUxclJyz6OuxSXGqVEjSwwqQaKXTecrPPjgx3T3do6gybtabBuLnnw29oYVSCxUs0Z
 G9AmsGXxRaeTr+XYlYrYJriygeWmBe8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608140114

Sorry for the noise, please ignore.

Am 14.08.26 um 17:17 schrieb Christian Borntraeger:
> find_last_bit expects a size in bits and not in words. the calculation
> limits the number of guest devices to 8192.  This probably does not
> matter in reality, its wrong anyway.
> 
> Fixes: df1fe5bb49241 ("s390: Virtual channel subsystem support")
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> ---
>   hw/s390x/css.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/hw/s390x/css.c b/hw/s390x/css.c
> index 3a67b670531..dedd39006bf 100644
> --- a/hw/s390x/css.c
> +++ b/hw/s390x/css.c
> @@ -2023,8 +2023,7 @@ bool css_schid_final(int m, uint8_t cssid, uint8_t ssid, uint16_t schid)
>           return true;
>       }
>       set = channel_subsys.css[real_cssid]->sch_set[ssid];
> -    return schid > find_last_bit(set->schids_used,
> -                                 (MAX_SCHID + 1) / sizeof(unsigned long));
> +    return schid > find_last_bit(set->schids_used,(MAX_SCHID + 1));
>   }
>   
>   unsigned int css_find_free_chpid(uint8_t cssid)

