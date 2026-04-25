Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010055.outbound.protection.outlook.com [52.101.61.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2AB396B68;
	Sat, 25 Apr 2026 23:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777160681; cv=fail; b=cwJwM+nUbgECUNfsN+36swBfFx5CVsSyFj9l0s4ZHTvRQqXcFBm8iMNOPnkise5BY+I3OM69Qyq4Ws+MZ+5b+ENrNInQ7QX73d8D8FP07ZlQluonoP/txkK2tILK9Nk8Mn3jD/dC7A/S+VQXLQ65gV/6j4fACqzK9zJ7zWPj/mQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777160681; c=relaxed/simple;
	bh=DjqiZWlyolBmUedRiakGZfca53ieFfRdhPxl4R+RMgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hGkAVGNo9xcuKWYxifCA5d2kAovCaQBDbiZ2SQRoO86z0hgu+TDImYPB4nDPSPP/CCbDQbJ0lybE3soGI9mtrlnQfzVviNmbM8uNyMDHb54nVVdn0KxWYUx1Ln8PAt4ehsGiDV0hj70RzlmpQj1NEJYD+X3Z1al4DCsjRRohGlk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Gfb0wO49; arc=fail smtp.client-ip=52.101.61.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Gfb0wO49"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lW20rYU7FONZRXEOSrREGkxnhN2eEHxu/jm+rqBoudRjsPQlq5Dky9wFPjDuLPMrDOJh2pQRGvjz8kAboxrRhMY2uYJAzAuT0D4jPqrNxEIb+gLNdjWU0OKbQUkmKjHft8SBaCrMOjeuKkDUKdlmqWApM9/0BTYQN55DDLAqOgnHLMMt8YXSYUxvHtTc2Fnz73djRJoFbwJ7YwWdUvw87CrktlfXxUjfG7uP698ssH5YUUjTvdPYvjL7UT8xiUSqXuptKWRb5m7b9k9kFzXHlNw1lvqWvyH/S5CapYlBv/0FF2U8Om9Tkkzt4MRAG4+8i+Bf4v9SIorpqujh5+i5FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M/r2N5l5yK7dhwnzM1nSh2VY5//1TR9ZJXHM/Ut7AXY=;
 b=MItQWNnlC1fEw1U7sEWh3QdYosVsYXQ8I/JvJMkK9LLZpSDMfORmJzmYzdqZgogYGrudBuuTPhEUJLAe1Twk3POYSHpbObbq/VEmj/mbwEX28bdPT4xaod6I3l/OD9407eW4nWYCYOQDM7iqMnFZUVQgWaEST1Galpg+glQOOWWCGTFl4d0qmWLEO+aypywNZzH1DWpLtbV2mUUMOpiPKbY/SdyqReOhaV5ZT4LPiP1rAmLWcQWm0cxOhCUm06dPgU7ww8+zYUU7Qdp7i1Dr4kMPy+THzjeHVeYHlJpJ2H87pWtdLQ/8OncJ9kXCcPLFxDlysoOjYKFKikdlE1xdoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/r2N5l5yK7dhwnzM1nSh2VY5//1TR9ZJXHM/Ut7AXY=;
 b=Gfb0wO49lIvdYCa/5b4WBKRjhNercwHXmibvJH3Vvq6T952c1TIkTBh1fJcVduCjBlYivC3ZZgJsiPErwoGIX3OfMrHcTeNPZGNxWPCVHqoz6lqnX3CVi5PAej4CodypN7P2E8nxbyqPdw6ie+/ExRjeEA+hJM5jVEsMjUlGwCJDOtTwiyEc1NhDE1YEETzcTsmR338gxO+XUmKHE+cTtxXlp+bWGEcYPnl9AuMkob3XGHcuvO4kCuf4zRb8PbReJDx5jH50X2WMdyj/eJ1rMuj9jKLqTb+cHFjDqgtbfVjuBJTXDTEeEqSbP6T+w1ThcnypG57GXBJnlQReE7G7Ng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB5814.namprd12.prod.outlook.com (2603:10b6:8:76::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.13; Sat, 25 Apr 2026 23:44:33 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.012; Sat, 25 Apr 2026
 23:44:33 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
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
Subject: Re: [PATCH 7.2 v4 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
Date: Sat, 25 Apr 2026 19:44:30 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <AAC60F49-769A-423D-8EEF-B1DD9860F083@nvidia.com>
In-Reply-To: <20260425150613.95532603a9a9404c7638f65c@linux-foundation.org>
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-2-ziy@nvidia.com>
 <20260425150131.c4b3703b65e6de0fd3893d48@linux-foundation.org>
 <20260425150613.95532603a9a9404c7638f65c@linux-foundation.org>
Content-Type: text/plain
X-ClientProxiedBy: IA4P221CA0002.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB5814:EE_
X-MS-Office365-Filtering-Correlation-Id: 25f77125-3566-440a-bd4e-08dea32499ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yaW0D/g72WjmoBoB0+nFS1hQQ2EN1piM6Jwuh7Dszgg88yZUPus/JQyEiV0fC1SmLNAY2RXI4nXovfi6ZbnNmkJ8g1mVyr322wiAgomLRVKbKOKuMCdgcNDsNnre+FO/eun/K50VY/Ajfvs534zxLv6NaRk3JwndZlAgi7QWsZgqvkAxGlcLGKa3HQzZTCqXshJ+8YJZP8tF4NDlofDI1V2zJbWs7BeRcs17CfLCHi4aS2tw4MwCIxN0IOjJp/92go6mlVJALamkYUR/PC9iD0JJWOz4EFFSInRcerNzRRSYO98SQQDtPaRGTVLTEQfCc3W8XlID8THaavcTv6YDXKbCERonErRi88oQeUQ4Rz/WEvk9LhUahT539b3v9bGenrtw0SqJXbcXd7DYQSD4O2BFcL81nbzTWYtMKTM1xhoz3Ef0DQIXogqv0skrxtzlezQ41l/wr+9yRPBwJhdFxiQjFx/d+FXprhl/os06WN/v9RM6bemuXQosi+95vVar5ev93ovvBHYts+Ue8xkAR1vM2L+IKNFg359o+uGjcRIfbjGWY9uzOJRE1JNhfSvoTS9633FvHjMdQuzvMPrbnWLfsZLylikSJ727/l3hUYirpRRVcMYMpz064RlvLGi7PXhBa0cNgxiVNgfEipldFWOK+pSdKAOZv1EZgXe1XFXD8JlCYP3gz6tzjw0Kkiwuzvn8kFKTmzCVA+IR3vNqnLIhqbkfQNmFSASrL8/9lno=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DvCOtPfN0RWRp63ojWaNfnSHeprqbTX03Ldl3KAEv9txVz+z5OgRXUllZwY5?=
 =?us-ascii?Q?iTyY+mwpKLt3ohiPdowJWrDPtuv2bnS0IasrjVHdjNjY5wNyaOMCoUiRt9MS?=
 =?us-ascii?Q?W7+mwXg78lSo6/iDcpdohss1EDxLNFBA9faS2Tv/CDX0L/+COQrzaxzxF5pb?=
 =?us-ascii?Q?DmAzFkQuoLDPcCeCa767+vsG4ymAZef2WNYBcJPn7XUjZm548gC0w256TMtL?=
 =?us-ascii?Q?6Sz3pac1IkxWDvuzfWaad6RPHoM7JFc/pJRcKUGOb2x2wDqTvS1UrKGa/Zw3?=
 =?us-ascii?Q?jGKZJLaayHXwITMgp7zRzM0fjsxsLekJp+/LHgpM/6uAvHFc0LrwucyOokwr?=
 =?us-ascii?Q?ej4vAF+XJb7MS8O3GYyuN+SYNlIXhV+tKW/PFEuFGLH4ZF1QOJWGgcyGm3ed?=
 =?us-ascii?Q?qaFkWhQOWr4sjOlTZlmPPxrjLcCW0OZRqi8QkLx5VgTZoOD73sFJAJNjOb4Y?=
 =?us-ascii?Q?rNDRWGbljBVtOgu95IR8GtJF6mw/weWs3tNnLDOQXX4s7ML9AG9xLIl/rwnq?=
 =?us-ascii?Q?ZfUbSotL3uDHsfAIKyr71f4oCy/fgCwmTeA5+TbzPTF0sEKEZ9gAsC3/qLFj?=
 =?us-ascii?Q?2ukuGnoKFlnvFcxOVrbevSRTXTErXfCCfdkuQROsfuqXWEUAfJQcfJ4j0g7A?=
 =?us-ascii?Q?ZQ1l1IePvGee/9y1b9Gaxbx5tmLvjVwLuhvhx1nTQmL9K+BEz8Z3b+yRjoS3?=
 =?us-ascii?Q?TjyCbGn95KzgfJ8/sOF5Sis5vMEVaw/2jnD6RP0wT1RSJyTWbOWYPyd53BnV?=
 =?us-ascii?Q?OyYybhwKiVZiJMmV0kd0Mtn0KWsWKC7oAYk4JsGCtELSiPYciB9mjKKBrQzf?=
 =?us-ascii?Q?Yk0X2lyYsTGt/U51nPtwi5vx8hMgQtY8GCV0pGB0h8kc0bSfAfg+FxpX8PTo?=
 =?us-ascii?Q?TjSWzGkuJ2bOK0FguZQRvvcBBdVGa/HkD/O7JkPbXVe2CZiLcA/xq7ChiUZ/?=
 =?us-ascii?Q?fa5OsesWRITpjMOb7XrU29zpByxqGOn5z19g+bU0VWBghiVz40wQ+dj9lao4?=
 =?us-ascii?Q?PYUKxW0kUt9e7H142ptgC0wIjA+U20KWAdQdg+djKQEUAZ8GsBzJHUIZiMft?=
 =?us-ascii?Q?HO5s4zsnvP1wItVmiIizXaJuzonZxGpDzf9liwbhamx3GguCAz+FUPj8xwfR?=
 =?us-ascii?Q?49hvgsGTIxANca/75YZvQ7Y441C1Lhy5YBNPXfUTD2k+A21KakO3Z7VAE4n4?=
 =?us-ascii?Q?FD/dJjtcwYoubP6MKfh5CkizR4jUmDrugb08/p+wr6JexQ1Pi+qIARzAMCkj?=
 =?us-ascii?Q?UZNxv0rT/z3r6QeGWOQEKHTKX/gEBzWy2fu7ZlatDsCRQF77cwr2p29rM/4W?=
 =?us-ascii?Q?V3PnYE4RupolWcCzkP0NyAXIMIM2tWI8FeuC+4txMvIGKd6QzvmEpApOm19K?=
 =?us-ascii?Q?woSWRy22jU0P5O+JmSyAGJnu2gD8tfGf50TF8HaPzWUy0zXqWorVRjOVy7XH?=
 =?us-ascii?Q?87GCWx66PhGqseDrUtY3ZDK9//Osc0+EW5TBd34JOp/f1UhxxbUTnxr/bHFK?=
 =?us-ascii?Q?RB+tIWZ4ifgMGldpV5wgC/tOFXwcOBvSanEjBfpxk+3PGP79GzQkKYBzgjJe?=
 =?us-ascii?Q?e/5x6q3Iv6FmTphZp1G57oNuPSgrxVfPDLWdKhH7hYe+P/ih2ZzlAZD91o2L?=
 =?us-ascii?Q?7JY2B7XAbxVq2xmHEWbRYUk825W+COJRFhJQg1etDgzk8iTXF3wT5rxvtygQ?=
 =?us-ascii?Q?LR+JAhRBAHOegynSb40guC9Ks4p1o5ZhRx/0hp0bgX9Jsa5L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25f77125-3566-440a-bd4e-08dea32499ee
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2026 23:44:33.1232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BguJOop59KLI8v6fZnigl9/dfj6rXQ/6mIb6uYxTq3nZqIaS3G08bJj/O6JWJwb2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5814

On 25 Apr 2026, at 18:06, Andrew Morton wrote:

> On Sat, 25 Apr 2026 15:01:31 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> I added the below.
>
> Nope, still doesn't work.  I guess 32-bit arm doesn't have a PMD_SHIFT.
>
> The series has a few todo notes:
>
> https://lore.kernel.org/f416ea70-fb70-434f-8807-6638c9787b57@kernel.org
> https://sashiko.dev/#/patchset/20260413192030.3275825-1-ziy%40nvidia.com
> https://lore.kernel.org/DDB6CEDD-116D-48C1-B558-D64CA2F58F55@nvidia.com
> https://lore.kernel.org/896b3956-3cdc-48b5-a0a0-a3ec35aefa07@kernel.org
>
> so I'll drop this version.

Sure. Will fix this along with other TODOs.

--
Best Regards,
Yan, Zi
