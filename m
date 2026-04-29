Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013048.outbound.protection.outlook.com [40.93.201.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF13E37419B;
	Wed, 29 Apr 2026 15:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777477023; cv=fail; b=LgZ3YmtD2RAyW9gg7C4zkqJMT0qG4k4XW9ZZQnIMgiHNKwEABLTZ2BJZTgfFtbANVAvLOlqfFQgeJSXEwoYbl8VmJ1T3l31nz77MfCtxAO3OxGjGwGgt/ojc4nJomXB0n18382tuTlrT0OO5UG2mZFPOR3bZQwH5p10bcR2Vq40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777477023; c=relaxed/simple;
	bh=C8QsjfpKNewqy/FEJ70WrAGBhBL6tnwh/gYYMQeqgbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=X24lFQKordURTEKBfdKmun1Gw+3Qofd7QAex1/GqzykiOdok6RQwl4hc3dfM8wwAkkLQFHzgcB9RRa3SnyK05YZ15yjzAGQIORgBBfzdkbC0bB3EtFXmMABYoPB8Lu6/lWU6vWAhSHtPRHY3FUF+CpQodGZveKdHDOZd3nhm2ds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M/pBDHtO; arc=fail smtp.client-ip=40.93.201.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M/pBDHtO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rawNT6VlCJEU4lxPqLLQBj0w4PC2X6nNZLYhuE2u3tUHSSXQ/Yj0jeOWNIBJnN2ZcpumnQf0hNEYvCfZpvPmoSn3anvi2iVhtJJ8Uqt25Z4oLbBvCcr6y+VlTnBge8xlLNyVy0AqhYfK+6OUgBrdDQ0mWBC4L6ZenIK6GErOCP54xFW/aRAW5d82baSf1G4lmRG0nb2pAPlvnCFKwaMal0nzlfouHdsQOWooUYRyX7IefQyp8nDoq4tk8VMmmQ5KboK0W8l1985XEmjLsC6memneL0y9HBcH7zcpkRji9cjzNihBkxZ4OFR/eQjBaiqUwFEh+krquX2pcVg3Vnfevw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VzPEzaFT0PPo0m+nXKA/CE+C+L2BEl2OLWbZAP3NPks=;
 b=yQACSellH6k9QOygsNDMqaiZZqLOf08NeT++pKfVbpc1xpox4dcCGY44hFasMOKLfyDnA7RVFEOKC2VxtPOK75RqwIiUo2cPertmRYgs7JIG63u0ZG62UZYAI5nsvaRFMzh2KSQAbwTAIuZwOx7Aj9t63KlWCdU/n2zUq+mOpMTHMGqodRT7VE4aoguk6tnvK6uxA23h9If/N06xRZsOPlmK0ZFj6DBGw+cmZoRfqs1fubHt5th92lmodcwcTNlmgTwEISw64Cw/z4336r7m2PW5zcoraXwf6POKRWa6NckauuiaT54nktyYz8ZlWVSo60wvnGW1HCwRB+PHdppZFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VzPEzaFT0PPo0m+nXKA/CE+C+L2BEl2OLWbZAP3NPks=;
 b=M/pBDHtOQnhUSCDItQI/7bupszH9FnwGb2RtsRrd1gsuL9MHcGk+56hOoydtW27Rlz3MEgcgewh8/Z780e7AodWvd4J0FFRKPzSSE5HXESqk9aTkeERWd2MK8mlbPPAb5SlIxnlwHUF07GePe+Kcidmh1h83he8pBa/J85bayjFYBMaipmTldDRp0B/hNL/uiFA7fqpzghtfT+2cXkEjdiQ9Oe/4EiVPKSQug+lXQfK5nbivqucwVnsA4rMtVjnmAbkrh2S5pg7QUCqsX7x6Cs7XiNod/a4qHqCFWhQfkb060M39RCCvAZwJ6lNN4duOYsYMKNXNa1TDsyY022y1KA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8881.namprd12.prod.outlook.com (2603:10b6:a03:546::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Wed, 29 Apr
 2026 15:36:49 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:36:46 +0000
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
Subject: [PATCH v5 07/14] fs: remove nr_thps from struct address_space
Date: Wed, 29 Apr 2026 11:35:30 -0400
Message-ID: <20260429153538.727855-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR08CA0057.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8881:EE_
X-MS-Office365-Filtering-Correlation-Id: b14c9c58-1b73-4621-717a-08dea6051f90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	mSFRzH5dzUfX8RdrM12cQb8vDQ1gK3xE/dFV/grM1Uon6TRVtMRzT7ianEICsE5Cr6Bo0q4d7DgMGPCQ9j3ILBankJWzyI/Sg1vgkkxIkp1KewCKGSv1lL+wQ4IR1eIyOAusF4Xu/m2f9NK5HTCSts8xHDmORS0g/qBzi8QjJOuOJ/guTLYr+YOwAfITE1is02cJhTJECDek4u4P1vVHufLU1R/CPu/1JBAZ8qz77qB1vzB/sD2yvDmu8HrdMAKIUC8XYt9WY/PnzWHJAXM2gc2Qrzdn6OESyufh6T9dH0SncDRkVApTlK1WHnA1055mRIAaaS7lUUbkQc++r9YnBBdNRkNK0Hy+Yp1YAcRSqrgL3/ydFBpsXiGPcXvqErwkSab5gZ2ogb6gV+jt7PhVuJnVL5I72QEtqqD8efcbyYQv6tcO8/vPUY2NEZe9EaHHxU/bnwxdj0tzO+rBSXIbTCVLohB2ZHJyr4bAf2Qq2sdnswEXUa/XiuVUzG/fU+73Sso7a1uVwIPPLTq7Ddcknpi0ERi7S5U1JIc2rqH9LQPKWF+44BRPNXO0OPBJ/pMT/klV5JwHr25gCJTI5LK40ltAxRkmPI2MqqXGS40t7YgzbyvEzateLxNUFvtAfgyNF40YEUZHjwt2iDb7/zA8vjw1lIkh/PwuimTLF5bFyjEBJPIJW7lygZOmThn4W5+Eq9TVdv0d3Wf0bPi9yGHG3AtIDBQIVInZtFIu1fwmYts=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?30hBulo3zlLLhfwwZAB4OvnAy1YtxqiZYEhVF4++Qv0b9iDRxqHt9pmd/630?=
 =?us-ascii?Q?kJ/NUA1FNpig96YIhl0SbFbL8t3uMxA9BrtcCyy5C7fuXG2G53L96c6zy0J1?=
 =?us-ascii?Q?+IIianBRWk/dh1cAnQzcBqki9k6D8Lu5Mn7O0to759rvEY12VjaohSUJ6LqA?=
 =?us-ascii?Q?VSi2c9APlWaa4e14bvde8H9TMlIb9qmcRUFmtxjxKxfJpL0rjDRitezgGbDb?=
 =?us-ascii?Q?BMB1fNcGls25IQX/jL5eIAxzoYLxK/hwcy8RPq1BXQn7rWPpz4nIn5aNHOxT?=
 =?us-ascii?Q?cS1ra/mHGblUdlLjSd1vfbRG5u1z3V7pMYRXYyl6nxJziUvLsRimyq1W6bkt?=
 =?us-ascii?Q?AY3F81poYvFw3RI3QSBwxGqkp3yEABfoCSMQo/f7eW95Qrw9m+ATZ1WBSGRn?=
 =?us-ascii?Q?aTjsTqW4R4VY0/qZAPMuNEpK1CMY6mlV9tCOFnJnEGsyC1ErMRtpzWsV5jE+?=
 =?us-ascii?Q?opaTIy16/3BeGy/qO1FyHDrJqDhAflTP/meK14LmbJ3vcUVlOLu1Q3VoYxiV?=
 =?us-ascii?Q?8tJDvtFI2VKeYzel1yZpvjwyYfKPB9K3iDSP40qoELt87GricgfwL8uDvSGg?=
 =?us-ascii?Q?XORKPlMjsp65WOQX0S+BlSuT7eEa9KLGn9xvzLPIO7em5+svqlvkhP0+RWvX?=
 =?us-ascii?Q?Y61BdQOGc14ORcEZPpeeIiSxrIwvw/TKvs+U61bpIcvnscjL6rtMMuvx6hD1?=
 =?us-ascii?Q?+zOW7AzE+Q63PnWrSfR2ueOAF0z4hpW0kH+Zy37xATMTh3q2414rwVgd1cwy?=
 =?us-ascii?Q?bg5vFx9KsGDkQhF51aQ0QXVb19p0kpN40Ye2pVi4wQoqV9XQ2Vl2F02Nz8RE?=
 =?us-ascii?Q?AzAkbZtoquoar7z2KifU7uOV4ahMN4u5RiaUj3EdmtL2IBByffN0vMFQrh+1?=
 =?us-ascii?Q?MwFA9PFgZ65H45LJrFsFzLTW1gAXaRl1Gj1+PXTKU2kiwbRQCItnUUVx460B?=
 =?us-ascii?Q?QODCrSNvIBQ8q9I03ypgtBgyuDaFfLAZUjxdS98ZxcgkKgii3oQvZMeE70Zx?=
 =?us-ascii?Q?apIUu79pkfvejjJnebnkMAewOcM2SnxF9bsObJiYT/CASmASVHDPVHt0guMV?=
 =?us-ascii?Q?qfoxW/AbovhhBMH1Utj2Ylg3HsXQlG4L5bldLp/4zBGJr8V/RZh5SHDZLbTR?=
 =?us-ascii?Q?rQWs4BOE4wyYOdPUCpd/laxjlpfCa5/a360SzBi3ExP0RkbhIRwswUIUU59q?=
 =?us-ascii?Q?YHaVQYzQxgR1aoQYLlm+9D/Thv8tXYNOElk6LsfY5WaAHJ0r+wCcMTsdCwcV?=
 =?us-ascii?Q?orWwi5VCAJcnKbI7oPHetywW3f6VreAcqSIW01O86Oj5sW3SklzVGq593qxe?=
 =?us-ascii?Q?2fMyFa5HrXC+v97O663IaC4GooREsvlA0iMViES6Z7dvB7ETanS8AlTfz/Y9?=
 =?us-ascii?Q?F/fKgDcwt9caHMpa+tiB16fE4QPqGliYicDAbYbNdu7yYRw89daqPDzFx2ek?=
 =?us-ascii?Q?qhmfld11JSxnlTAVawQoQdhf8gjpU5VSlp3w6Vn6HYtkDRSLfyd1LW5qtKlb?=
 =?us-ascii?Q?pfttqjMQ0Nt3CG3n0R/5qzto1p6Y52oOhLqWnYdHjr4ewmX8mDKgMhpE44Z6?=
 =?us-ascii?Q?JkNteJwUlG5eztAC+WKayNFbUSRc8LgpFNRIm86qVVXY6QzCTuPys8Hjqu1l?=
 =?us-ascii?Q?jH7mTgHymJQ/StL4ZMBOwud86ZZWwdGQ0W9JnfphRx+VS4FzZUEPibhXrukW?=
 =?us-ascii?Q?BgLYgxVc7tYZjRbhlBvq7nHcTT80vC83xgXzK+8teaWx2SFb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b14c9c58-1b73-4621-717a-08dea6051f90
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:36:46.9035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pE0GEkRqKdbICyjeFgBjW4/ryafaY7zrbKKC6EaU383VaJSyJCoBi9MwscbbVZWY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8881

filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
is no longer needed. Remove it. This shrinks struct address_space by 8
bytes on 64-bit systems which may increase the number of inodes we can
cache.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
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

