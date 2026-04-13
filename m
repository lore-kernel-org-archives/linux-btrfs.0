Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010012.outbound.protection.outlook.com [52.101.46.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A150D3E1218;
	Mon, 13 Apr 2026 19:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776108070; cv=fail; b=DznTd5eMGntUeQcRroA43rJQNsEOD61r6xb5QLbopcNhJ700eDyAjCjQC3us3FBO+SlThe02+g5seb4lng9+nrDfeqqeFpF15EnljwbiTmXKub1qB324quhqA1bZJPhVCnMTXjt4EXcYvEQvnEt24EQmutaIwxpx7mUtTPmDB7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776108070; c=relaxed/simple;
	bh=9h7w8+Wr8t6fqCW1eT7hHzfjN9CkipktgNBkOOzsMh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ce8MuiwYaaBqrefxbjDaYsDJdhUmq0YOsMiJ2Ea+trd2xGwHsJY87EE6tYU7a9MyKeh77lz2xcoUgKhDmVnLFjmF8DgbXQeyY+JZaLa2Ewgo1o1RpMJtXHHM+Q8A+U56DM/mOJilhIwzaSKsam7HBXGUHB3ekSIMs1IQh9A/i0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m/r1ExBa; arc=fail smtp.client-ip=52.101.46.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m/r1ExBa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ChdQ9Nar/3A+5aswCjPN2JLDgOZCEWPfCx4Cb4RWt48IB76E4I/b5rLkyMOdZP/0euaqI6TH2VRYeCRYkau0ByUvZLM3ZN3ejbA6sxiLIKPWlDZpSr29SUkmQMj329p+28ng1l5fmVBaAZpBPMIi4mD37r3Ua0XttI0D/whXniFW0hdaX6Ez01uvuWDQj+2GSF7hleHHPpP1z+TliXI3WYC6+D9j6hlPRiCJIDNKGXPnWcgmguqipB/YaUa3E73yYqjrDHYbTaCMrXk6IGA0rfpdOaUppicStIIa2lYyynrMSM6m5W1vIyiLvY/BwtaXrvHupDuuZ5XrNPgBsAPozA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cb1C19gImkxeTr3FWZH+1IFt3hjaxVTf/e8ZvzJeKOA=;
 b=RSVw0IdLOMJTh1bF+WF/fM78i9Z00AnCvDpNfsZ0dceLUHMyT7MXbfYGYF75qTLT5fi46p2csSPeNZA70KWiUwNS/mAmwzpLJecWBAFEZtwTQYDXeSq3SfyYN4AOB0kkP+DwtP02MpjwI/m+9PtuUf3SOWc21CoT3VL2e8zoeYheBByOKNrbD+UDEn/1p1qPaDyC8OJAlIpDO0FmOyecnqCfqPUheVCOwRxgoKrs86qx3lx0x4Jebor4zTnr4Ji6strHkTjIYrtbPyK6Aep3Z3JEaPu1mN41oF0d+X3AIZYTduMxMSXj0bHusntyf9YP1fq8uagkrMS96oCosC1P7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cb1C19gImkxeTr3FWZH+1IFt3hjaxVTf/e8ZvzJeKOA=;
 b=m/r1ExBayaL/egN4e9z/ulmFo8pLgrsyBxOY0q4dLnNO7XUURUHQjVoHaC74OxdmfL4b1DndsmCpxBkEDi/yotr7UlHgPvokFDEztPyBV0x6ywb5eRZTVID/GolHnfCim1oLqDRDRmIbX0mRm+Yb2APGY3BHYEBz1netHG9JbCC8Y0IJ3O7dpwlAD47Lq+JOgsA+WKwtsfzxTulpBALSbOup/9RJAxt6qh+WqRtR++8PEvGmg/nRBMxm6JRpNvODV6UxXprLoSUeEW7iBb3yvUzHXU469umKaIXyluQdeNSgperUqcewFpZHMqVQrjbUeP/r8VgQwXLv/4pQ7hcDyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Mon, 13 Apr 2026 19:20:49 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:49 +0000
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
Subject: [PATCH 7.2 v2 07/12] fs: remove nr_thps from struct address_space
Date: Mon, 13 Apr 2026 15:20:25 -0400
Message-ID: <20260413192030.3275825-8-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413192030.3275825-1-ziy@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:208:335::22) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: fdfb06b0-fc91-49c5-a779-08de9991c51f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	c+DCloSmEImTi+VEZA/HVEkxrIxDFDCiXpnIGtCezsZybdgZ2nvuoB2BcLoHW5e3xOiVN+LNJv1uycLJ2xhuvgtDz9tffFh+aVD4iQj9GAeLRMTnaEN6X6VEJkkS0y1V8+B4T9gUcE4Wp3sZ5eLpxduHTYtGurELHHAzrUpNwkkJm0nDsA3zDpC3MWtUGA83NaWQNqJNmn+pGKLKG7ePiXztyhFEhNXbyYe8u6nhAQwATKUbW6b3AFjnvSxzdvtq3V8P2oeYZmhI3D9jVngJ59dlGh2FFXdeATcUOROAzicFLLHDKO6dr0EqrYImyL8UGVZb0RSZZ3Jy1F4QGWCwDPf2dKoe9y0P/FBuv2Spf0A2KY8o+Ncb/PPQpV6cbvQ5XPV+jlBPgFEDIvEkTaHBlBjOk9p/67ZkkOBbj/RpjemnV08K+TEv5lpu8EmnftslTE9GSqJfqEi6WiNFdx9SujL0JAfbE0qsWRIOzAwq9tzlEagVFI2e5nMPbslMUVRDOCwDPuBzF7gifGfqePkbzb8eo6YAbzJ7IfZ5SWsdbmeKU8PIE+g8A5RPDWTD6jbD89ugtSO/VcEhX7l4N24bj6U1dCr5ywPWnOTOuB3lFY9+Y8XEOTtgdsKLtyLbmyUeuONtEdeqn/lp1pcFZqOl39QhYkDATIQP2jnflxviy3RJ9eMDeZgrAWU0/8RJirKyTNsXulb8mmX6q79ICqDRlRKnsZNKdmCcwQjvS7e/0Es=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Bz/rPfMsEC0FOHbgogIPdeKDpBW0MItHkwYSxUqhtV+HbGFHy8Ig2R1EEJrs?=
 =?us-ascii?Q?LDT+rtcYfjBL8e2PzOumoYzu3ymn5ShRKM35hIpJIzP+mPP24+25CYJEmoBW?=
 =?us-ascii?Q?xX367YScfEaUeGEzsF43vMzApI0wp17CHSDzxed3Qro4WwvpdZ5K9vTeiYBH?=
 =?us-ascii?Q?7JynoULsN2y37DkgxEFoNJDScyeUuEK7iQFKm0ytBtEz8Ua1coEj5bM5Y5XK?=
 =?us-ascii?Q?vLjh5ZYAbdviiHuirM3WLwxPt1RSn7kv3rYLbDc8jfnmWh4zTma8ZlMwKTLs?=
 =?us-ascii?Q?KoGcS3Un0cUkr+Sj1Uun/B7BY57dNu8GO0P8jp0HkQmgwPLkHOcYlx0fiS1T?=
 =?us-ascii?Q?PN+JdyIwrcfzH1KqnMAXwiXbT3C1w+i0qmYP+hn3UL6kIYBNy3vyXZDQ6uaN?=
 =?us-ascii?Q?Gr4z1ojzFhhZ/HICaxYf35fYWF7mppdrGgTaGYtVgayVkQL8e9mN5Tr5zdB/?=
 =?us-ascii?Q?CGbUCSi+K6QerqZ7DJHMUo/Qj9Rl6h91dHKp6claP6kxAohj7gqiZJGlrVA8?=
 =?us-ascii?Q?MlCpTc1BW7+AuRcsu5Bp/DQV5BHVwlAHddK/Uq0X3jc/8RqJhc02LfesZQd4?=
 =?us-ascii?Q?PGCnwCBJA3gMGXpud3SPVpiWau+slZu/OTsqjj7DDeoaVvO17v41u5h6Bp7R?=
 =?us-ascii?Q?lO6rnrBvpgyex1USVX2/aqM8Xbt+WhVxXZV3wy9dwP2UdG566ZFyz8RDw0c4?=
 =?us-ascii?Q?Giu39V0o9SWLkLV+LGbK+owlh216SojhqQmh848fWSG9TS/glf1SxRnhmwzl?=
 =?us-ascii?Q?ONcJxUHbqC+H7PEZu/stCP7WVArxvWQhe4IxYVoa4d0lzV+0k4K+PmUHe9I/?=
 =?us-ascii?Q?CjAYb8Yt/Tw9m3H0eRVpcHQU1vpV9Bq190px9TMy585zuTIxzHdQrWOn46FM?=
 =?us-ascii?Q?Hb/mEi4FNOO5Hy3e/tXyZ5/FJjDaaLcSVhK+0bCs4cDWz2OVz5SZZJL1ehpg?=
 =?us-ascii?Q?aQK/nZjX9sqBVJ+svkp5CzH6BR0ZBFAFUfbrsu7GRUZgH4Skoz8trfDhE9N8?=
 =?us-ascii?Q?ajUT1B6Jt3hK94JpoJv292XCJgA4uFVqC+8nFwdJ1QF4M4syndlg6tvJxnhp?=
 =?us-ascii?Q?dAf+AwJYBzn0EDLro2U3SwmrqjGbopaOMoRRVL+54jUWGo2OPKh1E47c2hzt?=
 =?us-ascii?Q?54YebtTKATVpwWEAXLMv4oP/VkET6SMEBKQ2C9nNU35xR7FXzKE50i4TV+dM?=
 =?us-ascii?Q?qobt8Pbzr7vzpKBO5lnw/qsqeaRXVsfXU+pSy2Q32TKmtIH04+xDg6t2FOh5?=
 =?us-ascii?Q?TpGAJjwh2ABtQGJe6ydMr1+78igQ8mOmDOnhIrhbyDOqpPF3r/GpXTT1mcFe?=
 =?us-ascii?Q?P3eQdSU2TuS3o5xTj2FcEoq4m7YxqqEUPFARMY/vEGEoYcqRirYfNv9zETXq?=
 =?us-ascii?Q?tGXrmA6KY1sVkfkBAykfyfCZjkev/hCxiJ2E59fgI5bk0y55AOQVytqqwJpa?=
 =?us-ascii?Q?AGwXzdqktDBzovCdFVz0kmpkg8TJi6Rv30fifKC6rQJg+CzE3+BDSaZU2vlV?=
 =?us-ascii?Q?fFUnbveh3DUk42BvCkTWCZoU9FrIbXleMBzvihWYdzmCrlEc2ilqTQy5xMSB?=
 =?us-ascii?Q?Vk36Q7m/d2aJ1Tvse2DIUtre6JMubq8aALuQ87wBfRRFYiBIKr2F2iFX6Rme?=
 =?us-ascii?Q?5/yTS4277w83vsRLXJnvlT1EpbcNHPtVm43b77suRKbN+0B4z9nMpHwpCCK4?=
 =?us-ascii?Q?1Fs59iVK09MCbwEwPx9W1xsqkgXwW5OEy/kMMKynUjRyK2BE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdfb06b0-fc91-49c5-a779-08de9991c51f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:49.1254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qm6GtJ3gOlxmlxopD18idfiJbnvPZKmk+NKa6mq0erDcYkUjh0+s/sYZVo9n91W/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444

filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
is no longer needed. Remove it.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
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

