Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E452D3346A8;
	Thu,  2 Apr 2026 14:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775140694; cv=fail; b=SauvzMt+3IMH6zR5YR+OZ4oTVUjEy3jCIgQeMUMkiMIaWulOWsZqTbiSwxGdwSvt5pWypxSqWeyzjRcCTthh0rMZsMcgAaEADJ9J+xftwlpHoyHnPjo/m1spbSaGLzeA4zFwiHoD+tUbqm6H/qVgMlVs6hzdFP2oq3LlOvYrfJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775140694; c=relaxed/simple;
	bh=CyLOBn/bpQG/lsbmrDGPmp5hSoD/pxHC64hd1Iz1H64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ahNfGM0D8uD7Jm0PmgOatc0lFdMuDteioI6xLGJVHh62muexp7e+VQDiCji29lNQAyjbO1cIOJr1x9e10RTXrZn5HONyPIhQixEenKBeU/eOULdsujnfJKTrzTmNPRmGd4+21XbtwI2Xno1Y/Ss47jO8tgq0Z5Q55mo2jZ19cAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=T8GNyW4h; arc=fail smtp.client-ip=40.93.196.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="T8GNyW4h"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aONVRPg9A3nvD8zpUK8l7e7YJJ310hw/LxGytaVpXHptBFr+R8SaPEPNDKZyeYNfqpbl+gXPF4/PyyRX03IqNSvKV9g3OBOvdfbCEobgKlioV4IN90Fcxzzijhd0StUIr9Iht4hMGiokcbTEJ7gKigozAIaCfcWYHcbF17KFafqhtqa+1m8kmcvWeDJnEGszEdYBooLBsHBLApJRM8nn96E9Q7uuG1LME46N9wZkbW8T4z1aUPEYYH0Dw5ufASfVKU8vR6LOwUsOj5WHZUdEgBWK6Usy7h3DaD5DnhhthQtyoWLQ5ObDbPqPAj7aYE2ZVQMkn7DJyyOrSjYabs2ZlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CyLOBn/bpQG/lsbmrDGPmp5hSoD/pxHC64hd1Iz1H64=;
 b=f0ZBfDiRUiduGf5E1px9GBHPhxErAoBqOu5/74oabps2bHt86ZHSxH7o79MhvyapQ6LI2sHD/szs1eGhdGdb057YxsVL44YEdGdC739Z+tiRFddqsJknFPvyRle5F+4RgkDkFHUyuyMPcwVdCn5xE5YGQKZRCjzh6vi5wFS5PfwkqtHY58EotdCMSTlXP0TmFktFhFSjvdOnf1z6hmrcGSDwZkqDW1/OwtuAcVMRvrujgHYVb7zXK2pN6aCzEmexlz617wSa53mrBNw7bmObZG/LPy7V0z3Pyt9aEJVKYMtokhu92PVyAcUeF3Wh8J5GO6uQYXl8iXeiuuiGqnZqdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CyLOBn/bpQG/lsbmrDGPmp5hSoD/pxHC64hd1Iz1H64=;
 b=T8GNyW4hS1VgZ1q7ThtROtLXoqYBGKXaxoE5nDk6VytCf9cxIwW5VgivjoNlmC1DBbtvqAlwv8EZZkcSivCLgIOG7KsTQ1GOleArEnOXXmFidqRTHfn0SJARs8+/lh8FdT/4klA6f/mszMnrNgF7n+px637Aw3m9xafRtII8nUAMALHleA9bh/EfLZqYLT8dNe0T2405zcEQpMfbAe21+bS1vTEKjBJz5xPGV1CpztPeiRy9lpI2k/Dgy3MyVojueaP1wBkLtKCGAdcUjSNpy5whF2x79zMqtaiFltYBuhLLYeWf/Ouy+fUUPD4q/McQLuhQBZQHylmjGNbZW+h4nA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN6PR12MB8472.namprd12.prod.outlook.com (2603:10b6:208:46c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.21; Thu, 2 Apr
 2026 14:38:07 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Thu, 2 Apr 2026
 14:38:07 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 03/10] mm: fs: remove filemap_nr_thps*() functions and
 their users
