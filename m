Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012071.outbound.protection.outlook.com [52.101.53.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DDA318B96;
	Tue, 14 Apr 2026 18:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776191157; cv=fail; b=UeuFVuwjexrWo6sOpHbg7OzdNAxJvABtQb9A91YgPJatztjX6y2wHqFAaLyHIdJy8XFs0/bTD7sWT4m4zSirGW8iJNC95mSE795Fdh3Mz2syPkSgOgVI7ky5iIsQsVQMZStW6106JJtv8DyAC4uEK02Jnw8EupF10GLINxWBffU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776191157; c=relaxed/simple;
	bh=zDJzyQtie7akrZvJJYJCXg3vUCXExNFthQ/Bf8cnnZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ftRC/LfAH4gciVld7Y5cK/wchm/Bx+m0pX1eKNNHdlkoLuZc0fkdzIWkOmUNgzVfTudrWJ1Vtn2vekunZ0kSnPdIFxMM/pNPAjsHg5aZB6S2BkNv+w2RLF3TKcQOuepYaukgZvp7Q3sTGiwS5jOXTGFxRfbz/TL6O5u/lnkZFOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eIbzvJwk; arc=fail smtp.client-ip=52.101.53.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eIbzvJwk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EZODTic50wbeB3dulKYdbQC9OB4vCi5iQp/GpDwGaeUSSzCz+QElCXrpMB87gnLtkipptuEdMGwNIOk564AMgYdQXCs47Y6FdFnYpHIbgCaFsZar21YuFaGBPZZHOan7fWryQAuSik/ml0F0kcFeA+gXneOsiVGwyW8ClItGNK9TcWpCx+rnoAnM599p3xYPjfAc5EmZG0HzzdMHHHkKy4Jt5EOqaHGUPaWSwYEFvw+luBmq2h56B7JnuB+9FDXptUR6ZqtL2wnN76l1jhZZwCiQjHP96jWuXuGhKmjvtEagNTxfwtdjMmN/qCRDhZGotFR8UHyU+9boOU4x8v471Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7Z4el1JHmNCMUQX81yQeE6sokBCtPlVmoOjIWr3+AU=;
 b=O0qXJZbdkPGFg8PFvKYxqKT+W61ulfWWgSkIGnjLAtFxHjxQ1WQeMMRt1rpljLEjb8k1rfs/hmQoA+yLGaHeo/zx/YZANnJ+goP8bbCWbh7DdYX6CBJGGpCOCb1GY8yBhRTvcoI7yzK3L5htZna04ymgn+aKxRF0USIq6go91zMxwFZr3HpQTEV7wpGTIwDwRM6ePIPqqpjujlQAdqOeEMhHisfkhO1uj04BR1fmA/KbcdKISTZIvRGgOmDrqY3EdmcuTfSr1KAzwWI1i9sDFjScyBtvuyI4UwzLtKCXxXst2l0z8b9/kT3CD0HEpSDxyw2CIuR9iZUBJnCvWuqIDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7Z4el1JHmNCMUQX81yQeE6sokBCtPlVmoOjIWr3+AU=;
 b=eIbzvJwkH6yjxuK0u3qoR5MfdPTYRsOelT2/TZODtR70iS6VlRFvwMASSNpptiLQ2paJ4GzDByZIQSc4AIbCMd2R0YSgi5B/97r5x1HlJ6VmScnmi1DC00aNLQEbMXKWlK/m2EN6FHWTtyzjxMhNswyDRuqYZcTThsLvfoyKgBVG3OBkqD9xDV4jBFof/clcl0lJLV4zm0xX0LWAaAe8Zy0OE4GrFSSh7clapUqxB3W9PqFbVicio3BxV3N0Gl/eSh91JKdXhfmK2HTKp4Q5dJ4j4U/82jfDQr2x2+2140XJnRqeFrv1z1jclgfTASsq/iDLn06nBceOQxFaVK18Xw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9714.namprd12.prod.outlook.com (2603:10b6:408:2a0::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.18; Tue, 14 Apr 2026 18:25:51 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 18:25:51 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Nico Pache <npache@redhat.com>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
Date: Tue, 14 Apr 2026 14:25:48 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <7468C68E-FB09-4714-94A3-4BED63453295@nvidia.com>
In-Reply-To: <998c02b6-2612-42c1-8099-d65ae275d1a2@kernel.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-6-ziy@nvidia.com>
 <ad1TMjF1L3usYIC5@casper.infradead.org>
 <05F00072-7E06-47C9-BC26-FE3736F557FC@nvidia.com>
 <a4d477a8-71d8-4219-9cb3-153f2c01e184@kernel.org>
 <84B8F641-A3DF-4219-AA57-6BA48E9B4998@nvidia.com>
 <998c02b6-2612-42c1-8099-d65ae275d1a2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: DM6PR02CA0146.namprd02.prod.outlook.com
 (2603:10b6:5:332::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9714:EE_
X-MS-Office365-Filtering-Correlation-Id: 601fbc05-20e8-4cd7-f407-08de9a534206
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Hbobht/coJty88R15dyuJHUwSANztCT8V0RJqcTaAF4tlKbMxZU0D+DwoOoJsx2N3rFFWruG9Ni8kIXxW9ALIlABanFJGPhSbXtVAcYgyrrIWhGCa1Fo9jJbATQfy3eIjP758SMyL3lJAvgRKURLMA8SJsBTA9qhQiKVz2OE5Fxva9toca4SMtszTAZrHGzwQrvVOlfBtXKyi4LWDciJO79pws545YpYR0fW0NMX8/rOdc1kZuaUA3BWgB/czujLUoqHASjxzsOoX3vRZ+KXvge8RlxBAUal2U83MxziWLzxnwWzqjeuvzWoePVMgwBkzMxnW0l4RSOKVRs8opHrlK5svy7DZ3izOFFtF3FWJCoHgO1D9nFujnqfdNALlqI+uUWp88UETiVW6k3nzDDUNqmWXHmyYQcZTsjeyvYp3iCwSVOu9nHEZhC3Rk2M28T7CaHargOjfjOSEYgRNE5hxfHwlnic2gaZ6rYfJRFpZpT6YYuHv6LtxNZBFQYztazaVj511Zh+8+LCKPBQ8m8+WtJw9hjtpUjvshQ7QAakV7C40zDndQSQ1IJ+k3DRFRc4N2rs7xrof84h5rFMQ/CxHhHfHNf1NEusdySJMMMmLqnqa8QQ8I6owiMuiJ0G+g9LBztrFnBg/THT1P9Kgsad6pvn22xo+eib5Yc5tr7ni5cGvYz6GwTiC2QU3ig3lVLfBJwIUeiScuRUUwK18TWje0J+sHG/Cr+tEctrQYccAAA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bldsRDVEeFVIanhUTXhIeE54MkxkMVZGM2N3cmoycnFXRkFxd3o4VlBwTW1H?=
 =?utf-8?B?QzFpcVBUc3MrNE9pU2FFQ0hoZzl0ME1XeE9pYVYraUNMRktZUWgzeXN1SzhC?=
 =?utf-8?B?QTlTWTVVMXNOa1FidDdyb1JqaThGYkRiZ2ZUUTlqbkhlTHkvQ2xUNVFqOVNs?=
 =?utf-8?B?T1pzM29XRVpPUDFOMW9VQjdXSGNVdGxxaWp5NjN0a3VWUnd1a1VvVVp6OGNq?=
 =?utf-8?B?YmNQaUF3V091dFNXTEdkTzRZTTRnNit4OEwwL1lXMEd6aWJkSzJ1UHNHNzJm?=
 =?utf-8?B?QVVkRUR1bkk3OVdzK2tiUnVOOHpIZDFBRVU0R202QlpSRFlKS3hycjUrTThi?=
 =?utf-8?B?NDdpc0RCUnZ0akI1aSs5WW9FWkxIaGlYVFZTcU9CdGVPSHd3SGsyUHF1dXBL?=
 =?utf-8?B?Q09TeGxSQXh2ckVtWXdIbXZoazNvN2h3a3VpRklSSC9MZzVZekEzYUt2SllE?=
 =?utf-8?B?OXB0bmRpZjRsNjlITitoSnRYY0hlVitaT0VzSS9RT0R3Z0xpUlJOUHgwaEpW?=
 =?utf-8?B?TWliNzFQRWtIbzZ3cHRyb25VVjlnWjdQRjBwbVJSWHF4aW5Ka2hlOTd4djFt?=
 =?utf-8?B?SFN6Z29aZTF4M3hOYUM3ZFhYSFJCTk9hUit1RmNYRkZvOWlLaEhzd0VOY0ti?=
 =?utf-8?B?VjV2dmM2ZDQwUGpmSWdrSlNSQ1pMbGRNS0hKbG9yTUVVZjdwZE9iZWo3N0Jl?=
 =?utf-8?B?NUtPUGVERlhOci9peWpJaENNSVR3ZTlFbEZQTytSMSt4aFJEV2JCeXloVFdZ?=
 =?utf-8?B?Rzc3OFZoK2xpbmF3Q2RoRDRPY2JKS3dhMExBeWxEOTBvM01VcnJLaW9nUVNw?=
 =?utf-8?B?RDJHZEN2MjN4WjlEL3hjeDBGNnJvSlBoelNHa0t3SWxKRFBSMTJITUI3QjFC?=
 =?utf-8?B?dnUzaTRxM24wVkRRNmd4WCtSMnVJUW1qdHpwNHBkaTZ3ekpJckNmbndwM2dL?=
 =?utf-8?B?akt2aklhcldTS3dxRXJrSjFzQmNDeTdRYmtrNU9GT3ovT0F2YTFFdVIxNUgx?=
 =?utf-8?B?ekJlOGJyRnZKOXo4QzNBbzkybml5eW1IWkxiM0lFTWs2NC9VSmZRSjI0R05a?=
 =?utf-8?B?QWtrUTd1cjN3ZmJyYmVjUm8yd2tpM3JSRTlXZnpKdjgwNXdJbVpsajFaSDYw?=
 =?utf-8?B?ak9UcWY1OG9iN1NCTE1DbzljUy8wZVNhR3czTVBLdzNJTERDZDF5OG9uelox?=
 =?utf-8?B?dUJxTktZd0FrQi80NmMyRDEyK1JEcWdZdmVtNFJhRkJIS0MrL1RuWG1Wc2V6?=
 =?utf-8?B?N3g1MUdsakE5cFozYndFUGoxMkJQaGQyNXFOTnRmM3hwU0kwR1c5aG9oYytD?=
 =?utf-8?B?VnNDOG9iY3kyOXJsL0plMnN3MXd6Umx4NDRLWVoyTkhITElDUGxreDZWWUhq?=
 =?utf-8?B?ZVJ2TWFHVVdTWUZ2ZVJjTGJMbHJ3ait6NzZjT25RY1BpZ1hzREt3blB4VE5x?=
 =?utf-8?B?RUphS1FqTEM4T2IvUm9yZ0dESjU2OGpaY2hCTDNjTW1FTXdnQUxld0dqVXU2?=
 =?utf-8?B?RHd5azZObENpQWFkV0s0U2pUREpubWFOZnhpQjNxK2hFbDIyM0FWQXk5SmNL?=
 =?utf-8?B?Zk1PZzU5aGJCSyswY003UkFMK01yYUkydFBxTVpub0VoRUlhQUh1eG5RbEow?=
 =?utf-8?B?OUIzSGRLUlhhRzJPV3E0ZVQ4ZEE5UmRCVHEyamwxbE1mRTZvcHF2Zmpad0VG?=
 =?utf-8?B?UGJXcHJ4NFZMaUNHMnY4VWVvTUdld2dwMzZYWEtjaVBCZ0d1T2dWZ1Z6SGtu?=
 =?utf-8?B?UHgwOUsyWm5yQzIvcVdERVhwcGZVZkJFS2pYbk1RMXAvU3RkaCtielIyRXJj?=
 =?utf-8?B?NXJDMnB0SThjeVpmVG0vNHI3VUk1Zm1UcjV4SGJqTnFEWGF2OGZJeWJqNHR4?=
 =?utf-8?B?MGQvYnRrdUdIaEJyRkNDRlhNMkdMU2hDUEgzRnI4b0hrNHYxT3BsWkFMRTE4?=
 =?utf-8?B?Z3hYNHpQSUFCN3F1aUtVN0NCSXhla2dybUhyUXFEOUI5aFFCWWJTbUlaQXcx?=
 =?utf-8?B?RGdPOUtrcHQ2bG5hcG9xcG9aWWNidllYZmhqNmJvdTUwSWlibEhqcG5wUzht?=
 =?utf-8?B?Ri9UUFZ2U1hER2FnVGdlVlI3UTBGSUdtOHB2bVRUTExuWGFEcFdBMStMMDd0?=
 =?utf-8?B?dGNnVW04b2orVmFXTEhURnEyYTN0SHEzYXo0ZThXRjEvbGRoS0NIdE5qaEJB?=
 =?utf-8?B?L3JzMGNmNlArN0JqbmFBTXlXQmlUY1BWa0o4aUEyUHdFbEhxQ3BBcEhYNGR3?=
 =?utf-8?B?YTZwUUFUOTJnemxibCtZdkEyNGI3dk94UnJjZ2ZCSjl3OEt0L1pETDhTZUht?=
 =?utf-8?Q?404TsqHg4GGnMCLBwR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 601fbc05-20e8-4cd7-f407-08de9a534206
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 18:25:51.5301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MWmS+rzup1pzxq3625rLXq0nQLUvNWHFLZ+BjJ45lXbxmuZOuokAjYSrdfoq4q38
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9714

On 14 Apr 2026, at 14:14, David Hildenbrand (Arm) wrote:

> On 4/14/26 18:30, Zi Yan wrote:
>> On 14 Apr 2026, at 7:02, David Hildenbrand (Arm) wrote:
>>
>>> On 4/13/26 22:42, Zi Yan wrote:
>>>>
>>>>
>>>
>>> I assume such a change should come before patch #4, as it seems to affe=
ct
>>> the functionality that depended on CONFIG_READ_ONLY_THP_FOR_FS.
>>
>> If the goal is to have a knob of khugepaged for all files, yes I will mo=
ve
>> the change before Patch 4.
>>
>>>
>>>> I thought about this, but it means khugepaged is turned on regardless =
of
>>>> anon and shmem configs. I tend to think the original code was a bug,
>>>> since enabling CONFIG_READ_ONLY_THP_FOR_FS would enable khugepaged all
>>>> the time.
>>>
>>> There might be some FS mapping to collapse? So that makes sense to
>>> some degree.
>>>
>>> I really don't like the side-effects of "/sys/kernel/mm/transparent_hug=
epage/enabled".
>>> Like, enabling khugepaged+PMD for files.
>>>
>>
>> I am not a fan either, but I was not sure about another sysfs knob.
>>
>
> Yeah, it would be better if we could avoid it. But the dependency on the
> global toggle as it is today is a bit weird.
>
>>>>
>>>>
>>>> Alternatives could be:
>>>> 1. to add a file-backed khhugepaged config, but another sysfs?
>>>
>>> Maybe that would be the time to decouple file THP logic from
>>> hugepage_global_enabled()/hugepage_global_always().
>>>
>>> In particular, as pagecache folio allocation doesn't really care about =
__thp_vma_allowable_orders() IIRC.
>>>
>>> I'm thinking about something like the following:
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index b2a6060b3c20..fb3a4fd84fe0 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -184,15 +184,6 @@ unsigned long __thp_vma_allowable_orders(struct vm=
_area_struct *vma,
>>>                                                    forced_collapse);
>>>
>>>         if (!vma_is_anonymous(vma)) {
>>> -               /*
>>> -                * Enforce THP collapse requirements as necessary. Anon=
ymous vmas
>>> -                * were already handled in thp_vma_allowable_orders().
>>> -                */
>>> -               if (!forced_collapse &&
>>> -                   (!hugepage_global_enabled() || (!(vm_flags & VM_HUG=
EPAGE) &&
>>> -                                                   !hugepage_global_al=
ways())))
>>> -                       return 0;
>>> -
>>>                 /*
>>>                  * Trust that ->huge_fault() handlers know what they ar=
e doing
>>>                  * in fault path.
>>
>> Looks reasonable.
>
> I don't think there is other interaction with FS and the global toggle
> besides this and the one you are adjusting, right?
>
>>
>>>
>>> Then, we might indeed just want a khugepaged toggle whether to enable i=
t at
>>> all in files. (or just a toggle to disable khugeapged entirely?)
>>>
>>
>> I think hugepage_global_enabled() should be enough to decide whether khu=
gepaged
>> should run or not.
>
> That would also be an option and would likely avoid other toggles.
>
> So __thp_vma_allowable_orders() would allows THPs in any case for FS,
> but hugepage_global_enabled() would control whether khugepaged runs (for
> fs).
>
> It gives less flexibility, but likely that's ok.
>
>>
>> Currently, we have thp_vma_allowable_orders() to filter each VMAs and I =
do not
>> see a reason to use hugepage_pmd_enabled() to guard khugepaged daemon. I=
 am
>> going to just remove hugepage_pmd_enabled() and replace it with
>> hugepage_global_enabled(). Let me know your thoughts.
>
> Can you send a quick draft of what you have in mind?

From ee9e1c18b41111db7248db7fb64693b91e32255d Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Tue, 14 Apr 2026 14:17:31 -0400
Subject: [PATCH] mm/khugepaged: replace hugepage_pmd_enabled with
 hugepage_global_enabled

thp_vma_allowable_orders() is used to guard khugepaged scanning logic in
collapse_scan_mm_slot() based on enabled THP/mTHP orders by only allowing
PMD_ORDER. hugepage_pmd_enabled() is a duplication of it for khugepaged
start/stop control. Simplify the control by checking
hugepage_global_enabled() instead and let thp_vma_allowable_orders() filter
khugepaged scanning.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/khugepaged.c | 36 ++++++------------------------------
 1 file changed, 6 insertions(+), 30 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..459c486a5a75 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -406,30 +406,6 @@ static inline int collapse_test_exit_or_disable(struct=
 mm_struct *mm)
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }

-static bool hugepage_pmd_enabled(void)
-{
-	/*
-	 * We cover the anon, shmem and the file-backed case here; file-backed
-	 * hugepages, when configured in, are determined by the global control.
-	 * Anon pmd-sized hugepages are determined by the pmd-size control.
-	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
-	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
-	 */
-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	    hugepage_global_enabled())
-		return true;
-	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
-		return true;
-	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
-		return true;
-	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
-	    hugepage_global_enabled())
-		return true;
-	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
-		return true;
-	return false;
-}
-
 void __khugepaged_enter(struct mm_struct *mm)
 {
 	struct mm_slot *slot;
@@ -463,7 +439,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
-	    hugepage_pmd_enabled()) {
+	    hugepage_global_enabled()) {
 		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
 			__khugepaged_enter(vma->vm_mm);
 	}
@@ -2599,7 +2575,7 @@ static void collapse_scan_mm_slot(unsigned int progre=
ss_max,

 static int khugepaged_has_work(void)
 {
-	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
+	return !list_empty(&khugepaged_scan.mm_head) && hugepage_global_enabled()=
;
 }

 static int khugepaged_wait_event(void)
@@ -2672,7 +2648,7 @@ static void khugepaged_wait_work(void)
 		return;
 	}

-	if (hugepage_pmd_enabled())
+	if (hugepage_global_enabled())
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }

@@ -2703,7 +2679,7 @@ void set_recommended_min_free_kbytes(void)
 	int nr_zones =3D 0;
 	unsigned long recommended_min;

-	if (!hugepage_pmd_enabled()) {
+	if (!hugepage_global_enabled()) {
 		calculate_min_free_kbytes();
 		goto update_wmarks;
 	}
@@ -2753,7 +2729,7 @@ int start_stop_khugepaged(void)
 	int err =3D 0;

 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled()) {
+	if (hugepage_global_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread =3D kthread_run(khugepaged, NULL,
 							"khugepaged");
@@ -2779,7 +2755,7 @@ int start_stop_khugepaged(void)
 void khugepaged_min_free_kbytes_update(void)
 {
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled() && khugepaged_thread)
+	if (hugepage_global_enabled() && khugepaged_thread)
 		set_recommended_min_free_kbytes();
 	mutex_unlock(&khugepaged_mutex);
 }
--=20
2.43.0



>
>>
>> BTW, this conflicts with Patch 12 from Nico=E2=80=99s khugepaged for mTH=
P patchset.
>
> Right. I guess it can be handled.
>
> --=20
> Cheers,
>
> David


Best Regards,
Yan, Zi
