Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012028.outbound.protection.outlook.com [52.101.53.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C233E317D;
	Mon, 13 Apr 2026 19:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776108071; cv=fail; b=jwraMxqQd87cMZ0LJUYTesTfiZojkHi2D1dKl61dTSntBhzClkmkreHurxSNGzVQlLlQbJM8H+EB+RJuypIkrImOV/SifPRoYy9wY35KMpkRrN3vM0UYsCi/MMInEA+83PbUePFV+JDM0pSfzNWwOw0IKEePo97DqGzyhb29ikA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776108071; c=relaxed/simple;
	bh=+0WsQZ7bWfTdszz+QrILEGaymsKdfqpavNgteVKoOTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YKDb3kFdPsBe3YV6Zy/poIW2K3HteufzgiIvaZMG7HqLQiwW7TlaPLOe7ULRi1AzOmsN3VwbQUbt6BtenTScs1K+ZyXjk3pB4wXnTYzjDO16KdIQAorqoH+nVU8FqffJD5C6GHeIO+/dDCiJdXZldf/MCkoitwd2qtUZty2ntWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DUqRPQsf; arc=fail smtp.client-ip=52.101.53.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DUqRPQsf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xo/zHnRSLWejjjRQ3G2IH6Ow+TMraU/XTo+W8SyL+LX7sLUImO3h++B/aCsy1IEtyDaCVAqOyVu5oXyncblp9uqaafPu2PXiJv4R0YL9o7eenn8Xqqy7jbVoWxSp1uz45LPb4CBeoL3YoFwvCaFvt9YqJqwHGuQWEN/ZmuVxuY2je/jB/XQcDs6W8wZYndJBMM/yh4VN3vNG/aeVQK9gw4KtI0duiMpWpJZRIn7c1YX0pcxDs5XE7ooKlPGl5JSaMY221w6XgpdfkyQavHJKW2RSX62cUMm1jNpL21uGFKN5pBLkMv63VkL5K9emkNOyCu4ngl12VSKCQ3H/6Bcjcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ycci1Ec5ilfqJF+ZZD7TAuDXAjaW7BdC68giBul+An0=;
 b=Ar1o/fOglqTMJib/38nnQ4aLV8cMFA9OdrkubhZVnO8Zc3NoHoOIv+w/zFVG8i9HpikEQeUeEe/HA02qZm3UjOhhN3QRxPEpU7zoEQ3rq95DRJVDZzkuc3P2g1iCeFpbzJ5ZuNtMz5PY4gL6rGD3ZiA6MmfNBmTa5R958Dmb5lUzFyf6LwAb5CNUByamTUVNIFNKglnXGxlyBgA3w15z2nQA6saYggLddNgiSNbI3GOiXTUav5LJQ1QYPdrFU0TGfBt8sJTrHcMEqiHO7+8ldvBK6y/FAT1gpT62pFl0j1mUb1bUhzNBAbN0VCbAqFnX4adNZkyVqu0pCkaU+Jup/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ycci1Ec5ilfqJF+ZZD7TAuDXAjaW7BdC68giBul+An0=;
 b=DUqRPQsftbQyO902RGHWNk70V60n7ekk6uMfwQZNzc8v2NE4YsU4vvN/c3PmADULOqrODYE3YV/QcLHSZbPz5nw9U5ph1YEuwWcmZ9BmC5NcKrozkTYYiYK+aCb0UivZyxbG92Luj3/rx6KFjSAvddyIBkduxdKYeC4pj/d4+V7aRAZzohnWsCwUzIN1Xj3+Glp72zCjUZODhw/sqZ5kH8ofSkNYJq4+PESWeUvK1HgIOrSMDl7L/L9m0WZeuugABaAce2jIH1GqNZwclaVzKb1263UTuJ0KeKpPjRFzVG22M7ofI4LqjKR+skQV9lPVr+zDikM21oAOJgIFF6ExKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Mon, 13 Apr 2026 19:20:51 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:50 +0000
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
Subject: [PATCH 7.2 v2 08/12] mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
Date: Mon, 13 Apr 2026 15:20:26 -0400
Message-ID: <20260413192030.3275825-9-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413192030.3275825-1-ziy@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0005.namprd22.prod.outlook.com
 (2603:10b6:208:238::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: d0460a3a-c933-4351-0151-08de9991c62e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	5NjpS2Z0J3E6RatXCr5YW5psCXoAXVTbBvz5GZQqU5rhBA3P1RmAkzgC0wa8JBlKCBdN37K3f1I7RmCootqplAlgnbkTnc76ZZBwDwhDJ6X4RSWlnladFeEApzzn13VfFnkxCOcBGuXEASNhomSa+bfZjaj+R/feyeyNCorngIlxFtW79a1rDqpRmta6lSEmTJTKKoILSj801NZNAm20M0w9G0jQUvD9/7QJEuhmQFdntACXGCl1Cu4Z/BjtHwlNlfXV8lUAwMPiL+OiyJwyZFI7d26C0utWCHi3MtzGMKXu/9IE4we65u6gtsCgswqcznYDUwxrNYawxidnMSbKoa0dVuyKaMCGP/OCTozN3/sRS3MNxqKDV0Yrxo0ryW8bAoUMFFRLsQqTPsSR2zCIO3G8rKtjqFJbAbI7gpgd64fkgjBAw4eBKXt0YK4SnvrJEFCgdywEtQEQgm4L7gk32rW8HtqUjftaV8oEYR6dBrV/tmDXAgh3i3flkQdRl4+no7h724y9/z75fp8y8tqgCz4v72juhOMlgpdIT1DeUB2NNTUJa9REuNntZNgW7V3C3pXKnK1DwkhY2skYp2pBTH3PKFeKQN83J+09MHOR+qbBhkJ41wEbt0a+De9W/p5Kp4QmFfcxItOKxVismDovdo+WPeab5zpHee+apYYQCMqhPyhpjLQRJTDXU6bnf5psXRptQ1LtdtlLCd16DS2V9GDW+k52bPv6RkUqL0fSFyQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?92hyHQIaXnjbLPOsEfYnxMoyELVEnWl3J9I0zrDCHLAe29Wph06bdgY9iSFq?=
 =?us-ascii?Q?q5YvcVBqgbRUnoFP4dyfXD4hN13WPhCiKq4+wOTCUVlQIuoqWdGcNvypZsf8?=
 =?us-ascii?Q?8r2Ry9CceMgPcEV7cZrLH1kFzRSFyD8osFTHk7B7C+J5k5JHxJX9LhfWWM/H?=
 =?us-ascii?Q?YgKRGROsTzwCUqjBVybPXaB/wJU038SxJvnWM3CLhpB/+6vrMDRkBBnDCNZ3?=
 =?us-ascii?Q?QkzEW8m4fLqxGioQNg+4ubReaiGKjSxcK+51i8GQ/cDpAqZCDokqHfeOew/W?=
 =?us-ascii?Q?Y/dyUDjNQIhsHjwYpLfD0354TIFXZDzKJ4j0Q49JT/tFG5F1svVecow8CgA/?=
 =?us-ascii?Q?daiQ+EQ8xaCZ6BeKK4uGL77hqmzeUHCE33csNW9D5X9pkwXx4em0vSG6dxXH?=
 =?us-ascii?Q?tEeKh+KD9bx1hbjZsAmUhdwwpBg5bb+wdxSBbML/21VvxhYc2uQ906Wuxp3/?=
 =?us-ascii?Q?VdR5OPa7A9Q36mfrKfkTSYGhoCnNruhoMrPV4a4lvq0daUNSVtDWeIqGtJvK?=
 =?us-ascii?Q?YeTLuZkHFHMdz+FoVwL13nHZZzYTL/UHMtTonr8rsrRd+xG2ojjiIBgbEqRw?=
 =?us-ascii?Q?/xrJO3Nrd+uTJRO3WzQnc01uTIOYQMpB5vTt3rcN1HoB3wSvnv9p996lZRMV?=
 =?us-ascii?Q?aqCCEobddtAW7LdDckWEusPbMFiyO/l7kuhWTpZTiUsztnR3W+NTxTG3aRs3?=
 =?us-ascii?Q?UMLRzKZ+ZvtnOil/AZw4IgXnDdE6K+dzQIlij+Ld/tWCtMqev0w9luGxUW3S?=
 =?us-ascii?Q?N+eY8rimuxG6X8IECsj64+p6BZEIruL1bYOafdQYkcmkQvcvb0mmP+ekY+in?=
 =?us-ascii?Q?GjDhDP9bq1RTqdljp7sTrDRjbb4iN8RWh827uO8eBFeqHpC/nfufRhnT3EvN?=
 =?us-ascii?Q?sTFUcWb4RutPITCypBFAFUVT2bEyGj9+FTyVVTQuJ38xeE2H6F6LLNf/Ehb5?=
 =?us-ascii?Q?nJIN0nepTxnnBLgDwnY04lsSsblgv45nLAgv0dErlzT4FZ7wKiZJmMlZfr7Y?=
 =?us-ascii?Q?1qfevuA67JXSNm8dh7fnSEhpn0qziC0lN68RtDfsesFa1Brk7LwkgKtmGU2F?=
 =?us-ascii?Q?EnHZvAiHKVOLq6TLECoscR2DnB96i7lsuPPwoL+PlS/kpYhi1gU3W4rnAkNR?=
 =?us-ascii?Q?ch5IoP/PIb3XffA3bE9J1MdJs453p30u69r/fN8YRP6BtEhTAKIG/37ZGcUy?=
 =?us-ascii?Q?T2OeJwA+NI7yAIw6KvJydCdu16oqBfno+mqOgv2ZqhYzNmjKM0T9zMbayksI?=
 =?us-ascii?Q?ZESvdE130BGddTXNZGkut0keHp1rRIywwJi45tFRFdyMbJHpQB4wT7j0Lrz8?=
 =?us-ascii?Q?YnYb0fjX3pNVmS760ETh9OEN+FjZobySaozO8tmTiuQIERT1stwfsHtqWJPK?=
 =?us-ascii?Q?lSBqfE9gwcUjsYskMt4QAYY9/f1Lurzz3g3uG0Ey6ribqxmAn+aaEqwb6/GM?=
 =?us-ascii?Q?BBJrIWAgrikWCr1ThMwOpaXUdtOGu7673fpTLkSPsO53SpF0QXqXR/uwhdAe?=
 =?us-ascii?Q?56vECCHqJ0M7Q5BvAcArGx0Ud0VwShv77tVfps63NfW8sftWXC0YwvrqY2AA?=
 =?us-ascii?Q?V3/NX4Uw06nTpiHYNZZ4NaJMDra1cwVsbLfXQyQneZlzEGq3tULfO34y7/7H?=
 =?us-ascii?Q?6j98ULKihC6i7FfR0mNVigAJBP17PFb8lK0wBbyLCQmdZR2CgsYlptEypGH+?=
 =?us-ascii?Q?3LwmKAkSl7xHt2cK7CiHTsgoeqkFepUdkDpezjrhRf+D5c6D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0460a3a-c933-4351-0151-08de9991c62e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:50.8576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSaMKBTlHwl23MAuNLGiDtJfVM/iPYVStztTRFYhoYHxp1YWBDOw7oJbdodSIsmO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444

Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created by
a FS without large folio support. The check is no longer needed.

Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5c9ee900ed90..4de38c6c6d06 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3821,33 +3821,9 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
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
2.43.0

