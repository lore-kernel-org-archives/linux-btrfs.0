Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CF037CD50;
	Fri,  8 May 2026 14:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778251961; cv=none; b=YGwh2MgZoExncAga7QYuY/NteYsdtpweNc5h9jM0I8VKZzx/plGVSmc+Cd+LsVAK74Emz2FzLECjX51lhIXHPyewVf6kP1z5Cb0rGlf1SHd1KojF1ZDTGPn00kwoG99irf1rpzeDYMAO51f7fyeRc+04HJ3BtWUkrRPfguSaL4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778251961; c=relaxed/simple;
	bh=EyFvf4zYl21W/bkNYBbAFm4I8G7JvoWBcG4DQB+EUgo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=go/DKaG5yrmL/RtiJiMNlY0P7rz67kdu2sIZ/FuefRilzrtiaUshhFcezwMZ1ToHGKBAoUnvjn2gad60CqIEie+P4IQ+6tyaKgLU2hrTPmPU+WlYTAfons9A+BmA1UVWhBqdowPmq1R0iNnbLFnxhPTlbuh8aVXVpRQwWEXWvSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LOBCO+BG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LOBCO+BG"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 648CKRut2578306;
	Fri, 8 May 2026 14:52:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=zPk9j6
	uRgLZ2PQ+0bCzs2mIY5lcGqQXx54Qs+6t5rMg=; b=LOBCO+BGiS0hSBXOHbz83E
	R/aBOxFSRCnBGrzadAUS8HNZxCJ1944x7COjRptKto/w69oXFy4U1IycdY3qik6J
	GwD04kHVbrQAx496zd7eXU7d8Q72z6NFOmHc1TLBmI2OUzX0iisFcEuxePmrWB2S
	dwktZpXEoWdZV/acekj2y+C5aAk+Ue5zaI2YIfSGopAlkhU6LT9ZRNX6/3OsOini
	jbX8yjQ7pe46D6xAiA2Gwk1tGqUn0d0MrCrMtTEKdoFLyUhfw0NGvGcoKtfIswEP
	ALxAL7DPWJjKF9c1jSF3c+2IY58adJO7gu3oMe54A5e5eCDz8iwEXqLPdFi7IOUg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y52wyg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 May 2026 14:52:33 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 648EOdOM016033;
	Fri, 8 May 2026 14:52:32 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dww3hghxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 May 2026 14:52:32 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 648EqUrk30605670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 May 2026 14:52:30 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89AAD2004E;
	Fri,  8 May 2026 14:52:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 999342004B;
	Fri,  8 May 2026 14:52:27 +0000 (GMT)
Received: from [9.39.21.154] (unknown [9.39.21.154])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  8 May 2026 14:52:27 +0000 (GMT)
Message-ID: <48f601e6-eb35-4eca-bf7f-327a16a8e54c@linux.ibm.com>
Date: Fri, 8 May 2026 20:22:26 +0530
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] btrfs/291: fix state transition logic and add size
 requirement
Content-Language: en-GB
To: Anand Jain <anajain.sg@gmail.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        djwong@kernel.org, fdmanana@kernel.org, quwenruo.btrfs@gmx.com,
        zlang@kernel.org
References: <20260427122551.71696-1-disgoel@linux.ibm.com>
 <20260427122551.71696-2-disgoel@linux.ibm.com>
 <33433bce-e071-4f88-b0f0-9f5299714d3c@gmail.com>
From: Disha Goel <disgoel@linux.ibm.com>
In-Reply-To: <33433bce-e071-4f88-b0f0-9f5299714d3c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA4MDE1MCBTYWx0ZWRfX2M47IWmA4LuP
 u+nHCARLn41q6NnExazNUwpH7ogEmoeAR99Fzx6gocdzVWVtWsf2J84/GECYf8NwpIK56bCifb9
 KslIuXJBATnShpPdhqfdOhkaUPm189ZFWTv01h7t9CgHfvMxzUhCPs6H9U2tA9PYsFMuib6XAYa
 /8/Qns8BAagSFbf+mXK7C4uFqodf+pnSVX9qJYbDlobc2I6ZMB2m2QxZeOSxI6esaEf7xQCpi1R
 BQIrcdhTCinWHiE5b3X7fKKMdU+mYcOzqLeIOO4nn3CsBm9G9stmvCDS4m1uo8s3Ulw68vNAnEp
 1FVelTaPIYCIImBkaetfMT1PZkISurVpXPQnPX1w/YwolQiQxC2FvNhD0nv+EzRlAqkEO7WvDZ5
 lCvjefhNrZ7Ziiyx0k0QuysJrFwGjm5wFJkojVsbGF372O7VSSiVSyfRvz0xsRCPhcEKGdAzYDi
 5q2e6UYZRq3d0XkE8WQ==
