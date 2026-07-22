Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B6F3CB2FA;
	Wed, 22 Jul 2026 08:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784709335; cv=none; b=HCftFYgZolPcDSbwbhQfvnhWcEtPbJ7Yc3g/qLOdGHSn9m1aLy3bZKwEwS3/KaoyleaCxAAf5R9QTDS9L8bcRnIcRyTS7Fo9l59BGEbFJpaa7NDw1O20gH3nGGk1bKZWWeqj5PIjIh4shTECo4TMG9giDo0J+67jQ72JzLmyATw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784709335; c=relaxed/simple;
	bh=fyiZ7dewrgguMVLV2Dy6hVGCjw4hxoNo92BrZ65/ET0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UD+l37iX1sGAKJanKdmE2aRSZWSVby8cNnPYiPaMDIPSl1KSlhq2629nps1R2Qi8Cn3GRROrYCd8sYzm+qeo83SsQUpFYrvTEU9qVkw3is+vMhpH7VeELE5Bquwr2MfhhymxK7oBvszCgFvDHMoJAzsEpi9KkFg7PC9hmCj+kAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OAuY0ELm; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OAuY0ELm"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M5BiGR3156846;
	Wed, 22 Jul 2026 08:35:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=rv1SGN
	C2gyflEP8G7nbM0uchSYfvL3xosKpihjoUKag=; b=OAuY0ELmX0Qm4/KW0wgbut
	J1wqu0NmUscUPGHPOiB1iRh4MMTA2EJogj9eK1i2k3PS/OFJbAG6Pco978llRsKD
	JVesu5j5tRdXBHSx17vUuKEVhJ9cr9cWOK0vpmKGL3c5xFkBgG5dZdjmlQkh8XkU
	Ap0BLmNLtZnVfTvLbiF0basXsBJIeXc35SX+6mVASwy1GWWMKEJccYgXsXtz6Kb0
	gnuh+2e11KQLUrf3VyWQZ2vYttXCygXbHWqFLfzvMzyyBASRhSN37DLGzSyD8ATJ
	X2xQJ41ieefXCbTelivo2W3rvev2WWg3BRKkns/zDqEhD3ScgK3gqmll67hlDyAA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg79114np-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 08:35:29 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66M8Yhsw027119;
	Wed, 22 Jul 2026 08:35:28 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgmtjxett-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 08:35:28 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66M8ZQ7b49545692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jul 2026 08:35:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F0E62004B;
	Wed, 22 Jul 2026 08:35:26 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1935920040;
	Wed, 22 Jul 2026 08:35:26 +0000 (GMT)
Received: from [9.224.77.173] (unknown [9.224.77.173])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Jul 2026 08:35:25 +0000 (GMT)
Message-ID: <83290932-cb8b-4741-bff0-6a7d8df2c637@linux.ibm.com>
Date: Wed, 22 Jul 2026 10:35:25 +0200
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
        Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
 <20260721191152.101118-2-borntraeger@linux.ibm.com>
 <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: _mzbYkPGzxBvwZIsNGHvhmFwqjqYiEVA
X-Authority-Analysis: v=2.4 cv=V6RNF+ni c=1 sm=1 tr=0 ts=6a6080d2 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=lEjgxdKC6ZHkbqwYjkIA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDA3NiBTYWx0ZWRfXyGLPGDP2vbEj
 xMfWmDcg0apWLLCqd2cKsB/9I7bHctn0osX38LoGmsk8i3zhVp+fQThg0mu+mi1JuFitXkJ+ELd
 u6avby2E6Y/dRH4bMJCwxZ8PuXgdnks=
X-Proofpoint-GUID: xJaR1kY_-9f5HcRkVD3uL3fjtbNscKvv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDA3NiBTYWx0ZWRfX4n4DDF+G5WJ6
 Y6wRBS0BREuAManMEekI/fbKLEnkBaTl9fwtCQM3S0gI7fGOdDpmve/8AaX/TjJAdtjSEyRTESk
 LKfm/+FrH4RRJdDgRUAfbqnXKuSs9cava7MvMw8Ik8D6Sju69cuyyHeLGr/sTxEm28lLDrySt9r
 jllt6m5tfpbFtGjVDv9hc+KrbqAqQhR0ZKPCIGah+tIb7aOqkpOt/oMj15t6X1wiIzBpC4s9yeE
 qACK3PNE1I7ymm1jZoOF5J6yRKCbqSZRzq9H6ZsBoN/i7O5HOky1BDMeBxi3xcdRdg5Pl2VY1W4
 g3URAxscIu32FstgqtcFu067m5GA44GYNUOxztGwf6k8C4XqQEf0mzY7XdbUYW7ALEkKHh8VCXV
 rp/M/uO1WaOy4ovq15BTh0YEHHhUBypq08nFyenAfjsZ3Xsitwwt4k81u5ppEorwRZNVJ0EdtNr
 M/lqrGY1wws5tF6sPJw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_02,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220076

Am 21.07.26 um 23:07 schrieb Qu Wenruo:

First, thank you for taking the time to look into this and trying to understand
things and trying to explain things. this is highly appreciated.
I am still trying to fully understand this myself. A question:

> 在 2026/7/22 04:41, Christian Borntraeger 写道:
>> A folio can carry the folio-level dirty flag while its btrfs subpage
>> dirty bitmap is empty: btrfs data mappings use filemap_dirty_folio(),
>> so a generic folio_mark_dirty() call sets only the folio flag and the
>> xarray tag, without setting any subpage dirty bit and without a
>> delalloc reservation.  The typical source is set_page_dirty_lock() on
>> a GUP pin,
> 
> Shouldn't such folio got its ->page_mkwrite() callback get called first?

Isnt that called implicitely at pin time?
At unpin, set_page_dirty_lock() re-dirties the now-clean folio.
 From what I can see, this is not an s390 invention but a sanctioned pattern.

But I can certainly not exclude that this is still an s390 specific problem.
Let me dig a bit deeper.

Thanks again for your quick response.

Christian
