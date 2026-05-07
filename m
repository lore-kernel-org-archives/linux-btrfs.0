Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010028.outbound.protection.outlook.com [52.101.61.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCC3330B32;
	Thu,  7 May 2026 06:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778134120; cv=fail; b=Cp4qiTqtCOKQyv8WnzU/AsizddQVL9xppcPFZUKfncTIZDfpWrn7UUERH67QhAOsFbgff0dXR9f9+lcZHC45jMJDqn+BH/Rgaqjjs98k9lhtZSbiA/+jSZJuQVkqw3WGAeUOIZSnyPZoDtYs48SvF2+u3wYVJIERnEIkOJPwfFg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778134120; c=relaxed/simple;
	bh=xya8Ug6pNnJgFDKiZU7c0tnzEyMknneRONeuvT+yZIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gI6fk1uyqA53DeAat+yNg/wtR5aJHD7v31qmx3YcC+p8Sbm8IcyFEE36qfPVYF9bmbvLGKsMFScJ5EG+tS9kFMvkUMmDk0cFFkcknHHIAvX4vtBr1KAeV2VlLjUEZJ5GLnhP5lxVj0oLnsunAQisw6jQDmpGE76A5+1PISUJ8Tw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p5DwQnk0; arc=fail smtp.client-ip=52.101.61.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p5DwQnk0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ydqcx+bsEsWdT1+S2LUmGvCAv+xZn9I3UizuXCAGgKEz7yw5wQMrCoaCHbCPYFRxMwx4cR3kN6GH/QMPtwYB0WPFmE/PVVVuRvTsXLUlExGoI0RJ7FJF9wnJu5XbWCysq/0Z2xvRFoBAuH0MkjwLEwH3feNw/RSL72aT+ECHykXxT9jtV7VfJPBGiqulpugo+foTb2fF4PDl7E+ydjz0VvxPM/LTPgAsi6LAbQdFrIrClJ79wWuXfLxjhjwwK/FKCvVou1Pe/FNMD4kIGrpSRVtBAlZjLApDX8J2ojtXJJuShAx+X2aD1Y+voi1gGB0dydn+m37d/MKIs/YN+ZtuBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=meaPf7MMjCcp3ad7LEkKaINeJyK/fHinF5fTV1JSDis=;
 b=IAhNDH29RY5/HMHWlTs6UPjzmDgB2sl8mGITpB5b85sLxKH3yHSsTDL1eapFf/tT6bWvZr/VSys9ZSr5lwwIYCt8xfjzNOU/xFtzI7ObYDdz7ozFtlroY5NlwmVPHeek23ZifcOrrhh2x52V35Lkryxs4GpKQGjTG9sOwK4D79gHd5WhbwkVWcfMjxbnDdCWlt7JfTqsNlsqtJgrqAYp45pRYR/iJsg6Q6zHP6JLw+HcOh0GnCsj02irnz+FyzKLSTtQOyphdj0oHGQUFdqBR55aydLm2mcCsKB4kqtnz1W6Yf4c3d80UTI5DgDLWPR1/twjkdog2xsVTzviqOTomA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=meaPf7MMjCcp3ad7LEkKaINeJyK/fHinF5fTV1JSDis=;
 b=p5DwQnk0k56TncEwHQUbVyiVqcQXNI+/F257C7NmiAtipBcrY7KKJFsdKVoqXMS4vTgTnuA8jMeL3nRZa9wtlrjFAlavT2dhmyKXMosajYAU+whtPXjEoxgtYFUhzeEAHFaUPE+M8GNnOjVskg7afEVTeDMJgDfxNzGBMErIC5RY87bYdmBKe8XkQ0BZETRNkpTdQ/yiSGsGRQEVDQeDhxIMPwYUhJwtvcWzrDUCG78FAOX2tauqY+eNK3R+twl3GEqnNZwidAIzpZJ6IwQUOabq57ni1aDiuGZGSdhe7s4G5y1Lw0PC/nrGFHZrsNbmu3t7A/UV7KysbuIPG/sC4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by BY5PR12MB4177.namprd12.prod.outlook.com (2603:10b6:a03:201::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Thu, 7 May
 2026 06:08:34 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 06:08:33 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>,
 Lance Yang <lance.yang@linux.dev>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>, Song Liu <songliubraving@fb.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 01/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Thu, 07 May 2026 14:08:17 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <CCD6A5D1-AF64-4AC7-A717-E497AD2AF15B@nvidia.com>
In-Reply-To: <20260429152924.727124-2-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429152924.727124-2-ziy@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: CH2PR18CA0044.namprd18.prod.outlook.com
 (2603:10b6:610:55::24) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|BY5PR12MB4177:EE_
X-MS-Office365-Filtering-Correlation-Id: cb63ad7f-2007-4496-f9c8-08deabff11de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|10070799003|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0pYygDThwwbfN5qWrK815u9n9tIn3LU8W6zlfGR6ACpXO0FmjIzj0oWetWHtpvlE96DCaIAcQU4KEQneU0iUzv3Evnh8SVTo5y6c+cvN1R/ZNdgtx75xB5+tQljGWV4MqtuptAlqDoqdoXMu5lIYrk1aArTqbuuvWG6WvgNuKzX0ARJ5DtLMzyyK6Dyi8FuExoD8w2IVZVianS3v0NxaEarNwnV91d2bvon9oj0/pi1dNXin9dspa1F/pbZgHPOPuovwDpmcRo8pj/Re7mG/iwJPSZ0LILGQYqwzXvbup/Lm58xXT2v7Nnxm2oFcsBdq4p8cU8g1t7v3LgKQ6H67RReDNteqIO/WL77q2aZ2fFCPFPgF1ODb4KbfaPpf0X/9rrfgKPftvxujcJbNS33yHPA/GeqXcmVY0qPiOBma5sON84up2dXp5HFF7j4hEDKvrvoqLfu4F2atCnptUrVVfHqsS3P+2CKgJ9iKy6qczUDBf23eSIfa6XUGQpnnIDNQt+D8wnCnmSAQkEK5xnyXjC3SzB3du9BJVV4pNS3nsXRGsDcNg7QJ9Dooa+DvCwy1YdEagdwQ6mWLuFNXeMq4IhjLe9bmIhFh7jv2hXhq0gP0CIbNppcSF9CUJczwJDMmtCjfuHKAYuKoVzXojWjy9LYWj5sTnrDjk2g2k6l/uHGnjJxgthk7NqgfKSO0XrGce2Uw8/Dwk+rbfUNW6kb0kA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iCsgPle7ljg7y/bnwzUQb4eVGIXJIsRbUqZ+s58diRDJIMLqgMeDxylS/ETq?=
 =?us-ascii?Q?I7I9cVgKw2KUd+SOJGwIMJDc3qp7KmKj4opJUwjGHNEO2uYlHp1H7t0dcW3d?=
 =?us-ascii?Q?nFdT1i586QbJ9pk5/MWfAbLeo0vBHdGkoHOUYICSVcuUCjVSBfch4mnFaWG6?=
 =?us-ascii?Q?pAyF8LhS4xY5xHrcX5RKlW8rEid0bu2L5ywbwq+gWyNyf/k6bfbO3SXvlL6g?=
 =?us-ascii?Q?RHH3q4lj3px/1zlTJeBX93/XrkQp2h/q1E+l34MF44sNyV3Kx7uoIZtFAT58?=
 =?us-ascii?Q?Xfn3Ds/6sIf5l0TGP+ScpxAhrv65wNg53h/fI41w6doBfhlAZxB8/VdBfOB/?=
 =?us-ascii?Q?OFuxq5sUhjPiUY0rgGqunr7hsaqtzlfskIsZ09PUlGYSK/e8xgyWSLkKflRn?=
 =?us-ascii?Q?GMIFeEJcR1umCCdKFTV9MPtu4Nm5LtKZhTWimi5pOgvWGVff6Ceiv7gkN9Sg?=
 =?us-ascii?Q?xm0F0Vyd24IvOvG1nNeo8qk0q+pokyZT6SVGlKNNFIGvmCbGXmAxp2Q5kZXI?=
 =?us-ascii?Q?twCyXvyUVBT5to7uGemiOyJ/FOVjAtuKhmudFqYHcolHLRBcg5kkbwVlwC8k?=
 =?us-ascii?Q?JtZlbP8/fY7DW4b/2IiFJclLufWPbPu0nSCIQOSRGzBL6SgsUo6h135WappR?=
 =?us-ascii?Q?XNTUiCXh9yO5T+xdKN9tdW/qrv+wWs2PmZWqVElr5b49743A7rqHWO+zsCMm?=
 =?us-ascii?Q?DeBSLM/PB8G+4uX9l0UXLcpX0ijkiMY1WzrLnHxjxunHXZIriPB2MBZj2Vfs?=
 =?us-ascii?Q?CTsYYD8kOP1SafXRGBEi3U6krUhOBEwjp59dj/L1u6r5Z7bI00jQrHglumO7?=
 =?us-ascii?Q?awb77ratFQfCcBFmhsmugkDNTmf8+XRIPvs3SZsjTT98O6kCfLsQT2fFYOoT?=
 =?us-ascii?Q?FePIbh+yBWfrvX3qsW7Vj2JqGPc08k2wAvwXytFcnmwYMYch9qbfAQ9DriqA?=
 =?us-ascii?Q?Vb5QCdLpiVUpTtJpQiaTGmNvq8NIC0Zv0W8NxAlQD1bUwkdUGBLRjiV2he9C?=
 =?us-ascii?Q?oj1XSTOfMSq4hdqLJ88GxagI2VLGJsky3+BgarmTPMaaFuFt6d0iYpeLOq4r?=
 =?us-ascii?Q?rGsc5CxCi4qGMdQI3ltcwL00LSm3zFBY8BBsSRxVIOHFRJ4AHtZIrNOQcFfU?=
 =?us-ascii?Q?b+SKUQ0N/M+a4mVm/331W9OiNmfPOukIUy+uTv2nmroBnMwwxLcgwl8ySzyr?=
 =?us-ascii?Q?igu/stRfE/6JkYpcT2c7QN88sTZlvl40iHWXtRTX5qQwgj3DZt9ILFPOYVwl?=
 =?us-ascii?Q?Pk9bLYxhLR1qaxUH3oqG1L4etLssNlV6/YGFIqOsFWtKGEbHW7E3o7Nd5hvO?=
 =?us-ascii?Q?4M2VcNJmn1LaXe1pR9JlLzXpFTsgpeieGhzrIceSfs1CkbPs5PxcHUUsDu8U?=
 =?us-ascii?Q?xBdoIs1seNICQ3VsLyF9RTpB8XWkqCvW5N3l4UoiqakAR27tdLI/iHWnUWHD?=
 =?us-ascii?Q?TVfHCZwliHGvLrsQaeu1yiRbrSMsrmCZ5e9IRkhJj/SamdHsY32KVwRS5ePS?=
 =?us-ascii?Q?9N/r6wekfWjl7+CePhHaV920WyDs62Lm9zw/pyVSmmal+kUefrWwYnllvEk2?=
 =?us-ascii?Q?vaORoUMnWW5UHano5KYpUeaeFMqTETMlflzY+n+xBZ5QUlmRf6r84W7BUypO?=
 =?us-ascii?Q?paApA5su86nZlQgYfRwb9ZYH+kMZduBYbnZzCuoz2fbIZ5w8g6Z9lfez8OaX?=
 =?us-ascii?Q?MQmEpd0ck+YD5o+EuGvNV1Zb6KlwwTRJ0nNF1YLbvNAYM+TrRsmHcxATMI8H?=
 =?us-ascii?Q?//FSxl8jSI2rJ5mBO3nnH+rSlKBUdi5dw8KghUhzBZsmIMP46mxq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb63ad7f-2007-4496-f9c8-08deabff11de
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 06:08:33.8800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V5H3Ln20T8ZXQNszK7IqDbzSbZWxiwADKlWUk/X0ueNzcR/7IcHpSgYeD0GlAcVl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4177

On 29 Apr 2026, at 23:29, Zi Yan wrote:

> collapse_file() requires FSes supporting large folio with at least
> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem=
=2E
>
> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>
> Add a helper function mapping_pmd_folio_support() for FSes supporting l=
arge
> folio with at least PMD_ORDER.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  include/linux/pagemap.h | 26 ++++++++++++++++++++++++++
>  mm/khugepaged.c         | 10 ++++++++--
>  2 files changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 1f50991b43e3b..1fed3414fe9b8 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -513,6 +513,32 @@ static inline bool mapping_large_folio_support(con=
st struct address_space *mappi
>  	return mapping_max_folio_order(mapping) > 0;
>  }
>
> +/**
> + * mapping_pmd_folio_support() - Check if a mapping support PMD-sized =
folio
> + * @mapping: The address_space
> + *
> + * Some file supports large folio but does not support as large as PMD=
 order.
> + * If a PMD-sized pagecache folio is attempted to be created on a file=
system,
> + * this check needs to be performed first.
> + *
> + * Return: true - PMD-sized folio is supported, false - PMD-sized foli=
o is not
> + * supported.
> + */
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +static inline bool mapping_pmd_folio_support(const struct address_spac=
e *mapping)
> +{
> +	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
> +	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
> +
> +	return mapping_max_folio_order(mapping) >=3D PMD_ORDER;

Hi Andrew,

Can you help apply the fixup below? It addresses the concern raised by
Nico and Lance[1]. Thanks.

[1] https://lore.kernel.org/all/aa778cfc-b7f8-4100-89bb-d2b2ef8e1138@redh=
at.com/

=46rom 9c1749df6516c06b1628ac7804bc7a6ab5709f37 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 7 May 2026 02:02:28 -0400
Subject: [PATCH] fix mapping_pmd_folio_support() to represent its exact
 meaning

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/pagemap.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index c6a4ecd3d6ed1..52895896f3357 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -530,7 +530,8 @@ static inline bool mapping_pmd_folio_support(const st=
ruct address_space *mapping
 	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
 	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);

-	return mapping_max_folio_order(mapping) >=3D PMD_ORDER;
+	return mapping_min_folio_order(mapping) <=3D PMD_ORDER &&
+	       mapping_max_folio_order(mapping) >=3D PMD_ORDER
 }
 #else
 static inline bool mapping_pmd_folio_support(const struct address_space =
*mapping)
-- =

2.53.0


Best Regards,
Yan, Zi
