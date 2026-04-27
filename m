Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B363148AE;
	Mon, 27 Apr 2026 12:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777293247; cv=none; b=J4npSI2/VipwZR2o7j4MUbu0e/IXHYCwdCYcu3fzh9rOvRAxyaf16Awb/KIFrLlbCyGxMADJjA+9cJRAcxaMP2/nuqA6ld3hhhi1/lVI+bmrh/Lzjx7D7qDQ0MXRLmVvHXPRmGLXB3v6pyAo9Psaz1ovRFoManQhD+aU6q2XLFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777293247; c=relaxed/simple;
	bh=+iJt1yJ8O0CjI/eCKxQGn6UFOM7L3adKPtiQ+6O3YNY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rRYsPDJQl2E1gJ5rrv3evk9cW91nBzGI/doxUzJy/BWDwjZch1LxKE8QrdvX5K346HdgXX4fo/3ySyw8hPcxg43fzJDGlWnxv49liEQA1ZP3oTU0qIuPkIoFh9FxW+VjxpUHTSTDRppdtmrNTkPM9xqgPJvZ4WmoVr6xL/y8E3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RLd5WYEd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RLd5WYEd"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63QMFv5w3102032;
	Mon, 27 Apr 2026 12:34:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7IwXXf
	40t3wYN4w2Eyr2gG4oXYKG5ZvFC5CFp6RfFHM=; b=RLd5WYEds6au10aZjtfhd4
	uPGdyUlBTrJEluSNgkhwCxZOh/d31kfbOsO8srfWfENvAk52BVk2gNR+QXkQlejd
	gfDHZXVVF/nI5ShD9G90pTJS5AA06YzrEO7Xe4XtKvrQNvVVrmq4D7SH2a04XNyR
	H6tgLuLaQ+cDHn9dkE6U0XvzddsQCfboGYqvL9dgRn4kN1t92e5qMePkwlkHtI37
	bp775K4Az469O/zZhILj3J8NGBK7EYLOa86ZplQND8YgDfmpicYj4D6KzZ4nIBXd
	PcYZj3lqCkyZ9gPhP4PKS2B11q95LYNyKmaNMlV8tfy79QrRUxjEFDT4Jd7GZEiw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4drn44gd9k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Apr 2026 12:34:03 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63RCNqAH016728;
	Mon, 27 Apr 2026 12:34:02 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ds8avn78y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Apr 2026 12:34:02 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63RCY0l755116270
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Apr 2026 12:34:00 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A1CEA2004B;
	Mon, 27 Apr 2026 12:34:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0C3C20043;
	Mon, 27 Apr 2026 12:33:57 +0000 (GMT)
Received: from [9.39.16.1] (unknown [9.39.16.1])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 Apr 2026 12:33:57 +0000 (GMT)
Message-ID: <14822154-4cd4-4ca0-b3f2-ce91902d1391@linux.ibm.com>
Date: Mon, 27 Apr 2026 18:03:56 +0530
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
To: Anand Jain <anajain.sg@gmail.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        djwong@kernel.org, fdmanana@kernel.org, quwenruo.btrfs@gmx.com,
        zlang@kernel.org
References: <20260414102031.74527-1-disgoel@linux.ibm.com>
 <c27c678b-89b2-40e0-9b12-23b0807f74ed@gmail.com>
From: Disha Goel <disgoel@linux.ibm.com>
In-Reply-To: <c27c678b-89b2-40e0-9b12-23b0807f74ed@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: ARoyPrsruTgU2sUsqqJRW3xWT4yFl86d
X-Authority-Analysis: v=2.4 cv=Ft81OWrq c=1 sm=1 tr=0 ts=69ef57bc cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=24uHQU0NJ4ryqhBzpYsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: YYPU3rDPGrj6PnN4O9YCGDB5rb1kc8bk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDEzMSBTYWx0ZWRfXwcVj8oL4sOeg
 0/EkuuiKJpI09YJbA/HyVyaoxKGl0gD/Ol409jeZZigWNQnHGwDT/ySyuuK/0orQB4nJ3LCtqZG
 i2nMC69uBioHAV4jW13a4UoqGHJc8wenbqRDZT0ddNOLx1EU/ddOsQIt8vRZ4jNGNq0IWai+IRc
 DI5a9lfTQzOQ0YshHaQo9zMLIFPNJfXA9mUdaeP6oXpN0tHJHYslox/DHoXVvrmBdo4Dtj5RCju
 r4xa789Kc0gmKNYjerc15h34m0HiBpJ+W+U5wO+nENFq/T3+pGBcZLYox/mF7B7EaAmCr+P3WIO
 mcUCs+2WWVWFI7Z9O1EOFY+a9AEks3YVu89w5ZBMlzG639yMDC4Y8c6EBaM3bUkVJd3LWfwvGHR
 Yy7E1ULVgzYW+MYdtx1it8cJDW85W4L/zvAcLHlRSBRq4Zu2gxzIZc1OfGesmduvFwpzDqipAPX
 WO2BAQIMJKdI7Dv97kg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604270131

On 22/04/26 5:21 pm, Anand Jain wrote:
> On 14/4/26 18:20, Disha Goel wrote:
>> Add a new helper function _require_logwrites_size() to check if the
>> LOGWRITES_DEV meets a minimum size requirement.
>>
>> This is useful for tests that use dm-log-writes with additional space
>> requirements, such as creating LVM snapshots during log replay or tests
>> that generate large amounts of logged I/O operations.
>>
>> The function takes a size parameter in KB and skips the test if
>> LOGWRITES_DEV is smaller than the required size.
>>
>> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
>> ---
>>   common/dmlogwrites | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/common/dmlogwrites b/common/dmlogwrites
>> index a27e1966..1ce2b2fb 100644
>> --- a/common/dmlogwrites
>> +++ b/common/dmlogwrites
>> @@ -14,6 +14,15 @@ _require_log_writes()
>>   	_require_test_program "log-writes/replay-log"
>>   }
>>   
>> +_require_logwrites_size()
>> +{
>> +        [ $# -eq 1 ] || _fail "_require_logwrites_size: expected size param"
>> +
>> +        local devsize=$(_get_device_size $LOGWRITES_DEV)
>> +        [ $devsize -lt $1 ] && \
>> +                _notrun "LOGWRITES_DEV too small, ${devsize}KB < $1KB"
>> +}
>> +
>>   # Starting from v4.15-rc1, DAX support was added to dm-log-writes, but note
>>   # that it doesn't track the data that we write via the mmap(), so we can't do
>>   # any data integrity checking. We can only verify that the metadata writes for
> 
> 
> _require_logwrites_size() should be designed something like this
> 
> _require_log_writes_sized()
> {
> 	local size=$1
> 
> 	_require_log_writes
> 	check $size || _notrun
> }
> 
> So, patch 2/2 can simply call `_require_log_writes_sized <>`
> 
> Thanks.

Thanks for the suggestion. I've implemented this in v2.

v2 has been sent: 
https://lore.kernel.org/fstests/20260427122551.71696-1-disgoel@linux.ibm.com/T/#t

-- 
Regards,
Disha

