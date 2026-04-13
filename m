Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012028.outbound.protection.outlook.com [52.101.53.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27FE31A807;
	Mon, 13 Apr 2026 19:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776108063; cv=fail; b=kO2EfF/U8N4fs29XROxEbicLffBfw88o4SNmLcuXJjcDjHeglHxYzTXyZXZ2DLmscKji4pVt2pBBCEcl4n8qyIBpbH4IMh2jN3l3G4SfRWA69sBXVFIm1TleEPAB9FfbO5H5Q6HzPwo//Fu1qJboXQ4dbA0drfIRWjkdRkg6y/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776108063; c=relaxed/simple;
	bh=VHBnTE0WgNQiiw6RqY0E5R1Yl9Kr+DurXHF6Hi+Nwc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LFnUpWC0TBUd/B//As8tY1MypjjE/Yd2MbGC94m4QW/JaEW9YjJJZb17t1G1mrVO3DYNZekAQMNKiCWZCVaEkFleEENKrV8QiebOdq5RWW7/WqNHuz+2I3EpbWNx0fz4mz/cGnuaYcbB2VUXwfs//5s6vJtwR76D997uArJTq18=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TeIAjVwA; arc=fail smtp.client-ip=52.101.53.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TeIAjVwA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=glhUXnNZ5KGVw4ogruX9y5v2DRxjijggR5oQrXcheBPBbxeWH6DNu9Q1hCcxcpfmHGYat17O1bBAxDI8o8f37Oc/yBOKRaok/0FxycnXeb/Tf1Ci1UX5qSskpZWod/9CSBc0pGySd2HbJbRqdrTHKeV6Zsek7HuXUBqleHXsISY4IG7/mWyuL+lXD/k/GMb5SczWJYNwS58zzsrp1sUvD4vssbIIKjiGiSlCk2tk3SvYD1lxUO0z9/PKtVBH85bpGGLcKrCbqAtEx8hT2xCUO22v7r3abSzdTbqW9lJPz5160LggB/c/+J3RkUvhKVXIfKBTxUPcu4tj4qmAiZvyTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yActp2s80GIDcma74HmE47OX0r+m2huf1uabN+Ec8II=;
 b=Jr2iMsN56g+5Ih904UAedLNR+f11wVYYRSNmk+pS6VlE+YvKiVjsXAVxrPWfa03lh0savJfYbftj9wnv9nuns90SnpMPET5RsXETw8UzQdkYsqZGi0jTQP4fCn8qCGskBc0msW8yD4LGtR0AOumol4KCq7BlqtAd+4Ik3bioICynRfy8q7y6r9cYYTDBHR73O/YFv2T0E87+mFxKKqXRNrPHNlA7wjeiFNFNDOMW2VtoMtJHx9UOV2bAR0VCUJziQVgMC1ekeN4l1PKE58zx+vD96+2lqMNLkq7YQ/Gh2Y3JJsVpyqkU5docePo1ZjOoAV/prnbL/OC8RCdrIT6LGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yActp2s80GIDcma74HmE47OX0r+m2huf1uabN+Ec8II=;
 b=TeIAjVwAHy4rP0ZE06UoNjSs9oSmfXbqm4bqQ7e1JFTvi8frgluISt+P8n8SZnUqw43ETcPdszzhFIGrw+FsRepfNQRpdPAS2uoELCZ4ipqlOKefHof0ahM0+/H68sl7wpQCuYatbQAFzPZhYMqhmdJHiXYgLHxRoH3GXw7gcEc1U08TKB7eTpB3Uc0HhGDc7Z3ySkPxkHJxZ+mAtZVPugcD3xuUxYaPnC72E1HHAKtbiWLPQ6cFOFlbAknE60GPDzoO9j6RtsM0mr5b05XXo6rsUQ8PDiYLyDpOqSNuumV9UceyqrZLvf7aSdvBRNEAldwoWT6x9ZX/nf8K9fX7dA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Mon, 13 Apr 2026 19:20:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:45 +0000
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
Subject: [PATCH 7.2 v2 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Mon, 13 Apr 2026 15:20:21 -0400
Message-ID: <20260413192030.3275825-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413192030.3275825-1-ziy@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0188.namprd13.prod.outlook.com
 (2603:10b6:208:2be::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: 231d12ea-bb39-43b9-ae22-08de9991c1be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	5NDOgR4HwSIhGpIwHEjN4Zet6vchKt1HgYzDlpxHEvdrySg1WtSv53U7wFIWOsF4NKetKd8DEUbxLSPa0aQpItYtWEJHayqBBjBF3V7b0N/eLzz3pF3OJ8tXrgrB8UCaTt+JsEwcfUB/00KlGFIs+xf95mtD6e1sGqG1aE77wSLxPb3e8sb1EjQMGhCcjpy7z+1wfGA72gk7AyKyaXW56neWg2lkUV6d6a4ESs4i6XBT3spOiWE/RVD+i6Mhj6r1rS+jPypYXxMTU4bCHVTlsa9d8p0cPwiGSleequEVnGpmtFI/652PhRBVhIGnviFhEI+62Y6zrgEhEVvk70d9NzQTLvfVEpr3R5i2+T5VcZ4q9D2ExoTrZAOlTZ98sZYtb6cQ6A6b5v7kdImmSnOxw8aKtr8gQ8GI9OJoQP3rRLVlN4dx2CGvwjmMS0NkMZ/4pN/1RF0Q14JB48u3PiyrMa+Uk1twT+yTWH3PdR40F1J9kjJFN4hzZqX048Z7IPCRP4tTECLFDqYcBLND+EZICYrTRG/CMZUjzlNZNFQ5GfvHDJpNi6xdy6EnvRfd/DY2bNUbjGQiGs3YRuy/G0gUCDm+9O8zUJTU5oYcShlkNMEXYya/XaWakJQhaTwew8+//CUT/RmF5SpuSAezKI85+vzKnxR+IXRx4/8H32X4RZ/vXvP8sYMr+e32Jxi+0q1DxYSM67y8+OnNcGgqX+BgJoccgu+TieXvtiaV/Qr/22I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tLpAsomZlexGCJUb4FpCDdh4PAxBs2hV/df/ou3/JpkqNDrPBtEbUbfZz3fT?=
 =?us-ascii?Q?aeV8WqlEc5fUhkGecfrNXJkrUaRLgkUiCI8mOix8jPEuWQa55gQBiyIPHmZr?=
 =?us-ascii?Q?zcDf5JIjTvM47zj6QFXFiEnu/ueZol/eFT8v4xRpv66NQEzz0VR4KDrTshTV?=
 =?us-ascii?Q?BjGeGZwLynNZxb3W7PZCkQ59x6BKkdc/T88YlLGOrCN0dQ0ALJCQ7VkE1EcI?=
 =?us-ascii?Q?s+Wj8nYcU/pnVKXwDY6GYqkbBBLCkbmVGwl4HatR/iyb5OmzgDNzRg3net6z?=
 =?us-ascii?Q?7H5TsVuEGNlZHI6zR6Lfl8rG745+CQSIwPQf0KJWi278xVXy/s+dutEzKAYG?=
 =?us-ascii?Q?RNEHBqs1NZ9/A/fq5ULikxpYKxYrSWsO3IP3ieOfo8+m9PRJQS4CiULjO/Zl?=
 =?us-ascii?Q?FkGgCtUbA1hMOJawvah3R6wLU+jC5rP8mGTNyBxVePt5TQ0WLomjzFSqmXYq?=
 =?us-ascii?Q?1alIdFEihVYacZ7yUOrUvRSmBN9sDuI2gnXi2NK/1jOGfUgOwVsEWxh99hcN?=
 =?us-ascii?Q?rAK6WSEMoMJjwmEQvlyHlksdNFIpc10yQH/ghrQzKU9IAwQ1xdYIeoS7ENsX?=
 =?us-ascii?Q?jL+DEeMrPZOYcByvA+TbcYtdoqadHawuSBP7Aroz0cwcnLgE4xMxmBhkoVEo?=
 =?us-ascii?Q?Ij5n2+iMG8Up7s9/S4YKFI++cOur9gAkuT9Oeq/EWiUXerjytjJfEKpdtc33?=
 =?us-ascii?Q?c4LLd25Ch+ilz1D4BiqiYnbhE3PM+5jG0ZKu/EB6Y6BrsQZpiymonAAdYMMv?=
 =?us-ascii?Q?QMi2XdDTtyQePrno4gjq3Y/R9gM+j+vKdbIi82yBUNYZu5wnNxlZkVXR1x/F?=
 =?us-ascii?Q?hSZuyLccQyOwzKlC6hy/sKhLziMLh81FZik4hY7XCbditQ6HAsDKQktC2zPj?=
 =?us-ascii?Q?JItoMf24eiMC151tMSnvTb/OZozxiniFyI0cOnZ3pt/6u2pBccmyGr+2+J1R?=
 =?us-ascii?Q?wz7Yd92YpmnOyVd3wVxv4VPVvXK7P7TeRi7X7lIyeRU5F34+PMHML2WTJEHD?=
 =?us-ascii?Q?1m7P5orYlIs+S8UTGwUSghNqBqbvd1PajrB/UZqpQXxdNquHg90iX0LILPoE?=
 =?us-ascii?Q?chMLlBPWWtRgPhCo27nzHxuGQ0vRkB/7upAjDI+pHIcth+08Xl4UbyBNgrqj?=
 =?us-ascii?Q?0/NimvIarKHfr+KJe8Pl98NXQdm2qaeJcVJw3lspiW7oUrybD9DTGSwwq6bC?=
 =?us-ascii?Q?PAOTGco+7jjToTidR9zfjrojYPDLC8L2Sjals/hMNcmjre7xEmyQRmLtGznN?=
 =?us-ascii?Q?ukjCYaRwCJA7+mL2ERnHYk8qJ+IC/sWLgyNfp1auRo9JZq6mgQnFQxxbiRe0?=
 =?us-ascii?Q?rZDjAp2C17oV7BoHtPt90sA9G6MZlopGqGYnM+rGQlAoc58ACjTVIdhzYBy6?=
 =?us-ascii?Q?xj2lBGVH+cmGDhs2qNqlxPYbsRpKUMbBfoS0agCU+Kg6ADLQ61BvRKwcHKXb?=
 =?us-ascii?Q?IOUleBxDOg0KniY53gh4LFkSzRRA2sMIrvdiwmt+qjgbYKE+ZNMYDPBWMBjA?=
 =?us-ascii?Q?me9dWLZ2T5x79djBczYQDE39VUhg5YO+yP315nkCwzODzxJXstN9KPLFEe5M?=
 =?us-ascii?Q?ajb3HGGm5CrzRdFgsd3VEiPMKCaI/7R6QTyRrBiTLGYw7dGdkhN9DX/8+n17?=
 =?us-ascii?Q?f0pfv0MC0jVT7cHcZYw0B4N1UeZHSmcUhSERexhLojWC5urFT3p3XdsHP9lT?=
 =?us-ascii?Q?s/JpPkzfFz3kcZ5tYFLdaKQePVGouAD0ndJH0poKwr7Hjg1L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 231d12ea-bb39-43b9-ae22-08de9991c1be
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:43.4147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7XuUF5NAp9tPG+SubHuh0viIFdwM+vmXmUNtg+vJepDU0oYYKoFGNMLxmZoWV8Bw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444

Replace it with a check on the max folio order of the file's address space
mapping, making sure PMD_ORDER is supported.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..a22bb2364bdc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -86,9 +86,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 {
 	struct inode *inode;
 
-	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
-		return false;
-
 	if (!vma->vm_file)
 		return false;
 
@@ -97,6 +94,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 	if (IS_ANON_FILE(inode))
 		return false;
 
+	if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
+		return false;
+
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
-- 
2.43.0