Date: Thu, 02 Apr 2026 10:38:03 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <AD7586F0-7480-4A34-B83C-F332AE9E36B1@nvidia.com>
In-Reply-To: <d1fa25cb-083a-4afc-afce-a62929acbb33@kernel.org>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-4-ziy@nvidia.com>
 <aaea8ce1-eac6-49d6-8c85-7361977b9a9f@lucifer.local>
 <b098fce7-be16-479e-b9a4-36f0ad71d242@kernel.org>
 <53cf6157-58b1-4539-a276-2486e8796c57@lucifer.local>
 <25899F67-955D-44DC-935E-D7F234BD335A@nvidia.com>
 <cd36fe49-56b6-4ec6-8dc7-9c793f939bb5@kernel.org>
 <EF04F17A-89ED-40EB-BA91-7A82713E28F8@nvidia.com>
 <f7e1bdbf-cb88-42f0-ac48-1a273bda2455@kernel.org>
 <44DEB48D-589B-493D-A278-4896BDB58564@nvidia.com>
 <d1fa25cb-083a-4afc-afce-a62929acbb33@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:208:91::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN6PR12MB8472:EE_
X-MS-Office365-Filtering-Correlation-Id: 0108bd6e-68b5-47da-7210-08de90c574d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	D+V3VyFaGeFlIzsBCOdmEkuJhXf6Gkj34H7XsD73cd8elWZWQLc2FMNnXkgoTuyzJ5+/vz0HVZUo6KquPisz6itz4Mq5VeLHsC7AE01TO89a6/jP23YRXp+xJ6KO6lFUERm9dujkvjr0I5YuFafg8l0pWMZiyZOjhkWV0/hdhqUL1L9w8DLGcqhvhua+qjLc+OrN44q6cmYxNfyU1sbfbVBfmZFmuhMXC4vZjUu5Jbq1r9mPWlsIeZzwiVAmWBmwRqgpSAj1qFZ4OjwXvZylLjPttGpYyKoZ9nGq6IYqB8wAUM1CDR5BrP0uso7x5KXmMmB97sgicZuJOf6NTQdHbrR6nL4kKckpm85EzX5xVPrB+SOI8YrEEujheMA28+jpLuRkh1i8bW9OGdPS8pquGEra4ouFXc6qZ7ZGzghGSeL9sLPFhyJAsDiwJWhaiB1EyfY/F2cHihBEDqGGswVvfaIIIkm10U7zJKSfpsZ+S5xZt7UKhEKPBQtqwS/PE9XEoOnRl/OXQkU420cCt7Qb4PSOcUDcX4cl+qrf4jzo5xUgoMyjzK0LQahCTqPXVZritucl5tmibqVd0p9xrXMLvQE+9RPOU2r3e6TznIC5a6u7eMlROSoz+/vgDJ3bmF0s3+LA3E/Nrv8xPH6xgwse95iwqLIAibv6YcoWBdDABT0vxV3mf0NCsOAzxfkE76ribwYNZyi0JjQPbCUYh5TeCbzAy6yTm2rcqLxCCEUQRQ0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2lpU0hyZEJLT2NqMVo5eXVhTUJlY3U2RDNtQjNFd1p3UkdVVzcwWWxwZkxU?=
 =?utf-8?B?NzRaWmJ0QUtyektjbGo3OS92ajdhZXdHazBMbm5JZitnU3p1dnVDVXViNlov?=
 =?utf-8?B?WUp4bG12SW8vb2ZKS3NNNXNpVHF2UGZKVFZuNHJkRXJTV01LTGRPdGlnSm9X?=
 =?utf-8?B?cElrOUR5Q0xPRkkxUUJFa1lmZmZaYU16dFJqQkVQNUpVb1A3bFVmdEs4Z0RF?=
 =?utf-8?B?eEFZMFRjUjJkUFlMMlptWXlDOXRNaVgzYm5WcHIya1l0SzFQKzdycWhXS2lW?=
 =?utf-8?B?aXRpc2lvMm14MjB5Tmp2aDE5aGlIM3l3NTJ5b2M3b0ZENFVNUVFtN25tV3hZ?=
 =?utf-8?B?TkhjUFo1d0ZyMWVMZ2JMMlFNR2xmUGkyWjQvWXM0R252L2t4akxVZGhzVlFS?=
 =?utf-8?B?cy9HZXRadllGOHVNQ3lXN2htRVh1bGl4VlNMYkR1aG9zTzR3UHJpb0ZpYndv?=
 =?utf-8?B?RWsxcEhlc1VJSEtqSVJMZnY2V2ppcjIzM2plcC8yZkY2eW9rV2VVQWkza0xQ?=
 =?utf-8?B?dms5ZUxOVU03MW1SVmhjTXRiNDllSjdlQlhEWUpkU05sSm12WTMycjYwZi9a?=
 =?utf-8?B?ZVRncG1ObEtOMWY1OWNPNnJOZlZ6TnQ2QnNzcks0OVoxVkRNUTFwdStWMk1o?=
 =?utf-8?B?azd2S1RtRW5BQkpMV0hNQnlaVmxmRm5EQWZoVkxpcmhIdnJPQk9DWVpRU3JG?=
 =?utf-8?B?Yi9oNGx1eHBoeWkyRDFsWXpMOGRzUXhNbVhnQVZCNTZVNFZPQktBbXBoS1JG?=
 =?utf-8?B?S2RWS3hmYitINWZDUTlhMDY3UzJRaWl6clkwUjVUU0FySGdUZ0ZnWVNMODhV?=
 =?utf-8?B?QmFOUUVsaWpQNE1sQUpMOERvSEkyU25aQVZJWVVHMzE5K0VpM3FXdHdCR3Ni?=
 =?utf-8?B?MzcrcWFiMlhSakdtdHR6TGdQeWtSUTdUV1BKT0xaY2t5UG1ieHpDaFN5cGRI?=
 =?utf-8?B?RHRRRzVsUXdzVE45ZVQydEdvc0lPbEkwMUI0REl6ZDlpK2dsQ283Y2U4RUFh?=
 =?utf-8?B?d3YrQW9JeFpmTHBKa3VyZHFlV1FvTzFUN1YvaVZDR3N0QkJrNGtyNXRjVWdx?=
 =?utf-8?B?eDdqcDdmTWxRTEhaK3NCMzZDalRiaUdRbmUxczJrVWZpUEJ3ZnVRbk5MMFpC?=
 =?utf-8?B?SUd1N2pRc0J2VHd3VWtna29kRXlzRTM3M1N2cis4elNIYnRPa0s0UklxQlVB?=
 =?utf-8?B?NllZanlVM1dVNDBMeTZrU3JFS3p4UHNEeUxxTHcxd3ZraWM2bWtSNVhGd2U2?=
 =?utf-8?B?Yjlpdklra3dTblcyZmJja2xQWkhHS2xmNERVRGlLODJJZWxlNERydndmVXhC?=
 =?utf-8?B?QUtkUDFiNnE4bCtLZnpOV1Nxb0tWZi9pUVRLWkhKNzlLVTB2QWd5bEI5MnRv?=
 =?utf-8?B?TFdFbFYyR29jemEvcE5MTWY1OTlkdWFiOTJDMzM1OWhoVUVJL21pdTdSajZE?=
 =?utf-8?B?UUcwNVR1anVUNk9wb0F6cmxjK1dGek9udmdvM2VDUmducWtneThobzlNcEhj?=
 =?utf-8?B?Tk9zTWhQZEpoQVl6Z1hSWnpWOGtmVmhUdUhLMkJaa3VZdG5saThTK3FHajY1?=
 =?utf-8?B?ZWlYTklXQlNOS2prc3V3dkV3VGhaN1JSaFRxbmtCVGQ1eHY1RzlzcXp2bkha?=
 =?utf-8?B?Vy9mbGlKcmswOHlTVmJLa3lsUGwva2l4bEMvYU0wTkVLQ2tqUTdPK1diNm1T?=
 =?utf-8?B?bW9KUUpaNEx5azBLRWZOWTJDU3V4SG1DYWpuSjZMaDVURmZ5MEVkY0xOMVNH?=
 =?utf-8?B?eTVkQkZNQ2JYUEVmVllkRnhxS3dLL2o5bW5ZejQxTG9vZWJvVjVMQXp5Qk82?=
 =?utf-8?B?cVBMNDFjdldVVkpVRGQ3dFdoYmNxSDRoWHFBazNhRFNPMGlRT1lWM24xWjdZ?=
 =?utf-8?B?SFZobDJNWWV6eDlXdGhJblNEZXpDcjIrVTRFeG5tTEZoUlVobFhOaFo4WlMw?=
 =?utf-8?B?OFIydHUxMTloMGRxb1p4WW15d3NpR2x0NUpHdjh6cmZwMjJ0QmxEVWd5M0dz?=
 =?utf-8?B?NzQzam5JTmJpelJEaWVNTml4OTIyZDlLWXFXVVlYb0VuRE05UU9lV0ZQNVZJ?=
 =?utf-8?B?dDgzY0d0YXZZT3RZUTE0ZzRCa2pkN1lYNEV6NHdQL292L3FmcnU2R3lXeUJZ?=
 =?utf-8?B?Qm15QWJCS1BQMmVaaWltUGJtbCttdmRBeE9hVG54cXlHMFVSVzN3MmE3UjVh?=
 =?utf-8?B?SjVKclp0aEptUDF5RjRQenl2K1JaaVlnQXZ3Y3RXaWlQem0rdVQ3TzFyMzJC?=
 =?utf-8?B?YnRGVFNhcGMzYzNVbnltcjZlaUUxRW1kSmx2TFB5T0pmR0JJUW5mNkNvME85?=
 =?utf-8?B?Nm1WZnR5MGVQQUNTSVZzWFBaTERDY1p2V2ozUzRSRENxVnFzVDBKUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0108bd6e-68b5-47da-7210-08de90c574d4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2026 14:38:07.7150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZnKHTV8uxjeCKAjo2luZG7vcp/Mf9cRwgxWY9kGVDdoBNkfbpQYwBA5tbUZM0NDd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8472

