Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010035.outbound.protection.outlook.com [52.101.56.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A686233688A;
	Fri, 27 Mar 2026 01:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774575803; cv=fail; b=nA0VUNeSaYkZCZiGlt/X7yZwNPbqtrkJwEYENsQfGbF5EVPcl3U0r/rI0j4bKDOlFhcrmYeCSg4BreSSuCfinGiY9ketgxr1VttkvdgjUQa1IcUadVOAp+WXAOv9NIyBKMTO0/nZbg/LfVm/8W0dJ6mT8iq7TQPNAR9sVlj7NAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774575803; c=relaxed/simple;
	bh=VAVbRNc9IxU4dYRSZHKYlFQ/eArrbGPwYUFLyM40AFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HWmodkUi5BXjjyjOKgZlve51VUTsswCEJsWyLwsDzq7G3UEQmACVOHr61ms07Y5olpCvZyz4j1Fes54S3bRDr5wjGYRQ6Gh2nDRTQ9EEJCdNyNoIKSE7EPkkqZ9clhCOwlJLuJ+Z8ylb4g6ceMVkiZ40YmAB3Y12H/5ThVvPock=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HyKTIwAj; arc=fail smtp.client-ip=52.101.56.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HyKTIwAj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=exLO2Mr3ioKahVJzgt71dsqLDQh9EOLQwJ7z5ucFZvJEnSEXx5xVAT0Zeg72iIOakahRzWV5moMveYDsqdD8hJD1/OMzdMYKSFeU75ykmJ+0SvZP7vM3utMR9xufHBbg0fBBRXS+z5IJa6hvVoTZG2VVxkZ7/OKMnJd4ygPWtdymWfPKxGX/T3+7wYzvP9bI2JI0Xro2c4r1qf4cpahMcQ4kERddV/+9VkT+z+bw7OzUxvxjjsX4NY1yfPi/ALmfv+K/Mc975ZAJ8UmlD9eyBDVLuKOb+VuCy6rQW5wM3i11/bSahP9CDNXK0FUD7H4z2VbLZnDMm38a8DY9Yx/0cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bY6vie+DM6LyPUx3LThLrnzn+NZ0QOuiiUTObE5GGT8=;
 b=DVzrrFuAAcl4CAC5M8GNu+kovtfd5P0TSYl+EaGK+Ea/eG6htH/QBvaBwGYFl/LX9FI3cxLI2HMNs09hG6pHOejnGgfvyF9JVwSEL20nyvzAvFF2ZXFRKnQITwJJvU7GejSUMAp1HeEtERz7v4XJ1nM6peCs+O7ADXdNv1GQU+gKktKcyxyFUZBmuJuw+s56AppQ7uztPNWHHW6t5W82Gcmkuyzlfl+kj26OIAPiA7YtzuCKety9l5hjYRxTUC7xPHZDcviiQOvY6iElt5whajgNyz4SdbjPk5fVlhmFtn7e/UeR8oYE5icoCO9UgtKrPoxEr+0J27kf24YOqvAjIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bY6vie+DM6LyPUx3LThLrnzn+NZ0QOuiiUTObE5GGT8=;
 b=HyKTIwAjweyHa07cus4/u+xaCcXj6EHSXd9OzvhijIW6G37540xQhgRfmDQ64n489E7fV5P5YQKid1JsvzVIOoPYLkpA/bX2s69wWsKQgPM5aWRsyNJsDc7S9VueJ8L0DiZz9xTtL77bYLp6Mjjsq0ZGgk4pc45hrCUiSPxNM7K/buYIpXGwH0tp9GLZl5XMYKjUfun2gQ0M0PvyvXf+dgUHzhtixizxxrKIpryVCAT61vmn0o2Q9McHn7sg1vZbO1y7e6w72TmbxHm0vky/fpGrn858AVNPdEYcJoC3VP82Wmb0c2QxMBRnsqNRPqwDvRkh/GGBUnjEtRvLRzgMyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9264.namprd12.prod.outlook.com (2603:10b6:408:1e8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Fri, 27 Mar 2026 01:43:14 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 01:43:14 +0000
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
Subject: [PATCH v1 07/10] mm/truncate: use folio_split() in truncate_inode_partial_folio()
Date: Thu, 26 Mar 2026 21:42:52 -0400
Message-ID: <20260327014255.2058916-8-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327014255.2058916-1-ziy@nvidia.com>
References: <20260327014255.2058916-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P223CA0014.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9264:EE_
X-MS-Office365-Filtering-Correlation-Id: d737b191-00ba-409b-fa8f-08de8ba23627
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	AhYr675sEyTqwUG/G+sfT4Mc//YgtQjl5urnU6R33ngg7Kqu7eeMDUA2LuEvbe07MajacFQzCEHjzUbzqZE5CvjZhLaMQ7jWqYHPK9luD6Nvm/pFJ5aF4/v0UPxsGvZQbUBhIVbQdAj1SHp1QVfYarAp/Hgs5nghFG8y1NCBxUB4PxahF3zYDJ7clmqCCS2ah4wRsI8cHFkh6mfhEtlXGTEphTXP1jjIfTxrvWuujPwOpPm/dI6SFii8ibNLzvaZOSGe19TNPuPSFPqDxRVxTD97GKTTXEKHhquNPGs+Ynwbpyyq/2cQjYsXumLAg78YpUmRqw47Y/eLGkjFi7SofB31C6ZC5WU9sb1rerQuGnqedfcOE2jxYqv1rI7OG0xzrO70LCwnAyQaejLMgOO43OkYGZhEmWoNbttEUgBxW3FYuqyhsDfqoWGMseLRUVH8vbHOep8/Kl92tDGBrXEjyL2Pfs7tsgXKhYYhRYyixVmSwd4tL8JqZ6xR5OuijEKHKUXc2hCI3zDoTi9zpCLWP3xOM31VjrsyR1KMNeUzzzw3/kvXJAdEj+4sCNj3+WTFFfZRD/e9/N1d8Tmh+wOjxrJtgPgAaLx46uq43jdfgoX6FNdZIM+WquoXEdXxdQc9zurxWSW/9MXjAhxOyLhGKJpEsJgjHi3jEoj8elvEk4KGeJc8xTB153vU/dMEsCCVa3MeJlQ0z49llwC7oHtMaoxRzxhF4Y8vgxqWkigB96E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pxCgFOdVK5WTv5ozbGgjJAsx3QX3ZRqfnmAGJnMC5fh9rnODGpECePLe0vDv?=
 =?us-ascii?Q?W2OrUmeL6Tty0VxRq9zIx7gt/7k1jMC/VzTf82iIQxZPVehy8Rw4CS5YfLrG?=
 =?us-ascii?Q?rROutK8M8vbHBQl6I+OQhSw4GHGhrrzSFy0rSJeqokBgPUNk6ksyGXLeULjY?=
 =?us-ascii?Q?S2MvIJ5wpslCUgQr6FyM9yMncKvqT7rEiV5scfVmwx88aMOSt7I9RwKjl647?=
 =?us-ascii?Q?Dt9zGxeiMdU0cCL1JfU2BkBYA7HCV9vgE2ieCXemWkz5L+VCo3y/8S3JXm5n?=
 =?us-ascii?Q?vV3zuvFKKPYOA+pobfTaT2NBIdWImKHxf84NWyvMXcopfMi1dNkTX6JEsPgh?=
 =?us-ascii?Q?bCYyyfiNyKeHlmOiyodbloGKzucTcxEVe/0HuGeIdoTZ17S9NDl0CBmPFiQ5?=
 =?us-ascii?Q?nUIX5f5mhaSu0joRa5PxzwZhYvMO82t+ZebATizqYk76SOY9W+uE1jq9QnEo?=
 =?us-ascii?Q?yX9ipiJHxLjRnttLVPHyisj8W+sGtRJ5B9/k3nGZzP900y1AlfVUGim157Cp?=
 =?us-ascii?Q?A2hjLk5qrufBPq4j552O46DoTds61IZFQVp5SrAzQ7a1kJZqzxTSdAjODKJI?=
 =?us-ascii?Q?XrVImsUDakZ4dRqyWwoGizwYGB7oi0BOzNeBXqUfyXKUFEUevkDafiJOvHSd?=
 =?us-ascii?Q?MFpRZ9R8kPetZvMTdp9oV0EF35/8wh6UU41uz4a8LRr07qxWJfL+BRaw7YfR?=
 =?us-ascii?Q?eAuzZP9yalytWtM5hayNvGd9NgXUJwc9mhA62Z4A7a8bgezfL0FVlDqHqHgG?=
 =?us-ascii?Q?kpOlXn2IBA5+Wiq+rKx1j0LfTFELb9sKIjtjrQfERxnudd76vBevjHcCscEN?=
 =?us-ascii?Q?I+ARA5335l0am57km9YzSPEvkYWcemzEqmFyhc8RsT+Obes/Y00kfMf+pMio?=
 =?us-ascii?Q?aI4LGiqteQ/xgxzPmjpB3YJS+iYtx1ykShtTAy7ISvZkglKXYLOa7XL+3OmM?=
 =?us-ascii?Q?3GLAkEdNG2jC/iw8Y3Q3wAqvVoiOUgWHGEbbiUdWBsc9S0fHEcI772tTLWzE?=
 =?us-ascii?Q?P4UN7Lkl8gQgN+/Zu0zxD7+B35Zqi2MXIlnmkYbm8bQIRsR9oAkObQEbYSNv?=
 =?us-ascii?Q?PpqkfOEHMe8Ng/Eemj1DNQ3SRYjwShcp8YTNEtD3moxnevxrjV5PVwiUtfbM?=
 =?us-ascii?Q?jJM13ojRCHGQb4XYGNH0Airs4I3BPauSUrI/FE2rCWEqZad8jDpr08lOuGRG?=
 =?us-ascii?Q?dT4H7SGQTUR6HqOSJ7cvcy3UJx8kbQISyb1Nny946Ziy/mCQS7CL/NMOauOe?=
 =?us-ascii?Q?2qOVjc5n9wjoAi6L0935rYQI7X1PR72fx5HLPSaekJHwGO37stSoon98dHdt?=
 =?us-ascii?Q?tWW/wksorvXc2r7nxs7sGbnq6aen6zTcI1LK8DQl11ywHjmoGbYMjN8YE5w6?=
 =?us-ascii?Q?MRZfpdFtQp2m+ewPnf0CIwyzG4QS5eH5Dtk7khA9klgZGh5Rglr9z7i7cyGk?=
 =?us-ascii?Q?OcQTMS+5bxhJgd4NXRM5fGTyY7Hv1cflUcLjbjHoC/x5/Mvi8z6dYjMPjEco?=
 =?us-ascii?Q?KjRD+M1BsPhO/vGj1lmsQp3tgvExsZQY3G8e4a2zj0OQ2s65V4sUbA1iGNCR?=
 =?us-ascii?Q?YnCFILukbmEOD8/SlGj2xNlSH1wg+0PQ7jZpndx/xYhr9VHRukdlLIN5T42e?=
 =?us-ascii?Q?2hJEaSUxEFF+i21zlmzPpiK71XDvoPg2F8PP5E8esf8S/5M28jXnQvJE0O5Y?=
 =?us-ascii?Q?pBeSbIs4CxfJIlgx9Hq78kLO2OVGJoW1aYt+QViEIW9xGj4u?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d737b191-00ba-409b-fa8f-08de8ba23627
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 01:43:14.3665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LqDFAsiX+MpdKnH5VdHSTf8zL1JfX+r0D7NTy6HJ9xDqUHCKQIuueVLJJJuPOZCF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9264

After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio or
not. folio_split() can be used on a FS with large folio support without
worrying about getting a THP on a FS without large folio support.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 25 ++-----------------------
 mm/truncate.c           |  8 ++++----
 2 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 1258fa37e85b..171de8138e98 100644
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
@@ -641,8 +620,8 @@ static inline int split_folio_to_list(struct folio *folio, struct list_head *lis
 	return -EINVAL;
 }
 
-static inline int try_folio_split_to_order(struct folio *folio,
-		struct page *page, unsigned int new_order)
+static inline int folio_split(struct folio *folio, unsigned int new_order,
+		struct page *page, struct list_head *list);
 {
 	VM_WARN_ON_ONCE_FOLIO(1, folio);
 	return -EINVAL;
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

