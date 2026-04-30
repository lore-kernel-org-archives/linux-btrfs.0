Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010029.outbound.protection.outlook.com [52.101.56.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0AD27F010;
	Thu, 30 Apr 2026 14:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777559885; cv=fail; b=tBqiJEAS/sbUbTUqKrcDcpn9Eyw8Iw7RuWwsbPICVJ4TtyAdtwpZ3Gg56/fqPgVT5EeHJcd8szBDtdf8vU6eQLQgxAl5MUzSGSsUfHl0AUr+gzrLjCSFkz2SgH+qeUE6IDD6bRWcZPc5rJ2O8IUJhN8eyVS3V2DuvbmIzACw/KU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777559885; c=relaxed/simple;
	bh=sAkUut9ti3zk+5gM6Q6i92Ltvafe6xBgQbI6lakJ33w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=he/NTNmOH6sRaflRnBs4mcwQEdoTAx/tft1r8oNdrgTm+PGpW+3dK9hFpf6SaqLOrQ5PCxxU6tTgs2qvKEnDjvYkcmhLSUusOhFi5fbLABIvHw6wz7/lFjFCOnDdYuvHITQ7pEDHKitLtcPG9BmdffaydQbNRvE7wXMs9YmcFsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tTdu6xXH; arc=fail smtp.client-ip=52.101.56.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tTdu6xXH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yg2Sr8qmR7INuNUgd1vhzwahlUFF0HU58BaotvQYCNtS0uM15FBal3mqtVYzvkNTjx5tLEBoWaAb3ZUlKAvOYHaAqd4TCF3z3CCPdk5oVj85M2StAwt4O/9YBHl5O7aL1MWhnqWA3jonEI2v8kuoUXp12GxM7/1rSMB018WIUXjJg6xXU41wXVcUV5xrspx3WdA2A1P2aXI3fdcbwJeC/26OP6q+gCmP6xWLe6hiPi3XAvF/Y2YoRYGLifhOlmevlhUBE45MfjC9wyDTnsIGar2xufMlmp+ubV9RAqoncRL8vg8rEyhajvRlfHZ+uqfX+mK4fwQhGiFj0U5QMcU95A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=35m+pdl3AkQXKqZj00qBekl9EdjtBkhj8tRzVWShtFY=;
 b=v/gyIitTmlH2W1biLskciBv5Wtym0sJApPF5y6tXkDdLK81a6uQIPO2Q8EkoSXR9lLzl1sGJj8lZYSexKK28tSQM8fmdYmyyA4NeWAriQxXJQADI4xaSrIx5rJrzPZ8D2viCJh5bqdmO/neZ2RORtj6UDlhGQV6f9U0uEjMbGFEwf5h2CY7o5i6lAR7zwMZrr4dIJ0SBHphLXcUgBS4653lKID3DcOEUXI3VKH1ZYCGuUn1zUjJW7y5Re7ifhnYlAG7XT/UhuqSV2+VGXuVqiTHZpqSg5XeHO/lM9iE178L3jwS6015AWVNoF0/kuMUwjFGEAT//YJLHWG9e3L5VfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35m+pdl3AkQXKqZj00qBekl9EdjtBkhj8tRzVWShtFY=;
 b=tTdu6xXHWwTSCOITuhutBsB71RUd9Ea3aft9Fkd/OedE76dONMUx8rcjTj4e8dwtB+W1CljTvXZMd81sFntZOiXZwNjpHSaoV8MN/vBxfBYo3rWEjMp8nih9c7/QFEsTve1gdVElkxREmHy3Twawg4KZrZ6VtUcnSdhkl0hkq/y8lSxA5LraZ/w/0vJeIN/Mpc4utseXvPpBeuS6IJVb4WBmSO4RpzFTktpqip34S4Tz3In30i/8seXNrbDPpjRoA5O8N30pMg99yBXmrhd9a2cZ+19ztinXK937pRqhI8DyHn+jtClsiyg0tuVpgcreb83uyCBkRBB8P/IfbM4CDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB8176.namprd12.prod.outlook.com (2603:10b6:510:290::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Thu, 30 Apr
 2026 14:37:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Thu, 30 Apr 2026
 14:37:56 +0000
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
Subject: Re: [PATCH v5 01/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Thu, 30 Apr 2026 10:37:52 -0400
X-Mailer: MailMate (2.0r6292)
Message-ID: <4C10A739-4931-4922-B2C2-245A610C0120@nvidia.com>
In-Reply-To: <20260429152924.727124-2-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429152924.727124-2-ziy@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9P220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB8176:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e483ade-89d6-4751-29bc-08dea6c6117b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	GH+NFB8Q0t113ErR7tBPi7T4PSXEdJnpkYX3DED1UBSjeZvrTE+qxIctCqI5OqK4twwlP+oxWJZe2V7vO01bS+P/Q15KoVIG5bKQ05VOy4Glvqa5f8vFj7gLLR5zad6/aN7GkuWJD+f+4QC7/odre47ox9sV2s+Ndye3FWGXtdtAUtvZP3Ojn3NmD7+AW+MsrHWvgpy5KRObh490lJIlsBmAHq3jc57O06JXpBx8MxuH2bdZ8HEbjwpsP45++TzJ/gWLvXkY7vt/1vEoBSo7SXtRClT5wCG2/Ab+UuHZmsvDFPp8cwrvOZHrDLOkZmIfVLmMDKkhhh9Boe72crnXqoA2ubg2SmubVvPwynyb3Bm9xI16KWfj1ghxysgktVS+c6PCBI+9lRtyDXvHdiu/MMggLwzMcAIcQtNHl5n7vTHH5j8mdGR4I7EIdchD4kvcnrm1kh3xixknm/NQRFTUiTyFVD6+Z14m5AEERia8kysqY4111iK7PeSH1Hqtc2XSMtJPghoX56HfKEgO/gLKFThL906inY5kmhRCAXshhicdukqAqKwclnfE1azd2i7mnSQvWwBA4x7k3y+dM1SegimWf91NDgkMkYZQvIP2PE8p1UdaeXj/FNncAQdfFXSR/H6UO2uFCazD9T00jwnzTwqwyuDYm+5ISP1ojFm4oIpIBw4C3OkB+u72WnX6XbZHiM4xgHhVgvCTJ7APFSRhJqhcOQz4DLs+bvZKBaRxhMg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+TAXsoU2u3U8CRLk7+B5lcK0qKUcDjCJ2Qvle/wo9VRKmKowgY1ji69LGrrJ?=
 =?us-ascii?Q?q6/GqSodKAkbrS1bizapMGS62yJB6KoTw9xJxxTYIIc7icdT5ztgWmNaEmkM?=
 =?us-ascii?Q?ebM3ihg5IBzFI7mfpoVJunrgdg5EvmX7KWO20z6alHM1q30rT3tErB7413dQ?=
 =?us-ascii?Q?z3iokDXyGLfBUzJRjTHHw2MgD6qGv4Gk+I44bWWAfcXM9AvH1pTcu0T2i8pD?=
 =?us-ascii?Q?Gfl3XaaNEo6RwvgBAKZGFiKuIwxEt8ZpRpFXMTWXj0UNFe1zCM4rPaNsB7zR?=
 =?us-ascii?Q?WQC2rGDDvG/FRpkqcgH/+Sz2W0TFNUImBSl0dOIBhgvTx11hI6jEEuYB5DI7?=
 =?us-ascii?Q?WwiuNAgccmCNgI1a9zGI8xBB9TVqZaaFmpZKymAD142BDbM2zXI8BncXgMIN?=
 =?us-ascii?Q?/ZLOZUqm+kpdyddA5ReNxdQXg4kIOWoqhPy2xi+dyVwJ0X9VpXxEi+7dO6Vb?=
 =?us-ascii?Q?FfZoZ8graoA9KLmU4ZBilP9zeinFORBLHkIH87ERM0M4vadpG/66r8qZX8/I?=
 =?us-ascii?Q?ONlZJarbTUq5Qxy8P2GRKgRgQ72AhcGkO3Az0NEhJbF8Iz9TcerWQSsvx+U4?=
 =?us-ascii?Q?R11dx18YMYF+eTHdPFWfLQpyDJMq8cWrLspNF7+POfiZ6GtbqsxswdwMFWhb?=
 =?us-ascii?Q?CnEhhc0UnCQLgB04x9mhxro1819U1B1SoWCpKkGOStcZpnTPdIrvNXKaxF9k?=
 =?us-ascii?Q?LRGT4sa8w7CVkOTKEIEtQGW/aeyhNNbAHf59nesMfzHVsfPdBW944oko72+r?=
 =?us-ascii?Q?W8j/bhlG36o38xGFYH3bSRq3q48zyoVA/+wdETGUcgajmy1A50RZTDwnGZ8p?=
 =?us-ascii?Q?YICYfrhgp7fJWDTojmKhYeTaQTiTLHhOUbBPv19JVt+cqwcBaeEyvjsqTAL3?=
 =?us-ascii?Q?NA1jVX8mYJgw1p8nUFz6HKPj/gjYtK3K7mHY1aB+mjQxGw9Tf7m9uGMxl7c0?=
 =?us-ascii?Q?UTjlGu7FFoSV0PiOqM4BEmmp8YXlFdXinYqmvM77+eHWngkcAsJZ8mlOu2uR?=
 =?us-ascii?Q?KVUUiI/MfOFvJ5IIOUQAxmUfhfgFuiyljbpNL9WBKvSa3AX5g20LPwXfErKg?=
 =?us-ascii?Q?nJdIACfDV8F1ChmyhSG5W2ftKSMYklbPfsgQwP4VBar/StphBrIRwqqVnvOd?=
 =?us-ascii?Q?zhktZ6sFQ8e9ZxRZfNIFBda8mn7b+++qWYS4LH5pqb6xIiA5RlE4PJDEwL2R?=
 =?us-ascii?Q?2NjZojhWQM50f1IjcgvH45OZ76cKDE57x0rxe+JSgSmYRnJNh9ka9lpth8xm?=
 =?us-ascii?Q?dDj9LUdAhqBi/0hawiP95lendk9EBq2II0dMkRhYY0SXZqPVUSc//aIAxkKx?=
 =?us-ascii?Q?qtt70QD7iCAM9ack9UwKVIQsB07v2QjF444jMPAmil9ljeHLD/mEtLZRYHIv?=
 =?us-ascii?Q?PbHAh/tB4ra9E/lLCHQv+gqJp2jVxzNb3yb6jVNGcZ6dpjq4zvqU5bYoJBKP?=
 =?us-ascii?Q?rUIZ30EM3qNa4tDt6OSzbaI7yDb7Ov506X+zvI9sEi8ZatBEWcr0/DPIU0uz?=
 =?us-ascii?Q?Pu8ZtEbIDI/XDu1RKkKCzYlI2M9GnN2cNX7/Jbpyz4pJiwrGz/8JXUe40wpv?=
 =?us-ascii?Q?dS861G1LT0tLn/L/cZr+riOjq2vDAEHOCGSQeWksfuRMGh9OgnmUOEjmYCLC?=
 =?us-ascii?Q?K26cmQC7zdGTJxC0LGv5BcADGCj8MiP/ICNHbyIfiUf0Ejrqrte/zpFX4q/6?=
 =?us-ascii?Q?q9pjNrPnLkde6lyLAcPO1DdDVTUo7CXW1EkIhmpCuQ7994tm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e483ade-89d6-4751-29bc-08dea6c6117b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 14:37:56.2981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6O2BujI1rIQEfIBlugSnfP1Yc8LV7Icpt6LwjZTc2NXWDep/NHcfxBIpF+D9x2nR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8176

On 29 Apr 2026, at 11:29, Zi Yan wrote:

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
> +}
> +#else
> +static inline bool mapping_pmd_folio_support(const struct address_spac=
e *mapping)
> +{
> +	return false;
> +}
> +#endif
> +
>  /* Return the maximum folio size for this pagecache mapping, in bytes.=
 */
>  static inline size_t mapping_max_folio_size(const struct address_space=
 *mapping)
>  {
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index e112525c4aa9c..6808f2b48d864 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2235,8 +2235,14 @@ static enum scan_result collapse_file(struct mm_=
struct *mm, unsigned long addr,
>  	int nr_none =3D 0;
>  	bool is_shmem =3D shmem_file(file);
>
> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> +	/*
> +	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
> +	 *
> +	 * TODO: once shmem always calls mapping_set_large_folios() on its
> +	 * mapping, the shmem check can be removed.
> +	 */
> +	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));

sashiko asked:
Is it possible for userspace to intentionally trigger this warning via
madvise(MADV_COLLAPSE) on an unsupported read-only file? Although in
a later commit, modified file_thp_enabled() will prevent this.

Answer:
It is possible when CONFIG_READ_ONLY_THP_FOR_FS is enabled, but it is
unlikely a kernel will be shipped at this exact commit.


> +	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
>
>  	result =3D alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
>  	if (result !=3D SCAN_SUCCEED)
> -- =

> 2.53.0


Best Regards,
Yan, Zi
