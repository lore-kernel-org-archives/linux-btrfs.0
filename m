Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5F73CA4A1;
	Thu, 21 May 2026 13:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369133; cv=none; b=Nf09IurSs7xq+XbUQ40/05CJxo5ROhwtdBja19946SytaFhxa6rFaAWRx2Y/G7rCq0zB02M2Qide1OaPkMntjs007nIap+YrfFcqvrM9qMGHd0nR+phfSh9xESLLQguniKWAQH5aOP0IZYNUVDyrRlJCyou6u+HwZsZrPnqOC/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369133; c=relaxed/simple;
	bh=uPoBUDD+jL127CiTPS4Asu5CsyfNiCS1TQzDUNE6BMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Am50vc2DZwOVRVoMpObJa/eRDXmCeFb9u9osc06688c3fwgR/TSEMibFBEbgBrW+jAM/quns7XHxWnbhv/QwzWxc8PRlnrV02uDu6AwU66xqM12Gayc7Af2SRaigv1LlIxM1DqJZW/fURFc5YXOpmivwuLwivaJQxNE9ATaG/Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QhFUkhF/; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QhFUkhF/"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L5JlEp3681418;
	Thu, 21 May 2026 13:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5igxQ5
	WgrsT9o6C3hBpZAgcUk/dzR61wNfo5tKYHaDE=; b=QhFUkhF/sGAhidy1ygG9ND
	8/3OjR5StjEudvUfRdJZMPavPy59mt1RzjS95imr95t8a+ovjUsRYuGItfGeMo79
	cM37CBLhN0y5rfNZwttOb88APj4j6NZ/XjblKCt5AM3YPTd0VCCwJbe7p/L2OAgl
	wJdqMzMr848y4arzo5mmMbDeSl/5VtEP/A/Y8mZzDUyD+EQLTDESe7sMOzfU402V
	gt3lBp5xjdFXQ1m8Hofbjjz7VajF0fTmhs2w166Sii5kYkLtmFTGSJNBxtd0Qg6d
	M/WwUdRY94mT/4bx8YYyeGxI8M5Xg5mYxZUDXc/wg7Sap6W/+PH9DKRDlpLkgDQg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9y73xy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 13:12:09 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LD98fY027075;
	Thu, 21 May 2026 13:12:08 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e73wkc7c6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 13:12:08 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LDC6Uh29753692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 13:12:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 415AB2004D;
	Thu, 21 May 2026 13:12:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 819902004B;
	Thu, 21 May 2026 13:12:04 +0000 (GMT)
Received: from [9.39.17.57] (unknown [9.39.17.57])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 13:12:04 +0000 (GMT)
Message-ID: <cf5450c4-9e5d-4d3e-b459-b2d439f4df57@linux.ibm.com>
Date: Thu, 21 May 2026 18:42:03 +0530
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] btrfs/291: fix state transition logic and add size
 requirement
Content-Language: en-GB
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        ritesh.list@gmail.com, ojaswin@linux.ibm.com, djwong@kernel.org,
        fdmanana@kernel.org, quwenruo.btrfs@gmx.com, anajain.sg@gmail.com
References: <20260508144701.68561-1-disgoel@linux.ibm.com>
 <20260508144701.68561-2-disgoel@linux.ibm.com>
 <agHogPMQGKqAHkIT@zlang-mailbox>
From: Disha Goel <disgoel@linux.ibm.com>
In-Reply-To: <agHogPMQGKqAHkIT@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDEzMSBTYWx0ZWRfX8xCL6Fhxcmw6
 whyGtqru/ukz4xjIZ7UpdqsovNqadSvZoUkxd4cwqExaclIwtsb9qJTS0YIcWgs5Jv8IGA7FuXv
 pKH0tNPD8eqqRNCOcTbNItBoAKEAoM9KQ9KIgUBWh+3rRK/nlkoRAdy0zlmNfV5u1UqJZW55msN
 +rQDlcWt+NWafp2DfwXL62eGsbRSChsJpZn0Kytb+5bolpp/sHNJM1zMcv6MCVoFzgCg5DqzToe
 Sbl87ocmauawLYCydZkXMml1J58vlUFgeiDY7JJdMZPimVK2mkSftwrmc/42BbTP0ajQ3aQc+NC
 6mc6cJ4+3S8sSnQMNiks0UbI+n3rKfMz7Dl/J7JfdF5qSmiPkIkm2gpt/VLEUhHvzya4Jz0S/Jk
 Qibxp3C1MpXM9TCjxjXShTsSi2v3huyHPk/wPi1O9KJ/Uoc0HFhUs2hx8zA4uF4CB/YKCSK0XLo
 ewra/bffQXp3cMihJxQ==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a0f04a9 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=k8l-ip43zsTItjP_rpoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ZVa2vgrtoAqkbAmDBcEa0XE1j1-am_y_
X-Proofpoint-GUID: q3AcWfp6VIaZjgLrw1qizHVZj-g0Ym4e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210131

