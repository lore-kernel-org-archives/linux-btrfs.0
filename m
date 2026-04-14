Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010065.outbound.protection.outlook.com [52.101.56.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28D81D5CC6;
	Tue, 14 Apr 2026 16:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776185132; cv=fail; b=D0yYuK2GtTmWyxx5aDNHPaaGTCXH46a1tE2nvuEoCQTc2BUYhuGc8J9YzhqTsQMGwRQW0xogwfMqnKdTVPVSC0Ht9dbpqN6u5wijxg66qVylPdkLaK7f95jCFb0XjGdw2qRhFg1Eiu9DxIEmSAKqTGS9isFLbLvfMSyRn1XTdrY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776185132; c=relaxed/simple;
	bh=QMU1nm1TfjlCYqV6gONJupbGisHcCFehTCPA0ktBtQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cKEWMwee0pseCLA67SsL+3+NjfsPy67AwHNOaOfe2g1tqmV1sOCzg4uWA+Ht8SoiT4q1SrXpNPVQsjyveUFf1qn5Bt4+IwWzgWuCMB3upPCiVM9fWjVYO0zDh/19GpHC9UM4xXgbcV1OKKfs7weHrZbudiiwLcLXxMy0iNi9vB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=txS4PMAa; arc=fail smtp.client-ip=52.101.56.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="txS4PMAa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SQtrBPcdTGpeyHgBWGDq+xMcnYw6HX5op5UJ9TkKGyEFu6nHH9+oNINl46ZgKNr2S8KsGLFqlyQRegUcwiY4wR8LhFC4Zovxp+qcE10OhUPW0M+9LHjzuMg0b5OEDFIQR7oq7mNJ+7RVhRchkLw8PVaTOveVmQyBPZlnc11/Up7QPiLvFLX+Snoe4tyeZNNrsU4/RC13SiNXOtOsHrgtH1jcUDM2D8qXXmibaQWD3VwKk9yizEEKsLvNf1Ov59i096u6HW++D1U8VGpWsi6M86GOs0Fyp/3PYCvDeXxq2g8ql3RDNtcEUM3Q529zS9xDxQEv0aieyP9EOkD+2H7vnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Jvrl/6Gj/xrsxEx4GH6Uuj5rcNnnIbLXzjXdRXW3J4=;
 b=Gkuw2yDSzCBdH4tYDdZjFNZq0OovdXO/f0HTdKlY2Eiy/maBH1zt4CmG3fb+So1ZkxZ1lPMM5bHwBHM2ASBa2YOI4FVluWg4nnDJT7l8KDrx7V1I8nxMhRqkE6/mkFMLlxU3jv/OY8CtE1gd1ToimBbgno4BB3SinFNIfBaKOZUqv+hbUm6k4p1eC0eHez8dHDid6PU2zN+ymUZ3R+AKZslOnji3vOIkgH5N7KsvjQ/cNdFya/jfBAeizv24wSKktVLIiq/d8vNrnp9pl6ZwSUqwzSMpuK/E2Lkj/JsYiPky7ZiwFEIrMYC/BHAoWCy+rNrcK0sx1GpZnGgSaVUkag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Jvrl/6Gj/xrsxEx4GH6Uuj5rcNnnIbLXzjXdRXW3J4=;
 b=txS4PMAa6lSfMWUC+77UEPR3O+z3TM9R2rxK/X1cXvc9XiVwaq7XSZivWgDtpWSyFN6sMIylajj8f+PNQRlSEc3M1RjaDWdImpi71p7c3clRuzQGA0LY/Ww/BQFBnIyDjis0HW5X8JqiGFtQAwe9GdMPHPL2IcRbBCLNJ8XSLkZflTcvvqmnNck1nkTqg5pVjFUbeqCBuSML5AeiFQUA7gHrUPj6fH6Gh2EWTXzlQeei54edqeG/ZEiamQ0ebhDkDuxGs82nwAf8JEyqjhZsVcfDefDn5gbxsvum62o09RgaNZpW1G+OpXQjHBcswAYwGWhVlRHM16w7d4VCPL/lwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB9169.namprd12.prod.outlook.com (2603:10b6:610:1a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.15; Tue, 14 Apr
 2026 16:45:21 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 16:45:21 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
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
Subject: Re: [PATCH 7.2 v2 12/12] selftests/mm: remove READ_ONLY_THP_FOR_FS
 from comments in guard-regions
Date: Tue, 14 Apr 2026 12:45:18 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <1EBEBA57-E519-4004-899A-CBF21A77ED53@nvidia.com>
In-Reply-To: <c696705c-4c0a-4e3c-996c-358d2f0b7074@kernel.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-13-ziy@nvidia.com>
 <ad1WTCR5Kld-tiL8@casper.infradead.org>
 <E3268570-18E4-40AF-92E5-931A8ED1C9B5@nvidia.com>
 <ad1uK11f_J8sFN0e@casper.infradead.org>
 <c696705c-4c0a-4e3c-996c-358d2f0b7074@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0051.namprd20.prod.outlook.com
 (2603:10b6:208:235::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB9169:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d2a3948-40db-4aee-a732-08de9a4537c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	fi0P7M5fV/oHPMBFYpGmjZljo1FPVg2vJRY2e9NxtxUP3VNptBZkib0B6dWwA4Xh2Npk9CYaCy94rS/b2opQF6VlRlg9ZJ91JnIady4PUnHR00tBFZa6qKq7Koqj7bzt9t4H21zhf0uR9fZVkTEQQwP3D1OPNwCcWX6Vg9oA3WuZDgtXDOVi7k/0j7QJhNqkLV0b936VFszFycrRQSmPq5ESfW0wVEQZq6DNaO/yS43rjkd+wPQPA4GOK7tjP3Ohv3TdtVj6kA+bSd80nP4kZzELTxFZoKLbR3rbp8Z6M9EJ0T7I+6HrpwrpM7+8+km1tCU+JVuBGLFclLviJdgZAqCugDv2lPkgsuAxz4k/zjaltscKFIHFgTAMZS3L+CpuTmB/I1EgOuVmVtUartwakEPjbLtVhY1WgRM7VQ8sbMKear5PtLkfiFXxrf0S2MA83fVhT0KGBFpjKGYquhu3zWonmJx5Rnmx3EsoHPC6Z9T6zvffASu2df/ayH3a+YECS7o4rOwJEroGU9jEDqQ0iXKwyOsnbeTBj6Xx3fXIRVylO8iPRPcXa/qHSZ+TbiX5xZnOM1295AUgT8hjhS6pF1s+0MsxTUhJshK3A/cQB/PZ+z5RJiVr6vXuIXGpMIHzqnIglmRDwauS3utimFmLIVhaheVxfGC+iTrsnRr7PsFtOWyzYc8EZ6+eTrl+FiWcaNz5KTtUsgbO8fx6t+IZSzvh6vGQsDfVVeQd6UXdYCg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GwrIOc3J/sqZGExdeBe4LNcbBqmcaANc/F2sVcl1164NHqEDx+meI5WP09Vl?=
 =?us-ascii?Q?BDbQYdtxrT+pO/ZGSxDoktlIPrKOc2KL9lJ/Xl9iaIaD+UjaNkcTsKjLq9w6?=
 =?us-ascii?Q?kduvZRCj8Sgd2wLWEtVsSzW/gz4Y7V1xfvkefP3S0iXTznhdbCbuXg9R2T5Z?=
 =?us-ascii?Q?HBPtYgXmMvJDrJy7mMubBdmxifYKqgsQAxOUJ9JZvqyyqoC7jhjZhUqry89a?=
 =?us-ascii?Q?51hqybAYKQG4O18Ouuz1J8ANFzPeDXuxfuaomQ0iQaE1EZm9sg2ckRScqUP6?=
 =?us-ascii?Q?RwUKJ8kP17Dg3lJ3JiZsiImIS90Bs/ketwvpYRrRMw3SldQ1t/9EwzJL7mhe?=
 =?us-ascii?Q?fA6nI3/aXU/czmU1p5c2rJkY+F7q871qhGcem3H/JdtESGtZnHmI25o4FMIW?=
 =?us-ascii?Q?K9YkZkk/OIXgBs1Fla7+PSsXdrriDM44yRdQ7dEFMgedMQ609etwmIK9Ju2j?=
 =?us-ascii?Q?jpPQCNmtht6YFkQE0aX3DKUMxl/sTMUFqaLhrV77XUeLsVAqBB19C6LSYPtT?=
 =?us-ascii?Q?YTcKET/nOMXFwDNz/K8YFeCRnDNDaN/Ld/6EH1GEPhKTGlGSTPHXGMqvHejn?=
 =?us-ascii?Q?ukgm8IDkRDQrHTK0CCuNGR4COgc2tkBNJCKNUJv3dJn4vShQOt41AbM4Sdg2?=
 =?us-ascii?Q?/bUA3jIFYrM+tyvPI1ENTOiIEkpj8/whDUlAWQgQ4lu8ETu2OT06bqbXqO6d?=
 =?us-ascii?Q?HdH4vCOLqdNE2DCYOXWooyAlRtEjSXMtG4axhO+idEfZGwYdX6iNF1i7ShIr?=
 =?us-ascii?Q?uDB+EAHWJ+h2q3OQt+pawbbpIhwrwciFYJG4iwkcCWc4yBuxkare4m6uS80j?=
 =?us-ascii?Q?kyO5PHIhaGgNusui8Y11kIEvaRApdZtxH/BjSsGnVMREMvoLHk13aItfgp+6?=
 =?us-ascii?Q?I4j73FB9lKpGOJZ3Ea+JNcm9eChAYDk8FjQMD2tM0IhIce/ngdwFG9lEAyJQ?=
 =?us-ascii?Q?CMf3t9gbD1RWs09qjMuSEyJoLlYqfILVBiK+XiSnMp8VW4vDNXLftcvqxxRo?=
 =?us-ascii?Q?3bGSMwx1l7HPcemmP0NM59nbjr2Vl/EG1cFA1SIAFacemkCZWdoqcwQ3YrI2?=
 =?us-ascii?Q?C10XDYgHkj2eDgR5hPL82yBYJ8X26eaxBgCl0ymW/GoQ7AO9piRQN6uQDU0Q?=
 =?us-ascii?Q?U3krg7VVO+vDawyIO53iH5+adwu7ggenUn8yyzgmkQJJkGy+QHGTd/xPJzzv?=
 =?us-ascii?Q?RWXqT8NhOCpnwv1NnhFbanFTjPtFdsyu18atIgjh0dpmMvmXZy6nkUEg/wEq?=
 =?us-ascii?Q?s1sg+Li1pw9zfwtt//0aTwwHiEc+A7soOwGkWHcl6xjIcX0P6bqi4ih1hpbx?=
 =?us-ascii?Q?/oMGJGZ/1anuw/iYvVoI8Un2nW04hvZT2FLf4CZrhAyjyjFrGDNfEzuvzlKX?=
 =?us-ascii?Q?u8hyhg9FgRc+ZaKNOKOBXB5inHrjnYbglWuRa47ic/lEcRS+pmvfJf2ff4S2?=
 =?us-ascii?Q?BvjRod1Qf4LqTQrWlkwm5KTjC7k0LZh11O0HSjQf4zgusuSZ7JwBF5U112mW?=
 =?us-ascii?Q?0vRPUTtFD/kzi5TD78V33g8G6wsjXQJ+3fJI93yJq9g1PMJ65xbI8aHThyLV?=
 =?us-ascii?Q?CgqlZrLxHWcwXrTunkQTQphQql+o9g78fOeLmRkgfpJFRiFqT8DxH7EBQX3S?=
 =?us-ascii?Q?xEsriz51rsKv6MyM6ODmERs+07KgDynmBgwsSCqJD/qdRKXDZxXMo0jqwODw?=
 =?us-ascii?Q?UmOp7/cyidlnFrJiTIWKkC0W6wevbC8NMTXzVqITzUbUCw4X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d2a3948-40db-4aee-a732-08de9a4537c1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 16:45:21.3196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okEzDO3JM4KoLacEjs+QV6Srfj4cYzUr48CGkKKaUPQw78yI5+L9Ou4SAx475Gwi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9169

On 14 Apr 2026, at 7:09, David Hildenbrand (Arm) wrote:

> On 4/14/26 00:28, Matthew Wilcox wrote:
>> On Mon, Apr 13, 2026 at 04:51:28PM -0400, Zi Yan wrote:
>>> On 13 Apr 2026, at 16:47, Matthew Wilcox wrote:
>>>
>>>>
>>>> Is this true?  Does MADV_COLLAPSE refuse to work on writable files?
>>>> Should we delete some code here as well as fix the comment?  ;-)
>>>
>>> file_thp_enabled() used by __thp_vma_allowable_orders() refuses
>>> writable files with inode_is_open_for_write(). That should prevent
>>> MADV_COLLAPSE from working on writable files.
>>
>> That sounds like more code that was added for RO_THP and should be
>> deleted?  See commit e6be37b2e7bd
>
> Sounds like something to implement on top of this patch set?
>
> But with the added dirty checks in patch #2, maybe it's trivial to do it
> in this patchset already.

Can you two elaborate? The code from commit e6be37b2e7bd is moved around
and replaced by functions like __thp_vma_allowable_orders().

Best Regards,
Yan, Zi
