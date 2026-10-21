Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792567571;
	b=aExorT4URahmNiwAbyswEwitkATFo6wtL91zIVyNHNWm5G0fVYxNxnsXZRKZSzO9PF/C
	 YVkmv3BysMH3iOtxEYkM+scLtuED/zSu4WMTgPeSjEhXNNV8p806EDpGZSg7EuYHkb3+l
	 hu+tcwo9aSf9SeswNfQoO/w9xNWAtvcPjcSbtWtCCv6vs91Nfz4fWBEXQUlZAnrE6RbVH
	 M9fnb4lUDiwx9n9J+qh9t53NjTGiEwoQ4dB9HwyS3as5NX2nSAzHmdS3CuEA3mJh8ygMh
	 LXyqS/09pFtdS2jnNC+3+ojjGoBEhb0Tff0rir+GuOMhVORc+uiK//whdEnyUTXw+DQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792567571;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Message-ID:
	 Date:User-Agent:Subject:To:Cc:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:WDCIPOUTBOUND:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ab6O7IRTGVH9v/INW/nIpEbFW26Rp4Et/QdgPPMHirE=;
	b=XlbovLqHtXbIgYC/V3zjT3reLfQa44aQaQhWQoPCInAR3jFf26Y0oEzgQ7EFFSgO5WHI
	 Rp7ej7mJuHaKOv0d0KYMbJ/RdQdtQehf4NSQllS9/NEJmiWETncBfiFV3dCYp6hZn9NnR
	 OdlQdYFIzrmFpkYvLYx/YjGkKyMTY/SsyOd6vkVa6am7i1b3hZGmIW6fV0J+qH/ZOSTQb
	 mrXxDlCNBTk7D5tfNHeTbeinT4uND/DFs2+bK4+ZwuF7O4wc3LADJ96fvvhDcBnO0FRgK
	 y7GbBxduN+q1bVsM3m/9K/KvzgjaJr3mYBBZjavhVIPWeZHdVAOtkZD6nWaoVxJkrtg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=j22ZkY9t;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=GDrvGT9J;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.45
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73707606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 07:26:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73707606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=j22ZkY9t;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=GDrvGT9J
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1792567570; x=1824103570;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zcCayJ8lBTwa951ZDcE/PMi16WCP557/vfVkaW2WfZs=;
  b=j22ZkY9tL+mkJw/KIYP/4LzhC75Qze60jQtiGpYFeHbwjbcZoV57ySRD
   8EVRTM4JAvg15CbmSK7Go0wrXeQV4grm1Blev+rHFyrZ3ex+2TQztyUw9
   b4x/QHYS4W1D+fGWN8WczK42VhBUm+lNDzUkXdTnsIYqqYmh4rpePY2p5
   cGlZ8SBgzfE4qXYBMoLmoZzru1idSjaUPKXVCNIh+bmRWk4dULQ4GmhuB
   o0FTCVaY36llFdzo0f99Vu6HtY42OdGskUt+oWgrDrtjLPRFtSY3khqzs
   joa9oXRnzT8+qTp9iLDOBsUNxHhxY0p/RIx6JrBm0RKV3tjYjRU82FY3E
   w==;
X-CSE-ConnectionGUID: uloktUZoTDmFh8PcySPLdQ==
X-CSE-MsgGUID: NPH+MjciQEW1TKao5Ujz/g==
X-IronPort-AV: E=Sophos;i="6.27,169,1786982400"; 
   d="scan'208";a="157012540"
