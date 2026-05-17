Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011051.outbound.protection.outlook.com [52.101.62.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB46F271A9A;
	Sun, 17 May 2026 13:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779026119; cv=fail; b=j/tMfPuT0Ttd110ma5LnkyMH+Ogm9oCpv4XZUis/6JBhIKzQScn5r6vd8qls/ZJRSoUXYckx0j4yiMByIitMCaJ0WH0woxstPkWAJntsbXdY7zdJhWhU83U821II5Lk4RnVt4FJPpyU9gFBJ3WIUV1R29Cc8N7v/9mm24+YJwJA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779026119; c=relaxed/simple;
	bh=1JcChy8dNpaXasV0M3rI1+XY8VPqqboxoQRqbElBI1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U7+UhLRLjGaxmhxsp1ktE/7NO8VgqZ0JdqxbY79G8tok4Pt2iZgbNMcaDxvDfF5wRyTjGaU2sZbnDYHXbtWtYD5lfmavrNHyKWN6NV8JpR0CJRUPzRRtvBQ6AQDUeiOMH9tPgBszqteAgV8TI2HTorBqX+Kw8ZwDYGYZR69YP1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZwX7dSAD; arc=fail smtp.client-ip=52.101.62.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZwX7dSAD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cUcUBKmPvpQ5SDVcdSLm5vex5OTPwDmD4h2J5ujxyHRNU2JhwE2aZEvYWy90zi+n1lchwzPOB/BD0ySTRygd4UxptsP1RwWBarp6Acjf8ABqjEfLtHtN83VEdkP5VDq/YXzbUl2ZIvjzqJaeCHJUjnK3T+t/Hzl8vMjCN5Gx/fi8qVC1QcmMUPNtCDrSYudz9FufPswaJ36Eo3JHuVGp58OG20aUac572sTka82/T/3RgraFJearW+EeIxdjBox4RzR7Ng/jYioc1Ik7SS3x0fAAYAHwMQ/8l2v0daxLVnOjFmrESq3rVQscBMfrTFZgnPqDBXDgL9nakqiARtNLuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ehzXYQDIF7/6cmQ2TdeNHDAfB0MXNZsBNh+08worURg=;
 b=NqlPix+qD16um96Qh3VzcDnEBvUlDcD3tUrTm3TPT/T6ipTO3iAAGKO0leUhjDiuW0tkOQUCUGQ5URqVNmR1zqhoyJAjOsNptZdwC43c30AV6H4Jaydq7DkkHYqjMydWUCQr48gbWlIpnYYUIqvgLK31RbYLgR+45JXUyKpe3hYYqzuKsZE13xRSAoi29neWEqvhAGQ20IRgI8O/at/F7ZmEqwcActPqGYI3RaRVNUKgu10AX3RL/GXzKIQXoYjGLCTmrilN2YDpbzlRb2C0R4EHKc43vQgICQTW5j4yWVraxQyemTfwO7Qc2PYn+5VuCstr/01myNRR0raToPiTpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehzXYQDIF7/6cmQ2TdeNHDAfB0MXNZsBNh+08worURg=;
 b=ZwX7dSADkmWEDtsqfUFVVm6BqZUxV1xQIjkXnWbUjYTgSFRvJypmSwGfrxfVH3kGuXENNZk8d7Rs9zANoXKV7sTrSEvoAqmKeEv+bc1ovYWMtOAFrTAjYjWx27vAms7yZTOpjJrqkF8uEsxjoAkqEFfYMFV14nM47eQcZ7C4jUznyUTQrU14vWL9DPJsvqwXhMvzLDVWur0bCqFlMyk2IUojwW1xbv04ak/9w7fpfWpmGYlFvMc4zIuscedtPgscIcu23CdnxJOT+cbs9152J1X56ONE1RG6Dm2ESeHqUbG9d7H40pfk0tFRDeZJa21ic28uz8n46qlJRzZBxPP8sQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:04 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:04 +0000
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
Subject: [PATCH v6 05/14] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Sun, 17 May 2026 09:54:07 -0400
Message-ID: <20260517135416.1434539-6-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:208:52d::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cc0b694-06ee-4529-0854-08deb41be579
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	UkQxukGtRKBuJ9NSLW2cewsbxxkCY7jM3lcksY1WsVkpc4idVpbdGZpaR5o992b9i+68s2s+u68VNo6ETTh+UlIq14/0NkDs12Yqfw8WOUqUCEdQxnFBeXA6N16Vl21E0/oqzvbDGww59wBwWJD6kipdID6NfJFfivgw6s8zgYYRoxJ5UTRZWJcDgKijIsgoNO/qIHXWGotagfZMIYu/j4zYRkFQB/WwtVIZ9CfFXWkX4hD0sqwa51BU3NazpqBC6m+NXbn0vo1cd5PkBvZyo4UKPNIF0FhNl6Bc2iQjauC1kmW5GrcTq0cPjXHfA6pmg9FgnOuMMGgrvPBYGW96MKM3Jlckd5s1lZmctB/e8oUL1nFrtvheKLpN0TtAn/EEHbDenhwM12JrLg986u2LKQFpzab7Iue8NuvFgLzkhAhTW4fR2zqdTSLgwvTH9EiHjwDwFqvmXE2Q1zfzu1KKrbFDTGiColBltW6SLK3zAYdXKzVLcwi6o31ZkK3C0CQhJ1kmivvvoN84LoiDzTX+tpSo4IpopvvuFOQLD3zd+rP3JQJCvjXhEh7mOKCiy58goPlDGad6a7U1aibrIk+VhLZsbbtxw5eFPSLEv8oZ8FZtC3F4mNA7zy8UkbPbOgGKvgVTDsJV8ulBek7Ez99Pi0qhSSbajsJ1d022K+qBg8+1+szR6wCBF5+D/8X8d7SR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4c3les0XUL++lgU3d6EN4o7FBdrK2rQfDo4JuNRuQhdUggQaD8K6jPrqKOhF?=
 =?us-ascii?Q?LehiMNUj732iSx3vge42UCG0idj/iinci1n0WJHf9QW3O8UOFHKTEHkde/3a?=
 =?us-ascii?Q?1ooq5Mj/GmkGzgi5/vvfdPYVklc6o7TxYpJseD7sm2gH/SwpuTJJnfY/T5jC?=
 =?us-ascii?Q?5rTm/QdGU+wst+jf77aEdPZLUnuOtXkxZqUhR4G1F8xysvmObylP7+rJX1yl?=
 =?us-ascii?Q?rYSx40cjTQRbTIe56cmNIRGtkxt11FzGNCPtJHYhZg6M6+G8cOrFd+VeZM9z?=
 =?us-ascii?Q?i8vSjwDqN+kzI1dzHprWSsbYPTq2pABP5bYiVNw7uaj7+pYfjrklETU1aruM?=
 =?us-ascii?Q?byr2CWUscPC6PWJkuY5J4U/ysI6TJ9XGCX0kCv647JmBhHaQ5hAJnDnIHkl4?=
 =?us-ascii?Q?XFv3gVyn20XogE0rc/CeALttbZTEBjBnluZlyTh6Jhxw6zOkPiJl9Eo9zToI?=
 =?us-ascii?Q?9DFkEHT1MJxtFud5wFYELZhQJPgDJuWe5aKdg6q/0WHs33FMCo0RVcCln88N?=
 =?us-ascii?Q?oD9sFjRj7zWIGCvTQuJlnvez3l30cxSqye0Cj5D6IlCJJAG8ZQo3HFdkQ8hS?=
 =?us-ascii?Q?KSLzl+YV6R9Q+N52Zo/XNV+h1A1to09efGfHzzriPMd5C+82O0vmvm09BF+9?=
 =?us-ascii?Q?hlQK+TZNKGfcAwP/qeOBrLMnHOPOHuur8wdEEU+U8oGooNicVllKfq8SDyDw?=
 =?us-ascii?Q?dUthG2nYUSwKNV4i6f++KiHVgSBed0aKEoQfdx7UkFrZWWX1Ew76vgW4hty6?=
 =?us-ascii?Q?7w8kcljEW+yqG4cWLU46z++pyY7PegQYGeKO7A19/pyZtE+PaRTAnOtydlkJ?=
 =?us-ascii?Q?Mv0iPexiKLW1PupotTOzVhrJ6PK+GuVlMfEfPr5t9hA0DhNmFWTBv0JNMOaT?=
 =?us-ascii?Q?zSB3SWM9lnyD7G8J3rBlQc55L1E7bVFhyG36tMcrLRZxHkzD/I6IDKdvBZYV?=
 =?us-ascii?Q?pEmFt2tQgCdYl0dwll1L9GVWgHrYdibXBO1o/VVEYjtakFv8zm0Fdr40P6vM?=
 =?us-ascii?Q?TuOWXqqAXsrew5Nr4rmRCMSqu0Bk7iavmE+Sn92h9ld4kcQaOx5fVQcYTcTx?=
 =?us-ascii?Q?5h8KqaAbhFiFkJCyVKEtnbXgzUKtAz58So8Ez/BftC8OdMdVrL6gpxxV+AoC?=
 =?us-ascii?Q?ooFtjbmkY/wRBjEcXkrdobYUyAYfyMmqn9vbiQMzoU9BbJFZFHhosfR4bKUY?=
 =?us-ascii?Q?wnZE0MtnVftBHzsCW27XjOwkxGzgZFh8SRO3pUzmdc1uD4qA/DsXP5WTB8qb?=
 =?us-ascii?Q?MMOdV7mkGGhXqdFgq+37197VKExv7h/0bgwHHtlZWubA0qca79j0Kt375i24?=
 =?us-ascii?Q?LybeBR8iZrwMwM1IQtMjcc2QcbaLSD5dsGanDBJAk7jK7al29x84kYLZgoFd?=
 =?us-ascii?Q?YmCKeSjsefbD3YVA2z5A/+6kQfqOB/+bjUbMZ7eg2d29FmPavLgcc7d6y8H5?=
 =?us-ascii?Q?dSvFuO2o6njI1cU98Z0S5DbxCyAPA4NWXv2t2+0jkzhCiFScSIpivOwTGe0i?=
 =?us-ascii?Q?4Ise/IAuNX4a5Py1YSS28VCrC5ngbnI5MSgNlXuu2yRemasvWqtkbRgphOOG?=
 =?us-ascii?Q?6yDOrZiOyPQPAbFByBD1W4DgWTCS6vKZ3EIKEFoU217KValRdGaCvHvfUuHe?=
 =?us-ascii?Q?OvTuRJSbX6W8oszJO5ITCRtuVfNjhKiNqFY1933Dw9D0rRhST2VNaDMR4cuQ?=
 =?us-ascii?Q?QTSl7jJjR3lsVLarOElZDWkUSlhujdcZd0NU8zIYsUruNgyJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cc0b694-06ee-4529-0854-08deb41be579
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:04.1017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tm0apA1Odt94CXDi41podFMWyJe7bxldY/DVxWdbrDc9x/2eyly3pcyJVwIsw7bM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322

After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
support even without READ_ONLY_THP_FOR_FS enabled.  Remove the Kconfig
first so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits
remove mapping->nr_thps, which its safe guard mechanism relies on.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
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
 mm/Kconfig | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index e221fa1dc54d0..27dc5b0139ba6 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -936,17 +936,6 @@ config THP_SWAP
 
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
2.53.0

