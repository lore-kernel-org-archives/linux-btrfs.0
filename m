Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013049.outbound.protection.outlook.com [40.93.196.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F463783D5;
	Mon, 23 Mar 2026 21:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774300289; cv=fail; b=Lfga2swWEKUZL3iI+SjweqTtmU0ogqyIeyzuT67LT9eJ3F9/xHYr/xUIJMXXl26FSo9MR7H02AuMZMl3MpxJ6ogpidKISIVrfDDu1vVfUEETBhLeZ5+868+PgvSUrHI2QeJMp2awQnfepo/0VYJH4rbSVtB+qL0mygArLvrhyCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774300289; c=relaxed/simple;
	bh=UraDBFm/RGsa0CLWDJicJIhmhV76W3x3tvZwtatFYik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mNalNToz6eIueKHunC+hOip8UBD8MJTj/A8crWjHY7ZBI8n3/VCmUBBVIqLU9X92iKEW8sXPL9s3HeAXsUBUwHg+0tYOe52sX2K90EJiC/EjjCjvzO86K/d4hCTi0zPO2HQ9Rd9/UkMwF1qeYKegrKEmT9HjSWH/MCvS5Tq+G08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rIVtGbdj; arc=fail smtp.client-ip=40.93.196.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rIVtGbdj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ffXeVcvgHMigsrDJ18W46dQGaoaiAub0sk3JQMYR77XW3E/IIvl+HNSSC5VYPGQ6xeurpUHW2LCQ8yrA/pdunJzqvpq0ockMYMElTMfMYGpf9Jqdjt90i7kneAL90jcUkuxdZS9KVXFnYYt0LwqR5odSHIgR5Dfu+AZJVvNbdXy+BGGwsox4HYf+hn97FmUezkQXHvaag66pj/Nzg4Q2ftS+QbxfyzdsQVB9aJsT4zs95kwB7Mh2ZxTgEFzY+MEUs6Od9kxAUaATmVlYjhRLHWMKbnF8JnYeJVOK6wEM7hsLEt5uSmtZVf23G2K98yphqXZmurp969XhQWmXF9rAKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jOixD1Q9GJQtec0haIXaIIXuJ/UJOnqXDhJ3Pj7TEc=;
 b=vOho0lP3hyNSThdBIP1zIoV9cUVb5bLaw8jFta17WhtNfIqN+6FUF/24ECVx+5YFbJ8HV2tkaYLR9ufVbPdk9Ays6K3tE7q3qS5L2ESiUPicmpistd0IglcfXxPMlNHlje6F5uMREZSSAC3h2U6OwgNkuVn5iqUzBs3HF1UhCMYHKuzBgJgDEo+qZDmwITF7cy/DEPq3WIvAxV9nYxhPfQch42NBb6M7xnG87suEq0hnGiwP8Wq1+5HFFWnIX8b6HNrHK/1vw+3p3g2+0ObTQqgUg31SUwu/B7spPa9i/IDFc6O0Ln5rbsXJ1T/XruSnS4BLTh4mCkYsSQ/o15fKhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jOixD1Q9GJQtec0haIXaIIXuJ/UJOnqXDhJ3Pj7TEc=;
 b=rIVtGbdjA6o9lvxZ0cc71jfZ0UFy6DsDV9mZ3PZDYGvu4+FUoF+WX3x0EH8b2VONkuEFVyLymgezE7I9F3dHWv3e6CclRsgTNVDbEw6/cnaKVLPHwJP2Natdq9rwX0gTWNxgnc+1KauNSj+3LnF2Kgz3cyaXYMaq60VBQfdsBybxxvYkcw0OwjxClHQgxp1fFxIg6E9CLKBhRl40mS//YfCw8nFhgorOHBUnKjgMCyqfYA6Lsfxmjqqf/KoWKsJTylzZBc5ddPoXmnbAuzU4Z6KkEw/NeYhDrBl2iX1UpSAtePaWgw1a4jPKGDjoRQ6LPvSyplP1nv6+SY3eUsPjwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8756.namprd12.prod.outlook.com (2603:10b6:610:17f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.15; Mon, 23 Mar 2026 21:11:20 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 21:11:20 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Song Liu <songliubraving@fb.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
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
Subject: Re: [RFC PATCH 02/11] mm/khugepaged: remove READ_ONLY_THP_FOR_FS code
 in collapse_file()
Date: Mon, 23 Mar 2026 17:11:10 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <EA39EF46-4331-43AB-8602-D0A73E9C9C9B@nvidia.com>
In-Reply-To: <9648838a-ada7-4983-99e3-d694e803e06b@kernel.org>
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-3-ziy@nvidia.com>
 <7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org>
 <E8D52134-B63E-44E9-BBBC-258DF74B8597@nvidia.com>
 <c20b7dbe-473d-4dca-a10b-b9f5267ad6da@kernel.org>
 <AF9011D6-8EA4-4134-B175-BD2DAB748419@nvidia.com>
 <71148f2e-cceb-418e-b762-c8dbd7a7eb1f@kernel.org>
 <FDC4C393-FB38-4422-9217-DAE95131C696@nvidia.com>
 <acGqbeSjktT4biku@casper.infradead.org>
 <9648838a-ada7-4983-99e3-d694e803e06b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR08CA0008.namprd08.prod.outlook.com
 (2603:10b6:208:239::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8756:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cb92047-b92c-48c7-35bd-08de8920bac0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yQCBJBwRnGshDQrO3P4BcURKzLjoi0PIaGH7WvdDdOCEVs75nM8vzknpYF8Oe9HV+hkR3YWLTY0DfAnK13WetqJFH/R+e5mgEdPOUbgVovG7ygDRW4XQqfwqmpof3ovgAg2JjUt5giXFt+3A0kVA+DnrepEZJf47GzYO8xltQdB3Cx4dwKcU3tz3PjY3el3YkS1+4xLv0j2n7tLMAE7rzpmp+8opBwuXqc9qC3ezQ82gZWiKsoBIXZNiu7+49uV6TdAkXsNm9yWJn+mJW4BvCR1Kj2ij2rs3ccq2K84yjMkrHi0xRqjSy3Xc/7rEE7+23G5Ew3AUDayvZemklJ99IZclkBHlRqWUPH5bVLRL1haKVvSSvo2kHmV0R1W8imaL6jYszqxiCXkLK18eFCBQq16Xhl3k9Un4ZSiM2YsJGRRPoSdlPG4wBnifTChu95FLR5p89nLdkq7uiG4XpJXQPqArLTWccu19Qwz+JZO6q/YLZo7UWPQdNSe5YhbeCo5+Mg8D+mmf/ZBKd2yriZekCLq1KynyLEJcGjrS1h280O7fqbeQyuvl2URgdgGV3wJ1WfvkBHuzHqc04Sgv+2ugBgAYpkcRZFqV3EiR2iVbReEcBJwVJLL6g+PHBfBNr+0YKWh1sCn9pYndVBxWSxF2HBn5lsEwOB2Ls3+LVgUeOg2oMXop1Gi93+dBMDMSNTeFLCmz/b8Wq6adQttFVtMSHmAXkWkZUA8/rkI/9m9OoGw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjkwbFVSdVdRNnAxbldQRTRmcTFMaWM2UEVvUzd0WHljOHUxc3JMN2hKMmZG?=
 =?utf-8?B?a2E3Q1c4dnBsbnI2ZzA2dnc4WXpoRUlZU2swQjRLaE55S2ZMamh4ZHVXS2h3?=
 =?utf-8?B?eERNWWpqTGpJaFB6VUMwOFpYdG1IWVQ4NlFPS1h6R2ZBN1ZkVHlMSHZJNjZH?=
 =?utf-8?B?enB5QzJKdGhOazN1T2dBbXFuTEpXanZyOWVLRGNzaFNxcDRxMStYWTc5Qi9I?=
 =?utf-8?B?KzAvc1BaclVtbWp0bXZLdFliY3drMlBLMGp0RGp4V2RkWmVCczJnWEJlaTE0?=
 =?utf-8?B?aXBCMnpUL0hxZ1FGUGg0R2paeXN1UXkzYmZLVHpoWUxubjB4NE4wek9ZREJj?=
 =?utf-8?B?VUhpSnVFMVVwTXBNa2dybHZoWWtsMUpBQ3hFUUhrOXJzbXoyQ1lvMCtxOHVQ?=
 =?utf-8?B?SVp4ZEhSNHVocG8yYVV4VjdhOEVSbzI1clczSVhoQi9WSWowajVaWEgwQ0Zz?=
 =?utf-8?B?YWRZdnczVlVHSVI2a1hvTmh5S1dESlBuNTBBbWNNaHNHdnA2WXVxK1E1L0ZY?=
 =?utf-8?B?N1dnZ2NyTXJUcXJiWmpwS0FwYnMzcFYyWGwxRmhmSWg4NE1nMkNjZktzd29u?=
 =?utf-8?B?TllnVno4dkJ5S21kMzErZkFaRzRMRUJ3NWY5WWhEbktXTDNEcXh1RHdoRytZ?=
 =?utf-8?B?Tk5KZ2M2L3lUK3kyMkxreVgvQWhBMmpJRTlncXpFTWNGSXFNOGd2MG5HNnB2?=
 =?utf-8?B?RVdYSndyRUUvWUNrT2Y3VU42Z2pvTkxjbGJKMTVhWlY2dFNIdkV4MFVmZXFN?=
 =?utf-8?B?Qm9TVXliRnQrSmFRWTBmb2NtbEJWc3dEQTBQb2FISG5lWkJ2RUlMdFRjbWVM?=
 =?utf-8?B?UEtqOTJJN080VkluVmVrS1lKVGllTFQ0THo1SGd6OGVCWnBKT3NFMjhZTU00?=
 =?utf-8?B?THNvNUtlcUVNK2xUS2JUUWJsZlpDZlR3V1B6ckl0dnl1UkFoK1hJQ1VyUGpm?=
 =?utf-8?B?RW9icHcyeTVmY1ljSTNUZGJTZTF6WDlkblUzSFBLZlh0SDZXc05sWFI3M2ZU?=
 =?utf-8?B?MmJtMGt0MHl4UFl5TGMxNTZmUmswcE5lbk92TjluTUNrUmZYeDM3RWNIWmZw?=
 =?utf-8?B?WUp2RnVvM3N6MDlzNEJrOVVEeWZzZzEvMTJ6Z1l5dEYrSmZDUUMrelpQaFBq?=
 =?utf-8?B?N2F2M005SFRjbE5VRXZ2VWVFVFF6bG82UkVtWVc3eVdnc01tTkgrL2hPL3oz?=
 =?utf-8?B?eGdtbU0vK2dSRGNVS2NSRmNmQmlDeUFIRTZyT3JDbWhKbEZ6bDZ6WnYvbFh5?=
 =?utf-8?B?d3FCTXZFZ012QS9pZlNuT3BzUDdodlQ4YlF0a291K0lJaUZLWlJuWVRxSFFl?=
 =?utf-8?B?VEZvMFd2R0t6dldxaGpNQlFCNkhFQW5TYnR6NCtVTWdsSWFFc2tFcnJwLzF2?=
 =?utf-8?B?QjRVeER2b1I4cFd2WHM5QXYzaUZ6UU1MbXF3SUc3aWN5cW1SQmxHT0RNY0xM?=
 =?utf-8?B?K2hUSEJVZUlVOTA0WnpRaEo1Uzh5UGlCR3RFUWRkbmoxVDB1cHlTdGhOdUti?=
 =?utf-8?B?aTVNNnUzQ2tYQ1Z0Y3ZxbWpaM1habWw3aW5tZHlLR3dzbFVOa0VuQTJNM1I3?=
 =?utf-8?B?Q09LZEZ3dXhQeU9uL2hORFp2RURtcjJoMzk2QkpoeG9tTnVBWmdlZHpxMHJC?=
 =?utf-8?B?aUV4aENQVXFvK0lNeVRVZ1hIcUhjd0YwV0hYclh4ZnV3WUUxZE8weDF6Z2tQ?=
 =?utf-8?B?Q2pSV3pXVnB2eXk3QWZzb0NxTlBYYnFFK0pyc2s2eU4ya3RTREp1RmJTT0pO?=
 =?utf-8?B?OHNxbXlxYzdRZVhSS0p1eDA2OW9iWGYweW9WbHJzL2JkUXE5SGU1VE1aaE1t?=
 =?utf-8?B?VjdhNDlyZ1ViZDNSRWplcXAzWVF2RHFpdlZFVlY0SGFTSlI3cXRkNnl0dSto?=
 =?utf-8?B?RU1WVXlZcm1LRlpWaVhYTDF5UlU3OFMrVmNGWjFtazc0dVpuQzNiUlRWK21Z?=
 =?utf-8?B?UWJ3ZmpGWTVNVGNDRXpUQVdQV2ZQWnJQMm9ZOG9jY0ZhS1pPbDQzYmZyeGZH?=
 =?utf-8?B?UlBnQ25kTlc3RWtaVEwzNForajQrcTVUd0hic2NCa1NDUyt0MERyRUlqd3FC?=
 =?utf-8?B?T2xwSmhDM3ltaUZ0dVRrSkkzRDMrVlRkZG9vdG9YQVMwWTUvNjg4eS9MVTk4?=
 =?utf-8?B?WFVGT3pqNGozSmhCYXFFVXpweFpueE1QZUhoQnFocWZreG9sdnVSdElVVkpz?=
 =?utf-8?B?NFdxWm0zQTEzVUlxTGVvQktZbWQ3ZmhtdVdqcnJTby9iMkFXZm9qeWdRV1pY?=
 =?utf-8?B?WkhScGpUYWxOMWFVNUQ3MVI4cU1lWFVHQmt1SEJzM3QwQjdabGhCNDhpNlFE?=
 =?utf-8?B?c09LVU5mQVA0dlp3eUJCRWoxTGk4SW1GZGVSRjBqbzVIMXZVbjdCUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb92047-b92c-48c7-35bd-08de8920bac0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 21:11:20.0714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GXvMBdOMamI1vR30kX//lH6ow+ovS2kX+jppiAaDcUk33TvllJ5m0eIrkamFiv/H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8756

On 23 Mar 2026, at 17:05, David Hildenbrand (Arm) wrote:

> On 3/23/26 22:02, Matthew Wilcox wrote:
>> On Mon, Mar 23, 2026 at 04:24:26PM -0400, Zi Yan wrote:
>>> On 23 Mar 2026, at 16:13, David Hildenbrand (Arm) wrote:
>>>> I assume so, because for executables you would have to be lucky to get a
>>>> PMD THP? So I don't see the non-khugepaged large folio support on par
>>>> with khugepaged support.
>>
>> Not necessarily that lucky; if you set VM_HUGEPAGE,
>> do_sync_mmap_readahead() will allocate PMD-sized folios automatically.
>> On busy database servers (and is there any other kind?), khugepaged
>> takes too long to run and find opportunities to collapse text pages.
>> Like, days.
>
> Yes, in particular given that the default khugepaged settings are awful.
>
>>
>>> It is more like turning on READ_ONLY_THP_FOR_FS by default for
>>> FS with large folio support instead of removing it.
>>>
>>> OK, I will give it another try.
>>
>> I think the test needs to be:
>>
>> 	if (mapping_max_folio_order(mapping) >= PMD_ORDER)

This is very helpful, since I was thinking about using
mapping_large_folio_support().

>>
>> as there can be cases of filesystems which support up to, say, 64KiB,
>> but not all the way up to 2MiB.  I disapprove of this situation, but
>> this is where we are right now.
>
> Right, that's what I had in mind.

Does Nico’s mTHP support for khugepaged include changes to collapse_file()?
That might change the above test.

Best Regards,
Yan, Zi
