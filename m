Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012030.outbound.protection.outlook.com [40.107.200.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836E0391E79;
	Mon, 13 Apr 2026 20:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776112975; cv=fail; b=MpJA7uvReuz1+VC98IdeBmG/gKMJOe8+JUqeMHaN1HkK03+N4ntcFmWa+ZImp734AW7/P9I4zDxCAJaSxvXD10xg+eDZLsHcmn/cOaDg54dwY70S712zANK1GaYmgMIKISHm3gH1gUeEVPD4XVtt8ydtcqm7ByIGOTi/+vddFk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776112975; c=relaxed/simple;
	bh=Rokn8L/Ulex63D5ZCL5Q8wQzbugD6fk8vN53Xt+8K/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qVYAEH/TfL3RiNhxX7D14bMGg3CJs4nLfgxrJqWtKSPmnWvEpNyrUjRNHa29gJ+ejWRe7ioOvi2bHH6u7n3PdqBUW1IIXrYoUz80RFbJr8K6Az3WBSQqa+vntMvkg1W95qRac7u8VFH4z526r/5rOGwZOyrkDaoin95XXoSax3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nAzi/8Sx; arc=fail smtp.client-ip=40.107.200.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nAzi/8Sx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kFfE5MYiTmBlS2LQJGgP+QV4dPztSWxaRjRw6hrlDJAjUeAmv0YA9mjQbdX63d0LD7e/cn4mI8EybS7Y6XbZ+dOKe55S/WDzuksUA5CKnc9YpBL0/r48zlcezbNqZ2pls6JO++sBqhGzNq/Js0EsCI+MkX7rScXwO2Ry8LHo4cr4nsE2EqxylcKdJhFoRhtO7DDGXbDF8G+EBEdM+WxPhT/cIP/1UF6CEfGBhOR1Kz/iYXoCYkILPnPqTcCppRFealcS6Wyzf0c3oba60jrBCEd57Za3nY9fdynlCoUi+Z2OsMKH3+hBke8Qk1qHryrvbarw01s8dYlcWcy441mdvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fcIIFMOCklLrkVEfByb5lM5cc5C1Di7q7PPaM8L8TSo=;
 b=TwwKsTVfcqKcnx5eWeeRpVaxY31yOgEmnNkBgSqoYdDXSzyPDBC+dweLVUDYK+MK5zaoEM5Gs3yTkJeUaUQQrHLH7Yngc/zzg82A0ofmUIX7f9YG2Sn7oO4rqYMh2yyO3E6xRpSOVxNdYg4KdIHhb9xFhmV6ZSjoZLXpgVBWw5GnyHy/TkqD+6ULcC6oUWARONhS6NKLIWW1g9VjLCj6zfes3+mX5rfIZJSQo58oXZJk5humpRoHZ+iWPNd+zdc7/vkfiK4iP/8GIGU8Th+XJUXYv1KKI/jBQwxYieRRMhEQ5qhPlXMEKX+8wD4TK373kCivzVktsX6zFUQOS4BlQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fcIIFMOCklLrkVEfByb5lM5cc5C1Di7q7PPaM8L8TSo=;
 b=nAzi/8SxPV2AqLyigXCl3GTMAD6hTnZolHG+eOGZAsuzpagC1g43/CzWTAi08gESXy7fRiajTotacmyHHftrf7s5QgH5Tk35Kf4HmrJwBgo5c4+QSRN+vQRyyWGw9CixiKhmref2ImalwPQLWp/d47fwOrhl/Y8sgIJqXXkiDJFqX0tutPFwJ5DWiH8OhAxh7jgS2tu7OstPTtkb/oMhneT1Rvv2im/MiestV5UlBAsS40x1Y3Rmm8jbEVikX0DXKI27eMfnU72uJ1NmAbLyKPF6Su9v+tIVorkJpO9gJ6oa7AO0kphEvVB1mElfQXGWritKvAODf0Pb4V6hBNbZlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8727.namprd12.prod.outlook.com (2603:10b6:610:173::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Mon, 13 Apr
 2026 20:42:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 20:42:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
Date: Mon, 13 Apr 2026 16:42:37 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <05F00072-7E06-47C9-BC26-FE3736F557FC@nvidia.com>
In-Reply-To: <ad1TMjF1L3usYIC5@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-6-ziy@nvidia.com>
 <ad1TMjF1L3usYIC5@casper.infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: MN0P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8727:EE_
X-MS-Office365-Filtering-Correlation-Id: a21175ec-86d2-45eb-ecb4-08de999d3503
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	U42cSImbYGquwBqbELKAWZzx+2BDjCXzKhUeYCd9ol4xAEG2S0CII+Z02FzsM+4+EbHqMocy9sq+X1yPgWp0FNPJ6l3B7Y5TqKe9SrxtsSvw63M0lqBPmSQTiwfiUkEgDmhS2tw+vtvrJIn/67CBs29ym4caFr56hlYBfrdUvDnXrvrXbCFYuy8FTmLK9UgLpsGe1pzXvVenHtqMkMUGbmFZ08PwHRa846I2aX+19dRkWfW/QWDdPWNqOGCDLBsIf0sL01llFtJQ0ihUVXvLPDDbOmgqrOYvU6x5QmD48wqgvJZ+glnp9yWJ4AK98C6eNfpmYrHX1dPKUk8GeNmSeenDPxFmX2f18VNY99GIzFPwALeas18kf+UGDKv4PHSkTttDEsHOVwP4ujYeRwFOiwZsF56BDNquhcAhzXv+282HXkQeKIz4U+ExxPxCAn6Mj18NCYtD/jP8JdUt6XPjf7oyptFceKXJ3Cu9u/9otxXruS3ECBcLGk3hThGnCl84Ggsb5CuoFz1RghsH62TUlxLlSz9KBHvxHALdBGT3ZH1X52Mf5+/LY9zlCVnvGO0tvG//sGzbk+fnjWsz4GPuBMkMLRspS24r4EiJqWOs1xJ3/vKXKWih4goV3vKXWAiQg9bxlVhrj6G2rpUOt/MpHlafLm51KU9MeREx89S7Ezj5jthSmMJkNwh7qqVn7TtCyRZhlt1kClfh3YEyJmDNrQpVhy3cwiLWvuxchN4/4+M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FpW1Wf2Ajty79E/OFmmU4cFneeqNTSr+upBCEAeGW49c36eqSYGHBL9qfOw6?=
 =?us-ascii?Q?2InDIfzrkztRhzUW9DdW0wtqLUdyLWj8YBBNIlUESp1njMtiSMds1HC7SJRE?=
 =?us-ascii?Q?oUZvx96u8cCNPirvbdVg7tfav6uHFQVxH2gwq1zQRPTHXPyH7izGfk6Iv4hg?=
 =?us-ascii?Q?17c9FYigDdz4jZttZ5fHO6Gz7KGL9sYSmvMSOregTeaiOjkJlnrbMWsa0kpx?=
 =?us-ascii?Q?Ixq45XsjEvuUqdEVQnyVIWi5716/2+Sx4zv176CV0ouwLyf8fspaDsMYm5vS?=
 =?us-ascii?Q?Um0ke6qgruQjKKHSBVp1bCu6QgfiP27EKQzUuW4Sut9HvOpZizyihjxdKe9S?=
 =?us-ascii?Q?8XwkrxtP6hKvpC1e+2iLO+b81jOKOEqrYn1KtIbnB0JkfxRLLZuiJuibWYES?=
 =?us-ascii?Q?CwbeSF1ZuJ43r5dJxWjR3np29+OY4B8SneTzmmSXU8NIfE/bTrEG99x/rGi4?=
 =?us-ascii?Q?2TRYbrdAo7VxlyKx/hNrJw1Mn8TvvB5mqwfLHgkPirHKD6SqlqvUBl7tyMdR?=
 =?us-ascii?Q?hShMV/qSCRq65N817/g2sJRBtfkZjAW/o/sNwlfNmicf8e4rw4OQXsek3vwT?=
 =?us-ascii?Q?YSbMdf1JJKswkY1+53P2rPxdqaZspOQyjr21s/H/ss/F/kwJS28Jn93URpl/?=
 =?us-ascii?Q?JziBHiQ84dOQcNkTU104rLhGn9JVfrYocy1mqZtS5lJg0IfxplvVyKwBox5Z?=
 =?us-ascii?Q?PzTlq+/n2uWwtwOneCJ45rjvc8GHUIiRfNnDrjWk9Zecz7FdpgfWZnuBPKUM?=
 =?us-ascii?Q?YpJ88YIJwECmXNiUmeui2R7Pl5wY92mZSL1QTq6JE5dk3dzcqlzqxhb+O/rT?=
 =?us-ascii?Q?iShQX61Ne5fnQ1d0nkRRiZoHyUHKHsLXVUSTM7VP708ehX4ege/MGEElKOoD?=
 =?us-ascii?Q?hb59lED7R81CCGDEyK3svGKednepZhWkZfs/ggib8PxPzIu4NEJlUAkSuhz1?=
 =?us-ascii?Q?UPIHm/Gc7E4QAgws+EnYaUwMlv9gKrgKD2gSedkx7SB+bDu1vNJki94oK/kw?=
 =?us-ascii?Q?bszf+4uLIe9CsRoPVFoS6VE07yOEvBrqoYlsL8mipkrHNJaSKmzeJ4jbkQ2i?=
 =?us-ascii?Q?pQJs+HTtJdlOVyfU9REQhBYlM50Ym21H8vyzIrr7PGE0QwU3XZNzLyabZjK0?=
 =?us-ascii?Q?q18DjRVc6b1nMJl3YanZyXZ7N5+VfNdJqbYTpx5PJCZof+3+nTyiIZbRV/5B?=
 =?us-ascii?Q?UfFwiqJfgUwtB06vQe+sGe6GRt7HV8nUoYLzGSzPKEzcyU8JswoiTqECRvrW?=
 =?us-ascii?Q?Gq6ONKI+qQ+y1uwA045SumsTB3K9zweUqayYJ0v0HceQXeuaWpDGgDAtmgT6?=
 =?us-ascii?Q?rkxl5oe2m2kTSn/bmjOhOrsYVi7m97RLHMHHX/Vkn8AXATb6ZhGThMCAJluU?=
 =?us-ascii?Q?ri8UUinlDDMGGPwVUgPVU5Ei3K+7YeQk4ANOVTfHc3cdGQCnpidW1wxtsajv?=
 =?us-ascii?Q?CgDC024M2UxQszv8i2C/hQix2mzyc4Ljo0MjsLlDiSo8PUEPCidxLc3QVBM3?=
 =?us-ascii?Q?NRim9m2tI10oV103drZZAG20hbr8Vt44lnDEICBWxMIuyZQlZqQQW6cifnoa?=
 =?us-ascii?Q?4m2rSMcxbA9bys+fxBrzXAXlFaYPGFG2c2t7/s5SIdLv8I4gyFLyhun9Y4B7?=
 =?us-ascii?Q?vbgqKfka+eTVgN6+Al0PSWzV3nlKPduEAw0VjNwTgAABW2wFF7BjJLaoFeV/?=
 =?us-ascii?Q?2IqnlOevyRHuNVN78H0InHPCD2Q5qsNgrMOsx7RJ/gTvm4U+Utoxe5NrijDZ?=
 =?us-ascii?Q?FeK62cGUbQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a21175ec-86d2-45eb-ecb4-08de999d3503
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 20:42:41.2466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ICc2eUsNxA8nXHqFy7a4AyZcTQeluNkksDkFbtP/4KoSybkSoA4+ZDjrpOxoae6w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8727

On 13 Apr 2026, at 16:33, Matthew Wilcox wrote:

> On Mon, Apr 13, 2026 at 03:20:23PM -0400, Zi Yan wrote:
>> After READ_ONLY_THP_FOR_FS Kconfig is removed, this check becomes dead
>> code.
>>
>> This changes hugepage_pmd_enabled() semantics. Previously, with
>> READ_ONLY_THP_FOR_FS enabled, hugepage_pmd_enabled() returned true whenever
>> /sys/kernel/mm/transparent_hugepage/enabled was set to "always" or
>> "madvise".
>>
>> After this change, hugepage_pmd_enabled() is governed only by the anon and
>> shmem PMD THP controls. As a result, khugepaged collapse for file-backed
>> folios no longer runs unconditionally under the top-level THP setting, and
>> now depends on the anon/shmem PMD configuration.
>
> This seems like it'll turn off khugepaged too easily.  I would have
> thought we'd want:
>
> -	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> -	    hugepage_global_enabled())
> +	if (hugepage_global_enabled())
>  		return true;

I thought about this, but it means khugepaged is turned on regardless of
anon and shmem configs. I tend to think the original code was a bug,
since enabling CONFIG_READ_ONLY_THP_FOR_FS would enable khugepaged all
the time.

>
> ... or maybe this whole thing could be simplified?

Alternatives could be:
1. to add a file-backed khhugepaged config, but another sysfs?
2. to replace hugepage_pmd_enabled() with hugepage_global_enabled()
   and let thp_vma_allowable_order() in collapse_scan_mm_slot()
   skip not qualified VMAs, but that would waste extra CPU cycles
   for scanning. Maybe not too much waste.



Best Regards,
Yan, Zi
