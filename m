Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011029.outbound.protection.outlook.com [40.93.194.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C662A331220;
	Sat, 18 Apr 2026 02:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776480314; cv=fail; b=NGAPv4VQNbDnNSVi9fwLc85L6yivrt3gRyS8drldyreP78COsDIQfmnm2OOS4sejzhOmeUroH1LqCm5/rC80x9Bucyhp2YTXOvKZf+jgJynJ5WYsFOs1ZfQrHERPd5w7DkZhSWyit00VVcA8w3W3OqaVjGlT00ERtw6Zy3ZopPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776480314; c=relaxed/simple;
	bh=JLZQKJe24GyDat/cNetuZPC8pkEX+HgcMH/HD3OV7To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U+EnGKGQLMzE/4PWTanB6Mr1omxSkzmoGuyla4VghuiwxMVGO2Dlq3i3ksRbb7O623KrlWga15LTzAyRl7FtZUr5eoIO0gaK565h7hX9jtCa7G5xslGOTHcOGvO0W0qdABK5ef8vB9fsAQczLp9YKoB4G+HmdivMJ8oOpBsMNfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E66Qz+G8; arc=fail smtp.client-ip=40.93.194.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E66Qz+G8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wLlkaYPut8PA8LCdyJelhqMyueMBCZ6hYAyVwTlyGY710bEzSLp/RVbMLJEQtucCqQjj3ManJkaGbXHnlNGVF0buQL/EAliZU8SqEYur27OQdsmiR9xa1Bz+DzpxcXrdZDSDvfMgMl1AV2AUbHVrq5djQviX2/WfaR87YWyM9mWdBMLxu25auw42kAVNlp78uzC2F14I8QIWd0k0zJeZ8QQRcISKivsEcS9o4RrvRzXDnbsw3Z35wpfrFVf0i9a256MXqpYd0eIcG+RQZ5BTLsvnnTWhDfWRLS+ePJ+lnCcAOln4Sb/A6tYbKPSCnldF9SwNd6tE6DwmUzgqRxCMaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fyo+9kUKhK8zmkxPkdDHVKTUVAufCVx1epCFlQueY9g=;
 b=kKWgBeUqx5XpTU4jvaMQmv12o5nbrgqPKeSZ1wOYkcMRucVIUYIKMx7YNaLvOpC4fD5uYE+WK3O80nnHEuQc5zhEJpXdgap32W61czXUrk+hq4J+YGoqp5/RHMoO8iEzWog2/lK7N8diD3M2wacsYKFPa+DBNqfD4ye3bstRtHk4zWILLDjN4XaEEe5hVNruN18Rr8sSemS9dZLsSMqHH4NbQJzp5TFuo9KduMLGB5OYrEf2XI9qYdDjLHg0EI9b47S0E7dTCdJbN2t96nG8JUq1PV4m5vBUWUL3FkzzdWtx0ZNOnTbzxDktazp4BKDrH3dhN1EApdXDNbhpfKYKYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fyo+9kUKhK8zmkxPkdDHVKTUVAufCVx1epCFlQueY9g=;
 b=E66Qz+G8W/NrjOYmlwDq0Aj0aVtO44EGXdUNlznyhQNTFAN/KjiU1qhCzZnOmWMWQg0xDX0rksCYIsaDqz/Lmn6f3Dfkjijl4Arn8cpjgngC0GnLQAyoElbqljL+4D2QVEc8pirLDhrnxklyorOUpidY2PTcQEGATksH7+aCTD5xomp5BZ25oLQpV898S+nvCLevichtUpkGFhwGtoV/bAoP10CqjBey1RW0XpO7YoDKb4qe7r5aGViy5365hHV0RXIDOlyFhdntj0gcMa4cf3RTEGHH6whDlllLMTvoKnBT+mJ3NlQL83PcG5B7sa+aqPFqJ0za8FYWPt8c5n116A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Sat, 18 Apr
 2026 02:44:47 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Sat, 18 Apr 2026
 02:44:47 +0000
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
Subject: [PATCH 7.2 v3 11/12] selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
Date: Fri, 17 Apr 2026 22:44:28 -0400
Message-ID: <20260418024429.4055056-12-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418024429.4055056-1-ziy@nvidia.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0155.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: c2924642-6e9c-4a4d-1f5d-08de9cf4746a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003|20052099010;
X-Microsoft-Antispam-Message-Info:
	RXO5ycDtvDWBL2xAcbKaH9TvmFPbq+OsdAPY3Iq+sIleufVDSkWPwAt04KL+/anOA7eoDpfYTTu6+2KSzJ62IHiVCiQ9DblRmFK5EsPZpb2H0G/FrVsaW8SjUjWyC3iQiQqZMlGgCBPWdfqcJ5S2TZMqt3mf9drkvDvovfwugYPOC8TeFLkvxgtffbZEP99ZWZCKC3bUfTLG+UTJ8tPAOKE3MTKnPB+GQ8RM5SArjg1G7WRzhhhITyKKFiEnOHRlzd0OiV9nPDojYtmtrmzgq9Ew5j/PxqGdlF5MRiOUG7X1XdngZGv282rm0KZmSv9h+kzqJfJfeViZPiTLGSNgduCjEBiGOEzWyi9ceAMdsy8wspsBkPJj7z+vs4rVhZ2sMSlFPwwP0EIniVSzc+28DvucjX/YqxRNrpY9I6Ur+JUPUSGillrTFhkLOwZRfRAHnL/A51f9VtH9i6i2rjg70rhJUteJGPcznrVVo+Sn/+7bWr0w9uHT5a0YdUCBCKbL/B+8KKi5cZaoKAwFGVcNdC4FqKhUUUQYVtMptwSYTJBBHnr6eO+P4MFHevqArZ7NzyUlfEZnckHBc+wwU5I0qR5LuoNWBNG3J2rbXN6GGkPouvlrKUykpA1XeMLIVDtoaxt86kzEYAzPnWZKC9DFbw1pbL4raAGg4OqBuTrMVPHTjCbKmM2cbp8G0RDSv9QmXnI0OhqKRZoMHv6xYBl8+JOINbjLAJF0k9vlc7wmnXU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003)(20052099010);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gwo60JGgVxFfqmKLR1unNbAOjwgnITd1uq7h/cEJwjXODxQD5i7Q3N9mHrrz?=
 =?us-ascii?Q?0TPSPj3HGtAItO7e0vnmq5c+PGzXm8DZini/fGVCITSDlY3QX6ariSTGFckC?=
 =?us-ascii?Q?v+9ns4XOgUq8+Xu9FSkdra7LU0lMlDblgouKSiLGKFKLV/y1dELT1kAGbpE+?=
 =?us-ascii?Q?lIXrDhF6O6dhU2V1rOQ49Qt9HZrBsi/2zZ//e/P8F0m3rmyJqSYi3wISDl/g?=
 =?us-ascii?Q?urVHZaU9NO/yyrNypeeWUl6stUlnPNyE1si59BJ1ECXSYN9wdCQtEwCnQjpo?=
 =?us-ascii?Q?tb8+zqDcQ5sjY9Ws79vAYJUnlM+gkB5UDZAx8gIiGDtxgpvKIBXiDlowNsGS?=
 =?us-ascii?Q?fKj3ep60GGuhgXxwtBwQJTSUdpE9jfdiDzwQ5NPt+68+RsKGI7KUlJAXLO05?=
 =?us-ascii?Q?fI4AZGp2TAwVxmxklh2YHfshH8643WRsF+IeHJ9HfMD84zN0O7KxpTyEuKkc?=
 =?us-ascii?Q?fluFQXRrRNXVUqDIRc7FYFtkxXlST2K448/U2kZ63lAk7tipL1ITLXyI1CcE?=
 =?us-ascii?Q?k8xfA8weHBXT4HiW5BB8NX1zb3lQfO2SmiEjEGUgTLcmmflkbGaIGBxoP9WY?=
 =?us-ascii?Q?VY1mAHNFRWAxLq4UVUR/MFku8KISjWCFokUu8BKQ2o0gomuDVGWYW08MDLjd?=
 =?us-ascii?Q?g70q4PO8oL+dT1zs+PsqGofUlUP1v+gH6pfaD+T6YqWEnxFkrX+rByq09rKl?=
 =?us-ascii?Q?R9ii8eb0oTkQTnJ689d7ifBSU/jYyYGg+TixC5PWebs6wS0DkXSo7LOUwKWg?=
 =?us-ascii?Q?HjwVDabBbT49G8SYX3eNiVE+qJEhMmOVo15GDp2ZHCFMRWvqB46cgMVZwxxn?=
 =?us-ascii?Q?ywYxYm8jZQ/2c/lRSPugfdPzR/e9yY4C2p9Zj0OIP4pTnL+pQKQOe840N+HI?=
 =?us-ascii?Q?JUSb9ABOKDvMJVvrWk3yEqt2RJUt/w6bBf0vBL8n6s3zYotBIOjIwh6vZ5Ld?=
 =?us-ascii?Q?zYqcNDIFpEETobnaDVfjgcMG7BS1Wi8xcFMI4qhEdiLNAAMYcPjhQrCg97Gp?=
 =?us-ascii?Q?qmv7V2ainYxXRli85keknl33d9Nna1e4zP9Pn1UB8lYSeUKH9cPzucenlt6A?=
 =?us-ascii?Q?7236G9ftlx/crm7J4ADKMLYx7qxssH7FXAOuDy70yUqWQiedhFZPsKiDcg8o?=
 =?us-ascii?Q?B4+qtsqiWaZrRtKZYXR2rekaWzJNbVsWR0MAZqo0KbfvWkm9HDe35ZZNo5I1?=
 =?us-ascii?Q?Ioqw958wVlI84Ia1wCG+uaD4pCDC9VeMlOkcR0oSkWNVzjkpqnscQHjA5X11?=
 =?us-ascii?Q?+mcvlFF3LZk7qipAxQcRYQ9rkWxhUTSA+NzDGbyZx8Lou3pllIA5OPZAO/gT?=
 =?us-ascii?Q?k7jA13U4oUAt14jZd36NUee8fQYwCsekALUHFtyoO9tDVsjMoOLNV1Ghthyx?=
 =?us-ascii?Q?MrBreZcp0+1uu2h4e9g0ILWj1kOE74XTzgW+QQMxuR17/IKff14Qa0xbBbZ1?=
 =?us-ascii?Q?xlAJvtpfJB+qsH1GHa6sFEn7cuAbjQAtC/tXj6o+0HhELTNlR4unD0UqUYEv?=
 =?us-ascii?Q?zb69B5SqEXt6jh97pvQxrt+72LFz5n+LgD2RGX1TMFORnZIQrEs0z5ygnp+n?=
 =?us-ascii?Q?291du3r1m7CRB2gsGFSBXmRW+t2CByYmLpu6uWUhg5cTPGsHgwHn8+w3/zvz?=
 =?us-ascii?Q?oBu8nA0FLjFe6b2FeeLkhMoEqUP3nL8O/5VLy6El+0fRR9orlGk9HYiiGC0P?=
 =?us-ascii?Q?pt3Hz4ln1v2x8GFwHbSn39hdejKjxYWfOix1Z0M4iSE1SeiE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2924642-6e9c-4a4d-1f5d-08de9cf4746a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2026 02:44:47.3081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ot/hh/hQ16Un8jk7rdeHByVs8UZGgfTTCKRr5U4zMTNjFzt8EAU4bbiYWgBrFjEK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650

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