Received: from mail-westusazon11010037.outbound.protection.outlook.com (HELO BYAPR05CU005.outbound.protection.outlook.com) ([52.101.85.37])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2026 15:26:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wwALRnT793lwmxay8p00hd/bzyLatyw1KfEyd2VnMA+xUKw6OuQ4NF5KeJHH11fg3PO12KRQeHyeFns+wvF5HQyArUynQt5p+eXfqwkIYDoIbUVcPVHwJ1rcNNWBlfnfMv0GNQ2OtDr1bwDg48fEStXcvWPdv+00rt52YGhunyksh27VbUT04TEPmHmTPWJJbh+edxOO2PhK3Wm08PW0PIEALz7Linffptw3MjTwWcX/inwR2Ayao4mRMP1jFYzt7Wx6BvDn1Red8JVZcP3lfwrE5X+gG7wxfOKmyNh7BXTNjQWV2ANmwgXA0tpc17qfphfr1sUsateTJzeIw2yXvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ab6O7IRTGVH9v/INW/nIpEbFW26Rp4Et/QdgPPMHirE=;
 b=EeIabzvyC9Jm01AMJnswH4opztgY6NtlSYhKv7BqWyB9nIQU08mIRmO6Z5u3Dnf/HpYKoR2QG0Ll103/CcobVwdssAteUrkwOH0/G8oBGYazI+WjimA/RAtACyA464mDhow0yNXCnAdIVCqeMO6CEKnX5y48wRO/Xy8JTs4LTMkaM1llolYlj4CjgpJ8+T4X1c4lX8Sn4Ut1IQrOXKpA6RpysKwX9inVptrZ6QgG0iRNgmPf8SKmAXDiPndRbKGu/v40ZAQFi8Hzlu+tNPc1zLlg4Ei6gbBPWm6FOnCOr2MjXndxFw3lrDPuRDgOysxJOM9xLhdLIE0vucdSCIpP/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ab6O7IRTGVH9v/INW/nIpEbFW26Rp4Et/QdgPPMHirE=;
 b=GDrvGT9JBHBFxO6nxqEOGhi/YDu2lA7eVWnxq2Wx2mFsL+cNpyBlXBBGWrkn5Ozc/H1k0l+5s8w2WRWtcNIBo5/VedQW/wN3WU9R8RqXuSkqndYEgjhuVcRHTRt2XII8CV72rWSzDM0Yk+Q6ZUlqP+1+/Or81LhRAyPSmUKz09w=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA6PR04MB9447.namprd04.prod.outlook.com (2603:10b6:806:436::21)
 by DS2PR04MB994315.namprd04.prod.outlook.com (2603:10b6:8:3c7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 07:24:37 +0000
Received: from SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825]) by SA6PR04MB9447.namprd04.prod.outlook.com
 ([fe80::14c6:1c14:485f:1825%4]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 07:24:37 +0000
Message-ID: <152061ab-a3ba-4137-9100-6dd05c3ec0d8@wdc.com>
Date: Wed, 21 Oct 2026 09:24:33 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] btrfs: zoned: requeue block group if zone reset
 bails out
To: Daniel Vacek <neelx@suse.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
References: <20261002073715.2191177-1-johannes.thumshirn@wdc.com>
 <20261002073715.2191177-4-johannes.thumshirn@wdc.com>
 <CAPjX3FcGedb5oap18m7wvKRvaR=wcUJVUVazg0_--RN-9SqzDw@mail.gmail.com>
