Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011029.outbound.protection.outlook.com [40.93.194.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76FB288C2F;
	Sat, 18 Apr 2026 02:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776480310; cv=fail; b=mKNShTKEMc69HK2Vv5iURcZx4XCYCd68YMgKRRQz5v3nHSXXLwRZjlGIhYvrlr9YqE+kAahJyICbOF+Z79eRYIGOgwKbuKjL+AUcHZsQbMqxDQrO9C85PmRKYRYL7fYjdQnWtMo6d2iamkWcHZe+lRqtQHNHShcME4N6d3FHWK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776480310; c=relaxed/simple;
	bh=coxrppTJGXWQDtuSPOtEo3pIE6kGyEkrBqiD1hCYffw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V/59oSpgSGvNfwSI27PAD7LJId6Uu/ZGiDX7JW4M29eq1cmzeu77rJhgyZtuLbWaVCvTIfUlf7qUpOW6V0vqa/dw6IK5xsrcF+/M3qVMwt+yXA6jz2yN11hVHvJzq3PAKo+DCRo1QY9erjIc6rl+mQCV6pVom83MTe7LRb/Ol8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZlOyRI5R; arc=fail smtp.client-ip=40.93.194.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZlOyRI5R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AA8LtE4mIhp4Mkia79/qsknw1a81r/OzQ/V9wU6wnb2w2LeUZMx/lpyS5t/a8jDlMeVisF2DKazarZ3486yB46BvwYXhpVGX+n/9PVts7f+/M7Y/qDBaOfdp/pbSNTUFZYutNi2Xq7hxTQ3tHNOI5rz+yfDgxv5P2b4qGk5xz1n30IGclcHem2Y3FmP8tiIikeNzrYwshpZLPy9NnP8+X77qZEhwlaEQH/Tpb5uXvsuHKGgvqO1fevl0P2W6REediwlRptHwbrp46q8S5z++rgeDc2cssN8YIH6Ms25lRnKhKDe6XUJo4trzKzmtoALY8tfTZF4VVew8zJ9vzjT5GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZBxyRBoqqiTc/WT41TjhmmTGhmo/L9qXeALUWtsfAxM=;
 b=GHGCUFeFZL4ke+EOtOFwQ4VclvoYigvvsjLUlrQBqgVpSRS5qsjjHGNUjW35XTUD2VTjwATErE2m5U6/92EEqxCjkFevRu6H3+lpNWFxd9zdSyA5plJDMnFfwe83BOERoThUEYB8QTtANqLHqcyUR1MyBq6qoxU6nTd8o21f0xjMGXVZlxmB3tna5PE3rAbnftieNCVLNSH7u+MutIC1nCwPjRYJELlGG2mNJdv8u86MjoTpFq9KZpTW37OZvOLZ+I0AT1odBZbPjG1/4YHPSv26vi82is1KcqvenYtwwTG648kOn5uWtFwjfbNi4gUmU3JyA4GZJeAvZ/VO9QcIag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBxyRBoqqiTc/WT41TjhmmTGhmo/L9qXeALUWtsfAxM=;
 b=ZlOyRI5RAXRLN1Al1kIMpy1SFfud6s/RzusJTTrA/ODLpE1xE5mZONjy2Y8H5pCeTdDsG/QtT22sPVP4//R4zRheJGJ1jX7UZkgxi+rYkT21OdQRCmFf+xaQ3Oxl0cEHolF22tNEEImJWC0R3GeeJYiRk4iKHmx1ybAWWowS56OzYRPI2BqdT8gHfv9Ioa0B6s+wC+oB/5lVbLRV6Qwhf0KxVbAu2H7N0RX1hWGOakSAcXNFGYK3pm3rGEsC4QmGt8KY0RXN2Yw/PN8b+AO2VQbbGb7dfTpO0/Y1IuxyOQ/qlteaXmKnNpDP+WlZKWVDPtL/j44AMhYEEg22TT5Wnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Sat, 18 Apr
 2026 02:44:46 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Sat, 18 Apr 2026
 02:44:46 +0000
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
Subject: [PATCH 7.2 v3 10/12] fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
Date: Fri, 17 Apr 2026 22:44:27 -0400
Message-ID: <20260418024429.4055056-11-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418024429.4055056-1-ziy@nvidia.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0024.namprd18.prod.outlook.com
 (2603:10b6:208:23c::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: 75bf08f2-002e-4404-826e-08de9cf473ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	2pvhhCHziZ2suWyeV9dQ8wx+Lh3HTXdH/w6jCMOtnTVN8DyM/7uNrfMvetKhVr2IX855y4iFdP+N3oEk6yXZ5sWCwGNhSgmE1TTFjyxovJ2X8en7aqtRi7Ne2fCM3eKuMajJil0V9vWyoZvfoJ2HEpJzal16yumAlHvSqnXTePyCsO2HzOZrvt2WhUO8I+D/btgxN31z6wGPoqO+HhjRKsguexMco3VzRlTtarGPOxYTfKQ7kFRVgr/dZ1XtXg1Kt5s3m+C+Huhk0EwECi9lIMUExjoxQZcSaCxTfRUrn4If2kOUr5KIECKOTvFf7qWS+c9n0ZJNOtA3LFaIcxu4YboTFyTyg3RPaMkQhUJg6yumtBHJbO0zN2matuJpqZUKeWbVqfA+WqUE0l9W0Nx6jLQllGKrhL/9xrWQQ8Cwpv00FSuOu3U7ZytvBmG7jaefBM6EkVRFF8QHrJD1D3fp2sX86O13pmEHRqaZUvsqiO4MvTOtColpIOJuATELtjehbajRjV/KpULgprInqMIFzGcGGttfUWmF7M3sND3ET2nki7xxrENXHeMs5xwZ2wN7rKp6cuw8YFEWm4PsglwFSHZbFgkZRd4VoiVyUvxVFfoFevQArlUhBtoYaIBssFglOAo5LOe6x3SJWekMhf2QxhzBASrSYWEMMBaG80RzDv8n/2hJB5VXQ42UQZx6vcoqVbqErhKS+m0cnXfGasHjsFcOYM0CyS4KjkkXCq8a88E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wCso1IMhwrx/bRxVILKvKVQiqHyskU7dtkjzNsq4RAKcZqBTHm0k9NEqwJdr?=
 =?us-ascii?Q?ICPt5UBYcZ3f7h/taBHSvVb39lxQBVxRRt7hBx+WXtNg2pj28U1imxOuk7oO?=
 =?us-ascii?Q?adFL8Cxlecf7scr99QogZVuom80sXorJmHPQYfdeWuVOkanaBlzJoBYnFFNf?=
 =?us-ascii?Q?SxftATB+HZKCJsVtPvHVqcP/Dcl11u0iv+T4qZNfxkqT5UVyIxrwodomvy3E?=
 =?us-ascii?Q?fY5epE5x/f38Gb/jAY74A8rnzGQTXUCJSYJsO9ti52C5e635qqrWCCh03Kzr?=
 =?us-ascii?Q?SqPsMWZZfHSNCzID0lnVb+M656a5fDaDsu260QDDigh68xHcXun4AAdnXzCc?=
 =?us-ascii?Q?Ed81wKp1qd2Zx7h1UVYU5zkDHqCA2xLdsrHavbPbQa5lmLGdxZfatJEh+jeG?=
 =?us-ascii?Q?noBWFeCEGQpTJivbB+cyFz9/wbnbyF6E0ovcYijWrcYwtOPJPaAjvgBLZSAZ?=
 =?us-ascii?Q?iosls9LXZmUf6LqEnTKVMogxVAYmKOvzFy+Qebd3FEDNcAzJwcTBQ4rd51ZD?=
 =?us-ascii?Q?O9MpTz1zEKQz7FmgqGCX3NF1k+Z/p8VAHKedVDIWxYrk1DwlnAwf+d0QJ+hU?=
 =?us-ascii?Q?+kMwVum61xIjxkklZaJqLoTrnIuNXLAkGD/inKTguz92Kk4Q60H80UZ3Q/aM?=
 =?us-ascii?Q?mFJHfMQmyl6/X8oVauxIqT/0vIpGcChoXXjvlbV27JHtyTcv91FFhVvr8SMB?=
 =?us-ascii?Q?qlCObpc12CJ8dr3Iv6hD7m3D58rVyJ4FFebsyrr1iin/5thkm+vR5gHTFsIh?=
 =?us-ascii?Q?y3kiED0JnsHrto+RPon6NjA/sWjpkFPNVezofsAV3oC4wewpXdMXdmLycjdv?=
 =?us-ascii?Q?nx++Kr1LFBhH2gzLm0/8+HLWoHeHPYA19wkhD3+bsJ8FoKb1pXAP8A8nB33S?=
 =?us-ascii?Q?hlbDk0r70inYBGJ5GGt151t9DQcDPRskege9ucGUngfQ1FL+MQsoDAsRIIdF?=
 =?us-ascii?Q?Qj2+d62XuCg50wgciLzoE/iOHp9RTrDX9qwBQ7TaqBekwYJRdk5XaJUSlUNP?=
 =?us-ascii?Q?Vdr1bhDypsOA/a4UnFAxgGXJwgLDmqxgNj33P3cNJ5enuANV5MA4NeWsrtUV?=
 =?us-ascii?Q?8ZsY9NEZy48MxohwnwX6qI1BMkyZ5cwFjmGbutEF3jzGDxPW8xu3lWibk7Yf?=
 =?us-ascii?Q?XMJueYH7JEHc0VqGTt8l6x5SBcHP4W7Ya2W2rDeCeOmgvWE42uwHRzcQqnpW?=
 =?us-ascii?Q?/y0K2SjY7l65Vk2ZWb5jPEnX8v/uN7PB7FCjQdfOQPQ76FjGQnLnRg8RXAU0?=
 =?us-ascii?Q?EnmRUyg6BT86B6BOPvLj4MjG9C06UbpqoY1kCCL0PlOvihwB3zw0GqCSMMb2?=
 =?us-ascii?Q?I9yuILKKs/nF1L4De4uo3e+EYSoCEwvzh+Lpy/U5jMkajXO3OdzuUEJnDE7w?=
 =?us-ascii?Q?tcxtcbYIs1umz/EoMQ2sko/HONsc4rh3r9otz/xfmtBG4W6YgMSbfy0ZpQOs?=
 =?us-ascii?Q?xoCYeGvj+ygROgpm3OSAlLma8IfaZ0AXLZmtb7gEBQdiyDyRnjOXWHtguq3M?=
 =?us-ascii?Q?ZuNWZhCOiIC1Tka0XWi7aCAKYXeMUve85UfLuxm66gjGuyJM0RxIOFOm2Xbo?=
 =?us-ascii?Q?wwpR4/CTNbbaKqYav2D0rGQQbgsrbH9vuSGOfo6EulxA72SmSGnPwcbgvk2s?=
 =?us-ascii?Q?fwil1q4/XwM8Zp9rNdfNXcIV8ChbDNCp1p1kiutjukQcsFOevdAMDu5ALFPo?=
 =?us-ascii?Q?Zz5/YYvtLhUPmcvrY6rFsG8cPZK/BtOOMmBpTIFnv2t0Jss0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75bf08f2-002e-4404-826e-08de9cf473ab
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2026 02:44:46.0993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tpQM/K4q1CcqouvGjZQuvTvtxTfr5lAgDfVk5qstZ2JcmZ5PJAUWmGzo789OhS1C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650

READ_ONLY_THP_FOR_FS is no longer present, remove related comment.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/defrag.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 7e2db5d3a4d4..a8d49d9ca981 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -860,9 +860,6 @@ static struct folio *defrag_prepare_one_folio(struct btrfs_inode *inode, pgoff_t
 		return folio;
 
 	/*
-	 * Since we can defragment files opened read-only, we can encounter
-	 * transparent huge pages here (see CONFIG_READ_ONLY_THP_FOR_FS).
-	 *
 	 * The IO for such large folios is not fully tested, thus return
 	 * an error to reject such folios unless it's an experimental build.
 	 *
-- 
2.43.0

