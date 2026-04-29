Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012021.outbound.protection.outlook.com [40.107.200.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6235E376475;
	Wed, 29 Apr 2026 15:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476636; cv=fail; b=nOIpkRfGzOxOZW4lX4rMM5NDsaHF4FY2iyJPxr/PNLbdk6Wyde5ZPU9alKxSlpLwM2SeWM/kcMH5RaASs6gXK2pT1LicqvkE2bdS/Y7kWBwq7QEspZXDi5htLZKUIyx45L9lQ1CdMYQnbla2ijyhHv2mkb/wwvp/Sys/9pmn0m4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476636; c=relaxed/simple;
	bh=qACqOpaCy/mn3BNLmj/v/w26QG74ZBVFaVbKgVXw8AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YKwJTROuE5xvHQzZMreEGLpG6qtN0zcKur7MiD/RnVUU8lZLpf79dbcasx7xFd+EITjlWztGxUu91gCz8MIeTJVpwsoZjokiuFkceogzbG7TPRzRgQH/bEQNilaVROF3OiiEf5lU5Wg/YCUQ4d5O6OeK6qVE3i2kFT3fF6VVCVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EfBQURmv; arc=fail smtp.client-ip=40.107.200.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EfBQURmv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qGzK5QR1iaBzR2mBPF0u0vKopkMUAGKySNqXKZWeamoTaNfU363O/dy02tgMZmu2VbUdsCsne6jbe8rtBo6oSvTu5rf6f9BAQsoNWoHIHZ9T3tWGYd39nJOUgsDPwSH4jWzgnU4fBXzO3+HqV0IwOhfo3aC2LN8szVOYfQJaXDneQwE4sxJL3wJB84G72R82Az93TeaQ6sltw7EyUM3fc0zlXs5U57tzY0pVVnvSS11uENrjrXtUSkHxEpQbWLVSdpPCs6TckjfW7yXTXbgWstv/uno2pazMzcyHcyAU9j7fEN66dMTUWdbY+nDz9Kd5ozu6rwrQrjETCx2vDs2V9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sVfr/2s2cblfcwXqm1gm6FaLLK8qes0/WkQi56AxgkA=;
 b=CjosFomyDeZ41DHE76o/R4ejtxM7DAB9hLsxmUhky8j0QL5O3NFieaJ1/6sQ4N6yP5XPBl8FRW78xXlnBd1IhNXH72jVGrNHTpz9ELG2PD6D1woWaz+qC8Gd0oHLMQBiz1gbFwMC/TvcOzVuTz8xHfp2H0L3h+lev6GscmQtcx6IclEdWrQoeSezLyiiSEECfdavDIi+nW/0g1y0D/zkA1RAKR7ixPKpZWmVWIdmjmd6qaFU9tBl5zg9Ao0ONgbuGA7NfJqmy5ZVdpvmK90kUlDbngoa3GAvKAHqSxO4xD31+u4rSCOlhurNT8WABQrvbQtKKiWUISku+o6pAOqFiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sVfr/2s2cblfcwXqm1gm6FaLLK8qes0/WkQi56AxgkA=;
 b=EfBQURmvZI3XO2oazazTK6LxjQtwcUbZ8n4Q9yMzNfvQiahbcP8fYE2/vsx3Jx1psVsbbzjdMLTtAYjMmmTJ2E0cEf5+5+spRjSvhuLn1FgQYLDmD3x3Bpd4fwGMHVFY5oIlig32RF39lqfA0xJe75CRyqIUEWFirdH6Qxap1G51pxL6fTbQem+3LPcDMhD92s2ctwK1/ei/w6BdzfMGKqm5Czbq9vY8cQSg4YGLy8hAI7+yWE180mKUpIAxifYdjXd8clHCHYpDKdSCD/lW7bq9E4bwol3HrK1a6sTAJKM/hx0lMgbEq0zCqnBXujOqeZ5dMIoPWWBKPFtpuEUu/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PPF12042BF6F.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bc8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Wed, 29 Apr
 2026 15:30:29 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:30:29 +0000
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
Subject: [PATCH v5 04/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in hugepage_enabled()
Date: Wed, 29 Apr 2026 11:29:14 -0400
Message-ID: <20260429152924.727124-5-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P220CA0037.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:223::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PPF12042BF6F:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a0785c6-456b-4b77-3974-08dea6043ea6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	hnP5P7LGQQ1kI43zOanOgGXMZMMWdovqwl9Dhg4PEWO1QrNj3Yww1vAJbUdENzwI+5AuRRh2qHy2uzfuYaLhSVDA37cl3uUa8gkGMWNigXaBC0vTOziysbsGXcJPDK8iSzRy0g2y41nXwSbDHZGshx69Gc32LHamLeI4QOvZiVXv/dEkMX98qJ/ggL8z/9oioK+KhErtoxsKYQwWeJBYAH+efyu0lC4zmDAFRJOhMMzGt4eLyBjlp03ykjhggMuBM6Ylay9wKg42+pxA7i1LlqS91avAc6ZHBlMuawrQSoHmAwHwn2udxLPog8gwuQJsKeYuLel2RDwBxY5MHf4rf4Rqy0h9s7frlwe6TCy5tbOgWfPgXS5jhOpt5mpZbxxMh2yEC4DEpB7oJkwvPdI+DYM5v5q73HxVLs9gT/4mX3/K9qCLhsddGKEkWzRyCJgeTRCo4+omtF4GnAC/4UPMGoBYRbhZc9JyPpPQb+Nowetv1KsSjS2KjnAOMCxq36VhMe813hTuElvRsHrdwlPEHwvNAByvuud1bGnLLf1V3aPEmkWFnbjy3F5pS0FmaAAOTtvEemN0HkrLSfS+SBQQtcrQFvaSO1TWYlD9NFxWsGG624E00Lp7vid9UGw+x+b5X5BZNQD8Mpj6jHHt18+uKgqmwuED2l+JvaoL546qTSxOCcCsUlBUzlVaU/PE0jkn1H3EhEOG1h06OHkwdQcK2ClC/OV525NZ6ofjVYAkHC4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yEsFjBeb3e0MeaAkV3g24pKL50cPPthVjf4+JFDUMfhVG396W0iczQwM7xT2?=
 =?us-ascii?Q?Du6Mzh1hklLm46QJJuzxPatlRYofxbuVV0wL1Be3Qj6YFLqqFuTnh/NDVoXA?=
 =?us-ascii?Q?0XKfTycCvDBB4Uszlgy82dGY6Ox5nxU/bEj/OftmUVZIepnQ9kZJxLZIXKfo?=
 =?us-ascii?Q?8oXgrcVKCoaDybxxww2bC4q9IkFceNcm1CDA6NQwQPLigA4p+HpRIhOgQZDj?=
 =?us-ascii?Q?9qryK6FHbqh9IKE2s8mgp1ImfslOESS+8M77JEP2F0MjNZuDnt4wcBG0CUVq?=
 =?us-ascii?Q?AAmIifxoAQ8ENYXzVjVrVcY5n6bns2dduxi1FdPmwMxSq1zQeHqPhbbDraMn?=
 =?us-ascii?Q?s7T0G0hLTXDN3D9tzRlRSBfr9eQF9vg3N3MWOs9LSUhkHYjy23JbDn0QJkAS?=
 =?us-ascii?Q?nYIiTZ5u4AyeVHAwTEap7qTWeo7Pa/dCZ9kuFRGeUWQShcoWfsc7qo1kKoeu?=
 =?us-ascii?Q?qwohceqUIvw11lrX3r8obj69owA5VpL11usQAq+GA2bEEzBU5l+xcx+fgj+/?=
 =?us-ascii?Q?dz9cdTs9XCQhatq+hwbWzZZdY6uF/EmbgUnwED8B8+eqZjvZLEcao59dvvdX?=
 =?us-ascii?Q?1J44JcgnSFUC1UaIizbeKhFSqefSW0+NBW/M3KJ3MFOiekPV9qwyVbBWaSGd?=
 =?us-ascii?Q?vXigbZTgNk6+YZbsfRiZGYro+Mz0zx4YR8hh6uOqJuPaCfhOk7eNUlF6vp71?=
 =?us-ascii?Q?/N98I0x573sREa6H/s2ySpy/inaYd70KfBdUPdkgtBBZBwPTfSXi8lNBo+PX?=
 =?us-ascii?Q?CkPLMpr2GKzTHojaJscyZimKzxwZoMrKnhsUDovhUENJ/xNNBoXv5gJbdJ3H?=
 =?us-ascii?Q?Gzs3FgvTPqjzFc1JvNXOYH/e7WQU2GQFYC/2swbWhKUeDrIJVeHy/Hz3yo2t?=
 =?us-ascii?Q?6SVKlQ1kRHm0IeVREcyCE4skN6rgBQt0UFROCzgaTDWwW03mtWxioU03Lss9?=
 =?us-ascii?Q?u76K6JahrOUnt32Q8WE08B9Zidr+v+1jGmPYFGi4SWTvPa8yM+vhCk3ZLVgP?=
 =?us-ascii?Q?PI0n/+WtZs4A1xrm+h/hhApPXdMjB3RWXhRTpW+3OPBUAAQmFYbH6eMsAODW?=
 =?us-ascii?Q?IRAOICJe2ABIMyBHDEzzQTAATs9/iTQlo/1E2BLeP0mOBQyBN6PfufH1pSvn?=
 =?us-ascii?Q?7VZK59yMff59cnDLcXjQn0R62epm38pCRYB+GC8oYD28L6veA2Fn0f4hQn2D?=
 =?us-ascii?Q?PiGzV7DI+E6r+AwTFhYEtozvFswvhbBONDkPdQCNbwxAX0kCqJ3xHd9ioJ43?=
 =?us-ascii?Q?DjUfJidPdkZrHFxqT+aKSLk+I9OigRHb5QkABwur1wvj79yYLLnUats9F9zt?=
 =?us-ascii?Q?Yb9rCCKXeVm+f85p9IzJUAPD5KmZp/tr3PQoWQBfrjA/67LNeiurWF+h2hsO?=
 =?us-ascii?Q?8Dz5i2Yz73EZaGRN8LJ7nlGSNS28iRtRKu3Y1T/gQmXIqH6i7tKsZMooA2ew?=
 =?us-ascii?Q?4x3GqPZBR5YnU8Gm9k9/733gKqlhVl9o2jpwto1+H4qIFG/N4jrAlDbx209G?=
 =?us-ascii?Q?vhjC166LIXxYWcCklfnw4hOkuOW/yM8lBe1nlWbR7hex7Zi/qbV2ipeMN7qf?=
 =?us-ascii?Q?B+R8BnCmF1XuiHuswLCAQVERC0ny0n3AtIeyNCSK65qv0L59iCbNA2c3twOi?=
 =?us-ascii?Q?KMqpqEPuos/dxRmCEPvuSpoXT2bNRH4hMMkIJgLDOaAeUK5fMP5FTzlGr6Ce?=
 =?us-ascii?Q?B16nsDgWrf9htSB3SBhLmHdujzL3np5WTLv3M+7PLuXx+7eT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a0785c6-456b-4b77-3974-08dea6043ea6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:30:29.5408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PqPFFdIk0vaEzkD/c8FMwSSiuGc1Us2cVp3TQZf0AvCx5tTAmD5H3fivNpqnJPNx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF12042BF6F

Remove the READ_ONLY_THP_FOR_FS gate and khugepaged for file-backed
pmd-sized hugepages are enabled by the global transparent hugepage control.
khugepaged can still be enabled by per-size control for anon and shmem when
the global control is off.

Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
IS_ENABLED(SHMEM) in hugepage_enabled().

Clean up hugepage_enabled() by moving anon code to anon_hpage_enabled().

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/shmem_fs.h |  2 +-
 mm/khugepaged.c          | 26 ++++++++++++++++----------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 93a0ba872ebe0..acb8dd961b45c 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -127,7 +127,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
 int shmem_unuse(unsigned int type);
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				loff_t write_end, bool shmem_huge_force);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 71209a72195ab..d6971ada8f199 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -524,26 +524,32 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
+static inline bool anon_hpage_enabled(void)
+{
+	if (READ_ONCE(huge_anon_orders_always))
+		return true;
+	if (READ_ONCE(huge_anon_orders_madvise))
+		return true;
+	if (READ_ONCE(huge_anon_orders_inherit) &&
+	    hugepage_global_enabled())
+		return true;
+	return false;
+}
+
 static bool hugepage_enabled(void)
 {
 	/*
 	 * We cover the anon, shmem and the file-backed case here; file-backed
-	 * hugepages, when configured in, are determined by the global control.
+	 * hugepages are determined by the global control.
 	 * Anon hugepages are determined by its per-size mTHP control.
 	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
 	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
 	 */
-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	    hugepage_global_enabled())
-		return true;
-	if (READ_ONCE(huge_anon_orders_always))
+	if (hugepage_global_enabled())
 		return true;
-	if (READ_ONCE(huge_anon_orders_madvise))
-		return true;
-	if (READ_ONCE(huge_anon_orders_inherit) &&
-	    hugepage_global_enabled())
+	if (anon_hpage_enabled())
 		return true;
-	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
+	if (shmem_hpage_pmd_enabled())
 		return true;
 	return false;
 }
-- 
2.53.0