Content-Language: en-GB
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
In-Reply-To: <CAPjX3FcGedb5oap18m7wvKRvaR=wcUJVUVazg0_--RN-9SqzDw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0158.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::11) To SA6PR04MB9447.namprd04.prod.outlook.com
 (2603:10b6:806:436::21)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA6PR04MB9447:EE_|DS2PR04MB994315:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d119d84-3b59-445a-d3b7-08df2f445cd7
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|376014|10070799003|23010399003|1800799024|22082099003|18002099003|10067099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	MeOIiKIszGYbNAZ5gr0o7U5m2R2hojEvyi17DipXo5wSTZe/4gObgXwYCK1SMv7kJcfC1UnEqurS8zhyXPi/yE2p+SoiUuFFMO4RW9mPxM87yoAeHry0P9WEbny4IwPfv9MxUg+7LgoVcrxR9teybt/RaYx21Nf368axRMyncN68tOknelR8rt1nLhGDTNyYG3AV6jTTxOXrRHFyJgFmo1JLF0CAmdOiImPxVfgXfXFq6gJ5hQFEfl7btWKirYyV/qTg3Q8i6Xos5HLTTo19rZc8r86HYty8uVzaXkA18VCk7Okt/tc0TqrDPIAyJuouE7rOMMxp8v4gH3GCcGY9vuNiDwxlTd78yzujF1w14a8B2Yp8etwwH9EZtFL4SIyqrfgIdiH+3ymYXctC1orJ93tXwYizz2qxTI+g+qnVou25+oakL4IBOtRFJGmH7Hmju5we9s2IXFGt6xX4QqJwWaChTqFu3drDkBzsqF+Y/26B2kgus0a6vNTnvXBM1hpFbgMouldpsssI0WJV+F85N00LgoyoyL1btAeGw6lFdk1dGySsJ19kRo4oFNVYAnFkguXKIMBhCsEY2F39bcRIysJTa2w1lNbc0f3c8J2ES7EbtH1EMWjVfR1Rv2OHdYUBhQCc0/3WL4ElJF90bNvffeed4JBVw0sFSJhR/cvGnEI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA6PR04MB9447.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(376014)(10070799003)(23010399003)(1800799024)(22082099003)(18002099003)(10067099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bEtPclVxTm5SZjZHQnducDFDOUNZOXByMDhoMFROWjUvTmUyU2dySm1xZmVX?=
 =?utf-8?B?SUFZYUluaC9iTEMwRDNGY2hJY0pyTUd0Q1UyNUlVdEtyNmMvdnVqVUduaWli?=
 =?utf-8?B?eUp0NXhvNStOejB5dy9qUUx1bnRpUjA2RjNaOVdPaGtKQ0NFdnZ2MENpaXo3?=
 =?utf-8?B?N01uWVVmTHpIS2NMRkpOZmRiMkRzV2s5YmM2Rmx2R1JjM1MzY3lNSnZ6TTJY?=
 =?utf-8?B?NW14alV6ZGVPai92eVNhQTBGT0N4R2xmS0EvNHZwY2xiZ1V0T2pxcWpHcUNw?=
 =?utf-8?B?QWRUd0c4eG13SlVocCtJZGZGMUZYSlJ5MFZVQ09tSGxxWDJPWjBLZG90a0tH?=
 =?utf-8?B?b1BJcHYwNHEvMkJBVTdVS2hzazROaDZlMENGeGFtazRsdG1IRmV1dTA5ZS9M?=
 =?utf-8?B?eXJPUTZSK2lYbFMwTlUrdmVuT3BPWW41TzhWZkRiWm9kRGNDSkNBWVN6TGFx?=
 =?utf-8?B?L0M1L0orVDVEb3pDQzkydVdiK1dXZ1F0amh4aEhwUUVJNURrVHEvaWpvVHRR?=
 =?utf-8?B?aHR4SXNwNkJub1BTWXI4Y1A4UFFpNjRMekZraVRldm91SnFVaStLOHdwL1VR?=
 =?utf-8?B?OFQzS2dCbHpMTDlXaTBnWnpGTGRoQVpRNEp3ZUpCMGE1cHpCNy9xZFRjYjQ0?=
 =?utf-8?B?OFhETHhZQ1BWbWk2a2IrNnlpN1lGMDgvVm1yaUtscEMwSlh3WFVTSWtlZTRN?=
 =?utf-8?B?bzlCd1VOQzgwdkZBOEN3elVBUTI4YzhKQ2lNUERoS0c3VjdwSHcrWkJucndU?=
 =?utf-8?B?QzQwNEF6NHAvQW5WTy9WbHlVVjgwc3RJOTVtYjlPUGFjWm00dWVmU3A0VDdt?=
 =?utf-8?B?Umxjei9PTW9IMFNTZC9hR01TalJ5UFc2WlV3OTJxRk9uRnZwa0cwRUZPanVL?=
 =?utf-8?B?OSs3dmh3WE9uT09NUnVTcEdhU2hlbnpYZnBhTlEvdUwzQzV4MDNLdGY0R0Uz?=
 =?utf-8?B?ZVpQT2xsb29VT1VhRGZBaU9LYjV4SjNhU01LWWx6VDR0SWxydHVjZ0w0cThj?=
 =?utf-8?B?Tmo5aWNBVW0yRkd6UjlHYUNVWkVLb0Z0aE1Vanp5TlFOck55NFd1aFhCdHJ6?=
 =?utf-8?B?V09GV3lmMnFUemtLam5YWDhFN096NHIvb01EckF1eWJ2dFFoNjhENWovY0FV?=
 =?utf-8?B?NmhhdlA1L01QTllwR3lDQmNqNUNYS29YYzc3UnZ2V3dlOFhGbkdMU0JjeFo5?=
 =?utf-8?B?VkRqTXdRblRsbkpSaWtaeS8wbkJMQzNvc3M5N3JsMUU2ZGhaZ2tSMXIyY1Jo?=
 =?utf-8?B?amJjajdyelBLTUlzbWFRdytsdkNHc0F3Q2U5Wm14bDFVK2hTNUttY0ZDRXR1?=
 =?utf-8?B?dUluYktVcTM2TllIMk5yNFFNcWdBL0V2TndaYitYWDEzcWJOZGVxK29aNUtS?=
 =?utf-8?B?RU9ZL3ZZMkFHbTFqMFFVQlFTc3cwZEtQbVpjRFZZcE9aWFZ6U2M1RmtKd0pM?=
 =?utf-8?B?djBqdEg2bTArOVo3aVJINzJvYTJrMS9IMit2ZDMvdFN1TTFsanNON25PQzB1?=
 =?utf-8?B?eFM2ZERWY0VQMG9oODc3UUp6ZDdKLzgvM2tobjI5dlZCeWIyNEYwZ2pWT0V5?=
 =?utf-8?B?OGszTTNjK1dUaWEvaHBISno0WUI3UUdZbEFXV3MvbVdwL1U0Vnh0MUYvR3JY?=
 =?utf-8?B?UnJta3MvSnhCaUJwdlpreWhZTDVseElqcHp3WkUxcFBSNjgrQXI5TlZ2Y0du?=
 =?utf-8?B?SmpLVFVsVHl5L2FrRDc0RzlEbXFVY3Y5OXNDTy9nNVpPNzhCaENjR2RhTEJY?=
 =?utf-8?B?TGNKaCtzYWF2ZWNnaTA4VkJBU3ROYzB3Q1NMbmd3WEE4dmFLOGpKNHVOQTVH?=
 =?utf-8?B?dnFjbVRlVCt3Zm0rd29qQldBditwNmE2YkZwUHoxbUNtUUszNGxIWEZuVGdC?=
 =?utf-8?B?OUN1cUhsYzBMamErM0xVVE1MVXRQWG1paTV4eHYrQWhJTC9aL25sOEhJdEh4?=
 =?utf-8?B?RDNYenY0TGg5aEwrT2xaeGNpRXZNN1owNEM0MWxaTjNSZG5NcDBZb3FGeHNO?=
 =?utf-8?B?MkRTUVcrNDFSbVNWL3h4U2FFajZOdjdvVGpWdzRuOEZhcjlveEVYNnFzdm1m?=
 =?utf-8?B?MEpMbkNBVkIwZlJleFV0c1ZsbVE0alE1WWJaWWt1c3AxdXY3ZEc4Uld0K2Nq?=
 =?utf-8?B?YUxEUlBMeHk4MDdyN1hpb0JPYnB1UFRlalpPVmM5eTA3dHhKTmhTckYrMXpN?=
 =?utf-8?B?aWttbmg2dUFqelljUXV3aE5JL05iT2ZSM1g2bldsbjVPQzF5QXVCZ05aV1da?=
 =?utf-8?B?OGhFZDJQYkNtNWdJOURKd0pad1VuU1kwS0w0UmdZaXVOMFFUbFhleURqM2N5?=
 =?utf-8?B?Q3BQdHl1cDZQWkJ5QU92V0wrdXFhdEZ1ZnJkaGlYb0ZQRmFCMnNWUk82eUc0?=
 =?utf-8?Q?mpykd16HvmjRhPwUkyUeMjtCiCQnPG/BGkmLbiJy8dHY7?=
X-MS-Exchange-AntiSpam-MessageData-1: 8lu6IBw2942LGsT++paoVr7maOa3SPJ4kr0=
X-Exchange-RoutingPolicyChecked:
	gzYVAMkqekz7Eg35TLiJpUWUJx1Cxuq0BPWQmY3Aaj+pzoP8xxtjsFRZ/M8EfGoO1GgAcyur86Ngg/xBNDZMWgbXzHJGm2B5i+j7gFQKVgUYRDEDeREjrAkT1AaKnjwvAYc1m5KGzgqcYL5p3R1qprhDAKyXB5kpUkTlPKuHiOPmPlZhxuFSG6eVgozxOIXfCaTN2eH+mwq3eO9Qr+EdgRoEChI+vkps63T56wQ2KhA5wzdLPacBsMSN0cazMs3RBYf0FeiXV/6Z8aQDxRs3GNUiRHms9iBvBO1VSxn2o7ta5ccDQXz1EV1A3ERiJ9ObApw4Q7j+KGZmZUfhLfxd4Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7LC4zzwganCXqFu57se2OJA3jAYeaiHEhszZ8cNx8vv/AOEamEAlLUoHCPhM0vX2ckhYvM7oDROaTQi8fmX1gfqHV6kA+2LlEt42VeQA0KCCCbXQs/C23/2axhNhYgE9w1ymJZ57K4aOdnR+nzC7ZvTskdVW7omfKh5mj1hVxfVRqxXFyRi408GCwu8MgaqzT5Rx+oxszlesPCi94+2mRE1LBrVpnMq02w4uyQtGoCKe9MphCBDPWAYSo0ml30mDFPpREdp7Knv/7hDVv0qQ8lUlrcWMdt0r7SGQAes3NMm8d3LBnJVByBgCmvV4+9wpTqooZuGxL0QorHK1KHnDKkKlROkG4Ns3WcbmfMgsn8a1i8ntg26TjlTV27ikTMnLofh1X9ysUXq51kTcAGdRGeli187oYVwueBmw04evCXgOkSqK8DUwnFgGN7iFsXSqcn4vnTZaS4/S7wt53svry4alTA4Rkj1YI0PPTTkyqDW2IKzinawnrODXOFz2EXerTHoF0+bd8kQH6Vf5kXBDSj4ZEKhwLCEwsGEAaYEt9PBVMpfGjXUqVeEMt0IXZC9ZzXDT82hVlFo9sL2rtJyjblv8lswL5XhXC3YJObWgqvUEBFk3WyrmiHQjav0/x6Xl
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d119d84-3b59-445a-d3b7-08df2f445cd7
X-MS-Exchange-CrossTenant-AuthSource: SA6PR04MB9447.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 07:24:37.2721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qIqwUeCAynNDXnIPlaG371RjInlVdNgJi6DlxYJcLj84eAxgKAPz1qgb2Mg/Yp1+O1tB3U4tt+uRgZko0dlVhOpZHOyQW3/LWXZtK8jXHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR04MB994315

On 20.10.26 14:43, Daniel Vacek wrote:
>> +               continue;
>> +
>> +requeue:
>> +               spin_lock(&fs_info->unused_bgs_lock);
>> +               list_add_tail(&bg->bg_list, &retry_list);
>> +               spin_unlock(&fs_info->unused_bgs_lock);
> No need for the lock here, you're adding to a private list on the stack.
> 

Fixed/dropped

>> +               if (ret)
>> +                       goto out;
>>          }
>>
>> -       return 0;
>> +out:
>> +       if (!list_empty(&retry_list)) {
>> +               spin_lock(&fs_info->unused_bgs_lock);
>> +               list_splice_tail(&retry_list, &fs_info->unused_bgs);
> So you're picking from the head but putting back on the tail, right?
Yup, this is the same pattern btrfs_delete_unused_bgs() uses. I don't 
think the order is important, the list shouldn't grow too big anyways 
and we're getting rid of these block-groups.
