Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011029.outbound.protection.outlook.com [40.93.194.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218D633AD9C;
	Sat, 18 Apr 2026 02:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776480296; cv=fail; b=SgHztCDf5uU49NNA1czB6EqZQVFNlVCrGfKx4h7gJus3y8u6ki2JXv+Jo9eI4zz1vdxJbpQ1eCdLA7+WLNUAMj888dincaF0+TFrTglGX5j12rWfDmUwne0LERIRYsjagO0uTRg9qeq5et5v8pxezjtViumGQ+mNZesQfK9zlRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776480296; c=relaxed/simple;
	bh=BvntjsGDuxSCysq0E7uKC4XGkUBRLn0wY5XasOmhqbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bglnLatfjhHefIB7rTDIjTiemclF5+RHe7dWoFLs4VTdl22Frih35T1Y6BfizVX303X5bSH2EMblz85JHNBpoE2eFTIvdlIeTN9DEXpx8493Wmytjz0Y1zFxR857+HJqJO0W9xBP6JxCCeJ7VS+ZxVnQWJtKgfbBFuwspaqK40M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hh/1eI5z; arc=fail smtp.client-ip=40.93.194.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hh/1eI5z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sD+9vze+YyGQf5C5+rRVhYLwJJ0eE43kYKL6C1D7davrfEmlkUDOLtCtak69mfk7KsGpyxc5S2xXaNaqn1Ni3mSc1YWOt6zHGNDQ1s/aFCsdjoDksz8lgW74AN/kmmb2fTAY+GgNWGD6vvGOCy6+B6z4fKRzqfXIZm+DnX4zNFrc+wpA/rIUc+0X5c99/vC3SQO2jBmNZoParPn2O9RYy6AJcj1eXfbLl+pnSuZ7b2E3YJP3pYs3Fzpe+ezMwp1pwzrSbRfoS3DESnJ3zS2WrQogKqwYcg9RaWU7AnmV+AYI6nTaVYl+rQKkH1wY+SYs9h8pkkED/5YiTuB31MnQaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yiAxSos+tR/IOka6D9wqzZcO8uxobs/5c6TWi0tmJ/E=;
 b=K78rJSx5kkH9Rn9NcIt/KXtAgp1kYgXXcHGdjkGkz7fNviMUueCA2EHdWEngOrMo/aGFjgZ1VwJqOlCFoAITHgCj/dvQpzjZDAvHHlG0+pPez5LPlgFUi4KXwnfOmsbjRfzmY1uCWot3QEV/RxRIwjUTJ4VcQjh2eV5BM9B9nc7h4Vg5s33QXrfA7A74UzDNteJdI1uiRfjsswmBYTLM98bveTG65OcYqn5EyGeGfh+/jRKWRpTkO3vFvifxEK1ExdQJiRUp6Q57Dzk0mpO1w9iXcSYASctErVJRNBmZfgEpUOWpFPqdUcF6MNAegpXHgG+0Hi/7UbD023fV1SUVJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yiAxSos+tR/IOka6D9wqzZcO8uxobs/5c6TWi0tmJ/E=;
 b=hh/1eI5z5o2ghtzHWtZnRlo33Ou3LwSkFJEpirAuXBpULPLNUVI4dE3dbyygHZMl4nZWcKA2EA5BkLsdI+osToT+LbVL6ATePXRNyIm/EEl7VAy4bP/n82FKs803zRQdB+e3MrIu8IADO1uwq+1Qv2odlY8F75Xr5F1fLDVHc8LjTbC3u1uEJeRYCd0RpnV9n/5T/QwnkkvwJq/1+pKU6GWvlsbubEgdIfca2VZMwRnlnYam2NrocwMKVRFezon035Tz8q+zvU1pgridwi93sEcpMlU5t9m2ZI/d8t9us1PI3fLYITfWtApDGWuLO0QknkSqX83NY9i8AYs09j6CnA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Sat, 18 Apr
 2026 02:44:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Sat, 18 Apr 2026
 02:44:41 +0000
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
Subject: [PATCH 7.2 v3 06/12] mm: fs: remove filemap_nr_thps*() functions and their users
Date: Fri, 17 Apr 2026 22:44:23 -0400
Message-ID: <20260418024429.4055056-7-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418024429.4055056-1-ziy@nvidia.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0167.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: 319e323f-71b2-4ea2-3860-08de9cf470b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	8DfmGWKZvJZ9Jkiz5RsvosExglk6EEv+MOSaseyqon+WThqCLBUV9aBxoPhBvBCkFuWWPZZezQbOerk+e17BM/kwTHMtzSXxHS7CuMbBhSaTmwOSr9VP+dKpa6I1Sgm/gkNbpP7pXlv4knxsq1RjgEbcB2mzZV/Jw3DS3zPxsNz/1kXBUJcPK5FU2N8lqDORBB/4a1zBErUrBRgurGdcTr1VG2pMY8g/Dim3iaQ5pTjkOhRwMtT30tV7BHyyc7IJR78ktLTVou0qQKtjCECfeI6gldLfuAGOiezcbVz9NB9bxVTtKYWQPpqma8lLnHifNXd3FvpvE3Q/Srz9rRma9wHhCW4Xnyq3RF1VAfI96VtFZdSpCn5Uhyq40csn8iIKWDvHTxaMQlYhOx3VhqEE/jfqGSmadSQhBtvLKWhWoFkb3SBsm17I8aK7XGNvBTwd5DD5cUH9o10ye6Ga5GVCM2VrTBgeJdhcvhmAyfmRaVqY7bMmTvHkTZQ4qxVut96NpwYwe/6AoS+3Uu4lDZfkdxZvkbTLwHB6eHjv9UDDGbeg52cYLNfy3zd1xBvq1q9WLxAkyb+F0mJzZGhu9TkMiOJOoI2JKPIKmDejIvrbqic38s37BIjReg9QfMyk/T6Zogi7QeGOEaFNQgSMlH7U/gSdH8vZb5wZBjwx4+z4b2ItusTmwOX9RwBOgw6rb7jogUgFx7p7E3Sp5BBXP6ZSlPfK5XYS6s4A5sbXoqqrFK8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z0wCRBT5WQNXyA+jRAqfMD3zut7auvYayBZcksJZEVpIwgFsc+ky+SYxG8Zp?=
 =?us-ascii?Q?BhALAURb+Z0sUexZOaoAp6Stc2kSpG4jnbwqjvX0XHSBOiwrIX7v586u1984?=
 =?us-ascii?Q?rX1qn9pMNqzichjaTBSYwBe+M6y74fBbDhlKI6k1MFgvYOhz2qxcWImEmXeV?=
 =?us-ascii?Q?kBytzjohsl15Gi/gQc3h+J1JDZp5Jc/IzTLuNZanyDEKQsrQzH5S2eYuniXr?=
 =?us-ascii?Q?tAq5ROoMlLFj++uQ0nrc/n5C09ahnTu88/U9dcrN8dEhhJYU36s3YNI+qQoH?=
 =?us-ascii?Q?r4iKxnll59bSLkvN7CtAMYoKdnaPdOq+sA6RJndrgq05Jt336W6gJnNbkDR0?=
 =?us-ascii?Q?7jkG/TygZ0vuIwOzabvLjz5OIsiJwvpKqAaq1yHWUBmaIsRSSn6W77RSY6NO?=
 =?us-ascii?Q?ghwLeComwbxrhpAUxEFi8vfXZVgBfCwyGxQmOcdzEnaAT/2AN1pqys/s6RfL?=
 =?us-ascii?Q?g/SFxajaX3hL3pyONrEWLnZsueyz55+KHypk9L9Oy0YxyanCLbf4EQoCMMX4?=
 =?us-ascii?Q?wxGXNdUObJIah6kqrzPSHaaF2Y4q/oNIwwDh97VD7bBGSMvnBsos+YeDDjFm?=
 =?us-ascii?Q?OZ5PO9M2E4HSV9CR5LQcLUPMCzqLa8hrgLdh8RI5zfXaqULddtU4a8ABjWfG?=
 =?us-ascii?Q?zmV2h9R7Oq/qRkozOUbUo/kn0Q9cYMQHBIZ1QpvjbJ443bF+jC/e3HTp5JS5?=
 =?us-ascii?Q?AjXqs0jzW/Yl7rg8oRiBKsSBqbWzQoFl8FTTsdKBTKbyFXGeiDcYHZcG/DAg?=
 =?us-ascii?Q?M2nJBZI1Lk8eufroKZAw1fOhDitKszcBr7iWFh5gd6Uk0v3hrIkmge5qRYEN?=
 =?us-ascii?Q?Nvyni01VEvknaZ1icNhmmAPTrsPlA35V1Xa+95mfGMcKGuQ2Zuy/Z0ozf5sn?=
 =?us-ascii?Q?dcOiEcXYjwyX4BUH2bfWYKn3XqDm6IXt+HKy7nCbH3OxN+r+8YvMRBuEWcKd?=
 =?us-ascii?Q?Fj6HTqkcVhQPmVJfCDmXijJhy1iOMdCfDWVSppqg920KPNuRIY3zaS2m58Xk?=
 =?us-ascii?Q?3SJfrytKAv8lOJ71G/QgZQ0HMQQbBBoNFNCKeXnQY4fPIiSYXQFjYm2ZcO4G?=
 =?us-ascii?Q?zN8Zi9L+RwHQImqq3P6HhLYyqmLACqe4+g+PWlKbjyaOlkL8E38UvLvNyU4L?=
 =?us-ascii?Q?q5fmnjUCK3lKaGv1boXojprZmvqOy24GUZo9VVZnCyg/YyhFk4dcpCNPyr3o?=
 =?us-ascii?Q?APsf0Miu0/Bb6VHGmTQ5UYr9bqk9fzjG/4nC/D5CEGYvW14yi8fovUfgnRvJ?=
 =?us-ascii?Q?PduFVaGFXL7SVih73F80EAtoR+t5+wxiL3zUN2rbtn9dAAcyYkfiEgPXVXI1?=
 =?us-ascii?Q?U2C/aBz4kLnF4k4hIyjw1OkIJWY/OKSPYq1D+9q1c1E+0Wb0BOreCQjHl81+?=
 =?us-ascii?Q?RPnxw8fFCQKEK4dTkGV3zO2+nVuMwacoTAz5lj4j0cNvjvMxe4k94ci0NJ/5?=
 =?us-ascii?Q?pPSKKQnCjIer1FKtFy9BQ9HCOovdsHmEJmRteLZnt4aksHPMBW2O1byBi0oj?=
 =?us-ascii?Q?lm3d7hjnzDvtmMAUdTvs/F7jSCHIidMTksK4RClpXrkl6j2eRwXdD76tCXrh?=
 =?us-ascii?Q?bER09ipFQHy/3RKZQdpm1t0Cpf1yKWTwy5Wp9zPhaJxpARy0UYjr7hAYUjz+?=
 =?us-ascii?Q?H2RJCmbvZk5LOr/ti/Ln1C4XZewbbfXJtz8DGBKKJTI2jIXtqP2ofAhSoS9W?=
 =?us-ascii?Q?SZpZmbWmADU5sAaEoIJT7GL1lFQ/pm0iYT5C5D4clM+FKTJW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 319e323f-71b2-4ea2-3860-08de9cf470b7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2026 02:44:41.1001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1eSijqDKOe+aqttXVqz1IdPPU4NPkCQfrYP1aQkAOPKMTzF7LTE+odfjsjvYXvCY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650

They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
large folio support, so that read-only THPs created in these FSes are not
seen by the FSes when the underlying fd becomes writable. Now read-only PMD
THPs only appear in a FS with large folio support and the supported orders
include PMD_ORDRE.

READ_ONLY_THP_FOR_FS was using mapping->nr_thps, inode->i_writecount, and
smp_mb() to prevent writes to a read-only THP and collapsing writable
folios into a THP. In collapse_file(), mapping->nr_thps is increased, then
smp_mb(), and if inode->i_writecount > 0, collapse is stopped, while
do_dentry_open() first increases inode->i_writecount, then a full memory
fence, and if mapping->nr_thps > 0, all read-only THPs are truncated.

Now this mechanism can be removed along with READ_ONLY_THP_FOR_FS code,
since a dirty folio check has been added after try_to_unmap() and
try_to_unmap_flush() in collapse_file() to make sure no writable folio can
be collapsed.

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
index c3cb1ec982cd..a63f818910dc 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -540,35 +540,6 @@ static inline size_t mapping_max_folio_size(const struct address_space *mapping)
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
index 4e636647100c..d3cd4d2f3734 100644
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
index 7e9cf8c0985f..3a310f1f7177 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3926,7 +3926,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 				} else {
 					lruvec_stat_mod_folio(folio,
 							NR_FILE_THPS, -nr);
-					filemap_nr_thps_dec(mapping);
 				}
 			}
 		}
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 718a2d06d1e6..c23c75703161 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2116,21 +2116,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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
@@ -2308,19 +2293,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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

