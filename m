Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010003.outbound.protection.outlook.com [52.101.85.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CDC3803E3;
	Wed, 29 Apr 2026 15:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777477034; cv=fail; b=oujvVlMxDnx+PcYPsALf41vqQOrOilUKDZG6Ajo326pnDJfgnIqfvFJLxi9KA5LnXhJfNRRm2Cv9SdKOiVbHnVoXD1q2/JC88T7PaVVY3ssfGeXFeOxkzegE73zJFoLeuUZqvqa0uolFz/ZgQV3GBFRIZLfGLii3TI8lvGUOj2E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777477034; c=relaxed/simple;
	bh=CTKtUtqtNwzrUMRSP1sWp+vrmMD2eZwPHiUwR0qTXrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gNmrrrS/BL7Ttt6yjr1CmY1dpzhVRZoVOnQRsOQwZsRP2/lOQL9ZKnKcuES0WLDVUYSm67Y8scpavRuuLDCGCBEn3SKvR1R9/zlQFdTQIc1nw9qdtKjLcJgzah7J2HOCIuYgBuNN0OU3oIpgU6ku9mSEKfHYcQg3X0aTuLPKf4E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p4OAh9Ad; arc=fail smtp.client-ip=52.101.85.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p4OAh9Ad"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R1b63iQW0L+285NVT/kGRZcy+vv5talIBusKMkRcCB5V3vCXrdnuEasXAETct241acoz14gsgSoMRngF5gCaUDbU+bEszOvEtRbYLNtxoC5VsBulwuF0Tu0AzLpkmTuYKyPuIahTxyoaRZsM325eVJtIAfSTendHIQOCBIjdpaOZibOzvp5ajkRNQt8Y9AnAnrkawVjAc8UAtHM1q+4z4cREjjXsGulj1c1sUjX9NjPWTVGArpArcir1lXy8eRvIBkFT+/SjzVCkRU3GWfuuptvfeJvrQQ4RWFHs4voxBA9Va28tJsW8r0aKdpLx7BEyrPkcBVIiokNg6O8cN0DIdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7zYkN1pToZE3rvPsfZEr4uuellkIu6jkVJhUS1SOGt0=;
 b=DDbfRbPSPZ26Ev3hQQH07AcZgksCe7ZjGuo2q/ZfNV77mDxBDpLXKLZ1k0fw8+TcLAi5wFQt8whRiGStL0SaYMXk79oTGf8mAobgVylLkxsNqIRVIEAF3NsG0l0X4lo/5L04iOKE8KhtzK3RyaQDTUj3wdH1a6S5KNW2cp2xyeYblUtz27dQdnlonNIsZcTCBOx0IuG26tiF9R7RffVZqaKudcUXllSNgmfKRCzqqQ2F+UoTVWPrTpltSTF+wCLPfTj2Wn4kLFuglJxV/a1hZNreif05qmaPYc3G9C5aL5VCpkfXkF4TjkBEqNapBpHNFn8XbO4oh7XSKND46YzgWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7zYkN1pToZE3rvPsfZEr4uuellkIu6jkVJhUS1SOGt0=;
 b=p4OAh9AddItESBm6qoY/6CLfxTidAXn7oDH0cAP09ufOkxJnjUR5fQyY0Wmb9wm78QKDiR/+5p8Uhf83jn7JE2cC1gXvEGkDsrg6iw7PoFvSaiX0kTb8FpROok9pOKjUuax+taJOuCO2ZMMMdNgQ+ZjS7Jw5VAvUJo8B66a+SfAvupCWIycD/TbmJAx3XsyiqnLr+/qjlRYoXBUKN9qrafCrBmrUpS1uhtvKdjwuN85z4mor5qXR4DXwUf9dTOMsKPqrAWZ+B0Ar3nwFM/AhrjXuuYQbCFdobJhVInS/VZzpXkwQULP1GIdi72Ex6p5VcigUhTDMznA7+uli2jZt0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8881.namprd12.prod.outlook.com (2603:10b6:a03:546::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Wed, 29 Apr
 2026 15:36:57 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:36:57 +0000
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
Subject: [PATCH v5 14/14] selftests/mm: add writable-file collapse tests for khugepaged
Date: Wed, 29 Apr 2026 11:35:37 -0400
Message-ID: <20260429153538.727855-10-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0359.namprd03.prod.outlook.com
 (2603:10b6:8:55::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8881:EE_
X-MS-Office365-Filtering-Correlation-Id: 8423c098-4c9e-470c-68da-08dea6052554
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	R9g/lBI9eUoVMZ9uWcC++QUwmMHob77LMzQrdnCxb6VG98WCJZ9qfoKyLfjQKsMMeRceb8PpN/op4W3dZ80MLt6Vh6NgDFcfZPoBND7qXkvxRsKmF3Mz98UBmkQ2kQ0TAEQzBcY/nvSBGpWUND74n3dPqOiqG3UtNnmASPNag4yOefzLcfa+BqIBzE1kF3WQ7V7OYoqKCzOpzBrV1lklSllGCCw7ZsLubvXBu0P7CmV6gfPXu/FUBYXaFe1S7AK7cQTdVV5LMtW/pA+M4gB2rXVvVs5fAO/ejXewPrMat9ku4SvK+wN6vPWbJlIEWo7a0j+nVQJPp4LoJT1fkcX1Zy931T2LVaYYi6WcUKkyv7cdLpdIxiaolVmV2Q7nT/CSNVREuhqXLt2YW4LXfA0h2jKIqLkQWF6CrrYUfPUeAn7Asdvwkvf3dsS5k0+5B0gkwWkJFb0EcbrdmkcL6keCULN6Ib31ti9je3QL1FWAPWCVraJ4q3MaHaOyL03pBN3DY2BljyfwiwxvNartNfk8aNyUxSfHDggeBnrzVj8TLm2Rq1oQuZOGiWGDL2Rq/ddqIgNo+So48N7rLunA8Sbc2TXTiyO2zwqvH/+0S1O20866LqRw4UhhWZrmFxgBQ3mpxlBY2N2gcJNdY6+A3aFe1uIw2RbKCpjxocwdll4o8hdrtuxKcrxcspDgtTbH5N2QSbEUe3xKwupTfelqt5XwfM1pKD56+NrIZKIcZToOEzc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JVzV06ZWSQvsn5f7TQgNYoVb88e/5l6K7A0/qk6ObZaUCr/1L/l2GyHIdvG2?=
 =?us-ascii?Q?fCDndUa+YOG3zdAtsWSwY1ZIbZRbFlPON7F0wg8meCLEtPABcs6cjQuRTEHE?=
 =?us-ascii?Q?xgTakCQ3WxvnYfDkvHcFcULlO3eGDNSjzM5kPVcWu7UUPiPQzqtqeGxvijYp?=
 =?us-ascii?Q?gV54lkdZ3r8rWRZMs3Me/yo+BnbBgSptonukB9TiDaMA4h6Y7BWHdQzEAwff?=
 =?us-ascii?Q?WZ4licULWgVnWCeGRDz0/qwjY2xsNnvh6/3W0/goBrPhs4Bh1eSI+7VG8BPU?=
 =?us-ascii?Q?wNuZo8gxOzgxj9tM2N4rLAThDBZ+5n4qf6KwchnFd+LCWeD630akXG2hCZvx?=
 =?us-ascii?Q?6TvtPrtmaiP+B9nK8ERsP7sc2TWHxGM2ApaNcrDbhG6SNtgTrsBKbgXRWx6F?=
 =?us-ascii?Q?JHyepuvmQTnp91FBiXTBLCIh0+EWNy3POfFWxgYUwzgOSlG80JdFEskOeDuS?=
 =?us-ascii?Q?Rq0w4UObb15HDc99PR5taHx31xFjC0B3YceR4HE7fzFH0ADlWFKmlmQiJecU?=
 =?us-ascii?Q?fpYVghdfAjHYFrTAHFOjUW1kzwYy7xYWO+JcMEhnfS2pE8z+arLZ+MtHLxZp?=
 =?us-ascii?Q?bs6HhkkFHfn9p28A9e8ES7GAKn2FW/VxU4ZJYAqQAKE0Cu7SNpkQpspYcIlF?=
 =?us-ascii?Q?BBpWNswukBxO3xSHCDMhgQuKikl1ZDYJS3m1QgLk4TGrsYXBU2M41BJ/TR5F?=
 =?us-ascii?Q?VEDdD5/8Vl+anU7+ebffTXVIm1fjDQFWCsKPN2s8YZKrMm0EqJU8M5nlGsB7?=
 =?us-ascii?Q?MJ5C2lWA7lbcpqy7ymDUC04nPrFBJElVZsqeOvRnnnoZumFuH9QSYNiduQqw?=
 =?us-ascii?Q?bIcZplzbC6ucqc3PvQFdcvkGH7Yj3l38K1BZ3UqkWxXXzRBcgBHi2wYPzOA8?=
 =?us-ascii?Q?SyQ15BEtsUTQ4FjV4iacsexrIRWQufADSOiS+TOIzMb3jFshWHv8tq6pxTxQ?=
 =?us-ascii?Q?0loisOymsu/NPeWuY10wKDHKNqxeTzBHBpyNRl9vqlT8PCMtucRDGl8eRFsr?=
 =?us-ascii?Q?RRNTjG4D9lsDjQeEjtWNmEB/2rYzypIojc65lUHg7FWZ1ZjnobmJ0jjT38uv?=
 =?us-ascii?Q?7C6Xk7BsPi0yfAss6CijgqKqR7kUn19wDOsjPbxU3L/QSG60ODuc3eVz53DA?=
 =?us-ascii?Q?hOAmgX0zMBGW2LPkTic+4nAAJNJyzEBf2okxOCB8Uj4rw/oalPhOT8N5rNOU?=
 =?us-ascii?Q?3vs7q38s4cby3IR+CtBCesqr2tp7LbfzIGuhwC9aFgcyfz/xD1e2RzRI0w1f?=
 =?us-ascii?Q?seFz3eDy5SXSxD+LI0R0rqx2aHn9cZD5NZwQcOTKZCn5tjAQR6q7ORMFoj/L?=
 =?us-ascii?Q?kSnlTDh02IAeQPPGLFMDCSJmOiyUhtVfJiScTJvJRDZyNM/boxm4unkTny2X?=
 =?us-ascii?Q?okcrCCKKbIymqUGSE1FNVJNgn4myx7WIb5LATEBzQMBeKTwG5PlYE2PHaLxW?=
 =?us-ascii?Q?W46mNESCKpL0+HBTZvAhrTpwpV4yza6hIsyT+lCuAq70ase3iwcIcl7Mx3n5?=
 =?us-ascii?Q?npU/RjFCrOijSIRU9C10PQEIQLgyzf65WlXSgssEFhCvjDqwX38YegamZkRE?=
 =?us-ascii?Q?Bjcx6YW6iSUqNPgFVgRE0oQz+nXNNvetdA+i76FsgR4Tbhh0b7pPUmz2FgQ7?=
 =?us-ascii?Q?d28saj57F8c/BPtETjbhg5FMge6q923WuLPOY+viJNH9wJ04eQ5LdOCMQ2fs?=
 =?us-ascii?Q?RKtVXMksGR0Q5Vwcz9869ochcdRXsi+NZDCyc9DwQPvsRMe2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8423c098-4c9e-470c-68da-08dea6052554
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:36:56.5729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I8ufdFeQfduyLAKpUKzFY931rsLmnTRGOJUPMyExs/OslJtEQWJf8dxa391pnir4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8881

collapse_file() now supports collapsing clean pagecache folios from
writable files, so add corresponding tests.

Note that madvise(MADV_COLLAPSE) works for dirty pagecache folios from
writable files, because collapse_single_pmd() triggers a synchronous
writeback when first attempt of collapse_file() fails. That writeback makes
dirty folios clean and the retry of collapse_file() succeeds.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 tools/testing/selftests/mm/khugepaged.c | 113 ++++++++++++++++++------
 1 file changed, 86 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 80b913185c643..e73aab5149bdf 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -41,6 +41,12 @@ enum vma_type {
 	VMA_SHMEM,
 };
 
+enum file_setup_ops {
+	FILE_SETUP_READ_ONLY_FS,
+	FILE_SETUP_READ_WRITE_FS_READ_DATA,
+	FILE_SETUP_READ_WRITE_FS_WRITE_DATA,
+};
+
 struct mem_ops {
 	void *(*setup_area)(int nr_hpages);
 	void (*cleanup_area)(void *p, unsigned long size);
@@ -50,7 +56,8 @@ struct mem_ops {
 };
 
 static struct mem_ops *read_only_file_ops;
-static struct mem_ops *read_write_file_ops;
+static struct mem_ops *read_write_file_read_ops;
+static struct mem_ops *read_write_file_write_ops;
 static struct mem_ops *anon_ops;
 static struct mem_ops *shmem_ops;
 
@@ -113,7 +120,8 @@ static void restore_settings(int sig)
 static void save_settings(void)
 {
 	printf("Save THP and khugepaged settings...");
-	if ((read_only_file_ops || read_write_file_ops) &&
+	if ((read_only_file_ops || read_write_file_read_ops ||
+	     read_write_file_write_ops) &&
 	    finfo.type == VMA_FILE)
 		thp_set_read_ahead_path(finfo.dev_queue_read_ahead_path);
 	thp_save_settings();
@@ -366,14 +374,14 @@ static bool anon_check_huge(void *addr, int nr_hpages)
 	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
 }
 
-static void *file_setup_area_common(int nr_hpages, bool read_only)
+static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
 {
 	int fd;
 	void *p;
 	unsigned long size;
-	int open_opt = read_only ? O_RDONLY : O_RDWR;
-	int mmap_prot = read_only ? PROT_READ : (PROT_READ | PROT_WRITE);
-	int mmap_opt = read_only ? MAP_PRIVATE : MAP_SHARED;
+	int open_opt = setup == FILE_SETUP_READ_ONLY_FS ? O_RDONLY : O_RDWR;
+	int mmap_prot = setup == FILE_SETUP_READ_ONLY_FS ? PROT_READ : (PROT_READ | PROT_WRITE);
+	int mmap_opt = setup == FILE_SETUP_READ_ONLY_FS ? MAP_PRIVATE : MAP_SHARED;
 
 	unlink(finfo.path);  /* Cleanup from previous failed tests */
 	printf("Creating %s for collapse%s...", finfo.path,
@@ -405,7 +413,10 @@ static void *file_setup_area_common(int nr_hpages, bool read_only)
 	success("OK");
 
 	printf("Opening %s %s for collapse...", finfo.path,
-	       read_only ? "read only" : "read-write");
+	       setup == FILE_SETUP_READ_ONLY_FS ? "read only" :
+	       setup == FILE_SETUP_READ_WRITE_FS_READ_DATA ?
+						  "read-write (read)" :
+						  "read-write (write)");
 	finfo.fd = open(finfo.path, open_opt, 777);
 	if (finfo.fd < 0) {
 		perror("open()");
@@ -426,12 +437,17 @@ static void *file_setup_area_common(int nr_hpages, bool read_only)
 
 static void *file_setup_read_only_area(int nr_hpages)
 {
-	return file_setup_area_common(nr_hpages, /* read_only= */ true);
+	return file_setup_area_common(nr_hpages, FILE_SETUP_READ_ONLY_FS);
+}
+
+static void *file_setup_read_write_fs_read_area(int nr_hpages)
+{
+	return file_setup_area_common(nr_hpages, FILE_SETUP_READ_WRITE_FS_READ_DATA);
 }
 
-static void *file_setup_read_write_area(int nr_hpages)
+static void *file_setup_read_write_fs_write_area(int nr_hpages)
 {
-	return file_setup_area_common(nr_hpages, /* read_only= */ false);
+	return file_setup_area_common(nr_hpages, FILE_SETUP_READ_WRITE_FS_WRITE_DATA);
 }
 
 static void file_cleanup_area(void *p, unsigned long size)
@@ -455,6 +471,17 @@ static void file_fault_read(void *p, unsigned long start, unsigned long end)
 	file_fault_common(p, start, end, MADV_POPULATE_READ);
 }
 
+static void file_fault_read_and_flush(void *p, unsigned long start, unsigned long end)
+{
+	file_fault_common(p, start, end, MADV_POPULATE_READ);
+
+	/*
+	 * make folio clean, since dirty folios from read&write file are
+	 * rejected and not flushed
+	 */
+	msync((char *)p + start, end - start, MS_SYNC);
+}
+
 static void file_fault_write(void *p, unsigned long start, unsigned long end)
 {
 	file_fault_common(p, start, end, MADV_POPULATE_WRITE);
@@ -523,8 +550,16 @@ static struct mem_ops __read_only_file_ops = {
 	.name = "file",
 };
 
-static struct mem_ops __read_write_file_ops = {
-	.setup_area = &file_setup_read_write_area,
+static struct mem_ops __read_write_file_read_ops = {
+	.setup_area = &file_setup_read_write_fs_read_area,
+	.cleanup_area = &file_cleanup_area,
+	.fault = &file_fault_read_and_flush,
+	.check_huge = &file_check_huge,
+	.name = "file",
+};
+
+static struct mem_ops __read_write_file_write_ops = {
+	.setup_area = &file_setup_read_write_fs_write_area,
 	.cleanup_area = &file_cleanup_area,
 	.fault = &file_fault_write,
 	.check_huge = &file_check_huge,
@@ -542,7 +577,8 @@ static struct mem_ops __shmem_ops = {
 static bool is_tmpfs(struct mem_ops *ops)
 {
 	return (ops == &__read_only_file_ops ||
-		ops == &__read_write_file_ops) &&
+		ops == &__read_write_file_read_ops ||
+		ops == &__read_write_file_write_ops) &&
 	       finfo.type == VMA_SHMEM;
 }
 
@@ -559,9 +595,11 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
 
 	printf("%s...", msg);
 
-	/* read&write file collapse always fail */
-	if (!is_tmpfs(ops) && ops == &__read_write_file_ops)
-		expect = false;
+	/*
+	 * read&write file collapse succeeds for MADV_COLLAPSE because dirty
+	 * folios are written back after collapse fails for dirty folios and
+	 * another collapse is attempted.
+	 */
 
 	/*
 	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
@@ -629,8 +667,11 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
 static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
 				struct mem_ops *ops, bool expect)
 {
-	/* read&write file collapse always fail */
-	if (!is_tmpfs(ops) && ops == &__read_write_file_ops)
+	/*
+	 * read&write file collapse fails since khugepaged does not flush
+	 * the target dirty folios
+	 */
+	if (!is_tmpfs(ops) && ops == &__read_write_file_write_ops)
 		expect = false;
 
 	if (wait_for_scan(msg, p, nr_hpages, ops)) {
@@ -753,6 +794,9 @@ static void collapse_max_ptes_none(struct collapse_context *c, struct mem_ops *o
 	validate_memory(p, 0, (hpage_pmd_nr - max_ptes_none - fault_nr_pages) * page_size);
 
 	if (c->enforce_pte_scan_limits) {
+		ops->cleanup_area(p, hpage_pmd_size);
+		p = ops->setup_area(1);
+
 		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_none) * page_size);
 		c->collapse("Collapse with max_ptes_none PTEs empty", p, 1, ops,
 			    true);
@@ -1200,21 +1244,24 @@ static void parse_test_type(int argc, char **argv)
 
 	if (!strcmp(buf, "all")) {
 		read_only_file_ops =  &__read_only_file_ops;
-		read_write_file_ops =  &__read_write_file_ops;
+		read_write_file_read_ops =  &__read_write_file_read_ops;
+		read_write_file_write_ops =  &__read_write_file_write_ops;
 		anon_ops = &__anon_ops;
 		shmem_ops = &__shmem_ops;
 	} else if (!strcmp(buf, "anon")) {
 		anon_ops = &__anon_ops;
 	} else if (!strcmp(buf, "file")) {
 		read_only_file_ops =  &__read_only_file_ops;
-		read_write_file_ops =  &__read_write_file_ops;
+		read_write_file_read_ops =  &__read_write_file_read_ops;
+		read_write_file_write_ops =  &__read_write_file_write_ops;
 	} else if (!strcmp(buf, "shmem")) {
 		shmem_ops = &__shmem_ops;
 	} else {
 		usage();
 	}
 
-	if (!read_only_file_ops && !read_write_file_ops)
+	if (!read_only_file_ops && !read_write_file_read_ops &&
+	    !read_write_file_write_ops)
 		return;
 
 	if (argc != 2)
@@ -1287,11 +1334,13 @@ int main(int argc, char **argv)
 
 	TEST(collapse_full, khugepaged_context, anon_ops);
 	TEST(collapse_full, khugepaged_context, read_only_file_ops);
-	TEST(collapse_full, khugepaged_context, read_write_file_ops);
+	TEST(collapse_full, khugepaged_context, read_write_file_read_ops);
+	TEST(collapse_full, khugepaged_context, read_write_file_write_ops);
 	TEST(collapse_full, khugepaged_context, shmem_ops);
 	TEST(collapse_full, madvise_context, anon_ops);
 	TEST(collapse_full, madvise_context, read_only_file_ops);
-	TEST(collapse_full, madvise_context, read_write_file_ops);
+	TEST(collapse_full, madvise_context, read_write_file_read_ops);
+	TEST(collapse_full, madvise_context, read_write_file_write_ops);
 	TEST(collapse_full, madvise_context, shmem_ops);
 
 	TEST(collapse_empty, khugepaged_context, anon_ops);
@@ -1299,30 +1348,38 @@ int main(int argc, char **argv)
 
 	TEST(collapse_single_pte_entry, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, read_only_file_ops);
-	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_ops);
+	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_read_ops);
+	TEST(collapse_single_pte_entry, khugepaged_context, read_write_file_write_ops);
 	TEST(collapse_single_pte_entry, khugepaged_context, shmem_ops);
 	TEST(collapse_single_pte_entry, madvise_context, anon_ops);
 	TEST(collapse_single_pte_entry, madvise_context, read_only_file_ops);
-	TEST(collapse_single_pte_entry, madvise_context, read_write_file_ops);
+	TEST(collapse_single_pte_entry, madvise_context, read_write_file_read_ops);
+	TEST(collapse_single_pte_entry, madvise_context, read_write_file_write_ops);
 	TEST(collapse_single_pte_entry, madvise_context, shmem_ops);
 
 	TEST(collapse_max_ptes_none, khugepaged_context, anon_ops);
 	TEST(collapse_max_ptes_none, khugepaged_context, read_only_file_ops);
-	TEST(collapse_max_ptes_none, khugepaged_context, read_write_file_ops);
+	TEST(collapse_max_ptes_none, khugepaged_context, read_write_file_read_ops);
+	TEST(collapse_max_ptes_none, khugepaged_context, read_write_file_write_ops);
 	TEST(collapse_max_ptes_none, madvise_context, anon_ops);
 	TEST(collapse_max_ptes_none, madvise_context, read_only_file_ops);
-	TEST(collapse_max_ptes_none, madvise_context, read_write_file_ops);
+	TEST(collapse_max_ptes_none, madvise_context, read_write_file_read_ops);
+	TEST(collapse_max_ptes_none, madvise_context, read_write_file_write_ops);
 
 	TEST(collapse_single_pte_entry_compound, khugepaged_context, anon_ops);
 	TEST(collapse_single_pte_entry_compound, khugepaged_context, read_only_file_ops);
+	TEST(collapse_single_pte_entry_compound, khugepaged_context, read_write_file_read_ops);
 	TEST(collapse_single_pte_entry_compound, madvise_context, anon_ops);
 	TEST(collapse_single_pte_entry_compound, madvise_context, read_only_file_ops);
+	TEST(collapse_single_pte_entry_compound, madvise_context, read_write_file_read_ops);
 
 	TEST(collapse_full_of_compound, khugepaged_context, anon_ops);
 	TEST(collapse_full_of_compound, khugepaged_context, read_only_file_ops);
+	TEST(collapse_full_of_compound, khugepaged_context, read_write_file_read_ops);
 	TEST(collapse_full_of_compound, khugepaged_context, shmem_ops);
 	TEST(collapse_full_of_compound, madvise_context, anon_ops);
 	TEST(collapse_full_of_compound, madvise_context, read_only_file_ops);
+	TEST(collapse_full_of_compound, madvise_context, read_write_file_read_ops);
 	TEST(collapse_full_of_compound, madvise_context, shmem_ops);
 
 	TEST(collapse_compound_extreme, khugepaged_context, anon_ops);
@@ -1345,9 +1402,11 @@ int main(int argc, char **argv)
 
 	TEST(madvise_collapse_existing_thps, madvise_context, anon_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, read_only_file_ops);
+	TEST(madvise_collapse_existing_thps, madvise_context, read_write_file_read_ops);
 	TEST(madvise_collapse_existing_thps, madvise_context, shmem_ops);
 
 	TEST(madvise_retracted_page_tables, madvise_context, read_only_file_ops);
+	TEST(madvise_retracted_page_tables, madvise_context, read_write_file_read_ops);
 	TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
 
 	restore_settings(0);
-- 
2.53.0