On 11/05/26 8:50 pm, Zorro Lang wrote:
> On Fri, May 08, 2026 at 08:17:01PM +0530, Disha Goel wrote:
>> This patch fixes two issues in btrfs/291:
>>
>> 1. Add dynamic LOGWRITES_DEV size requirement based on SCRATCH_DEV
>>     The test creates LVM snapshots at each FUA point during replay,
>>     requiring significant space. Calculate the required size as 120%
>>     of SCRATCH_DEV size (adding 20% overhead for LVM snapshots and
>>     metadata) to ensure the test works regardless of SCRATCH_DEV size.
>>
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
>> orphan items while maintaining crash consistency validation, and
>> works with any SCRATCH_DEV size.
>>
>> Suggested-by: Anand Jain <anajain.sg@gmail.com>
>> Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
>> ---
>> v2 -> v3:
>> - Calculate LOGWRITES_DEV size requirement dynamically based on SCRATCH_DEV
>>    size (120% of SCRATCH_DEV) instead of fixed 9GB
>> - This fixes test failures when SCRATCH_DEV > 9GB, as reported by Anand
>>
>>   tests/btrfs/291 | 19 ++++++++++++++-----
>>   1 file changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/tests/btrfs/291 b/tests/btrfs/291
>> index 122aeaa5..e5ea4b50 100755
>> --- a/tests/btrfs/291
>> +++ b/tests/btrfs/291
>> @@ -36,7 +36,9 @@ _cleanup()
>>   _require_scratch
>>   _require_test
>>   _require_loop
>> -_require_log_writes
>> +scratch_size=$(_get_device_size $SCRATCH_DEV)
>> +required_log_size=$((scratch_size * 120 / 100))
>> +_require_log_writes_sized $required_log_size
> 
> OK, more 20% space makes sense.
> 
>>   _require_dm_target snapshot
>>   _require_command $LVM_PROG lvm
>>   _require_scratch_verity
>> @@ -129,9 +131,14 @@ do
>>   	_udev_wait /dev/mapper/$vgname-$snapname
>>   
>>   	orphan=$(count_item $snap_dev ORPHAN)
>> -	[ $state -eq 0 ] && [ $orphan -gt 0 ] && state=1
>> -
>>   	pre_mount=$(count_merkle_items $snap_dev)
>> +
>> +	if [ $state -eq 0 ]; then
>> +		if [ $orphan -gt 0 ] || [ $pre_mount -gt 0 ]; then
> 
> Hm, this's this exception you metioned in commit log, so if we find
> merkle items, no matter where's it from, we need to deal with them
> later, so set state to 1.
> 
>> +			state=1
>> +		fi
>> +	fi
>> +
>>   	_mount $snap_dev $SCRATCH_MNT || _fail "mount failed at entry $cur"
>>   	fsverity measure $SCRATCH_MNT/fsv >>$seqres.full 2>&1
>>   	measured=$?
>> @@ -143,8 +150,10 @@ do
>>   	echo "entry: $cur, state: $state, orphan: $orphan, pre_mount: $pre_mount, post_mount: $post_mount" >> $seqres.full
>>   
>>   	if [ $state -eq 1 ]; then
>> -		[ $post_mount -eq 0 ] || \
>> -			_fail "mount failed to clear under-construction merkle items pre: $pre_mount, post: $post_mount at entry $cur";
>> +		if [ $measured -ne 0 ]; then
>> +			[ $post_mount -eq 0 ] || \
> 
> OK, fix same situation you metioned.
> 
>  From the code logic, this change is good to me.
> 
> Reviewed-by: Zorro Lang <zlang@kernel.org>
> 
> I just have one more question, this case is written in 2021, now it's 2026. It
> still fails on latest test with kernel 7.1.0-0.rc2 and btrfs-progs-6.19.1-1.fc45,
> no matter with or without this patch.
> 
> Is that expected by btrfs? Is there a known kernel commit uncovered by this case?
> 

Hi Zorro,

Thank you for reviewing and accepting the patch!

Regarding the test failure on your setup - I can confirm the test passes
cleanly on my environment with both 4K and 64K block sizes:

SECTION       -- btrfs_4k
RECREATING    -- btrfs on /dev/loop0
FSTYP         -- btrfs
PLATFORM      -- Linux/ppc64le localhost 7.1.0-rc4-00100-g8bc67e4db64a 
#6 SMP PREEMPT Thu May 21 09:02:51 CEST 2026
MKFS_OPTIONS  -- -f -s 4096 /dev/loop1
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/loop1 
/mnt/scratch

btrfs/291    2s ...  2s
Ran: btrfs/291
Passed all 1 tests

My test environment:
Kernel: 7.1.0-rc4
btrfs-progs: v7.0
Architecture: powerpc/ppc64le

> Thanks,
> Zorro
> 
> # ./check btrfs/291
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 localhost 7.1.0-0.rc2.260505ga293ec25d59dd.17.fc45.x86_64 #1 SMP PREEMPT_DYNAMIC Tue May  5 17:39:29 UTC 2026
> MKFS_OPTIONS  -- /dev/vdd
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/vdd /mnt/scratch
> 
> btrfs/291          _check_btrfs_filesystem: filesystem on /dev/vdd is inconsistent
> (see /root/xfstests/results//btrfs/291.full for details)
> 
> Ran: btrfs/291
> Failures: btrfs/291
> Failed 1 of 1 tests
> 
> Thanks,
> Zorro
> 
>> +				_fail "mount failed to clear under-construction merkle items pre: $pre_mount, post: $post_mount at entry $cur";
>> +		fi
>>   	fi
>>   	if [ $state -eq 2 ]; then
>>   		[ $pre_mount -gt 0 ] || \
>> -- 
>> 2.45.1
>>

-- 
Regards,
Disha

