Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC44471439
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 11:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784807124; cv=none; b=id16WPXGbdIIdsNG+ApugWvu2yLvh7U+pcyy2N7r0iB3ga4w8dq0DxWnwDuGi/nbO2XKUetcj2Q2FEKPOC7wYwd9drhQ4txeTXl7Uqamel5z8ZYwWaGisCdYyKobc5jLKEy4yNKAM1glNO9AqbYdl1CHHcq2ns3hYc1YI+Q5R4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784807124; c=relaxed/simple;
	bh=2kwOhcBZKWPaAMH60AHfcYu2QaOSbX22GsY8lUtlOug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQaQqqpF0fPadMAYhFWwyMSqa2NfRoerVOdgMZj+u3FXpiWcTv17tcHyCNqKaxLjwiotQDSmIOSbbnjbHXONY3+Y/q7tc9dQuUf6oL0mNx26pOXeHWAclphvLjGn/D25Ch3WCJHw0mbjkrODbG6eh0/pGH2R1qBwMaXqeE3g78g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QqUCcBLp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QqUCcBLp"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N9BoxV2585853;
	Thu, 23 Jul 2026 11:45:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ve56yA
	AY6xLykonIN4rdwEfZjT5YYVFdE2k6h0iIUbs=; b=QqUCcBLpnVSCCpRRAbHE2j
	cwSjO5/3io/Mw4ddLRY8VygA9CcDV7Eoyc2Nno5aH0u50T5yttzHMrer77FZNd3w
	Uhy6lmAZ+CYIXnLHvyplt2KPzxsDFTEbwyZEmiXT60/fBezo9E64rvUfZmdrQdyo
	cGcsRL3U1G8uBPlKkMy14XUGra762NJG+QQ7zQFsmVWR5dmq/XfD+GdcXn643O8Z
	HRbvGEJ0cWsUyB9LHh00j0v2GL6jm9KeQVZxe2Poh7kfN3IEGNqstP3NhXcZBkp4
	3RSGJA5sasFJ5TfxgJGEY22bMFTDggdZEDCjgbgRRAM7ZPIt6i9iavG6iOGjXp/A
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7ahenqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 11:45:18 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66NBYcTP007057;
	Thu, 23 Jul 2026 11:45:18 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgm6wc1hf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 11:45:18 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66NBjGnQ51315116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 11:45:16 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E0A620043;
	Thu, 23 Jul 2026 11:45:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CCA1F2004B;
	Thu, 23 Jul 2026 11:45:15 +0000 (GMT)
Received: from [9.224.77.173] (unknown [9.224.77.173])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 11:45:15 +0000 (GMT)
Message-ID: <be2eff36-fbff-4451-9a63-84f95968370c@linux.ibm.com>
Date: Thu, 23 Jul 2026 13:45:15 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] btrfs: disable direct reads to avoid dirty folios
 without fs knowing
To: Filipe Manana <fdmanana@kernel.org>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <c6dfdac9fc51c94183e51a861eec269185239660.1784787211.git.wqu@suse.com>
 <CAL3q7H55GkjjCougzD3w2qarX0x6XoQu5G680xv3iuqTMgQ0YA@mail.gmail.com>
 <f4f41f37-304f-41e7-af53-d7037e54cde9@gmx.com>
 <CAL3q7H4yxeAXzh+hHBsiD0ovotWpcoaK2byvS_5qz2cJybhNoQ@mail.gmail.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <CAL3q7H4yxeAXzh+hHBsiD0ovotWpcoaK2byvS_5qz2cJybhNoQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: SwqJg7K7BAgFsQgnvBN2x20-wnaTRnmW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDExNSBTYWx0ZWRfX4CEs1dasAnoY
 qMhSZOnFhafMi50xJgiccCA8DcZQlKxPg+sPBCuiC4fdxrYT/vsWKIAR3Dw3jNUaNXu7rGUAtlu
 u6m2wRM4WdW5bKmBwcPzX0cesSbkf09USYn/UUWOhPalc98QDC0nT3N8Sx50O7aUDZBfsBpkpmA
 Dk29hPrZ/VtqmKrrrQ8Evhr6SpYNd1pPj6xkQxRZgQzGJiD0KdkYZ944Z0cCfQbBzu8vKsanVWQ
 cSeOYFAx1VnLhOR8+TqVuRkY46sxq6LeOdvxCzOaFx9nUAKcb/k+qsJSn018sgz+20u3j1hBFOy
 ibWMuJJn9/ge+bqElFYlkicM45LXQ9tOrpiHMpVNVwRrPH42nSn6+k0MvxiiTt2PAu17ZjLIRYG
 YY03ruP5YuYZP7+g+S/6wBkOBECHtDOqwcAY6t0OWbJS/SRhhoUuYFuQYiHdW9WvRkwCR8vImVQ
 sMY23l0la8Q45KNMt2Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDExNSBTYWx0ZWRfX1h7dV/o0UjG0
 SNlV+lqFSnSQNu1980VjcVCnZ+RPHb1tTinYgwyx9JwLa7wNYe2VLyn2CTXfqxcEHITpWq1QqIt
 rDpXbfxcH53yi7pjb7+WOqB/JLTwzpU=
X-Proofpoint-GUID: ozrzs0igYP0fPiGsRXRlbg6qWwTLmnQB
X-Authority-Analysis: v=2.4 cv=SM5ykuvH c=1 sm=1 tr=0 ts=6a61fecf cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=7YfXLusrAAAA:8 a=iox4zFpeAAAA:8 a=0ESMOZCiN0YSb6BcWVMA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=SLz71HocmBbuEhFRYD3r:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230115


Am 23.07.26 um 13:23 schrieb Filipe Manana:
> On Thu, Jul 23, 2026 at 12:17 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>>
>> 在 2026/7/23 20:08, Filipe Manana 写道:
>>> On Thu, Jul 23, 2026 at 7:16 AM Qu Wenruo <wqu@suse.com> wrote:
>>>>
>>>> There is a bug report that a reproducer which doing the following
>>>> workloads in two threads:
>>>>
>>>> - Direct read into memory mapped from page cache
>>>> - Sync the above range
>>>>
>>>> This can lead to dirty folios without fs knowing, this can be a huge
>>>
>>> Can you please explain where, and why, the folio is dirtied?
>>
>>
>> btrfs_check_read_bio()
>> |- __iomap_dio_bio_end_io() from btrfs_bio_end_io()
>>      |- bio_check_pages_dirty()
>>         |- bio_dirty_fn()
>>            |- bio_release_pages(bio, true)
>>               |- __bio_release_pages(bio, mark_dirty == true)
>>                  |- folio_mark_dirty()
>>
>> At least this is the one from the reproducer.
> 
> That should be part of the change log, it's not obvious at all.
> I also wonder why a direct IO read dirties the folio if it's not
> supposed to change file data.
> 
>>
See also the initial discussion here
https://lore.kernel.org/linux-s390/79b9b1b2-0455-4a7c-85fd-929f4103f198@gmx.com/T/#m31c388aa6bbfb77c689ff95b5a35c4db5fc231c3

In essence any gup+set_page_dirty_lock user can trigger inconsistencies. We found that
as this resulted in lockups and the O_DIRECT use case was just a reproducer that does
not need a kernel module.
