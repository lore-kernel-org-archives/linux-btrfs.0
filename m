Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013061.outbound.protection.outlook.com [40.93.201.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62EF33BBCB;
	Mon, 23 Mar 2026 19:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774292827; cv=fail; b=G2OJ0om1uNtAZ3cnGXw5WkbQkjLZaoVkhE7Gq0DJPgIAkRCWh6MvAz0nbt5KqGIxXM1tjNGwBYEYfXlNOgz5Gm33eGFwSmyAKVGUMHE/rgRFhm127K68Wfz3gdaYtS10EDbDiP6ym+ef/fozUdh8RUnIANkV84NRZB9RF+7id8Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774292827; c=relaxed/simple;
	bh=tq5FqUm33eEFRQuVGeLBa0Lix1W8TbXaRcJT9+JDm2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MvEdugED2C81w6t5tExgWs9fRsPN9B/kO32qpJNJCa1tfPn8oGhQF7ODULZKLEEnxXXm+Kd8ska8BrS772tIrnKXKTY5tZ2j/FCkgrB9bQs4TdYvFniT2spq17lbn5POFiQn1shGz9CHK8bsJqKWSRbKVkSkF/JL5DrJyJ2TyKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LDJWCYSj; arc=fail smtp.client-ip=40.93.201.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LDJWCYSj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HKBemAj+bCeG/AXWdsImyyrQKzgs3uySh0MhWCFWa41U2yB/rMTqf/ahwpl5T7fVgvUzfKL0cWFejiR7JH+GMV8G9MIytsJer8p+L7Noe/lSKtQmSXdhTsHpI42zvZgEIZQYMIphgFBwEMleX0Lb0Fcpe1gQZmmcLQi6rURapVb0D3taoOLxN+PzW9GJNUqZLoWei1OHiYtuSxGn5ZtZ9+vKEcs9fZ+E1YTgSAIwfMOf0GjR1ziHmrytwECFCpnp1EGjKrVILNU3jlOT3NC7tzHA4OZhSbSRNZJB8W9v8+HfccxqK1z1lGutyyWWqmwUlOfGJvvzY/HY7JlzYp/ifQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fwYUfDFv5xgqECm2JXLwGqY5p8gmmW4sRFsTjJxAK78=;
 b=Ly9wXSWN3aHklbsHt8NJkgEj1X3C9VfEGtroiLwZuafQauIH24JtRIioJ05dIzQYQ70aFGNwuvxK/zKH1Spvv4Lysgvtowin+HVxd1crd4ywlptZ2n2HAZksDNC/I0w6Rkxwu9hRYXwWLN/T6jkHtEPMB2D3fMTs4KbggtGgxtY2BgSICiTORrYtfWorv8TEfXGs/KYgMIo8530CfKap2q2A05IHj/IhRBVBNB85u7l01a5HqORAycnPwVIxZU+HNjy0jXbDklqQZGVIvBf65cSZnxFi5ML3NubIrviryuW7OvEDOjOYzX0wORBNCX+fZ0k1RzgvfWss/AU2HnOVug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwYUfDFv5xgqECm2JXLwGqY5p8gmmW4sRFsTjJxAK78=;
 b=LDJWCYSjXTukADWJQhmYks2bJUuX2NSIeRNQWzXdiPTLVCLAOb953iacG3DkADRSYrDIwvT52dCxNSkxqs3FvOvJTEOK6YKnnUr2VgDRVJob8BQvXbOSLJlrWDVDXfXMr3IMpZuExhVMOy36bIRs8KxpNZUC/VkKjJ7aXgUZgosGv3msHPCZaa2zm1tFesI8rLPhU3wj2vodvymloSIAY9hMpGEDOwQwlUw313OF+0ciwkzB6KRLthNkWfWbrwtCdrV818pQqQK57Sk4MQdDZu0ATEkaOiAsScRpZKYBsaOZm8lzJmzBPLPVl628bi5dN6zE2iNE/kNtq9w32DilAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 19:06:57 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:06:57 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
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
Subject: [RFC PATCH 06/11] mm/truncate: use folio_split() in truncate_inode_partial_folio()
Date: Mon, 23 Mar 2026 15:06:39 -0400
Message-ID: <20260323190644.1714379-7-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323190644.1714379-1-ziy@nvidia.com>
References: <20260323190644.1714379-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0019.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d6a0a9d-582d-4aab-3484-08de890f5a72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	RcPh1Yz4DXNnziOJ8JeVbtoheSRMQCR5MfoV7R3zsP5pSaiwLgQ9silntAqrTBaJbeEqjCyt/bNKnzFvs0NcJ8DxaZfRzWLf4AFrXTq8/FRoLe4V7PxevBFkxmbwSzlnMGSzatLyteOTmCf8qGnpuwSlUa1sTapoJoz7CS0Cb5i+54lxoWPE9Bu7X56LGt5WnhUITEAOxWM/TI8w9jo1bI2kJ01I0kphm9yrHgGg43HX2KQ1oY63+WLO/xqr5SSZMSfvBtYmFfcD3O4lTEuI6RRgABP954pU0qWXPAWXa5TWdpcPKcdoz44RFZTHOn+UGJuzwEl+7HVDLif8HfE3fnlT+zea4WX1ErGf6WP8AFBICkVJRNMRUOE3h9p50O4XAzfB4qhOyEQK6OnAddg9OckRSSH2D3DBibPxWfKlQrunkhYsYT2C7CI6rcCZmK2wPqP/04IGnOpylQV3SZStvpEvptkjbUDhuXH0CxCH4sBQIgJ9dD+RBR7iB/1mmIktc8SP/KWHwGRXPBAGKmskgMq26rrlfvc7ZWRf7lksPk1CcEA0ToXREms1tc+AUr+Tv5qqaOdNBF/Yn+xaeYf1Mk6rXYrQaT7WUe1Cx4feLCqxTiV792TPtLWTNFPBvMpmNaKilyF4SpZppnNSnL14/HvbgCGQiRyGldLfvH6MfqIatwtnnCSukNeiik7HOhEYMDSkri+nlUS70gCcZoAztwhXIVLzy6K7NdTXZkdOqm8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2YbIPDzkm/yLs6RPhe7CN7bxKRHqn57HtdqqQ2O76uOE1yPVCcENaStzrM4K?=
 =?us-ascii?Q?NGzJ8mo2H4ekcBapxL1mPGJziyinCyVJ8EoEj6jom77Q69hLu6PxcTDU6inC?=
 =?us-ascii?Q?z5uZ5S7PXjbDntWpsswzrku0pcy0wI68g2N7fMGTy5wjxVpvjOYK798G9M9w?=
 =?us-ascii?Q?1ispwCAUStw7zRxZJW9jzDmm0E3CW2uKzefZ7Y6A2hY7AG9sUCPXsXRL5ePL?=
 =?us-ascii?Q?JtRw3TTolVV/DVtE3JQHf6ClUKUKbpO6Rggq2HCpNVWRykbvgHYute0zuBiI?=
 =?us-ascii?Q?NnaRtmdM+EeSafv8GxgBYo9Vzwpp1Hv0t1o01R2+JJ6X8Uvf06NTd8Sw3hu6?=
 =?us-ascii?Q?s+wCWXsSevdZ85wAYkLfBzlXhUU4vwBWxgVdQpcRs0OgXk2FZZas4nya1+Nn?=
 =?us-ascii?Q?kv8b+Wuf+SoCqVzw/dCQR2CzZESliviTJo61232aKAyjbTMfVpwkIONPx8Ba?=
 =?us-ascii?Q?IFOKWehIeYACT6GT9LCGRq731cIdtsdwpHw8oIpskwPBPVrc/Ew/je3H2qSr?=
 =?us-ascii?Q?ySWQUpzUvYjtlDYmodLwwE1SKJj1NX4BlvsudHi0vHR5svVqjABGdRcJ6nZ5?=
 =?us-ascii?Q?ibtQ0PbO9W6Jzbj4krmbMejgtFHrpmq+pi7K2kku6P/to0h8D8b/3AlBZBm8?=
 =?us-ascii?Q?2HxrzgYIka72OKmpo8Y8QU4b0SpgtTTgLUqmgil20M819tOKjVK8Lljq6HYQ?=
 =?us-ascii?Q?tliYodw4X/LWvlHmbTYynyoDxKmSCnEWp6ROpuZNoC65O26mndWQ21+rT2Kb?=
 =?us-ascii?Q?UVDp0sHk+DdJ0rYThpvsi4f3zzk29kQRhO4fv1nPlTErOp82rXl0Zcz77cE2?=
 =?us-ascii?Q?DzpcHttx6SagebtDQ5GU+wscLuic1pwFvr/pt2DuonSaT4tWl0/UeiCYI3an?=
 =?us-ascii?Q?VhUQ3f5ANIi47oZHH/7fgq+h7jQSW+Bhrm1ZKkJrDd4NfPlMJGYBN5JqN3SP?=
 =?us-ascii?Q?9rgsjxtQwQIgMsB1iOOFlC7myl4L6D1bvCQVLjDTeHMomTNkEFYf9OfBoLel?=
 =?us-ascii?Q?zVvNWdQN+vznpbFONNTxP1XV8CmjKFAAr5Lm2kxvF2rFo+1HBeD6IAPIAoc1?=
 =?us-ascii?Q?ZFyhOO0BJICevhRR5T8HlM20NGYDGx8BqbvwwRsp+vDgJhnGe7FSqvic0Biw?=
 =?us-ascii?Q?HTWIKVO1okicEhKr41RMkz9+v3GEFzYHPqiUaa2mLHLSzN11bxmcsKVDf0/I?=
 =?us-ascii?Q?m3RJ8u87JRFhRs5gOKXer0nx+XzsrCTgkBXWfAqmwKxvq0Tz5WPYWEBzksm3?=
 =?us-ascii?Q?Bk7at04WBLOSuvBX5qvXH5F2iQmicHU4Ohq6XkQvL8BgbPGKUcplTRYpfNYp?=
 =?us-ascii?Q?17mQStsQeRCEuBgeXdG6Sez/VHBA1P5rzJSvX4Bo4/Dl3bnG6ix7Lh89BmLb?=
 =?us-ascii?Q?qfDVKsIKE/NiI6i4lVDEmmFpA4mPawTjN0sJPkGQPQvaLj/qsN/f40TY7WOU?=
 =?us-ascii?Q?ync007FWeEHOJZzUYeGem8p3dmoK7fTlY8S7DbGsTtKjK1PyMGo6WAs7jvQp?=
 =?us-ascii?Q?8ZjMSdlKHbmMI5MkJ6YJ4Fc0Fp14ZdZ/8uEAQoMIP+J+ve7GJQYgH+vVpCR4?=
 =?us-ascii?Q?t/+y2zW2+FW2h664Fel/G0muHyQp/KP2zumpgSa1k0mzyXtzKsqbR5zwlUaE?=
 =?us-ascii?Q?TxL/7uPaXczZd0k68nY+5k59TRhnqXIi81D7nfiYEstuHQNMSpItOkonLiNb?=
 =?us-ascii?Q?pJ+5mgYrEj6ovCNWG9mhczv6qPnriuhFdn72DByN2c05yjCW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6a0a9d-582d-4aab-3484-08de890f5a72
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:06:57.0031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +RRJquhg9Np/erhHs53HUPq951/3FqBPUofoq0I3j1mJ6iP37H7M/rmiBGKzD3Bs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813

After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio or
not. folio_split() can be used on a FS with large folio support without
worrying about getting a THP on a FS without large folio support.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 28 ----------------------------
 mm/truncate.c           |  8 ++++----
 2 files changed, 4 insertions(+), 32 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 1258fa37e85b..77c8f73f8839 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -389,27 +389,6 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
 	return split_huge_page_to_list_to_order(page, NULL, new_order);
 }
 
