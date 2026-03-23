Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012048.outbound.protection.outlook.com [52.101.43.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585B1337B97;
	Mon, 23 Mar 2026 19:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774292825; cv=fail; b=Yde+AN+jVpX3qXoYp71GIPA5gKltzMQL1wiNLfa0qgfL1ZbDgjENojuWuMZQJAYEs+MqH//PtmG9CJtWKFIqt+9Qtqv/0vmncyKAVhBjwemOdX6la6w5kgaGYP5cbMvRR0cT+66j+29BfaKWN5WPSurXIDoOW15DK9bMyQNSuuA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774292825; c=relaxed/simple;
	bh=IbADcvJG7GeL1QvqXjRQkCuVUjKERLuIEGz+3dgJG9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lQBMg84mmn9V5F/tzf1ihYSywiBfHPjRMEQ+6UgJqf2cPCyQ8h23lLBYv1bwGxTaL4LbCx8PLzRx8bmkTvzmgqiPVK1+GdNuMewsEv++WZaC/nLU20lnQBXIosZpSLr106hhwsf3hnGI8U3YbVKYiiimyWi8HKQgPntWJxwAiKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pFleVGoB; arc=fail smtp.client-ip=52.101.43.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pFleVGoB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ayvcpbzg40k1GCs/vODnm+loT0IBYPKkBXGlvufIDUw60jfo3TLuDf1hoQ0En8sB/CuIbIW4g3c3XGsATQK/h2YMjNYp0PLU6czop5Pp6Zq/YRD62JRdvgBeNaBf43EcLLDgkJ3rXYwBgAvWSm7IEvAuZKJ0Pra3+brye7MB7BCrgRR4ikA2wXajcWASnQtoAr+beEOi5BNYIDDV1JxaVdCOAiEb/WIc6UBmW95MkMF+iZznoL1sjc/2qhJzQfhUsu+PC/W9XTfclyy9XHxhFxKKOrY7gaAPC2MLThGbAsALyOJqAk4U5RwR3lD//aCqeiJiDYoT+8TTHrJwqkoETg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D8O+f7qd9atNjedwWxjNpgH7Bw9TaVnZDnBEr44WoG0=;
 b=JfNheZFZrYHFE8RfdmyKlb7AHj5DowQqlXcpkx6XXtQ7aS+AmodLypa8TK4OpGydPzjfM/y/Ag+uo9Udttzijekc18g4OJJbLT+P2LcxqO0ob+NEgSQn7Jq7Mm/ld2gCaK+tfQ2ETGbuaw2DJcklaHPwrgRoePbuvC8+qWptge05bDb0xTRRNNVNaRt7nNvVHG6fktgVu+MUZ09MqzKLJYdLHmUt49U81I5KQJD5mHqSr8kY2ZUxXlRGkHHFuF8wEa0RaAcyYq9n30R74jvZXTiLPrJ8KDf/OX2zHeUdGdLHCtGGBRcWlXg6TDGVJ7xPPqSNHHh/XdIjY23HwQr9kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8O+f7qd9atNjedwWxjNpgH7Bw9TaVnZDnBEr44WoG0=;
 b=pFleVGoB83iN0p459utRt4ZfnEIW4iwfQRG+Say6uZZyBT3Z1kqxIb3Mf5lMbzn1TlOIi8Xn+jNl+HPOobXkxOykIAAk7Ghj3ntaDH1o1Y/RUw59fc1TMNwuPh2znV7Iu+Fv0tHAGyoWjPepjU0jLgDqQjye09tX987XBAfcMl273oKXr/C3lpEMkBkGM77pt/SB4Kil8IvCMqtLBo88iv30xHnH1SurGHfA4NJhNBUfR2Yu4Gdcgt3RJhWDLoO2TwcOrUhKWOOsE2w8W01p868axRe+koNToj7Y4PZ3Z5myd01KAfMOWpfVVK0SAHUK4IpeUFljISoeJuhnVVrSUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7607.namprd12.prod.outlook.com (2603:10b6:8:13f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Mon, 23 Mar 2026 19:06:58 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:06:58 +0000
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
Subject: [RFC PATCH 07/11] fs: remove nr_thp from struct address_space
Date: Mon, 23 Mar 2026 15:06:40 -0400
Message-ID: <20260323190644.1714379-8-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323190644.1714379-1-ziy@nvidia.com>
References: <20260323190644.1714379-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0029.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7607:EE_
X-MS-Office365-Filtering-Correlation-Id: 43cd01a4-53c2-4593-96f3-08de890f5b46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LKvJi4Fq9sPqjbXB8bxouSBbZSPccPe5FcUMvg/H10UBg3PLb2P8svDslGw46lp0yCVLqOsPGo53uFa8QZQbM7ClcYlU+mXNAco4560famdHI7/gMKfiON9E3cixZVVR1qf2Ais9SXGez9GS50yqPZ8gg0u3sWVuZjvSTV6HwIzJrf/MyOdzfj3de9wWRB1n6VTkAPrW33lSlm2FbBLj7DAn0tnwfyPcAYi7tu4ideG/kyZRG/5bJzenknUPUoCi5k/RiejWVnFWR4zvFDR5XCrlFeOgVc1LlkmPh5pDFV3NoF9RQOKMSoWWXFhPe7Rj48wyasI/bsEE1zegzhLQAMEQZF+OA4nJiOJ8rgKcRo7VcjgxxvtvC06OGoihvHZAw5DzH+biypulNVdtjIa4Dg9yAih9fXqRa7RfUgygkWj8USTQvBE0sEX+bFWJ5/89n6uSN/Qx0KZ8uZ6REkiNEslmWnSGatEqfeougfnpqFh/xpjtjE9nTLr5kD0IM165uPd8+rGkubsqBnDWuBtrqQufdQpyBtAQFotV5ChUWKXR0YI5U8BrxpOA/GHATnOXbegfUs+eeALTbyQNWL00VTOBZsE5/JVzJg+cx+rhXYIDPV6WDa9z/rtJ05z036AULMVYIEvcd+s27V4ucJzpArLXzjzaWzFM+CWOPqFZKM0MRQvf/Of4WvnZKCM0khQo54CBfyjoU8CHvoxhRNBpkzSfYnV5N5dpSw1VixrPwzM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2SF0zAMBWfIE2QCCMbmkPEXZEhD3oKVrtWrmmZbFeKkLjjLO8ocJpAt+FA3j?=
 =?us-ascii?Q?CEAHKJyD8CAhCs4RLKU8CSI+Jrk48HQtpEzqertf4fMwE4HqyOGp5HQCPYo9?=
 =?us-ascii?Q?7sovMlgGp9taHR+KZ4viS5CSprys3zjE3KrWP/gjFJoIGUU07KEBP9MB9DFA?=
 =?us-ascii?Q?WAamXQ2vg6tsaUC52zcwptXrq3jJx+S4ROo/YL/y6w6nzTUcdcEqVDW90uWN?=
 =?us-ascii?Q?K3xUK/AUKaHvuCRBeB9ytRkvh/BHY+Ns4DOFnPIzp7Sp2P9lC5juVJo/lgdS?=
 =?us-ascii?Q?qviP/9fVoNz2KiFhUzcXC7p1uGz+EPJBvVrSCPTIC12asv89HWqir8NjIWId?=
 =?us-ascii?Q?b+yq4mZNWWZEEzWSfK0H9Osx+sPLrd18KvHsGnAODZ6oN6P+wEHCXFPQy36o?=
 =?us-ascii?Q?CnxRnZDf5uRIgahEaJPJGk1XpGQSAAJsrxG1doPTZ1qkRDBemE+81+xQGJT+?=
 =?us-ascii?Q?Pqc8uG0FunBVhyiCGsvVNR10erd+eMh3yEidpyWpFwAuS3gKRMwuEtc/WFfQ?=
 =?us-ascii?Q?v46ywUqv7fJtLbuOcGaw2shuKLBECGG7QDDargfA5vbOE7LNvhXhiEOEZXC4?=
 =?us-ascii?Q?ZIusCLVZksb9vmnnE5WZNyaTwZhXOy2recJK4yxJuGZAFL+dOLEl3E42RoAt?=
 =?us-ascii?Q?6yHymQ/TBF2UhAiYo5+LdHqyhtKjT2YQ8ZuURvAycfqEgK30mzTOp8B6SFDH?=
 =?us-ascii?Q?D0rFn+y/nJlIfz2Jj7OdkqHVMaEAV4Ud93ZL1e727R5LSr7AwAin/7h1TkpP?=
 =?us-ascii?Q?USA2WL3TVIP3D//KhuGXp06GDE5Yt0RhAdznTM/pZmitp/HJ3u2v2wX9fgWq?=
 =?us-ascii?Q?4lRWL/MksPA0pJKECg+aPa9tvTgVtoRLEBzCKe60PZAmazHWCQ5mGrv8IorR?=
 =?us-ascii?Q?liDij+yuA4Ls1alPtq9+rvIMt0oa++fNd4b5MSJklF3eY8AmgbPwR2qcnsTv?=
 =?us-ascii?Q?AP3aNB/wXDNn1WP8s07ANte+hu76rJvmvyHrPamkL4GjL7mq6uBQt5vAVB7v?=
 =?us-ascii?Q?gFoJEJ5nDXFr4ziZ1j6IAIe5jWN84WJ3CxMstjP6RQnSZv6RojCwzRkV8YE6?=
 =?us-ascii?Q?1xMNuMNjiui0IxydWbb5ohGoxacctuDfig2oSausWSMkJ235YLPFLkvdCCFn?=
 =?us-ascii?Q?4SafarYyoA8P60ymwgfUdeS7cJT98V8FX1DYCIi4FMANW+NxHT2ZPf0RRmqM?=
 =?us-ascii?Q?pBqQl7o/YYTLIMhLH+H6kqM/rcdfhr1oGZ/sUWyhxl5dSSXhhrNWmsqY0GNQ?=
 =?us-ascii?Q?saeivxnwVlHHw6qCxep8O8GxkcwY1bnAP7cmqTsGNnZA2CjgDoTjjZopONVA?=
 =?us-ascii?Q?orbZNWruw2qALv1TQxs8ZXAUp0goeDOpWpKUvo4JQUB0uq4sLy6/8yjFfA8D?=
 =?us-ascii?Q?Z+jZYDjC7mBkI1tr0efpuNCgXaFWjHFZhPx6iiTMFLa4wwOtQhJpmjj3evOp?=
 =?us-ascii?Q?AE8spe9x8UVfrLqhTOtfydMZIR7jvR7JO+sktO0B0M+3ZL3kLzGUtn5dutcf?=
 =?us-ascii?Q?O5G4tE6/Qu+BRurxh3ABFDZHFDf5hzlCx7hs6Dz/2Wk7SmTVL5vddSbvxNT5?=
 =?us-ascii?Q?JhuQ2VjMPH9B5EeITy8pf6feRQ2YKyx7bTz5w9ob2uMN7F0kZQWS1tAxnDej?=
 =?us-ascii?Q?hoa1ZHEqs+5hTdXkJMsWo5QsPpUBzMd0dueW4QacOh0ORwBWuxlrQKMfl78H?=
 =?us-ascii?Q?XZmozuAl6pFZsyZqbw2YPW5gsyJzFXmAM7XivcDtLrz4RzUt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43cd01a4-53c2-4593-96f3-08de890f5b46
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:06:58.3231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PLvazqiSA24ZVQ11atMQnscHum1WGeSo0NR+/naBbmY4ZudmlcNelgtDU9xydBBM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7607

READ_ONLY_THP_FOR_FS is removed, the related field is no longer needed.

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

