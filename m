Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012015.outbound.protection.outlook.com [52.101.48.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C917D2FE05B;
	Sun, 17 May 2026 13:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779026126; cv=fail; b=gHmOaj18ZZtO/dLzvird75l1trLpQio7y5o3QfyQhLLjCY1rKgOuzIKaHFNtM8+Zz8DquKMTMxmYd3e9ceOf1btcJNFkHWlf8ZbyUE6nNy4L/NUoTjwlssBWLd9T4DEkeWlk7mkcJvN03jT6TnxW46Dl1AId2Rlj69HpMYRjU8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779026126; c=relaxed/simple;
	bh=NqEbWWcIfdMqgm2MrZirvDXYsn+4yjvIokP4J90y9JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VUzGONkGqr8FAa3Vtk0Zb2JHaQwu9lEBQmuAVayARAoVQ0G7Nk6QNW26g6yhdEte2siGQ84tLkVA5tJQfP0ux28J15N+jtheFsES3iudL+tEaTEeyWdmXB5PjTDJ9fARaJFSLLJFWbdQtAC5uTrhReT5EsR2Kca0UnUQaabMeMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rZU5r1T2; arc=fail smtp.client-ip=52.101.48.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rZU5r1T2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hTKoxfQ10T8drna100NtQ8OZpni474tJRSMiCJDrUZ1rIIhiTBxFUmm/AO6s7P10PEJOqm+Tzem8IX1TTXPUGdP0TrSJbNoZ2BtWT/v70A1Lp8/V+5tcgnR4jCo7m/Ycad/uOIurQnvjYndNXp4OlE/SNaqTOAlCfh69Xasj58svSKPx2zevMg1Qy0nOI77ZRdCx1+aksC93faQJfH8bmGAG+NW4CuYVSN9qmLe0rzq3grRlzR/i7msSuMTS5HdayBVChwUdD/TsaYxyAR2n1hRFMbUTCdQ7/e+0p4pEiKkZHhURTZdaXKYDhv71vOjhebakeKLEn/DfZUL93kVb/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N5YqtxDlewapOrYpV+OyVW45DJyV4JExgBS5FT5cWFc=;
 b=fatYHM3aSEvuXaq6ODSP62uiJigSciJyqTUiz/YD6JFVrEmbPXDWs0mZVqzc8GYO3FgABSM6eHjxnqwI/fA3LRqW372/AKaO62BssJNOzi6GTqcrCsxCpDp6iwJjNigKBzqMu5FcXl6tqHiyJr/QHOgnN7F1SQQs+OCp7jzQyNAbPTW/xR9kaB+BGLM1BbBaE8aLCD9ssrSoIijx5tlDe+l4Y1GPO+r3Tj8RxMimz3SkRmUYobdQsN/YqPjoR8X+P1g3CtSDi4/gB3iaPeILjGfMUYI+AaEXDcw/AULSBx7a0qb131QwBc4PXPlI2/XLjicl/Bod5zkaPW1Epu8jaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N5YqtxDlewapOrYpV+OyVW45DJyV4JExgBS5FT5cWFc=;
 b=rZU5r1T2eFlg34BJABByuJ7SJr76j7vjT52wZ64nzktu1aS3cUEUYzoLMmOzNgEuYRVJ8B7KCY2yu5bknWfHPQ3uKDJnXUMm5BFjFHhGO4GPTZHPVGi7aerXYdZJjka5+w3BWk2lwesSEVP4Ez2UngPEr3uFtySBiYlrS0E+mIG1FUhJS6WOe5UzAFD2m8UMpj3hoR6ov+Q7RL34W2nfCySoZ9iK+bUWqCmeTzfCEn3QLolpHSjm4B0KFoIxb7b7m6ZLHk/YfDJZiJbD0VFOP//avO5RWNCTMZY9Pu57jde6U614kCsDUW1AoEmRNKPWxWbF7+UmcCXDzNgsnuzQdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:12 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:12 +0000
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
Subject: [PATCH v6 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
Date: Sun, 17 May 2026 09:54:13 -0400
Message-ID: <20260517135416.1434539-12-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0020.namprd18.prod.outlook.com
 (2603:10b6:610:4f::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: 95abea1c-d8cf-4722-be9e-08deb41bea2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|20052099010|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Lf1rE25j8H8iaxD5dj8X4hAdGtIbcUWJbI6iltAXQ+NSCho8tGzH/5s9C7hWX7w927OjnEripm/LZVOTU4NYEvxJpuptpzA5I15WIYg/XT+KQPWstfejm1iAsKy8K7nqn17SzcsJj8NJEI3Lof1QKvAv9tqJ5/Da5b4XAo2LcNzrOnymesz/A4xEUalOLmPrdPukorc+YykTuBR2YOmNpalqPE3SWx/oK4Sm52dDqwAYxKn6XAQHvJbJWKrDCBvy4MU3PGobvgjnui/Jkh7W5EmhTVFtkxPOkgdj/z2LCFq8+YPvSjE/318Y+6eVb8RFDR5G7iSKDxy3qW/vrzFOK5V95GU59bf1INurgkJb9mU9/ITro32uEeYnsZeWmnl5aA8f0XfbuyKd39V4EAwoDW3dOl9AJHEadUJFh84pbbdWD4cLM+Lg3Qhn/8lIyBLJJ53JNo+eoDI5bWNmxIwDmvwVCZDUDmJenLxSFDpIIcIQioPJBEbsTVDMkxKQFUoSeeFRmG0eD4Gmn21n/hH/8EwUDygecS7jyeBIQJZurYyDjGah76tUDYyH7Ir7QL69XPjmzmhv/Pc7USt7Fodf7g3ebJq8ZIVMZypint8F62bW0iovE6U/4+b5Z7/QkZViBe3Gnb74u4HhGpYYXoBjk3Q4aYA2kWoocuXHI5TIF/SvydCiSBq50DmesOtmV9Hj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(20052099010)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x8f7cZmla4rtKGW7jkv4qNcw1Eoym8F+Xyz9EPcgubIMNaHu+A1fuPooA93r?=
 =?us-ascii?Q?REaUx0mGV6fvtEKalhxgkYzjLqWBJF2f6rRpkSC8WlwQaljyhpB8tQQwtqhG?=
 =?us-ascii?Q?haNjHj7O0jk1ByJyXSVXcEiojTW+9OI4MjLfQSOfU9cJoBzWEj+e5t0ZY3Ub?=
 =?us-ascii?Q?0oVZGsoPmtdu8/wKYht8MpBmhbSjO5LehZN1eio283fM87iVh/t6C3EM/akM?=
 =?us-ascii?Q?xhd9J8sRFJ4sLqcPxhvvaJiPG5XG3VvYKNm1P1ouXz+TzTr8WDyUYT8H2jiM?=
 =?us-ascii?Q?pNYBznEgdRkDrb9GkQEnZW5V2ahfgwV3TWIazKdAUgXrbCh1JkdQk1Dugl8V?=
 =?us-ascii?Q?aS+ZovaMl4ZblP/kDEf14VSFyYDRYSsPhowiyHBhIy8obLhQik42pLDxz6Jn?=
 =?us-ascii?Q?4eBYckP5pD3GhGHsGvzfdPnbTFf+J9MuMj53nnE6Q7sXKzv+vJsHPjgLMtj5?=
 =?us-ascii?Q?DOgenvAo8fUHLnwQW5h/fTPOX6SXIpAnPcy8SV33GOQADfXPFTNKK2gx9+X/?=
 =?us-ascii?Q?e4qEOZfhyig/1znrqQUH9++bI5Q+iHWuiHzBwp1Py8HamQs5rKbb5dvvGPiy?=
 =?us-ascii?Q?3/riXAu3T1IL2D3pwvWq14+p/EoZcQfOq9YrExwBjTQK1pTnJjuCheYPPJKE?=
 =?us-ascii?Q?dIt4PBVJUDY7dHHBsWskRXjr5TBytI30m/BoLymKvUgvWrm/5k1sf/gA6xkJ?=
 =?us-ascii?Q?/+XBqDci+YIVTaW+sMRLnHDGGKtay4pqmRysc1qpMHxavWb6qWn9UB3SNrng?=
 =?us-ascii?Q?VHfU+YMSzCiCqwBu6tcN+hG8f7EnDM/OS0VfuDpsyQ8t1kLjdt/a5Df6u6Pw?=
 =?us-ascii?Q?YJ7MEOXJqeQvfixM+2TmyP6B/Xl4IG+oOphPNweWQZ8kHgOOHNYQdK+EOVce?=
 =?us-ascii?Q?YNjdtkEsSzix8Fx7Lw+j4YwtDaEj943+7btlJw46dNs1bZjUcydZOMF0p4L4?=
 =?us-ascii?Q?NZ4i6XMz7WBIHAWKAkphi7kg0D9tCdLyQqI4Py/Zb8Bccmo38Q1ArfqY4UbW?=
 =?us-ascii?Q?b05d8KdjkHWjF/lMyEX7RPVULoTn15bf/9jH516thaQOri59nLOBhvt2Qjar?=
 =?us-ascii?Q?BJhVf6rPBlN73sQJmw2ZC0FOu4fcL1uYoveh4AiGt89UdmKNYH0GKxqyQHMw?=
 =?us-ascii?Q?v0ogeJ6W4dz3IxgtkzVxfjoWHVor1y9eSeUvYfd2W6OB/pQdj42r8KnThsih?=
 =?us-ascii?Q?lSAKRw0nVAMzeZoe+iG7Niw6oRGv7HkXhQe/rCV8wM+PtR27wEeJ97/QWTBi?=
 =?us-ascii?Q?mW5Au54FCgCiCZA4iDNmtdHexcQ2Zf9Uqa2yE1Qcx4ANBT/RNi5mBZ8r7jOe?=
 =?us-ascii?Q?mktTLLiVX0r9OXXgeIP3b3GJhTRhvNazEgP+/w4VbHhlLgIiG58d+gvpcVrU?=
 =?us-ascii?Q?yVzXFwOlW2VpfMCFuo5OpIgE8RRtuStbZEyjYSJEWrSn/aR/DR5a3EOlISYW?=
 =?us-ascii?Q?NrMEcSzGhLTLQKV0JCD6kLq4EVXakSCD0xc5lWCXbs+7nLBb5v3L91Jdz+QD?=
 =?us-ascii?Q?cdJIxPYgU2gZExcUeshtrFqYibeiUGR2XHYeG2gaDuSVTDhkCMGNVnN/9dAk?=
 =?us-ascii?Q?HVIuNhJEVLi5RCbNErs+kPFvQCHIMi2/OQUrOimOncDm1zXh1ArcKFLkF6gM?=
 =?us-ascii?Q?toqedh6viraqxyhs5MoMvbfpsX7ekYVG46oA4nhG/ys/hju6/7IDlP/H+7XX?=
 =?us-ascii?Q?Jk6Xt/y8vPT9vKcLNE0L8ufnc2jF+0BBqmDUVqNWJ1E8yc05?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95abea1c-d8cf-4722-be9e-08deb41bea2a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:11.9967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ojVEzifhr7hkuqkNqer/vQmdNYBO5jF4RQ0OnNQIWmUntpHfAsJW99rtdrGt8xSs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322

Change the requirement to a file system with large folio support and the
supported order needs to include PMD_ORDER.

Also add tests of opening a file with read write permission and populating
folios with writes.  Reuse the XFS image from split_huge_page_test.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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
 tools/testing/selftests/mm/khugepaged.c   | 125 +++++++++++++++-------
 tools/testing/selftests/mm/run_vmtests.sh |  12 ++-
 2 files changed, 96 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index c8393ca52cab7..7ee6dfe93b3d9 100644
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
 
@@ -364,8 +366,10 @@ static bool anon_check_huge(void *addr, int nr_hpages)
 	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
 }
 
-static void *file_setup_area(int nr_hpages)
+static void *file_setup_area_common(int nr_hpages, bool read_only)
 {
+	const int open_opt = read_only ? O_RDONLY : O_RDWR;
+	const int mmap_prot = read_only ? PROT_READ : (PROT_READ | PROT_WRITE);
 	int fd;
 	void *p;
 	unsigned long size;
@@ -400,14 +404,14 @@ static void *file_setup_area(int nr_hpages)
 	munmap(p, size);
 	success("OK");
 
-	printf("Opening %s read only for collapse...", finfo.path);
-	finfo.fd = open(finfo.path, O_RDONLY, 777);
+	printf("Opening %s %s for collapse...", finfo.path,
+	       read_only ? "read-only" : "read-write");
+	finfo.fd = open(finfo.path, open_opt, 777);
 	if (finfo.fd < 0) {
 		perror("open()");
 		exit(EXIT_FAILURE);
 	}
-	p = mmap(BASE_ADDR, size, PROT_READ,
-		 MAP_PRIVATE, finfo.fd, 0);
+	p = mmap(BASE_ADDR, size, mmap_prot, MAP_SHARED, finfo.fd, 0);
 	if (p == MAP_FAILED || p != BASE_ADDR) {
 		perror("mmap()");
 		exit(EXIT_FAILURE);
@@ -419,6 +423,16 @@ static void *file_setup_area(int nr_hpages)
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
@@ -426,10 +440,18 @@ static void file_cleanup_area(void *p, unsigned long size)
 	unlink(finfo.path);
 }
 
-static void file_fault(void *p, unsigned long start, unsigned long end)
+static void file_fault_read(void *p, unsigned long start, unsigned long end)
 {
 	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {
-		perror("madvise(MADV_POPULATE_READ");
+		perror("madvise(MADV_POPULATE_READ)");
+		exit(EXIT_FAILURE);
+	}
+}
+
+static void file_fault_write(void *p, unsigned long start, unsigned long end)
+{
+	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_WRITE)) {
+		perror("madvise(MADV_POPULATE_WRITE)");
 		exit(EXIT_FAILURE);
 	}
 }
@@ -489,10 +511,18 @@ static struct mem_ops __anon_ops = {
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
@@ -505,6 +535,17 @@ static struct mem_ops __shmem_ops = {
 	.name = "shmem",
 };
 
+static bool is_tmpfs(struct mem_ops *ops)
+{
+	return (ops == &__read_only_file_ops || ops == &__read_write_file_ops) &&
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
@@ -513,6 +554,10 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 
 	printf("%s...", msg);
 
+	/* read&write file collapse always fail */
+	if (!is_tmpfs(ops) && ops == &__read_write_file_ops)
+		expect = false;
+
 	/*
 	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
 	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
@@ -579,6 +624,10 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
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
@@ -613,16 +662,6 @@ static struct collapse_context __madvise_context = {
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
@@ -1098,8 +1137,8 @@ static void usage(void)
 	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
 	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
 	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
-	fprintf(stderr, "\n\t\"file,all\" mem_type requires kernel built with\n");
-	fprintf(stderr,	"\tCONFIG_READ_ONLY_THP_FOR_FS=y\n");
+	fprintf(stderr, "\n\t\"file,all\" mem_type requires a file system\n");
+	fprintf(stderr,	"\twith PMD-sized large folio support\n");
 	fprintf(stderr, "\n\tif [dir] is a (sub)directory of a tmpfs mount, tmpfs must be\n");
 	fprintf(stderr,	"\tmounted with huge=advise option for khugepaged tests to work\n");
 	fprintf(stderr,	"\n\tSupported Options:\n");
@@ -1155,20 +1194,22 @@ static void parse_test_type(int argc, char **argv)
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
@@ -1240,37 +1281,43 @@ int main(int argc, char **argv)
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
@@ -1292,10 +1339,10 @@ int main(int argc, char **argv)
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
index 3b61677fe9840..b73921b2cac02 100755
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
+elif test_selected thp; then
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

