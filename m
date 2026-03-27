Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012003.outbound.protection.outlook.com [40.107.209.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297381D90DF;
	Fri, 27 Mar 2026 15:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774623641; cv=fail; b=JzR+nxubBUexRy7YTQC9Wn280vjr7MDT8ouWuLAh9m0ofp96oyQ73yQ/gcwurfVEV+qqE6TbYrxsfKMgZ6Jpp1i2/cWBxvyKH6rn2cTpJIQVSQW8NBeUCFcgbqQskb3tafJmnRuo5SI2bWr3SPCp0T9V1/2L/ciel87H/Oibdag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774623641; c=relaxed/simple;
	bh=tkNQpy39cW7LwXaWTxmp3PlPGn2nCB38c/wBj5WJ4xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Cc1DhixFqmO/EBdDkBohTSFyWGtaTastRk2BQL22CWWPSDGxwiM5dOumqtAYeGA89/7i7C05muLrTKnpzJFaxoGyjBdG4KSBwXVM8fFufuxma65limbA3QIPrCzqWMRWZMOpm39Bszme9pti/kJhaS8BNHupuvZfRBGed7sNCsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rSwWIemq; arc=fail smtp.client-ip=40.107.209.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rSwWIemq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dpsKVnGJVErB95jDfru5KVJo+kjHCSBa/OY06mX1q3kz3+E7KZ7rxa0vKNxIIJ1DxhuDo66ioz+fb1o2zM5xKH4j9I4VAMjK9M7QyioEzHFVfadPpHFIRUx2w4/3qH3gebWEpdGC+ghg6gkNKjpKZoSyHYovI/zFQ3YqLn2uLtIfqShQB9MJdMKy+cUC8ndLL3SMtX+3LIKpuTqnrXCYWqbEQfva7WP2EdAy9pQFklNYsA5lQX1Yr7rdjx5paqD5Aqc7R1pAibm2SD28NuumGoFtnjM/+NT0TMPXF+5OjWJWCfQ1Jm9abED8fF/QtH+dOTOWfhug4WI31VmARMIiYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4L4LJlhxGnlihb8H6OkfGv63Yhor2CJ6Nk+l39ZW28Y=;
 b=K/G6zpKFIWtg+EsA7iBS18SxqDI9Zml9k/21o98o4DmRyK3bhavJ8U2rTzYJM8FEEOOTI8HjxqEstCYWntOUlFnEnF9N9cxDDlWX1Pf3Y+IPFP7dNvvGyXTxvG5vFf5K0N0vcKzfJIBcpf8uc8sK/cVtwGXFzdQAvdxlEKvfv1q1zTeRe36g6otfcUpeGYvKPajerP0a4nRtTOqmE1N80m/HGBSZAUqvJkJXmnpL/xuvuyIGsDu02z5068HIVYqOklapArWVPIydN8kY42juckJyJCzhM1BnaSRUUHxorbqFty6WqvGZQ6Oz0wBPEDoD+x4h5ZVP+7x6Opb1vF8xzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4L4LJlhxGnlihb8H6OkfGv63Yhor2CJ6Nk+l39ZW28Y=;
 b=rSwWIemqk/bQMwccEL1kJ0/II1KcmqaeQgucXVNPa7qsAtcUY8BY70wP0SISaAgHWYeQMbfdsQP1UZX0/TAURd2hLnSuzxkClaQ3ScAkh5ZLBuc9uMKi94wg0erPGG0W2FjS900AxCuuqmMsgtpXy1eVLYN2sadPJ3cJsgvA9o5vbN2Grm2DxlwgV9NQ9WEBxdx2THeCb5XSHE+7yGW0orpDW8+79nrOEFTfZykdgBrQS+PJZHrwsLuXK/pzOodRfHgODT+5vEuIVw85XCjwJNZw7UVt21Gk+/sxHMi1LL/5g3uGBk4eNJL8ZcCep0i4+bQaZkZFjTMCIa75HjHppw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6597.namprd12.prod.outlook.com (2603:10b6:930:43::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.10; Fri, 27 Mar 2026 15:00:32 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 15:00:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Fri, 27 Mar 2026 11:00:26 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <6FCC0430-C98D-4D7C-8C53-F7722F1BDC4A@nvidia.com>
In-Reply-To: <6442d533-27ae-4e2d-b8d1-64acdd2dfbd9@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
 <7fd90f5e-65b5-4734-abb2-77b22c733af5@linux.alibaba.com>
 <8f5119a1-9aa9-4a39-ac94-ca1631db26e1@lucifer.local>
 <ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com>
 <89c8b93c-f6dd-4d8e-bcee-3c1ff1c04295@lucifer.local>
 <b9bc241f-91a0-4df3-a5fb-2221bee3ab68@linux.alibaba.com>
 <6442d533-27ae-4e2d-b8d1-64acdd2dfbd9@lucifer.local>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0249.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6597:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a6fe2c0-a69d-4a5f-fa25-08de8c11979a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	x7KinEp27sTuca37nfrNznDIhwbe86CWTimiqfpTlkypaC2+LX7XlPMpcdcmRQXlPBdkqprMxw/2CEcsjpPk+hX0M3H2RM8yV3CmIKdtOUdtIABzh6mJOquXVDgHlgV9HwDwMA8sendz6sevzNpzJWzfBZ4Pn2FuBMvraQnLxN/mUNDoaKC5B0Eo4VMKVE98YN07QpfGwyNJL/EuQ51X+VHKsir5aoYzDpNcMctdCVHmnv/HbRNcr9KYn1+++SgDaAUNt6TNd2EWP3OypJSLaLbx0/k65vVVezow0LhXG2Cx4EJ14C70i1x8u2bhg3Dvs/u299DuDqdVhaH1Cx7S60s/i+EQ0h5ornOsYCofzwJmtqbSAD0vsRMHW8bYh7IWPBzUL7FHfsK2zdgUmsAkm8vwmlEPxWdHqw47/E2Wo7tUU3zMK+37asxTzsRxzcWDhaF35xb/J1Bd3N3xTiPcfRDwr7rhvZiVH+8INxzd95T8MOQwV2v42VBZ2b/6xxBmKA0yLmJvX7IqlzytQWGF7asgv2kKeJikzsuOmY7tQ/UCqO+cTndcSoIign3YwAP54gjrsCHk9UTm5ujCf3S34vEbY8yYVSS2fzsPy/s7FNWvir1PrRp0HYwJMqyluhcHNl2YxKtxDsYo0MKJ5k3Aqq5lrKoxiiLzlu3Ca42ky03Csm6zjWkTDDJWAryQSkKNdk9RHO5nVKJzZqd264Qec2ZavQOnJN3jFolGJcqaL60=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JLO5lRg/16BRDxO13hnCJJ3eobeKP3jOskeEgTsLPQIhBstg5G6gDjplNl75?=
 =?us-ascii?Q?QA3hKzX8GpG2o+E4qV4a9P1+KzikWLJ0uuL2u9p/H1TD6RxFX+gjyIv5lLuC?=
 =?us-ascii?Q?Z+bpOcOgOrRZyZVFGOsEYoSPaUbRt3fzrSXVjR4KN+HEt8l7QIL0yNSFZSgC?=
 =?us-ascii?Q?8CqP4kITQuCVZ4R7qrtqg8Ma6YKrdhJKtKLmzFBhOtSUQdEGTGjPvkaVtKLg?=
 =?us-ascii?Q?3wCmcSFcUFo3Ej5+mUU1Z1ZnUy1OIiKBvkiuO4s7oNwE/pcSmDkm+ZvAA4s4?=
 =?us-ascii?Q?26fNP+hMhhWglhMhMCT4BkIo8ZCcG3yRD0f3SX0JyfgMGvzGRffgco56bPAR?=
 =?us-ascii?Q?F/DUimvJOOJcDWxKfPhd4JYkxD+PJ8s9eQfsS8kC24g3X6TyKF2ez+CAt6mp?=
 =?us-ascii?Q?WZqBslWlUnbSFbu+kpav/yBqMvZ5/fCNeolQKaglLow8Is4U4hn9OHINLGD7?=
 =?us-ascii?Q?8IDxFuP39OPDRtlHU1hqQgWCtO3x6Atlq1Y2IhzarFISOTLBJKu8ksI3CGCI?=
 =?us-ascii?Q?RjOpIFZqob09wN95EvIMY4VXnkN9jXoZo4/GbHS0yWQIhrkafUtTuXLrW9Iu?=
 =?us-ascii?Q?DQei5kbkRQsJYM/PigsepEbQsLbUdZf3eRvc0kBLyB8G9D48hIVKmypYrxg/?=
 =?us-ascii?Q?+Ig+P7SdK32rKtauMhkcMHiEn/YETZeolsNk6cYJHsFWsM1Z//6TRxtiFcOw?=
 =?us-ascii?Q?RdFkf62ZBytfQnfzFUJlITIFV/QSeDBfr3R84hkqQTiAGOjwhp9nr6UUl+Mw?=
 =?us-ascii?Q?K57iYmN1Bum/RJnKTfqwc9xBLWmhVlObtRc2fvRtaehnLrnUiyKGepuY6SoT?=
 =?us-ascii?Q?2KLGeD4QqHLjwjpf+4AZeRe0dgLsA+DOdKViFRGieRoUpsE0PMRX27We+26Y?=
 =?us-ascii?Q?DopoIv86OZ389bK6bYIywZbsKdPmMfmaHS775SkOZWieDeb4yddyjILjdllF?=
 =?us-ascii?Q?eoyx7vLQU8EjICmXOj0BGvCZiVpszmufyUv1Mlq/lDTVNpaLTWjMlbo4QlKY?=
 =?us-ascii?Q?bDQ+jFuLtgSLmHFJzyXTHMgQMNBmRcuP9hXpHq8ByRnwlWcEm/yTlK/kxtJG?=
 =?us-ascii?Q?1BnGZBgBs4STiv+FPShR5rr8Lgs+j6BiVQ7ERDk8jKxCEbDrgYzK9rKXwEnb?=
 =?us-ascii?Q?r7bSaTSI7ElnOrRWElQEKYJWxEdxN7DwpLe2KpLLJpZrFANwhaKEphS/xNUP?=
 =?us-ascii?Q?J2L1H2kFy9OjDc02sygyrDHPtaD0EbnaUw0MT6ZjhPb8WsXL12ida0ofoexv?=
 =?us-ascii?Q?mKWxktvDBkFxl+qbpUdZLu6MIPghT4qsi+dAr0JJ/bQAZzoYJE8uaLWONiRE?=
 =?us-ascii?Q?A1vGZKYTWTrRMxwwZn/BQ06OmyAJ/G/Kuj4Tq88ODpL6x8btXWg2l4zraP2P?=
 =?us-ascii?Q?HxJuswacCED/3iWGpJgfjzjHrVcjB4MLZ5U1ypSqTSW8uZbAqmswD54LgSY6?=
 =?us-ascii?Q?7qcld1GdjbKlILggKTbg+l4J7MeuobzmW0Rj3v2JgkA3DLu8vy2pldrMaoaL?=
 =?us-ascii?Q?xBvwznqq53MHFu293UVGsuo0fTYx2qXz2Y67FCpbebWWrDccD3QpqG/U5d6y?=
 =?us-ascii?Q?Ed1MzS4OgXODrKZEmwYp+RJiSJLRAh1O5sNuKp3WTPKjYnH3uVybT3uIm4qn?=
 =?us-ascii?Q?32AquYlZVAzpOcez75mgKYut2aexSjDdWupO3S2l+9vzp5I/eST0YnLsBN8K?=
 =?us-ascii?Q?S2O1Y9NCoX9b8Sy/ptgItLOXkxwYX/MJLlKFptfgttceJgeP0Y4SCrqoJxkB?=
 =?us-ascii?Q?wYjjWc6ITg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a6fe2c0-a69d-4a5f-fa25-08de8c11979a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:00:32.0381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JymtO5/qEQSQYptKacb1mpGKuac4NykHz1mfJZ+6FDPVWG1NvPOa19WmlQftxDCQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6597

On 27 Mar 2026, at 10:31, Lorenzo Stoakes (Oracle) wrote:

> On Fri, Mar 27, 2026 at 10:26:53PM +0800, Baolin Wang wrote:
>>
>>
>> On 3/27/26 10:12 PM, Lorenzo Stoakes (Oracle) wrote:
>>> On Fri, Mar 27, 2026 at 09:45:03PM +0800, Baolin Wang wrote:
>>>>
>>>>
>>>> On 3/27/26 8:02 PM, Lorenzo Stoakes (Oracle) wrote:
>>>>> On Fri, Mar 27, 2026 at 05:44:49PM +0800, Baolin Wang wrote:
>>>>>>
>>>>>>
>>>>>> On 3/27/26 9:42 AM, Zi Yan wrote:
>>>>>>> collapse_file() requires FSes supporting large folio with at leas=
t
>>>>>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. s=
hmem with
>>>>>>> huge option turned on also sets large folio order on mapping, so =
the check
>>>>>>> also applies to shmem.
>>>>>>>
>>>>>>> While at it, replace VM_BUG_ON with returning failure values.
>>>>>>>
>>>>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>>>>> ---
>>>>>>>     mm/khugepaged.c | 7 +++++--
>>>>>>>     1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>>>> index d06d84219e1b..45b12ffb1550 100644
>>>>>>> --- a/mm/khugepaged.c
>>>>>>> +++ b/mm/khugepaged.c
>>>>>>> @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(stru=
ct mm_struct *mm, unsigned long addr,
>>>>>>>     	int nr_none =3D 0;
>>>>>>>     	bool is_shmem =3D shmem_file(file);
>>>>>>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem=
);
>>>>>>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>>>>>>> +	/* "huge" shmem sets mapping folio order and passes the check b=
elow */
>>>>>>> +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
>>>>>>> +		return SCAN_FAIL;
>>>>>>
>>>>>> This is not true for anonymous shmem, since its large order alloca=
tion logic
>>>>>> is similar to anonymous memory. That means it will not call
>>>>>> mapping_set_large_folios() for anonymous shmem.
>>>>>>
>>>>>> So I think the check should be:
>>>>>>
>>>>>> if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
>>>>>>        return SCAN_FAIL;
>>>>>
>>>>> Hmm but in shmem_init() we have:
>>>>>
>>>>> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>>> 	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
>>>>> 		SHMEM_SB(shm_mnt->mnt_sb)->huge =3D shmem_huge;
>>>>> 	else
>>>>> 		shmem_huge =3D SHMEM_HUGE_NEVER; /* just in case it was patched *=
/
>>>>>
>>>>> 	/*
>>>>> 	 * Default to setting PMD-sized THP to inherit the global setting =
and
>>>>> 	 * disable all other multi-size THPs.
>>>>> 	 */
>>>>> 	if (!shmem_orders_configured)
>>>>> 		huge_shmem_orders_inherit =3D BIT(HPAGE_PMD_ORDER);
>>>>> #endif
>>>>>
>>>>> And shm_mnt->mnt_sb is the superblock used for anon shmem. Also
>>>>> shmem_enabled_store() updates that if necessary.
>>>>>
>>>>> So we're still fine right?
>>>>>
>>>>> __shmem_file_setup() (used for anon shmem) calls shmem_get_inode() =
->
>>>>> __shmem_get_inode() which has:
>>>>>
>>>>> 	if (sbinfo->huge)
>>>>> 		mapping_set_large_folios(inode->i_mapping);
>>>>>
>>>>> Shared for both anon shmem and tmpfs-style shmem.
>>>>>
>>>>> So I think it's fine as-is.
>>>>
>>>> I'm afraid not. Sorry, I should have been clearer.
>>>>
>>>> First, anonymous shmem large order allocation is dynamically control=
led via
>>>> the global interface (/sys/kernel/mm/transparent_hugepage/shmem_enab=
led) and
>>>> the mTHP interfaces
>>>> (/sys/kernel/mm/transparent_hugepage/hugepages-*kB/shmem_enabled).
>>>>
>>>> This means that during anonymous shmem initialization, these interfa=
ces
>>>> might be set to 'never'. so it will not call mapping_set_large_folio=
s()
>>>> because sbinfo->huge is 'SHMEM_HUGE_NEVER'.
>>>>
>>>> Even if shmem large order allocation is subsequently enabled via the=

>>>> interfaces, __shmem_file_setup -> mapping_set_large_folios() is not =
called
>>>> again.
>>>
>>> I see your point, oh this is all a bit of a mess...
>>>
>>> It feels like entirely the wrong abstraction anyway, since at best yo=
u're
>>> getting a global 'is enabled'.
>>>
>>> I guess what happened before was we'd never call into this with ! r/o=
 thp for fs
>>> && ! is_shmem.
>>
>> Right.
>>
>>> But now we are allowing it, but should STILL be gating on !is_shmem s=
o yeah your
>>> suggestion is correct I think actualyl.
>>>
>>> I do hate:
>>>
>>> 	if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
>>>
>>> As a bit of code though. It's horrible.
>>
>> Indeed.
>>
>>> Let's abstract that...
>>>
>>> It'd be nice if we could find a way to clean things up in the lead up=
 to changes
>>> in series like this instead of sticking with the mess, but I guess si=
nce it
>>> mostly removes stuff that's ok for now.
>>
>> I think this check can be removed from this patch.
>>
>> During the khugepaged's scan, it will call thp_vma_allowable_order() t=
o
>> check if the VMA is allowed to collapse into a PMD.
>>
>> Specifically, within the call chain thp_vma_allowable_order() ->
>> __thp_vma_allowable_orders(), shmem is checked via
>> shmem_allowable_huge_orders(), while other FSes are checked via
>> file_thp_enabled().

But for madvise(MADV_COLLAPSE) case, IIRC, it ignores shmem huge config
and can perform collapse anyway. This means without !is_shmem the check
will break madvise(MADV_COLLAPSE). Let me know if I get it wrong, since
I was in that TVA_FORCED_COLLAPSE email thread but does not remember
everything there.


>
> It sucks not to have an assert. Maybe in that case make it a
> VM_WARN_ON_ONCE().

Will do that as I replied to David already.

>
> I hate that you're left tracing things back like that...
>
>>
>> For those other filesystems, Patch 5 has already added the following c=
heck,
>> which I think is sufficient to filter out those FSes that do not suppo=
rt
>> large folios:
>>
>> if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
>> 	return false;
>
> 2 < 5, we won't tolerate bisection hazards.
>
>>
>>
>>>> Anonymous shmem behaves similarly to anonymous pages: it is controll=
ed by
>>>> the 'shmem_enabled' interfaces and uses shmem_allowable_huge_orders(=
) to
>>>> check for allowed large orders, rather than relying on
>>>> mapping_max_folio_order().
>>>>
>>>> The mapping_max_folio_order() is intended to control large page allo=
cation
>>>> only for tmpfs mounts. Therefore, I find the current code confusing =
and
>>>> think it needs to be fixed:
>>>>
>>>> /* Don't consider 'deny' for emergencies and 'force' for testing */
>>>> if (sb !=3D shm_mnt->mnt_sb && sbinfo->huge)
>>>>         mapping_set_large_folios(inode->i_mapping);
>>>

Hi Baolin,

Do you want to send a fix for this?

Also I wonder how I can distinguish between anonymous shmem code and tmpf=
s code.
I thought they are the same thing except that they have different user in=
terface,
but it seems that I was wrong.


Best Regards,
Yan, Zi
