Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011029.outbound.protection.outlook.com [40.93.194.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA9133F59B;
	Sat, 18 Apr 2026 02:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776480303; cv=fail; b=AojUTQCdu3x7g3YB0ab1RuYgu4NCY8OOOGtW2dmsxjz6fG4z6ED0o76fxw+GR0RMKez2suFSEbH3E0ACIML7seCIjcX8Y6l7NpjMq54WQklQyhLRb6cSxsIZu7jnFw+6TvXKGgwsjMnErx3sLQ2rTWWZhBre05wVrc5TOM+x7No=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776480303; c=relaxed/simple;
	bh=GtdJ6+CP/rLrU5rAlSpLU34S9q36qlw0KJLgYQYzLL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DKi/UGY3n2yB9dqc/Phd+QsGBec+lm308PbsA+s2r5n3LKnhzq/hbzEoiJUEDa2d66axVYlXIyXTwIiAIoIaIRxdw9minTXtpXPM6AYll63Ef5Rank9NArMrkexAhHVbDXf1NyQizZwONawnar2JXmCef2Zeo+YIuv0Bxb8/ySo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IbI9eG6x; arc=fail smtp.client-ip=40.93.194.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IbI9eG6x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a14C89D6BNSKQRZQrIBstAQ5oHvch1gpdE1yX1TZOv24NNEqse8g2rdZXeoPkmvPalsyEqNK/4k2q8v9YdFU//KgEIzLxFqtgLLQUG48XC2Sblw1UZS6N/l2d/BXXXqbrBczTnxDl32idX1+tTRJZVFdVdcUkc9N2w0WaKagmre0MthwdzVEmpwSmXoVp3bl7hadJ+97sSTqipTO0o0AmE0Q41Z4DhWNm3FSrTf9LzrWolDon25f+t0cyr9DwC15mZuByPBwUUw0fK+AoFWOmCmsTu4A9v/iSLbRCnbB1vuUV+pdCRiB+kh6domfTYs8smcV8iHqfTs/B/pVmRxboA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Uya/5uPLX/g/QpyOR9eNRukSrgjWHsdm1y59QVitao=;
 b=i7noZ1F9NDdmOuHYb0RW95A1S36tfNAL7pzXOSP9T0ui96myt6eFKHXl9dKzagya1xoGn84Tm6M8twnQkwDaG4dT9FyzhIbijmlNex4MEtwkWRWtasetk6lceYl7ingG7udj/3tXsoDybI3Zw+3v/eC39Ec4iA+eC8nRHs7auk8jlmNMO+AT5Qi+yVEBwjUCfCfR/imOUh0iPvGp0cBRAn9mvxF59sP+VJ23MgD1Y2MnunaYE/z7cgGaYsKGjhg17+feeHYl2A7DQX1niUtKJ5eVdvNc+i5aRnGCc8RTsW3YVBaMg6kIoDsPkY9YJnfDbQGLZ65mPB+Uw/rhuyS8ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Uya/5uPLX/g/QpyOR9eNRukSrgjWHsdm1y59QVitao=;
 b=IbI9eG6xzMd4smEdfSrpLFxTwcx0RFMGqiGnR1FHnW1cLdKQElDJDe6CLT5BUpm1A+RQ1B6UEWqEKA2FCQj+OMrD9zJPZl2oBXz2inZ+BZIbHDGNMVoNCLHI6nxMXcUNKKsrMnF0KMrMmS7qjt1qewgD2sRKRB7Tg1W2Cnt6tT0f0ij5V6CHWkdalpNabnDpByhB5ZeIVUgqRFoSVD810TBsvG/MWT+26aFPAzZ9UNoqOaiKiwrcFA8EZjYGgkzkoDk25H1KJlrhoF/V1eZb6bYRy67NTM19BC6aWk7HQP3PZFNGxzTHz7Np8IOOKpK1W9cM6nM6l8c8OJoScyp2xQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Sat, 18 Apr
 2026 02:44:43 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Sat, 18 Apr 2026
 02:44:43 +0000
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
Subject: [PATCH 7.2 v3 08/12] mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
Date: Fri, 17 Apr 2026 22:44:25 -0400
Message-ID: <20260418024429.4055056-9-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418024429.4055056-1-ziy@nvidia.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0156.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f9c3309-940d-49a1-24a7-08de9cf4721d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	mbtrDq43T9xNApnGS2WYcqiYivqaqfyJ1qnyo2cTmqieYuxFYB1hy6aOQA13pTAK4s+6+CkbObzLfwUcZmeDh4zf+97TzHAwVNZ8sZtv/+13zOr8JaXzNB3teOEHOuNwKRcMdGX6qVFirrgV8gGXBLAuHuFvd9BaW5bZm+EvD50GEuhcHiT+hZ4XLAIlj/cyIkd1MGp/mG6STlt/rj3+aj/6+oWjTBZZJH7v+K3DwH8iQskpygQQQ+qsszj7FKrBOkyFdwVN+ClpCWUWgdd7iZwY8oXS6xprbztIBZZ8aEaUeC7QIxuQFV8PlT8R3vsxdRUQRMhFgbPX2/xPqWMrEuF2Jk/wyPHGRLfR54CNYwYdAXJhhy41ofmKqKOJ8jQjkyz4QXU08awpU5zpjgz9wmE/Y+s0Zw6zE4rhQJSVbt74Po4bt5nmIqibhSgzAN03Bx/iKRL99W0voF4W/SKC4q9IAPEkNbM4R3JXyQvizBjD9L0Fm6WMDcPlsyc5Ce75HeJBfWcj6mU9rU03Ti2G0KEkAX26Shns66zho2NGvoSv7AscXS3PrhPRLi1uB0IH4oeVQZRSHAlvWlyX6SGaTUYLrowLqEhodg9FvnHJ67J8cUY5hgN4/3snfAA84hl+3fXgIf5SgeZo3cAs0KuVYSJpUH2VEu1b7HyrU7nq7jnLLdoJ8UOlRiFX5XbVWMK2EaSonS1edZZ73ZiNQ5pBhtgE3fKI9IIJk0NK10dbkCg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pjkD2Ry4WydSHrkm015p9d8ibJf7EwdzvDlJ6M54lwFtmNypSSImv1cvtRfP?=
 =?us-ascii?Q?65nzQWx2j9I3pGRQfmYNhIE4B4VJpIJA02m7s0Q9wa5NEauioESLpoftT3m0?=
 =?us-ascii?Q?EA4LDeAFiNjpFSG5y1Pyk4TDgVZgb+e0xHbhgqwz0Up8M2T6E2yIQF/Thvwi?=
 =?us-ascii?Q?mljnRm4rx9gVDFGQFPNflZPbhn6GNN5ufj48XS0QWs45YrHOhVrTCiezxSOV?=
 =?us-ascii?Q?peu4yAVWidAj6i8SfJwc9AicFl72vyXoJMM8u1uSRp7xYS2euMPioEqxg9V0?=
 =?us-ascii?Q?EeM3MYI8pzGeUu7W40G/IbF0bP4bOYibYxWhH9Y4j00UB0XNIkur3VEpFyh0?=
 =?us-ascii?Q?yGEcvkY/Y30pLYo0j2DEX65PBopZLFuj8N35K9wQaipmtr2nCmlmCavasiK8?=
 =?us-ascii?Q?ima8O7vUd4fPeIQyl+d5uIHoWcFWIi2Ti+kp/1Nj0AS7R3mIsDefeiPxf3Zb?=
 =?us-ascii?Q?r0P78LhL7jSwfKZqBEbQrBz/AfVRLfhJuEBGHk2u7/LT/8DNcDfT3Y3ODYn2?=
 =?us-ascii?Q?6htDehu7fwzoeZnKD3uYwMhvkEQKnzwC8SosUWcD71BAv/jOOMuTmVpQy8zu?=
 =?us-ascii?Q?y39z3ClKQUJGOz5aWEULxaEl22CJLqv+7BJSiBmFQwgafs4/A6bLdx9nXyOk?=
 =?us-ascii?Q?YxStGdlPJsRhNfXqriHHxEoh0pXa//z2EblpNsIv/kmIp2GoScLGDuYBBy3P?=
 =?us-ascii?Q?7U7eKXsMFxUW1A3IgxLoEl9vvPpz8C3tpvNDHuzo0VoT3WkBs0hqdrk3Zx06?=
 =?us-ascii?Q?Qcp82jlrKB3Kkk0FOYMmd1DXKxt34A7Pwn6955JYbN5vELqfw11qL+/7kpgf?=
 =?us-ascii?Q?uQ/wYCncz/xsaqYV4QfSIZcBzrn9Z5PPNd89D4zFbIpdrjWpDXc/xE7RWH8w?=
 =?us-ascii?Q?GQAiJhF5ANIYQIQ6ngGDRLRdK/srC/8IG5lK0XSakf57/649Owomykkx8WJQ?=
 =?us-ascii?Q?HKXe02javIZ1EhrrhF1eaFGIgR2LeLBVyivdcjElv5VqdO9dLWuZUM1ZUgWW?=
 =?us-ascii?Q?V527S2pYZm/en3P7uRThxmtYsh2wBIsZ4Oh5NNFw0saf4zUVKFqngulTbf1a?=
 =?us-ascii?Q?3pgMeIrLy2omE6QWMSscgDFVwlpLqA0Ohk74127azWAcBM+vnyHJyiZDHHWo?=
 =?us-ascii?Q?gFyhX28FsqbuCaMY4a/1vprS0ybgshA3jG2REVduhCYLq2ySVUt11Ff+9lRO?=
 =?us-ascii?Q?FLUkeUHXs2CGKYUFg8WbizUJ3rPwEtoHrIDntZ3gA5td0kcLHjh855p8XKZW?=
 =?us-ascii?Q?c/pBPsaTXZUkbgxJk36ftkkJ0S7S7v4gdG/2DHVt3N1OpYDiumW1J+mA3ovp?=
 =?us-ascii?Q?JB9K6dJaL00iKPHgUPGy4TVgL/MwXAt7j/f+cKBWFZTDQFgYVZMfnN9VOzZc?=
 =?us-ascii?Q?wY7g86uS/ZJRqJqXYBxd2YN+qNW+9/GoBkxA+upJx6WB66oZ+yqW/jWjzzGT?=
 =?us-ascii?Q?XbZEeJYh/iLgsfSmqyP/z9xocq4j/LadiS/S6MYGx4ydnjTgrNz3N7ZFwZiT?=
 =?us-ascii?Q?mxrUsvEYbTiLPptGlt3havJ3g+dMN6AFJ6m6ehbYaMh1a1l01h6X/hoGpSBZ?=
 =?us-ascii?Q?xazZv9mDbZUgTV6KGsFLuZpWljkutqKboSV0GFUHDM9F7d26uZCnH3gH0k/D?=
 =?us-ascii?Q?sXW53h4AQhRWopI90UpnObi+bAF3vJCVAUWIlBAUU2u03aMBHGxgQTmUDvP/?=
 =?us-ascii?Q?HznCAuH2TSFJPOAfCZD18QWaosM2bEWiN/zXB5B05RGipT3M?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f9c3309-940d-49a1-24a7-08de9cf4721d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2026 02:44:43.4538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t3Y6HbeinbJUjHCdiIuSuFp35OiAzxZi5hFIeHumiMHcCeUp/VTSJ0ZkX9D/L2rJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650

Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created by
a FS without large folio support. The check is no longer needed.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/huge_memory.c | 30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3a310f1f7177..a1eebc8ed105 100644
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

