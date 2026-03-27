Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010035.outbound.protection.outlook.com [52.101.56.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC7D313E2B;
	Fri, 27 Mar 2026 01:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774575796; cv=fail; b=Vhsy9jzN4jXHqTywcuILXj8hXg1EhVEkijkmoXJ17MufisMVbkLLzXH2bL6kdorK07/KXZNIhNsg/5Hdy4JnUld3BAIX9iBYzT4Aoxzb55sGyKXu3UMUdQjTqj0zXghgENJkJubY7mI7qSutuAGS7JLRQGPZnGtPFkjqGA65CYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774575796; c=relaxed/simple;
	bh=G+mtyIIddNKFU9uVPmuG229YgXbxmtjsw2U0uXYDTj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AxnuqQQtF8VO+/fpn85eMlWKYVMEOIPmqu1R/7QYe8Z6yf+TKjcJeniqZQqpE5cNSiQoYOdN1Upl1uH1AqPmqO17L3zxZuOYsFvTVZ9USF28nAJZd4Kfp4IsGfQ1XC5cELuqOH3yf7AGqW95m61pWUJQBp1AouI+Zo+m0gBt0/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ka1ndSTf; arc=fail smtp.client-ip=52.101.56.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ka1ndSTf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bFIaeul7VonZLDabQVhk/kQua8SRYz7bdPRDNlRqiRt7LQCzSfaJBU/deJMjR8Dn1BhLOM8dS6IaQQSADejlzrAEjy6HvN83UN9vFqKAvm4VJz633pnf3ngYR5sf6kjmmkZYPUAXqAqgrG2ov7BM7tDyf7vtPTLwANDAodcqkid71ujZkbTrCJCA06ZXT+eePDKkVwV6giW+yM6q3c0NATsVnL7l5W1cTl1l17ig6lU1W21nI0qWbEHYfWMbhPZ24gA0jSNvQs5/UmwS3NDXdFp8lHPza6YibM73nYZSfbxrHrM4Xyy7w5M1rX/KNbirmDtgpNsOHzT1YELTJXdXZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U2WaMiXzr0SQ6SLYDBfpHefvZxYslS1JRPY1XuHrOOE=;
 b=U9DKo7hP75q4ahpZrMaVm3kKy7MZ87Od/WeXbI0kWtRqkPH7JkyK/vB0ssOMkS7u0wGtxLwkpDyp09ZVe3mG7bvHFqViscp+reKz6q38zRwBLZmgG45VODY/biaCqhBL/Oc0Bxbb1CeJdAjz0adUYopeYbR++rpE5RfFJ3IXEquvKJO1tVkD+fUSSoqg5E4CC3dLKC0TAyWOPBA/KHbg12kiwBLPxL4BsFiEgiBq4WYZFe3ggfeM7tK/2TKz9I+V28ia/1BWmRxHiiAdMdJROSKTm3l9ZS3oflsomp6RR2VRCIGY8Dffho7jxbqlVQ+EXZ+pSt6iJZOg8ARiep3k2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2WaMiXzr0SQ6SLYDBfpHefvZxYslS1JRPY1XuHrOOE=;
 b=ka1ndSTf3RR1aAUBB457Se3s1kbAmwlUN+SAjMjENeNxBDuDoRAya7AzGvfCxzj8tcv3aALjNSBQCySX98eo2CNAbxMiEs6ISmMOejoBCU4mTrJq/Ip8XPR3EQhrXRYWQO2JeasCgwQHhv294FUY8v1k1mSxn99Do68NW8/akD9YKmoD1disbRRDya9r2BDI4vd83WjGxktuywaZKc1k067sKYTIE/WkulHeG11pwr7JyUJbw8pmf3GS7allDTmwnoPh1+sFhy+JclT6NvtKge8pqRQ3epQpTlKlXixqnccY3MUKB+piV/zjR6373DCFq8icCBDk+rZk8ujbJrCRyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9264.namprd12.prod.outlook.com (2603:10b6:408:1e8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Fri, 27 Mar 2026 01:43:09 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 01:43:09 +0000
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
Subject: [PATCH v1 04/10] fs: remove nr_thps from struct address_space
Date: Thu, 26 Mar 2026 21:42:49 -0400
Message-ID: <20260327014255.2058916-5-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327014255.2058916-1-ziy@nvidia.com>
References: <20260327014255.2058916-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0009.namprd06.prod.outlook.com
 (2603:10b6:208:23d::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9264:EE_
X-MS-Office365-Filtering-Correlation-Id: db36ec20-ec60-4b58-506f-08de8ba2336e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gV2ZM9J8L1wuBkxN3QDI7B4yx6VhEQV/DZ7CnmKbadYsGVGCHTUfO7iLBOOcScrmmSvw3O7ehA35ZGz7vP+5rkCT8McfewjENtg5m912PTsITnMhMlt5uJQpyFN2/vonr5in2tWxxiG7Vzmb3fueuwi4KcQ7iNFoCVjArQf70Zyhr8G036lhXemrV08RZ1TWmkE+BoNpOGmVGohHY4ZFdEYP3QzWaCAzrEDiJxoLiiqB5H0Utw7APADa+LmrSsHvIku6kq9hskCQ44ZDiM4Sp5EGaghlhdXlqU3UkCUEn0sTCjbs1s2gs2f8VdB2Oqqv1xTI8h1W4WkjFSb6zfCG/8r01CZ7qXKbLY/LU4usPSULGT46quqSAQXlK6dKJ2hadEy/EwVemIxS5keZxkTvkPhTBMdRIj/5o3I5ze4cBEIm/RrKVHPY95bLZ8cm38Ek2iJGfbV/G/Txz4/ObJnVf4eZJ6dwpO6hYddNyT6Hc0XUU7a0c6RvCkn2abj4y1+SJEoPyLTj8sgLJVCYQF5c2WWbLFYxGpDFThBysjh67vBtDngFk3g4Z9IZqcpHe9ZRhtwOyP6ULMGf/jkHuili/YEy9QoN7XinRFm2BJHuzbCU3URjpZdVQAxk6c2I1UXw+5WQy8T3KHl7DHNFmFi8qzEvNGiFIrWO1n6tv3FJIa/hrOxU+lQhJvUMR5ao7bj+D4BoYBgj+uxB1SH3BoEmrazFsblLYeY6WEn4bWx+gw8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M1ahI4UexvoPqOnycmAlpz+nJQi6Prnwg83Al7KUpzcVs7iMpGLhqimLLbWA?=
 =?us-ascii?Q?tFvh0BI2rtHhGKClDchsP6FRMp51hcByI+UwtQwPsa0tKVNmHis7YGXH820B?=
 =?us-ascii?Q?lSs+vIMF1UKzxRPZ5ufxT6I5P0Q1Tj+8uPndCOP4lnFmywiRJFIVZHtAwMcG?=
 =?us-ascii?Q?tT+XZkm9hF4W/CCGy8QJgMiEgRrdhxIHsRf/Jl/QMJJhLdaoEm3A73DrAmrT?=
 =?us-ascii?Q?N+smrrHPX6QJjTKMizPDeBlpkR/o2X631sxm6F5ezs4bIcoQQjHXYRKJLWlt?=
 =?us-ascii?Q?K8l2dWaQTdy/6YcuCpSB1RrMq0wVypmyy/zHCTxDDcEQ/558O1xBqd+FxGKm?=
 =?us-ascii?Q?n0HPTvCwk1kEUnj3z5zUS6Q8ifEf4iIOq012hrevUQ+F+YoBbYUMd7U8ygp5?=
 =?us-ascii?Q?EJe9yLSY7dXk7E4R/H3II4dEtjjk6wOzVuDcCuAMWD0cxZ7zxGFYyM+JgpbH?=
 =?us-ascii?Q?R1oOGOh4FzBzLJGoHEfjqpyemMAEdFYLXdfXWsTH2F9DZ8636e2Efxv+FtNe?=
 =?us-ascii?Q?H7dpCYUxvARwhEvwILPNI9c0AuZwNwTgVzUc8KvvbXXrcoYTdHG+C5yljfs3?=
 =?us-ascii?Q?euAkrPI0WC52PIl6y0wkHwSEU2s9VO2kilw5JbvXTpm2uzpvO72IDe+p9UhI?=
 =?us-ascii?Q?9PfEd+itauO/cnjZe1lLn1GG1L82rZn0gM8zoMSEu/vcrXXj2y36+GRmqwc1?=
 =?us-ascii?Q?AQvGdjUBf9eZ9eKTZpKoljJcvt5UhkjSqSVFo8YbrtXw1hizSfmiVpzwJnZT?=
 =?us-ascii?Q?u9s2/Lfj8it9EWsbP4iJpPaalUEwF5ki1jbWZXGVbze5kKTCVt6dDhuX3rv8?=
 =?us-ascii?Q?J4794GZgtN3LBHXlFjfKn2S55fAwykoNKGFRnLV+sajVIvLe+IFc5/kBn5uq?=
 =?us-ascii?Q?eRl9l4leEe1Nz0jPqZ8nnkGSB7Mht6xfZ1Iqvjuz4v9+/1Uk+ZOMgY8Tzxug?=
 =?us-ascii?Q?Fs8FYvJa2Z0kF6VQ32c5T9FmPnWJXpNko05mL+C2OaYgtBDMcH63o/3FKnGW?=
 =?us-ascii?Q?gD/3jvlNy0y+O9iXg63o4t6fRrV8Z4WqbkW5BdYAmrIPMPj0BBp+NALdjgfg?=
 =?us-ascii?Q?9MwZM6aCop6Q1IueQq1qzwvqcy3t7BQ3kyfaAEaNslQlJp07cCRu86fQcCRo?=
 =?us-ascii?Q?rapXhAjGD1gzk4jJFJVsxVhdsHgk5r5HgmrsP6A9afZtEg0FlDOVsqlPSg+w?=
 =?us-ascii?Q?4gUttzBKmFHcenfdpZ+pPR3qR0ks/+9bz0swkUnXP3UlnANpdj9FpfHtVAro?=
 =?us-ascii?Q?FqzFpC9PyTF7CnlpGuBwpQuvrwccdlrufNImph1LvdDUOpVQGzk9FMmtofFz?=
 =?us-ascii?Q?bVzmkNdfzjUHhDmTCqr0kTzU/9eEdwvYo6nggWgJf68JDVFw2qCSSraXNLSH?=
 =?us-ascii?Q?lX9YDe0ucj8PSr42s7TooGt6f16o2/W+957jtdr5S4YN1zNCD4F2jA8K0A5c?=
 =?us-ascii?Q?VPoqcHL1PhbDxPJQ5UIVap/mFssiMdMduk8AcpSOXMJAFE+eP0EzbJ8lJnOo?=
 =?us-ascii?Q?9H+qWtmMsqjymDDmqz5LyiLaktmr3DOUsIqE3NuR2CcgG2gRZYb0vjRaNB1c?=
 =?us-ascii?Q?s8nzYTnuB2PVm6qTTb6l+ZzZ1wt9JnQk4gVcp3FsQkC5Gglsy6cJOpwBvq2B?=
 =?us-ascii?Q?OLSDYSzHGrVfQms9NfUjlzlPJeMiQJjsV3c+JVovivy22H9O40rS0eQQndqw?=
 =?us-ascii?Q?AMtrEyfKxG/S37TjXnt5UQSo1oZQcnqBH7VA1u7HwdmPG2RF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db36ec20-ec60-4b58-506f-08de8ba2336e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 01:43:09.8017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XFr+OdopehM+lWczBuRN9svtjsl3SMy2VJlzlEd9YF4g0tqawv9oEZCyZ4/v/qDR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9264

filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
is no longer needed. Remove it.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/inode.c         | 3 ---
 include/linux/fs.h | 5 -----
 2 files changed, 8 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index cc12b68e021b..16ab0a345419 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -280,9 +280,6 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 	mapping->flags = 0;
 	mapping->wb_err = 0;
 	atomic_set(&mapping->i_mmap_writable, 0);
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	atomic_set(&mapping->nr_thps, 0);
-#endif
 	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
 	mapping->i_private_data = NULL;
 	mapping->writeback_index = 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0bdccfa70b44..35875696fb4c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -455,7 +455,6 @@ extern const struct address_space_operations empty_aops;
  *   memory mappings.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
  * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
- * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
  * @nrpages: Number of page entries, protected by the i_pages lock.
@@ -473,10 +472,6 @@ struct address_space {
 	struct rw_semaphore	invalidate_lock;
 	gfp_t			gfp_mask;
 	atomic_t		i_mmap_writable;
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	/* number of thp, only for non-shmem files */
-	atomic_t		nr_thps;
-#endif
 	struct rb_root_cached	i_mmap;
 	unsigned long		nrpages;
 	pgoff_t			writeback_index;
-- 
2.43.0

