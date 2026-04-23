Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010029.outbound.protection.outlook.com [52.101.61.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54911D6BB;
	Thu, 23 Apr 2026 02:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776912685; cv=fail; b=lB6ErBIki45ZX3uZ3b6vfNaTpnCPfhzjkzgM0l4tVseXFzZmInCxC0ZafI6YsJFI99mBE+V22zY2wtntnTF7QR6OEF1fAOVaYlZxrqqrBgS57hwDd1TUc9T14A8a7opPyak+hiGeQXz4TNSMicWAxPcgkbYiWNsIEHUD25jR5C8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776912685; c=relaxed/simple;
	bh=fONpP6lumI63B5UCmQWq7nXiIqRRCDtqFidcoLozQqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SvxtZWNPq1WA9M2eGrGyRk8+RKdCdXKg/g6PGmX9aq3Od//nYynxwpvYVv1Yu5QFasWfo0n9/xfiK8qUsii6l6/lnxLT7i2xrBlHvxgW61aejjpPqnp6E4e2uANpCkarCXLgtZcYt6l5pT4sDu/DirsfMO0JNnjzqjqcxO3njt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KvzFyEHY; arc=fail smtp.client-ip=52.101.61.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KvzFyEHY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BqmxOa5AkXzbMhUs/D1suQI/p5dTdJcxzGhxBhzloD+OweFziwJmI0xDwcmWsJbdx9Qt8hj+/oZBwhn6D1qJMs2m++Tnm9xRhXhEoYtVHypmk/gecnw5cwVspZAGSmI3IBNoURK1UBXQ3H0kWiXQ1JEsnXrjUWSYJDlihzrvVlED60DHrJFv0xbNFRcEhiSLv8Ia7n4rERR1S5ohMh+aQx7zrdG1zH7N2kkGCsUhw8LfjZnbpsGUPenTKt6QFj5kjz6K+WW9fVKJ9l2TKi4HyPUORMntjjtpiqGZzPuOKnbiZQiqlKURpvmZsMBCPUhH4e0ly+N0TKUBnFH/bLfA7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ypUYRVhPfTMcbnJOo9JuHej7v338bwFhBtvqsQrsN9o=;
 b=xLyrCwlOS5wklEob4v5MiYeP6DbiwXbw8jwCHWNQ71cF93i4olK0lf0h4DWf8O0vScCvwSM4RPezfuJcrGpGlnd+C2NNuT4z6EyaYyFu/pH33uLYn0fNu82sC2dRRVm7FH13Hawl09BhxFHHOb0qUDUNypFWnEfdN4Dcvov5X/rdjGmVExppxkFKw1TigTijv58tOWaGn8fPWvJDET+D72bjcWL/OiSlj5D9nxWPgSdoErPtzpWKfPTM47o2YZtaGyBwxnX/JdXmrfV5V30RFi571JApwaGhmmli3g1oYykXIrwyYxQOpO5b/p23UnJKCKF/GMfufpd/3+NOOMKKbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypUYRVhPfTMcbnJOo9JuHej7v338bwFhBtvqsQrsN9o=;
 b=KvzFyEHYtYD7SvlmK3EqKWMt9qtRW1KYhsaVFoj7iSPgtlNQRZlOnq+TWNJ1bLjjS+HWnho67yOnzyXroLDxiqiTc1+rUw8+lfUuSp3EBnBP7Df7fKGTkIRs+PWl/dwz75tUFbG6CBzO4fIgHuq80ri1fMzdqNyKGTrdFEVXZ4X7GZgzUOh5HYWYgKQu5z39xitW3iiuO1PIUJjIwIiStKIQvG68G2CKTwCzswfA0zMeCz6MGBhB5qi+b+S0AFbn81xu3+5VRpenQbd3aiRHisIu0PG1dEkbsQ2jmrhcE/37XY+9oAfM7MJ4P0SE+Aq2tMjhQh4XdVhRRmCS25zuuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by PH7PR12MB8055.namprd12.prod.outlook.com (2603:10b6:510:268::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.20; Thu, 23 Apr
 2026 02:51:17 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9846.019; Thu, 23 Apr 2026
 02:51:15 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: willy@infradead.org, songliubraving@fb.com, clm@fb.com, dsterba@suse.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v3 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
Date: Wed, 22 Apr 2026 22:51:04 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <20BA865A-1B69-48DA-BE12-9BFC6EA5A4CE@nvidia.com>
In-Reply-To: <20260423024324.51588-1-lance.yang@linux.dev>
References: <20260418024429.4055056-2-ziy@nvidia.com>
 <20260423024324.51588-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR22CA0007.namprd22.prod.outlook.com
 (2603:10b6:208:238::12) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|PH7PR12MB8055:EE_
X-MS-Office365-Filtering-Correlation-Id: d9920067-f24c-427a-788a-08dea0e32fd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wJjaXHonrxMP6LJrucwLtfvM2fT/Iy41rYKy9PMvyLtmuY4iEAdbHF9QsSNlicA0VBWLCSwIBcA3/qZkHDDEScHCGwAJ2Vkkm0s9FT5fasTqxS6fYiCbjVipUqd63LxkN/DGmYOnjYwznITvtA7jiYJmGKPt3J8MZAFIGyY2XGKYc5v6J5RJw7lsubZGWdVmMzD7CqI2LGRUDbMDLgag3QemOQyAAymwUqyOxOXtoWu/FK166T2wGyRYqom7uNCt+eFDSFT5YfjzkAjsQeDxQFL+OTP0U/QiJfF+kW1HLIAtlOVPhd8uDL57Zx8MwGG4YxoZlsv9wmF9JJR/iwLxDY5fnVtiLUzi54wvs73npVPSTIMyFT+iHsUTH+1sNQO3arM/4Z//t0+t0kXreBGQq2UQh+NRmawGDMnfGeASK6vU7rNB8H6W/C0bGFWicyHiThM4fvdal5Uk4oRcWjdr0b4Bi8TVo7eZ3KO37hLb41wq3djowxx1t2FGllIiijjDE9RX9W2G4CvBsfNc4U2RVa88WeESu3GD8skZHpHLckxD0o8TqQXoq74NRykqaBM6SLQW16xf/2/WStBMLLdPtUqOQN8eMIPANx8Av3DD8KvcFVhVA2tkwSJECOaJ9v5q/K43pqAY3AvKSpvjIMRAMUoLq34W7C8tyt/7AThZbw7AaurSQSI2jyXR4l5qapCocb8pkrEpcs6LlSIGRDLDBrsHI+A819TOGf1Nz4tjF/4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZGRJNzI2TXFYZzZqR1FETkJhVzhvak40Uy9LQ0FZb1h6NjhZVlJwWGJmVnd0?=
 =?utf-8?B?Mm1vdGxnV1hDSDZOMVEwSkRuWXYvZ2cxa3IrRitYTzl6YlVidmNISVh0OExt?=
 =?utf-8?B?UnFaNTB1SVZWMEJGVXYxbDdRSEk3bFpwRGRHZGZrSWdDMUJrTEhNWHJ1K0U1?=
 =?utf-8?B?MnluUFNybEk3N0FBQUZ6UWEvS3YzNTBwbmxvSUt2UW9ITFI5OFFnQnVJa1Z2?=
 =?utf-8?B?a3ROdTkyQXYyUmZtY1dpYnc5clN4R1VBV2hZcTNBZWU5ZmdnSXdzV3ZYcHk4?=
 =?utf-8?B?VHc3bjZZaVYyY0FjTW0rY1JtUWRjT0psVnQvYmtyQnpvNUd2N2Nya0xlNVA3?=
 =?utf-8?B?SXExc0FRMURpQUhFdVY1RlQ2Y0Nyb2dTZnBiQUVjU2pLVmJORytQNEhFVklv?=
 =?utf-8?B?REQwY0MxcEtERW9RRUlpYWpPdG5CZklvZURpR09QUFVMMmZxemxuaEtrWnB2?=
 =?utf-8?B?YzR0cjJhZTJZeVhOOUpCZkxnQlAyV1VZcS9vTjdCbU9yYmNpQS9KR0R5YUEy?=
 =?utf-8?B?ajhqL09QTVhGYU1OZUhveWh3Z29VM1JzZlNyb1hiZ1RaWVpJZE41bnNZaE8w?=
 =?utf-8?B?OVdIWmxUT3ZXTTluNjd5R3l3QXJRVmtENkVNTzFFZm9Oazl2NHFnVnVFeGNM?=
 =?utf-8?B?T25laVRiVm84a2w3VGwzcFhmVFFicGxJTEY0UW9Eb3kzcjVOU29XYW9lREhQ?=
 =?utf-8?B?YXU4OXpob3gyeE5EKzFyN25oMGFpRnVQajBMRnRDdHMvcTRvVzZsM29JZ3BC?=
 =?utf-8?B?S0Y2T0JoQUk1cVlxUVVmVmhWRFZzVkw0ZTdnREZNSGdVSVlqdUhtTWM4RUdu?=
 =?utf-8?B?bmMySXdQQ2VtcUM3NG5HTEFWUE9ZRVZaK3JnclYvV2hKQnBHdEhnZzVZcFdy?=
 =?utf-8?B?eGgveEIrQzUwVmp6WWtKdEFzZ0hJRXEya1MyV0tTbUV1bXY3Q0RwZlMycDVI?=
 =?utf-8?B?WFdZMFE2QWdGRFd6TWNVZ0NKeVp5U0NHMTRyYVdrNzkrOFBDS25YZmpTaU0x?=
 =?utf-8?B?eWQ4QkZuQy9iUTZNekptb21tdzU1Q1ZFQXJLdjhYUnlUbnAvNHlmMGpvTFc0?=
 =?utf-8?B?dHIrWmhLNlBlZ2MrVU9yU1BmamxFN1F1c0t4VHJBUFY0R3pBaWVpZUpGUHZl?=
 =?utf-8?B?YjB2WkNTY3E1NVl5T3BqZ0lNeWwzZjhlandJSlpUZGhOenpKUjNKVVR6TXZV?=
 =?utf-8?B?SlV5LzFLWTVwV1hMVzJjSUVRVVg4cm53WElKSnRIM0s5YnI4UjVDQWV6aDQr?=
 =?utf-8?B?YmRscE1pcHhONmlPVURmTnBiaWY5V2xpcXFRdUpLSi9YMmg0Ym51Q1piRjNk?=
 =?utf-8?B?SncrVk5FeG1qU0pMc1BYek5HSTRpYzBaVG1PWjFjY0lDUE9mQzRPeUJOd3l4?=
 =?utf-8?B?bGVaWERKNXhqWkFtOUsvZTVTRnBmOVRoUlBNbjZqUXZwVjBUa1ZCZ3gxM1FD?=
 =?utf-8?B?SXVaOFp0czhLRHFuTFZvZFVpTkJ2cXZJQUl2THRIanhHUU9aaysxN3B4bGxK?=
 =?utf-8?B?eGIrZFU5ZTA2VGc2b1VPWjU4cThTMyttczBTdCtiVldPM25UN3RWdXBEcERX?=
 =?utf-8?B?VExQNktCY3JWdUpnREtzZ0FqYlVQbU1iNi9ET2F5T0VWRHpRWmtqQU83RVND?=
 =?utf-8?B?VjJlTG10ZDFMNnB3RjN2cThLN3NWbTFqTU1SdkRrc1cwTGhDMVZGOFM2bkxB?=
 =?utf-8?B?VU9lN3k5aHd6cG0yS09JellDK2VBU1E4dzZQbFpNRW1IN3ZXTk1Cb0xGQyts?=
 =?utf-8?B?Snk0QTIxeVBUTHNsTXRJT0cvRVFRZjYrbHNzRnR1WnA0cGNzNkRVZTVmVkVs?=
 =?utf-8?B?WHg5STZxazdRa2sxa0p3Mmo5aTRvVEVFdVp1VHAyT0J4b2VVaUZrUkhGazNN?=
 =?utf-8?B?WWlKa0p5cjBNY1lqV1Y3S2k0dkFxNm5rUU9pTkN2T3YwRE1XeGJPMGpxaXl5?=
 =?utf-8?B?Vjk1WkYxTlBCUlU5RmZxZDNqQk1jTDhHc2xuOWRmV04ySjN4VENIUy8zQ1Vl?=
 =?utf-8?B?Nllsd0VOWjMwbzBCcjhxK01oUU9LczRRc21SellCME5GamVJTml4V3FvelY5?=
 =?utf-8?B?MmMxdmJRWXRobUVxWDRnQk5ZL3NPcTBXNUNQeHBSdFB3YXhFYXdERWZidnh0?=
 =?utf-8?B?N01JMHlwVU5jb1MxbTQ4d0NyblZFa0VkS2tSdVJkVXBuaUVzMkFVam1Bazl3?=
 =?utf-8?B?eVo1TXdFazJzaEhMem5nM1BIeTBzOGd2WWVtYzJyYTFmRVIzTGluSEplQ1I1?=
 =?utf-8?B?MTJ0czBQWEZOK3NHbFFWS0JoMm5rM3VDbVhsQ0hZTjQzSGZReDlNU0NRS2w1?=
 =?utf-8?B?TlZhaHB1c1lFaERKTnlDYVhJRkZpK2k2QkMrMWN0YWRLZGdyYlNyQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9920067-f24c-427a-788a-08dea0e32fd2
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 02:51:15.5144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L6sRmQUn5ttpq/KsZzUy0ynIsz5ikE4L/GLpjAqNlkJpoSsQE60OEcHvfnCAQmUt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8055

On 22 Apr 2026, at 22:43, Lance Yang wrote:

> On Fri, Apr 17, 2026 at 10:44:18PM -0400, Zi Yan wrote:
>> collapse_file() requires FSes supporting large folio with at least
>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
>>
>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>>
>> Add a helper function mapping_pmd_thp_support() for FSes supporting larg=
e
>> folio with at least PMD_ORDER.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>> include/linux/pagemap.h | 10 ++++++++++
>> mm/khugepaged.c         |  5 +++--
>> 2 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>> index ec442af3f886..c3cb1ec982cd 100644
>> --- a/include/linux/pagemap.h
>> +++ b/include/linux/pagemap.h
>> @@ -524,6 +524,16 @@ static inline bool mapping_large_folio_support(cons=
t struct address_space *mappi
>> 	return mapping_max_folio_order(mapping) > 0;
>> }
>>
>> +static inline bool mapping_pmd_thp_support(const struct address_space *=
mapping)
>> +{
>> +	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
>> +	VM_WARN_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON,
>> +			"Anonymous mapping always supports PMD THP");
>
> Nit: afraid not, at least when running on architectures without PMD leaf
> entries ...
>
> Maybe better to say this helper is only meaningful for pagecache-backed
> mappings. Anonymous mappings should not reach here.

Good suggestion. Will fix it.

>
>> +
>> +	return mapping_max_folio_order(mapping) >=3D PMD_ORDER;
>> +}
>> +
>> +
>> /* Return the maximum folio size for this pagecache mapping, in bytes. *=
/
>> static inline size_t mapping_max_folio_size(const struct address_space *=
mapping)
>> {
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index b8452dbdb043..3eb5d982d3d3 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -1892,8 +1892,9 @@ static enum scan_result collapse_file(struct mm_st=
ruct *mm, unsigned long addr,
>> 	int nr_none =3D 0;
>> 	bool is_shmem =3D shmem_file(file);
>>
>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>> +	/* MADV_COLLAPSE ignores shmem huge config, so do not check shmem */
>> +	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_thp_support(mapping));
>
> With [1], can we drop !is_shmem here as well? shmem would then always
> call mapping_set_large_folios(inode->i_mapping):
>
> ---8<---
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 4ecefe02881d..dafbea53b22d 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3087,10 +3087,7 @@ static struct inode *__shmem_get_inode(struct mnt_=
idmap *idmap,
>  	cache_no_acl(inode);
>  	if (sbinfo->noswap)
>  		mapping_set_unevictable(inode->i_mapping);
> -
> -	/* Don't consider 'deny' for emergencies and 'force' for testing */
> -	if (sbinfo->huge)
> -		mapping_set_large_folios(inode->i_mapping);
> +	mapping_set_large_folios(inode->i_mapping);
>
>  	switch (mode & S_IFMT) {
>  	default:
> --
>
> But we can do that in a follow-up, once the revert lands :)

Right. That would make this patchset depend on Baolin=E2=80=99s fix. A foll=
ow-up
patch is easier for managing these patches. I will add a TODO in the
comment, so that we will not forget. Thank you for the suggestion.

>
> [1] https://lore.kernel.org/linux-mm/b2c7deee259a94b0d00a7c320d8d24d2c421=
f761.1776908112.git.baolin.wang@linux.alibaba.com/


Best Regards,
Yan, Zi
