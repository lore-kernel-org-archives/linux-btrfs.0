Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28C43C1091;
	Wed, 22 Jul 2026 10:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784716844; cv=none; b=cnsfb5+cKXvgoe+EOtorQGHeucZyOeYCW9whZOzc6I35VfO5Na+7A4RAtOuDxGWRnWltPV99pGwbtlB0l3Lq9A95cVeGIktGHZRFaSsiO+P7o+qdNTXybqsd/lVnBRNNRgXg5M9S2DBExMPjeNKraGt/l35vQ1rqwzyKxqhFSmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784716844; c=relaxed/simple;
	bh=BNPEuqYRWTnIVb0q9FhLHXQn5A1SqtfKLzwmta56V7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aqzkUYrc7lcXAyLcAAvZ1clXKWhO1jsKLj0/YgIH7svK2Q1slSztj3LCIaab8FNmmVtFb9O4zDzFfz11Io33ClAdrprYWLfIruSPXvP7V0PoaG9iAZ4mDigYgqP9ma5BJ1C1axtERK4KpuVv723fPKiePEA7tryfX6emS1NwrcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tJOlpvBX; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tJOlpvBX"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M9Bu7u3566083;
	Wed, 22 Jul 2026 10:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=b93K53
	eKlZ1po0mSl+QcBTIqFf/Mkvs4qO36TMN2P0U=; b=tJOlpvBX6Gh7lX0uyxn6mI
	xJZ4BmoqC7UTKVxPStzhjeyD5jLH8u1vaINm/FBpZeUIhrh+8PYQUWYRiYnLHX3p
	zmia3/zoW5Gld6cotS+V4v14jwsCh9qfbH8Xe1UfNZBZEqxhU0uFK+U5hyy15LtE
	be5IhXm9P4zj9PgIQuZ6wMJ2qjhc3AsKyBZXf+cGlC5/SM54fjFCdGk8ys+4ojWA
	dh7k0eDqJPyjAQurueYBOICSqsmQ1lt6bhBAg609KZx6H9OK7KLE6Zm9TT/LJziB
	ILTufiQNSB606dwlTzSDPKQUE6T04S6Me8A+qWCpzqFGXKTibDzINDJyEETSEBMQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg78g96eu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 10:40:35 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MAYda6010528;
	Wed, 22 Jul 2026 10:40:34 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgnah6uhc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 10:40:34 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66MAeWo411338094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jul 2026 10:40:32 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 889DD20197;
	Wed, 22 Jul 2026 10:40:32 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F9E320196;
	Wed, 22 Jul 2026 10:40:32 +0000 (GMT)
Received: from [9.224.77.173] (unknown [9.224.77.173])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Jul 2026 10:40:32 +0000 (GMT)
Message-ID: <5e7579a8-73e6-49ac-b585-66198e35d87c@linux.ibm.com>
Date: Wed, 22 Jul 2026 12:40:31 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc()
 for folios dirtied behind btrfs' back
To: Qu Wenruo <wqu@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org,
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
 <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
 <8ef80fa7-6c93-40bc-8a49-bf6494104cb7@suse.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <8ef80fa7-6c93-40bc-8a49-bf6494104cb7@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDA5OCBTYWx0ZWRfX2IpQOJbu7RD8
 1L8FAWX/YlyI8vsjHfQ4Eu4lSVGEzY5BMh65hoezwlFAcbOMm+gj2EdOw0jtuMlPLLO7IvZNFS3
 da+u313ZjpcpXs7tunn8AF2HiqBUpMafJma3q/O3VX6Zs5aAUsFfFBbngOYkkSFzNqqmIkbcee7
 Tm5YDjpbBr1j+GsqF2fgpEnvlDOPGiZ2ns/C++gWBUXCkjxeSiVjRJTwhlCYU9C7HSTSY6fEqx6
 E42kMSN0NxvF5NbFvp3rPk850BLzvDWzx9sryvDrRN9qYHFPUncq9mhO72iZItCUVdtvDVBcvk2
 ir37MEoxDUedpmnKvKzb4O88+pKgvuk7FKjk/I9BjF5gzOE4J4AVsbZJehz9vTWLnNVKZHHzcv4
 oKIAloRjQ/rvmR/ADIEdC9twlnoZbXInxmpB34FJwJqTh80OtBpN8ztM6bI2A58NoJ9qGIM8JsV
 KDXyS3+pNHMT9FrYt4g==
X-Proofpoint-GUID: MWYbKPM6OzY5Hi5p60U97JvoKtpbcVGq
X-Authority-Analysis: v=2.4 cv=MelcfZ/f c=1 sm=1 tr=0 ts=6a609e23 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=2C_faDN_CL7dLDClzjwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDA5OCBTYWx0ZWRfX0/m4z3eZgsPJ
 gr26WhTXLNYuPDIM7jV+CIeOsBD8Rhv4AvCeR5830Z55VwtONSNnFaLnuANZ36CaFNPxU3zBfOT
 4vGEbqO5pJliRLeI/4gC7zQW57N4ff8=
X-Proofpoint-ORIG-GUID: mHPPX-rK_oh6efqEg3xxK0IkCcUAUaxr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 clxscore=1015 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220098

Am 22.07.26 um 11:35 schrieb Qu Wenruo:
> 
> 
> 在 2026/7/22 18:59, Christian Borntraeger 写道:
>> Am 22.07.26 um 10:59 schrieb Qu Wenruo:
>>>
>>>
>>> 在 2026/7/22 18:05, Christian Borntraeger 写道:
>>>> Am 21.07.26 um 23:07 schrieb Qu Wenruo:
>>>>
>>>> First, thank you for taking the time to look into this and trying to understand
>>>> things and trying to explain things. this is highly appreciated.
>>>> I am still trying to fully understand this myself. A question:
>>>>
>>>>> 在 2026/7/22 04:41, Christian Borntraeger 写道:
>>>>>> A folio can carry the folio-level dirty flag while its btrfs subpage
>>>>>> dirty bitmap is empty: btrfs data mappings use filemap_dirty_folio(),
>>>>>> so a generic folio_mark_dirty() call sets only the folio flag and the
>>>>>> xarray tag, without setting any subpage dirty bit and without a
>>>>>> delalloc reservation.  The typical source is set_page_dirty_lock() on
>>>>>> a GUP pin,
>>>>>
>>>>> Shouldn't such folio got its ->page_mkwrite() callback get called first?
>>>>
>>>> Isnt that called implicitely at pin time?
>>>
>>> I have to admit, I'm not an expert on the MM part, I'm mostly a simple user of the existing MM interfaces.
>>>
>>> AFAIK, the last time I brought this thing up, Christoph mentioned that dirtying-folio-without-notifying-fs is a bug, and fs should not and is not able to handle such situation anyway.
>>>
>>> And that idea makes a lot of sense to me.
>>>
>>> So adding MM list for more help.
>> So I now have an userspace O_DIRECT reproducer outside of KVM. (attached) which gave me (on an s390 system, though)
> 
> Thanks a lot, I can also reproduce it on arm64 (64K page size).
> 
> This is super bad, as we have just removed a lot of folio ordered related code to detect such problem.
> 
> I'll also check if it's some recent btrfs changes making it worse.


The RFC patch from yesterday seems to fix _THIS_ problem, but as you outlined, there might be other issues that break and are not handled by my patch.
