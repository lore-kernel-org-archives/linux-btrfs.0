Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012047.outbound.protection.outlook.com [40.93.195.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFD43064B5;
	Fri, 24 Apr 2026 02:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776999163; cv=fail; b=c8Gm8JqBHZct0PQOZjyC/jiTls0j9WjmfkZdLdHzUhzXGbG5OlgTrBNlBiwCfUwaETy2I+Wvg2wmxlIMr83aTlIVy/sS0L58uiILUFZaxEZQITuPmBDo+Yu9IbKv62jM//jnVX/z3LoicorcIFqTBSzbMn1Mw4eCAhSgiYeUH+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776999163; c=relaxed/simple;
	bh=JLZQKJe24GyDat/cNetuZPC8pkEX+HgcMH/HD3OV7To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hU0SdNsfMQMnbGZtNubRdVvfZOu+3muW7dKtAH6IWc8hu90Hc5EF7AugZbiRJyvg5h2FvCa/HPvAoH6VIkfNn8vx77BbURwBAAG0Jh+PYQM/IvrdsraQFU//pqiUvE7/TRiS7bDJ+uh82mPA+w12rCGmG3KPHKn1CeXSdI12jcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fQYqEpyg; arc=fail smtp.client-ip=40.93.195.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fQYqEpyg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jSRtkz0ZD08ZaJRBrwAiyuBODS4L2MyhibDWTylpI2ODmotXVmPEfUcrk6uS2m7M4APLoZB9dHZf/lVo8Gb4o71BXhz5G7yEo7+1eyyMneIXQlzUUOapb92UPfuGR6mmLJ955Zo/OddElNfFkbW3YzXxS67QGrVYE9hNXvyMx+glilKpRxxjAYbogAI+XbfnxkEZ1KxOqpDrfeg+uXX9ec7CdrOD3rxgZ9B4lERAOIjy/UvxPp2cR1/6jAq6kgM1TbqBkK6NRv0Lz1IS/NLk1wKHfXmMD/jr9x0gpOzKDMjt46/ItuYMX45rki6m38tH+63JRumsUhmQFKj5g74sGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fyo+9kUKhK8zmkxPkdDHVKTUVAufCVx1epCFlQueY9g=;
 b=FEWQHgYquRTXYx9OhU/ebstoXlSQf2fwXgRDXQs83SLzuqWTkRcAoPCpCczSh1aytyE8yJA/6JsAgCzc/rzewy+7X+nVhQnkNsi363JafJU3NUnUqXeRee4Kb1VwbcWLrLcWXJeEpPMfSz7l1W7VL/K0Cd6fdOQQeM3s1+JRfFe/Z9equCCPBXFNUNjzv8MC81aod+jvDhGsSoi34Ut7CvoDxuY4pu/JJ2+OYpM7Fu6RgdO7GmUCY/x+iHVvetoq/duzwjsGJAwMsYlHMbUeV23x9rZIh+sDHQx0H95Sn9lp7e2a8PcvpBc2STtjNQMdaSQzO/zGV1Uk4e0mH0o73A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fyo+9kUKhK8zmkxPkdDHVKTUVAufCVx1epCFlQueY9g=;
 b=fQYqEpyg71gvn3n97nM7rk9Kfh3kKyiWSyEVi58Z8fSInJoGNxnMO2QL6ar6KJSh+brKq2Kt0Wm2IoGy+O+UzAc1O4vJPzqyD0VccsOud5RDPPdtEDHm8GpQlkAPEUAiHuBaIDC/31ikXz54EohQtNL43GDUvVp8i1DfOE7OhTswaccuYv0eVwnfUOiiq8uqmwAEukERDGnPvONrwX5/zKHdIHoALY+QgMMJ2jzMvAD+G5PPThGCHrItVXhJRspxZFjytt2hjlQ234J2Ld0PtOF8RJxGYLvSEcuR5QNlt796Eu8nr+TPZuUlmI6OKUWFmZ7LC/y1rTK7ZqAHrJeWdg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7825.namprd12.prod.outlook.com (2603:10b6:8:14d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.22; Fri, 24 Apr 2026 02:52:23 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 02:52:22 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
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
Subject: [PATCH 7.2 v4 11/12] selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
Date: Thu, 23 Apr 2026 22:49:14 -0400
Message-ID: <20260424024915.28758-12-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260424024915.28758-1-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0017.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:85::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7825:EE_
X-MS-Office365-Filtering-Correlation-Id: 2562fbe8-5c45-43d2-5d29-08dea1ac8269
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|20052099010|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	ka6vN2Qb0hWtzKMrL+U88G3wnn4qIPgG7Ies+W3cc+fXVk/t1eegT0CQBIrOacRhNGnqQSNOUd+o4K5RXs7A2789IRqL7kK6Bs/I+DaB2sXKvXGyfnXF9IAggYkp7rCT0FTtJO0Uwdn31R5jL1yoK3ZeLWBae54GqW+xdnMJp1qqtZWClj9j1rPrymFWW85lSy+tkPEbEWHqaVPc6aUqRkaKHOWavbcx3hxf3TdOzMzeLay3lpTFzI74/gFBuf2BuMARrDQCIg32dUQtNlQ1fK3uvdWMILXQCV8tpYgA/IsY3qaBZ1neXzS73k51r+oYLeRNM5FNtRV9FyztuUZmFt8pMrc4QyOG1lvREIeTcKo1RHt/6wgMB7Bu2ztwgyiTQ2bO3zPmIGW1UvZZSMGPQP7cMFkuIOE+Ylg1Ji3sKwvx+TeovQPSUPlPgmlrNGj+ZOCW0kqe8H2dVOEf9mVjBbbbmZZeLUsApnls4By9/Gv1kFJ4FOpVfiNmUMU2iNlFq3pNnhY5SLcZgUxtQaQTR2nEacCz41agWfzVU/l6exN2OZTU1utHb0mvVmubGjUVHw3tk2B9BiGargoQWEJ1OE4AkHCxHkIRxN1ncn2F/tFEf0965rx2mATA1UBcCpdFug411g/38I8EQGF7VLtmlt5JlwA11pEgRBVcvq7LMLGeXxamWNM/GuvjiFZg8dulr5N1Sm1m1yavSt80mbJUezTnlMz7D6ZsYRcY0vi1aww=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(20052099010)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zqyL5wS7wSoAPIWCbXs70nQWZNfxT/9v5IB0NkZgPr/7rA9FUplyRUvSQdxB?=
 =?us-ascii?Q?eEqB3EPUuaB3pegwVMZlIX3hEqcvYTZbgxNpoWPEmvrFFX9GQsPAFiRf7m9t?=
 =?us-ascii?Q?cdw8IGQQCuiXouRI3E3c+xVpina2PNPoKIRw0XKX1DUSE/9DavtgGGGGFqND?=
 =?us-ascii?Q?g4ZNvBYBjTKu2OQL6zyfrgGSC3dSNdaxHCMFyl3tsw+HxPnko2SixxiStYxM?=
 =?us-ascii?Q?YwI1zA/I+kLEG1e5whjIfoVNMCVdL74Ll9wfEOmf1CFwInrz3IB+5HxGT3g7?=
 =?us-ascii?Q?2VL+2QF7OfmL1zZixLwWHBR+9eEVrCNF+jcQYhnaoucZSyb4x/8JRHcmcGhC?=
 =?us-ascii?Q?H0nxu9n8vuGIUZkdDT24bqLa8AivY62iM45Fq019QzZZsQ/XkdIjQVVyCK4O?=
 =?us-ascii?Q?/zbIIbbK8EA6a3LFbrcTBhKwIosLX6/fuxxwfUL6R9Jk+YDbfwfDJVcxGQ1c?=
 =?us-ascii?Q?9tN4mqgDiCScUVO5t5wIigrEvstRmnnA7E/+TDZ1ZnV/eDq1Kdx1/gHU0hNh?=
 =?us-ascii?Q?o8vRcWEPJ6/G+rPBKX6x4e67AZu1yobGtJJAdq5Y1B2QfuGKz1yIYH8zq4iK?=
 =?us-ascii?Q?ikiVOxUmEUKCj+0NmSMKGUaYaLvg9tvxtvlUjsFEyhgBesnhYCWUpNQsQ2Yr?=
 =?us-ascii?Q?lvUO/S3bMCg4qqeUVT6DvpEQtprpLjI2ZGJuFDQLmA1Ed8G92XCaCB4/kT8/?=
 =?us-ascii?Q?hYlMSPrFx9gf3kYvE6+h7ExVp2jWH48XAYiMOyLTC9Wrg6GwzDJiOO8AMbAr?=
 =?us-ascii?Q?z2pXFzXggrhObE8Dw0354NMvvUgAzmJhw/MMBRmC5BYQUe3b8CwYqmZqJhVw?=
 =?us-ascii?Q?zKlb44frlSG/vbr4YRe6gp5rghutPQA47b0W5DA8xTmKDs0wpJ7pK//jKJDR?=
 =?us-ascii?Q?W2wLK+bu+7f+rl+0QvNwt5Z1iSPdUadSWDhafXyD7Yuf9xv+Q2dFehFqp8/R?=
 =?us-ascii?Q?JInbdpdTCm88hlX9ih26BDm6LIxkTYEALzGZcZH6+DzOt2b09+MhTF87YwK8?=
 =?us-ascii?Q?PCBtJolJM9PPyvW+LF0YQTkMIZU+e6TCVW6rTOmEwgY/tmTBprxeA6DZqYqE?=
 =?us-ascii?Q?rZYSI8BRh8jJcLmBggImR0og72a2Zd+YNajOPXsT0lNZJg5OVGrisTufJar2?=
 =?us-ascii?Q?HYSjvjHJuf3WZ/D+Ot1EeH1tNHx7G34ct7EBFctm13k5pdSTXSXQzKTNydLL?=
 =?us-ascii?Q?7FBdcJSeLYarTm+MHHeYMfhpVlIgXrjCtStfhbfl2fzvvSmpqOTV9QFHdqW2?=
 =?us-ascii?Q?zhMrNSrgT3dY2GgsPwO3wb0s1BGo0XnIs6C3OZP5EzkmDjQr11Osw+wOwWAo?=
 =?us-ascii?Q?PcB4xiYwZfxwreq0Jt1/77DseuxIOyBoo+0n9IbNAHaleIWgJmfj4SGCd4eJ?=
 =?us-ascii?Q?1SXs5VTT4DgE9N9mOvS+HP4QDDqEVpELh/xcFSx1/2fM13qx3FaGQcmv8vRE?=
 =?us-ascii?Q?ZnH/+xok/IbF0fN/C5sQtfXLECuTq+bVkLqSjrG5TN0xAZ3cLs1k57zEUoT/?=
 =?us-ascii?Q?ILga7xUJ3LSNnMwkxY4ry2GafUiIP0Vfv8efmqVnBSJlEWjewkHN/0SdCSfF?=
 =?us-ascii?Q?sAvIfCxsXlNqtzY1bEBxuculvijBll89UjcsFZrWCdt2+mmFcwqblHLqHAtX?=
 =?us-ascii?Q?mf4vThFJ6eoh545X+D7fObh2OznPqd1MP3E3uPb3tefG5G6nRrZSvCfgFUDM?=
 =?us-ascii?Q?p3QMFiVZ1g1EJTVuDGR5wN2+WFOH7RqFnqOdwN9VOzs4xw5w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2562fbe8-5c45-43d2-5d29-08dea1ac8269
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 02:52:22.8800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 49MbHi/ythK5MuZQi+yydGEfROnWQX1Ff2LagYtodwPPDZ+Vi5+uk2wbvgeWwCyN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7825

Change the requirement to a file system with large folio support and the
supported order needs to include PMD_ORDER.

Also add tests of opening a file with read write permission and populating
folios with writes. Reuse the XFS image from split_huge_page_test.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 tools/testing/selftests/mm/khugepaged.c   | 110 ++++++++++++++++------
 tools/testing/selftests/mm/run_vmtests.sh |  12 ++-
 2 files changed, 90 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 3fe7ef04ac62..627472cbc910 100644
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
@@ -388,14 +393,15 @@ static void *file_setup_area(int nr_hpages)
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
@@ -407,6 +413,15 @@ static void *file_setup_area(int nr_hpages)
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
 static void file_cleanup_area(void *p, unsigned long size)
 {
 	munmap(p, size);
@@ -414,14 +429,25 @@ static void file_cleanup_area(void *p, unsigned long size)
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
@@ -477,10 +503,18 @@ static struct mem_ops __anon_ops = {
 	.name = "anon",
 };
 
-static struct mem_ops __file_ops = {
-	.setup_area = &file_setup_area,
+static struct mem_ops __read_only_file_ops = {
+	.setup_area = &file_setup_read_only_area,
+	.cleanup_area = &file_cleanup_area,
+	.fault = &file_fault_read,
+	.check_huge = &file_check_huge,
+	.name = "file",
+};
+
+static struct mem_ops __read_write_file_ops = {
+	.setup_area = &file_setup_read_write_area,
 	.cleanup_area = &file_cleanup_area,
-	.fault = &file_fault,
+	.fault = &file_fault_write,
 	.check_huge = &file_check_huge,
 	.name = "file",
 };
@@ -603,7 +637,9 @@ static struct collapse_context __madvise_context = {
 
 static bool is_tmpfs(struct mem_ops *ops)
 {
-	return ops == &__file_ops && finfo.type == VMA_SHMEM;
+	return (ops == &__read_only_file_ops ||
+		ops == &__read_write_file_ops) &&
+	       finfo.type == VMA_SHMEM;
 }
 
 static bool is_anon(struct mem_ops *ops)
@@ -1086,8 +1122,8 @@ static void usage(void)
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
@@ -1143,20 +1179,22 @@ static void parse_test_type(int argc, char **argv)
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
@@ -1228,37 +1266,47 @@ int main(int argc, char **argv)
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
+	TEST(collapse_single_pte_entry_compound, khugepaged_context, read_write_file_ops);
 	TEST(collapse_single_pte_entry_compound, madvise_context, anon_ops);
-	TEST(collapse_single_pte_entry_compound, madvise_context, file_ops);
+	TEST(collapse_single_pte_entry_compound, madvise_context, read_only_file_ops);
+	TEST(collapse_single_pte_entry_compound, madvise_context, read_write_file_ops);
 
 	TEST(collapse_full_of_compound, khugepaged_context, anon_ops);
-	TEST(collapse_full_of_compound, khugepaged_context, file_ops);
+	TEST(collapse_full_of_compound, khugepaged_context, read_only_file_ops);
+	TEST(collapse_full_of_compound, khugepaged_context, read_write_file_ops);
 	TEST(collapse_full_of_compound, khugepaged_context, shmem_ops);
 	TEST(collapse_full_of_compound, madvise_context, anon_ops);
-	TEST(collapse_full_of_compound, madvise_context, file_ops);
+	TEST(collapse_full_of_compound, madvise_context, read_only_file_ops);
+	TEST(collapse_full_of_compound, madvise_context, read_write_file_ops);
 	TEST(collapse_full_of_compound, madvise_context, shmem_ops);
 
 	TEST(collapse_compound_extreme, khugepaged_context, anon_ops);
@@ -1280,10 +1328,12 @@ int main(int argc, char **argv)
 	TEST(collapse_max_ptes_shared, madvise_context, anon_ops);
 
 	TEST(madvise_collapse_existing_thps, madvise_context, anon_ops);
-	TEST(madvise_collapse_existing_thps, madvise_context, file_ops);
+	TEST(madvise_collapse_existing_thps, madvise_context, read_only_file_ops);
+	TEST(madvise_collapse_existing_thps, madvise_context, read_write_file_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, shmem_ops);
 
-	TEST(madvise_retracted_page_tables, madvise_context, file_ops);
+	TEST(madvise_retracted_page_tables, madvise_context, read_only_file_ops);
+	TEST(madvise_retracted_page_tables, madvise_context, read_write_file_ops);
 	TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
 
 	restore_settings(0);
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d8468451b3a3..50dd6b6d0225 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -489,8 +489,6 @@ CATEGORY="thp" run_test ./khugepaged all:shmem
 
 CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
 
-CATEGORY="thp" run_test ./transhuge-stress -d 20
-
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
     if [ "${HAVE_HUGEPAGES}" = "1" ]; then
@@ -507,6 +505,14 @@ if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
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
@@ -515,6 +521,8 @@ if [ -n "${MOUNTED_XFS}" ]; then
     rm -f ${XFS_IMG}
 fi
 
+CATEGORY="thp" run_test ./transhuge-stress -d 20
+
 CATEGORY="thp" run_test ./folio_split_race_test
 
 CATEGORY="migration" run_test ./migration
-- 
2.43.0