X-Authority-Analysis: v=2.4 cv=J4GaKgnS c=1 sm=1 tr=0 ts=69fdf8b1 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=8fm6bSxqBhqLCKro3lYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Ssv_M-iOhYoCJE-YPwUavF24WCd1CsgL
X-Proofpoint-ORIG-GUID: 5GHlsr01k6zYWoMTS1-hKR4JqMBs26jz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-07_02,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605080150

On 05/05/26 8:16 am, Anand Jain wrote:
> On 27/4/26 20:25, Disha Goel wrote:
>> This patch fixes two issues in btrfs/291:
>>
>> 1. Add minimum 9GB LOGWRITES_DEV size requirement
>>     The test creates LVM snapshots at each FUA point during replay,
>>     requiring significant space. Use _require_log_writes_sized to
>>     ensure sufficient space is available before running the test.
>>
> 
> It also depends on the SCRATCH_DEV size; the fix fails if SCRATCH_DEV is
>   10G.
> 
> [  173.478493] BTRFS error (device dm-3): device total_bytes should be
> at most 9663676416 but found 10737418240
> [  173.482763] BTRFS error (device dm-3): failed to read chunk tree: -22
> [  173.485457] BTRFS error (device dm-3): open_ctree failed: -22
> 
> Thanks.
> 

Thanks for the detailed review! I've addressed all the feedback in v3.

I've tested the fix with multiple SCRATCH_DEV sizes and confirmed it
works correctly.

> 
>> 2. Fix state transition logic for verity enablement
>>     The original test assumed orphan items would always be created
>>     during verity enablement (state 0->1 transition). However, in
>>     some cases verity completes without creating orphan items,
>>     causing the test to fail with "expected to reach verity done state".
>>
>>     Fix by transitioning to state 1 when either orphan items exist
>>     OR merkle items appear, handling both verity enablement paths.
>>     Also improve state 1 validation to only check for cleared merkle
>>     items when measurement actually fails.
>>
>> The test now correctly handles verity enablement with or without
>> orphan items while maintaining crash consistency validation.
>>
>> v2:
>> - Use _require_log_writes_sized instead of separate _require_log_writes
>>    and _require_logwrites_size calls
>>
>> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
>> ---
>>   tests/btrfs/291 | 17 ++++++++++++-----
>>   1 file changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/tests/btrfs/291 b/tests/btrfs/291
>> index 122aeaa5..ac1d192d 100755
>> --- a/tests/btrfs/291
>> +++ b/tests/btrfs/291
>> @@ -36,7 +36,7 @@ _cleanup()
>>   _require_scratch
>>   _require_test
>>   _require_loop
>> -_require_log_writes
>> +_require_log_writes_sized $((9 * 1024 * 1024))
>>   _require_dm_target snapshot
>>   _require_command $LVM_PROG lvm
>>   _require_scratch_verity
>> @@ -129,9 +129,14 @@ do
>>   	_udev_wait /dev/mapper/$vgname-$snapname
>>   
>>   	orphan=$(count_item $snap_dev ORPHAN)
>> -	[ $state -eq 0 ] && [ $orphan -gt 0 ] && state=1
>> -
>>   	pre_mount=$(count_merkle_items $snap_dev)
>> +
>> +	if [ $state -eq 0 ]; then
>> +		if [ $orphan -gt 0 ] || [ $pre_mount -gt 0 ]; then
>> +			state=1
>> +		fi
>> +	fi
>> +
>>   	_mount $snap_dev $SCRATCH_MNT || _fail "mount failed at entry $cur"
>>   	fsverity measure $SCRATCH_MNT/fsv >>$seqres.full 2>&1
>>   	measured=$?
>> @@ -143,8 +148,10 @@ do
>>   	echo "entry: $cur, state: $state, orphan: $orphan, pre_mount: $pre_mount, post_mount: $post_mount" >> $seqres.full
>>   
>>   	if [ $state -eq 1 ]; then
>> -		[ $post_mount -eq 0 ] || \
>> -			_fail "mount failed to clear under-construction merkle items pre: $pre_mount, post: $post_mount at entry $cur";
>> +		if [ $measured -ne 0 ]; then
>> +			[ $post_mount -eq 0 ] || \
>> +				_fail "mount failed to clear under-construction merkle items pre: $pre_mount, post: $post_mount at entry $cur";
>> +		fi
>>   	fi
>>   	if [ $state -eq 2 ]; then
>>   		[ $pre_mount -gt 0 ] || \
> 

-- 
Regards,
Disha

