Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011051.outbound.protection.outlook.com [52.101.62.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D472C11CF;
	Sun, 17 May 2026 13:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779026121; cv=fail; b=eI6qZ0YoOQTzPZcYRQ1JOLa4NQ65Rtt0CBciBM8GDs2EoeGwV/G1UaBK9pYqF0OF416WN6xLtIcBmbF9kJtSrAwqYQxFYAAeRwdfeRrcvUn7l1Yvo2gJTo2aE79mTb2KSswXEZQpRapQmFoPb7xUtlmapFR41gFBIHYDRIpsGSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779026121; c=relaxed/simple;
	bh=IKUykIPS1LAzfO5owNOalhJ+j8vkLQXqIEh55h6IfJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CVoynXVcPe6XtBFEuftihO+d5ZhfAqGv5DvR6Aztp01oeyoqZ36xOhrsRa8v0S36PUNswy3Q8eP5ldRiTNC+qNqDz9JQyifUnKcIJPi1tYa3PX3lrec7mbe9oRB9xxrLwGWbScHQwaK/rClxUiJHJLVF2AADKYp1hG5T3cfh5Dc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oWK8EG3X; arc=fail smtp.client-ip=52.101.62.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oWK8EG3X"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jr0tntECgAnu9HdM7nOmZK7AiXdyc8LkcqnX+kfRoJD6TaKeTkAJ4uizxiT9vdHmNEKpLR8ykTraHPSVV8kh2nKbwdr8LKD4VSUEaZSOg7DlzvSy9jNqb/KMqqO8CNoAnZl0PX7jORfIQz4bus1vUuDFKcFGPxgKnFrf8eYrrqAxTI/ZDrZzxCKp2Ji7P6hinrzuyHWR2Jx1/M7oHoziOMgT6xd4PF8Alasl2GfWoBdImw6lEz/vulMk50J+NdPsNTpOI5i96GnzPZis2R62ex1nDB3gSuFsh4c2f9I8ykDn8Hsk+smTLFgxYYjobL9gQCxiICHqeiLquWQuPVfjTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PvLIPKL51Kbj3vlSAHwOw+N5Ez5Bo2Fuh0RSLikMH20=;
 b=Q8BNgGFdiNZH9Wy5YqdJavc7nzhVglZHOP/bP2QXY8gUHzB9KRGp99B2kIn7xXQ5w27oJ+IIi/fr3cN0Oseq7jatN8QcgiAzKTJr0zTHDcTnSvTBX++4L4cky9yh+RnEkcTKXI8OhLkvXLMMTLH1JG4K/2USt7KUovIrK8/HilQUC643X7p1Yil0dM+EI6Q/w2kfxt/J94zKowN/dMOuXregz46U0HMmtNAB4OgBxhWaSIIzZ6efXJEm+nSR98xTmEZlq5SLLCrS8wU051SzNMbcd6Lb9UyAELrvs68pz9vMso75gaCyIqJcbQhOkPHCPED9dBcUflh4tDZyzd3yMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvLIPKL51Kbj3vlSAHwOw+N5Ez5Bo2Fuh0RSLikMH20=;
 b=oWK8EG3XCMhHxXrm+1AJ3F7J4JUy06TwMBMQl4L/+a1aTgSqZDwh2I/jJnha7zyR8tGu7hn20xtk0UGAUogl6Gy8wJ0DUDVSTZ4j8XVusP/QmOjMBTnzhDkVHIvJKcq+d8XsJJK5Xl3QDRQaTEamMcOxWEVbW7oROH3BPnrZbXOPatdns73z0oUYVu9WbK/sJN7R1CTaBW4YAwz0MNyKIGPu4EXdJpNpR+Coc24hHo8EzRTw9yXZzLH8Gym22rxCDRMHuKK7Ab6JvJDxEaziNGpgSfIEVBZX+Dm+v0k592CCq/Fq8jak9Ajszg2It0xaJUl69g+91C/RahOmUshutg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:05 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:05 +0000
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
Subject: [PATCH v6 06/14] mm: fs: remove filemap_nr_thps*() functions and their users
Date: Sun, 17 May 2026 09:54:08 -0400
Message-ID: <20260517135416.1434539-7-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0021.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::29)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: 78812ac6-5ef6-446e-9d32-08deb41be64c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	rwDmhwGdNPx8dmKZoxUg2kMKALsY+R0yFVOvJIhKkjCIIn78NTuVCpmY75Yxtz/ogRn5uJ146cC3qZnZt/5C/ixWAoGgIJa6ukHTiZU58QrfaGROV3AjFfrUptqvF/EuGsw5n7QR4SmBYUCJsJqPyheqWKPFaX6/uXQ7Ai8bf6cF9HZ1pAsPGOkt6jyRiVB9anXZoomrVyc83PoRaLxNTZiq2Fjpd2weZGc57MckqC1IClm1YsJEfk7mpW3iMZl+/sBh93CbqXpqsqMEi9+Nv9iZGEeCAHsVzIZrxKMDzIEIBawBgBiSpcYqXKXIcFednminqH04hFBRRVp7CJ6jM8ccNb90m7YR3B95qAkYikK8EAq1+QWD1yAa+XRurLDATxq96KbEzdDXFETEfmxz/IQ2lM6JR4Cf1EIbbs9WYI11EKJ+6AXdncH587CU4z9iiQcPC1+XSiNg49UEExQsa81DS2yifiVIPD2bR4HNifrjDRrzAJg7eaX0jTD8HtSE/K2y5y+tn0fN5JuO+bdY9D++QEq4D77jdc6IbGepjFbj+6+yZHZbJJMztExHvdshnLQNa79BC/ASkHtDdOv51sx9lQDwr9e9nWoA6PBfgo57I0Q1QiKxxUgJAEjm6nkp44bJgABuWXfCEn9JhSalU+YoMLDBlsam5l5gVhcOUaoz3UUNOg1uRZIb1LwrXNx2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c6Z0UI25x/KYwHHpDQKcscW++9mTMogpwKPYtPli+/S47b+sCU3la0KeoIkY?=
 =?us-ascii?Q?ZHSnyZnhgzBOFmdFKWy/PekmhkxTjMPdDTZ0iN3jmf+70T7J0ZeWxg/QXRgR?=
 =?us-ascii?Q?sWZMEyCMoHCgRxUl8q/ldYJj5Dc+JFd4v8YvSYjvoyUc5ABknydfJwLKP0G8?=
 =?us-ascii?Q?YxzuNajkaC09QVGDmr9AmEsrS/b+V702s2R89z0uhM0u1wyeDy84OxZIDvhb?=
 =?us-ascii?Q?uI2UQIZPbHpcnfS+34DUlf/UMpZGSO4/pMNw/SOyh3hCdF8TAqUXpmerCsND?=
 =?us-ascii?Q?BE3sKODmUgkQmXIpRR5yTMCd+5SM/Jhx2no/05FnCxtvH04uKz4SUzohkFnN?=
 =?us-ascii?Q?FSLs/DFDsr6KZ5kMZMsnuN9w2FnCGcFxsmkVlIsdrpa1Rj8AWhsGccJOz75V?=
 =?us-ascii?Q?8uavpH7866v4aG9avT44foqpQ2kKloOnOQVY1lM8LQRmRTSf56UlENdfLA/T?=
 =?us-ascii?Q?KyeCf14FwvL/fLMeeim8b9/tcUg85Jx/e0eUKInjCaJVEM6fKKx/z/8+p7pp?=
 =?us-ascii?Q?ezJBIY+NKY0h9s5tAxXdg8uBtI7rMaPstNd1FD+ZvLTi/aJom6G8a0rT3mX9?=
 =?us-ascii?Q?NS1SCOb7ADSYxjJIt9tD6kxNO5Ga+OWINUBvhBbOL8L7DkfvbnD0TvwB9cQf?=
 =?us-ascii?Q?JETGOIkODYk3I0dK7v/diXQBmN0rVd5RirHt9AWnILZvv/Ei25f02zQ5X4Gr?=
 =?us-ascii?Q?vAX6MWeQfgrZHCT6IXZP2U1vXg6ZoOhjxKJoVHBX3sgwvZDBQ/FHVyGnJXs2?=
 =?us-ascii?Q?8GbsHU2lOg577/dw7RRZ5VujlFO9pIffymCQwdYFikglieDl4p862jxEXyTs?=
 =?us-ascii?Q?ARdAeb53XobdwDc8t8E1uxg7MlnuMAd/9qd/oLkgDsl2m0VYsqBZig6CGmBO?=
 =?us-ascii?Q?wmKn6+9ZG3JKkmRxi+FL12jO52YN708Gdjp2FCU5QbP1sViP7UQOVA/a8fLN?=
 =?us-ascii?Q?MAvnqOs9+51NZkUhMxJW2JVJx6AK1nJmYrkJ0Gonx9NKb0Yqj5kV65GEYE2g?=
 =?us-ascii?Q?t/asZKoPymLncLP/xh5lN2tFFNKFtUiXxk63/O3NuRVj6fj5Mwd0akJgV7yR?=
 =?us-ascii?Q?ybnMo67Z3ErVra4MZ67ZXGbr/XTnJKDEZpVqO9oo7NpXwiqELuaxC/dIMwba?=
 =?us-ascii?Q?rQsUDQLCh8IkZtxCyfosm92CMjVt5+yW12Og/D9BL0cQvxcyg2oxcnSJM8Ul?=
 =?us-ascii?Q?OwGVketYtkt2cet9MkqdvnYJWhRBwzlaOo4itrIyXae9Z6//syvt8/1/+Dzs?=
 =?us-ascii?Q?sNajzv2VvKF0lv/yMZa7zXM78Mf4RqJCiq0TV++ivGI3IOIrW2z0ae/WDMPq?=
 =?us-ascii?Q?gAm1eOF4nlqJjf1UglbFvlstTwDjcvfTOWBYEffVlLd7lNMt7ONuSAf7qKkU?=
 =?us-ascii?Q?pLa45hNhepQ9z34OR1WudhpGpK3G4CQXTf8WBzVSSZAF2vzeNTwEGHkG0XD3?=
 =?us-ascii?Q?5ME2xXPwCTE4/VJjzUcL8lK58cTwGv6TYePK0kKMyf/36rydEY8RadIH7u8S?=
 =?us-ascii?Q?u2DEXY8l8D0NbkCcYOxSpgZH35VITrHP2uAn6HEalGN2eXdPZuoF/5D7Yk2J?=
 =?us-ascii?Q?VkYj2rDwA+8w/b6C2iCOJ0X++0HGK846SfL54Wnz3EoNcpWME3oP9vC2Kqg1?=
 =?us-ascii?Q?mQIQ38MZGDoBvMRRAnmh6FnQnAHbmS8nHpgG4VjotBsa1D1mUGpTZk3cOwCD?=
 =?us-ascii?Q?ECTGw7b5GXg2fhBhEbsCuE7poWFoh0TA85NrJIahyR0iWXUD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78812ac6-5ef6-446e-9d32-08deb41be64c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:05.5174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fusGN/jhktgOa5oLAyw1tO4TQPgpjQBPDYhLoRvRiMquUDKuBNoJdhqrnCpDAROi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322

