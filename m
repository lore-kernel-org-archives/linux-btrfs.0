Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011051.outbound.protection.outlook.com [52.101.62.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D7D2E03EA;
	Sun, 17 May 2026 13:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779026123; cv=fail; b=eVyBYQGoS+RivAz3FL+p9sqt9j6qHcj5ZhAWZrqjQ1e0+3b3VdBg6WrIFmrH5pwSPcY2Z3EZCGJRreuTvQsz45QmZ8kqKPYFx4k4+MFNmiMAVuGyw85jmOQwNuL6nTnPJOH+DySckz1TfBKA1T1cgcHdxWN5V2nzGK8H5OoDgCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779026123; c=relaxed/simple;
	bh=dS1UV/oMT5WaEog2K4PJX5n1FWjAO8lt4NZQcfRuAd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uE2JLLufbX5bzT8PiR8O0itCDc2RoteC7IYAWtu5USzr5Qb2P7fXu/oTV2uLkcb0CbgN99ypi7rcA58qWgy5/EznbEN721URzlYTJDmR7vVfeZqoBvpEAR1D7WLO2MlJAu7CieFJmk4OrNe0hsWZwYw7MKVYPZVA+4TRBCtLvBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iWA3sBaP; arc=fail smtp.client-ip=52.101.62.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iWA3sBaP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iI+SIvSAYNguKNStp14jTBG2e1ZKzCjfN4lrrzb+rsXxeeMRi7IJUpbkuH1GwWiqGRBuOfPsoKivLOxh/m/Wevi7RTfm8iAYv6IlxJetsBgUQUNk9/o+tODoZwLnKhq87ClIBiO4qLwxp41yPgFF21NYlr8UlFVBdNpqcfuZ1OWieinnNSpGrcwiRU49McdRFVPOY4q2srQQ8xvNCsGtpOB7mWvZ7IM8qwePnTq4eQZvTTL2Je2JFruT/aJ9q4WZAQalpdxG6teGxSMA0NSMXBAB48vFKky9OuYJyZrVUOdDHbILVDrdyRXEVAIAvAEYDp8xUoOeB0ivYZjbQa+2Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EUAD3nseCt254ySt+ZMi/pG0VbilqjYycqYqVrPSjC0=;
 b=QylFb/bmLEHOlyuZ0c20MAjFcTe/IM2tocDuDy9SMhFFBSgeFpWYlcq1V4A9BoX6ZvO7DXFblDDurcbmdiMoLAm7VcLN31etvTpP1Q28LiVur4hiz3C0Ko3tmlqlSTr4/k1QZxCokW2jKeH8/s4Ao2VftsC5sqSdtG4pGygnzAxgN0hKohWrDDdbH7ZJh3XrTcVrFHrMbqfSYkngY47ifeXSQfSZm/Fsk8/w+RQUWYl5RUny98iK47tSlF+Jeo3YNFbWdZNygJOPiM8jP8uzeLnElOzE70DGvkDZWRO11WJ0WJMg28AaOb4O1wdv90ZWD+ZKwDjewqKgwdF0G0c3MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUAD3nseCt254ySt+ZMi/pG0VbilqjYycqYqVrPSjC0=;
 b=iWA3sBaP+31MxkDxNHrypBsPPV7VO6oQvojMM2Pwp2OzDezwnvN4rPw3NW9GpxxYANASWWjm4ni7UZG54uhyu0XaEu90iT2xCbZHHg1jp8fXgrorgDFjmxh8kzuQN/rznOp2Z7G5WNaHXQVGuyz31KlkfnHJYu4pPI/szE3Fh6ve7KriRV416ZxBXm3LZVlP5YfqzFpwTy6gvtovYFvcgGk1Xo+E1d0DxtK8HrTv3pDyTftSJ7pbuTKmRc3krC2DvwAym5ZKVJuLzOLonNrTfLBV3nX5urhaOe1mwP5hlqBan6hXpwP2aZVZqpFJ7aNNt+QqUA1tVZzEalPn3SXPOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:08 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:08 +0000
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
Subject: [PATCH v6 08/14] mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
Date: Sun, 17 May 2026 09:54:10 -0400
Message-ID: <20260517135416.1434539-9-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQ1P288CA0016.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a4b89c7-dc14-4d35-3983-08deb41be7fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	hw6MFhjiDbZ5EX4HAV+am0stO/oO1JF187yHkT5cgZNOqF8HBvxYDHzdKSZ96I0VJCOV9Rh92TjhfWhE4jlbKackaYUiglbYNbwhL6Dt0wzQG0ZDzNNaiazZZso+1a+zOC0dIGQTkN8H8et75T4j3BIsOQXfQGS3sHzVSpw7YzbCB99O3ZsKeunz1M7wkafjRZ/Qr0Zl0DYrImWoV5UvlXdRuTDfuswue2u0NBLU5w3dk6y6fCEZIZS+5lKfY5ahZw6GUwtgMhC8UhfkNA0fBkdqge+jFk19ZcHnWAhSb8zAOfEGX+EOr5Oz6ISujb+CXtCHGAGSoRW91MKcC5N2x7ENzXr5U+nXlenflNToJfQvC5X0XYEiyQqY67UlU1zyAkKaXea0uzUydYDpM6fbIth51wbzrVisUMlmlJNB9y3UExA1lM9PbXolmnsOnoGBJf95FhB0j9PMpeI2AHW2yD/i/Tw4pX96Mb3n+KhCk21cuU9lPHTqjyOrNvrRhhluYLiED8aE+GdR+hj1hiXgE9DxqZ5EAzQCPx7Bk+GJRhKhUlwRYFMjCvkxzMDQH9O33MuWDHR3U0vi92pvgWZGWRVy/OPlUzgbxruW1DrX59kSIhmgK8Dt+hwfmHkxGK10jvCpPQW393GI4cXsHv6VQr5DaOs8p0S9LfKzye3g4Fg6QFrKSQnVDXDoM3Cf7yKL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eW61XDReKRSTjoy8mBwu5wSnyeiyzQvR3k7jcHiy4wI7NuWkmiMRvrr71eqw?=
 =?us-ascii?Q?06ZE8o0USmayVPL9fMnAF8TfiJd+1D9MLCnGvNcvZKr9XsKlT6LnpMvyr+HH?=
 =?us-ascii?Q?OkTNcHe0STlQ9O7c6JHmjWcLTxsaFG7cEwGoyDwg8Gl49E9y+GkbuJn2jqKo?=
 =?us-ascii?Q?vPFwRE4q5nwEeyXYgRLAwFMXlMtYleNaLaHh1Eft1+lA45kyZJjKw50Su/Vx?=
 =?us-ascii?Q?UEqVgDCl1L0VGS8gL20/NsejgSBoPtTqeqc0r7tylKbrIcrYzIpHG+kRRSSl?=
 =?us-ascii?Q?qrrX1AcjKl4f6Nmz14RepvPxOK1UdnPD2hDGGnS3i/QyGcRpURzmETfuSaei?=
 =?us-ascii?Q?h0KZJhqLGxfv6J0vekm4OST/BmCwEO+PHsGCPsB73/rD/gfA7Q5fAoweiG+8?=
 =?us-ascii?Q?rUmdKzQvL/hKsSjXdYiJ9sYvQhVKmezhTobTi2fPOPzR06AR1kNu0czPC2Hk?=
 =?us-ascii?Q?RV3TD/DkjKq+aI86s0YaoD9VUacDE37tIhbEqCi4vmZBJgX9p2zO7IPtN3Xd?=
 =?us-ascii?Q?tGfYcQktKrU1qxneNKlLg0iT0eANq6BTziq4AtqJqtj+Bjw5605j/Zfg2NhM?=
 =?us-ascii?Q?HLgjrTPgEr0hVSV3/AhBWDYC5fImPMOtpILP1ovyfFVmOPGUQOGWDYyBkY2C?=
 =?us-ascii?Q?2Uk6eX7uHDqz0c96bVCEAfG8Z0tDjLuczfW5raQImDRjHNUKrWU2RQN/INhN?=
 =?us-ascii?Q?UeOL0NwRU/VPFU0HJjNwwlRyo/61EaO7X+bl/Qr2PuATCN9QxNUx2XnGRLAk?=
 =?us-ascii?Q?/8bOc2HpO13Sq8CMNXqrMHb4FdgS9JLIn8tPtFqxDg62u4kCwAQ0EIV+2ua8?=
 =?us-ascii?Q?6eZ17uJ9zJEqwauQVxdt1Ualh+JwmcivV7s8xhR69KdicelbTpFq+qTgxPkN?=
 =?us-ascii?Q?CaTI3nEKVCZsRIh9qjRg6/ZXhK6F+ntM0z87wK+lkRgLTn6x62LJbhaLnAyW?=
 =?us-ascii?Q?g2wl012bD5lzFUlLpt+G85azDnd22TMu1G3ukLa8qe26puSfiZSTJWS/d2yQ?=
 =?us-ascii?Q?cxL9sEDCtgJ7H2QLsw8y3NW2hanxNDOefcBltVZ6iGE1Lis9BmGpAi9e3qmr?=
 =?us-ascii?Q?ZmCVqbq0Ijguww04ivUa9nz6Ss72Nj/OlTNFt9ckBYQh81GwEldFzBFgln9V?=
 =?us-ascii?Q?0nYxRbrcVcbUguUYMOERClIW0+GBbKr6XdaIWKY2HOR/p3P57yymL1yhePeu?=
 =?us-ascii?Q?iIDwAZfrCEZjn/hXFCQMOaW3Z+yhv+Q/P5dfVhpV234LPm77PSee9Cr3ZmUM?=
 =?us-ascii?Q?H7px32nkXRggRL0Fiu53gHkp4sBdwgdAb9S7GRXxiuzr1SPvIHer7VUoUExb?=
 =?us-ascii?Q?pMdq+Ocr1hcQ43SlA0O7X6ig+4FyBpGFDZQVD/N/ATA0oI2DGxqreM9fRzEY?=
 =?us-ascii?Q?rcyiMd07HsJk6hY9Wa7bCwnxeUIlXA1khHzaCutWCZz5vhF6nvBvkND8zGxA?=
 =?us-ascii?Q?zAUmKe7qkjqXa61SJW6gNPU6I9tM13Zqnp9q8nPunsfhvz20kGLmMg8BnLll?=
 =?us-ascii?Q?xilj9pTyeA0BCGAXvhk8AtpswdUGyvvvB83LF94QLzVm0Dawxt0ohjyi/zoh?=
 =?us-ascii?Q?z7YPuLizi7XZbh9AEW61fZXkWYg34cLeHsCQIl/q/e8FfgNx+1XqqPuQ1a+i?=
 =?us-ascii?Q?PLBecYdtHh17EZm3o8uxtdaQsclDiC/6AaNOjvUdTtvy9FV9pMatxfl6np2w?=
 =?us-ascii?Q?B4SbuaZqSST+eOPi5XKQCDEGdPMNA27d6upjJxVUwBCF4miT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a4b89c7-dc14-4d35-3983-08deb41be7fc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:08.3329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 80JIFbPcF03EFLpHj0U/baQwUbJhWJ1rO+wZwV3Bqp6P8+uVWYISb65Q5NLMnTaK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322

Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created
by a FS without large folio support.  The check is no longer needed.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
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
 mm/huge_memory.c | 30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ed49e5d40e8f8..d055f53be8502 100644
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

