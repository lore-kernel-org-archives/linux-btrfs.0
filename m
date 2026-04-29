Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013048.outbound.protection.outlook.com [40.93.201.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E08D3815F7;
	Wed, 29 Apr 2026 15:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777477029; cv=fail; b=W89I+NNTBAge5+vjbTzqwynW7CTddZJwCguK/jDeVW4Qp7jq6Webfc+yj+ZiJLZz9GLH72bE0Imf1n29opXqOAZxwSUeJ2VxvEayPaGgxSFB0PsAQo79YQX8LQKdZX/oDY4ti9ELHfHfT+6/rLPc3iodj5Bnsy+T/+qOK59GElY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777477029; c=relaxed/simple;
	bh=ql60HG04lUZwAFl6DU7Qln9zbo5cdo2Kn5NGL5aUwcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KcFNn7J39tvsiI4JmVLjviGIq9nyvg1w+5LnKZukRSMNe5yCXS2SXlrY4ZbVb4IN1Q8CWa8rZTq3/vIkEtHS11D8nxk9v5MnNfKRhsepIkphiyvhafpcRT7Wnxtny83/jAtJqVl1PbVgHc4CWVJhkoEzVwRvdjE1sw7nxX9L9tc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bPHtSm2P; arc=fail smtp.client-ip=40.93.201.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bPHtSm2P"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dlHtOZMEO60YJrbcxVDv8w558FfMITUua+RwkJTWbaaEYDMVvX460rNZ00wy4SFpdJlid0/3eJ6SroCQObHVhdkkyyiM5T0sq+SDEPTpT3m9Vx1z+SiPnlExcLxNg3BDJcpN1agJ7nkhI0W964twf91YOHDZhe9vqoVACaGywBJDKUDYBSAQCXYxgFRHUPNQ78aHihMbyq6SGUEpRH57GB/4ip+79f2jQu0FxKv9wozN1EPayu4IJ39J7DeVKSepRWHjEn86YhMYjYfafQaNQ1eyXDjLc/9FIjFfwMZdEk/IVvqriD9Ome9xuLuhBFTsCyawyaraZF3bC0ejKtB+Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g1D0QTVTZQ6sVZdnGTnaKIJ6POa9dHBG5/8lH2xEKVM=;
 b=HTPckVDUO9hRg9fq/jMMnBFRuvpdMnbPyvL0F4uAEnAq4x3aIwucr/uvMw3a2p9P753PPsXDLj1J/xFamooVovViuNkJPA3NJwqY6Kd2e9oGWGP/K4pW2qiFwpp6kvIa9w5vGIovYWbE6L9VrF59nIZH1uW1V+7kggfuWw46v5oTyCKjQEK6T5kXyVitz0FBG6ujPKz/+7ob/bCke0mY9PfZxdycONFqqbxn1WNsjWNmzfbPefb8Z2APVgYf2u0k2TsKq/w8D79wE+fqpnpxvASHlICd2bo6uU0HPaQs0nCW49ex9/fFyp/kCj5dKGc5sy+7bN5U9BTZ1qAZ749hig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1D0QTVTZQ6sVZdnGTnaKIJ6POa9dHBG5/8lH2xEKVM=;
 b=bPHtSm2PK3xQgb13Aj1yS+q6J3XJxHA8s2LR4Navh1QOap4/HVRT1KvRD/oTWXYioeT4QTekuFI1yqyN7lfi4NSK/PPbTuRIRtxDZyXiKkyXOL3G4Djb25kdogZQq404IYS2oyO1+5+z5rnHUppTuRuaf5Y7HqmKtkNBgh6H6kqLpyKuIvgOEesameVV2grdyZy1UfJ0eqk9+HCtsucQOVOlne8DJiQ0uk1TYzGc48hYlcr3ci1O39rqRo9QMLxKpZ4oitPH2hoEXUt7WSqa4QjmzH2JsYXxCHoPYLGMDsPPa02QOMCVBkaxmOWhDIhabCEcIENYm2XoKc5OpaHtzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8881.namprd12.prod.outlook.com (2603:10b6:a03:546::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Wed, 29 Apr
 2026 15:36:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:36:50 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v5 08/14] mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
Date: Wed, 29 Apr 2026 11:35:31 -0400
Message-ID: <20260429153538.727855-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0020.namprd21.prod.outlook.com
 (2603:10b6:5:174::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8881:EE_
X-MS-Office365-Filtering-Correlation-Id: a7d998c9-b862-4be6-e3da-08dea6052058
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qDyqZnmT4QZgltZ+/RAMA61QbJOhzB92BuFJ+4QyKJzouHstYqCPpW98GbH31ZEUM0nOtCSCKQwvk/ZZBXKYPjBxbSLYasW+cag0vxjtX0RuLBRaCjZTkxduaLDn1c4miDTBMPIYD13Flbgq09uPRCTKThkjatu3AKudaa9SAoAFOR4tiOdoHbW8AJmWa2cNXamJYME36CxsYUhIvsV3WnpZcO76+ZTkIJiMnd9h9Iij3l7hAuw25b6u01aiGrNn2e084f6Vn1qluCTWr3X5uUEGm1IzL8PoL15NzbvVBNqc642oRjt69hTN0c7z+SqGUL2LMCtNA0LxN2O+JeBau4vIavuniTLLMayW7/jN7r8AZTmVdPtnU/D9/KI/TfFDfgOdYQZ+WpV2d6iPBKbAfkYvHp3QagFRlBwIV/eTCKJObliaXRfBquXwv0g/8vlr1M8ph+/P8VaJLW1jDAgKyoHCOWWDGQiLXZZ5v7LHIu+UPzYGDZNWkVow9uWF5eEnNwgSg9fX2r5qc4yZ5RELIHd7+eHIe3jzosB8LRPLW5yS2nHqrvSyx8Y95UaTmTIy3a+DKcxAMABzP169JADS+Zo2J8XoyZqZan+Ywcmm8lhiQ4tgxi2oA7WRi3VNqeww08jhAwJailm/yyNbjy0Hlb8Fp/bQKmkq3ShTMlXJblg2j229ndF0onjZ0uI7KdfJbQKU4t7cF8a/X1boxmKNyZfR/44NWsodf0oyOMK6gW8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tquAYUvfAIM9AUEJ65a3dcVFw7OURot5+QdloY5758CTNan2dPQxfhSXb5rX?=
 =?us-ascii?Q?4AkLQx2Gxy0IxJerZUIeiT8v3MHg13TXmcMPeBKp6wn8YlGzvGizkrOuojuC?=
 =?us-ascii?Q?9TOcnfFNLzRFK7fRk9Hg5O2d7KVvxKV/TcumbvnkUkQ6WRq7+TNrd7GI6N05?=
 =?us-ascii?Q?tZxO6zr6VCygDxgvPbSXP/0uJU1kotwESrMVBm3sCde8QMfnrw49XCQV5iK2?=
 =?us-ascii?Q?lzpAagDRK9Gi/JYOByQgUilu7kSpa5gAyPQEvu4U7yg0+HEDp2pVpyLcCeon?=
 =?us-ascii?Q?+/LsIaL575gqBOktM1PB7XNbvlJHYyEMyPrCBPVI1RVEj0FwSQ+/kKSjwvd5?=
 =?us-ascii?Q?AdLfL6KcG8i9TXVZQv9Wd3Ge0xiqKM3hCd4CLCp/W5FPqGVBiOobzSxLnunF?=
 =?us-ascii?Q?tIjK6b3ZgHWmHb4Ebz5doDF/zQGn/jM7oqH/xMc/FTeVCW8SmbXaq0uixrsV?=
 =?us-ascii?Q?WIwWw2s4/AKTJXrgtoEQWngvRYji6KaZhnsprjOX+B8gGr5e8q+ru49w4x4O?=
 =?us-ascii?Q?gnULmGkjMvaSbYOPLogTz5IYkugkyhx3EVYex2Zt2ZjkhtdJzLJm2jlOKSbo?=
 =?us-ascii?Q?O+yDL9dV0TnM/z9L9bd81ylHIhJtxhDS0jnx0ANPOe+L6hqql3I2skzipNkp?=
 =?us-ascii?Q?z2Bada8jRAvw/ieGoVXgVGSpH2+SlACN4VfIWl2/NARmKKb7qMZhqDKPqFMq?=
 =?us-ascii?Q?+Zn43xDcAGH/EP/d9CQIbQG0G9PsS7GOdcT4XoD4QqbK/dyMJYG7uyy/z69o?=
 =?us-ascii?Q?gRClCkPsvmID84msWduFEF4neFQageYVncPiqZZvF2yUGUpYS9yii2lOaJwM?=
 =?us-ascii?Q?74R+1IKsRuq1gOL9skzaSSJM94OOiWu9d3ffC7S1K7Q7RlFrVMw409q7fACx?=
 =?us-ascii?Q?OxTWqjNYDvA51EeREM9Tae+vdfh5hNxhxvDOv1A4saLP0hCxiwX+Rz8+fopN?=
 =?us-ascii?Q?kqBukPHfcmnhFCrWKq/rISZnuyd/vKyMrRVici8vJaTZhYQFL1o2in7M5idI?=
 =?us-ascii?Q?d+N6w1isDSNqhK+JktChePcxB1QFnhY8RTIZaF69SFpH4DxGba9ufdjx5exp?=
 =?us-ascii?Q?8/tHNs99kQ4zDfq5KTKjmgDiQULUGK5DrZ4YwP8ZKNSP0JybX6jbzPmnoQ52?=
 =?us-ascii?Q?jGAj17DDjDrnFn5QzfsDOTUNX1fsyWShFv3ssgPeF2HIPjM18CH8M+Se1aSr?=
 =?us-ascii?Q?NAk/SFicpkP9Lov93L4LAllddD2U1/jUH3ct4Ybh9krGpMyRkTMyWaF8dec7?=
 =?us-ascii?Q?0P0Dywab/X5WboZ3rHCNwHIiufZPBUDP/83sxo0bdBZX0FcyWNVKSRMH0Egj?=
 =?us-ascii?Q?iqd6JmDW03TiS+MYucLdd8z7FVNPG8bQVlfI/dWzTYZozNQprXcOsIYLoEtl?=
 =?us-ascii?Q?ahfs2O6ft2/U8PQPgGXS/+wpANIoJX3Ixb0r/VRCcl89HeuLCWz/iClkGGcr?=
 =?us-ascii?Q?Tz2O1l+QBuDl0op9SWUqADclWXptksziYUwelM7oUakCsLqWCbYeAZ9dejaL?=
 =?us-ascii?Q?y1Y658VBrVg8y6Dem3pbpQNFGt8pgHwxSz2KDGwe8M6e5rNpPuD+JP86JWon?=
 =?us-ascii?Q?8AV6z0NAaGhmmJfaya3mXcDzZRqUBPBa4S56L34XArzVlS3fsgQ667cj39cV?=
 =?us-ascii?Q?12L52TFgdPnKtuy4ZilNhUaZ5bi7zpGl1psIFGdZx6fcGs0gwlzp5qdu4VrX?=
 =?us-ascii?Q?upr044H8Eo2pPxGpZ2SjWQL9rVVWwT+X8KA8x4VzihQZHL5Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d998c9-b862-4be6-e3da-08dea6052058
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:36:48.1788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LPBWPyLjXgGrvOQ3uI7uVok9P/M1wXAIJzcFD68gj5UdUZq3b26hKY9VDturKE2i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8881

Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created by
a FS without large folio support. The check is no longer needed.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/huge_memory.c | 30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 884e8b5811569..9b3abb98a7e51 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3846,33 +3846,9 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	if (!folio->mapping && !folio_test_anon(folio))
 		return -EBUSY;
 
-	if (folio_test_anon(folio)) {
-		/* order-1 is not supported for anonymous THP. */
-		if (new_order == 1)
-			return -EINVAL;
-	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-		    !mapping_large_folio_support(folio->mapping)) {
-			/*
-			 * We can always split a folio down to a single page
-			 * (new_order == 0) uniformly.
-			 *
-			 * For any other scenario
-			 *   a) uniform split targeting a large folio
-			 *      (new_order > 0)
-			 *   b) any non-uniform split
-			 * we must confirm that the file system supports large
-			 * folios.
-			 *
-			 * Note that we might still have THPs in such
-			 * mappings, which is created from khugepaged when
-			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
-			 * case, the mapping does not actually support large
-			 * folios properly.
-			 */
-			return -EINVAL;
-		}
-	}
+	/* order-1 is not supported for anonymous THP. */
+	if (folio_test_anon(folio) && new_order == 1)
+		return -EINVAL;
 
 	/*
 	 * swapcache folio could only be split to order 0
-- 
2.53.0

