Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010070.outbound.protection.outlook.com [52.101.61.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8712DF701;
	Fri, 27 Mar 2026 15:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774624377; cv=fail; b=nW2UENy2L6VKRDQKY3m3zqf7TvRpYBRrllyFVtqZi2q53D3OAIjPBMwOVL1kX7X5rYEIdJf5ttUYBYjoJxxLy+1YkPOBLyzrFQ1/O7Ndc3oe7XRVdiz5MbeGJJ/QnYI9f8PW3CEpD2R2iKIOx8gsLdsMkXRnO5/uWE+hOG0Ky24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774624377; c=relaxed/simple;
	bh=Z58TRSZE1E7thuz6V6zQCfesv974MLF12Fi6dxISmEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JhxceDvs3PZZNGIXONISopAeRNWlnX2dj7lI99ZFYdtHUWnnLUIvVFGNx0NDFI7KuIkkrVhBrGtblbY9V0D9V6R9tGKldiJynYJJX9QXLy6fgfJPxUtpZiXwnvD/GL5C8nBg76zg6nm1PRxlb9VAHh++wEE0lJ78tYuFlKWWRgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e9hR5kZ3; arc=fail smtp.client-ip=52.101.61.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e9hR5kZ3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=urPsqvOFrBIkLYTS7OLsaJgQvo47OUMwa0AdC0zaj9zaqWSNVCTUSJZe29CpnTrdm0LZfX2bO1fjlbf/LsmAxh52RwqnRwCz4Qafdn4QecoqIqQVdNxbqU3jSo8yU4fjJ0U1bDvSnwLQssJTfa9Do+VZdi4S/gT3tYhtf0hDS2lZQVgq62oskiFyzcCqk0YHCYWUo3f36ped1nDDxOs8Q+meNC2oMZFBSyLpcQHPpnL45xBj9mq3OP+60B7/xu8oBzyx7ekLIv0rCAEZH2tMZbD9JtCQjcKUjfMavi9/94oQzZh8+/ZllYWW6vAhvMfqM7D1eKjs9ntvhBL5sMLUaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8sgyVu3BLpLV50ujzlFNQlxtD0aZ0ElwJb147GhSxI8=;
 b=BfoQZLVb9kn804mC6IpuuT+mIi7o4TJgqBM16MW2yn+HbInNTqnUumdF2mU+7fMIxj2Xb89Jq62QZURuHSBpxalmrGLIpfwpVz1OcoR6cUEEIusmeohg7sUcL9eFA42T6CgqKPYkOhC147cVL7enLozYgqXYS4A1BeJ1PBHrZzTGx+u9pJx+j+z3R/z5C1R9y+0R4dWaEFybatZXyB0eCznHACaP5P4yfnBdSettX4a7FV1oM0aF/1JZFUPI7Xbk3DzFy3Q8uOwwTLwJxboXZcdW8gJmJxVR8ssGLiGFPuQg+jmti9B4oGolF1ds1H9QwBe+fZTyjdHrMjqWVrPNNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8sgyVu3BLpLV50ujzlFNQlxtD0aZ0ElwJb147GhSxI8=;
 b=e9hR5kZ3HQlXKShdcZtcvz0mCKA78QrgPQKUfpgEqV3kEYCJAjEw+TZ+N88FR9i7HemAQ1MSe3w8XW0JYSDYaixscm98emy5Hq6J9FpgYGwhmR/1bGOVZMxcWsJZuN3qAv3YMq2ZMHdpeGI28h4p47hVlCllLuJ/qhjevdVz+Quira7aW5q8H98HEZ5CTtpr+DYvuvbAwVcIufenGRoMR9J1c6T5rusK2nakQGdituGnwvLWOHin5qH+Bx1vZC89VKFfBH40uRxNW0wZIaeVXZBaRsxJT/wcpZrgsC5FQlwjPJYILNb3UB/bDDsRNHIiydIomC9smv4vC2xPJ0edzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BY5PR12MB4113.namprd12.prod.outlook.com (2603:10b6:a03:207::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.10; Fri, 27 Mar
 2026 15:12:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 15:12:50 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from
 file_thp_enabled()
Date: Fri, 27 Mar 2026 11:12:46 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <075A4C69-B386-4557-BDAA-4038EB36370D@nvidia.com>
In-Reply-To: <5ac47338-1954-43ce-9984-56d70f7c392f@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
 <5ac47338-1954-43ce-9984-56d70f7c392f@lucifer.local>
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:208:52d::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BY5PR12MB4113:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ec8f197-ccd8-480e-c491-08de8c134fc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MXlvvn3NDPKoO58Xv8YwTgu6tVKW4aV5R+KzgTFaiGB9KQtaADDBV/YcC29PY6LyzcJ0AcghNQIiSnGzNEJ+CJI6lCX+eZT4azLmTL2hXhSg6L66Pxs2gRjTFC5IQyTY+z3kIempTqSztqf4LTIMJY4oQUBSumI9JdOVqJUAqgcP30v2fZxtGguDVl2rZDObHE3A/ZJm/gO3fZ49rzqe2++q6GByXTe0Fv6+Uv8G9krXcMKhGS+88Q91stPD03whbIuwbRsBKIlGAxXjfWLHXOYwX/Z1jUmXAfr30Dg+dS1W6Q9ZwAQ5s+pWjfHnwVPFR5q+1WW78nXkDjebjxEthlMeAr4hK4LXBrGmqWcSpwExQ6ZSqE7AlmqOVe7jCa663ZE/Ge7kX5s8DwhUDcC/cJF0flSMoJWlItorafcU01lCoqds3CZzW5rny//TzfrTrCetf6bWx3W8v0UV/7sVOwSaR3/4s3eKsNtdvcHzSpwFvIBLEUEXe+CRNASIuAUVsYsE3XY0ysfV0+M1B+wMD5vwEJjy0SWHIWTr6DZE1VCXvmPYKdV29T4ZetNhQjds2q9WH0h8XNPGa23hp8Kf6n51A/4109rF98cdGLc88oOx672t3OVQaq0r6BCbbcPxNZhgvt7M9NUDU98iqnCX2cp3Nscge1hx+57hXt3ZSgaJL/NkuLTKf+lwtEZkBO4wbO/s3SE4M48R3gZH0CorojjvyVl7c53MXmy40jAhvWA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dKfRzqJyfpor2nOGguT0y8XBUDeeXZY7rVduxy8W4DAtHWHFFUJco2Ams6qV?=
 =?us-ascii?Q?EHWHWTZznfWrkuYAPEF1AOwzXG2oTFTET2FzDcTkZvUjl1qF/mCOOvbYnIqP?=
 =?us-ascii?Q?t4t3wSO8bxfPUYY4H8Ti+SsDtZjsqdqDOdIt+681vk76FS+LIQo69LlbxBC8?=
 =?us-ascii?Q?9RBZik4rLUgZgGT6ihPkQt1UlqMRoLrQetRWP19KRmnBY2Y2E31MbXKlarZ/?=
 =?us-ascii?Q?5gTD9EaWJJ/tC3Yjq9XS/EtwiMIRUFo8HrloJJeBa39cYZMY0R1NXWY+iN1y?=
 =?us-ascii?Q?JdPypNRAqyCztX0AhnzzpH6pk6MTs+XF/L+O/USSd0sR3OIc3QjNXDXYMZvW?=
 =?us-ascii?Q?I1s3v46uaDKhkZXHMuv2230uyrJOiuIh5rvZqj2m7Hd/Uw3CUrNrPa8Hn3VE?=
 =?us-ascii?Q?THuWqH//CrD5j7g9+Yv4HCGGKoV0VxnSRcAm7aB712Gsf5LaCU+LIRWL9FM3?=
 =?us-ascii?Q?H8BuXC+GDHnPm3NnhKwHcMsXtu2VW7eZsqMFpmgdUr0JpqAoAF3tReg8BfkB?=
 =?us-ascii?Q?yE1pzkcXu7ZvyrPjMPJCcZm99r4ZnjwZroe7tXdpxuZbf/3gDRfK02bd9Rms?=
 =?us-ascii?Q?2YUxxaYTE5a0pZhto0kwXRpu/qKDI/iTLPE2TWuu2px3R5NzemUNy5S4o6Wg?=
 =?us-ascii?Q?MjqKaRQvdTMWP9qFqM6Eq6G0axJWrj7RE+TZmYzchviRE2mUpUI3F8Qb72lu?=
 =?us-ascii?Q?boLJQh1eoAeL3wmqgQ+X8Bubf4eiMWKWLKKtVEEYHQ9njs0hAjxcyGzkLW4Z?=
 =?us-ascii?Q?VsGwvP1W0nJkiEi0Mwmxyfly+U+yU3sWq3aDZ08jj6T3GSU9V/qBRfwwRAnL?=
 =?us-ascii?Q?kawhmq/aRjRoVp6bmhGpzjz1B7WZbYFYTKbVUf4tJRhUrwPIMqShxfV0ZNYN?=
 =?us-ascii?Q?kMurRV1pfCQZt4u4wwyTDKPl+0hUjlSyzI+In+vvVep7li7Yqxyt3BjLCCHx?=
 =?us-ascii?Q?5Q3fP4i1lDoEaLeKHYa0iD9Kl4n3QNNRTTKVNUKtkjy3YPorYxdmWjfmwJ95?=
 =?us-ascii?Q?Ra08fkR4nvaRpiW0LG2UYFVO8Gvx0P8cKry8gYxi+zNe3ixIDUVcob6+YluX?=
 =?us-ascii?Q?65Sb/VIjoc2Bk4g4Qv6JriOnOJf2MrrBoRpRhHiROOwM1lIHFeaj7iQX9UPi?=
 =?us-ascii?Q?9/vGBs5krJCstI8H8pOanvTGyq9baTmluaepwrYI3FckLKGz4YfFGSG3V6ei?=
 =?us-ascii?Q?/zK1NNl+k8UWNTeyx9a1ClvY9xXbrykXFFe0dAlInfuYdwTe3V/naWVeS6+T?=
 =?us-ascii?Q?ojB1KZag/CzBZ7ywVtUDh42PYmofXxiro7MyQTXIHla+Vanp4szTPtA9pa6f?=
 =?us-ascii?Q?TGM24Lp22dEPr2AL0/g1rgmgcwx6DGC0Pco47TGmit2GUo0S2Y9LYNk+q0HQ?=
 =?us-ascii?Q?Pipg16aRSjCS9XafPFJlx9o4qySAqLkJgLOYZb8wPEyIy+HjHZdGj9yxiPqx?=
 =?us-ascii?Q?GbCoWHnt4rgZO8Rz4AI9k+q0/6tTW40rcl2rfWuO4Jcg99360y+06Yr3quls?=
 =?us-ascii?Q?ZPwousTF9j4WaLfBSMhbrRt8q7JpO1aeHaDkvJc1TvjiOoqgtyjiyb7vKbJs?=
 =?us-ascii?Q?elw646S+X2JIFlQokCeZUr6bEQOHF3B36jcxJRXRvNtBSRjISKmtuA/4hpyl?=
 =?us-ascii?Q?XfXFRwbzzuw9XR94x0FeNk3mHw4GEIHxo9lZH8wlffu9aGVZo1QI/X9CESgZ?=
 =?us-ascii?Q?uvrNJLQ45wfdJEbjTXKrW1yXbAQg6KfCBUctQHZz9thm6PPO1LffXPqtIcPu?=
 =?us-ascii?Q?p3XsbXEsNw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec8f197-ccd8-480e-c491-08de8c134fc6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:12:50.5817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b/0vQ0P0M9Gs5wElcfAVT2euAl0xisf2fIID3DZ8HMrYlMnucUUuYWINjF+ZqakP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4113

On 27 Mar 2026, at 8:42, Lorenzo Stoakes (Oracle) wrote:

> On Thu, Mar 26, 2026 at 09:42:50PM -0400, Zi Yan wrote:
>> Replace it with a check on the max folio order of the file's address space
>> mapping, making sure PMD_ORDER is supported.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/huge_memory.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index c7873dbdc470..1da1467328a3 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -89,9 +89,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>  {
>>  	struct inode *inode;
>>
>> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
>> -		return false;
>> -
>>  	if (!vma->vm_file)
>>  		return false;
>>
>> @@ -100,6 +97,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>  	if (IS_ANON_FILE(inode))
>>  		return false;
>>
>> +	if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
>> +		return false;
>> +
>
> At this point I think this should be a separate function quite honestly and
> share it with 2/10's use, and then you can put the comment in here re: anon
> shmem etc.
>
> Though that won't apply here of course as shmem_allowable_huge_orders() would
> have been invoked :)
>
> But no harm in refactoring it anyway, and the repetitive < PMD_ORDER stuff is
> unfortunate.
>
> Buuut having said that is this right actually?
>
> Because we have:
>
> 		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
> 			return orders;
>
> Above it, and now you're enabling huge folio file systems to do non-page fault
> THP and that's err... isn't that quite a big change?

That is what READ_ONLY_THP_FOR_FS does, creating THPs after page faults, right?
This patchset changes the condition from all FSes to FSes with large folio
support.

Will add a helper, mapping_support_pmd_folio(), for
mapping_max_folio_order(inode->i_mapping) < PMD_ORDER.

>
> So yeah probably no to this patch as is :) we should just drop
> file_thp_enabled()?



>
>>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>>  }
>>
>> --
>> 2.43.0
>>


Best Regards,
Yan, Zi
