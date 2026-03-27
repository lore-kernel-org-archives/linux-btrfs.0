Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011031.outbound.protection.outlook.com [40.93.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF371D5CD4;
	Fri, 27 Mar 2026 15:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774625720; cv=fail; b=j2BPvh1ISFSUCkI8IuWJi0ukiEDMGmEg+baJ1jfGRkMFqILG94DNo5Yaok0iXPNeKweWZkjw9NizFmUaA/CxICeI/s6HFKpZkT5SbQ9lXud7rHB46yT0Mdz27cl56e1g1nzHLavf52WJhIScvyLKQRRIgMxBraTrrF0vP2QEP+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774625720; c=relaxed/simple;
	bh=XNJ8IbL1Pe7wnwwzkFyHf6kC29gqC3MUFfl+9VdnMYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DP9U5UAUlwQ+GMJ1khtgocL+piG4QIuy+rN5pvjx3KI59hfk+r2YKibAU/dqpkU++dNgeBvSeAvru2kD6E7EZlAgd3GbFMi9KH1ZTX+rnD6pGrcgsmVqG4K5j/CLxGF+AjXaRNuhd1tksga36myxudOhbkfLYH+qIBiGJKLpGpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FUgCXu5p; arc=fail smtp.client-ip=40.93.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FUgCXu5p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G6ojaCKAT9Z6uTu5PvT/XTVg2MGph+AMIxVO4+YmYBKo+h1G7OhMWX6Fl7oYEegNr7u8lBykq61U0h52xMUhdeQ32vlI12Asj+KxfCq6izKyWrQw1hKSRh7te/BEQhf8e2xpYrWNdCGhFOEW5YNERbwWXX/Q7iw9BYtRejWaEwpsnrqn0Rk5mvQqeatsyq6vkX/Qp3uU+kNce6xJdSR4FADCGmeTTchblVNtEySNz8pq7ynSj3cMiGETG9Z/NNP9nUlO2UVOV2o1Fe7lZcIx1BpqTidNZty5iYd3WTOdeA8IcpNos3wCnTMa7R8OLIrxKC5w/65UG9USP2JDRQPnHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NHgdMDSAaMac0OTUGTqh/XWPeGyNSFplBaZLR7Qs++w=;
 b=HLi9zvIk6p0MeVjzhqbL2zEyuWlWEHKoFpjel5iFaca1GczWjWZqtQyypVezKwaL40MyeTXRQfgQ/3/xCOAUQ+x7Ax9cHDSSHfxNAt3axsaEBdiLphKTW5vymNwrkL0bAVhGaN1fCpYph5oMrqdilip6iab7m8ebREYju3JjcWlvSlRQXVbti7RwlGAkw5IlJcrb2EjeA2o77RV4UypuNxDItWRfG9m6LMhehQr2Juen9F/vwTsmrtxYSBgTr+/yKRKCq20xIOZXic5tpEIbCbd8aharX72gZXOeQ/4BV1W8G8dF+2PmVQBZLlBxoY0tuMsKSfy/0gh8rTxIJ0uoOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHgdMDSAaMac0OTUGTqh/XWPeGyNSFplBaZLR7Qs++w=;
 b=FUgCXu5pO5vjm/XJfyXQ2m/LPiWmnwTss+M5IQJIt9+YV3PpopxqL1b529PXxeRCxU5EtajgrEjl0PwrjWt3nAHh4tbme8INRrcXvICPLybk068NtoE6FyqxPiuXJCRQeI/hDK2gyvU7ZdzCUHhcFfGzUaMvIP21T4tuSIeeFAuzo5ZLwC1hBdz7NrAM3AR/7ha0Ix5OtMOhIiK1BTK+7rkoy0N9yboVGP4jb88WcEu9ADoDixPZQXtU0sBg6Kytk9wER+pbEDqKqql6XLAw9I4j95ZavwPvorRohcxIqWwp6CB0OjOgwQuwfu/IW7hbrhdGY9qboqS2nBD2iEie5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB8081.namprd12.prod.outlook.com (2603:10b6:8:e6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.11; Fri, 27 Mar 2026 15:35:12 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 15:35:11 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 07/10] mm/truncate: use folio_split() in
 truncate_inode_partial_folio()
Date: Fri, 27 Mar 2026 11:35:05 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <F4DCA929-F799-4D81-9600-08BCA030949D@nvidia.com>
In-Reply-To: <e23792e4-3331-45b6-b709-cd0896146a3f@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-8-ziy@nvidia.com>
 <e23792e4-3331-45b6-b709-cd0896146a3f@lucifer.local>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0261.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB8081:EE_
X-MS-Office365-Filtering-Correlation-Id: 89740c46-afc3-4ac3-e19f-08de8c166edb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|13003099007|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	zdjFCG0gsiKCPQeKANRdGAd/5ky/93uKtA8M2CS4ceuFSzA+QckRyWA+JqgoVH3a4+AH9Cmi6WOQYyQiestmgOr99XnZslSlc+ZPyzFK5uz6PpIOedVyo39EAxJ9KZg/BKCF8mg0F+ffiQw0H4/VY8s7lvg008Py00ObqvKP4BCjWA6qIfKwfq33Msu0gKyJZ2RqDc8GKAH3xGc6+u3EOi0vUWLcT4emK2q8bnPZfKQPKhTLc28PE8Lrv17fBavJ8gtoShoHa9OzJUTRGv0Y2SkN/oifvcozli+6hDKiZ4Nf8z/kuKk0ollQp2WoXwzo+zt7ZTAH/re/Gs2DkNHboCwTonU61wp8ZqDWn0PPmL1lqeHvQ4tb30wnRLnenzy7bLR/lmp1Ezl1SUGK159U0jiYtzx/KQp13be8JtHmFTPU/jte8LrK3T7g6/p9ePyYSU0IrfH7Bx6h4HFpgW2a1XlxABF2EIhmi7gCmxLXeB4Rg8pu44fslM96Te5pjbkRe1us/Bv3/nqAZ2QTm0zad1i0/jtA7p7/KmYXwA5IFI59RUh4eoyIsamp7a6Raxtuiuoerj6zTmDOBsZE2EOBg3tHiUxLPWNwywv9JkQhN2PHtGuYoEYGb0QheFJ9ByFhymUXh7FT2a30anFjVDMvP65o5cSv15O6pMUYu8ussr462UQf2nLVzVpso0mwUEafZq2QHgkc0ArPyutY1JghcE6Ui/7rrOpFIIXWBH4Uf7s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(13003099007)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lH3JkcRFvGLFHu/bOcIw5u7Rr7U16CK9iM1Kvibe+ae6XvDo2LbR63y3OKnE?=
 =?us-ascii?Q?ZB0/5MEYsY9DI7DaS2oZEaghnZF7auspvkZP9V8S/XA2iwgB0OOuPEtzdyEI?=
 =?us-ascii?Q?+sGuC5iyVOhbe4qwd+DPngKPz57bXWs6IyGn2D/BiMtLizk8btQ37dBgjQo+?=
 =?us-ascii?Q?4cLUIDxt87O7ykSnKQfyZNpBuvGCu5huCN0r3lpo53cQ93Fg/WGNwDJyR/+3?=
 =?us-ascii?Q?ZbVhCaZh/c5A7MVaQKznkaKJEJiOKVgW+4ycWMuVWBtaZxA5R+QUwlcCt2+W?=
 =?us-ascii?Q?twRNL60UNAIMJaVAL2wVpOEL0/BPEKtKTjXiKsg8iz8utVYgpHRKdRMZ4TuX?=
 =?us-ascii?Q?oPSMUA7T6BHBidaon1JHjFyB2IDCJj2uuF+CQUvX+AeY9SKD9N+TNcqobw1y?=
 =?us-ascii?Q?UykPw0zgeTwzm2qSevxF25I03vvre2YZiq76qW5BS7O+oVeedluQAbecBlBq?=
 =?us-ascii?Q?eLU1zScKXlDrK0N7jSFp9NOum93eKebr1iQOmVTrUlM6op1P9I2gRBJn/JfW?=
 =?us-ascii?Q?bGaldcoCyDw8j1kTK1BI+T6iy3YSxfvZ2KfHK+vydQ68uIaXhUPwRtKhHTUQ?=
 =?us-ascii?Q?IuTBq3dne0Taq52f+uMGfES2sQpWZD+dlG6rVRJhDVOvhX2jJIYUc0K8aeze?=
 =?us-ascii?Q?b8kJ3Zd9OronxIQIcutPNZaGxHKdWaxjJFvMfVz74z7OrNVeXrI+FSMC9M6i?=
 =?us-ascii?Q?mnUMiLewuB2tdzv2hJVBjvcqJKgB6lYXkT6c0FCC0iZX9HYpnqBMuzJPwiyA?=
 =?us-ascii?Q?KH8EcfD4ruOSva6yE+eeIbB1ivBYkdkLMF2T+MtDlEnfvnKOVOp0clOzTsL1?=
 =?us-ascii?Q?IX0f01HBFBxSUzaiSZdutyMYmDkem+8AecyZ7LH+QNAUQv7DOlQfN0mqGLDU?=
 =?us-ascii?Q?s2Ky2opAtNphXVmhLsKQKUPNFtvBllrxQChCu9AVtD/mZex3b8FrtGZsbAbO?=
 =?us-ascii?Q?KiB+d62LRTadHeGeZ93a3MRP+CUgd+FpkhjLMl8EyJXiChUt+/e9N7g0kcZ5?=
 =?us-ascii?Q?SSy0HdjygMymtiXhoLt7SQSoXJeunjvM4xRP4oDInNgFyVONO/C/mDX6IJiB?=
 =?us-ascii?Q?TDZcvG+C1DI3fmY+3SuIMlqM+uk82etjmt+u4NwyXoWRDZ76+agFs+hzEXeG?=
 =?us-ascii?Q?RShroOyOXn5tCKJoVBKEuP41IuMQ+FojoEfU0B8grr9BLdF6+/bRIsNSkwaP?=
 =?us-ascii?Q?ncb6uQh3nACGuHPudBLrU4S0ScFQVk03jR9uYhViOfQ5M1ojAQ7Lqagt407n?=
 =?us-ascii?Q?pHEsg+UqCk+D5WgAZptSeB58rJWgFVJnAHrEj7q88bCOqTD3nlaqxFpCoJlR?=
 =?us-ascii?Q?QW7eouMlLB2iFqTxz98QsK471dWfeR7OOfzH8qqH6LxXg5BzCrF2bJzGXh+J?=
 =?us-ascii?Q?Plg2wa5XE519LvHsoGHRqbNO5Nq1Um05okoU+FH1vOxD4r9ze3MCrISz8b0i?=
 =?us-ascii?Q?SNSuji0/pFlcw+8D+xgzh21rc40ImxjwkdMWe8477MkRui3OqXRIxMwz5pD5?=
 =?us-ascii?Q?AYZPXoxI5lAxvuHvzcATcYAF/V2Q3zX478G5ePJ6hxy2Nl+AGuY7IaO4BjnM?=
 =?us-ascii?Q?psD/h+1CIZzAXzL0Rfe1PTQmZJ9XYslgettc/KI5NP5z6w862HmSfy8b0t0h?=
 =?us-ascii?Q?pUnLX+J9jdZkFK7uGSsDAHBOxuJJdeIzRd0MwmVSyn9KMPwLiEfmRAXWSKHQ?=
 =?us-ascii?Q?yJn6aQK9BBwgsOmF802kfsVQZ9vUwiJfZJJY4zsoWk64dTD6wORoVARRbPF1?=
 =?us-ascii?Q?qmgIZeBj6Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89740c46-afc3-4ac3-e19f-08de8c166edb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:35:11.5264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qq/zmjD6IfP3moT7ynK/Yxq1sEzXwlxUN7ejwkEuV34CbgdfC6E55J04vT49FbXp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8081

On 27 Mar 2026, at 9:05, Lorenzo Stoakes (Oracle) wrote:

> On Thu, Mar 26, 2026 at 09:42:52PM -0400, Zi Yan wrote:
>> After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio =
or
>> not. folio_split() can be used on a FS with large folio support withou=
t
>> worrying about getting a THP on a FS without large folio support.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  include/linux/huge_mm.h | 25 ++-----------------------
>>  mm/truncate.c           |  8 ++++----
>>  2 files changed, 6 insertions(+), 27 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 1258fa37e85b..171de8138e98 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -389,27 +389,6 @@ static inline int split_huge_page_to_order(struct=
 page *page, unsigned int new_o
>>  	return split_huge_page_to_list_to_order(page, NULL, new_order);
>>  }
>>
>> -/**
>> - * try_folio_split_to_order() - try to split a @folio at @page to @ne=
w_order
>> - * using non uniform split.
>> - * @folio: folio to be split
>> - * @page: split to @new_order at the given page
>> - * @new_order: the target split order
>> - *
>> - * Try to split a @folio at @page using non uniform split to @new_ord=
er, if
>> - * non uniform split is not supported, fall back to uniform split. Af=
ter-split
>> - * folios are put back to LRU list. Use min_order_for_split() to get =
the lower
>> - * bound of @new_order.
>> - *
>> - * Return: 0 - split is successful, otherwise split failed.
>> - */
>> -static inline int try_folio_split_to_order(struct folio *folio,
>> -		struct page *page, unsigned int new_order)
>> -{
>> -	if (folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM)=
)
>> -		return split_huge_page_to_order(&folio->page, new_order);
>> -	return folio_split(folio, new_order, page, NULL);
>> -}
>>  static inline int split_huge_page(struct page *page)
>>  {
>>  	return split_huge_page_to_list_to_order(page, NULL, 0);
>> @@ -641,8 +620,8 @@ static inline int split_folio_to_list(struct folio=
 *folio, struct list_head *lis
>>  	return -EINVAL;
>>  }
>
> Hmm there's nothing in the comment or obvious jumping out at me to expl=
ain why
> this is R/O thp file-backed only?
>
> This seems like an arbitrary helper that just figures out whether it ca=
n split
> using the non-uniform approach.
>
> I think you need to explain more in the commit message why this was R/O=
 thp
> file-backed only, maybe mention some commits that added it etc., I had =
a quick
> glance and even that didn't indicate why.
>
> I look at folio_check_splittable() for instance and see:
>
> 	...
>
> 	} else if (split_type =3D=3D SPLIT_TYPE_NON_UNIFORM || new_order) {
> 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> 		    !mapping_large_folio_support(folio->mapping)) {
> 			...
> 			return -EINVAL;
> 		}
> 	}
>
> 	...
>
> 	if ((split_type =3D=3D SPLIT_TYPE_NON_UNIFORM || new_order) && folio_t=
est_swapcache(folio)) {
> 		return -EINVAL;
> 	}
>
> 	if (is_huge_zero_folio(folio))
> 		return -EINVAL;
>
> 	if (folio_test_writeback(folio))
> 		return -EBUSY;
>
> 	return 0;
> }
>
> None of which suggest that you couldn't have non-uniform splits for oth=
er
> cases? This at least needs some more explanation/justification in the
> commit msg.

