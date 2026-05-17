Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012015.outbound.protection.outlook.com [52.101.48.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B1D2D3A93;
	Sun, 17 May 2026 13:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779026121; cv=fail; b=sDBrze4NSPv4LSBrg64kprfVBChWWLpo0Zbz1JSQ4S4RSx0dOpdmel+wtGYMQFmN2NSbcDL8uheFSj6KtQFPDXKhNjD+H4bkYqvnJG6z9ZYvhf4pqQVsYDKNGWt8gxB+G3ZFTU99juD2ZGXnv6HrFNRQghVtrtMSbEtA1jlwwv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779026121; c=relaxed/simple;
	bh=xEVYA8LVbnRl0rNxfBaGZ2w1ksWp7945s2bmwZdnNSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s7GQuIftDwAJr86fgJ2KgoWQZORkS8PvjIRVB/YaCK+a8H68ZcWr9n4IpWp+c1isTLghytKLoKgPiIn1WSUEgiONWVJWEIn/oMCWxhQsfgYHidH/qNLn6FCVWaJEfW7WauuNe7NDMS1K3qGZjI9+RK+kDBUMEmkygiShbAtUft4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aoopv5t/; arc=fail smtp.client-ip=52.101.48.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aoopv5t/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CFvdmu4jXYa7GmTPqJTSMgOdUvphv8c0r9kx+/ahHICHFKSJoaO5HOJHXbBbky84oroRji8g0n6yXQPTF6RxnKg11R8EEj9rBqXpQg3w0lzlZ5PSDuCB/FI9D9g4XgKSaE7qZ3XO8ZXRFcRafRdaYLHEdFNxiYDFh9ZSZzz8v9MGpEMHEaG1Nn9ZcPk+zHF1xxBqR06w01vmq1uXzRwlAyQDs4LcIB/J3IhUobexQAxT+6XCSPhQa2ZHoQ7FZ0ZnV0LhnWG0DxQULim9QCoCkpjAOHnZfEzeLtnxblz1aEloufikhB5q6TIAYAucNEswtIN51RtdTezwGwMmSBZ7hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GGhu152eXpSF2WeSNS5Vm5FfHzQLndJ/Oc2KEFw00/g=;
 b=NYhHXdbJDZGwYfjEMLqxjVooB9hOhdqRkvrE+WiEDy/v8Ne7GltqTB6Xnfx/CEul5UIM3Hd0I1/A12AdCGVmJBy4uhIzv/qS7q0XYw4oWb/MuBfnuMM3oplZN+o412zs6IlZdb274qyaxiANba2yZYUlkPm8NRAk//8qsMzcwt6ciZL6o8UxD0AECU7jmPOii0NykVGTNAxZI/Vs6xUV6yqiMO4rB7jCJ/sKwJkzF3W1sd5x7VaWzWTVHinYqaolIO2bLnS6xFa6sOlAmbVW0dCxu+DZm+YrQtZA+koCrYWMrb5xQb4sI4RgYyD4ouzj8M5YIJYkQabv7H+n9/aUPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGhu152eXpSF2WeSNS5Vm5FfHzQLndJ/Oc2KEFw00/g=;
 b=aoopv5t/6sgpjAdvmiB5VAOsaenf9u8YCV9f6Ritg6rVX3owS3GR1UeZVWI/2FkFq3wOIrz1u+PpWv+w5v5nyPxcsA0wrqpi//8t3OOato7qilUD7JMG27AKLg9bE/5dhf4pPSLBh1tvwLdQmqMP/JtDBJmEIkhpniFQr4Pp6J9yrK5rhqG00d0+PFymptkxLY++FA6EGywNpfNx+HN6sYFVHKrFL/y4MXMjLLrzR1XP2Ru2pMrBC1XItdwPeSOUgpNtcyJIeJeiAWQ33VexjIhkzFaOyQiuEg9e9Hbg4Us9kEk5U59WUJ1A0lthtWGthiy6X4BF85PUFDiloCxd/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:07 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:06 +0000
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
Subject: [PATCH v6 07/14] fs: remove nr_thps from struct address_space
Date: Sun, 17 May 2026 09:54:09 -0400
Message-ID: <20260517135416.1434539-8-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0227.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: dbd5c735-ca65-421b-55bc-08deb41be727
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	arJ6o6KjoW501i23FMiOlP3RGeU6vgRTk/d46tT3qxrtiniFtBTBZloRXz2VYYjSzMMy0xSGqzRm5hJKG45oLkSf5GYgYch2Aul+D0IdbrRe+X+p/DbqoDuUmWExVO9vPZYulJetCWVbk2LdpWaGLPYaMAzw4JpXYA3tlbm4Te2aeMxFuZTtYynhtkbIpsNTwDYZV3I3w6wGIPXtIa0fgfyBmfFkU7hX24BeRfBeVYh2o11SnxcSttgNWdQ9iHMcGqafuzOySZHGtwKIGfwoTDF5QlL7tq3R4msSJw1xFJ603WrsKtS/DSOmPLt5/ToqtF/bHQZv9tz5NqK84OBz9AR/AcH4yhMrOcrhv/sHJRhhETSZqo6H/GskRZmMEJtjWc8N8RSUD9j3kWNVkmE4AQRc7NIKmyez2LdVhDkf8vTXzAUtzmGYDmm428jKw1tQQqCaEMot/zA8TPKzOKJPyvTaEV6rL5lD59WwEhZaRw4kM2mUicOLSYbQAWUagWd4+a+Sg+lU7hjVZDwk6fHJNnz8SwQJDu52d6AyUOM45Z/cIabeTUQoOvknhPQ9Mkj5lLYXLqT4NQHmB2K4nm6sIj2FSGa85DFy2XTXsHfagMIlNJ4igCuT6GWfkK1fT9XF9vrHd6n9bo7zXN/EnV8vQlkDOkFxCSu9YKBDm2Y+iVVEe1SbQ3xjRPcRuEVM8V03
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IW7N13aZYgC5w3LJZx3HA6NISP+00vObsUGcMhXIr//LndfPdG9u+y/wFXYP?=
 =?us-ascii?Q?QZyCcgGFutF+xsaHlHK49XidUWE2vZTQDbF817RC9g1XaeC4WBNYKjJ/WviZ?=
 =?us-ascii?Q?qpNirMYouMEFIy5UTm7OsBYwZinZx/AkBDbX97dvSqKx8y8Sj6mY6M4jle61?=
 =?us-ascii?Q?FrRUm9tY1vV/2cpPVIrUbhrIR9xyqqYBX0Sle+/gbYQIebLmNh+tQW+Fw/Qg?=
 =?us-ascii?Q?7ahFrE97Uax+8SC7Qwn+106CVZDK9Ww1OGDAejnT7eyt+0IL/zHzvceYpE0P?=
 =?us-ascii?Q?FT5MpfDOQL5Eg8NXLC5YQ24mo3bC1FuYMIcDv7KWEalKUP+ILM39EHSBGThM?=
 =?us-ascii?Q?8eWnbDXUv/LcGejoBZTw6N7qerBvEkOrbFNuymS7FMoYbiUDwhRqVXYf0UfZ?=
 =?us-ascii?Q?YPvAwHg4YWLJ0jYDQAP4znGPbVzHEAAMkPzYawU8oR6ylDwjMc1VofVkRc+X?=
 =?us-ascii?Q?t1hcI5VGGuVeyl0zANHq2oouziVbmrhnJVy7neO8KuPf9Ce0veXR9IVl75Gn?=
 =?us-ascii?Q?amMOqdTHVIySGbpEmk3ZVUPRfgUrGQ9wgUmGMrrAycaz/FA32/QLXC1l4Dps?=
 =?us-ascii?Q?9J8gpwzleYEImRI4BfivJjWLvVHwcZIfqJM6o+9gFNtslZmJOvkSJ5ZmaU9s?=
 =?us-ascii?Q?V22WRmO+mnJDtEcLJqfQEUY3nznyADeVHyigKzuQhwhbhz35azridBoYi1+A?=
 =?us-ascii?Q?CZiuZb674IqdQz1KuVCRWi91S5lei1sV18lJtwaAYwWZSgYSESC7noTvHlxx?=
 =?us-ascii?Q?9CtYTkEJodrEEWb0Q9m1zJaWciqDGpfbkiNP/w8q/YL+2ysT7Nq77xOXkQCt?=
 =?us-ascii?Q?CiIf6dBQ5kLsCIvq48P/7Fsl8/9K42UGq2KhzPt98ON54WWe+x+mJddckXtS?=
 =?us-ascii?Q?OXl67zCoep6bIVuPystNoUkyxbDyuU+weL9W5XQOG9T1fTg9yzpyJqo5U4C8?=
 =?us-ascii?Q?+bRnXsjZHkwR3PQ4q+dzh+Jemb00MatU85EglCXbhD3pi1VlXzpffMysjzcc?=
 =?us-ascii?Q?QGTkRU4KHtSELaaERgEKmqoKafG5WGPp692gQ1hXhChxYcQWelJ0xi82dHj5?=
 =?us-ascii?Q?41B+jseffnI52lRyFed1++fTpTNtArzM1DTeRPw3Kxqs3XgoESBPLdiBco4L?=
 =?us-ascii?Q?uc+j56EHWSfl44AC3KCdOh9LlwWnv23VXKGEhWR+0Lozfgzz37OquqCWI0m/?=
 =?us-ascii?Q?Vg0OWasYV8LKBKYsPmv4vIR5LZiek/evbBk3oVgUBjfI3hSe+h6ddm5G0DZD?=
 =?us-ascii?Q?XbeKx46pIgMEVA1cZxT1tyaQPmdn6R7xo4+el9x2K5lZRSlY3eEXmDZYVLIe?=
 =?us-ascii?Q?+U6Vh3FUEaQwYP2PRUdJIEmM+K/A669un+EixWier2J4Y2Z3KZpahZ1G+PCo?=
 =?us-ascii?Q?FM2zVUy8Iq/5aiJyZ3Bb/qFz6ww4MK4OT0SNRggqcvhe8WNWnq8saHliin1l?=
 =?us-ascii?Q?8LaCOhMPDwPYnaui4b8DXRuPWubFcoKeAKWHhTWzQ6oxGandSkn4wZAWELdU?=
 =?us-ascii?Q?Qfehi1ibY7SBsh0EeBjjpm/9hLV5JOrcFC++TGcFyBA+QjxT9KZu+x/8AMKS?=
 =?us-ascii?Q?kAO+zRR0ItEpe7dNqI3vvpi+f52CQnaY4V7tluZKGOt0Pq0meYzgJtF6Qaav?=
 =?us-ascii?Q?gHGBhFTaFIdMzfqPD2KULiLX4FuMr5UJRDjgcx1Jx8/KVnj8mo3jR2xxDaLY?=
 =?us-ascii?Q?mlUQ7AXLRVxnK4M4qXwTMfstyfuPQJus8Rn+ObZU5RWKXczK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbd5c735-ca65-421b-55bc-08deb41be727
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:06.9149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Au3/KZ3un4tJZC0URaJiQqXCfE5iOpxN4C8w6HvYe1gydkh2ZJyK3pDHD+LlLbT8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322

filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
is no longer needed.  Remove it.  This shrinks struct address_space by 8
bytes on 64-bit systems which may increase the number of inodes we can
cache.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---
 fs/inode.c         | 3 ---
 include/linux/fs.h | 5 -----
 2 files changed, 8 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 6a3cbc7dcd28c..d8a6d6266c3c3 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -279,9 +279,6 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 	mapping->flags = 0;
 	mapping->wb_err = 0;
 	atomic_set(&mapping->i_mmap_writable, 0);
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	atomic_set(&mapping->nr_thps, 0);
-#endif
 	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
 	mapping->writeback_index = 0;
 	init_rwsem(&mapping->invalidate_lock);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 11559c513dfbb..bb9cc4f7207c1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -460,7 +460,6 @@ struct mapping_metadata_bhs {
  *   memory mappings.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
  * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
- * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
  * @nrpages: Number of page entries, protected by the i_pages lock.
@@ -476,10 +475,6 @@ struct address_space {
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
2.53.0

