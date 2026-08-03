Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBE53ACEFE;
	Mon,  3 Aug 2026 09:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785748040; cv=none; b=OpjXqLC3dW1E9Qyimq5UH/lxApUzqfBHewncDyTWDaM6wQcRIuWrZI7JhP+IbYWpt4eJx+QCa70QbwY9rqWycamgpPxBom/ZKUoqd2SuGbGmvETzO5Gy3PatigdWbZ3M1qRmhHFQO83XKTlZ4sgMWO83eNMBgywYca5LrVlNh24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785748040; c=relaxed/simple;
	bh=lloAQZzEPOJ9Hp5APUskUtSz1NX3u8iOQkaJenygS8Q=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=taaKymAMoqy4OTxoqoN2ovzp0SH89lbq13HbR7cEwQYt8dTcFLn8q7qvMW79CA6NgtLVLQyCtDRHdu3Btld1C14/FA5RZxfippsIjX7biD1roWwtB9kzmPMfMZ2o+w6Yhp1+QJWwVXOzaoC8bORnSthqV9v83yLgvVY7IoKDn5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jF5x0FV0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jF5x0FV0"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672LmFGb168792;
	Mon, 3 Aug 2026 09:07:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=xusHSS
	kc3LwKj+Cvg+QKBfNf0euQiacnL8qX7jeWCG8=; b=jF5x0FV0r5pkNeCxwHFNv/
	FP1dwJOzKfByUFIV41ok3Z2cdEakaD8UQyxRu560Sh7/bDGJBn1NG4cZM1OyBPxU
	Dg0CWQso5H+/nODjb2SiMDbpfZwgaqN3TfZzQAgI68DF132OixPzXTDgdoB2rv/J
	M6BdOe3kEbSjdsqOWdOHGxDmMzifXbI92yqBr6XRKmAPTgJhOw1N/YAC1mGQ5iya
	7YKYLfy2cmTPudOhKSRbg45Y+gNejm1Na0K3ClTw6e0EV1f0VbD+W/bFsM4WkQsh
	eHesLxw7ogpBWhoUdXxZC9q8F4ZH+zXdZTwaPHVm4aaRYHhjny8aPzby7X7C2ndQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs77fyrgu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 09:07:14 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6738uK9i006286;
	Mon, 3 Aug 2026 09:07:14 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fsu4qct7h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 09:07:14 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67397Ci128115310
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Aug 2026 09:07:12 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 471C12004B;
	Mon,  3 Aug 2026 09:07:12 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28B2720040;
	Mon,  3 Aug 2026 09:07:12 +0000 (GMT)
Received: from [9.224.77.173] (unknown [9.224.77.173])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Aug 2026 09:07:12 +0000 (GMT)
Message-ID: <bb5e1ba4-5062-4a92-a9ee-1ca0a0dcc992@linux.ibm.com>
Date: Mon, 3 Aug 2026 11:07:11 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Lockdep circular dependency: btrfs_swap_activate() calls
 sysfs_notify()
From: Christian Borntraeger <borntraeger@linux.ibm.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <782c4d5c-d93b-42b3-b4ca-58deb3d8a894@linux.ibm.com>
 <11be35c2-7ede-4c83-b21f-39e52c3b04a2@gmx.com>
 <6a5c7341-6e88-4eaf-8311-0de81b3d1015@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <6a5c7341-6e88-4eaf-8311-0de81b3d1015@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDA3NyBTYWx0ZWRfX1R5W5BUM2rQn
 oASwArK0jSCIK5d0aGCYBVFHoExKcsk/Cw4jS5LCyhXZLQ5ocG7RYLJjYgPeGYno2aN2IY4DcR0
 NK9msKQY1uDkK3A2izKzeXXfu5Wce0Nfk7Ze2t37xej286nUec6K9eyvmcIRLsrXJaetIQw0iv2
 4gTY8tAOn7/n1ZyS5IPN9o7OAuejWEZ6OJr99JTSem2eSAGTda9cEJTwEANyFi0vzcme/maiYkM
 wDbPHPyvhspPGpzmEGZq7/MtgL9Nfi1291WlnF2Q4+QkaaxLf8Uorbjdgy/halYilpwJ3u1ncrE
 qwgDtACWfsLrh0ehwzflzHlkFM5c9vcBMDLbT+8gvNn4txgV+veoljOfAU4HAqawBpTR4XslbgA
 /LpTM+xIy9zMWir9tQ7qeQN0pVgSqgBoNF8pQgBwGqIs47S3pWgHTQsoEw6rRES+6O1dG24wfPS
 hlB6z1yCEnSaXBSRw1g==
X-Authority-Analysis: v=2.4 cv=WIFPmHsR c=1 sm=1 tr=0 ts=6a705a43 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=QQJeTcF6qchfQrgI5ZUA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ZrbWQOtSPzuRdBXR-l0k-XHnOv66y5cO
X-Proofpoint-ORIG-GUID: zcpar5YZdA9v1vJ8izQ6e0Y0_15ANhDp
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDA3NyBTYWx0ZWRfX3Rmg6rzBbn0f
 LnsCYdzqR/EBwxIk+UcavNqq4f8mlLIMCHYl1eO5hoxwzUmZ0O8PqXN+WV+CklTO8Jf8cw4Q8PT
 d72EhYeYXJtOWnH9wzZnMmWe0qKVbjM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 suspectscore=0 clxscore=1015 impostorscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030077



Am 31.07.26 um 13:14 schrieb Christian Borntraeger:
> 
> 
> Am 31.07.26 um 13:12 schrieb Qu Wenruo:
>>
>>
>> 在 2026/7/31 20:27, Christian Borntraeger 写道:
>>> One or more of the following files ( btrfs-swapon-kernfs-repro.sh ) violates IBM policy and all attachment(s) have been removed from the message.
> 
> Oh.
> 
> 
> Lets try this:
> #!/bin/bash
> # Reproducer for the lockdep circular dependency
> #
Can you reproduce the lockdep message?
