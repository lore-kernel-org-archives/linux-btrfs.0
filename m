Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010012.outbound.protection.outlook.com [52.101.46.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6663B3E4C7F;
	Mon, 13 Apr 2026 19:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776108077; cv=fail; b=CU7KEVjLIOWSo4HDFJ+Fyfg2s+lYXG+tp8AUkzIM06jlFI84cExPFK5uu0yawLiicByZ9Nn0PykpCG6eoI1/qcL28F2fDoktkHSjNufAd8zHdAy3z81a98EUVLJT2HiqPui7/Q62QBVylN0U0b3etAQFzfZW2eawYIfxUnjuxdU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776108077; c=relaxed/simple;
	bh=lSPfCbD2yvDjg0xeuJm643jvV0dHdThI8TgrcSoET94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LUc5HrQ03Bjmdj426PWluWH3RJ7LeYe7XXFcYtYW5Dc0IJl8xg589u3IQJmfipnn7R3xXQBPHnhf3P39NrTxi2xv28y0Ulg2AXt8E0cDN69I9y3f8atPgNy0JYCLExQ/SUgeDCnWZNA0y2YNJtp29ZQTWpKEyFIOme5JgdSDu+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jqPCqaGN; arc=fail smtp.client-ip=52.101.46.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jqPCqaGN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kqXeHDOpVXCTk6vHNVdWzcMOEHmnzKvGvIvTKPs4RAVFW2UCb/B8ACx4tOfqzc1OEMgAMTVRPgqVB2wRSbjGJBh789/3xxWEIV26JWT1pkZjJg1f3ubMHB8LyKPjD463T3vRspKqSjORFaJUzUrHF7haP32GuyJe6X2bRjCKt0Pn/QOq8EWfwy9GqozTC6p/W/tGBmZwrzjCzOcVUKwkER8G+6rwalqjGBp3wYP7TDTRHrbt9GYuLpO4ClMBAo1t5pJmNEvKyw4pqcv2FHUsuUfNZ8+4UfolnPeMv0eei7r1L76wuNuBpIdmzus5K9bFynC7jcodzpM33ZRGulFI1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BoBCnPTeqfrm1QRjZz+gi0AjIAZR252PiL2hmCWGEaY=;
 b=oVsL5l0PmwormmoM877WeMY/BYaZi5uPteMKYxYqBdss8vAxU0ZQn+1J0UeigPOyCMBwkvIr9AARf5PHvkAwtWMfB3Nbrexx9ehJJxvb1y1Q7BzsUCPbbdoqniLAQaMaUrMrrq7of+xoy3FDmvTHt7gM/t+w76CppgaD89+Gh/j+sOlVhxjfgRPpOS0iN1N8dmu9pigL5CFQNZjQCwKP5e8fWYlauIQwqNixL5Cf5kjwgNXZuT9PO6ah+/n9WkfreLCqeCjxG4tp+dWzEavgaW1LSchA1MO9z1ktr6CuPq6Ocy7WLWQXEz5keTW07hXW8z+IhdikmXdtOZwczC0Dxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoBCnPTeqfrm1QRjZz+gi0AjIAZR252PiL2hmCWGEaY=;
 b=jqPCqaGN8j2rL+NVGPNsWL+SQDZiwK5P1pXUptn0gKCkASwzLigD8M/Llh882rw9oXfJPO28oUHh1k+l8w+6VzdKRWoXwPuKaTXMZMIv+r6El5vebAykXwdL3XWu/siD5lwJrkNLFTD2AUBzaXfupSw46LPLH2xLZFp9fieFcfq+eFNA8/6HGj8laRHBoBT3WoSxulDh5JaKVH7PRWfAUr+7nkXvl2pPRgQXiivLiabc0CrKhNnd1Xs62nuIjjF1l0htxE/sI5+3oYCelZZxHlptqkKh85M375k4b+l3gMNONogwATkc6cui/RHQJ4Nk+TzeBOIPJtV/TmTvICf51g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Mon, 13 Apr 2026 19:20:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:56 +0000
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
Subject: [PATCH 7.2 v2 12/12] selftests/mm: remove READ_ONLY_THP_FOR_FS from comments in guard-regions
Date: Mon, 13 Apr 2026 15:20:30 -0400
Message-ID: <20260413192030.3275825-13-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413192030.3275825-1-ziy@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0291.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::26) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e95e092-29a8-4c2b-35ab-08de9991c989
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Zscl4/LgEGzPrCZJSbRaWK2vHOPlV5WBNISOc1NOmKOfS+8EEdUAkOcZgvnY8yCxzlYf8IH8URUFixBzyGQMNUn0KtGqJwfw+k4jHdQqQUd1nsBtgWB8SwhtVRMyURTvEs49IObnHLl6I8vCtGSbf6bV1L0f6QG4XQdNpN/H6J1XKWkw+nHvtc8R6Z4m88yQr+FU0x83LV4oLOigFBxSvg8SvPJAqxjyyuK0XtrCFTrHow+O9+UluVWCoKto3bDLHxBrqxSK4t9nfxygvm+lxKsTe5rfNFfIsllGZvLEk4lyQLO+DLFfrVWVX+DVLICDLrPZK0Bi1oDuURb5FN2fjqnyFhCmHU3s1mmnOiknL9fL1JLSP9Mky3InIK6ZmVN2hJSkbl/XkWx613ima9sn7mB/CX6D+sAuNm0JSd+jtiuiZWlcFlrurK96VM1gs7kUNkeWMAuZY4+j/A/9FuFympvcxrphuByGonQn4THkB+yI3RWzJtUFDGvuiCYbi4xa7XhZ8WUfAiZwQ6ZTBrl55K9HDDU2rUJy8jA/yi3OagE0Mow3RSc3nlfCeHXFlCOu+TjjLqrgsxXO90D8Oh5F6OkGyNYusEKbaz4R/beKlulnCuzfNISzWDgOqoTXOOWB4KLDXORrkMcJImOGBH0olSUGwRRlA18woG6piwE6mhesRL27x2PvcQ9jN88DCEAPrAPqRhqP+p+OPvfIeyTSJje9JV+wogVJ69i29r1BCjw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g8qvfWn1QpNvII8JjI3UtZGPWwYKhrAFlMqV+uEhwKX1rWgqpv0paf9WFiIt?=
 =?us-ascii?Q?pKA6zd0WaDoVLuetp5f1OXd7dOtCa7AqsCAVdCxPvpNg46CNj+xW9VfcjADv?=
 =?us-ascii?Q?FaS5FQVwWCrO8Qf5FMpfC9a3bbFqDWC4MSNzF0g2v5FnMuNl9xscx/8m+pjb?=
 =?us-ascii?Q?uNkk24AD152310eZuyUOju6HSJP8lPAp0PUgaTHJVq7e+KudKQCjjMriCrwm?=
 =?us-ascii?Q?/9b85NjOlubq0yD4EikXKEkgYoMlVQJV2vwR929L6nIbOnKjtJFGL9Mnz6b8?=
 =?us-ascii?Q?boq0ikZ/yMLwdi+KIbNFRxcBtUpLoalhHh4WYI9crEJyWK0wgjRM/j16bbln?=
 =?us-ascii?Q?0XLpKtyYmG/uKIrDkH25LljJN2dwlpWHtGb+dlE5BDrR9cZcn2duE8HZPeEz?=
 =?us-ascii?Q?f4xk8lVRhBIzXC6y3tdMO80Ene54WOjfJ/akwLfgnPdvIJibBP7aP/jxOHmj?=
 =?us-ascii?Q?kar+UP6E8jVKK79QKYOuXZTIOD8V4fGXWa9I14cKIFBLTBD8fghRfUuxc1tc?=
 =?us-ascii?Q?si6G+3j7e/cuToukcqJTcwQ68hqBlv6iUwvk4OdawvUEtnEl3Wow3VM2dzXy?=
 =?us-ascii?Q?TdNpht69nBYiUm7DGqszFFbjGAZF0IyV+Ja5KfhMrMBUnsJAFyfa2OpS7hdK?=
 =?us-ascii?Q?aPdhDoJBczV6OtGRzjoJ5/EgTM7T9iaOCCFMZo1Me5BDGe7tjEeppGYQ2f87?=
 =?us-ascii?Q?Ag5r1AzBkE0dvHl7RbE6WR/kSzEs60uOWZ8a6pDRKyNoF/kxFo2uadPFr9Ya?=
 =?us-ascii?Q?Wkk4ox0klqck3/eFpNcW9U1YlR0Rop8sHg+2h3zliUekDZqJoDb5hIv3OG/s?=
 =?us-ascii?Q?RIgLhOB7aPfLePEnZoK0txNGwO9I/vRP/R/wxkA8vMc2f1zyjfRAdE1TqHld?=
 =?us-ascii?Q?hoMv+T1n/cExE7VQMLKiPPXDqwalCytVWeLFmZ2qMDn8e79oKxNomtt9HToi?=
 =?us-ascii?Q?2/pYMZrEtZMdG94mwVzuTyfhm+DmhB4oEgM2E7GU35KxKt/Q3dPHoHbQvKYA?=
 =?us-ascii?Q?aKC7S6wwGXNCp+iNiPUHiHFwfJs1qp1uq5kWY4G5df7LkQG3To0wFTIJ27Pn?=
 =?us-ascii?Q?9Cv3nj2yhn+gIqfJFnUiN9llDiAtodawfyE0yen5YRjE2QNC6HeE8q2jmufU?=
 =?us-ascii?Q?8bw9QPtFxlF1Z+P9pc90nAeyUG9pYBAEoCmB3zBNCbxqcnQ9x9urjxVgBsAu?=
 =?us-ascii?Q?Urr+rSzyi9c0rDn45i2Ntyx+beu7UTtQQTSmafL6iCJBmE/2APwojrr0PhY7?=
 =?us-ascii?Q?AYVD5Y5ZB5B1Gpw8LTqjFk76GfopTEPlUSs8e3yHcF9OQJLhZ05Tb6NHENiK?=
 =?us-ascii?Q?yQSQQrhPT/KUgF8AYK1PNpwDdm6X8Nko4NTBFhorX4AV7nGoHuWrlt1MYvVC?=
 =?us-ascii?Q?z5VQDn+twQy+x54Nm32OwHtHtpD1e5Q4JdW0Oy1ob6wEXU3Nia6cPRtzTGgr?=
 =?us-ascii?Q?cC0yvwqXad//dia5uDTVFLzs38idhYMMthLQtCR50nO1NWkYTF/KLgFXLbZn?=
 =?us-ascii?Q?H4GwJm4NVf/qITN78INTYtJ3HD/7LMR+Qr4aeEigQp93ru+/ztcMpZ3YXOjT?=
 =?us-ascii?Q?Tvjdrc7cYbm4C0hxCPDreFir23+yyRnYzJkHEBOaEr+QGsFmTPpnTJZjtR4G?=
 =?us-ascii?Q?f6CAzZVgl57bmE3QcXiMcs6T+gawf2tN4QhKYeoygH+9F8mnzXk6rDFUqN0D?=
 =?us-ascii?Q?0m9sQDxYv9VfOrgsPZ6n07sNZuOzCpXONUhpC1j68k3xOzqN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e95e092-29a8-4c2b-35ab-08de9991c989
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:56.5524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2GR5eSQMyQ5i2AQ39DFUYEYI/S3i31Zji1txd+Yvp8hrWGRNTGL5EcJpi6tp8Iw+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444

Any file system with large folio support and the supported orders include
PMD_ORDER can be used.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 tools/testing/selftests/mm/guard-regions.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 48e8b1539be3..13e77e48b6ef 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -2205,7 +2205,7 @@ TEST_F(guard_regions, collapse)
 
 	/*
 	 * We must close and re-open local-file backed as read-only for
-	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
+	 * MADV_COLLAPSE to work.
 	 */
 	if (variant->backing == LOCAL_FILE_BACKED) {
 		ASSERT_EQ(close(self->fd), 0);
@@ -2237,9 +2237,10 @@ TEST_F(guard_regions, collapse)
 	/*
 	 * Now collapse the entire region. This should fail in all cases.
 	 *
-	 * The madvise() call will also fail if CONFIG_READ_ONLY_THP_FOR_FS is
-	 * not set for the local file case, but we can't differentiate whether
-	 * this occurred or if the collapse was rightly rejected.
+	 * The madvise() call will also fail if the file system does not support
+	 * large folio or the supported orders do not include PMD_ORDER for the
+	 * local file case, but we can't differentiate whether this occurred or
+	 * if the collapse was rightly rejected.
 	 */
 	EXPECT_NE(madvise(ptr, size, MADV_COLLAPSE), 0);
 
-- 
2.43.0

