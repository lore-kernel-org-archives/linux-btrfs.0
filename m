Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012015.outbound.protection.outlook.com [52.101.48.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD592E718B;
	Sun, 17 May 2026 13:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779026123; cv=fail; b=LJHtM4av9GMNdJBZp7KnzJwuQFRvfVLt+SnGUcCW6X7ihc+P/6yk9hMTqTSa/DJZ4OW0IkK2ywZfh+D2qWYpOjl7lHKH0sej5VXhC+fiGHTSer6GuPxBal5JLkNY1dYt/cx8+AlYy80ssBTPJ1SuW23MpF+/kfAdpOw2xgtVky4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779026123; c=relaxed/simple;
	bh=Hcqrb5esZiCeDaoasM8ESkNfphKDsjkzNeAgpoKFZ3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qL3ED/vNgLPyJoaVs1xqDySRcRgUYelgBTH4TM/puX7cG8hoONcJFQGb6KnoQ7YE78tllOVN2LN1zgtE7X+R7ur9+qp6i3fFikjTc20Rg+i+vxgAwTgq4i3aqFxZudaliINiO0g7+YkNp2gfBN0XbP2LK91MmzTavRwCUg5e68g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K4rh2rAF; arc=fail smtp.client-ip=52.101.48.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K4rh2rAF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y6ejfVe4ZNxD6NOrMhvIoqOwE2nTrswCkZ2GREY+4XW0lTTlylDe9G1Z++U79XttNKAxj8mkqnAJhjTnWxOnJyW/rda6Xz2WylNzFfsFpRiOBUvLI8m+k5P/+Wym+4OanzMgOSbHm4uf+8g53hZ2Li2IVFKJ5j1ofIZ7Jck9QndNNXRy6NCepXsRoxqLTaiDKnagZ0SDUWJfKm1Dm4Nc7QYgCiVmCm1Nw04lThpi0TmyrnxI+AHldOYowEQt84tH2gRnC1vMlQjxCRmy/foIXTNVVMIGJUKVgejpWztFdEJzvV6sfGo8qmFLH75kTJKc7m978LV5lsKtN8M0cj7HeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BvgD7m0xUKHx8SMqzUsBe2RMip0KC3Nz3pQSzZKVxpo=;
 b=MnnAGRy6cfY8I3cOfZMameUO7STa6LfB+37mp6oeLnrJZx1poMsIn3IkqpILEMwJ00R+gMwCEJEEuhB503VlgAvRYwwW9pEPI+vov17znL+gDLEmNBHYrXUDjkxiu8IXqbBYWWr6b7zY+OoIEfjbZGn6WVzbShBQyhjeS2BOp8T2pwXcZJ82DXTido4yv0wTd1KoVT9/jSQFZAZXQ0rSRnzGEB169t1ELBNomWwi+p3W+daAxGf0XkvpgCN9OfieM80mBaBetViaNHU1rs8o5LLSSpPVeaYGqCbV38XyTy7/d65elAsDTbr4Spx210EwBa74EilhQuJO5seuZQv5lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BvgD7m0xUKHx8SMqzUsBe2RMip0KC3Nz3pQSzZKVxpo=;
 b=K4rh2rAFQwY8WZOWkmzjqsw/KzsI7325cd8t1oL32TR17w3CLZXX9L7X4xYwPz1FXt7stt77LNd7K/cSfvTY6GZvS4ubq+frraKUkfOdqr91rBVePSWsJN0t8BUgN4JlnqurzJ7bBHwQV/BaSvzraDQvNeSnTGm4bHEJOOZKxPStZT/jp4xl94uNOn8czLswQz/rffeEZN6+ZBczeZr067O7uUWBvxzPiHZBcBtqshglqxBOJ3TdrJ949B826CpEWXucJUkiPd9bvDOfIoJvr67CQ1oE+bYM5QnmAK3lEeYxnw9GE2Jmo8/Q42tP3v5gicRgC/tz50WySZnmMCJBcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:09 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:09 +0000
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
	linux-kselftest@vger.kernel.org,
	Liam Howlett <liam@infradead.org>
Subject: [PATCH v6 09/14] mm/truncate: use folio_split() in truncate_inode_partial_folio()
Date: Sun, 17 May 2026 09:54:11 -0400
Message-ID: <20260517135416.1434539-10-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0027.namprd04.prod.outlook.com
 (2603:10b6:208:52d::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: cbf434b8-3151-4553-595f-08deb41be8b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	/L8sWs1ax1DJwVs9WvphjhZqdAERd5/sYRABq8ENvuLDGIhNiJrR5Qw6OuWwX64s1MvoP/kwYDRJrF2ug/aPvg6b2jUsDcPUFqrr8Eza1BE4F4yrMJYxAjbh5xuM6qstyTEwB/uNepdqzLauWZEoMfbUgDQzuhi2pAyMB7/SWeYBf9wxoyutAOF0Y0poevUv9eRM7IQcBswee0wKP1oxGljjGoXDkidexSf6thp8bQLPzviqpoa7DSwRiPJXthHF80q8AeoY3gq0eysok70Srl0l0FuHEvDG3CvnKeiSlsgyxvGzkQBXlWAGu0n/MWX8/81eapbbVh5a9hyyFio3dF0qnjabm8cj2qiG1Isixq7thOL/quDLaa6XMzVzNPeH2GxA+ZG4Chgc1TYn5Ddy+/GEe7AK+aCevpwNweIXW6Ynl8s6byuc5RAJxX1vlAN0m5HkyMBxjFWriiHF6kqeHa01MB1EMYAeGvf+bvzQVwa6870fYGzzXfvBNMT2rydlXzCSCvEBbrVQ12YhmkdJFW+wpGst0F2lCmHXdApgRVb+/9ZNP8wyTanABSBtqXYKPOUv+W6rXO6HIW+YCKGA5+FMwJC7hf6V6g49h3xlNzPtKv9jJwtgCYdHenGmDiJMfY2bsQehQvNAylFS8e41ifA1dflqTzNbWih2lJc/11ijIxtasiY9gMYN43NbtCoN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qZTZbRQ5ugxDx8EsxgCrMbOwv6Boel6TLtXqDWRcIzYZPEyEFgvGs+ctTuUd?=
 =?us-ascii?Q?9ExIX2mIpqWDzF+QrK3kiPy4IM2HHSJQ+WEqGi85w/dICnR4VlLfk0tZrzuJ?=
 =?us-ascii?Q?M0DykJE6WI7HxAFclecBVDV3vKe3s3kpd+xDrxVZLkewOAvXdpFspMPh0nNm?=
 =?us-ascii?Q?LpaYKTUDuhY6AjOg40qCacwFkjbZyZAlDLcnxxbQD/yRzTNNAsbycRwuXNol?=
 =?us-ascii?Q?aIUwcCJIfSz1ANB8GBRpFCvweSynapCKF9/zTTtmWXUYReDFsSkWaSr7VuPY?=
 =?us-ascii?Q?GFFe4cUwAYmb6YPXGhUAinTxxJ7M/0RCDj82C8hDtEr3cje4+3ec3VqwN23M?=
 =?us-ascii?Q?Px5cEJnzRU5LnDCfWGf07WCEJEV1BwfDwRQ0ZPVA3CpfWUZr7PBKbIdHM/Xf?=
 =?us-ascii?Q?lBGbLKyZVnYMur3QGDC7Vc9pqicCW3jxMK/Rx69ODtlTZaLor8JeGONYSeh1?=
 =?us-ascii?Q?nsq6MKVkPBiZTL26c6jQd9z2Zk+RkM+SK1mC8QWnk9YXme9AeCnmJe9C0sUu?=
 =?us-ascii?Q?rLGrG/txe4uIkOy2VDAP03M9dgFOAMCkCb7Jcg839MD5EiGwpYRvw2ZDzZ7V?=
 =?us-ascii?Q?GhyL/4G/CPIFwNoJsv0We+kvc2RmfmbfApD0Eq7Muqzp/gsAfJ6SwL+utZh/?=
 =?us-ascii?Q?D1EmuRf6SQe8t+BwfkJq8j2S2R0gPRmYo/uux4KW5X4b9tKY7Gtb0qFSvwWc?=
 =?us-ascii?Q?bL49oD/b0PTNg58P9z4KOsUo2LIxtQycgxo2lEVljlq7gC8QFFTYIsv38Vn5?=
 =?us-ascii?Q?Ks+Z2u5CO8vCojmtg2SBryUChFkPFXpBVIYfdvsudIZT4WnkHeko0K+VoT+6?=
 =?us-ascii?Q?EOxwiwPiSaYEbPiIXIMqbJUBWdo1Yuavoc+6osqdSU2GKozJ9IJc0H+bHntF?=
 =?us-ascii?Q?2xvQ7XyIfu9ubaphUr3VfDu9BnuXijMweKqQgL0rjM7dTlcyaSHvCt50I9ho?=
 =?us-ascii?Q?8TIB3mN6SO0iyIYVx3Wt5jspeNfy1bO9kXB4tAHVJrU+GkO7BiFr5SHE8Z0X?=
 =?us-ascii?Q?nEManrcNv3k1ICuhoMLJVfvkGQpxnLx0ktlISOopfDziuBDUTushwTt4umRq?=
 =?us-ascii?Q?iMkJqHb0zakIWIDFUdvzVnzF/PSBbqN/Rq7n8C6tuEdihks9uxPcU5eZtrYV?=
 =?us-ascii?Q?GymMPDDIv1RLMwIniKnGhvxNR4CqQee3lMEolMZFiPGqpuJMj5JLKXJ4xkY9?=
 =?us-ascii?Q?9TJmjm9tdqm1mvYBFZbBU3Wl984MP5xNnODS6nMy7/4m4XKeOw6RXO9UvaQI?=
 =?us-ascii?Q?mBxc0dlIS1MXo4zJZ44kKlpCG92qe4z2rDrF7hMONajjxO1J5NhP75+glILm?=
 =?us-ascii?Q?FhLvcUtgX+FIKvbTccStoi4K7v5TWfzAvJjrOecOXNOpAp4QN5zr/3EmHTVt?=
 =?us-ascii?Q?YDHe2eN4B+SlwKNdlm2NzqyEF3kBxuqci+62kMsI2tF5+DTZ5+JptoHeXCgJ?=
 =?us-ascii?Q?SYYZVXXI8k4MzOlUx7oZUzO2hddU9ki4xHoaLpt27PfNkssdbhQ/SMfHGduH?=
 =?us-ascii?Q?gQt3Ag7ekdAjQryowrFILFSRhM/Uk5vaVCivbHHCNbgNWyJm28tam9mTlc/A?=
 =?us-ascii?Q?TY1k5agegS8WVtxCrWBjsgFneIqrMtIkQU3nVfT/ninKAIIMB/8h4v2UHyox?=
 =?us-ascii?Q?OYy0llaKEQbgc+UHfVojImiJ9XaS6HCqgE/reOVqeu7NNcQLCrbrnyqbHRRW?=
 =?us-ascii?Q?1+bHcVSKle9k53iWRNnfhNl1SV401zZhKyZpk2WmFGXKxc9+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbf434b8-3151-4553-595f-08deb41be8b8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:09.5579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uf/mqQEyJ+LJ1X7VasIX6oWYzmh37beolnb68qcgYw4lYJQ5pWzqHt0H+Ee9lARX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322

After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio or
not.  folio_split() can be used on a FS with large folio support without
worrying about getting a THP on a FS without large folio support.

When READ_ONLY_THP_FOR_FS was present, a PMD large pagecache folio can
appear in a FS without large folio support after khugepaged or
madvise(MADV_COLLAPSE) creates it.  During truncate_inode_partial_folio(),
such a PMD large pagecache folio is split and if the FS does not support
large folio, it needs to be split to order-0 ones and could not be split
non uniformly to ones with various orders.  try_folio_split_to_order() was
added to handle this situation by checking folio_check_splittable(...,
SPLIT_TYPE_NON_UNIFORM) to detect if the large folio is created due to
READ_ONLY_THP_FOR_FS and the FS does not support large folio.  Now
READ_ONLY_THP_FOR_FS is removed, all large pagecache folios are created
with FSes supporting large folio, this function is no longer needed and
all large pagecache folios can be split non uniformly.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---
 include/linux/huge_mm.h | 25 ++-----------------------
 mm/truncate.c           |  8 ++++----
 2 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 48496f09909be..127f9e1e7604c 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -394,27 +394,6 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
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
@@ -647,8 +626,8 @@ static inline int split_folio_to_list(struct folio *folio, struct list_head *lis
 	return -EINVAL;
 }
 
-static inline int try_folio_split_to_order(struct folio *folio,
-		struct page *page, unsigned int new_order)
+static inline int folio_split(struct folio *folio, unsigned int new_order,
+		struct page *page, struct list_head *list)
 {
 	VM_WARN_ON_ONCE_FOLIO(1, folio);
 	return -EINVAL;
diff --git a/mm/truncate.c b/mm/truncate.c
index 12cc89f89afcf..b58ba940be474 100644
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
2.53.0

