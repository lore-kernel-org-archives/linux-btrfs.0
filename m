Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010064.outbound.protection.outlook.com [52.101.201.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D252BDC23;
	Fri, 24 Apr 2026 15:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777043572; cv=fail; b=hK53YHy1L4YfKDlRq+GqZ9qr+uQ8BYlSApEqpsXzjyP4lV3IQv1c3DLuNemjcdaNSngkL1LU/jV/H0VwDin5TVSu2+BYk0re3LFayARroloNI8yJ9l+pZ619gfDFAx/DyF4N5YzycPDNwsJPw3fL9HZ7FLXzUQB9cfS121snbOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777043572; c=relaxed/simple;
	bh=nlmWwchAz2bajBf/dTP3cJpYTzcr6TYrFg7IoJXgr9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f7kICmTjPU+sWtVaTP6r+xdIkemGstAhkEES1nK+Svm9Xu8zE2pIgYGlmdY7/4gqtOcitri5bM49wW/KMG+WAdi/lyuq6AZYq+DZ22v/pXdH42r5vySMwup1xw4b/eJxCiLYgCGR3ayg1n8LcnzIcm8hbMybCVJTxJfyz/gsPT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c5rD/GX3; arc=fail smtp.client-ip=52.101.201.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c5rD/GX3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D7D/J6tArKl60K1FeqGP7bhVPLlnjHB8SHIoVwl4mIicFDdeyfceG4bKluqUZO5u5ZI2uv55hZeMsrEQ6q398TTZzNW8JePGGtQ9KQU19h4/f0/u2uBX1/JnO7em+lvaV3ZcRHpWGRZAOSMlIfHbjEKvWglpJiyHfslU8UU6vtsAzRWTP60ljPlUgPsYTygFNqBea/GiCVz8agtW+L2FqfJ/s0VyLXLc0lkFQKgxP5yjyepwenLb7QnAPJU26ddsY8GxvYMKAMTydTDp3gRjSAfZFKLrySCMLZHGo02/U77LoemY9e+7C8/wXCIGulJZ81rYh0gGgCPs6SWcwqjMCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nlmWwchAz2bajBf/dTP3cJpYTzcr6TYrFg7IoJXgr9I=;
 b=RiMlI9JX3kLalqWd8ER/6WDB4Cdzj/gYzdL2JdW3cT7+TJB8W8IJ+jU3hEHHOEJANCI/bN/eKC5QJltsMlpQCm8U0B47g+VcrQ6PNYXYiBLWUzQSNaxA93wER2QbUzJaWbroksgCTn2w8jAv/hVT7tUpoiKezadWC6JAgQ9eG6O3/75v+KMd6ybkt2snCrwh5aPmxJZIvRoT8M/EyY/Af8Debo8/GUj3XENUjLrDx1uFG8il4ifxjsPYAuWk98hike9wLI7GYSLS7VGZY7+n3msVayOOFmTYVJvkL2c/I99nmVlqiS3lnQT0seVKtsYItNwFybRoRHm6OFaItK6g9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nlmWwchAz2bajBf/dTP3cJpYTzcr6TYrFg7IoJXgr9I=;
 b=c5rD/GX3bPV8Bc/26nCAL9/+92ZgiW0HCzjYnLw4v/NCDztBxqyA34bd+xjFuMszeNWLC5xmwtF97QPkkInJhLasYhuKlpWNBfOnQ/HB3+dhNEE0qrs/n67zNPlmyCnwKOF9UK3O5LwTs2nBTxC1M1Q2ihU+/jkapZAK7O7BVl8sI+ue9wUiuuqdN9H8aCi7MRdekjaTvCn18om7GR3ql6lnyAZoGUkhZE6VqhkTa9/rghR5dvyYOUJ8ijXt0/AWlwGBD4uD3NJ1eTqdEGyUVVNkN/L99BGmeUbI2ycRVnkL8y9ebyJlvd4lgNXX/2iMA7nBKU4pUyypdQ/mwWBOaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB6927.namprd12.prod.outlook.com (2603:10b6:a03:483::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.22; Fri, 24 Apr
 2026 15:12:44 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 15:12:44 +0000
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
 Shuah Khan <shuah@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH 7.2 v4 09/12] mm/truncate: use folio_split() in
 truncate_inode_partial_folio()
Date: Fri, 24 Apr 2026 11:12:39 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <DD21736C-7EFC-4746-B926-54551B757785@nvidia.com>
In-Reply-To: <B2F4546B-F57D-4EF8-90E7-37879711877A@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-10-ziy@nvidia.com>
 <896b3956-3cdc-48b5-a0a0-a3ec35aefa07@kernel.org>
 <B2F4546B-F57D-4EF8-90E7-37879711877A@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR04CA0135.namprd04.prod.outlook.com
 (2603:10b6:408:ed::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB6927:EE_
X-MS-Office365-Filtering-Correlation-Id: 62ebeca5-c47e-4d81-74e6-08dea213ef83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	IfWN/hTzpzVT+n383ozCgyc6lNRqsq7jZNnmJbUhBknhWIgNNrJH97sjwaTG9KQNgHrdyEErOfPnl2HI5dUhecEgkPah29+nP1qJ4oxsfc0rzPfyjk3sI2ZUz36HHhp6mlv05jun4mfWGOIkwTEuXTrzw0+fYUdadOjGHbSw9tsH+Dc3Ik2G6AjMn8dvu6nFqNz2qJK7da7ZKnUqV5l8RB9GjDVy2UXtlGSxdd4eXYwGneFuStH3lRJ7ti/8Agg1XTRBdDHKTddh4yq3viVzQ+W+cpAcoIfBAQipvVOu00qN5IRHCTNhaQikDG/T9HKlBr8r4nsJ4U22hw3YbG8uCDVqsZsoA5Qt0XKKCUySMSEqzudLhYjozDc3Zbk0HnENtsyrIVcvGXyG3VByGzIauJkPPBEFR4lFBCAkhwpi31zIXETj2Izu+YFtApdJo7Jk/c0ItQMiX6r6I+NbPcb3xfc2huw4X90mAPOH0jSDzyyAguUcg/kB8jPfdXs1rLSzPUlBm2r3JezR1v3WKME5aDU+FXJ7Ni1pgsv2ij1Q7R0ZCKcVFJt9R7kpZsb6W/r97iNd7pHmMAYvkLWNJOrUK5r0Xev4lwchifFIQHI00ae6JlyzcjIku4+P1uXAZTN7gHDD0jSrHNeVzkR7ygtnDcv0Pqs9YBjfOqNySAkUebLh7YGuxvd36DSy4cY/lSCN0fbgeSZpKPFlE/nST1A+yo6YCpa5FVZa+7VRySnXzew=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8Kfu7NgtbQ9Pb55i56wMzAI2wxnS58sifLArdqb6qoOkvMN72f1kHbAO0O0K?=
 =?us-ascii?Q?mhCAk+zcErWAVkjwvbZRYjQTMqPEV8kKdtG6PUzIeFqBLzqNppjyCOWt3yXQ?=
 =?us-ascii?Q?aj/9NJOPFv7Xr7e4NHosTk4cUIHlpvHRWA6sdgkoAz6GdL8a1+ZRgV4oQfkg?=
 =?us-ascii?Q?CSfXuqwlBaqzDVYh9iuF+I4LoaeMFs/huCcSUCKk+/HbNgrEHb9qdOa2TfOt?=
 =?us-ascii?Q?gGj/TOyONjzxj6ISvG7ZLgiBsIi7vz+F1nMgxsoMte4mgmscugBQmmAXlVbt?=
 =?us-ascii?Q?1AnvlFrMWdVJoC0iccpGVFUEF0++WoqMVxwpDw2+NJlc7jF9epALktver95W?=
 =?us-ascii?Q?IFhgw6YrD2XlF92C6YX3q42JMKazJkdlFQ+bhTUFML1eAlrWMkxGLp9zXwZG?=
 =?us-ascii?Q?eEjUFzgHBTSgB7NeFjnr7wYidWN9SS71wdGkeqPFcbD5eJW318IR/MxDPHHp?=
 =?us-ascii?Q?OtuxbaUOnElCOuuGtDV/w4349b3ylrrATBEwDR0vTBNOpPRXzXsIbPRb6muT?=
 =?us-ascii?Q?ZWaLBTsifQ7ouDPY3AMol5LWIIL/oI9bwSnxWj+k2ayJcGda9Yiq5bAMyDfc?=
 =?us-ascii?Q?Tu/F3sGhmTfMvS82r5PEhySqCAWOuqH+djl/g4BVG4h6J8UK8/GlJ2lZrrm1?=
 =?us-ascii?Q?ensyq5o7RNlG3i4zzHU6le2vmvrg4U/EdBEiciR1RKCuTdQ0p8JqZrEx1Eeu?=
 =?us-ascii?Q?uG9QbL5+y66Zi6VVLIcT0YxHXtuWcYJYeojQbCU9WBf+7StZzIOEwSM83ZY8?=
 =?us-ascii?Q?RqBFREaqL1qxEQWOS+6TX7XxjF5q9SNBSCdg5ksaRZ3yNZp1jBlIKZTol5jV?=
 =?us-ascii?Q?nT2v4K+nWKZ8lqdy8gz89PQEML9ajCjNfn+MaFXYL929Vu7PzSjMBe/SHqhU?=
 =?us-ascii?Q?j2E/kIjGdJTMq91GL9NFcP8nvOPctEkAVHUD7tqBqxIuMpV/SvMohfwvKMNU?=
 =?us-ascii?Q?rzAnSL4YRKwWefAsnjv28xNrhFtm9zxlk+oy/Zpr/P9CKJkPZ2na/NfqGOqv?=
 =?us-ascii?Q?Zd0D740CNUlB6pMLbCc4ywF+b/5ohIDKhcGqRj6hHDno2GqEeiAG3A9GPxyI?=
 =?us-ascii?Q?kZmNc5ATBHY0zS24zLkMHdIUZkIbiGjS1HLfyawfCLgEaJzZwq4cDf8KlF7q?=
 =?us-ascii?Q?WlzksW+XYAupkm+qaCOBe2Q2fZQtfhLbNPg4hDtNBV8kQnMTAUldsZKWF8jA?=
 =?us-ascii?Q?nnXCy5mU/D8nWEYC+zRfLKizXANIGfG1DpSH3InGzncAxezWs/+of/li5Kmz?=
 =?us-ascii?Q?mNwqrEYW/rFzhQ8LLLVT4h6FAqTEwhq96NhKBYwq9Mc5RNlt/9szIuRkZJdp?=
 =?us-ascii?Q?USYsrVDX5WhWo3ves+zkj3Fgi6mSYRxKyzOeTjY5YfnM3nWkbh2wB7V2uLB0?=
 =?us-ascii?Q?FmCOfVNRrLfMKulI71tw6tuwV7yHUmzhTTCNYXPQaCfiDpFUQLPmqE1EJQXU?=
 =?us-ascii?Q?uM23Z87nfz2Ed/LM6NMZ5Ko0jNssIjTcjRdgVfNTDQQYCFX6RUSjrl+IXhia?=
 =?us-ascii?Q?bkd4LtJuZ5/oiufHFxw++hcGOiBrCvvW5XqeW8YJW5szipImWp7TYi+t7Mw/?=
 =?us-ascii?Q?sO8QrWlReXCF84EbukvsxkXjHBsKdwAEzSYc6fLmfjmDseEgsuZLGgJeXJ9d?=
 =?us-ascii?Q?sT53qcZ+FDlS1bVlKwHgA6T85SzeKqjcEMZL9f8Otlx03SnuoRQbZMLXYDsp?=
 =?us-ascii?Q?o8+pN4PgIKoHYBSwEg/0KzlcoXO/8RT2dB293Y8BDSJS2taCNnLFIMKCMR6e?=
 =?us-ascii?Q?/qpyLaHlng=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ebeca5-c47e-4d81-74e6-08dea213ef83
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 15:12:44.0716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w7rM65a50Ss+Ch3veb9UCzfJQHdmL+9/VN2CB6PRTSjmgSreZXCOcjz2GpTPW7wT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6927

On 24 Apr 2026, at 11:07, Zi Yan wrote:

> On 24 Apr 2026, at 8:54, David Hildenbrand (Arm) wrote:
>
>> On 4/24/26 04:49, Zi Yan wrote:
>>> After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio=
 or
>>> not. folio_split() can be used on a FS with large folio support witho=
ut
>>> worrying about getting a THP on a FS without large folio support.
>>>
>>> When READ_ONLY_THP_FOR_FS was present, a PMD large pagecache folio ca=
n
>>> appear in a FS without large folio support after khugepaged or
>>> madvise(MADV_COLLAPSE) creates it. During truncate_inode_partial_foli=
o(),
>>> such a PMD large pagecache folio is split and if the FS does not supp=
ort
>>> large folio, it needs to be split to order-0 ones and could not be sp=
lit
>>> non uniformly to ones with various orders. try_folio_split_to_order()=
 was
>>> added to handle this situation by checking folio_check_splittable(...=
,
>>> SPLIT_TYPE_NON_UNIFORM) to detect if the large folio is created due t=
o
>>> READ_ONLY_THP_FOR_FS and the FS does not support large folio. Now
>>> READ_ONLY_THP_FOR_FS is removed, all large pagecache folios are creat=
ed
>>> with FSes supporting large folio, this function is no longer needed a=
nd all
>>> large pagecache folios can be split non uniformly.
>>
>> In general looks good. Just one question:
>>
>> folio_check_splittable() also rejects SPLIT_TYPE_NON_UNIFORM / new_ord=
er for
>> swapcache pages.
>
> Since swapcache only supports PMD order or 0 order yet.
>
>>
>> It's confusing, but truncate would never stumble over such folios, cor=
rect?
>
> Right.

BTW, sashiko had a similar question when it reviewed v2[1]. It also compl=
ained
about when the split fails, the entire folio remains in memory. But that =
is the
consequence of failed split, unless we want to keep retrying the split.

[1] https://sashiko.dev/#/patchset/20260413192030.3275825-1-ziy%40nvidia.=
com?part=3D9

Best Regards,
Yan, Zi
