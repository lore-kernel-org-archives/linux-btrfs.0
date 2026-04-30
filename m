Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012068.outbound.protection.outlook.com [52.101.43.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CB0221721;
	Thu, 30 Apr 2026 15:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777562298; cv=fail; b=tB8IX1i8qmiseaz3XM4gfEf1btQ8zq8itSEe9npUsvEih1fEbPlfWuimRIkd6YV9hiQ85Jmrgclicn/8SFEqp+JHNjn+agOg4xPt4y4nOP9KwiIjwSy/Y8PzepX3aBM/SIYJWFyZHBeCFsmnitUPPzvY/KyGhM+dPr7shn5wZ5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777562298; c=relaxed/simple;
	bh=b3HlJPLreTlG0sSeaa+rZN6Z+/L7ShrKEMAI5c/b1DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xr6ZIy7xstMb82S0DYGi3+qnUNmBoA6YS+0vCMOHtLgg2rQw1WgiHJyRW8cYMUcoAJuDT171yH+Xkf667U+Q1XLQ47Zysfej3a9C06qthRPOaU3/woQjvfnVVw8JD7HGyIR1Eug2bpdJPMreb+5o2IHJBN4ETZJ7Vmd2+9DasJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ArT3CvjN; arc=fail smtp.client-ip=52.101.43.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ArT3CvjN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n+QGQ9QNnpNsQIy8cRurSbeEMTnSJq4AHFLm2lNyD/PUmKfLAyQgnpdPGQ6Cpd3MikmIse7WXs2OGWOc7mtL6YBFE529ToKSU5mRRTWAICbGQ2JcICd+AUsZPT/u73QFtQPSnI8gHP/e66xeQWDCDoHSrSju/VMgPWbxE2MmvXZpXyqtGExubc7QMJ2Ru5lYe6tUTowafeezv4YWhC5u8KqL1Kg4uQLy78CoPzILa+wTR7dTOWFSpdWI9Y3lLfgzTQZvhwsVwJhw5nZzcX9Cd8f5yURb6qkNkIjjnwGuHtnjid9jXR83wmjybJNkpk8VSFVDWrN3HTw0vCCg91Vgng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3HlJPLreTlG0sSeaa+rZN6Z+/L7ShrKEMAI5c/b1DA=;
 b=yTgdLkGICEjV2GXfxhl/OhAHNxjLo9/c9TFEtERyLS9Wnz8Rbm/s3GGzje7DNgLyvkdS1sXBQ+XVM1Kw/dMbxRfUDWb6s4m8nsvWtNShbfKLJMG4E4xY1vcmah8/k0460yXhbAgAJ446OCbpoWiheDEHpQDmZCsMqnNQPDux+gnMQKsKG5l3O8pIJLiHD/aQbKG6TeNnAxPdugWKSwKeuC21DAar3H8dYowwyBE5xLGl3Ay5AVM6k06R/sJPDVQV41X9j5tu1TxrA+ZYl9cCla54a2JKuPckeBhgaW2uzKzZQ1H8pKt7xMEgTF6aXlf5rLBTT0zTRz63DxQh5sLYYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3HlJPLreTlG0sSeaa+rZN6Z+/L7ShrKEMAI5c/b1DA=;
 b=ArT3CvjN8m7TvQ7tus14GYsmgnilrSJ8rUc0e81E5mcVPzATO81YqJAVF/0wlfbqczsR/Hxu0q7SaI+1SNDt0vYx+r4RBNxBlLUPImT26p0fBUDJEDCB/AUvclDHJr09On0KFteI8AKAVTARgIr3+dtUcNkOTinnJOmjWwVrBI1UPO668wZAIms0yBPdWh2dTeImu1m+TyuVp0pfR8e+5TathwZzI0Yzs0y/BmcYCDI6Qi1ef5Y0q0yz0MIAyfyZXGxRnIAgDc2dXPnoJMG5zz4AutWeNYHX5aLkVNiSG+Pb3lp1BkO+aGEcv2wbIRXVI65rW2M+Y6NL/jDrKKh3yw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV2PR12MB5968.namprd12.prod.outlook.com (2603:10b6:408:14f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.22; Thu, 30 Apr 2026 15:18:12 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Thu, 30 Apr 2026
 15:18:12 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v5 13/14] mm/khugepaged: enable clean pagecache folio
 collapse for writable files
Date: Thu, 30 Apr 2026 11:18:09 -0400
X-Mailer: MailMate (2.0r6292)
Message-ID: <CFECCB44-EEEA-4D3F-A505-3BA2C564C107@nvidia.com>
In-Reply-To: <20260429153538.727855-9-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-9-ziy@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0143.namprd02.prod.outlook.com
 (2603:10b6:5:332::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV2PR12MB5968:EE_
X-MS-Office365-Filtering-Correlation-Id: f4a52495-aab3-41c6-8de4-08dea6cbb1df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	pbtETsOVx6sxX/MJpWH7JWVPozroNPHTRqA/BbegrqjDLB7hqWG7Kq3rkrMwiDlTXwgki2zTAzA2jqmxcURMv4COlAEfqK7166z+7mSsM6FY/r7pE9NEOnqX+lgrmxdYq5T5IpQKQ7vz9wiiqumCmND7RVOJ/UZGcZP+yJ3w7B1yGyP4/mnoQzShsNLf0H9FFC8kzfShf82ZXLfoxV3RK31qdGrryfR8Kijnd8nme6ImdmoiVPCCwg6+yn2BIHGT0yXnxzxZ9CcQU61ZC4+fzejdf8ejj8zipkljA89vnVcnogjLGBtbJH2k99dc+bRT084JTLpvfeJcHL2N25uV4hWpOS1OC2txMJH/95sgmTkkh9TSS+V1lngECTMxXEp/A4LmdAPvknNVLjW6tFXgB5NdQbuaPy7RrpT1F4HmT9fXqQ7QZWcrHMJI1y2vzmXUGKaTHwT9SLbTa5P7QKGiHMKQkxmjHDIRhjRzGu0g4+61Hm3vILoMJ6X5zaOymZywpp2PvTmzQ51hCmHTLH1I4wWrtN8LThz31BZeQ/9yRvV+70GXib2L3+htSFg6c8pDCRgr/ZRkqxTu01FWjr4JB9FOSmkEGWNP9T5isbwaXNlhR6ViLJEhwAvcgd3FWYoLfSGz1DlWcIQMnw3fIFjlONJy246cCIEjDVdWDBV7Iw0F0Bps5OdBz/9fXTRvRf0fL9/NPP8HxRtM4cTtXx566uQsehCdTsp7K6H0fuCHkbA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TTK+oWkglfa2KIAvRYxnDFsQQQ8WnF2dQuaHVPQNQK6nlKw5mic05t5a6CVI?=
 =?us-ascii?Q?Ue0//BmeJgT90kHZAgRG4Mtrs5yOBH6oT/AlMAE1rz2pcjQ8EnD/uQdeMjT2?=
 =?us-ascii?Q?/Lqn0jgP1Zmnaf8nvCujuBUNl0R3M7FOE3sLahUk6Z4AMHOOsc1K2eDMOGPb?=
 =?us-ascii?Q?SOt4ZCRclWUBSDjduwCca7DJOdPe0SLFikqFljDUvqMyjGps/dmWRVk40l2Z?=
 =?us-ascii?Q?OhNJTX9U6AbOU2OjQiDtGarse5yZelfPgNfWMXOvUFaXnpWdWAJZ7psG+cUR?=
 =?us-ascii?Q?0AZno6NjiLevS9xfs5FlsQuccRU1e7uxD+eTdN9Cuys2K+ja98gLR3f6CkR6?=
 =?us-ascii?Q?YfhESNMsA6fZa1z6YzrWT0jCuge68VbJPf+Jp8tc14itPh+0c+f7vO2QQWtV?=
 =?us-ascii?Q?E5JrLmsjMdXklUEbr8MqynAh+AntGkGJboZIjSHaDAsTKtoKQM1hpuZB85YT?=
 =?us-ascii?Q?jXNrpSLeemhiB/yU2kKbtUEbJxkU5hGgtreDRC/SYx/3qvBeBbuzNvsoU7Mz?=
 =?us-ascii?Q?T0z4d/rvo6BYOSansSN4bXP7chSdPT+59/EexuhSFNiO5/qsBXBck6tikKuT?=
 =?us-ascii?Q?6Nvnl6UoRAjqUl59k9jQLg7kcarzh8P3Pb+QWlFJG37jbInsAjACrcrU1ZO6?=
 =?us-ascii?Q?3EvglqJcc7B333hgKgkCL/2Lb5j9dm12wOo5brM9XcJweWP0k8+kbVCEXkjI?=
 =?us-ascii?Q?S8JBRUwlxCU3BQQDFbwEKlsuDIeqn1F5lwZkp8HuUlJ/QwIkPs/KMNlfv6mO?=
 =?us-ascii?Q?3eq88XUZldaLYRooP+XmD1dBrJFNSDQscDGXsTjNmYagCt5hQsh5WTrILxgz?=
 =?us-ascii?Q?Tuq999SdUpNrZxPUyYwdUzziTp5vda3Klmk0LLfL5VxNq3OB6XEgJ/bKQVUu?=
 =?us-ascii?Q?NGBz1IkCT7/AWal4r+e+h/Q1wFWeqfpCWbwWaZKzrRttQrCMcN4ubt2IACfO?=
 =?us-ascii?Q?ojmwst152jrXOOUGsrYvoMfNN6Ca+P8e6PZNHSLoafbu2i4ynpW3mlq77lG7?=
 =?us-ascii?Q?U77hERx0BlXSCKfsfnbvaUoc78RC5DtLogAGgQMbuXirEQaWfEYeHw2YFs91?=
 =?us-ascii?Q?dvSq1zFDPbD4jRaqBuUWQsVg8MbH67s8xpxJMr1ownx8DyCM7FuGwqtxC4ws?=
 =?us-ascii?Q?Ed2vgV/A4l8PZE0L6yFV4eUJoA9hAdXWEK59xYz+YjDPNUO+1b5gd1HMsknB?=
 =?us-ascii?Q?CDIPgE+gU37+YMvkGnGVfb7F2CnYw5xun5pVl6Fj0yIszNKC8+FVKoEoop1+?=
 =?us-ascii?Q?rwfZs+scWI16jna52iy85JepjESOBIhvYbHwhnEdxpaRa/MKsxNLH51j0jFB?=
 =?us-ascii?Q?XgCr7hppf05Gwk7LimVU4+ZeSSt+H9GaJ/pmmDR0ITX5sgLXibVZ0qFZcQtB?=
 =?us-ascii?Q?YLnKKtn4nGIQReu0vOl0TdeExkX48mCfNJ4NYUric4afRrYiscNMYvGXCNhd?=
 =?us-ascii?Q?oBKb1HZkhggU/IExwWnz0CRVHgFpeg+F0qhu9ofp2ZA4fn6ZYnfoPoRfNPOY?=
 =?us-ascii?Q?/seM60PV/f5rDxhvLndBonafZNTsOL8duAKpf06r1bd9jbMGjXC9S0nh/uo2?=
 =?us-ascii?Q?5ej+e/7VUDMNRKR5Kzoavp1rW0i84TJEn4RDSfQ5RGdI0Efcf44ytGKFFjYI?=
 =?us-ascii?Q?hdEcuYhuN6ux2LhvpIScXAeF5R8Ol34rXBlqFcWPC2ogwx3j4HIrD/P+dGl/?=
 =?us-ascii?Q?JznVAEiAStomUhpiCTgtuwdkSjjWr4gr/p1fG4VIgFq3W2sw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4a52495-aab3-41c6-8de4-08dea6cbb1df
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 15:18:12.7229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MuIXbZRb7qbrrq+H4yF8bLuJsBalzVYvdcTriIgB4qNPhnO3aBPR/cRtUlDIJXDR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5968

On 29 Apr 2026, at 11:35, Zi Yan wrote:

> collapse_file() is capable of collapsing pagecache folios from writable
> files to PMD folios. Now enable clean pagecache folio collapse in addition
> to read-only pagecache folio collapse by removing the
> inode_is_open_for_write() from file_thp_enabled() and only performing
> filemap_flush() if the file is read-only.
>
> This means userspace needs to explicitly flush the content of pagecache
> folios before khugepaged can collapse the folios, or use
> madvise(MADV_COLLAPSE), which does the flush in the retry. The reason is
> that blindly enabling dirty pagecache folio from writable files collapse
> makes khugepaged flush these folios all the time. It is undesirable to
> cause system level pagecache flushes.
>
> To properly support dirty pagecache folio collapse, filemap_flush() needs
> to be avoided. Potentially, merging associated buffer instead of dropping
> it with filemap_release_folio() might be needed.
>
> NOTE: this breaks khugepaged selftests for writable file pagecache
> collapse, which is set to fail all the time. The next commit fix it.

Sashiko:

Is it acceptable to intentionally break the selftests in this commit? Each
commit should be self-contained and not knowingly introduce test regressions,
as this breaks bisectability.

Answer:

I am fine with squashing patch 14 into this one, but it is unlikely anyone
gets a kernel at exact this commit.


Best Regards,
Yan, Zi
