Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010012.outbound.protection.outlook.com [52.101.46.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDB6383C70;
	Mon, 13 Apr 2026 19:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776108065; cv=fail; b=c4f2ZewBMMlklQ9HsEJ+EgBFTf2rD1M/t+rgOA3KyexQB4ZE/aDWmPY2eer+6Vu0Q5sm/gmvmExzwpl+r3jEk4YPYt/TnDBpJ9DvrTZehA3HUYfDYEIFsKAhCoeRQ9QfQQRmS74teSFr0ouO+ZkLOrNG72ob1G5SkGp3/x6okcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776108065; c=relaxed/simple;
	bh=yh2fzdF0AibmOhFZkR4+wwDceiybTIMlaBsl+0vnpI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Mba3dKHz5gK7xotlvtYjP0FQef0r8KFKjSxm/iz3SgmDhPGbxBBIeo0lV7T/9rYv5fgYbwpygUfD/1/a80UbqVfGdyw1V3i6EJq1zWPNTtKcFCFUra2pgPrrS1aURQDPSMEEu3fuk2ZP/vViQN/BeErJqQe+YvVJ4phJ80Hpnys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dOjqbnmS; arc=fail smtp.client-ip=52.101.46.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dOjqbnmS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=upvGUqbZo5B02dzkX1ufgOPrQXMCt5R+2yGNM5vXhXSjTZVyu1GhKYd86rKgDoLRVsrKyzPkfE7K3dcqmJo4eAjSXxQIjMTcpNKKVAZQ0m8DmMyhB1uFRsm7PCRXYfSQQ5Ve2VvjVqF2noPjDCoFSoePZfVD4PTlnGURiH1BkY7KUr0mLxTd0oMyk7eDmoOeyawX7isqB3loQvrH+p75KnuiFM/ofE2eDhzDuTcwSxCzxRf63dCd6bmyuLPG6UJavE+sFgXXgzGqfCKyocDPtsiRL1zdNS/uTZJ1Tuiy6fPb8OIvIiuPXIWGowu6HICksXJWcDhDNgiutI9HRqggAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vrUWF7cM3Ji3HXk66NC+SyU1sQosqMDJgeX77XPYmJw=;
 b=HU47+pXHlkVy7wVecAiJiRWtz+/iWUrjf+yhxQQ4/qz0g9V0kj1dxWfw7koGGNG/GHycJFla9W+Ye5L2ksJ+UewNeOmVAoQ/gry/dzk6Z0nOf6WqXcLGcEY1zrDCeJNHGUdibMvEEBfdfH5DFJnWHtDMAiA53A11RuRSiTVc1c7kXDW4jUY74mLZ1cpItRUOqopL7j1FymEpydXboMDsE1D3rOL6UADvPct7afkEnYRK9wJP20ExyrQNev4E7uVxoy+ito2u1KCDh0d0WfaLKsrcvttcK5u7oI3ca8koTwbvIWtSlJsIAAPZNQgwEMrv657mY7pSMRPTpNM6MT1m+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrUWF7cM3Ji3HXk66NC+SyU1sQosqMDJgeX77XPYmJw=;
 b=dOjqbnmSoagu2R1JykeL4KjdTvjiwFgySLfpdjEJgnUI+WDLxxSoFwCS7d++q5xnJfPHApw3QxNAQBQ6GqB1Z3YipOQPWRfQwsQSlxp/JFIHg7pOYTfzUDHXhGZ24buJTvO4H9R/9x0gkVrgNu6Xir5jafE3K011VIJsfBLeEq61yaQUjYref5ZSIcQFTB9ycRurie1M8zIJD4lG1YYFb430CDwMB7E9iLFO/RJfxLGR4nJ2M0rXbZqcTu0OXYJj9Q2D+vkktIvhR0gU0DfVbbunK02QP18SvhvRtd+yyNmFCMg3wttG5c0A4G6ZMgFMb5Et+5TcKCMJXommqII1xw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Mon, 13 Apr 2026 19:20:46 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:46 +0000
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
Subject: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in hugepage_pmd_enabled()
Date: Mon, 13 Apr 2026 15:20:23 -0400
Message-ID: <20260413192030.3275825-6-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413192030.3275825-1-ziy@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0044.namprd20.prod.outlook.com
 (2603:10b6:208:235::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: e1226200-fe06-478d-875d-08de9991c37d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	PFPuMYbaqAxocRC/7yHOxeevODHBrT7KktWKOPAVGOA8lUM1+saYVOQn+Cw6v5eLEeuNSDaIuaGnnbsJkVkUcgqWduhdaIAJXgghfCTqQinh3zkAvvX/wTpCcX90Kh4F0rkJqvyOhsjgXybrM0bXqQCkE9z59r9N44Zfe5h5CIprUpGydtYnBr0PKkXcX+8T7i5ldTA/q8P8bmT+dT25qOwM0b+nGk1MctbtSlFHa0xy/F/BUH/iTK3zy27JWjZSmOxDMA4SWRGurCbE2UGDShAI32buvdwkCoGQwBlBUqHz0IMWcQUltru/cGNOBzQ+t3R9/RVQwqSXaor0LlgtTVCmGjwP9WK8cLQ1ZVEmR4wCaPjfUgu6GsKjQouoMs1/Ko8ge6uyE3X7Xs+hOgb4+Ox43s+ntnsZep85x3pw2/153xH1Jxm+6X4xZ+ailcwgddZronvkLS/tbR0abJEW1/I26TATpMQ+obT89NuGrlfaurLDuz8WvNnUTwC0hPOeFecrIHng7duOReDOSSmh+vThf48aY/vfFyocmp6qF1Eogx9EV2a2EW88IAFccRG5Gx8eyn7h696y0oYaioSQozQAeKlpFBaPjS7qPMVY2AkWsTdoRBdOhYjsyLm5H1SvXadD5s++/kRns8wU2XxqUinkhvc/sPPApoouML3ShttaNN6EBDfSvUgx7xEJbLJ96/w5aEoo1aFnlINuBIL+W4cJ4bBE5YKVDchRuXLOFXg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VX3e3EnWq7F4aNTFH8CLpy1zu+bXsIghfretDQ7AHHueKueE8lLPGmAR/1wC?=
 =?us-ascii?Q?zBMp+pD62dHrBuS+VaNXjwaIj9AUOZajBUfPrklV/NWEB86WRebPV1Ii8XPT?=
 =?us-ascii?Q?KgheJ6ZRrES6FFET4bbuwsHZtkHpUtJGXzs1O7VreX+AH2gq/S+NKqzWrVxP?=
 =?us-ascii?Q?08hyUMgivy1zUpKDVjOMAt3SFxMYvgT9WpeIUWn+nfGX5peS6/BpFPzNADtN?=
 =?us-ascii?Q?UebCo/evEunEiqvHbWBwWEofAzPz8+B1Vlo/xZm7jXksmlX2yNEnzlEIqC27?=
 =?us-ascii?Q?2UowAdnHlJGIOeh7ojn2rwlvTuMw5vIHO17O1UVLfDjs7oREqxV1ly3wz6Li?=
 =?us-ascii?Q?XU3FmBGaogh7eeJuhNlynh6tXyzcTvohSoqGLuREduJCCIOtkDeIrVAg80y8?=
 =?us-ascii?Q?rGgrySXCq7YmGrtdf2hz/m3spzikfGJnrHrDVAyWiTX1ffk9WJdsbaKRLPNm?=
 =?us-ascii?Q?ZhzdhAblmgACHE4CsI9vNKgQOfDtr/N61DQDIlpaZMkdHvtktqvs5+iSaQ+w?=
 =?us-ascii?Q?GCW1QUDHLWUL9nMdxvJsr1ZxyHOg5yIaEd8/CwX5YmCwQbgu9TLsrhKuuQbG?=
 =?us-ascii?Q?iWm2PfRMUoaKY5rm3qYHFMCeaZD9EPug4YA2P6ypEGX44Q5yJyqYYH6YfOQI?=
 =?us-ascii?Q?9EqO3DCsv0nq1rvj7DnDAKfPVA0Oda7Kd4GzSuGrTaxRv18FIf2rlcsm6vaJ?=
 =?us-ascii?Q?VW6To6NGdXb2swMTdDgWRJA6N69ErvAbzwfBlHlxsu6AafmGgoaZScGZMZ45?=
 =?us-ascii?Q?U8Lw8jP2TSZ/xOe98NUxqqAyX7CnKuI11di6qXkoA6ZrFo/vZ3QcgZhoZ8kt?=
 =?us-ascii?Q?D92Uu8djo3pHTl68hy63/3SAKgFjmv9RiJhIXo2I1/ytZ2guJ9WE7qgXfvJH?=
 =?us-ascii?Q?mSwNEPNuKrHgJoDwmgabASoZE5nyrxi+FwQ+Abn7kUOpFnAE/owtqv+/5yPP?=
 =?us-ascii?Q?DdC4JMtEQJFhY+ADMJPPLJSW2xD9oVLqQvgmZiXjlGerBqdgIrF15vQ0ilc+?=
 =?us-ascii?Q?wMtnbHVN7CTGStxInFpWnIXBoUX4IdaQ+q7/dLX6MtBrkFSJ/BLHI+AIqTNp?=
 =?us-ascii?Q?6f4GckmnNmVymaqPN6VXEqMWrD6b2SUaNLtDqg6jq19290ymzrppFkYcr+BZ?=
 =?us-ascii?Q?nN2UMeqezO8oqaEM3sY79t5nh3+eT7BhxE6iJ4h9n6/Yxse0o1OgqUmbAM2A?=
 =?us-ascii?Q?PbEIeogK4PlrOjNgF3T3jQY3JgODJpnVEG7vFG8jJJ3BmfF7xw7dOH/ivdKH?=
 =?us-ascii?Q?COdrkO4JJ+fsqk6gjPhs0RcL8zXzAj4TxMWdowtbQCLw5Khs6ou+Q+yQb9R2?=
 =?us-ascii?Q?lZNi/GVTtafp+4OAJbAXcXYK65ePi+zAUvNzUC0a3w6iZtRXd2hindPzgyza?=
 =?us-ascii?Q?6QNKrgU1rt+xuynQmCwXU8dWuQ25mK3zL80ZP0gQrnpIUkKOwAsCZT1p6MOH?=
 =?us-ascii?Q?2OALCoedBUi9CG7Y2TeZjKabBT4QdeuTMXMbEH8klIW9Ii/oZ+N/1DJ1TeiM?=
 =?us-ascii?Q?nnRun9i2Mov6ytwLMA7NkCejiybCobzkNEmh0svyPk7P2k+P1cacNALgTnCL?=
 =?us-ascii?Q?VN8qCDq95ZAAPwfhpATSJKNV8VyZ/gbxRrZMjBefVlOZ4nmM5gFvPAzrLxQD?=
 =?us-ascii?Q?8BzWpaGqQPX3UK3JBhwQIEB5ALI/FWF4llzJTB8psFLTc0NS9SqiRmsXgEn0?=
 =?us-ascii?Q?yHQoJlDjV7Rm+obyHsZQZCLA/htCaIGApeJle0/nGHmVF9IQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1226200-fe06-478d-875d-08de9991c37d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:46.3617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +wMhfmofJ7eQJzSNS3ZY+YViY+P8CTZLMnktUfBiaWuIRmO6oCSMUvnrh6IJ5Ihh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444

After READ_ONLY_THP_FOR_FS Kconfig is removed, this check becomes dead
code.

This changes hugepage_pmd_enabled() semantics. Previously, with
READ_ONLY_THP_FOR_FS enabled, hugepage_pmd_enabled() returned true whenever
/sys/kernel/mm/transparent_hugepage/enabled was set to "always" or
"madvise".

After this change, hugepage_pmd_enabled() is governed only by the anon and
shmem PMD THP controls. As a result, khugepaged collapse for file-backed
folios no longer runs unconditionally under the top-level THP setting, and
now depends on the anon/shmem PMD configuration.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/khugepaged.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ec609e53082e..79c985d7fa03 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -409,15 +409,12 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
 static bool hugepage_pmd_enabled(void)
 {
 	/*
-	 * We cover the anon, shmem and the file-backed case here; file-backed
-	 * hugepages, when configured in, are determined by the global control.
+	 * We cover the anon and shmem cases here.
 	 * Anon pmd-sized hugepages are determined by the pmd-size control.
 	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
 	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
+	 * The file-backed case is determined by the anon and shmem cases.
 	 */
-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	    hugepage_global_enabled())
-		return true;
 	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
 		return true;
 	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
-- 
2.43.0