-/**
- * try_folio_split_to_order() - try to split a @folio at @page to @new_order
- * using non uniform split.
- * @folio: folio to be split
- * @page: split to @new_order at the given page
- * @new_order: the target split order
- *
- * Try to split a @folio at @page using non uniform split to @new_order, if
- * non uniform split is not supported, fall back to uniform split. After-split
- * folios are put back to LRU list. Use min_order_for_split() to get the lower
- * bound of @new_order.
- *
- * Return: 0 - split is successful, otherwise split failed.
- */
-static inline int try_folio_split_to_order(struct folio *folio,
-		struct page *page, unsigned int new_order)
-{
-	if (folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM))
-		return split_huge_page_to_order(&folio->page, new_order);
-	return folio_split(folio, new_order, page, NULL);
-}
 static inline int split_huge_page(struct page *page)
 {
 	return split_huge_page_to_list_to_order(page, NULL, 0);
@@ -641,13 +620,6 @@ static inline int split_folio_to_list(struct folio *folio, struct list_head *lis
 	return -EINVAL;
 }
 
-static inline int try_folio_split_to_order(struct folio *folio,
-		struct page *page, unsigned int new_order)
-{
-	VM_WARN_ON_ONCE_FOLIO(1, folio);
-	return -EINVAL;
-}
-
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
diff --git a/mm/truncate.c b/mm/truncate.c
index 2931d66c16d0..6973b05ec4b8 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -177,7 +177,7 @@ int truncate_inode_folio(struct address_space *mapping, struct folio *folio)
 	return 0;
 }
 
-static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at,
+static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
 				    unsigned long min_order)
 {
 	enum ttu_flags ttu_flags =
@@ -186,7 +186,7 @@ static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at,
 		TTU_IGNORE_MLOCK;
 	int ret;
 
-	ret = try_folio_split_to_order(folio, split_at, min_order);
+	ret = folio_split(folio, min_order, split_at, NULL);
 
 	/*
 	 * If the split fails, unmap the folio, so it will be refaulted
@@ -252,7 +252,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 
 	min_order = mapping_min_folio_order(folio->mapping);
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
-	if (!try_folio_split_or_unmap(folio, split_at, min_order)) {
+	if (!folio_split_or_unmap(folio, split_at, min_order)) {
 		/*
 		 * try to split at offset + length to make sure folios within
 		 * the range can be dropped, especially to avoid memory waste
@@ -279,7 +279,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		/* make sure folio2 is large and does not change its mapping */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping == folio->mapping)
-			try_folio_split_or_unmap(folio2, split_at2, min_order);
+			folio_split_or_unmap(folio2, split_at2, min_order);
 
 		folio_unlock(folio2);
 out:
-- 
2.43.0

