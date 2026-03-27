Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010035.outbound.protection.outlook.com [52.101.56.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D953264F3;
	Fri, 27 Mar 2026 01:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774575795; cv=fail; b=bKhjr1+YM/TvLrO3bSfb98l2l51a7XzMZqymfYrawwtXp/+ndFRYbA5mIL0m7EsIUiaxjRCjhA8DWgbutzcEtcGQdoJc51YfxPPUWaF2lTg5CzODmRzpDaQ+gniiIPYkR/HAnp66oe8bqk/NLzBFAfdCwHXEZjN7ppZc6cOzTKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774575795; c=relaxed/simple;
	bh=rFGpbS6tdW42WJ7Sa6HEQ8X52uoqny25agkpwho8WYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IQ+ua+FRv04OjMSxyOSAXR2EjA5nGIN3UnbOdzy/2GnwTtEegFQNG5TK23k/pKRBDfnRiqC8YTZPCAkM6qJPd0hxc2ncDL+9YC3P8b+0nlymFSNAVffFGWB9qponc0hwe3Q/110TWH2OPSY51+Uln4USwQigqfJcD0k6rQD8tKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UBxXRzMW; arc=fail smtp.client-ip=52.101.56.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UBxXRzMW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jVW2ce9+BQOw+9mjRZ1O+Fin7dveBitSms3x8cyjZz6H+Tiu8cb5awtlSqUPKElZWIKZ0wmZvyARTakyEPKNVrs7qFferm+s1fdM7ku/T2jZFFNFohMO82e3R3EXEzpvAJc8yLhDn74+WlKGx6WFN28szsWmGg4oqGBEhLku2mfhUtmY4Teu9AJ0zKUZ4bxSqPJB7dsVYf3dsMK1jASF/3qCdrwSPDXoIeVCSq10x0FrlA7DVehUnUArregsnzodxvqU4iKwDl5fGFZJzbVjqVVmq/kh4yzVYk+PGtxNHPipV5+3lClzEML/cu8txwsmyBfa4gHQj60MblmbrE0LQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j8WtjKqeAnMSTiZeunDBBxM5WbMXam7k7WhfDEW6fjg=;
 b=ZtCU5rsjOm0A7aKey5nX61zHqCVdJNiVlp3K3ctkFXJL5LGrisjSVR5quKbBOQhJA9LTcRAPGaaF22f7RZa1Kf/K+e6hzLhKUfzRAvb5J7/EdagZa+7Qpb4XxKDaoNl3BaSIL+uKhfrZ3WZqP2oEj9jWTWrdrxGx3Pa4qaXbz2zwDQce3ikM5CYo1DmCrotX5FrDEDKYw2eIRRmzav+/YilT4LDGy1bGCE4N+JwvVTuk+vZJ+GJXklHeUAF9f/3Jzbs2OIT7t/9mjqdlEIUUKoU8731jV9dpL81A2TGJpNq6UFFYE2InPP6KlaBmvgnMlypyuJgQljNBn/+KMvl6Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8WtjKqeAnMSTiZeunDBBxM5WbMXam7k7WhfDEW6fjg=;
 b=UBxXRzMW4ucFIKATEK0XpZdtkZrsbY5SI1NGZkOmP5hebar0bApK+rym4eGTXL8rSbD3Ae6hTwPC+ge6tqm88hKV3NhyWlD2EEJEUxkm6FoInkU3NxloVzgriqkGpNU2/K9m/9hYITbWhNRi9Pbgpen72dki0DiN2cdrtkyVPYfdZWoz5fqJIsgw5SUupR1UP3Wl8wsCalVOKprKYX07nZKK84LLvGA65bQ9BsdOSi/M1p75S3mGX657MKSP4/+j12JMXY8vVCRobhrf/9biswG1rP9pnXn8gJ6EvgQ8qWEhtylekQ/EVCOW1DFf7sfLYqAIrkktzbuIvhi6O8U5uQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9264.namprd12.prod.outlook.com (2603:10b6:408:1e8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Fri, 27 Mar 2026 01:43:08 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 01:43:08 +0000
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
Subject: [PATCH v1 03/10] mm: fs: remove filemap_nr_thps*() functions and their users
Date: Thu, 26 Mar 2026 21:42:48 -0400
Message-ID: <20260327014255.2058916-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327014255.2058916-1-ziy@nvidia.com>
References: <20260327014255.2058916-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0378.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9264:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f5b485c-62a8-4932-266c-08de8ba2328f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	O094KnarKjbuKaes/vnjCYnk+orUicZYpaOpwqAdayMUbvexH2z8KIlUox2RyCTLWHlhpaIFHW4j6dXLX0B/VEZWXpbPyMppZCiLOzOKhcOM1AsNBXmwz6koHCUKuaIfucB0jxlzNb9UaA+snQpizw316Wd3LwpwE8B1EifDhxW3XsMXxvJcy+GkLn3dP57p1KnerApyJM1LO57be1SWyrVpBZPaqeq+t//PxVDeXd8wddYf0s0sp5Qt30w6nQ7IQ1tRzy/h5LZokaKMEnFh+5Tgzj/+X25IAWlsYAymPjC4snbNR/xlWx52E+Jih+W7fJqJTWMF7/DxA+MgPMDZlu5J0Xd4OrDNLtOUMNkMV0tDxcvUdZfY3RbcpARXnG9nvOtTQj3LwvKHD8tTYM0PTqqJRm04rLE0vVssmmkS+hPuZn93Q6X1UascZdUl+xeBeZbMHOCM1vuvZVV35JFCzPPtTSOMl8zA6nB3SrfWsTOlSqFqt2CvMYPskqSCm3yZ3TkPw2KFDn8+Akwpu9CoIL4biAV9rC9oBNMI/xpiJMEj2VzSNNl91UtHQ1K6tMXD/IJLp6OHMf3aznEYsHP7AdfZE7TGtGR6hYzvYJO4l/ibsvUZFDUWHoaVLfPqmBPbZbtEjJ353nNcTn2Jkfr9cqMgEa5w4r8fcVUqObRai3z4PJfH/WEuoEGOWL3gRU8J4/fN1W5jvvl4tPIqKDwYAGV8PZgwfXVclyzNaG763HU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F5as28cpigp1CliPrFqxBBOOjv3AeDSiDw6XL2Aomh6KCjp/rkMQEKA+nc2x?=
 =?us-ascii?Q?jNOfXX5nR2m69IZjjWX/Mp6iAyreuXeGF3cED9QHDiK3oNUCYgIFPnpO2yCO?=
 =?us-ascii?Q?+7D/YnKtb/292NBbGfCU0zizjotkqoBBsDVgI+qrIXb4XNjz8IQToOqW+Gve?=
 =?us-ascii?Q?sys33ithExpFzbJggzkxDPOYA9I2ca2a/IPYExio3e3R/Yoj5yQVzpIJfx95?=
 =?us-ascii?Q?PqREFeryrnT4wn0i4TiGYUT/RL/1H+/6M66TFk5yb4Y8V1/hvey4oQMJNPWF?=
 =?us-ascii?Q?gWNgScDrqWfeD4Wr8rvrP6t3j6zJRSRc4+4LIVDEbkTbYfkCOU3bKwBsjv9M?=
 =?us-ascii?Q?bVZIDBmbCGu4QpjN1nsNaM2fOWHk48DsjnMRvueSj2XWJR1JjNs7b/3rOCj4?=
 =?us-ascii?Q?shealzSb8UXpqkgcg0EP984d5Tzuf6dR7gcGLv+HMA+qoJ/C3CFXBcmdRG8L?=
 =?us-ascii?Q?Guv3m+hT+TOuHp7fMGKGC1hKrZuCum4VeCkQDzk7ds3Y+F148DJdWsIMWmfl?=
 =?us-ascii?Q?aDof0CQGivpZ/7uIhrIYd4hPL1CJQKsLXAl33Fhx4nsAt9isCzBwCv8JvxPC?=
 =?us-ascii?Q?f5dARxx2AfTymmSF7ItSNLOjESV+Gt6vdpuTi+mvYojR4dh3YV6hIRWf/y8/?=
 =?us-ascii?Q?49oOwPa4A49krEgZiwLYI/GbLmuCC9rePIcSvGC/jD5xVyDnsLEPnUcPU3yi?=
 =?us-ascii?Q?EKypGUo1pOJb76mSpMlBPUiRtQA4YC4uwcbL50/OXE+ANvR07S79OJIYVKcu?=
 =?us-ascii?Q?JbZTf2PFgUMEmR7TQ7X8IC50sABMlTRB1+buKPbuhEMEJ29DaInG4bstF3Ta?=
 =?us-ascii?Q?nDRx34NKZqmpMZCBxhgRrYrUafNT/uJpbl96eFY5IgZ7UheXrxNKGHLt6ovs?=
 =?us-ascii?Q?wz/FIJL73gL9eB3aVgSxFGd57KGLqXB2U88pxsJTrLHbpqLvtqcXQhnTq8WS?=
 =?us-ascii?Q?Dy+8qKY6gzUDmWks0w2xWvawAGRdtUL7aiAgFmKqWnmJd+MfMKj+JvNpc6Zr?=
 =?us-ascii?Q?1v30UwDFMnYe/Q3nOT+4wKXwuA5KeHQH4WMRHYZkqYwpbS+DH0ov+o9UiuuU?=
 =?us-ascii?Q?9DxH+h3OjgM4932y6dC8zMZY+S5HOR4HBbWBe+qezVQ5ov7N3qmHXOzjV1jG?=
 =?us-ascii?Q?dRjBNio/+ZQ9MwpzvZ1dP9ac533qcUuzcOaqoR9dPV8Q6tzNYJd96t73zfnl?=
 =?us-ascii?Q?F1xg2BD7rdd0xQaLgTQUaggbLF+6WEZXs1o2ChenBQeN1crPqSgyea2oUUba?=
 =?us-ascii?Q?uwaoJDco4n0W+10gLFKjbvVZl+WHOdIH2lukUW515iK+XVqdTrquTptaFXiG?=
 =?us-ascii?Q?IIFUBnKMvwTJ0TVA9GK/yeuTnZTbbzfU9bVSiD7mZhCJ/aa76b+CeUOSe042?=
 =?us-ascii?Q?kSUuyOdVprZBGdnX2Hsi6NtUBzLCq8VkOvEMV2P1qMpzpkz+Ng4mpFtGtLgh?=
 =?us-ascii?Q?Bv8DsjUbF09o6Q1zkfq1EVJ8pLRjMaUmpEpQ/1xF6/JN9t8YUILaJrBBuJ9a?=
 =?us-ascii?Q?97Ani/vLst6Ypg5oflSodVjqrKbGJGBaIjT+Vx8nOkWFefxbBBiutuP8+4sw?=
 =?us-ascii?Q?aGZgKYMZEu5wPwEpfH+P4dco6bTU4DI4bO5NIwWfTi20rzQ+mX4Mh/j/9J2S?=
 =?us-ascii?Q?QUZF104M44A9rXx/MoJZ59Rae+HGvYJNCIDbnsoUG9BuRiD8F+IXqKF6i/YG?=
 =?us-ascii?Q?1E1SyMoMJWaBbFro4+DIXLHwM5hU2wKlLFecMGBTVJ8mxBwj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f5b485c-62a8-4932-266c-08de8ba2328f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 01:43:08.3736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ELgQZ44u6oYxsr7wRWYmmG5lAbd+zL2UpVZ+xV0GzeNFZrCu8Oo2E51HDS2kpKct
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9264

They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
large folio support, so that read-only THPs created in these FSes are not
seen by the FSes when the underlying fd becomes writable. Now read-only PMD
THPs only appear in a FS with large folio support and the supported orders
include PMD_ORDRE.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/open.c               | 27 ---------------------------
 include/linux/pagemap.h | 29 -----------------------------
 mm/filemap.c            |  1 -
 mm/huge_memory.c        |  1 -
 mm/khugepaged.c         | 29 ++---------------------------
 5 files changed, 2 insertions(+), 85 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 91f1139591ab..cef382d9d8b8 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -970,33 +970,6 @@ static int do_dentry_open(struct file *f,
 	if ((f->f_flags & O_DIRECT) && !(f->f_mode & FMODE_CAN_ODIRECT))
 		return -EINVAL;
 
-	/*
-	 * XXX: Huge page cache doesn't support writing yet. Drop all page
-	 * cache for this file before processing writes.
-	 */
-	if (f->f_mode & FMODE_WRITE) {
-		/*
-		 * Depends on full fence from get_write_access() to synchronize
-		 * against collapse_file() regarding i_writecount and nr_thps
-		 * updates. Ensures subsequent insertion of THPs into the page
-		 * cache will fail.
-		 */
-		if (filemap_nr_thps(inode->i_mapping)) {
-			struct address_space *mapping = inode->i_mapping;
-
-			filemap_invalidate_lock(inode->i_mapping);
-			/*
-			 * unmap_mapping_range just need to be called once
-			 * here, because the private pages is not need to be
-			 * unmapped mapping (e.g. data segment of dynamic
-			 * shared libraries here).
-			 */
-			unmap_mapping_range(mapping, 0, 0, 0);
-			truncate_inode_pages(mapping, 0);
-			filemap_invalidate_unlock(inode->i_mapping);
-		}
-	}
-
 	return 0;
 
 cleanup_all:
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ec442af3f886..dad3f8846cdc 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -530,35 +530,6 @@ static inline size_t mapping_max_folio_size(const struct address_space *mapping)
 	return PAGE_SIZE << mapping_max_folio_order(mapping);
 }
 
-static inline int filemap_nr_thps(const struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	return atomic_read(&mapping->nr_thps);
-#else
-	return 0;
-#endif
-}
-
-static inline void filemap_nr_thps_inc(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	if (!mapping_large_folio_support(mapping))
-		atomic_inc(&mapping->nr_thps);
-#else
-	WARN_ON_ONCE(mapping_large_folio_support(mapping) == 0);
-#endif
-}
-
-static inline void filemap_nr_thps_dec(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	if (!mapping_large_folio_support(mapping))
-		atomic_dec(&mapping->nr_thps);
-#else
-	WARN_ON_ONCE(mapping_large_folio_support(mapping) == 0);
-#endif
-}
-
 struct address_space *folio_mapping(const struct folio *folio);
 
 /**
diff --git a/mm/filemap.c b/mm/filemap.c
index 2b933a1da9bd..4248e7cdecf3 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -189,7 +189,6 @@ static void filemap_unaccount_folio(struct address_space *mapping,
 			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -nr);
 	} else if (folio_test_pmd_mappable(folio)) {
 		lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
-		filemap_nr_thps_dec(mapping);
 	}
 	if (test_bit(AS_KERNEL_FILE, &folio->mapping->flags))
 		mod_node_page_state(folio_pgdat(folio),
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b2a6060b3c20..c7873dbdc470 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3833,7 +3833,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 				} else {
 					lruvec_stat_mod_folio(folio,
 							NR_FILE_THPS, -nr);
-					filemap_nr_thps_dec(mapping);
 				}
 			}
 		}
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 45b12ffb1550..8004ab8de6d2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2104,20 +2104,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		goto xa_unlocked;
 	}
 
-	if (!is_shmem) {
-		filemap_nr_thps_inc(mapping);
-		/*
-		 * Paired with the fence in do_dentry_open() -> get_write_access()
-		 * to ensure i_writecount is up to date and the update to nr_thps
-		 * is visible. Ensures the page cache will be truncated if the
-		 * file is opened writable.
-		 */
-		smp_mb();
-		if (inode_is_open_for_write(mapping->host)) {
-			result = SCAN_FAIL;
-			filemap_nr_thps_dec(mapping);
-		}
-	}
+	if (!is_shmem && inode_is_open_for_write(mapping->host))
+		result = SCAN_FAIL;
 
 xa_locked:
 	xas_unlock_irq(&xas);
@@ -2296,19 +2284,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		folio_putback_lru(folio);
 		folio_put(folio);
 	}
-	/*
-	 * Undo the updates of filemap_nr_thps_inc for non-SHMEM
-	 * file only. This undo is not needed unless failure is
-	 * due to SCAN_COPY_MC.
-	 */
-	if (!is_shmem && result == SCAN_COPY_MC) {
-		filemap_nr_thps_dec(mapping);
-		/*
-		 * Paired with the fence in do_dentry_open() -> get_write_access()
-		 * to ensure the update to nr_thps is visible.
-		 */
-		smp_mb();
-	}
 
 	new_folio->mapping = NULL;
 
-- 
2.43.0