They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
large folio support, so that read-only THPs created in these FSes are not
seen by the FSes when the underlying fd becomes writable.  Now read-only
PMD THPs only appear in a FS with large folio support and the supported
orders include PMD_ORDER.

READ_ONLY_THP_FOR_FS was using mapping->nr_thps, inode->i_writecount, and
smp_mb() to prevent writes to a read-only THP and collapsing writable
folios into a THP.  In collapse_file(), mapping->nr_thps is increased,
then smp_mb(), and if inode->i_writecount > 0, collapse is stopped, while
do_dentry_open() first increases inode->i_writecount, then a full memory
fence, and if mapping->nr_thps > 0, all read-only THPs are truncated.

Now this mechanism can be removed along with READ_ONLY_THP_FOR_FS code,
since a dirty folio check has been added after try_to_unmap() in
collapse_file() to prevent dirty folios from being collapsed as clean.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---
 fs/open.c               | 27 ---------------------------
 include/linux/pagemap.h | 29 -----------------------------
 mm/filemap.c            |  1 -
 mm/huge_memory.c        |  1 -
 mm/khugepaged.c         | 28 ----------------------------
 5 files changed, 86 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 681d405bc61eb..c321b80027f13 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -968,33 +968,6 @@ static int do_dentry_open(struct file *f,
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
index 308d846531d03..627771e82eb16 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -546,35 +546,6 @@ static inline size_t mapping_max_folio_size(const struct address_space *mapping)
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
index ab34cab2416a4..9a5e23fa6a238 100644
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
index ccd623b9501b5..ed49e5d40e8f8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3951,7 +3951,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 				} else {
 					lruvec_stat_mod_folio(folio,
 							NR_FILE_THPS, -nr);
-					filemap_nr_thps_dec(mapping);
 				}
 			}
 		}
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index edb5c3656c168..c743ec41a7b8b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2477,21 +2477,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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
-
 xa_locked:
 	xas_unlock_irq(&xas);
 xa_unlocked:
@@ -2669,19 +2654,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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
2.53.0

