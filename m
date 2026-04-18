Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010067.outbound.protection.outlook.com [40.93.198.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB3D33A6F7;
	Sat, 18 Apr 2026 02:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776480296; cv=fail; b=GxrJeh+Vfvetrosb+LmlTNzj0tx6UW6k0lRVojdGQVNqlYlkTvhV284knvpS6Xt2WtGQu5FlzwOvDGfd+tz3eqstksl+6B1lcsPhtc18Mqx5QLjv43ZcIWllHzha0MSprDKcUNMKa0TT5gClHz2bUBwqicSHDRG2ZW3kmRiX2v8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776480296; c=relaxed/simple;
	bh=FpWZQtdGj82eYcS3njWOSXvN6lzqQp0QzsqltdMPBZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Iv/spVoJ9FxBLTQvsIwScJOCV4BE4nqJKjR1OuUGLWfuPRqTSxwHDhiVsLv2lA7g8oey4zaSbGppCgnZ1Mnqp8csY+F+2z7mkU+Dizjhi/gnpbvJtSJne6uV9PNdc2mexxcLcn3j13IiSGJVzTbZF2X7/vbPiXiGx09dtguGqJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Owc/ifuV; arc=fail smtp.client-ip=40.93.198.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Owc/ifuV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SJuAmyCBLiORbGCpr50GX4MudeizH+RgvVKqsWm5h5ZDs9U6zxad1jwi/+Y+YVoH6FyoyKH4ACnPhGgtzG7I6MUepVljhgIiZ3Q9vGpOBZ+jeJpF30h0ObTRbFFvOsFgBkaexZA+Ug79hPMwn8m9GZPkHBsc3rjEw5yy2QhM8nHig4T+Anilf4DeU6ei0raCAsoaNO/LVp6SvhupURg/xNjKeJQhycTd1SWRmQD2EW53Nxam1qltCCknvpAqya58n/CftLFsOm/3qhxrVDWooyW8K54TOfO+gcmlRC2AvoXrz3P0hV3v78VxSPqcCXBYGNmmJHAKUFoau3gmomSYZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r617oYGbRhQcMzcfDyU5E5V9AAOVEsBjpi/q2Rr47AA=;
 b=wUxJVCSfSogQ/vzrFmbyDY8KJcD0p6BSR1JuP4OyTMKbrl9lqFZBSMMZxbuk0fYN5XAMZhlHLbTnCBOQKPGplhefB4HFEwJkIdSQPnZ9viO5/Git3MfEu+G6slMZN6poeQOiHP6b/MEJNq+t03H/BCDm61ap+DeRokmCLMTuTBCTbQCiSsIQ/v9KcQBbd1QDIEepteEwaQongvi9qZFSimjSYJHgecJzeyQZoQyJneJ8NUGRyP3Yu/XAf3Jtd4pRgTo998l1E6+I7YVPC30RL5FAVCzcoJTY5TIquUkz6EqDL3vl2s9kcuFIC9xtjRQQT8dsUObhTya0/r2Q8l9xkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r617oYGbRhQcMzcfDyU5E5V9AAOVEsBjpi/q2Rr47AA=;
 b=Owc/ifuVsMzb15OsMHrYv8vnbofDOC3wLW9kJeiaKBLt2cafo0gCNp5+t5e3JBeQuu5VSuDWsSKGUkyRD+2PPvtzEQsTMUA4WxdgjgUNIQDi7th/HDwW5A9H2rBHgrUOJmA+OkM4karl4Pfmkrc4vmoGxO1gqMRSeLvfQCGeNXUU6iGcSQLTVCbuj94VdG8idil0bLNYbO1v4wtwUo3iFd9fIPVeodyw/feDMQDVvEqUp1a+4XVq0tRYB0p7jO7VYBdYKorRrTroadm9lI8gpeM9lM9wLTaS++Pe10LsSnS+B27VYcZoqBp5l9yXWoXD9D34KLP3cfzwkIVeluzEiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Sat, 18 Apr
 2026 02:44:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Sat, 18 Apr 2026
 02:44:41 +0000
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
Subject: [PATCH 7.2 v3 05/12] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Fri, 17 Apr 2026 22:44:22 -0400
Message-ID: <20260418024429.4055056-6-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418024429.4055056-1-ziy@nvidia.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0164.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bc8c5cd-a318-4001-596e-08de9cf46fe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Do8In7i3cPsVK9VRgv05roH4helfl7md5kLujgrmBRd4Vyj+sYG8cNTHupLxMVwkBsn+UllM5/2tVu19aP+eYMl1nfxwZ0ULZwuPUOOyrFtGt5OW3Un4l5ly4boDoGwzGIhEi4Q6lRRgHcPhPu5SmyMRH3/OGV2GxMwgQM7WCCjFzbYFjVu6eN30Rr/DyN6Kk9yefNRJicvxBUZNRlwOO4mwsFSDnBvOoZpooHbYmZiqGucEOlAsG+/x87SOqK4+hySILfBV/UuLU16nEPIQvOHNYl0mZEnI4v2iShbyX7BurszEuYdEMlGZouuH2phbqZAJoZPoOGu2taYY5OtR4ARUo+wMNo8TmATQBGRanHQBGNhq8eo6A4cJsNEDGlRwx8Auyn4lTJAurD5suflUFFwxZmIKi3PMRo22Tr+j9Mj/XNGCrR86fkYmtP2tbEUjF1GVlCWTDOsdtlr7/nqvAv9lF0O3uTdJHntjHGu1Zju9mGhmYxd1hJ1TfjH/OPhR9JMdF5j8k0KIjD6nMKvC0JhAOVC/wvqhzDxyjlTNDEpWfRMzoOnL2xp3EmmE+iKpNDfwFkotaFxAlsibNzdiWkm+eC6lEbnvINsuL4+HT1jyBtJslEPMq3mnOCuUz7j01qgjQfZNxQFAbmdnOfpFFIsX2V7yTMgXHWhIy2A6MkwsqFfHErcLI2awsIN69SQF/5TEIlm/gY5ZeZhyCqrMZki9WMV8NYLxT5nYblrNrck=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lSpD/HvpsjJIKRFkSfkDd8+d1YIpCrdlyENhHe6kCTqjbs91uEk4YcvzQov1?=
 =?us-ascii?Q?4nNdJaO+1EIeuYhlVamL5yr97XJWKlsI1RbH5i9fUyWaZ281MBt0bK1PqWhx?=
 =?us-ascii?Q?U/Azdl0wD5iRccboF9SSI04RSIuMySNUMfzzNq7XcRM6y2A8Iv1NFSVKd6S4?=
 =?us-ascii?Q?Mr1yAlJXeHbGrKLdGx2z4DlVZF1mIvOIg538qDyltydd+mK+yvG8D0dbpJ/m?=
 =?us-ascii?Q?xUpVeq0ngzv54Xh9hh+xEIY3aeMD5j+rlTtxy6SO5c6SMiU4VOClzVYdHesk?=
 =?us-ascii?Q?6PhgtENyPBAqrndRPhfhB/0hjw2INQb7tPY9w791qJ/5nr4nSgKIPlpnyI03?=
 =?us-ascii?Q?qoAvlbcksfa8E/bycdtlrEa+zBTwf3UirgzzER3nxZzyJHKrJ1JEqcVTxdMS?=
 =?us-ascii?Q?L82ucerkFZH36e44tay4y2XPguGBW9PHu2MSII4+1iIOr38xJaxSQ2abcyUq?=
 =?us-ascii?Q?RnArg2EkTliaLq0ETLhzr1HzFdV9WcLaI4ZL/sp0CMOQ8/H9+AzZZGbc1tSS?=
 =?us-ascii?Q?zNc36p0ZdLsNTyu6wUYpENX1DbS05fnjCBembkSYKbgtaqKX1eKXEBIZGcur?=
 =?us-ascii?Q?XWs4VqE4geBJVXk6e8CTfoozgv/XzImeMJnDDHAExBpBAwV7P5/Hejg0Tidh?=
 =?us-ascii?Q?tui32i7YKKgf9uoFsiHm3bWOKPVAUVEiulS2DhTSv4rYugsteqGB8c97ESmB?=
 =?us-ascii?Q?Qdtbjt5zIDfhDDg1R2EiEJpAcs9uxkXgW+XGKKW9BO2lesfJv1HMnG0QIVJo?=
 =?us-ascii?Q?wXpuXZiEsWd6Ez//wz3B+zlIAXzk2D6e0W1syFQVyHU7jB8gbUzfwqj8zihL?=
 =?us-ascii?Q?D2iKK8YqwjE7Nqp46od2EZicbxBI/wEXbWnU/FonTufrId8qjVu6fZ0s8/Hf?=
 =?us-ascii?Q?7rEI+tTmlL8wwq5FvuGFaAoP84N1pSvRlpwC6ocO0ZjNW8IjC4l+BPO1X1nv?=
 =?us-ascii?Q?XH+tlGkwr9DRhxZ28sP/9ZUOJo2jTJpk9QeESMjB40g6L6eQdxGxtAFzGnqg?=
 =?us-ascii?Q?HSAQH0wnbeSaG8lIVPxKkg0LSCuATSyWK7dXfcADZpgTBwIZfIxnmOob0ABv?=
 =?us-ascii?Q?IPCSp29dSXWErtzxTQHaSvA+Cg1t7rHPgEhJi8Bz0F6ur+esCsi4bMbWmZgH?=
 =?us-ascii?Q?DggpkAd8Y7qmERHvx5AWIgBgdyoBFuif79XLceIMRgR3yLOpB46likwCuNYu?=
 =?us-ascii?Q?YuQYGogjjB4zfWRLxcFsIS2gRlZNnoyCqXGU5lyDzi/P3KipxtBIOa/OpdVy?=
 =?us-ascii?Q?9Wg8HW9XGntpyc1b6Tih7jYBps7d3F5BMa6u3bJqJ7MCga1umlijT37nh7rk?=
 =?us-ascii?Q?BHQSmaUvxisjjMyCskGQ22dZqGOmXAqmWTvwJkgBgRE82NZF1eWVGjQCfRq0?=
 =?us-ascii?Q?kfGjqVBTNzGwXdoVQm1QTgiW5k72ASst4MKbbZDxE45R8Qks0IVT/Jhwn6c1?=
 =?us-ascii?Q?GWKYmqMxfknmh3wYP9k/tUJ9Pksrif6Mub3gS9MopF0pPD89YxEFcQHVy1FY?=
 =?us-ascii?Q?ME5Sy2+CCUDm95IZrSsjuwTqrmeF07GC5lYRHGcr3KvWdEqM3EzvxFvFiPJs?=
 =?us-ascii?Q?KRDxi39ZbGuG8HjZgH+mVhbFnCnhkBCgaEk4n/30h6ZE1gHKVVH0FsUqVIzQ?=
 =?us-ascii?Q?hJ0ao2o4HQyJ49IGR3vj31UWZIiLrA3hbxGkVmA2ShwVDj3/KzophA6LzpbN?=
 =?us-ascii?Q?LpG28XvJZbz6C5HGZFSvN7h3YLeak77sGs8WoTG1EieQxTnX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc8c5cd-a318-4001-596e-08de9cf46fe1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2026 02:44:39.7183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yCV9mnfDjbK4gfCyRENIyApHlBoLuUq+heDrfyrpD26EH2XZENvPclistyFsIDkL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650

After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
support even without READ_ONLY_THP_FOR_FS enabled. Remove the Kconfig first
so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits remove
mapping->nr_thps, which its safe guard mechanism relies on.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/Kconfig | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index bd283958d675..408fc7b82233 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -937,17 +937,6 @@ config THP_SWAP
 
 	  For selection by architectures with reasonable THP sizes.
 
-config READ_ONLY_THP_FOR_FS
-	bool "Read-only THP for filesystems (EXPERIMENTAL)"
-	depends on TRANSPARENT_HUGEPAGE
-
-	help
-	  Allow khugepaged to put read-only file-backed pages in THP.
-
-	  This is marked experimental because it is a new feature. Write
-	  support of file THPs will be developed in the next few release
-	  cycles.
-
 config NO_PAGE_MAPCOUNT
 	bool "No per-page mapcount (EXPERIMENTAL)"
 	help
-- 
2.43.0