Sure.

When READ_ONLY_THP_FOR_FS was present, a PMD large pagecache folio can ap=
pear
in a FS without large folio support after khugepaged or madvise(MADV_COLL=
APSE)
creates it. During truncate_inode_partial_folio(), such a PMD large pagec=
ache
folio is split and if the FS does not support large folio, it needs to be=
 split
to order-0 ones and could not be split non uniformly to ones with various=
 orders.
try_folio_split_to_order() was added to handle this situation by checking=

folio_check_splittable(..., SPLIT_TYPE_NON_UNIFORM) to detect
if the large folio is created due to READ_ONLY_THP_FOR_FS and the FS does=
 not
support large folio. Now READ_ONLY_THP_FOR_FS is removed, all large pagec=
ache
folios are created with FSes supporting large folio, this function is no =
longer
needed and all large pagecache folios can be split non uniformly.

>
>>
>> -static inline int try_folio_split_to_order(struct folio *folio,
>> -		struct page *page, unsigned int new_order)
>> +static inline int folio_split(struct folio *folio, unsigned int new_o=
rder,
>> +		struct page *page, struct list_head *list);
>
> Yeah as Lance pointed out that ; probably shouldn't be there :)

I was trying to fix folio_split() signature mismatch locally and did a si=
mple
copy past from above. Will fix it.

