Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0D326CE39
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Jul 2026 06:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784184870; cv=none; b=I4NXnq9Je/eUOvNm/f08sY/hIXO26W+ddrswgrpFaVuFnysZwBHeS4zdcaKmXkHs31ngjTkJH9+heHQwFOj1YO2IvVuuEjC+7xpEFC2QjOVn8ipuVTLIyaKXrog8Mc0Kczb8MHRDW4PjVjVeWRQPZ1jEnhBVx5UzPUb6WiLdL2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784184870; c=relaxed/simple;
	bh=+oPNDWr5zQXzbTPMZKB5psmrWajf1/0mlFWc5UIKMLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tGTg2BypqubHJIN0qDwnZpUQoX3/rv+kd0vjkR2o7GAkOvoJHOGEzwbpCqfv2T2380I/NHcTmGXmmAS5Wh/ZaPNrpE+2wzSEj//yq7hAFR+daHKZPbu/6V2rK2ywATDe6V+GMPpv3j/lnP0wEmBGuh/mEEpJVWJCHrEB3BaP1NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hHQY89k6; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hHQY89k6"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66G4CFSx261065;
	Thu, 16 Jul 2026 06:54:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=MgxZOd
	t0sIolZhu2e4/sNuAQuAD0lbI/GNQNRmffWag=; b=hHQY89k6/Yxx92yJFYxxO7
	WKjauaraPo1VYZH0WqVo+/nO3af9jp61w7c4kZgBZXrvbL2Xjt+Vxj9gchsbqVHI
	68ih9f8aQ9L04MvOpZuPwQIhRmu7FaX1W4cEqPeaPUkTU39mxfE/JPS3eygK0pad
	h04xMq5VnQzyAkLPbtCaQarV0lt+/y22btOeBxmYzCfKlWE81M5z4yxzIb1fTcgB
	R3S/RP1jlXBjbvdmad/n+j8fL8KlWieyr9uL6UxHJrz4UOt2jCO9slQ78/gchd+V
	zkskH/qLOO8kqOPsj8s6BVdahFm90PfJwJ4IcpIFnpDUHIz2IPF6Hz5Tgp6eASbQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fcv33fx1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 06:54:26 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66G6nigB029985;
	Thu, 16 Jul 2026 06:54:25 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fc1nhkpr1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 06:54:25 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66G6sNhQ48562620
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jul 2026 06:54:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C5F12004B;
	Thu, 16 Jul 2026 06:54:23 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0557020040;
	Thu, 16 Jul 2026 06:54:23 +0000 (GMT)
Received: from [9.224.77.173] (unknown [9.224.77.173])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jul 2026 06:54:22 +0000 (GMT)
Message-ID: <758006dc-e6f6-4a37-b864-5e885c52abd3@linux.ibm.com>
Date: Thu, 16 Jul 2026 08:54:22 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: fix a lockdep caused by path resolution during
 device scan
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <49654338e775adb4b40124ea5a3abeb0dc6fdb42.1784027853.git.wqu@suse.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <49654338e775adb4b40124ea5a3abeb0dc6fdb42.1784027853.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDA2NyBTYWx0ZWRfXwxkdP7zZqg5Y
 nMYz1pyXCn7gYMV7Ll5nOGA1d37pNphej9kg/YwT+nHccI3nJmhFcgmBOyU6ed1n6xJ72uwCyAV
 dgbMufPM5XFudMpyVINt2F8NdWF3gDY=
X-Authority-Analysis: v=2.4 cv=Mp1iLWae c=1 sm=1 tr=0 ts=6a588022 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=iox4zFpeAAAA:8 a=YZoY2-2WaaR9FNdqre0A:9 a=QEXdDO2ut3YA:10
 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-GUID: 3p_8cikTmOWfHKlOhrotWfLo0ndUXc-U
X-Proofpoint-ORIG-GUID: 3p_8cikTmOWfHKlOhrotWfLo0ndUXc-U
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDA2NyBTYWx0ZWRfX6pbopXXBB3uA
 c+9EM15P0EDU3L9gox4xV3D1N71J5Dzx4iyYTVfjWqoJwXedhA3DvOMDP8SK5lLiyU8sWa3eE3z
 R9EiSDlfd4ggvQIvzhBaZqQ7FSMjB2q3jImla65HfRnjrZQ+K0Br+dgGU/MzWQlnnnwdeHvtsBj
 eUGqu8pkJHZ4aPjQDspr3dYtJGuZxaqbalr6FdO7TUpHaw50U33TgIn6nYcb85CTSzXMeT8Vh2s
 mEfSX+nmCsD1TVHDg8CW+FAkn+gqPkzXuqCQ+MkCOBHRrnIY95f8ntd6iwU/BNvlBtkpZFL158w
 kbIU192NB1zmF5Tc+Whgi8XQM1+90HDD/RP4KtLdhdZoQiOh9VtKXngazT6EPgEPZZoQsxtQ4w9
 h46ZKMKfnrpd84rsS1sHmYFBRGs5fcRf/6MH2Ja6OvGs5KqPXsYoUqvdkTgRsvOdyyy2I2Ioz1h
 6U0GIQvmv6FDNZ6KTew==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_02,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607160067

Am 14.07.26 um 13:17 schrieb Qu Wenruo:
> [BUG]
> There is a lockdep report related to device scan:
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 7.2.0-20260712.rc2.git0.e3321fa3034d.300.fc44.s390x+debug #1 Not tainted
> ------------------------------------------------------
> (udev-worker)/1653 is trying to acquire lock:
> 0000006919232220 (&type->i_mutex_dir_key#2){++++}-{3:3}, at: lookup_slow+0x3e/0x70
> but task is already holding lock:
> 00000069238564d8 (&fs_devs->device_list_mutex){+.+.}-{3:3}, at: device_list_add.constprop.0+0x148/0xc60
> which lock already depends on the new lock.
[...]>
> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Link: https://lore.kernel.org/linux-btrfs/5a9d9847-4ae6-43c4-afdc-6e5fa51d6117@linux.ibm.com/
> Fixes: 2e8b6bc0ab41 ("btrfs: avoid unnecessary device path update for the same device")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>

I can no longer see the lockdep splat for this chain in our CI logs


