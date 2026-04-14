Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011024.outbound.protection.outlook.com [52.101.52.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D3D3ECBF7;
	Tue, 14 Apr 2026 16:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776182411; cv=fail; b=uwvT9v9snfoca2bar7gx/V1HE9B6wdhGxtCtU1zhoC3cCpkSoeTcy5n5hob3+y43cXazFSepwwNu2dESaeq43oomoDQ1yDX7OvfGJfY7go8px9CW6mNXoZaiJa0Ljmf7ChmXuzNLcODIrK1gHIkCZq5HC2XLKCA2v4WLKf+tg3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776182411; c=relaxed/simple;
	bh=XqIFrP4AoTRNC69/uP0qsLiPDvybjHpACkNH0tqGlqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YMV6UgAhcJVJmC+9taHBnOCwlXJ+WgOhrjHDf6+AF+OlcrfWhIiUGuXlE0EEcovJB72j/nRzfAftgS/tzY0y3rNA/gRQdOr4YKQV8J//7LEw2Hb7K2ZV6FStA/uf5n7zgY6lggVd6pyruj3XEafCFo6jg+Z51p1eMeoPucOQhAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ibf2Au7n; arc=fail smtp.client-ip=52.101.52.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ibf2Au7n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JBdUmatRAGgLOyoMnoQgNNE1Y4rVr0mVzqlNj8SdgTuqKNSAvl2wojXdIPGj/JXHY+PQy56tLJk3V/Ougif8LwwJGtBveU7oUi9szxyiPLSZgYKTGDaB955prhkq8GDJ+e0m+4F6SCd6cPTvGe4lvnoKO93pezrtmRQoASXHw0ApR00BJWdYVDW0sUlv3jCuTq2oIARFROoVOD/ybsjx87aDVOVTvA4pnKPHy5DhBaN1vxLL2x7ycihe84cyR5uEHtOwsi6CknxYCIfKQywcvDWwl0ds88ZuNNcZYrRuPb2CjmUTsf8FzE55vF6VEpYhSnMn5A7PmmsxD0ZgaNAeAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v5teCDGJ6psv+P1lQ85veUFFHrzARcNMMMjI490pofI=;
 b=XBFpzGLk4uAWDLNRuYumQcQZMWZjo7Mf2MHvuVZS6GDAVlXzlswqdXqmGA+aZ52x4TE80drZkIia3Sgjp/UUsMNeBak2VrgxpgHwPm0inkeprf6Ra7EglsNC4tdVCsJDeaDuU4uDr9HE/N+syGq3FlKKDy9+Jlif16REs0M6hu/Ov+xlUPEtgccgcIp89b5CEgSKc0VCQ44TGMsLvb96oW0pHuOFQ4f5XW3FSuwZkdIa+x1CM0n/RJe25RzMMMnkxdbglgDV9ho7XnMpXHTof4en8qU0S+8AJ9H+0gfUnMgmuJDVUOOE073LFyW0dOKTMRHNxDZYti5KVdkECGM2BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5teCDGJ6psv+P1lQ85veUFFHrzARcNMMMjI490pofI=;
 b=Ibf2Au7nkENPDSXXJkLSJdMrG/J3vYH6xAMxkoCC5Ugd3S98QoCo7zNOvHl0ERiulQw/IMhhflO6B9MUVcRimq7xs9VrfhnKW1b+j9MjN5KBv83tTTC9Y08kYoASl2hxxD6xQh9XS/NzBXwNkzhxEG8NKUnazII6ig/8PuCti3yTSw2GEgj6Rl7SO0k4hhOdtcbdpZsxdgiYFEVJZXVrotzS3JYcbQBx8xVZ3lyXMHTWCHh9jXw7pvWK5t6qERpK5mrSpAIOi8QtoJwNVvtqxUkEOpPAWYKpagtjiFkB1ZkxE1+Vm/KDpTQg4j01xeGCuThx6FN2t7LvyJuWS27ZWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6226.namprd12.prod.outlook.com (2603:10b6:930:22::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Tue, 14 Apr 2026 16:00:01 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 16:00:01 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Date: Tue, 14 Apr 2026 11:59:59 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <E958CF27-F6A7-4840-A0C0-D1F183C93A8F@nvidia.com>
In-Reply-To: <47012a6e-f1ee-47c4-b614-3ca16bfc9e6f@kernel.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-4-ziy@nvidia.com>
 <47012a6e-f1ee-47c4-b614-3ca16bfc9e6f@kernel.org>
Content-Type: text/plain
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
X-MS-Office365-Filtering-Correlation-Id: d8164601-d7a2-4ca6-80cf-08de9a3ee2c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PzGnWKyKVAB+bQFHlnAJ7M9BAkdYiXlwvJdATQ64v0MBm4yBxcg9tumAZU37DItfbEpYqiolOU4l+v1P3QKZ45g8LbLCTdP5HHeGlyUq2gOD2gS3SuTKrRMpTRDmnIA3xFd3ADyeLO9cRbmKO2WeptxLkB4lCvdXPM2JNSX8vNnoxUoMzqJVLJ2aQCxIkY3EMWkAXzIJJKkWAM2gNVT8E/aVYL3H2glf72t967TwgfywOg36ki7ETZSc6HBLa7VO3Rp8+FX9Tm+hTFRH/kK0i8qv3XYA9QsIDAX631vBTj9SFvQQa4r0p0zgGkjhydAIkRIJBGcCVS/v7twi9fHb+jLslP19QQSe5Gs1v900iDWmW285BTTHdIuSBfn6loYQi9PCrgm6rQ3+KZOTbr58sByxVSHd5VGY0DJOpBWmyIO4k8LE55tBqpW3Z/vkWo5Yl/p5s4YTfzBxC9fM1mKyTd6h/q1yXX9UQhvLoGezSNWDdb7OLnhAlg/yf2I5S6dd6N4xs8NNDUzNnhDRy3P15ASjn/LVagcqpFDG92wvIr7VDHbpgCbt1d5O6QdqhpvHsyNLhPbkCdmH6znpxHhjO61EjYMrjANPvtm7HkFuCEbBERK1pKr6oJK4khN+4SiZR9wU7rB0Lw7LAN2nPY+ngCImX5bSqfcs/hbh/J1YULMI2HRHgqELQ260k3KN0I/eaN03DW8Lt14mO794JSZs1m4RS2gSUxdjRRuzq4r1Pig=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y6QYs+qqTx1WA0YSs/CtITKFfAsyI7TDXFXPSOtpk6vpneJfEFPkhZtVmoxb?=
 =?us-ascii?Q?jBDCVQAmnG0+ELKKDX5HUbGeV4ayou1i+yPPcWVkRWerOBLX4G979hgrBot9?=
 =?us-ascii?Q?lfSoEwnnn1ez59JwoldKcQeSGRtnztE5aPzE+yXHoXkpORelz3Nei1/vMCQf?=
 =?us-ascii?Q?cMhb2TD4D39mg6oUJYCuJsOdC0G6DTPrizmqcku7UtQBJFrIRC18B6AnpouY?=
 =?us-ascii?Q?obcZUIWV2m5y5yM20XQIs+kGduT/VBluuSHwe+3pnVk1ZlsRJGKhd39C/1gJ?=
 =?us-ascii?Q?Q+Gd+yp/OjSGaZHLqcWXMfQUHF+kktkP5zUozcgt5qI8z7quKSkRU/m/kEog?=
 =?us-ascii?Q?ReYp6yudIky8XdJK2AUl3N5PhDwWGE08DhFuShGloOc5zQur1LRZfi7lnfmJ?=
 =?us-ascii?Q?jWopyijuniD+/zzy8lBzyHISBFeqYAVMMzZOa3kHvEigat8dILGsokAwCCBG?=
 =?us-ascii?Q?HDklJqEJUEErIAiGttVXgm9hamnOmBQJB1+0Hw3NeMu1YlIb8qEs4iSf6H3B?=
 =?us-ascii?Q?sbhmNhuoK4popImI4DjrFJvkkBFMdcTq/nGXRCp7xrLslc9enYVhAmxE/sbI?=
 =?us-ascii?Q?pEWeIjbSDBPBL7EskVrdEJDf9/obROT9snFn+aMt+ZDlMwSrPif3StWOEfSU?=
 =?us-ascii?Q?zIxqAT7m/ky7s8T5J8KPm0KJHDrRxzT/8PHSidaPmHlqn8jpc4CqeoPmlXMH?=
 =?us-ascii?Q?ZxSluXgW5XPrFTnk3/bm3gG/9wf9gppdRhLZ0HgfPgnmawLCYUqm+TbjNON0?=
 =?us-ascii?Q?MajpGphWnqOmFTtJFQ7If8t/sn4bc8+8yZvLP2vfuUnhLbTlm+/emTdGa7cU?=
 =?us-ascii?Q?drdVc6TITyoGbhNQGogVJA1sFkxtTLgggTUGuU7Tx1KQ21zCBd1OiLHtekNg?=
 =?us-ascii?Q?N50beD+74zXEDNcPhSbenLMkKC2BrUwzq2p5NIj/f9uVttgBhkY9wo22Va1+?=
 =?us-ascii?Q?fTpDe6WBvwehVcbBLouXB+W7QEHbkP5GDPXCuzJMu1g8wv2Yb+jjMvL0xpQM?=
 =?us-ascii?Q?uyrBOurM+v+XWDb902vuBvm1slLU+/zXIh24mkbcHT7YKuXHgafXG2OSrWoR?=
 =?us-ascii?Q?WFTb7jqH3QXEJcFQ2vtteElmC09ATv1xlTGfG+7yjV5at0WwlNIchmHFoapq?=
 =?us-ascii?Q?La3OgMpUnL6Ob9wcGYqff2ulvHagjqYLV0Yv40rnrwn50+A6u1taKsAr22gZ?=
 =?us-ascii?Q?hcUZiP6ge5Pzpmz8zMiAW8u+xPKknGhqo5Z+NEKd8EP+LbNUy14FYMgqzGa1?=
 =?us-ascii?Q?sKLyiaEhIuYvweUnrKxLwuXlDLHDKM/59R5mMu95VyfUtk25hxiobQbAUYsr?=
 =?us-ascii?Q?MPDEhyTfELME+fhnsiBV1iiHem8TtsDs84NnwdB7G9SGXhZcae+3mYI+0Pmk?=
 =?us-ascii?Q?V+2P81v9X7vCeezDBpoGj5HovM9M4Vazp3swYAESKtd5vfVDcrySKNF7CMea?=
 =?us-ascii?Q?dTd1b8LGUaxFJyapBrVTsXGJ8d4gykKdIZWoFKyVg7wmlKxfWn0FvYutK1Gl?=
 =?us-ascii?Q?SIooIOviP2f+ASIzc7WwKa8z3tY6o0hZ9ee6UVZgL/VKYmQK0qkckZ2zJm00?=
 =?us-ascii?Q?sJm7n/MXLqhTlLTdUEpGIk1acKJq1CZFTCIjIlA1L6vMz0kUwuNr9lS09rNd?=
 =?us-ascii?Q?pmwyKen3iaG6sYkbfIXkFd8Hts9GtTVxRKyAoIKnjBiFsrH7VsIDsUowLS3o?=
 =?us-ascii?Q?Kzf3Ts8mH+xipWp8JQLhVvN1jzjZMeCDLSd+Kl5TG3yGcfrEMYSmWgOvvohK?=
 =?us-ascii?Q?iUrruHY+Lw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8164601-d7a2-4ca6-80cf-08de9a3ee2c8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 16:00:01.7732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ne1IhN7+UJf0LzpOsLeDkdDmRic8OchU944plhz3qp9TvIUU3sosQ7tnwzLzU5HL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6226

On 14 Apr 2026, at 6:40, David Hildenbrand (Arm) wrote:

> On 4/13/26 21:20, Zi Yan wrote:
>> Replace it with a check on the max folio order of the file's address space
>> mapping, making sure PMD_ORDER is supported.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/huge_memory.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 970e077019b7..a22bb2364bdc 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -86,9 +86,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>  {
>>  	struct inode *inode;
>>
>> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
>> -		return false;
>> -
>>  	if (!vma->vm_file)
>>  		return false;
>>
>> @@ -97,6 +94,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>  	if (IS_ANON_FILE(inode))
>>  		return false;
>>
>> +	if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
>> +		return false;
>> +
>>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>>  }
>>
>
> I assume this change itself should be sufficient and the SCAN_FAIL check
> in patch #1 is not required?
>

Sure, I will remove that one.


Best Regards,
Yan, Zi