>
>>  {
>>  	VM_WARN_ON_ONCE_FOLIO(1, folio);
>>  	return -EINVAL;
>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index 2931d66c16d0..6973b05ec4b8 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
>> @@ -177,7 +177,7 @@ int truncate_inode_folio(struct address_space *map=
ping, struct folio *folio)
>>  	return 0;
>>  }
>>
>> -static int try_folio_split_or_unmap(struct folio *folio, struct page =
*split_at,
>> +static int folio_split_or_unmap(struct folio *folio, struct page *spl=
it_at,
>>  				    unsigned long min_order)
>
> I'm not sure the removal of 'try_' is warranted in general in this patc=
h,
> as it seems like it's not guaranteed any of these will succeed? Or am I=

> wrong?

I added explanation above.

To summarize, without READ_ONLY_THP_FOR_FS, large pagecache folios can on=
ly
appear with FSes supporting large folio, so they all can be split uniform=
ly.
Trying to split non uniformly then perform uniform split is no longer nee=
ded.
If non uniformly split fails, uniform split will fail too, barring race
conditions like folio elevated refcount.

BTW, sashiko asked if this breaks large shmem swapcache folio split[1].
The answer is no, since large shmem swapcache folio split is not supporte=
d yet.


[1] https://sashiko.dev/#/patchset/20260327014255.2058916-1-ziy%40nvidia.=
com?patch=3D11647

>
>>  {
>>  	enum ttu_flags ttu_flags =3D
>> @@ -186,7 +186,7 @@ static int try_folio_split_or_unmap(struct folio *=
folio, struct page *split_at,
>>  		TTU_IGNORE_MLOCK;
>>  	int ret;
>>
>> -	ret =3D try_folio_split_to_order(folio, split_at, min_order);
>> +	ret =3D folio_split(folio, min_order, split_at, NULL);
>>
>>  	/*
>>  	 * If the split fails, unmap the folio, so it will be refaulted
>> @@ -252,7 +252,7 @@ bool truncate_inode_partial_folio(struct folio *fo=
lio, loff_t start, loff_t end)
>>
>>  	min_order =3D mapping_min_folio_order(folio->mapping);
>>  	split_at =3D folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);=

>> -	if (!try_folio_split_or_unmap(folio, split_at, min_order)) {
>> +	if (!folio_split_or_unmap(folio, split_at, min_order)) {
>>  		/*
>>  		 * try to split at offset + length to make sure folios within
>>  		 * the range can be dropped, especially to avoid memory waste
>> @@ -279,7 +279,7 @@ bool truncate_inode_partial_folio(struct folio *fo=
lio, loff_t start, loff_t end)
>>  		/* make sure folio2 is large and does not change its mapping */
>>  		if (folio_test_large(folio2) &&
>>  		    folio2->mapping =3D=3D folio->mapping)
>> -			try_folio_split_or_unmap(folio2, split_at2, min_order);
>> +			folio_split_or_unmap(folio2, split_at2, min_order);
>>
>>  		folio_unlock(folio2);


sashiko asked folios containing split_at2 can be split in a parallel
thread, thus splitting folio2 with split_at2 can cause an issue[1].

This is handled in __folio_split(). It has a folio !=3D page_folio(split_=
at)
check.

[1] https://sashiko.dev/#/patchset/20260327014255.2058916-1-ziy%40nvidia.=
com?patch=3D11647

Best Regards,
Yan, Zi
