Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B9C15B998;
	Mon, 27 Apr 2026 12:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777293098; cv=none; b=SyYEfZ5QcG6HkcLJqHMpjmUwHzngcHTY3ZvA0unU6Aa/FRaJE+9gL9mAu+6m0yzT7b2hmhe1Vb3bIwPHJhw8NWM1hzD9RvSLILNTbBlvqGBoZdjEaJk7lVwhCpRQABneQchggy2MforKWkdMq+/IENxRb+WZ7/rDcNc3P7cjiY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777293098; c=relaxed/simple;
	bh=uQyoyWja5kKmY0vh3HAK0S56vI4EXv5Q6X8VH2w79V0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QaxXk7DcnbgsF9QDkuBSaUfoBuJJTJiz0Pr9k0ikLDXNlLuY9khUPB9o7h53KjFSN+c6Q2XrdynFpK6pcYMVux+JLyVsQOf+khNDZ4UYBeu6TzsgZM1tRmaPHOO3Gw4aGBen+VNE9Swpb5cWKlmg3Yj6mYauk/4V4NYRt1BRCcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dRVpvO54; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dRVpvO54"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63QKfi2p2926120;
	Mon, 27 Apr 2026 12:31:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=LGAsjT
	pLdwvhcarhlD6NanmvWzHzwx9ExU1Y3/SKCxI=; b=dRVpvO54Kih6ZRNaPoCjrj
	PKXQhU/DwI3daieD0EhcASSflzYqxPmXeuH1TvGLOUq0ex32VVZhf7zcBnBUT22Q
	meCgmqxWVcpfKmYlKPDD/MJC8S/MstCriYSyMWeZeXvYVbF1Z2YADh8Jkau75fb4
	7tjSlWCxxFJnnEu41OY2JI8UR7LEO1B7dLIe/AfZRfsLMSOf0AZxD/6NkbEm7sOt
	Pu51EUVSB7HggWB7ofJPix3MMG/kOfbMbQRGElri4JQLXFntZ5xYeagKgOVB5ylB
	ye5PlBJ/x3XHpQIKdQ7qOQbMF46t7x1meRD76uLgv18KTcOzCFlRn4Sn0X/c585g
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4drn44gcyd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Apr 2026 12:31:32 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63RCNpVD029158;
	Mon, 27 Apr 2026 12:31:31 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dsamy4w03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Apr 2026 12:31:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63RCVTqh31326508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Apr 2026 12:31:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3963020043;
	Mon, 27 Apr 2026 12:31:29 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B69BA2004B;
	Mon, 27 Apr 2026 12:31:26 +0000 (GMT)
Received: from [9.39.16.1] (unknown [9.39.16.1])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Apr 2026 12:31:26 +0000 (GMT)
Message-ID: <a31fd97b-28cf-4412-97c0-7cf65d93ac32@linux.ibm.com>
Date: Mon, 27 Apr 2026 18:01:25 +0530
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
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        ritesh.list@gmail.com, ojaswin@linux.ibm.com, fdmanana@kernel.org,
        quwenruo.btrfs@gmx.com, zlang@kernel.org
References: <20260414102031.74527-1-disgoel@linux.ibm.com>
 <1e1e374a-d9ef-4e0f-843d-09f292cddc57@linux.ibm.com>
 <20260422155528.GE7739@frogsfrogsfrogs>
From: Disha Goel <disgoel@linux.ibm.com>
In-Reply-To: <20260422155528.GE7739@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: iWj1qRX6UtZFAHVzFF0lT4NOB2lIglfk
X-Authority-Analysis: v=2.4 cv=Ft81OWrq c=1 sm=1 tr=0 ts=69ef5724 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=q9VUZGwjv43ZNQfoq8sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: AsXcog5k9iDP0C9BFTROB9YjW7UqvmN3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDEzMSBTYWx0ZWRfX0df1h0h8Jrfy
 8KVBk4lgYgfswjHqFhiYI3PxMxAkySVYLnpTjxx5NCFSmt1EB0MxQI/M17bZ3Ch9dtKhj5sZb50
 i4zfkZVQCuSTelAdbm8gf7AZAtwrBBUZiMVPiG0/Bf3dASZ3Pasg2MZQC7lj6tnDTRPVrucoSv/
 lz7IFGtghtEAhvBL7L3dZd+aeiPR+5sSyyzfRcjF+hyBpfrj+ZGT538G4gy4mqLzJY9FvuFdUd9
 LcRONilFWrDzBXatIM5nFp1uwg7bzq+GVLhUWYwXSX8HYpLbZGj+bkYsBHUnOQEt3OAdo9WdRi1
 1bwb/mrLCmpWP3poSfQDqax42BXZ0U5blavGPMMnGMm4HYcI93eiuzwcOxYMk7Xe/JkQ/ng1SPh
 07Mf874pSKFuVJsY8BfI0K6P6ahZE8YcQK99tQs7Zqqkxwg9UEkGYtrgPAkl50vhTT4H81v+kep
 eW9zcgg+/zZ5FZCKpfQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604270131

On 22/04/26 9:25 pm, Darrick J. Wong wrote:
> On Wed, Apr 22, 2026 at 11:08:34AM +0530, Disha Goel wrote:
>> Hi,
>>
>> Looking for review comments on this patch series.
>>
>> On 14/04/26 3:50 pm, Disha Goel wrote:
>>> Add a new helper function _require_logwrites_size() to check if the
>>> LOGWRITES_DEV meets a minimum size requirement.
>>>
>>> This is useful for tests that use dm-log-writes with additional space
>>> requirements, such as creating LVM snapshots during log replay or tests
>>> that generate large amounts of logged I/O operations.
>>>
>>> The function takes a size parameter in KB and skips the test if
>>> LOGWRITES_DEV is smaller than the required size.
>>>
>>> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
>>> ---
>>>    common/dmlogwrites | 9 +++++++++
>>>    1 file changed, 9 insertions(+)
>>>
>>> diff --git a/common/dmlogwrites b/common/dmlogwrites
>>> index a27e1966..1ce2b2fb 100644
>>> --- a/common/dmlogwrites
>>> +++ b/common/dmlogwrites
>>> @@ -14,6 +14,15 @@ _require_log_writes()
>>>    	_require_test_program "log-writes/replay-log"
>>>    }
>>> +_require_logwrites_size()
>>> +{
>>> +        [ $# -eq 1 ] || _fail "_require_logwrites_size: expected size param"
> 
> What are the units of the size parameter?  Bytes?  512b sectors?
> 
> The helper should have a comment clarifying that.
> 
> --D
> 
Thanks for the review. I've addressed this in v2 by adding a comment 
block documenting that the parameter is in KB.

v2 has been sent: 
https://lore.kernel.org/fstests/20260427122551.71696-1-disgoel@linux.ibm.com/T/#t

>>> +
>>> +        local devsize=$(_get_device_size $LOGWRITES_DEV)
>>> +        [ $devsize -lt $1 ] && \
>>> +                _notrun "LOGWRITES_DEV too small, ${devsize}KB < $1KB"
>>> +}
>>> +
>>>    # Starting from v4.15-rc1, DAX support was added to dm-log-writes, but note
>>>    # that it doesn't track the data that we write via the mmap(), so we can't do
>>>    # any data integrity checking. We can only verify that the metadata writes for
>>
>> -- 
>> Regards,
>> Disha
>>
>>

-- 
Regards,
Disha

