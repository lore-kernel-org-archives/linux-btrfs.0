Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013048.outbound.protection.outlook.com [40.93.201.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B063537FD;
	Wed, 29 Apr 2026 15:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777477021; cv=fail; b=MFhrL50JUwechzsgd3Wm6Cz+sDK3aQ4+xjqRwMReXjIBamYrCltyWovl23C1kvqWroS6YpzGc5fZex/9CXRrsUEc3MlpQLTpTlOOfTJWXy1+3BHKsrWWL+h5IvxIbvN9Rc4n1DR9+LQXY8Q1mG4qPkVTdDSGy0XXaWhk1aBow5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777477021; c=relaxed/simple;
	bh=/jNSuxrZ8xyzDMfV6iB8Nosuix9Ru+6DPCfo6QafMnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BDCvohAe2itI3azIGX7+sNlW3MuytKTXDa9bW3H2G6G1pMFJEvJwU3fW4K/VwRTVjBxrX/+YNdNtZIO9jwVMA0rRR4z9dgNtmwwYrtHSt1MysIzcS86wzzpc13vtTOzmCsyJDb1OdCtphhqDrbgCgS9TLjyeGxZr+Q2o89pKV4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sG35ugBN; arc=fail smtp.client-ip=40.93.201.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sG35ugBN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tyDos2ORga61am5o89AkuHSjtibwR4RyUcPbN9j5Y9eqIFfQ7uw2hqz/QWa+eGtbHw5+14nLdv/S8TnHGHQcHXU+vNPueHEQOjoxkJEdVlA0XsDuR84RuKu3cNH4tntugK2fFkgXUpbDhRt9DyEd94Cy24+Oe90+OwdqQ7YMV2KLKVXsa/y94UeU0pEY/2T5V11t/w2A2J6azbkX7FHLjVNamBUSyQkV/ETrATKCmy4Ts1xG4tOc+ua2lZpxbuTsSLZ5URsHFdlEz39JoEt21fhUB6i8CYQGArVQW8WGml6hGpz5ZpFEsVHNnuGToUnTi56MPc5GtN/T6ZZVWpkOPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DxELcRqPEAEy/HwMBp7MdsZ1gA4IAZTcGsDz8bTFYh0=;
 b=V+8eTr8iSD6vjLk5HFS1EDk5BFYppQEElo6usgb3ccPB5TnkyqNjTMbeVp0GOYqUudjwbf4+t2DKo5winYhKkoNfXtEe+s7TwdZKrHFDcgdHD6hQvjWCRAzqUC9JWLv49bb75uI1lETaNBqlTif318SfpqQylUylwTRBJQ0acZ/wngWDBn/f4m/WuA7+OFPE2+yLa9d18ZN5T216FRT5xW1cirW1f5JHI+T+DDLXXvAmgoXcdL6ln2RysnTLcX7abV5MEKZrmX+FCI1ly9SM74/aBXNifRQBzGys+onLfpokc1hieEd9VV+zxyhjNmwfHOYMFpVXyO9YW4UJV/KHSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DxELcRqPEAEy/HwMBp7MdsZ1gA4IAZTcGsDz8bTFYh0=;
 b=sG35ugBNjujM6hJ6va6K15JosLj7+rdKyg8GVDKX61LhGOyaYcpYMp31/GYabV2s8nAMY7sd9oLJ9odW3AJffsZCs3T6DodhY8i+3TX1FW50kf82fPYyI/OWTkR4GRuf9NQAqJyvPqXmPj40CKC1OYgzUJsCM7lu+AWU+/f3ZqMNSOO6WxCzWa0jjxSW0CjThdrg4Ymtsk/BeUwsgmtq1r3aq6FVlrLSsbygQ9Ul21XH52oG62HjD2eW+0qc34s54faa6OBuZ5GuDM5SqMFtrNiDYmw+szaQ8nqTT4Y93TstSpfv7zm9bToMUTXP1HBPiNf8SZQoqIYdsudvN0CHLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8881.namprd12.prod.outlook.com (2603:10b6:a03:546::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Wed, 29 Apr
 2026 15:36:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:36:45 +0000
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
Subject: [PATCH v5 06/14] mm: fs: remove filemap_nr_thps*() functions and their users
Date: Wed, 29 Apr 2026 11:35:29 -0400
Message-ID: <20260429153538.727855-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8881:EE_
X-MS-Office365-Filtering-Correlation-Id: a618b3d9-34d4-49ac-e955-08dea6051ed2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZlR1yGo4Nssf8E1iQ++w4jt3fZBloZljzDu0JgTFa1cWcLlksnYdSLlhV8A1TH6m4oqieQmcUrrsNmdU9zLRr3R1V80ekTiidGt7pT9NCQOzGGF1fIyegLxspZcsXnk5d2tZuMFtbQIna0DZ7t85kIE8PV4HCCUOfWKXD3GfcCxDMX6YjQl+RHVk/HEZVm7u7IwUQc6lvUCfoHFuZzkmooezBl48OKiWmiyZUdGndl/h8GCmz/1/kY23Y1fb4nSUuqATkM8XlC3ZMFfOfqMDREibBIVooPjwfSVgpGqtXGC/EvybCF60FZ49R27Mbi3j/bTWWks8OycCBRHIY+jhfURPgWGExDbwm6Q1Hf9SSa1vkrICJmN8fk5rvCyKxFWmVAOMCQKfRJp7j7tGAltwA5/HTDgXH6xPlqTCP9+qQIq5t+kcGOj/lFTIvjJZIT9pQ7SIZrwpZeIHBRFk9TlAZhtNngsuDNJ9mf1fcUa5ojpb0xK5VCdt/iHdR1f+nP+JqOWZrvLV/kIZYnSwv6e2lTogtuas9yuIV8H+3CqM/wsWxNnLvemj1d/HrMMvpWX8MaxbuT3TOddJVHYjfW+ebuHrCWbxbQOj/K1icQkOpfiFNRKM5fRbZj5tvpJDhRI+Z7r7jFq3/dDK1NTef2xCW+6p1lNuy/8obS0jMkXg2cdShisbvYzn9+x4y8HE3GHMYnO+KlWl18bEG3QB0t+v6jwc4dnCLzkHmMiHFTpXgMA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2/JFoRwcfIVZPErBwqVRcP4pgEQhhQKGra6Ov1LZOMc39Szfqu0/DtA2FJhU?=
 =?us-ascii?Q?WQQ42J2WJ//od0B2KewiwH3DJrY0fSAIfi1CsfeEWNtEd4lNO6MfyebKHMee?=
 =?us-ascii?Q?vcdFbvJlsjfyyrjMucHkAbSwjkKZQHZarqGXxWc5HuKBoB00cTdHydxPEYOk?=
 =?us-ascii?Q?aYh8vrnD5znSa8bfC/yMxh135V5Hp/oJMJz27LZ4Kh/j5fu0Gs9mtx2ip/VM?=
 =?us-ascii?Q?TzOrzIlm7UQLUGlvs1qiqy25uYAk5Nni0SB6vsJSLHlR7GVFQ+9QckgD9x1y?=
 =?us-ascii?Q?BApknuGjyNbxGAP7KXyTmUzWUE5+sr14hJPrNScvxuRw3FVLO1MApG84pAUY?=
 =?us-ascii?Q?3CXCoZSzKyOgkRsoUD8ajCIukwnO9upuxU5LlBtljOsE6yuO3HzsAgwVADVd?=
 =?us-ascii?Q?QcZ3L4RxeiGylNGzo0cgF8kxBDCuh9gTAPER/4V9UcH0Ns3uEimPAEkh+5kx?=
 =?us-ascii?Q?UkozIpBL0l513bYCp7Hb/zr1y+VpaDPX9K+waXaWI0quNAy6CDWes+cJlinF?=
 =?us-ascii?Q?XamrSC4HRh2A0SyufCBFYgyOBW+ciklcAE3WGNWELe28O6CK/wiuOfJZaboP?=
 =?us-ascii?Q?PDegJuCzQm7QMGtZpQEYl994AXbvyPVe3ySj9qhJZNKTQFbvVmRydZb1NNlU?=
 =?us-ascii?Q?vXHiMdCMT4lut/NE0vv/hV7G02FN7l8Eis5+JDw0ZocNOvq/jpwBs6VFasf/?=
 =?us-ascii?Q?V2CwlCpM21LYW4ZTpj9wWOMgquTFZcyovWWFN3SWWfyxCpANcYaAWEYqQNXy?=
 =?us-ascii?Q?3+C94NKcHJXgm24He5iQXY2TT+0MYQs6to5EkslQz69Go/Q+n/3yfnkRGCUr?=
 =?us-ascii?Q?wfKyp2AnaDjgG+Rmbt/ZnUSG2jcfgJb+cEPM1ODRyLvn4cqMvBi4kuYO+O1F?=
 =?us-ascii?Q?yLs6pqTJurmMJGdcfj+R7NF+VkWglFuGQht3vTNJQz2kNFn3mgVSksIn/DBB?=
 =?us-ascii?Q?3TYcaM8yOrkliKad429AXYQzUttn2vRDi6CMck0bL0OxT7C4Ev3o/10ZRMYS?=
 =?us-ascii?Q?QyUgkN7uY4POljeEmUR/b3Ha9fOPE8G2z8ezfRIkSAcwoeIx2S1UyATU3Hj6?=
 =?us-ascii?Q?hLVwzcRO204Cq4HEwph//exUwM2cZbQ4viH40IK1XCsXDprqzZTCzWfce8T7?=
 =?us-ascii?Q?cv2jNglnFuqrh7pgZvTvEPgLYSum/vDThhv/PLGzh0y9wP5MEvgxZeFY+hiu?=
 =?us-ascii?Q?zHylbIkZD8V/JVH4haS6FFBIIdxIuv6UP4pw24pbRqfnDpGkR6ri1ViMggBT?=
 =?us-ascii?Q?SV+WVLjd3zD1wrxvld8f6RYS6vwsFN8cqHrP8XuHC2b+uF6zY5TbGrSpndnx?=
 =?us-ascii?Q?1PDie69A82iM3GhPwrd/Lnk5vhPnJdq+0oX3lwwLmOFMb62kfBU4P+01viJd?=
 =?us-ascii?Q?pZhkQgwevMMa0ZH3adJCvhrHkPxa+cjtvB4hRjixFm7mgh4Wl8O8gTSEMUWR?=
 =?us-ascii?Q?JZRIVFhizxTSONVwdzHYXhb725tS9Xz8op5XV6gq++i5TAPv9yaoYdambRSm?=
 =?us-ascii?Q?uNcIj+CUcLCpd1DcS2GpvV2TsqzwSiv2+T/3X0ivhKT7zYAPqLhZ6xoyGCGH?=
 =?us-ascii?Q?DgZRWh7RccoRwK91MGOvwAVCRwA5B9fmDdfPEive1RleNMMe1aCJgMTp47wH?=
 =?us-ascii?Q?zVbuNfblNR3puxroJetejbN0q/wtYJUPMbXB5+kJGFA8J5yE2FFvpLRj6n8k?=
 =?us-ascii?Q?/1t5S8PC6YJbh1d2r00jDdYfs1DTPA08Pvc+jxBfpJeq9Pzv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a618b3d9-34d4-49ac-e955-08dea6051ed2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:36:45.6292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3hQzRl+NLb0UT4O9bW0XQkHjX3aOO/4Cn7nyw6uYR+bj57LHzHrKB+jZ2tHM75mz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8881

They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
large folio support, so that read-only THPs created in these FSes are not
seen by the FSes when the underlying fd becomes writable. Now read-only PMD
THPs only appear in a FS with large folio support and the supported orders
include PMD_ORDER.

READ_ONLY_THP_FOR_FS was using mapping->nr_thps, inode->i_writecount, and
smp_mb() to prevent writes to a read-only THP and collapsing writable
folios into a THP. In collapse_file(), mapping->nr_thps is increased, then
smp_mb(), and if inode->i_writecount > 0, collapse is stopped, while
do_dentry_open() first increases inode->i_writecount, then a full memory
fence, and if mapping->nr_thps > 0, all read-only THPs are truncated.

Now this mechanism can be removed along with READ_ONLY_THP_FOR_FS code,
since a dirty folio check has been added after try_to_unmap() in
collapse_file() to prevent dirty folios from being collapsed as clean.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
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
index 1fed3414fe9b8..c6a4ecd3d6ed1 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -545,35 +545,6 @@ static inline size_t mapping_max_folio_size(const struct address_space *mapping)
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
index 3b324f03e9283..884e8b5811569 100644
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
index d6971ada8f199..1ee15b48962a3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2469,21 +2469,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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
@@ -2661,19 +2646,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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

