Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012066.outbound.protection.outlook.com [40.93.195.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A276835966;
	Fri, 27 Mar 2026 14:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774622376; cv=fail; b=hqn2Nx5umLZILNZjf9inNc66NbiH7MWdYzboFFDS3pIrgmDanxSKLk1Bb3uRJKol63YV+BDOPo6UATnatr176TYvf0D/TD5pLzu+OAORhj5KnY6G5fX3EGLkUcYz9uUZhUqIBuNEK2sVHytZo93yT9f2xKSvI4D36DLa2SxQVho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774622376; c=relaxed/simple;
	bh=pghVerH0Wo73YIFl3H8Ygt+5ts8fNGvw/iwAJbDYxsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A0W/gl3gkLD+RB0M+auwmSDYNuEaIUmMHB8KRN1i4gWtzzsRi1NnZYuwlZus7vlITME5MhtoEbncXDDCn5l9ucN3na9p14H8XXiNjp0MJJBOTXNaaXghzt/SPILlRia5l9tr4YMJmRcnxtY5kHGOSCUs9d40nmVO7FlmRMICFss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FUqc+Lob; arc=fail smtp.client-ip=40.93.195.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FUqc+Lob"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F7dy1C2cfwkigY84X/a2gUwdk2Uj2xzo/2aG1Dyg+Ab8TaM3rBusiX9GtpGqRTcINZw7hLrCd6fRrcD6ymqTKh38U+JIoQByclM3DbV8gtIJsyCQsOaL+x8ac8YoU9mjUuoi4vthIX/SgUM5dHarSUJeaKSNnvJNkOp+3aQfQPceKeGap6E/kT+P2LFy1xXJ4QtrGG6Fbc8XNo/3INlQ2poJYIBaNy9I2ywbxZ3PErC6kczph82P76p+Xj/ss0z7I9OUa/0Lxpz45dV78hReJqIBugpyIXV6Q+5bx3ZTCWpPsSoYHZJrtWsuWrlNjpej+Ug9M2qdUWIKLj++LWhwZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8rWKVy5uCBN6KSv1zZv8IZaHOQ7/kCbvq4NBpu24mQ=;
 b=V+sIJfMmGwiAdJUDgL7Ly3sIwwR9q1f0A+G0774JXUQjZWRQyKNSfoPdo75sYHy2yH0UrtlBIyhzreuFyn0Lp44Mqp7UVEY7aiH661Q4ViCWtsmKeL1GXiOCiUepcxkbSG250KWyuJVK/LzMBM0ALrHrukSzBh2C1sk/YHtBWUTPbXuxAoIZCFjmeK9kxhqs5KwrLXD8UOXY9shKCQ3UvW6y1njwfBgZScejO4rrDDwv7Cz4U/MoM6UevgXU+hN0Fv/fNv5DYqqHBKxEwLhm7yL9ITZCn1tS/JM/Q3w7yel9pAg3ynajNArf2wHXyii8csGxeYsi54Vh2AtXgsbtvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8rWKVy5uCBN6KSv1zZv8IZaHOQ7/kCbvq4NBpu24mQ=;
 b=FUqc+LobXUAqiyYexylf/r+uZQO1OsF/S8dCVx+ZEA/tU+QMYL4wTh0Tts2VBNN4xeUrK9L1uvFlB1FunwiXQbor8v+8CIwOWUbmt79sNA0wh3/kfknfP560vYjXQrJR16JGyLDzpOkkEcnwS/sT0uhg8h9CNCY3jQv/9q7ARocE+A+a0CJDkt7y5oC4D5xBWUiGLQ7UpwwS17X3z5NO5pbqXQEc7QiBNwrDbXu0nECzd0gSSfLTtQ+ZareTMAGcShkHCo9NLyuNmDDaVjU6JG30ii0HGk+aaRVWQFGXRSzkmSJ1/q6w2rijbiE36dd2Z0c+D5rVc6a4iptpuLLMLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ1PR12MB6025.namprd12.prod.outlook.com (2603:10b6:a03:48c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.8; Fri, 27 Mar 2026 14:39:24 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 14:39:23 +0000
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
Subject: Re: [PATCH v1 01/10] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Fri, 27 Mar 2026 10:39:18 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <7F3413AE-19D2-4124-BDFD-4350B11E5113@nvidia.com>
In-Reply-To: <a7976968-3598-47d5-99bd-a144783c72f2@kernel.org>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-2-ziy@nvidia.com>
 <a7976968-3598-47d5-99bd-a144783c72f2@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0055.prod.exchangelabs.com (2603:10b6:208:23f::24)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ1PR12MB6025:EE_
X-MS-Office365-Filtering-Correlation-Id: cdc9a419-f8d8-4127-d518-08de8c0ea37f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5+FiLlElIjhtEFVQNeHGJ5zD7vD9lt03PqVbUD7WMCSZ0+s0m3y2czlFgk3BMimD+pEUsazsFKOafWNIVYTT23qqIhQXvxkSK75uBLjoTWQNM1mC9pndEt0xkeTTps1p74YJjmWMfRfOlbYWB03M55/aZHcWk/4F0VcT+Ty/OQmZpMk3A6FFLM9+NMQY69taH61/ur6bnmM7e/9xtw7cPtTOjI5EMjHVXwZYr1xgoa6vayM8mv9evCO2AjbNsUO2jusfigR8OgLf2S0ZiX9MhLYSrDM2FHceNRDR3HcN48M/MtrFMzpRNCLIdVpERAOybykcK0GW+obzPUSAbixAAnHVoLi5YWlJDsIaHqegFMcIP+FtVBVSJfuh9WnP7EQ5culuO0SDApiHP3ls7cHIa6lpgR80HVwlLFEdNuPzBidhi+XNHIQIRGVWJLKrAHB14F8F3TCaOWekBer1Af/nC21Zzr0jCs+/KRfocm0oxy6HiYizWnappkB+QZd426eMvXv8T2nWZN4LOOsEPiiXpY0H2oGUTElcq/+E6Iu2bth0XPIF2gZwwyU86GIk53GS5p6Y+VTwzb8DaGp1yies8HTSMa8u8naVjW9ilKwmDAcTURzGFE29MbBuKGOoDnr+p3yUy9SbFSM2skyDV+MDZ8mYC+l0/BU9DOHbEHO4ZPUTJJnZQoUUZdy2LMuXLZ1m8QajNU7gFq7OILUWs7gIEb52dITEZME0DBaWrclKWV4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MYbJKjJS45JB2oIE/VwIE9uumIfHE7U6MJeKWB452ViD6TL0h7taS+U5cAnR?=
 =?us-ascii?Q?74ZF8x9ElbcyUC/ywZy/L8S4X90Ztl25lcIncdB860/ET6cqf9ZUM2r7KON2?=
 =?us-ascii?Q?VHcWbnqrA9lfjxahci0gbupuwAKW6Dqi7ysDn/xC8ZTXcML47JH1aJSj4K3u?=
 =?us-ascii?Q?j62aH4XQSqPEsVRsiJQSmAgC1zATOYh5fq9SLnwjJFNn4WRYq4t1ANUL0ges?=
 =?us-ascii?Q?/cMwNNLR+0T5RRjFs25T8RIpIsur5GCJ9zEaDiLjcQ9j7aw9EwwQjxWMdBaL?=
 =?us-ascii?Q?73ZWOkgOqPbniKsvfxR3VhOMcM9seH3jP+jnxIdCHl9K4MMQoY+9olSh8aEW?=
 =?us-ascii?Q?KkH7WQxKlEtHucfFunG7mBu5mcucCUFrB9G92Wxk3c6sTyygLVC/tC1+qa/9?=
 =?us-ascii?Q?mFMlB4k6rJ2HS34AxWBIeo+gMlNcjgO74TqyH8JkHZlKSaj5/zs+pj6GZDS1?=
 =?us-ascii?Q?F6TTeEqcN6u6IoPoj+T9AcOilr0TS4yVjq9vaRn5JOqZuwey43C1ZdwNp0jm?=
 =?us-ascii?Q?51oUfL76rEls9AyHhg9aW2kV4UI/iyvrEXugQVC7Ob5k9WyWaELhauX3U9c8?=
 =?us-ascii?Q?WBKrh1XgHlr2RGtWYQI4xDe3vDTxVWcn404zU4DaK2H7b93FMGKz4WkZUV2l?=
 =?us-ascii?Q?MwIgIT5UZasxwta3VNfBfknzHv4EJ704CHH3imzYGE4D/ei6NhhcuVhCFbk3?=
 =?us-ascii?Q?GsHt1abxV63Vq+XcQR25WIEWJyx48UpJqyw3WQdf2Eb5AXH9q5w7Q0+1TMIj?=
 =?us-ascii?Q?ONb07ttjMjb7uHnwp4sY7UkPpT2TipiHRcvscdd4Q290u6M321sm4xrov+di?=
 =?us-ascii?Q?0MBohWgmvsBFHssBFyU08HxeZB7qxQAHg/e5wF8zXmehPRD2UaMhtLm/u1jr?=
 =?us-ascii?Q?ssO4OTrQnn+k3UV7bwBtPn8j4BrTHbkLnDcGqVTRyugeaeW4kUZmrSqKTM9S?=
 =?us-ascii?Q?rydttTOrxMiBpErQ5D9E7Hrn6kT8YZylma5ct2h96urOUjj0Uz5cB8/AL6Y0?=
 =?us-ascii?Q?DRstlWR6bpk2k38MKmUSBv25CnjTMLFxiamsjg5zdCZAk3CfuHgoN0vLILne?=
 =?us-ascii?Q?RPjuIZS+81ZtCjqGlVyKID/nCa08laCfpyUcgzhZByde3Rxoc1Sm8qF9DMu8?=
 =?us-ascii?Q?izBYsalJF/jbuoVWNJF0pc0ar/x3To4HRozhxqPtd0ZjLlsgW3FzSYyjkd5j?=
 =?us-ascii?Q?HxreK/yOvf+M4vKcFURdSCrs2ZDad2qdaKReOTPaVMqcvtnWkqYVxDGAPkO0?=
 =?us-ascii?Q?+uJuXt2UsXFdRDd2rl1rLzigw0tz0BvhBtaakotJGHm9dnmOlwYCTWqqHLVX?=
 =?us-ascii?Q?cHpwWzaYX0Zow9ZiCwTtrKRfu4EDhFs5UZbknmV5OEQ43gk1vr8Ps4uWfZQJ?=
 =?us-ascii?Q?K4VMfBTzUwBvfZeyW61QhzKpDOckkAyUaeh6jpu9amY0r5weVhpKUWhVtS1R?=
 =?us-ascii?Q?U3Uc/qMqeZTRjPFFkyH036lnWASCh7avzkQMlsiNgWa5etG5XponoD5I3tFY?=
 =?us-ascii?Q?GtDiaW97sMgzpfWlcS82cYWnxmd9Oj2N2sG5OL7g9LH0Y8EqBxPP7dHoE768?=
 =?us-ascii?Q?TpzfggqNZClUIuWorRdEZrmfAUYj+wJQ5WYrDJSUpGbqeSe0LutjMLSTLhxE?=
 =?us-ascii?Q?DDkHAIYNRGL/3vEj0kjpZz+GQNxbk29kKPP3QYNaqDOCrUz2yalB7ZDxgrFs?=
 =?us-ascii?Q?YkFHwebqgjY/MbCvLmWUJMFRg0D86oB3zpydDJHUg4DqOt9CvV0RnJAhaJDt?=
 =?us-ascii?Q?QnNrTqri2g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc9a419-f8d8-4127-d518-08de8c0ea37f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 14:39:23.5251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EAtR0pbRFBibzxY79TkUrtb8BPR3XzXTa9SR6oKSZ6YL3pa1H2AlevabeltcLik6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6025

On 27 Mar 2026, at 9:33, David Hildenbrand (Arm) wrote:

> On 3/27/26 02:42, Zi Yan wrote:
>> No one will be able to use it, so the related code can be removed in the
>> coming commits.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/Kconfig | 11 -----------
>>  1 file changed, 11 deletions(-)
>>
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index bd283958d675..408fc7b82233 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -937,17 +937,6 @@ config THP_SWAP
>>
>>  	  For selection by architectures with reasonable THP sizes.
>>
>> -config READ_ONLY_THP_FOR_FS
>> -	bool "Read-only THP for filesystems (EXPERIMENTAL)"
>> -	depends on TRANSPARENT_HUGEPAGE
>> -
>> -	help
>> -	  Allow khugepaged to put read-only file-backed pages in THP.
>> -
>> -	  This is marked experimental because it is a new feature. Write
>> -	  support of file THPs will be developed in the next few release
>> -	  cycles.
>> -
>>  config NO_PAGE_MAPCOUNT
>>  	bool "No per-page mapcount (EXPERIMENTAL)"
>>  	help
>
> Isn't that usually what we do at the very end when we converted all the
> code?

The rationale is that after removing Kconfig, the related code is always
disabled and the following patches can remove it piece by piece. The approach
you are hinting at might be to 1) remove all users of READ_ONLY_THP_FOR_FS,
making collapse_file() reject FSes without large folio support, 2) remove
other READ_ONLY_THP_FOR_FS related code. It might still cause confusion
since READ_ONLY_THP_FOR_FS is still present while its functionality is gone.

But as you pointed out in the cover letter that MADV_COLLAPSE needs to
work throughout the patchset, I will move this patch in a later stage
when MADV_COLLAPSE works on FSes with large folio support.

WDYT?

Best Regards,
Yan, Zi
