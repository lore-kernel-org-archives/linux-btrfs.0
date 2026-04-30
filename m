Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012027.outbound.protection.outlook.com [52.101.43.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956692D979C;
	Thu, 30 Apr 2026 15:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777561991; cv=fail; b=ao0kKkRMBd8AcdvvhCwcVHRzDB5qrYgjnucLqZIbmt5RVAAnrI25EKhjVEq9Ml/0aVWiW7kwWSG8zEnkoF6vW3DuPN2KtXVRm/HB5deH5pMYrKwJVRBSbXdPk8SLObUIRyBjCQmJzOdtJDcXgXPGZztFxxX1f0dptjIPFnNWD0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777561991; c=relaxed/simple;
	bh=noM9gUd4HLUcTeHYR4qyit/yya+RI7Kf2YllqbIQ1QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MhDe0RSzMtq1RTCFcFlMLTje/I8d1oX3w6vFIp/Sj7LOoY7CB/uCIlk4hzO3HhinmTWOT2VUFR17BiVrpbegrgSLEs+uqmprIUQA2/VQqJ/Rg1dDc5xgdlZd/6ZaWt+rs+fDv1rWx1nXgubJda5INbdKhfjT2bKAzy6K04l1K3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UVdgyo+a; arc=fail smtp.client-ip=52.101.43.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UVdgyo+a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ya7KEsRb8Ud50DPhTuH3pFgSoPL4x7P8qlJauUJyROiWfsNY3Ipobn36E07iABGWtz2H2GvxWkmFnqN+NAyUuTY3cN5/uNWL15BhzlM/39ICMll+6mBcas7CtVwzvKV89rGWRs8wuFgpnkN4QJ3ODg7jvayt2Pef383diD7bZcRnsfOf6kPOR5totA+mS9PkcHqG0+QHK36xKQKGWyBTZFsAgVHova06fFiBGA0PnxHHOAUeZ3cNCjGxO8k3PGcubMgD/ysaxGIj63Yhm01jssHhSwy4ADfz9JzAFktBNYL/dC968iEqgXPZFGK8slT2qL2OiFPIvJYEXbv+vbM0/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3e6CWsUX13rFR+nJuShRydLDUVyHhsjbn/KUqIbHOc=;
 b=dAqUEApwfisiPIznwQbV6kpwwwCywh81lxgZhgcLw9c+6UBQ2yRSsc4fwL9kJTOR7oEA7t9S+IBH4cDaYuS+l5cwaa7nUBs2MnvrRLgvyybvI8gXvYeaFdDdSLyrTvmuOyTW7QnhdxEDIq5/GApf+x11kQ1ynQ6VLIBkV3Vkkdnk8VBzTt1OoZlw07yoizNpJltGm56pJ2wd+uXZSu/MW7drHOzW6gltdu7sJgxkAjqH3r/XX8oZXk/wwAQ5v/eaBgMlP5dinR6nOIhEL3pPHkZFtECjHVNtL8Elqf/BZ+BojFHuXZjDlhxWI0sMNxlLrbFZowSCr7LiZwjmGR19rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3e6CWsUX13rFR+nJuShRydLDUVyHhsjbn/KUqIbHOc=;
 b=UVdgyo+aMn0b3B9BGdjOsn+EIDfkXeH9NP4y6vJUf+QLRDn0PcxQpziITj6sQLmeah0cjwJTg9uqanQ8z9Ta38KC/+NFczTE3k0zZDwyDsoeGyXL4dM2J11mC/Dc4xcAA23YghW6mGxa7YqfAQYr1lXMsV6bVR+kgb4CJjQfX/zs3ddVPaDaFS6g+PuTWYpnhGv/bUwXwySdO7YjR3eVmgaL9CTf9Egxnq9KwCoTRuIsvWuOcjxUyS43t9p3vPp9Rjfq6QLK4ViUrdc5QGlUiYF2lcXpMk/7bU9n9nzD96Kdo6zkooth9Zzs4cvI7fvefsAIjmzgfybbAnQB4BvGyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB6485.namprd12.prod.outlook.com (2603:10b6:8:c6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.20; Thu, 30 Apr 2026 15:12:59 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Thu, 30 Apr 2026
 15:12:59 +0000
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
Subject: Re: [PATCH v5 09/14] mm/truncate: use folio_split() in
 truncate_inode_partial_folio()
Date: Thu, 30 Apr 2026 11:12:55 -0400
X-Mailer: MailMate (2.0r6292)
Message-ID: <D5A7899E-2118-4EEC-9624-28130C468802@nvidia.com>
In-Reply-To: <20260429153538.727855-5-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-5-ziy@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:208:256::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB6485:EE_
X-MS-Office365-Filtering-Correlation-Id: eb248de0-b695-4050-a753-08dea6caf6ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IckiOUMJToCXgLGcrl3412YtGCZsFVF1ddZOjntmo1FpuXtB3phHdmIImNGCz/MFIYDcyz3efmYII19KAlshbBdp+6peySEZZgkCI703+kQnlecFzfNg9ghvIoZh4LpAF1LrQXAWZ7ON7weboGkkpNhe/dxd5je+mEuVoQV6oN1ub4Li+Kwuqj+GhpIC1pk+fpPqJqXrFNxwOLFcKZxQ86qCdD+xq1u+nPszBntUlv0mur5WY2v/s8cWNsKwaZdAwEI2S+gTtDnWtfPnoPeJjWMf9izlXQ+91d3xRlWkXN/aYyNJanKEYd5rLnNIenNwy5ABbhXjooMxqEq4Hfqly7Ugk++jJdrwctCJeNwZu94VMDC0zYy54/IaORsYu8SbHuCD8Nk3q95awN56r+i8MzzW0E+XsTYaoSYPJ4GQKaGcQogcCa2b1dByl95A7vZGg74kQHTCciQz+8l6vdCWE92iIBRLKca4ijo5FUS+xvf2jbcO03QPARwvKW5hJ69iX4PuuBAqWBh+gsjYk7RNwbYT+L5KPP4VnOl4qkB1AvFSTWG5H9zQFf+hUcq/b3urWeBd0BTyorFzFnNzCJg5WCtcYWFgDWLpHkrPutVTRFfVK79EY9KN7VP2ZeHIsFdF/o2K+LMXtIlUyJrdx5WKO78/qe723V5kXDrHDoTFkltSNkZgyTvt+rlbjNHIiAfsA8tZ45FR191C+8FQHTRHQbBBDepWgkatj1dhblgr5W4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+wljR1p0TZl6m5A7k6JTnxxdfenctyH1IV1W/p45d+E8zFF5cN2Ap83m75jO?=
 =?us-ascii?Q?alK6kHc3lSg9KdkDPS0EJgM0K80RZvhBMdIX+fMzGXZHa8MePH4EX1IyCSL0?=
 =?us-ascii?Q?ZOVr+dSZLveqW2H404iEiysjpfgNleaoWoVfPJjXx+sHvOR1VtB4Axl4x/8F?=
 =?us-ascii?Q?NAV1G/1CucQdefXVt1Cqy4uRUZVbJ405hh/mSGAaTY6pgYs602izzI4g3udN?=
 =?us-ascii?Q?dnMnVcpo28v8kaV832Kxe6ja9DfFEzOCuuMFGVYvNyK19kcjTxAecm4aU9hp?=
 =?us-ascii?Q?SXbsnzHZoFtbxxCUZsrZcVZo5A4BFEf3leG9QQVlfaiwALo4o0yziWpD6T99?=
 =?us-ascii?Q?lQMFYseJ6UYuWs0vqTjUB6qqNcgEN/XN3jeQJ5GWhtIo/4f5LTyV4ZRUChLN?=
 =?us-ascii?Q?kDROzuuDt2k8eotOv2wJ2DL60gIuv9f+NVUdsZeSmE3Sxi7foJMpavYHdxho?=
 =?us-ascii?Q?qaObVve7CQeH1c2gXJQT4ZqBmXCsk0Nn34MS4+UyRahPOP3My3HFbcNhsB0R?=
 =?us-ascii?Q?P80r2ZObdJ56MtEJdwUtuNikSa1FtvfIxDM4wG9MY92fitY5WhXVxACYE3dA?=
 =?us-ascii?Q?DaBbcoCk1PAi43xpDd3G8Pb+zDNliEhGPNzLLwfj6ZGYxyhrcU9kGekECMGX?=
 =?us-ascii?Q?3NR6Fr+/gUkjxHSqHUIZtzcb5L/wrymEAxkBVkhrswYlgbGxrylUdi1TGdwu?=
 =?us-ascii?Q?UwHEnFrr5+AVCliji7vXrdfDh42D0elL15AiCeRBO04JvSry5W0YkbgkNgy6?=
 =?us-ascii?Q?SIIZqMKyxP6p4pi9OHB7f9nW/cCnjwOgLezoHIBGICwpo2z7mGMW3riSkBQ+?=
 =?us-ascii?Q?yqRR3Q8mblW8K0xuJlHwxcYWmzpyWKnm9LMRt+PMDCKALMwBHVfEPZ3pigRd?=
 =?us-ascii?Q?uCRLqGmrAPynXunpBGegujnRJaYFhwAol6j3YiHdW4arHe78t4xVV/wE186I?=
 =?us-ascii?Q?u2Rb+wGhgdx8+/GlvGwhFb5EDECPo5iOc2mzum0m3jIVGxpF6i5ei2VimdQh?=
 =?us-ascii?Q?ZtVkPEerB2fPLSmvOOQFBwxaxFUZmJO3Tn1Ut1d00RapSFxa/XAD5dpeTosO?=
 =?us-ascii?Q?RBcinRQxTr6W62V2gNUDNlxs+zPCN9IVoy8rBcTqh8OmbuIqnIG10eehw+sC?=
 =?us-ascii?Q?1rbyHxmHPEmCliRpu4ETEPafY/jNbXk1w/UcQxyn9aL6SB2hvrRVdHY4ODrR?=
 =?us-ascii?Q?pAXTPaIOKkSARF54DXzWjfZsy5iMR6BJHt1Tphlg7s2KvR2Fc2+lkrjBsOOR?=
 =?us-ascii?Q?0/miBIikCkSxkdxbenjbBLrsjC02c71XtjuGMJ/4zg2NSCGvcF+WTesHYPrM?=
 =?us-ascii?Q?gAU8c8F9PSQ2BOqfiZlcnapm+Rs74qszdWSf0Z5FcX2JMc+I3jFMuNxal0GV?=
 =?us-ascii?Q?6Avkv4cvk7JdQpYfoOnz84eATWp/zg2WyJmifZLc3MRpneaJOUpMUb/NVPMe?=
 =?us-ascii?Q?oIKfKiqzxaSv5YLYLdr/DtgfgpA55adZ7NsighW/i3jMA9I7axiuqFiyCuI0?=
 =?us-ascii?Q?Vos0jpuoR/zc0GduODH41bWy1T9Tr/XMaoBRaUO5CNB4dgG9ksoFGHJAnHzl?=
 =?us-ascii?Q?XX//bm235gjnFyMCxzW0fKgD5knL279hIYqw68d4wxD/1ZH8pEvpCBCyp8iz?=
 =?us-ascii?Q?O6P17I9KYrJq6/afMarh2WlLQ2YRnfgskZMjvz3YVWBn+qyGnjeWwF+VeXp6?=
 =?us-ascii?Q?uxE0des9ThKf+zVaaVP+/4JWOsFAWNPTVHCEeWpqQ7tkznBU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb248de0-b695-4050-a753-08dea6caf6ec
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 15:12:59.1152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jFnpBFoxo8Z2RDf1aWwtrtFPvFybZLc44BtPFI9TlIw70eBLpIZ/1O9AQ4NR+XP3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6485

On 29 Apr 2026, at 11:35, Zi Yan wrote:

> After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio o=
r
> not. folio_split() can be used on a FS with large folio support without=

> worrying about getting a THP on a FS without large folio support.
>
> When READ_ONLY_THP_FOR_FS was present, a PMD large pagecache folio can
> appear in a FS without large folio support after khugepaged or
> madvise(MADV_COLLAPSE) creates it. During truncate_inode_partial_folio(=
),
> such a PMD large pagecache folio is split and if the FS does not suppor=
t
> large folio, it needs to be split to order-0 ones and could not be spli=
t
> non uniformly to ones with various orders. try_folio_split_to_order() w=
as
> added to handle this situation by checking folio_check_splittable(...,
> SPLIT_TYPE_NON_UNIFORM) to detect if the large folio is created due to
> READ_ONLY_THP_FOR_FS and the FS does not support large folio. Now
> READ_ONLY_THP_FOR_FS is removed, all large pagecache folios are created=

> with FSes supporting large folio, this function is no longer needed and=
 all
> large pagecache folios can be split non uniformly.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  include/linux/huge_mm.h | 25 ++-----------------------
>  mm/truncate.c           |  8 ++++----
>  2 files changed, 6 insertions(+), 27 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 48496f09909be..127f9e1e7604c 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -394,27 +394,6 @@ static inline int split_huge_page_to_order(struct =
page *page, unsigned int new_o
>  	return split_huge_page_to_list_to_order(page, NULL, new_order);
>  }
>
> -/**
> - * try_folio_split_to_order() - try to split a @folio at @page to @new=
_order
> - * using non uniform split.
> - * @folio: folio to be split
> - * @page: split to @new_order at the given page
> - * @new_order: the target split order
> - *
> - * Try to split a @folio at @page using non uniform split to @new_orde=
r, if
> - * non uniform split is not supported, fall back to uniform split. Aft=
er-split
> - * folios are put back to LRU list. Use min_order_for_split() to get t=
he lower
> - * bound of @new_order.
> - *
> - * Return: 0 - split is successful, otherwise split failed.
> - */
> -static inline int try_folio_split_to_order(struct folio *folio,
> -		struct page *page, unsigned int new_order)
> -{
> -	if (folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM))=

> -		return split_huge_page_to_order(&folio->page, new_order);
> -	return folio_split(folio, new_order, page, NULL);
> -}
>  static inline int split_huge_page(struct page *page)
>  {
>  	return split_huge_page_to_list_to_order(page, NULL, 0);
> @@ -647,8 +626,8 @@ static inline int split_folio_to_list(struct folio =
*folio, struct list_head *lis
>  	return -EINVAL;
>  }
>
> -static inline int try_folio_split_to_order(struct folio *folio,
> -		struct page *page, unsigned int new_order)
> +static inline int folio_split(struct folio *folio, unsigned int new_or=
der,
> +		struct page *page, struct list_head *list)
>  {
>  	VM_WARN_ON_ONCE_FOLIO(1, folio);
>  	return -EINVAL;
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 12cc89f89afcf..b58ba940be474 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -177,7 +177,7 @@ int truncate_inode_folio(struct address_space *mapp=
ing, struct folio *folio)
>  	return 0;
>  }
>
> -static int try_folio_split_or_unmap(struct folio *folio, struct page *=
split_at,
> +static int folio_split_or_unmap(struct folio *folio, struct page *spli=
t_at,
>  				    unsigned long min_order)
>  {
>  	enum ttu_flags ttu_flags =3D
> @@ -186,7 +186,7 @@ static int try_folio_split_or_unmap(struct folio *f=
olio, struct page *split_at,
>  		TTU_IGNORE_MLOCK;
>  	int ret;
>
> -	ret =3D try_folio_split_to_order(folio, split_at, min_order);
> +	ret =3D folio_split(folio, min_order, split_at, NULL);

Sahisko:

If split fails, the truncated pages within the large folio are zeroed
but never removed from the page cache or swap cache, leaving them behind
until the file is fully deleted.

Answer:
That is expected.

>
>  	/*
>  	 * If the split fails, unmap the folio, so it will be refaulted
> @@ -252,7 +252,7 @@ bool truncate_inode_partial_folio(struct folio *fol=
io, loff_t start, loff_t end)
>
>  	min_order =3D mapping_min_folio_order(folio->mapping);
>  	split_at =3D folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
> -	if (!try_folio_split_or_unmap(folio, split_at, min_order)) {
> +	if (!folio_split_or_unmap(folio, split_at, min_order)) {
>  		/*
>  		 * try to split at offset + length to make sure folios within
>  		 * the range can be dropped, especially to avoid memory waste
> @@ -279,7 +279,7 @@ bool truncate_inode_partial_folio(struct folio *fol=
io, loff_t start, loff_t end)
>  		/* make sure folio2 is large and does not change its mapping */
>  		if (folio_test_large(folio2) &&
>  		    folio2->mapping =3D=3D folio->mapping)
> -			try_folio_split_or_unmap(folio2, split_at2, min_order);
> +			folio_split_or_unmap(folio2, split_at2, min_order);
>
>  		folio_unlock(folio2);
>  out:
> -- =

> 2.53.0


Best Regards,
Yan, Zi
