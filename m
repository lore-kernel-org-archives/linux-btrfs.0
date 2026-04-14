Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013016.outbound.protection.outlook.com [40.93.196.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7AF2BE03B;
	Tue, 14 Apr 2026 15:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776182388; cv=fail; b=fprh5dnQ1+BjDKi9WwbemaHJuwdrwIGPs6/SAlMx3pRzR4jdyClkjTVCeUbCLkaTmECc6HTFWDMlKgonPuqoHrWupu72GpXXYfdaH/wVANvnCcZf6AbjEQZN0hK7HLBCex9Ic6iOUW/S1IO+N2Fjl97ozMu0y5eev6MpaUC9eag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776182388; c=relaxed/simple;
	bh=1YgTxJfFBGdNZ7vvfOBE1FMk2x2jqrrZg06a79lk99Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S8d7340Kc8fl6dU+n8MQPj7Je6zB1dg2jKL6A6nWfq8pZIOugCNPBbjqJWNDnqtZlqp0g5iiST9Us1EHR9us4cU1JEz5Ap8u7CQiifcpvZEdpCyOS2cqQx5bA2wK708NMXEvnRltEzMhPDqo4IOgf0fdjLaxlEvIBzgPcWzVeMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PcKmss9k; arc=fail smtp.client-ip=40.93.196.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PcKmss9k"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TPxq7IL0N9dWJ71U0mwdGxpVf//9fajcWaKSWzLelIgydfTMmfjwYpo+6YvYPAhuSYC36q3VBqg8yPKq3udIYxzqYWVfd6qex+7/naG356CNfdxieuo/ACX5fdwGU4T3hnxtaxhDLExT84uQ+P1mnxCjYPjy1Cfj4t1vdZkWPaWpNfGt6ss4H9MIvvRiQpgOVX+OL0Rw6qdbPMrdPjPo7LXIDmRn96fKbxtlWrXEUwiMfjsi6Sz/MdIiwL51bQiylQ+/XPySlbEZuw3kAZYiAItZXHHFjYsmKlkhsd5JvsKoD+Cn/6s4youMZSgrzUzlHJkSahZdLumJIEISzHcy7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MHDXacRDow78n9fJ7nID0P2z698rRFzvQ7xqfgOso9g=;
 b=GSLMg3md7qt7IqrGxie5QytpgvdhNOXZVM3MzCJdbNdAN2BCJBkidULMY88Cs7WuteO5NW67nt4GBvhFTYUb++LKCznecyTNE7Vre7z71zc+gTUdx6eUB58IHZTPYtTo1blUZ5VtGufek8omQYnVM6zr9dSy//GoQ66kg6MeyVE9pNTUhwbE66dfKpG4Gqh71EvDkSfc9zEh6llGkR3QoaVTChp1PKh3hU0Ie4ZiIhH84EGFayGNDzWg6ZuVxt71quA2Luz8TAG+rQ5jGlLuyn86ZvxkWY3puUNhtudgeyVPgNOydzy0h4QM6cz7pbmx8lWnCovyRV5ffP8PcCjZzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHDXacRDow78n9fJ7nID0P2z698rRFzvQ7xqfgOso9g=;
 b=PcKmss9k5CR17t+CqiAI0SicUSSI8ODWXCjtMHcux+WItbmDEtthQc2FdvNJnLT/WvCCVMUDPqmg1uwBi1R2VmUwogzuBxt7kq05ixXlMnfQAt7xSh8Y+RY312ezVkTHuqGqD7w1/klBe+lXNUicZ4PNmSKdwHvkmd8leqLyD9/+vfCt+7XH7aKtQ2WKkZQHavqqegmkoTwJmFhwzS+gefmFr4fjkTJeqPgT9HHXlNNcDSqZqv6KLME7qG+TO2sD3n5MbFBKvDg6tGYRZ8zdrXJYJ9AhGZLU4IZOyUDh1z34J0jyPRU2Z3Ho96nlBMpeDrOY6DYDuUJGkz65NiGq2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6226.namprd12.prod.outlook.com (2603:10b6:930:22::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Tue, 14 Apr 2026 15:59:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 15:59:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>, david@kernel.org
Cc: willy@infradead.org, songliubraving@fb.com, clm@fb.com, dsterba@suse.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 akpm@linux-foundation.org, ljs@kernel.org, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
Date: Tue, 14 Apr 2026 11:59:36 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <BCE29F77-5B07-4089-83BB-A412CDD65E3A@nvidia.com>
In-Reply-To: <20260414154316.42935-1-lance.yang@linux.dev>
References: <20260414153724.35950-1-lance.yang@linux.dev>
 <20260414154316.42935-1-lance.yang@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0PR02CA0028.namprd02.prod.outlook.com
 (2603:10b6:208:530::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6226:EE_
X-MS-Office365-Filtering-Correlation-Id: 505fc7c2-f5d8-40eb-ae89-08de9a3ed5c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+nQdTT3KUnyymo7pe8ioQeMgCNNtvokDlsZ0HTw6Pffqutq3358Naj9g6qwCYStPMveVD1bazesqXSmpSdza4FNJFm8QjKEhlg8BnFwhxzQoVJ6F7EwaxQF/ZbaNdPV0SYGVpjPlMq7h3CC3mlqr4WX2B+r7F5S7ZFHg8WcdzoXFMmuQ40DIzP086/6FHcsdO+GsgbASFK/H4LT69MyOlDYL2Fy25e4co8CxpSvJtGIDBHRpbKCrk2XxuZcKYAKujkQrb00cEGnC4n85vsRhmv+as9pyjo71AnNCgLzgAOSUG5yPUWQpi21y0JEC7XW7YeXCUCSe3AtNoBaGIefmOtbeu2QVXRErX+x6P9L2YpTSh1GkSQcmWu4Rt91Qk5j5RKfDaOXBPf5bZSBobl3jgshFhCM4lIDNQt2hywKTzZXrMDVrKb57mOAoev4xWkqKHqxQ6TJQhBa/ElQLN7jYH6C5hUwaMwGOxFjIzCjlN7pjGf5x+Jb30yU/R5c5ceGa3cJyH5GFyYV/ytsEMcmp5+JzODja3EZGRVKBqQw2Kl9K5wuV4gyhe2FQj5ZwAteVMZq+RLOuSV5Vo3XWjEfLpawsBlj/AR4itI7PbL2j2iAAGyi1dTG7XX004q4KuHud3JXKRItRGcLd9sdguhINxIWH8wCiqn5lhwTNeqqMMYYlYpgon4iVOWXcFv8zMp3h/n4sTR6tepejlMBKvz0qcrlTfIWnnexYOn1kUrTY2gk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1UrOt0CsFZGJbvdo7HpMVHq0hjiJTmAfPd8qBccKUDh49+L7PZtG1JTTKHkd?=
 =?us-ascii?Q?Tlr/V8nYEvDk3F9/15UKjBagSk0ZqZUcoMVQrk6YG2G5/iNp6A7jHr1S2EQL?=
 =?us-ascii?Q?fcJusHDsqTclpzKev2vwaQemCBVjErh1RH8uFqe0NeZUEjKZVNUS8EyI+N7G?=
 =?us-ascii?Q?kYLL2CPY+CGbl4OBt38HPqovGrk71P3rMhUX0isinIQ4YGhpz+2dqimhSi2r?=
 =?us-ascii?Q?/W/TQVIpth57Z2oTzqnvg3dOX3xn0Tn65HapTEsg714qoNFV7ragpmxUkYqz?=
 =?us-ascii?Q?CJotnrZb1uAATyODvO+VlhlUx9pAXwQN1iN4q8FxeL+m6yt2EjjhAvnEtgQY?=
 =?us-ascii?Q?WOj3V38iTnyZfkdfhBPkGueyTEQkHihTdG1QbVjEaczXh7SR0K6RMxYyooUY?=
 =?us-ascii?Q?OiKUgSHBEkfe2jGXeQnMKqm/ch/2BIzBJOP6GRPSKKFoGlBP1MVWAAB2Hwj+?=
 =?us-ascii?Q?kVe/5md/trI7QQNWDrrZpma8ixNU51oLqpoNLV7XWRhNECtM/sw9MZ04EgIS?=
 =?us-ascii?Q?3OkXQ+yKF8SknXSDrHc6e/p6aRKLEOrLHsSNaGx+W6tGlM4TFsv2ajzASG61?=
 =?us-ascii?Q?Hs5qO7NHzI5Y9PBfPMb6ZQ/siFSUzDXgGleg/ItCWQGaOoOJvUznu/e7CYMg?=
 =?us-ascii?Q?P87poHwDs2RZNngoc4RBSNspk7UwmYze8qUoefOLZskR9JgZkrXmZx5kMAq+?=
 =?us-ascii?Q?Z1YkAB9hRQff1thiqy98f6OJGP+xzS5eZJ2oOVgUbE3ac/q47qU8VJ8HQHDM?=
 =?us-ascii?Q?wSwdhrTqvFu81D2mHXIQ2jOgJO7GVq1OBSD8kNk07zmX6X4d1TKLAFWzPp5I?=
 =?us-ascii?Q?lyr1xVVvK+kZg+qnWL8s7ENBqDRHLjz+sYOUBYnYUPQ/nxE4owwMi5mpyY5J?=
 =?us-ascii?Q?ri4LJl0Snw3mulg+zMxcbNL4wlTK8U5XW2hub5qTRUk8Lcy7HcintdgmgMja?=
 =?us-ascii?Q?oVHqh9odRVKMPWfYwketTDkhvcmUOWSUwFHH0h1bdLXw9i3FjN6GTVfmE3W/?=
 =?us-ascii?Q?oml4kFHRi1Hr7TkjqGmf8kda0Ceyxel9yF4x6yFPoFY3cCWm0ArNMgFK/Cm3?=
 =?us-ascii?Q?q4AAfm0YXYafiOYz00r7DpeeCEA+wF/e3laugc1YNs1nTsgiitfzb4EwebA8?=
 =?us-ascii?Q?sdfgXR1SkKB03KQEBUtVbl89KkeujMuIltmVlEfyYlOtsie+XSXiYrkKqYTG?=
 =?us-ascii?Q?pjnaW2RV5TnUTO110XaUc5soaarFHF4AJ+H0VjTgVQ68zRyMsxZJ+9NmOTk5?=
 =?us-ascii?Q?L4iusAYfgDQfLOI+TvM1ethD9+g/QfooxiQucg4bVz2vW19AgEXEocbnJAAq?=
 =?us-ascii?Q?AHUPeQBZze3nHbM/QbmKF+2M5o8gnfxxNqIGBPNEoCMCAajIuVqtgIcIZKCc?=
 =?us-ascii?Q?3T5wER5tjliO864RYQ36l7k+bNA4G3f3zn/9xB/pyjcB5NP6QPAngSvzqKA9?=
 =?us-ascii?Q?qCqE7pisHEdHXh2sDEikWocdLOG1Z9EIM+wMHZHAouktys2oAqgZPdBDT8TL?=
 =?us-ascii?Q?6g8SmIOcGFEViKdPP7JD4q10bYx0YceHTKnr98PpmyMS3ZKUHkZ5IVqcmDXs?=
 =?us-ascii?Q?//ddnRU4z6dXPwrfWLmQWM74Su3dM57naITRyLghYScvTI6hvVEnS+hkK6ZT?=
 =?us-ascii?Q?8m2PcbqX4ywQbG+ZPlz608u3Gd1HHyxpXmzP0dfvvgMnQuSIYpE4OkEOFpBf?=
 =?us-ascii?Q?weMoAiNP8ybE3xcUa1RbLiNBdVDDvOH9xdWCltvQncx2GhuTZcuYCgemuUzd?=
 =?us-ascii?Q?OfpE+Bi9ew=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 505fc7c2-f5d8-40eb-ae89-08de9a3ed5c1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 15:59:39.9233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YrhZRNYLu6WwsdxMsTxWTWwwxMthehq18GnL6FhAiFah3o0lGBv56fK6avX8MUem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6226

On 14 Apr 2026, at 11:43, Lance Yang wrote:

> On Tue, Apr 14, 2026 at 11:37:24PM +0800, Lance Yang wrote:
>>
>> On Tue, Apr 14, 2026 at 12:29:04PM +0200, David Hildenbrand (Arm) wrot=
e:
>>> On 4/13/26 21:20, Zi Yan wrote:
>>>> collapse_file() requires FSes supporting large folio with at least
>>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>>>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for sh=
mem.
>>>>
>>>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>>>>
>>>> In collapse_scan_file(), add FS eligibility check to avoid redundant=
 scans.
>>>>
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>> ---
>>>>  mm/khugepaged.c | 12 ++++++++++--
>>>>  1 file changed, 10 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index b8452dbdb043..d2f0acd2dac2 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -1892,8 +1892,9 @@ static enum scan_result collapse_file(struct m=
m_struct *mm, unsigned long addr,
>>>>  	int nr_none =3D 0;
>>>>  	bool is_shmem =3D shmem_file(file);
>>>>
>>>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>>>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>>>> +	/* MADV_COLLAPSE ignores shmem huge config, so do not check shmem =
*/
>>>> +	VM_WARN_ON_ONCE(!is_shmem && mapping_max_folio_order(mapping) < PM=
D_ORDER);
>>>> +	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
>>>>
>>>>  	result =3D alloc_charge_folio(&new_folio, mm, cc);
>>>>  	if (result !=3D SCAN_SUCCEED)
>>>> @@ -2321,6 +2322,13 @@ static enum scan_result collapse_scan_file(st=
ruct mm_struct *mm,
>>>>  	int node =3D NUMA_NO_NODE;
>>>>  	enum scan_result result =3D SCAN_SUCCEED;
>>>>
>>>> +	/*
>>>> +	 * skip files without PMD-order folio support
>>>> +	 * do not check shmem, since MADV_COLLAPSE ignores shmem huge conf=
ig
>>>> +	 */
>>>
>>> How is the !collapse path handled? Through thp_vma_allowable_order() =
in
>>> collapse_scan_mm_slot()?
>>>
>>> Wouldn't it be better to have that check exactly there?
>>
>> Right! Looks like patch #03[1] already does that, as David also pointe=
d
>> out there :)
>>
>> With that in place, regular files should end up in file_thp_enabled(),=

>> which checks that mapping_max_folio_order() >=3D PMD_ORDER.
>
> Forgot to add:
>
> thp_vma_allowable_order()
> 	-> file_thp_enabled()
> 	-> mapping_max_folio_order() check
>
>> For khugepaged, collapse_scan_mm_slot() calls thp_vma_allowable_order(=
)
>> before entering the per-PMD scan loop, so ineligible regular file VMAs=

>> should already get filtered there.
>>
>> madvise_collapse() also calls thp_vma_allowable_order() early, so it
>> should get the same filtering before reaching collapse_scan_file().
>>
>> So the extra check here looks redundant :)
>>
>> [1] https://lore.kernel.org/linux-mm/20260413192030.3275825-4-ziy@nvid=
ia.com/
>>

Right. Will remove the extra check from collapse_scan_file().

Best Regards,
Yan, Zi
