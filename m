Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330BF61FFE;
	Wed, 22 Apr 2026 05:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776836323; cv=none; b=qdpO5FWfhCZXE+b0xP2yLjeiegnuNKBVBMFXqAuq0A/w33pi9kdynfTTOhBZlIsbeOsdWnwFGyazYFVsJ6YxASDv+gOq0NhukY5q9pwPYn98L9pChdn9/EqF4MGMx1u3rWMfEcj4O2t7GOGx3N6Ns0WqTBBxPbYm5vrNZvl15Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776836323; c=relaxed/simple;
	bh=SSbTn8nI/sVgR0OSaemvvrlN3XOjDrcQcY0pwBkht7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UoOcT0gEjcVMFRwGA+kyBHrtA3xuZJtOjTdC7NTKX2Yn60Pw9D8FWLy07Jwg1raJSwHAgJ1d56vKX4cLh8mzmUKOrdiOZOp8b7Y4uhjoUyTWlUNAKS4IbCiWDMPC05v2QDlE8mzcVBEANUe8INsj4B6rDsQ4azpt4EUG2qejbbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eQaqdnX+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eQaqdnX+"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LImLpl590806;
	Wed, 22 Apr 2026 05:38:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=d1yIWL
	xnHFD5U/7t3Z9R2B7Z9KsW8UDapcVpFrHpzKE=; b=eQaqdnX+MQBW3JoHZBuNCr
	fID92FGQcZs74fBk4MuTVdaOuThVYq/cPz8931g2oKMS0Pw/8mLgpq7KmVVRsGJw
	rjC2ElC7ALWO6s5eRFG6XyVkfQQjSQYS/npFJB5wzg/4bpvcoMbCwSBiCy3J755V
	n31cYxplpnyoZar5hl7ezHWOP/2yErcd5IA1DnRrIn48sp21UtdvUh8La+sbQDZH
	5+2z+fMgnL1qx6vMRzJJnPeBoACJiocyGE5BHrLN4Fc3PoVUQUuJ+X1CAMaziSvq
	xgQsT1jC6nGdQed1JFafgqQqebO0rRyvKiRyeNoiTBGOt9A3eSFiRvaKaPpLEN+w
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu21v5g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Apr 2026 05:38:39 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63M5ZMQ5011638;
	Wed, 22 Apr 2026 05:38:38 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dpjkxrxg2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Apr 2026 05:38:38 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63M5caps59638136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Apr 2026 05:38:36 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B9BBC20043;
	Wed, 22 Apr 2026 05:38:36 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C78A20040;
	Wed, 22 Apr 2026 05:38:35 +0000 (GMT)
Received: from [9.123.4.214] (unknown [9.123.4.214])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Apr 2026 05:38:35 +0000 (GMT)
Message-ID: <1e1e374a-d9ef-4e0f-843d-09f292cddc57@linux.ibm.com>
Date: Wed, 22 Apr 2026 11:08:34 +0530
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] common/dmlogwrites: add _require_logwrites_size
 helper
Content-Language: en-GB
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        djwong@kernel.org, fdmanana@kernel.org, quwenruo.btrfs@gmx.com,
        zlang@kernel.org
References: <20260414102031.74527-1-disgoel@linux.ibm.com>
From: Disha Goel <disgoel@linux.ibm.com>
In-Reply-To: <20260414102031.74527-1-disgoel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: vrjVkgJlTJB8ySTK6p81ZAgwom7LDSM2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIyMDA1MSBTYWx0ZWRfXw3DNMK6qQ4FP
 2991lUcb7biLKU949UuV0FMVVNslR6wCH1Vf8g+sJXpCOGcdtU/VtrFfWo+kD4SXA6oIwGZq3F3
 M+JpmyBBHcLUgzCm8jRRbaffwiyisBomgUOcz3o+CnKZ4P/KbYEx+0XZcE1HQYkPOQka1vfSBt1
 0tf4x0P9/oh8axERgNEKlBW3K51af+SoRvWFy5mefxW1Y8AFdNXRXs1g62WfHEYQpiTH3JaK2uS
 v5rj0t3z/o4A65QJZKZJHk0jIsPiI4wqZkfxIEq1P4ZoyH7ZBh+RTp5vfwE4E5s0kXj6+TijTD8
 3+eWFE2VpDc5XF6M8zCSwqAJR7ytb730p5Hz9Bs706UynViTXlqtaMzqxU1Pn9Fn/JcKruSwRxr
 I1OD6nt2gseKvlzfuYUSlYhKCjH1fU1H+PQYBJ1pz2ln7dq/ypvVG81uXTM6O74E1TaoIEEcDYu
 31sgg5/p2B1o7IrK6rQ==
X-Authority-Analysis: v=2.4 cv=C8LZDwP+ c=1 sm=1 tr=0 ts=69e85edf cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=-RhjpE4fvuK0Md3SiowA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: FITPu3K_4MTP37hwkimf5BwZrSsM_IuJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604220051

Hi,

Looking for review comments on this patch series.

On 14/04/26 3:50 pm, Disha Goel wrote:
> Add a new helper function _require_logwrites_size() to check if the
> LOGWRITES_DEV meets a minimum size requirement.
> 
> This is useful for tests that use dm-log-writes with additional space
> requirements, such as creating LVM snapshots during log replay or tests
> that generate large amounts of logged I/O operations.
> 
> The function takes a size parameter in KB and skips the test if
> LOGWRITES_DEV is smaller than the required size.
> 
> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
> ---
>   common/dmlogwrites | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/common/dmlogwrites b/common/dmlogwrites
> index a27e1966..1ce2b2fb 100644
> --- a/common/dmlogwrites
> +++ b/common/dmlogwrites
> @@ -14,6 +14,15 @@ _require_log_writes()
>   	_require_test_program "log-writes/replay-log"
>   }
>   
> +_require_logwrites_size()
> +{
> +        [ $# -eq 1 ] || _fail "_require_logwrites_size: expected size param"
> +
> +        local devsize=$(_get_device_size $LOGWRITES_DEV)
> +        [ $devsize -lt $1 ] && \
> +                _notrun "LOGWRITES_DEV too small, ${devsize}KB < $1KB"
> +}
> +
>   # Starting from v4.15-rc1, DAX support was added to dm-log-writes, but note
>   # that it doesn't track the data that we write via the mmap(), so we can't do
>   # any data integrity checking. We can only verify that the metadata writes for

-- 
Regards,
Disha

