Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010029.outbound.protection.outlook.com [52.101.201.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE0C3E0C54;
	Fri, 24 Apr 2026 14:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777042755; cv=fail; b=MT1WSt58GAarc4v/TpIpVgG60HH6vihFDYutMs081c5OpsI1y3w3ZDVlLjJs7m03ZHpDfaS09cr0Pewnn8TIgCnomNahKtHkOWUqhzK3iV+ZIwNsia4zsjJk5N5ErBRLYyQLHkzV4oxsyo2An9UT26LuFtaKfSDoT6lMEFPxFv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777042755; c=relaxed/simple;
	bh=Bsvvxrwvfzs6Ivx8c5RfKsu8IXC9jXiIA0N//FLGjYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S2nJp1zjlmRL6nbkctmcV4cguupHXGYS5wr6HvSG4Nf5foDTNX6Be2Fms5Byi6vHhXhGcC20RPFyifL8+LCn3azHJ5hN6ntQItMwxhISNRQZdx48wgOQ+PzQKCuK87W/+wpo3bsvGypIvAPXaZEygY6Qwu1++Usl+Lh7ieITVzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e+BOOX7p; arc=fail smtp.client-ip=52.101.201.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e+BOOX7p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bu9mAEKjGNHHl+hqWzGL/tuAlEe8xcSXKpc4hpn/tZuWXW2ee75mVpoD4KjnFcH0TNGJzb4tBaji/47NH7uA45MYLKiG6SXlTmhucLqluvxf9Sdt7HLY7t6tDRieiJvin6Tw+KPzHwRFanGOu7g6kh1aOadVSZeL7zBd0YHQEl7SRmA//tlas2hOGQgm2T3rarjSVL3qhhEZ/4chEg1Ko1KVKieLr/GbYWk5Z9wz7WsByB6Jg8VAsU1z7VCv/RLUQRRtosCTkru10Ll/SjS+GZCTHw5T95+GeJ0kWRvZdoqgjVgrmTeAjPp8EHt4Sbk2A7oYBZzQSz6lQOjupx7FYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8OyorUKiKd9nmPgmT3zk8ckvL4SMqPdKpu3VLOTZiJw=;
 b=VFDS3TUk6Pzadq3/SjnEjLDpveIDPsf6BL7nNwnPasVbYaLTZuL+hUA/QtNXhfurygsGTD8Rc5BGPzV0mgtEF/9bwIvBMlA+TUhCkKg0A7NyyveSztxov5T0xBIysvx4I3sZLlEAuxHIKFSYUs2rhnDVjHZ2lXhD9Mec290O3PEgi2wlbP1OAaH82CeF8vc9qSGlKB1ncLuK5i7kQcSdwPRlC0UbiNJvTfypiHMnAelTVJrUt30gMspkGAk0JvFeZ0tQofp6eNVtFK5jGaeGviquwNGdhsumMBquLLVrSPUfJI13sS3wX4X5FxYulSBcXMkLunnHx87x3hDi2h6srg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8OyorUKiKd9nmPgmT3zk8ckvL4SMqPdKpu3VLOTZiJw=;
 b=e+BOOX7pBvhkW5pyF1ZcqVipWy27f8DKjlgz7konIXvD/qRsnLqQHQkG+rikaGk+QQ+cLw6vswxyOjBBoOzPx7D7oMP5Pn54g9U34CQxxQIUQmRUCX0+tswTL7DQYVFxWbX1Nx6OOtaAMX+MDeJVALC7A7gFgV2/v0tsQpygAoPPPaaDbkMq8CCtaJvRCap4luZQRZM5vYEdO9dDDA1Lc3+Lclj5qxUuBEjhr+lI4m4xoWi+9UeV8OUl2w6raVIbz7ZEv1wrk4Ow8Ml6YPtX/HtyyTRNO4j3lAuqWL3n6zXDImZV2xUda70WTE4bHItFfcoUAXDV6Cv4N/hTtYsylg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB6764.namprd12.prod.outlook.com (2603:10b6:510:1ae::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.21; Fri, 24 Apr 2026 14:59:08 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 14:59:08 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v4 04/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_enabled()
Date: Fri, 24 Apr 2026 10:59:05 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <E5433CE8-3C69-49E3-9D29-BFF5BACC843F@nvidia.com>
In-Reply-To: <312bc872-be82-457b-b0dc-fae7f4e15bbf@kernel.org>
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-5-ziy@nvidia.com>
 <312bc872-be82-457b-b0dc-fae7f4e15bbf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:208:36e::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB6764:EE_
X-MS-Office365-Filtering-Correlation-Id: 45d51d1a-1fc5-4649-b9ff-08dea212097f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	nei2FSomZftEgtIVPGMJuecNUXFOG8PC3QaxhdF8Vz7Hxx3VmGmJqXwKWG+wtu8ZZ6mulkLw3tYIWKoHSrHWz+jEL48v0UhBGTW8Qb6t3QZL6UkRwVpj0PlBwFyY5nlwtmeh2Tl6Iy0bwBns7ebZaPsvY4JQs++YzpKYnDUK4Vo8xBdcsp5ElrNBjvRsOPQWDO5c/BtHAxK7zHWzw1xQ80XeM+fFOhYzCYYtYbUlmIkQDhZwxKZ37pJGtovFuRmwmx8E2ARA9hDRpfzFqpqmg1ezU02jMWYTGbxfLXdkHlU5xJtifKclnbNZewM66RDwU0WcGin9RjRMx6WK8LUpR3ZhccZeulX+9RT1PMKzYv6Ez5qR5BxaB/iUUBAqX5ibk8NhRJatn8nlVTIaU0GvhxISW2cCtadQt6GW3I0GIse7AhZmSt957Fe+ECe1Fdfxtfbn2/cQKHUPgA6n5epPrHgSrnRWamD0IkiXslM+9iXAdvLt8Le1CpXevK3OnJ1ZawULvobPODtcGcdvvgzmIpfVwomtfB2SiA4Vz9bIduBR66EyZQab2+vKi/SgIjeHMtgGHAFRX/yRCHyQQPb4tEs5K1ZN8JSHOOispqsL6Egt22xMYmvm6BfF1/lqCnVFGi11YGo+7qWXot94b5mzenJGN2iIVTQUTdkwq3Z4xsFIXTZrTWkswRQbRrHCPRIlKWcq7A0IM5yzAIIktdAdHZk2kSogBYicdFZVF9mbGSY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2hRNWZZOHpETnl5djVlL1I4Y1AwQW93alA2S1NJTFQzTXU1YjZFMXR4c2c5?=
 =?utf-8?B?QVRkNlRIaEpUM0xEeVBmZkNabkdRbmhrUzBxM1dMZXVLbVo0R0c5MjVXU3R3?=
 =?utf-8?B?ei9JRDhlcXI2Sy9Yc2x1ZW9KWnBoR3JlQjJ1ZTlwZFAxUmJxQ05yMEZuT05J?=
 =?utf-8?B?bzZXYXNxRnpQV1lRb3Q5REVQODlBeTVmYlJITnB2R1pPRnFBU3AyRm80Y1pZ?=
 =?utf-8?B?dDdxaUQ3dnl4QU15LzM3aUhwYkp6RFJEQkgydzhIWFNRWmJrU3h2UjZybTJR?=
 =?utf-8?B?WE5OcTdSZGh3dWxpTmg0WmlZWFlHSDY0KzZIWi95T1p6aGxrWm1FSkVJa3Z6?=
 =?utf-8?B?SDEraUl4NlhXOVpHeVJ6SkZqaFU3SjVoa1FRKzZHZ1VaK3o4SXpyR2JEUERa?=
 =?utf-8?B?VGFrV3RiYitaVTlXN0xpMHNNTDdvMm1uaklPN0JiZ2cyVEM4dGFuaXp5SU82?=
 =?utf-8?B?WnEvWHhZUGdvRVhrUHQxMGo2RmdyVEE1NjBUOGtwdk5pNEdURkdWaGNPeFJC?=
 =?utf-8?B?NnZqQkp3WVFuc0JRN09MU3FUaThPd092Sk0wMEJ2ZUhvK3JCYmVRNDRWdWNz?=
 =?utf-8?B?aE1HKzRkK2REOEI3NEZjY3Yzalk3MkkvQzNrTm1QQUxrdHN3Z2RKSXprdklz?=
 =?utf-8?B?TXRILy9IanQvQ0pZTlA3eXBqci9WU0dxTks1RmJiMmUwTE1PRjg0TXVUc2Y1?=
 =?utf-8?B?MGZUMm0wMDFYa0pRNUQzMnMzWWgxS3Y2RDJ3bFRUM3pnSDNtMVFVMkRrMWpk?=
 =?utf-8?B?d3JMRy9OSm5hV3VhNWFBVGtsbGQ2Ymc0OExOUjFNRGRUQTBsL3RzL21pNERi?=
 =?utf-8?B?dThoRnB1ZVM4Uy9ubG91WFk5RXdVTURodnBhejRTNlFaR0s5YzFRY2Nzd0M4?=
 =?utf-8?B?b0xJRjR1R1k3UUYveExjaUVGSUdJRCtvei9EODFtajFIeUxZQndldE9xL0JW?=
 =?utf-8?B?c25WdEJBQjVrcXR5Q2tLWnBxRVJrWlRYL3FDSm0xM2xYa1hCNlNqS0ZSb1ZI?=
 =?utf-8?B?cCtiTEl2SzRqNUppa0t6VFNmTlVTRW5KbTJqZExuQXk3eHV1U1VRYTNjVEsw?=
 =?utf-8?B?NVl6Ty9OUmNXSTdseVhDMWtueVZPZlB2Zm92NjY5T1JyTzhXQ2d3Z2ZXWFky?=
 =?utf-8?B?VHZhb0RjUmtIREFkMTNvK0I3N0dRMEFteGZpYWhuMVZYaXFMS0MxMmZ1RW41?=
 =?utf-8?B?WHMzaEtGMkVqUjdCTDRmcnNCYWpuWnJWM2QyREF4Z2dGQWl3ZDAwMktVQmpt?=
 =?utf-8?B?QkI2VURNSmtHVWg5NEFpbWVZVXFrR1YxZklUcjc4WFNUcEFuM0FDQ0tuKzd2?=
 =?utf-8?B?UDRrb2xvZWJvdlVjQXI3dGdzV3FsK05MMm1IZGNYSVZoRjV1YWg4MzloSUdH?=
 =?utf-8?B?UWsxZm95R3MrSVA0UUlsV2JieGdCcVJBNFZwMWVUSUw3dmw1SDVveGdyMm1H?=
 =?utf-8?B?Z1oyaU5CZ3ZyNFByZDExb3hSTGd5elpmSUVKSEVxNmIwVEN2N0xaams1SnRv?=
 =?utf-8?B?dStKajVCZWVma1NsR1A0Z3MxVlBqOGhJRlRQSlNCcGsvZFBYallFeVhSZFZu?=
 =?utf-8?B?b2ttTVE3ZCsvOWNmS3pzUGdsYzZMOEZLRUtLMTh1MEN0ZTZrZ1RsMVVoaHVi?=
 =?utf-8?B?U1lqaVprVFVHeVFLODFnOHNnTUJpN2RxUExVT2pkSkowbmdoSjh1N1FhUmRY?=
 =?utf-8?B?UzdxTEE0NWxmTllMbmQzcTM4R1M5RHFDa0tXbC9PaVN0TWE5Mm1HMGFSQXl0?=
 =?utf-8?B?dXgzZXQxbEJSUXJwOXJwUTZJbUY4dWs5MGN1UnNPRWpwbyszWGF2UUZiY3hj?=
 =?utf-8?B?UWVzUmFpeWl6amNIelpaN0lxQlhIQi9XQmdBUXNaSDlSZE13U3dBcDdqZmNI?=
 =?utf-8?B?NjhHOUdWSDFiWFhIaktKV0RWOGdSOGwrL0NXQ2piSkIrV2h6c2RHRi9tb3Nw?=
 =?utf-8?B?NjNNVWJ3NTh1V0xhamorYmJ5TGpHRm8zVnNqSlJDdVhyQklYUS9aSWJ6cXJT?=
 =?utf-8?B?MHlmOGpyT240b3dYNXdBWURpZEZ0MGFqSlBpMTdnS2xMT0RCNmhTU0owZGhG?=
 =?utf-8?B?OEVKcm9LY0JtUDgwRGR6eTRVSENGRWVvaHBYSkRNTGNCWlZHMUJZd1pHdUJD?=
 =?utf-8?B?M1N3aHFhazU5UTJWMmxveEh0c0hWUUUrSFRQdFpxT28vc20yNnFWaS92SnBG?=
 =?utf-8?B?SWFrV2lRQmpYYU51VDZWa1IxMlF0RVcrb3k2bTBJalJlc21ZRHpJTTc1RVFT?=
 =?utf-8?B?YXlOVFVqb1JoRlJmNzVmd1FwNnBaWXdVd2QyUHdJTjYrSCtSbkNKL2FOS2Nv?=
 =?utf-8?B?ZlhobkcvWjlkdjR5YVZQcHlaQXlEcXRKc1k4YnN4MnJGMHpqSWwxQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d51d1a-1fc5-4649-b9ff-08dea212097f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 14:59:08.6799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /SlfQDOf/R9V7D3hCiqmZitqedUrYTGC4nzbCBQSTxnlDZOmw+QMqt6gUwGSgxfk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6764

On 24 Apr 2026, at 8:47, David Hildenbrand (Arm) wrote:

> On 4/24/26 04:49, Zi Yan wrote:
>> Remove READ_ONLY_THP_FOR_FS and khugepaged for file-backed pmd-sized
>> hugepages are enabled by the global transparent hugepage control.
>> khugepaged can still be enabled by per-size control for anon and shmem w=
hen
>> the global control is off.
>>
>> Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
>> IS_ENABLED(SHMEM) in hugepage_enabled().
>>
>> Clean up hugepage_enabled() by moving anon code to anon_hpage_enabled().
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>  include/linux/shmem_fs.h |  2 +-
>>  mm/khugepaged.c          | 26 ++++++++++++++++----------
>>  2 files changed, 17 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
>> index 93a0ba872ebe..acb8dd961b45 100644
>> --- a/include/linux/shmem_fs.h
>> +++ b/include/linux/shmem_fs.h
>> @@ -127,7 +127,7 @@ int shmem_writeout(struct folio *folio, struct swap_=
iocb **plug,
>>  void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end=
);
>>  int shmem_unuse(unsigned int type);
>>
>> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
>>  unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>  				struct vm_area_struct *vma, pgoff_t index,
>>  				loff_t write_end, bool shmem_huge_force);
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 726f8ace01af..cdd4b37e4a68 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -524,26 +524,32 @@ static inline int collapse_test_exit_or_disable(st=
ruct mm_struct *mm)
>>  		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>>  }
>>
>> +static inline bool anon_hpage_enabled(void)
>> +{
>> +	if (READ_ONCE(huge_anon_orders_always))
>> +		return true;
>> +	if (READ_ONCE(huge_anon_orders_madvise))
>> +		return true;
>> +	if (READ_ONCE(huge_anon_orders_inherit) &&
>> +	    hugepage_global_enabled())
>> +		return true;
>> +	return false;
>> +}
>
> Ah, that is based on Nicos work, right?

Yes, since mm-new has Nico=E2=80=99s patchset now.

>
>> +
>>  static bool hugepage_enabled(void)
>>  {
>>  	/*
>>  	 * We cover the anon, shmem and the file-backed case here; file-backed
>> -	 * hugepages, when configured in, are determined by the global control=
.
>> +	 * hugepages are determined by the global control.
>>  	 * Anon hugepages are determined by its per-size mTHP control.
>>  	 * Shmem pmd-sized hugepages are also determined by its pmd-size contr=
ol,
>>  	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
>>  	 */
>> -	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> -	    hugepage_global_enabled())
>> -		return true;
>> -	if (READ_ONCE(huge_anon_orders_always))
>> +	if (hugepage_global_enabled())
>>  		return true;
>> -	if (READ_ONCE(huge_anon_orders_madvise))
>> -		return true;
>> -	if (READ_ONCE(huge_anon_orders_inherit) &&
>> -	    hugepage_global_enabled())
>> +	if (anon_hpage_enabled())
>>  		return true;
>> -	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
>> +	if (shmem_hpage_pmd_enabled())
>>  		return true;
>>  	return false;
>>  }
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> --=20
> Cheers,
>
> David


Best Regards,
Yan, Zi
