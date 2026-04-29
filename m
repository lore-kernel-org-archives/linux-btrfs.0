Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013048.outbound.protection.outlook.com [40.93.201.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CB3383C81;
	Wed, 29 Apr 2026 15:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777477033; cv=fail; b=rDhZjEUhzjv5MiOTjklvU2J6YhQ5WEKFQVvtlcAi0ZzjtNP07TghS6DVAlVzrBO6HLgMhyKFyCBj4GtWf5vnyWLjMQAEXvChNQ0zT+i6u21CCE1MEVddupMFhBMWQsKxiZI9BQYwyVytREOKTSz8n6vXJYEjOgVKOAeHDQq342E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777477033; c=relaxed/simple;
	bh=1MTwhtpmQAsefE57hIJ3mKIDjG/htP5xtZZMiJWLN1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q2kiahw6cIfuZhRor0+QTux0yMrrF6o5rIcZ+sEWDJJ7fMKbzo3Jf0oJN1X2wuzMer9rjxeoxPC6s+lTuBO1YT9jPUBzC4Tp3XZkspExiw6e8SJwE5QumOYRCBYlb53lfhuoCiiFDJg/PaQeHWiBNB3x2B/NE/9sTtFpNg+R+Z0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MKt9oURj; arc=fail smtp.client-ip=40.93.201.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MKt9oURj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S2sO6R/s7Bs/fOpsHixOWRajC2j6QHBaS+z/VlHbFTTXLkdRnEuGtC4t1+lL8Zbpw9NHh/XSrAO08OysuE6gRp2ti/h8Wi31PjfNelS/IIY+x/em4cG5Ov9BVSvZrS5aRny9/BWn/cQhWnpVDk+Lc5eJPPAcsacMX7KULcV8IJLzmKehadtxoH/hu2iSyaah3lBiK+cr9WdDGiV9B60Z9dDHKjFZOnvpE+H95PA3g/MqiTdISlpVEZbQCRAri4nwpuK/m1tMA6FexqUoc03X+RAgU8NnHn25sbMnmEBn9IEWUGgWQTAAlrM5ItxnbBnJIlyADIVkuPD6DYCYoCByDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c8IGE9md+Wds3A5qgRUw9FsoDxobCxH++sKwWdjoMso=;
 b=noR1yvkHh9Zw/ABdciPIWV0Wcmn6tNUSujA5LuDxYBvuEQ2phxx00lh06S0uAGrlYJ9I496QY6aMf/g/Z47QW6jqRLPSGeRHJUQa9yxUxjnm/l/2TOiS0uaIjNmRBsOpRlBaclOuVGgeEOvObRSC2ZcWLJkh9bINNM3Nkoqyu47XPRsJt4R/h1NphzdaR5eSlDSI3xGV5WawyUBU3V4X4gg7mYNSDHN/UZnGNFoPcmTSVbx4zt0qJejWyW0/sVlZfNblwA/+XlTD8WRuA3AUxOZuQ5TQzLDiRuW3g2OkKxHJkZ6XVJHhRFQqtBbVRP/TvTySPNZ8q/HrpUPd3TxWxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8IGE9md+Wds3A5qgRUw9FsoDxobCxH++sKwWdjoMso=;
 b=MKt9oURjnHQ4uoLwzO0KJYVgRjhM/fFbE1MJzPyqXoUOe0FjDJKEmNDnoI+SNnEklWl4+QoyY3tyK1JbIejyNspZNYwmc0gj3cndy/xYu0lrI6zLs9YYk3KJlcuYBADAiJv0P1Zupns7WJRZUqkmGNtQ3t+Ag735S+keKT1Xyr3adsTRCarqlb52rsW81ABM+v4UYB0Rrt5Tr+WwyRUhJrO7cWc92RpyHio+2OdrYyB2874X/CM3W8zvgJinWLZyn/vt+G9B/8qMF3z5HyOifMUUojUROECzE0CbMiiDrLxL6aMuj3BMG8kQjeXG+XB2p6lfJ5qaqbsuOs9OU42DwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8881.namprd12.prod.outlook.com (2603:10b6:a03:546::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Wed, 29 Apr
 2026 15:36:52 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:36:52 +0000
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
	linux-kselftest@vger.kernel.org
Subject: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
Date: Wed, 29 Apr 2026 11:35:34 -0400
Message-ID: <20260429153538.727855-7-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8881:EE_
X-MS-Office365-Filtering-Correlation-Id: 313bf602-1621-42ea-c84c-08dea60522b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|20052099010|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2ZuWc5faAETWi+ncVPkzws1fFemfdkyll6U1xRFbSLJ1YmjaUPLeuTV13u+MSQIggERpC0vW+uk6qFiVHmRFuGWiSQtZVvX8egIXT2Hg1zQwhTZNP+5HPNQoRfgSSq0i9Vss7OD5Kiukyqpn2k7EbCONYlVP5ioKvRclzefF6lE7dcUc4vvENIngA1xVprk9h8Ky/JmAScPB9Oxpz8/SWfMcL5HvIW5SY98jrQQUNZDuGsq3uPyxOhdhDI2kcQyn1YoD9ZdhffmdVWfXBS9P3vtr17gsgP2tTtNydc5GgABpIN2b1KH/oPtubWh5w5e+SFHbZDlUSqYl2FngAj8qER4vL+JDLf99yDYdGchcEwi+pZ0N0PwmZGrLeeeb5Ilil6cE5luSLsHbrL+Iz+o+VB7uxUB1mUtus1lNTe9LqrjyTBbecrFuEP76FZU4u6OheE75aRMrMJd/v+frHlDDJ4w4K1EG9bHCfjjHMDOo0XqqD+RYdcj4YIpXod5t1eli3H7ugviFCNyVjmQu6fbUxwxN8nK1f7QuRChymYr4zIr3xHnD7cCELRQhRBZMlW6IbSdkK+s8lCCsP2coCAIDi1wsZR1e9yqo+dKTQgwUAbyYGxRuLuYNYU269bDgmtC5f1KEyoqUVviVpXAiQ9RqyfBA1SVdvM6dm+KVFocvNHMBKQ48nmHvnwuTCL4Gc6M/IddpGBbQCo7K2d6HTwIZYI7ZWJfImG1jzKrwWJE7RqI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(20052099010)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KZpR1KqrnDbckVXK8OAQM3GNNkZ7PvhFsQ6h36N7pculxxGAqDxqDajlZdwH?=
 =?us-ascii?Q?NFH10NKdFfHmLughRAFhudpUPfdVoL9wMbJj2PYdCZ9P73ttVj0fRvq71hmo?=
 =?us-ascii?Q?bTzOX5sSRwh6H5GwhziGNPkJETPXpIi+g4QNaDbq46HtQg37Sh7hmK+xv2h+?=
 =?us-ascii?Q?XnphOUKknYhUPPhPUb6cxNbI6UwXFMq2P9cDpCqPRlXOF+4FRbQNxnImk80T?=
 =?us-ascii?Q?EOh+iLO/iqQymX5fLVbK3zX0BdFTWNVlOS4CTX2TeSM7rdCwW0kz5qpF2ego?=
 =?us-ascii?Q?c90f8z3vRn24hqBxYlvZ8QwmjbERVKUVzkr2RLp/AIDzUvxQHiNjwLbceW3P?=
 =?us-ascii?Q?+RAgGgut7qUIGuGwgAukXEMj39+iA/gjSGDKKFLcFf5BKRmHVyO0oh/kAxYG?=
 =?us-ascii?Q?/TPjyG4aXPG8CtAPCv8vsFjTXGLhOv30N1FtHrGuonDRy6PEjAWxIONQSuYn?=
 =?us-ascii?Q?kkA9Dhpab1k2bbiT3ngnRdtee5vI2QIqbHsTQKtYAVTEkLmONrkDqF3A9pYq?=
 =?us-ascii?Q?6bFaVWbkvHk8OKZY6P5jyX99O25+Jl5W7jUs3zV1jQB4//u6+CtOs8ug8psw?=
 =?us-ascii?Q?nK4TF1uqHSJ3FD4DC0feg02zbmT2s4QxenWpasDRMCH1g/kkZoclZa2ZBhGc?=
 =?us-ascii?Q?bMP3aVkwDoMuSVTbik80FurS9ScDU0pAfZxt8nJjrthXoK6brsceTyHqLc15?=
 =?us-ascii?Q?R88OZ/v1zUJAnSM1XF8xosXEqaA4TVXySlM7HtWzYAFM3ZSeiLUdcbKGIDZW?=
 =?us-ascii?Q?koVVqWQYpEpZ/rh+cchFMDeGpHLBzkdn4cP0JbSP7dQqjiVrKvL4hGyw289+?=
 =?us-ascii?Q?SpWSIuuCnteEvIm8nyWBiRshPGfRBVax/d7QcTW91yrUc7PV4zYjsI7xga6R?=
 =?us-ascii?Q?VpZdD+lkyhxIZe9A5/j959e0NwL9wPKdrbEb4VAS0ROfxPdZCzrr8RDoZab4?=
 =?us-ascii?Q?iEtEDDA+e7rMnPXNj5SlSCM3W0jIf6ny10JImQWwx1H+j6DhoJIzbQSLSlyi?=
 =?us-ascii?Q?C1wNyiVSSYpV9/2sNe6FaGCam+0lGCbZnt3RoRe6ba6TtumPEp00NG3mswLP?=
 =?us-ascii?Q?+HkzI7WWbR+91D3rk4njNKT804Buf2qZz4ku/VcWAMUEDWqYeOyT1Mejf/hs?=
 =?us-ascii?Q?sCuFtr2Ompq3J5rKHXDh9xTL6MNkp+ZhRZRCkU/8wCeKpYXZM5+Zek3ccvoY?=
 =?us-ascii?Q?dbhdQT2VAkDF22TSdu8B34zqR+yZFvmD7L9wBolrSD2B/OlD6uc7rUysRxJJ?=
 =?us-ascii?Q?ZVAwaZuIWtSrYmMMR7OdYhRalfaXS1egSk8m/10qzphp47mJ1XcHUx4TJNW7?=
 =?us-ascii?Q?PXeqWdAnLBQLtVAiFcEG2KA7raNWamY7G54L/0bAfkPBT80gxgGwHw9bIbO/?=
 =?us-ascii?Q?hFDeH4xtHS4txpjZ+dI9Z2OZQeJomB7tWFKyYKnkaUoqZSc9/d5mLuHYs3wW?=
 =?us-ascii?Q?pNrk920mtQRdpyo7p3J7KT0/jvs+a8cXzT277e7TRSrB8/IbWYiDRu/Es6eM?=
 =?us-ascii?Q?gWxbolo7KZM01qTchvlu/fADQuPxDGWgQWr1rtBZixztteVdED0aH/y0lvsj?=
 =?us-ascii?Q?fVEUz9WM3qbCQwFfriytX19qyupEN17I395Qg0aVGIjE4UuLOQVVpL7yyzF/?=
 =?us-ascii?Q?ybiX6eIMMSuWJaAQ4XZp1K+Wt3wGPvSNJpWDxrOVEcsCQxiy0mFxnWMAWksh?=
 =?us-ascii?Q?eJPzzaw8yzzvyqdBCWUMn5n9cKxeIQtBxpY+07mm83S7EtwN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 313bf602-1621-42ea-c84c-08dea60522b5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:36:52.1485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1NlGBrMFjyfgaEdEI1xUQ4trzJabkg/TI91zKu1TA4p+d4OsKemxaKD0ule2Cwt+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8881

Change the requirement to a file system with large folio support and the
supported order needs to include PMD_ORDER.

Also add tests of opening a file with read write permission and populating
folios with writes. Reuse the XFS image from split_huge_page_test.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++-------
 tools/testing/selftests/mm/run_vmtests.sh |  12 +-
 2 files changed, 102 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index a6bb9d50363d2..80b913185c643 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -49,7 +49,8 @@ struct mem_ops {
 	const char *name;
 };
 
-static struct mem_ops *file_ops;
+static struct mem_ops *read_only_file_ops;
+static struct mem_ops *read_write_file_ops;
 static struct mem_ops *anon_ops;
 static struct mem_ops *shmem_ops;
 
@@ -112,7 +113,8 @@ static void restore_settings(int sig)
 static void save_settings(void)
 {
 	printf("Save THP and khugepaged settings...");
-	if (file_ops && finfo.type == VMA_FILE)
+	if ((read_only_file_ops || read_write_file_ops) &&
+	    finfo.type == VMA_FILE)
 		thp_set_read_ahead_path(finfo.dev_queue_read_ahead_path);
 	thp_save_settings();
 
@@ -364,11 +366,14 @@ static bool anon_check_huge(void *addr, int nr_hpages)
 	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
 }
 
-static void *file_setup_area(int nr_hpages)
+static void *file_setup_area_common(int nr_hpages, bool read_only)
 {
 	int fd;
 	void *p;
 	unsigned long size;
+	int open_opt = read_only ? O_RDONLY : O_RDWR;
+	int mmap_prot = read_only ? PROT_READ : (PROT_READ | PROT_WRITE);
+	int mmap_opt = read_only ? MAP_PRIVATE : MAP_SHARED;
 
 	unlink(finfo.path);  /* Cleanup from previous failed tests */
 	printf("Creating %s for collapse%s...", finfo.path,
@@ -399,14 +404,15 @@ static void *file_setup_area(int nr_hpages)
 	munmap(p, size);
 	success("OK");
 
-	printf("Opening %s read only for collapse...", finfo.path);
-	finfo.fd = open(finfo.path, O_RDONLY, 777);
+	printf("Opening %s %s for collapse...", finfo.path,
+	       read_only ? "read only" : "read-write");
+	finfo.fd = open(finfo.path, open_opt, 777);
 	if (finfo.fd < 0) {
 		perror("open()");
 		exit(EXIT_FAILURE);
 	}
-	p = mmap(BASE_ADDR, size, PROT_READ,
-		 MAP_PRIVATE, finfo.fd, 0);
+	p = mmap(BASE_ADDR, size, mmap_prot,
+		 mmap_opt, finfo.fd, 0);
 	if (p == MAP_FAILED || p != BASE_ADDR) {
 		perror("mmap()");
 		exit(EXIT_FAILURE);
@@ -418,6 +424,16 @@ static void *file_setup_area(int nr_hpages)
 	return p;
 }
 
+static void *file_setup_read_only_area(int nr_hpages)
+{
+	return file_setup_area_common(nr_hpages, /* read_only= */ true);
+}
+
+static void *file_setup_read_write_area(int nr_hpages)
+{
+	return file_setup_area_common(nr_hpages, /* read_only= */ false);
+}
+
 static void file_cleanup_area(void *p, unsigned long size)
 {
 	munmap(p, size);
@@ -425,14 +441,25 @@ static void file_cleanup_area(void *p, unsigned long size)
 	unlink(finfo.path);
 }
 
-static void file_fault(void *p, unsigned long start, unsigned long end)
+static void file_fault_common(void *p, unsigned long start, unsigned long end,
+		int madv_ops)
 {
-	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {
+	if (madvise(((char *)p) + start, end - start, madv_ops)) {
 		perror("madvise(MADV_POPULATE_READ");
 		exit(EXIT_FAILURE);
 	}
 }
 
+static void file_fault_read(void *p, unsigned long start, unsigned long end)
+{
+	file_fault_common(p, start, end, MADV_POPULATE_READ);
+}
+
+static void file_fault_write(void *p, unsigned long start, unsigned long end)
+{
+	file_fault_common(p, start, end, MADV_POPULATE_WRITE);
+}
+
 static bool file_check_huge(void *addr, int nr_hpages)
 {
 	switch (finfo.type) {
@@ -488,10 +515,18 @@ static struct mem_ops __anon_ops = {
 	.name = "anon",
 };
 
-static struct mem_ops __file_ops = {
-	.setup_area = &file_setup_area,
+static struct mem_ops __read_only_file_ops = {
+	.setup_area = &file_setup_read_only_area,
 	.cleanup_area = &file_cleanup_area,
-	.fault = &file_fault,
+	.fault = &file_fault_read,
+	.check_huge = &file_check_huge,
+	.name = "file",
+};
+
+static struct mem_ops __read_write_file_ops = {
+	.setup_area = &file_setup_read_write_area,
+	.cleanup_area = &file_cleanup_area,
+	.fault = &file_fault_write,
 	.check_huge = &file_check_huge,
 	.name = "file",
 };
@@ -504,6 +539,18 @@ static struct mem_ops __shmem_ops = {
 	.name = "shmem",
 };
 
+static bool is_tmpfs(struct mem_ops *ops)
+{
+	return (ops == &__read_only_file_ops ||
+		ops == &__read_write_file_ops) &&
+	       finfo.type == VMA_SHMEM;
+}
+
+static bool is_anon(struct mem_ops *ops)
+{
+	return ops == &__anon_ops;
+}
+
 static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 			       struct mem_ops *ops, bool expect)
 {
@@ -512,6 +559,10 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 
 	printf("%s...", msg);
 
+	/* read&write file collapse always fail */
+	if (!is_tmpfs(ops) && ops == &__read_write_file_ops)
+		expect = false;
+
 	/*
 	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
 	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
@@ -578,6 +629,10 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
 static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
 				struct mem_ops *ops, bool expect)
 {
+	/* read&write file collapse always fail */
+	if (!is_tmpfs(ops) && ops == &__read_write_file_ops)
+		expect = false;
+
 	if (wait_for_scan(msg, p, nr_hpages, ops)) {
 		if (expect)
 			fail("Timeout");
@@ -612,16 +667,6 @@ static struct collapse_context __madvise_context = {
 	.name = "madvise",
 };
 
-static bool is_tmpfs(struct mem_ops *ops)
-{
-	return ops == &__file_ops && finfo.type == VMA_SHMEM;
-}
-
-static bool is_anon(struct mem_ops *ops)
-{
-	return ops == &__anon_ops;
-}
-
 static void alloc_at_fault(void)
 {
 	struct thp_settings settings = *thp_current_settings();
@@ -1097,8 +1142,8 @@ static void usage(void)
 	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
 	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
 	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
-	fprintf(stderr, "\n\t\"file,all\" mem_type requires kernel built with\n");
-	fprintf(stderr,	"\tCONFIG_READ_ONLY_THP_FOR_FS=y\n");
+	fprintf(stderr, "\n\t\"file,all\" mem_type requires a file system\n");
+	fprintf(stderr,	"\twith large folio support (order >= PMD order)\n");
 	fprintf(stderr, "\n\tif [dir] is a (sub)directory of a tmpfs mount, tmpfs must be\n");
 	fprintf(stderr,	"\tmounted with huge=advise option for khugepaged tests to work\n");
 	fprintf(stderr,	"\n\tSupported Options:\n");
@@ -1154,20 +1199,22 @@ static void parse_test_type(int argc, char **argv)
 		usage();
 
 	if (!strcmp(buf, "all")) {
-		file_ops =  &__file_ops;
+		read_only_file_ops =  &__read_only_file_ops;
+		read_write_file_ops =  &__read_write_file_ops;
 		anon_ops = &__anon_ops;
 		shmem_ops = &__shmem_ops;
 	} else if (!strcmp(buf, "anon")) {
 		anon_ops = &__anon_ops;
 	} else if (!strcmp(buf, "file")) {
-		file_ops =  &__file_ops;
+		read_only_file_ops =  &__read_only_file_ops;
+		read_write_file_ops =  &__read_write_file_ops;
 	} else if (!strcmp(buf, "shmem")) {
 		shmem_ops = &__shmem_ops;
 	} else {
 		usage();
 	}
 
-	if (!file_ops)
+	if (!read_only_file_ops && !read_write_file_ops)
 		return;
 
 	if (argc != 2)
@@ -1239,37 +1286,43 @@ int main(int argc, char **argv)
 	} while (0)
 
 	TEST(collapse_full, khugepaged_context, anon_ops);
-	TEST(collapse_full, khugepaged_context, file_ops);
+	TEST(collapse_full, khugepaged_context, read_only_file_ops);
+	TEST(collapse_full, khugepaged_context, read_write_file_ops);
 	TEST(collapse_full, khugepaged_context, shmem_ops);
 	TEST(collapse_full, madvise_context, anon_ops);
-	TEST(collapse_full, madvise_context, file_ops);
+	TEST(collapse_full, madvise_context, read_only_file_ops);
+	TEST(collapse_full, madvise_context, read_write_file_ops);
 	TEST(collapse_full, madvise_context, shmem_ops);
 
 	TEST(collapse_empty, khugepaged_context, anon_ops);
 	TEST(collapse_empty, madvise_context, anon_ops);
 
 	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
-	TEST(collapse_single_pte_entry, khugepaged_context, file_ops);
+	TEST(collapse_single_pte_entry, khugepaged_context, read_only_file_ops);
+	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, shmem_ops);
 	TEST(collapse_single_pte_entry, madvise_context, anon_ops);
-	TEST(collapse_single_pte_entry, madvise_context, file_ops);
+	TEST(collapse_single_pte_entry, madvise_context, read_only_file_ops);
+	TEST(collapse_single_pte_entry, madvise_context, read_write_file_ops);
 	TEST(collapse_single_pte_entry, madvise_context, shmem_ops);
 
 	TEST(collapse_max_ptes_none, khugepaged_context, anon_ops);
-	TEST(collapse_max_ptes_none, khugepaged_context, file_ops);
+	TEST(collapse_max_ptes_none, khugepaged_context, read_only_file_ops);
+	TEST(collapse_max_ptes_none, khugepaged_context, read_write_file_ops);
 	TEST(collapse_max_ptes_none, madvise_context, anon_ops);
-	TEST(collapse_max_ptes_none, madvise_context, file_ops);
+	TEST(collapse_max_ptes_none, madvise_context, read_only_file_ops);
+	TEST(collapse_max_ptes_none, madvise_context, read_write_file_ops);
 
 	TEST(collapse_single_pte_entry_compound, khugepaged_context, anon_ops);
-	TEST(collapse_single_pte_entry_compound, khugepaged_context, file_ops);
+	TEST(collapse_single_pte_entry_compound, khugepaged_context, read_only_file_ops);
 	TEST(collapse_single_pte_entry_compound, madvise_context, anon_ops);
-	TEST(collapse_single_pte_entry_compound, madvise_context, file_ops);
+	TEST(collapse_single_pte_entry_compound, madvise_context, read_only_file_ops);
 
 	TEST(collapse_full_of_compound, khugepaged_context, anon_ops);
-	TEST(collapse_full_of_compound, khugepaged_context, file_ops);
+	TEST(collapse_full_of_compound, khugepaged_context, read_only_file_ops);
 	TEST(collapse_full_of_compound, khugepaged_context, shmem_ops);
 	TEST(collapse_full_of_compound, madvise_context, anon_ops);
-	TEST(collapse_full_of_compound, madvise_context, file_ops);
+	TEST(collapse_full_of_compound, madvise_context, read_only_file_ops);
 	TEST(collapse_full_of_compound, madvise_context, shmem_ops);
 
 	TEST(collapse_compound_extreme, khugepaged_context, anon_ops);
@@ -1291,10 +1344,10 @@ int main(int argc, char **argv)
 	TEST(collapse_max_ptes_shared, madvise_context, anon_ops);
 
 	TEST(madvise_collapse_existing_thps, madvise_context, anon_ops);
-	TEST(madvise_collapse_existing_thps, madvise_context, file_ops);
+	TEST(madvise_collapse_existing_thps, madvise_context, read_only_file_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, shmem_ops);
 
-	TEST(madvise_retracted_page_tables, madvise_context, file_ops);
+	TEST(madvise_retracted_page_tables, madvise_context, read_only_file_ops);
 	TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
 
 	restore_settings(0);
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 3b61677fe9840..854c5c3e3a6ae 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -490,8 +490,6 @@ CATEGORY="thp" run_test ./khugepaged all:shmem
 
 CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
 
-CATEGORY="thp" run_test ./transhuge-stress -d 20
-
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
     if [ "${HAVE_HUGEPAGES}" = "1" ]; then
@@ -508,6 +506,14 @@ if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
     fi
 fi
 
+if [ -n "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
+CATEGORY="thp" run_test ./khugepaged all:file ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
+else
+	count_total=$(( count_total + 1 ))
+	count_skip=$(( count_skip + 1 ))
+	echo "[SKIP] ./khugepaged all:file" | tap_prefix
+fi
+
 CATEGORY="thp" run_test ./split_huge_page_test ${SPLIT_HUGE_PAGE_TEST_XFS_PATH}
 
 if [ -n "${MOUNTED_XFS}" ]; then
@@ -516,6 +522,8 @@ if [ -n "${MOUNTED_XFS}" ]; then
     rm -f ${XFS_IMG}
 fi
 
+CATEGORY="thp" run_test ./transhuge-stress -d 20
+
 CATEGORY="thp" run_test ./folio_split_race_test
 
 CATEGORY="migration" run_test ./migration
-- 
2.53.0

