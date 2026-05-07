Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012021.outbound.protection.outlook.com [40.107.200.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C4940DFCC;
	Thu,  7 May 2026 05:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778133159; cv=fail; b=IgH9P1VrrWCO0vkHQj7xegToCtcVpHcEt+q6z1t/kNb9WFuLwnT2vm545IADiHzs6vkIpSUG5tpnt1+sTipLq/x83yw4cK8EukLdOJXayu0HtBiwpxQ4sggy6qm3wWbkE4gtLZp4D+Om6Lc5JvdNVHpNrrh2WHeLDEaNzFr+aLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778133159; c=relaxed/simple;
	bh=b2XbXfe7KadX0XJUStIhbO+RRMX+EIhBiLCMh+Xbl/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r0V4f19HbVlLi2TnyxIixMyAjhQuMiRtQpF0RFmO7Rn87sQEDnzFhmGkSmC3S1VMKmV8tEN3+7yMaV4TC38KZrztb5QB30S15FwfuJ8CmbsTwiLxhesN22OtWukWJY8kmancoVBndnYm3WdZ16z+S3vE2I6Jk7ZULCurNM0Q7s0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gFB/m+Yi; arc=fail smtp.client-ip=40.107.200.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gFB/m+Yi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F099egUDaeZvVUicLU4FTLilxuexY5DIA/H45nftr0Z1d9sbYpljVtMc5tyW8rWtljRRYCsdtqyxcdIcVdfOuWbEOI8J47I2SVOltGnV0ulCjrBqYGr/b3p7nyhjfYGc/Sy6nekox0JMRqsyLIksBsmlB3LurSpHfVhrpQXEx78adLQo1ibL1cKQc4qy8LFPyeapEYYxiMPJzjG6rWiX5VhdRt7vyesgc8Cm+5a5FZYDptmkJXwz5fdfCGKrkXhLNwFMvZO7wvCBm7USGK9UfUQ+GNCNSEgZYsROqfeHOTl+Y6l40+/dNC75wUhs+VOQxTcm101tIV9Iv0JBr2OvWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g6qKsFlwJyWWjyNnCw7LMqqMM0FAJ7PrAiEboSmxZKQ=;
 b=V7rS6iaLIwTDVQEwEaaoBHzcpPJ5k72YLe+hpVhNMiU9DUzO3ugMZIbRn2P7zHaOkIcPDf3bMmyjYXhpwBerUdQMnAjXtdaoaDFc3iWcdo7ixbhQPqFbW7EElRG6ZGVHOdnVATZ5bQwMuGfC44nL6ymRZC+wagajA4tY07/fzL6VjRGmxBoMlOyQQYvRjvIO5wjH7DR8m2Sc6xShitmWbgaZBFaDbsbTwnb/uu9QV9bmmS99uUI/VgXezyu+MQBWd97RTaYL/pYM3S6adyYsGHai2PZGWZiYOBsfvnm2RvPZf7Mq4zt2oS+nDUJ1OjHLgMu3w21vs1kGr9W9jkPHVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6qKsFlwJyWWjyNnCw7LMqqMM0FAJ7PrAiEboSmxZKQ=;
 b=gFB/m+Yil/wIfQ/NNTAu0Eb5+1WSmhp/8CGvZi1pDcAuTydXb+95LZCfyWpL4OhWDlMJ6BKmbq1TSl3eOtlDwlvDE8I8QBi3uICrb9n7BlA0u4yY9GvLy2wjuaEZZ44EPp+JD3Cx/OagB20RDOcnFc/2V+IH+xrzL68N1vFTfFqfcuxK8jhUMjXvIsQwUluTaPHxZaIZIbv+Stdam+74odcNMJ3iYQyD3SrkqRoq12p4R+pOfBuL/nlGQX/+1v7vpd7m9zgCR5/FU6hUiVy26aIR/vCGlAAcnX936bo1hnH5VYIBn7BT638tA3MIipzU48sBV2nUy3RPaHrcEXXtLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by SJ2PR12MB8034.namprd12.prod.outlook.com (2603:10b6:a03:4cb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.16; Thu, 7 May
 2026 05:52:33 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 05:52:33 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>, npache@redhat.com
Cc: akpm@linux-foundation.org, david@kernel.org, willy@infradead.org,
 songliubraving@fb.com, clm@fb.com, dsterba@suse.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, jack@suse.cz, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 01/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Thu, 07 May 2026 13:52:18 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <2BF9E08B-D35A-486D-B934-B8537CA9EA45@nvidia.com>
In-Reply-To: <20260507032956.51667-1-lance.yang@linux.dev>
References: <aa778cfc-b7f8-4100-89bb-d2b2ef8e1138@redhat.com>
 <20260507032956.51667-1-lance.yang@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|SJ2PR12MB8034:EE_
X-MS-Office365-Filtering-Correlation-Id: a2a2ec45-26ec-44e2-b327-08deabfcd517
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DOXx/KO8RANfu8ppTi0PateAa3A655xS2yH79ccZ0t9KzcbLIgKb/4VzEu4XYDQOCZEZgNv4pa2MGDAY1mFOmMHI+62fpPUuvg/Vc4C2crILSFMYAdPAWuCdk279lRan93Bpkw1VdX3k5aJz/kRiOCSb4QfM5usR9Htuid5J/7a4v48212QBmkCHJqoI5vAvjKp4raZL432uLaLdpFq2kNvrKKicU1p+Yui5XG61a2aaADBdwAoCnTeMsKOadtPBwzrPty7sxbQ0j0kHl8a4tIGD+M+B6Vsehgxhyu9HbiH9jrwLyWDXmnTb6l86IdMpfcFmyB6Ar+m2yswDOUNvQZLRy+BDgbk8G6OriV8FtbFsIxA9oSJIk9JhkJqkka+YviEfXL/AqGUcfu3jHysosKwv/GNlZ9LGOQsXpYD3Ap3HOyFkyo1uJ8F4mK7FdbZ5oNHKcXFq4p5U7PS6d9UtdCfMveXX8X6rjCWXw27+2YAX1SdUGLZtZV+Q1RRAgTJJZ7aAQ9nOGmai6ziEc4oqiw4n7YNMtEWFbyPNgXRvsSwa22+bzLt9mpZ+9aLONKWZvFZusiyX9tj5jgd8GjQfqDDi/Kw5mT2tcwgS6GfD8px6Eg9b0NhUe5gK8cC4q3hS/tsvNpKOgXRX7cfIOiJ/h1/Y3z0Ub3P4rTlWAAaIbAW83QkBDm/4CuI3Hw6F47vD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aL+Uzl9lphVzIdObKrSwX27CJ8PWhfRYyLqjF1A9H6Qeg96In/C4mpGCQiFA?=
 =?us-ascii?Q?hvOLjRqrZO3zWhaayQFKyN6zcI0l23gVUnbyECjsSJFFGo5g7+uwk0+gRLzp?=
 =?us-ascii?Q?qMdu65IpoW9CPmghTQPbm6wJ+UU8lv7n6ndTBLH7Qx16mUgafl3XfyRuQf92?=
 =?us-ascii?Q?NMpnImZD9nucgXjK5a7cSFgY9+Xr6RVYEyadePH1SSS31P+eu1TU4Nwc4vs8?=
 =?us-ascii?Q?IDT4w1eL+dSHgAxu8k0phVpvctd+VUpb54qg8kGeEGlVXd7LMEQ08ZqiredO?=
 =?us-ascii?Q?xC4a4cF6gKATL623oax4awq39dunp/0bSdWu8WQZqQ06I5mrbRGEUhx68QB/?=
 =?us-ascii?Q?iZtBfhWd99jH4XMvPiEn16mx/v+qjV5HUsRpYTPs0dtzUghyyhOUlBk3U6WO?=
 =?us-ascii?Q?B85MikVhpyy4BKqrscxizPeghHJ3VO6IlFBECFmj/F2yPQWW7b4ORtC0hnn8?=
 =?us-ascii?Q?vbLwcgLcA0kcbAP8UwkdIQva6j8LstWYXRDZ5wj7OvtTcj2NyXPu18YeM1yc?=
 =?us-ascii?Q?CiEnh6IbYAOLHte2bs+EgJ+83qsxg/IHfAgfj7//V3Fef6B/jeOPUO1mLDfj?=
 =?us-ascii?Q?QdPzgXMXwK6gSrQHJ/f7q482MtvGwAzrkv4riZHIJs9YGP43WFhRglYJ+ehn?=
 =?us-ascii?Q?h1+W+ssMqwsRL4HWC7JpMKfLrU9x5TRzFQyBmONQaVT5mwauOXxbDThOGoDl?=
 =?us-ascii?Q?Gs03Igb/2592+53ix74XbLIUt6C8LZjoX3eOUJE4kcF8+liaGkVGVaFec/GJ?=
 =?us-ascii?Q?yLtcTA8P72F3GIGGHrgnbbfZYk2Te2GuMAcFfZsQ4bsylynmaRtkcKe9UfzH?=
 =?us-ascii?Q?TrbzkydACptSF32sY2X/Fj4EWDfYAEbqwcH8z9CJwC/KjcTlZcQHUu+I9+8n?=
 =?us-ascii?Q?wQygaqHBN+yPg5M6jJBh6VI5zBGOKh+MKz1OlYKQJACg2WT6PpxaSVrYGemM?=
 =?us-ascii?Q?lle9m3BD+/eEL6AwY5CBj2Z/p9knTfaMYEa6fOBp0T+OHEO4eiXvEe0KtL0S?=
 =?us-ascii?Q?GxI9DpV8bV2/piblnmeywsdirEBZzi2nFCVWeTG611jLAMZ7tavG3aiC9uib?=
 =?us-ascii?Q?zJ49sUxL0LgAMcq6VkmXlDz7I+rQjaBTCAvcv/5t7blRCtsB+/MzIU3rVwxK?=
 =?us-ascii?Q?LOJSBh6RtVM9eFJ1lvTYLXMyk4y3Y/0ti5YnyIMYhWGxjd7mN614xHdQYvby?=
 =?us-ascii?Q?YmvjE68Sh5Pgo2fpdXRv1h1+SIfQRvZN1sF4QsE3vUnPZE/hptInpzIf7Z+f?=
 =?us-ascii?Q?EPhWM2ZyyNwnTYG8ai05CDUojirVCx+224gRLsFGmwNysCKD+XXNHGt6wsfR?=
 =?us-ascii?Q?9ahnoALNQw4bmk2kSDJTHlzyGYLVHSkoiIy9t2bXN06OMkhOYjQgD6e3Xq/5?=
 =?us-ascii?Q?er0vycB2HYFCpx+RcQHrE+YHTK66cV30yW6/OJkeMXuDTdvypOFc4hnAuQEz?=
 =?us-ascii?Q?/Sc4f/j0jF9TuX4Vd02NfNKlNK45X8k0KKPOqjmvjgnu1Xgong7ShPrCtTCy?=
 =?us-ascii?Q?Yd1qJ9H/pVi4eisYy0fo0hYEG6OAyGQrYjBvs0TTYoraFl4GtyQnn+2QUE8g?=
 =?us-ascii?Q?PzsSUXkC2i3U0AwKKaRKSALMS/cksKxLb7VFzVSK1q80KTnNf5DXrPZl7mjU?=
 =?us-ascii?Q?yS0lPov5q/hwdJTmlTR8usk/wJQ+0Ow6Epx8mKTfrZ2OujCyO7CLoo58Dsel?=
 =?us-ascii?Q?K5kx/sKDhDf/NMDCIhfrp+zApHGlLw33/C1hrwjan8CWr5wG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a2ec45-26ec-44e2-b327-08deabfcd517
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 05:52:32.9613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tCbg7EeTWh2veF9vA4mP44Cz9YRz6dN7oD8+6TjRQXpom/0Jjq3L+KsQvnRpIb9V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8034

On 7 May 2026, at 11:29, Lance Yang wrote:

> On Sun, May 03, 2026 at 09:48:40PM -0600, Nico Pache wrote:
>>
>>
>> On 4/29/26 9:29 AM, Zi Yan wrote:
>>> collapse_file() requires FSes supporting large folio with at least
>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shm=
em.
>>>
>>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>>>
>>> Add a helper function mapping_pmd_folio_support() for FSes supporting=
 large
>>> folio with at least PMD_ORDER.
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>>   include/linux/pagemap.h | 26 ++++++++++++++++++++++++++
>>>   mm/khugepaged.c         | 10 ++++++++--
>>>   2 files changed, 34 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>>> index 1f50991b43e3b..1fed3414fe9b8 100644
>>> --- a/include/linux/pagemap.h
>>> +++ b/include/linux/pagemap.h
>>> @@ -513,6 +513,32 @@ static inline bool mapping_large_folio_support(c=
onst struct address_space *mappi
>>>   	return mapping_max_folio_order(mapping) > 0;
>>>   }
>>>
>>> +/**
>>> + * mapping_pmd_folio_support() - Check if a mapping support PMD-size=
d folio
>>> + * @mapping: The address_space
>>> + *
>>> + * Some file supports large folio but does not support as large as P=
MD order.
>>> + * If a PMD-sized pagecache folio is attempted to be created on a fi=
lesystem,
>>> + * this check needs to be performed first.
>>> + *
>>> + * Return: true - PMD-sized folio is supported, false - PMD-sized fo=
lio is not
>>> + * supported.
>>> + */
>>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>> +static inline bool mapping_pmd_folio_support(const struct address_sp=
ace *mapping)
>>> +{
>>> +	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
>>> +	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
>>> +
>>> +	return mapping_max_folio_order(mapping) >=3D PMD_ORDER;
>>
>> Probably a stupid question, but I dont know FS thats well.
>>
>> Here we are checking that the max allowed folio order is greater than
>> (or eq) to the PMD_ORDER. Yet the function asks if PMD specifically is=

>> supported. In the future could we have some FS that does not support P=
MD
>> orders, but does support larger orders (eg. PUD)?
>
> Good point.
>
> IIUC, mapping_max_folio_order() means "maximum supported order" not
> "the only supported order", so mapping_pmd_folio_support() just means
> "PMD order is within the supported range".
>
> Also, mapping_set_large_folios() sets the range to:
>
> mapping_set_folio_order_range(mapping, 0, MAX_PAGECACHE_ORDER);
>
> and __filemap_get_folio_mpol() treats max as a cap, then falls back dow=
n
> towards min.
>
> That said, if we want the helper name to mean "PMD order specifically i=
s
> supported", the more future-proof test would be:
>
> mapping_min_folio_order(mapping) <=3D PMD_ORDER &&
> mapping_max_folio_order(mapping) >=3D PMD_ORDER
>
> Thoughs?

Thank both for raising this up. I agree just <=3D PMD_ORDER might not cov=
er
the exact requirement here. Let me send a fixup.


Best Regards,
Yan, Zi