On 2 Apr 2026, at 10:35, David Hildenbrand (Arm) wrote:

> On 4/1/26 22:33, Zi Yan wrote:
>> On 1 Apr 2026, at 15:15, David Hildenbrand (Arm) wrote:
>>
>>> On 4/1/26 17:32, Zi Yan wrote:
>>>>
>>>>
>>>> Let me think.
>>>>
>>>> do_dentry_open() -> file_get_write_access() -> get_write_access() bumps
>>>> inode->i_writecount atomically and it turns inode_is_open_for_write()
>>>> to true. Then, do_dentry_open() also truncates all pages
>>>> if filemap_nr_thps() is not zero. This pairs with khugepaged’s first
>>>> filemap_nr_thps_inc() then inode_is_open_for_write() to prevent opening
>>>> a fd with write when there is a read-only THP.
>>>>
>>>> After removing READ_ONLY_THP_FOR_FS, khugepaged only creates read-only THPs
>>>> on FSes with large folio support (to be precise THP support). If a fd
>>>> is opened for write before inode_is_open_for_write() check, khugepaged
>>>> will stop. It is fine. But if a fd is opened for write after
>>>> inode_is_open_for_write() check, khugepaged will try to collapse a read-only
>>>> THP and the fd can be written at the same time.
>>>
>>> Exactly, that's the race I mean.
>>>
>>>>
>>>> I notice that fd write requires locking the to-be-written folio first
>>>> (I see it from f_ops->write_iter() -> write_begin_get_folio() and assume
>>>> f_ops->write() has the same locking requirement) and khugepaged has already
>>>> locked the to-be-collapsed folio before inode_is_open_for_write(). So if the
>>>> fd is opened for write after inode_is_open_for_write() check, its write
>>>> will wait for khugepaged collapse and see a new THP. Since the FS
>>>> supports THP, writing to the new THP should be fine.
>>>>
>>>> Let me know if my analysis above makes sense. If yes, I will add it
>>>> to the commit message and add a succinct comment about it before
>>>> inode_is_open_for_write().
>>>
>>> khugepaged code is the only code that replaces folios in the pagecache
>>> by other folios. So my main concern is if that is problematic on
>>> concurrent write access.
>>
>> folio_split() does it too, although it replaces a large folio with
>> a bunch of after-split folios. It is a kinda reverse process of
>> collapse_file().
>
> Right. You won't start looking at a small folio and suddenly there is
> something larger.
>
>>
>>
>>>
>>> You argue that the folio lock is sufficient. That's certainly true for
>>> individual folios, but I am more concerned about the replacement part.
>>
>> For the replacement part, both old and new folios are locked during
>> the process. A parallel writer uses filemap_get_entry() to get the folio
>> from mapping, but all of them check folio->mapping after acquiring the
>> folio lock, except mincore_page() which is a reader. A writer can see
>> either old folio or new folio during the process, but
>>
>> 1. if it sees the old one, it waits on the old folio lock. After
>> it acquires the lock, it sees old_folio->mapping is NULL, no longer
>> matches the original mapping. The writer will try again.
>>
>> 2. if it sees the new one, it waits on the new folio lock. After
>> it acquires the lock, it sees new_folio->mapping matches the
>> original mapping and proceeds to its writes.
>>
>> 3. if khugepaged needs to do a rollback, the old folio will stay
>> the same and the writer will see the old one after it gets the old
>> folio lock.
>
> I am primarily wondering about what would happen if someone traverses
> the pageache, and found+processed 3 small folios. Suddenly there is a
> large folio that covers the 3 small folios processes before.
>
> I suspect that is fine, because the code likely had to deal with
> concurrent truncation+population if relevant locks are dropped already.
>
> Just raising it.
>
>>
>>>
>>> I don't have anything concrete, primarily just pointing out that this is
>>> a change that might unlock some code paths that could not have been
>>> triggered before.
>>
>> Yes, the concern makes sense.
>>
>> BTW, Claude is trying to convince me that even inode_is_open_for_write()
>> is unecessary since 1) folio_test_dirty() before it has
>> made sure the folio is clean, 2) try_to_unmap() and the locked folio prevents
>> further writes.
>>
>> But then we find a hole between folio_test_dirty() and
>> try_to_unmap() where a write via a writable mmap PTE can dirty the folio
>> after folio_test_dirty() and try_to_unmap(). To remove that hole,
>> the “if (!is_shmem && (folio_test_dirty(...) || folio_test_writeback(...))”
>> needs to be moved after try_to_unmap(). With that, all to-be-collapsed
>> folios will be clean, unmapped, and locked, where unmapped means
>> writes via mmap need to fault and take the folio lock, locked means
>> writes via mmap and write() need to wait until the folio is unlocked.
>>
>> Let me know if my reasoning makes sense. It is definitely worth the time
>> and effort to ensure this patchset does not introduce any unexpected race
>> condition or issue.
>
> Makes sense.
>
> Please clearly spell out that there is a slight change now, where we
> might be collapsing after the file has been opened for write. Then you
> can document that the folio locks should be protecting us from that.
>
> Implying that collapsing in writable files could likely "easily" done in
> the future.

Definitely. Thank you for all the inputs. :)


Best Regards,
Yan, Zi
