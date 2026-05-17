Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011051.outbound.protection.outlook.com [52.101.62.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692D33B38A4;
	Sun, 17 May 2026 13:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779026129; cv=fail; b=QisJBV6vq7jKA+7uD+I0oFsFVD5CdQKl7Z8Pn2+970HgOxNGDYzewcLWhEOr1BrrNYF4U60dLl0eTtMaDc62iU65VbS+ocOsfarhtbvjx/rDbkrPfuIXe9qAI3M41Jxhfg3e1HleoLYwm8ML2Xr8m/0mg7DpOucMuKaeiFr0o4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779026129; c=relaxed/simple;
	bh=9RuLDP7GwgXvUQ7e0iqVeW1BdIliPQ3pt/7IYQN+rPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=THOWMjgEDJUkIw2OoCtzdav430ceY1f6MSg3ZFjTVqrVNnHdwN/xEAOvKwqXXNHEZID7tsgx5DAQlBBTVO4pSfX36aeJU+T57e6LIfCHV2wM0ZdQ4vr/+8RJ2f0GNzS4mxJvAxamcKQKMHcJbWbOHJqMR6kRC7bClsnAz22zP0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LBS801IO; arc=fail smtp.client-ip=52.101.62.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LBS801IO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X7iFQ+Z8pkG4aSZMT4pxiYU6H87gbnobdHtGYfa5OeNrDLswxL9686fJ9T91LFe5DP/9cB5WhdlvYPxSwZwZf/tXXRtlPVV0YqxDuvtkMZZ2azKc/pt78p7HgLfgO05x0exDji78xh3NCObH1Ii74FXuN2WdKCBUjrU40h1hRknacMhRhquc6NuQ7xVk29H2p4JjfEmoDKIttZeMgdv7hubajyNMNGh9OLtd7nePoDS4NQjmYXhFXNx1ijZUpmk6M2e0bOXu1T51AWBgHA48phU/Ig9H3kP331dPGXsUxvmzHVEJJwq///L8/C3JyJU3XA2FiYzK+SrOukQkLrjadQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ag5ukcKaPeCQGprlevnjWROuwV1INUUBT3HuYOBV5XA=;
 b=c0Y0jkJe3MVHDuTRBP7luV/K4gjFDHrfXShm266KC8k6JMI46ksS0hnBWs6D/0Rv/Ay+5IS0TzdqITT9mugKN/oZ4CAbSc3BBqGUeFPJewMCfkaLwAQtpJM8FgNlRGL6F3ecdnF8pf0izikzrhlZmBJGXrihZFB6zl/N21ZOZ1/xYOFUSOo898t4b13mkjHwQWKnOpCITHyoXV9oixji8qRJyiKvM/6biyBqGZVu7YScFIwLYpRlRwy6oYyEXhHYLtzrCPUyr3vT1bRdkZ9ZtK2m90LkUJEjfuOc8TT0PkkToLcshJT3v6OUmjTMvEyQnoRKtJA6tWVGDz8fDyawew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ag5ukcKaPeCQGprlevnjWROuwV1INUUBT3HuYOBV5XA=;
 b=LBS801IOCViD/dGnTAcXSX/JKr++URNO6686sQRysGMohvi9479CIDwZeFWzmCdAgvxH3uAYBLH0IyVhuRqVBMpRf5NMzSKSMmQopgkWvAz02kQ/37+GgodcbfudrW4OyqYYlTSYK39DaugYJMHi8PrcCqiCnOFpT8Vkt9aWRTLzAhVqVbS5x7juXjtfUCJYdSxwyiJYHd3AyaMdFcVWkBz5VV4grP7gTEU4oKXYO5yPEZSZpz846BefuUGN+kuYbvHx3FPH7XdhtVmbUY3cGCg6GRyadkeokgdP7r2T+jvlS91ekvpKhzVhUiVfYK12+nS/8rXxYcJK0t2lVOwzrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:14 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:14 +0000
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
Subject: [PATCH v6 13/14] mm/khugepaged: enable clean pagecache folio collapse for writable files
Date: Sun, 17 May 2026 09:54:15 -0400
Message-ID: <20260517135416.1434539-14-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0010.namprd05.prod.outlook.com (2603:10b6:610::23)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: e1661d91-bda0-40fe-b5f2-08deb41beba7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Q0FX/UKZgVjmfXH/663nsW2Tu0Jt4fqN+HmFJgD6chWmEe3aQbl0qlJPg1+21O4tg+L9oufNlIHFH4IFR4czXYe4/9eQZCZsitPprkPiI3SvxEO3j6e43ko13ahKjpdQJi9qViVXJcLJ4UEFq5d7HKve5nXtZ+6q0Yd3IzY8PqD3P21YTev05d7sb/6vIFbB0WO/CfuUJ9EO/Oxx4OtFjnI2OF1fr4B8XKVuDlJmQT5WMZou4nmOtGZAtSwC8y2gbyjXubtF9CQFInS3q5/XLHcJXVNR1agVM5n0RKxdNAdXQJR/6QxAYS24iPlRM0Wp1ewvvyV9YgKLee7he4ixh4AzoLnFI+A2Ecyw4BEfeJlEKN6NCiCr9jxCgPBdrbPBUbzp0+tzlSGsEARQRscr5WaGgP3vj7NHTIavAK8b0RfMaMUhPjTQd1fL6TmhptPCy6UAy+Ebh1++JGe75f0WqQ5EXF0JdPq7X3Z3+YQq3YIzyZEn1VsMD1r07NHHHyr1i0ybPqO0YPbwkET6V+fQriS1mjSNoRMGutKxtAAkMTwZHCUL5iJOQn/FgiX2VI5YtLNnBZqLvCkmN/b+pxRvG2Rn/VJN3h3542DTzb+Ck3WYFLctO3nqPzXqix1Zay5yVIFPgS2eZZJvhyHwCrDBD3wGczT0TZwal39earObRhGipjQW0UVr5OiOJdtDIeEs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6UOAIzZf6E+c1kuQ/NJXStHn4MqYPqcPFJex6Gx21/kKjvPB0YuDRE10EdHf?=
 =?us-ascii?Q?nlJBsEK2SyRiy33MMP6XWJmHjg35nS4e2af5g6qRy3iU0nDGljax709LLKSX?=
 =?us-ascii?Q?W8vr0/knB7294JBhqtNtJJoffJ2H7Jtmkj+kCZu7Abi+CnOsDJJvYrrbXTHE?=
 =?us-ascii?Q?TLAGAxAsW921Bjx23NS2S8TdmOXq200gOQeoLHN/XXMF+Oz5t/J+ynbjG1aQ?=
 =?us-ascii?Q?XqvcOy6jEp47heViFuxM29AT88l6PbQxlX6HJ5rvatn9AegCmptRaIXD/CrU?=
 =?us-ascii?Q?6CK69LeT8oWqj4ElzUysC7P81p9MfCQUholK60kmPum/h9ECXes4UkswBIu9?=
 =?us-ascii?Q?KnlafYnWI5TV2aDi9c2HmprNope7dR5F0qYzGPfk61Uxwa+mYjGBiWgnH75w?=
 =?us-ascii?Q?zcTr1+VkfUoaDbOeqnuvKALBCcrBd+JmUtYxd3KPuAHvUnBkZjsbaMF8oMB6?=
 =?us-ascii?Q?jrODC81NLcsQlenjR9m6fmVIxVoE6Hd6RXn6ZzU5qAAqvToTp9wObIABGuHH?=
 =?us-ascii?Q?Pm87RkV7bbOtF/FsFR1EtkvtRE6NPcXRHZXYKdllgnT/5+iVToWKJ36KKDcB?=
 =?us-ascii?Q?anHhCrxv/A1IB6qzP0t4Vo9uDk6xc3lRB7JyuZaP64BP8aIHa2sG7jbWyq7J?=
 =?us-ascii?Q?NanmQcn5vZYrhqRFhO9CVaM2GttY8cor0aU8snXNDnDB1ob1s013JitiF/mP?=
 =?us-ascii?Q?uqm6PrRfwNJKsMLgElqBE2lA9W73fi5fOx8HWsSB5onVmPMkNgDNhpn1Oldu?=
 =?us-ascii?Q?4qwBEWvErqrXwJNdQQPzYPVIE6p717izFiiDUAQwoUuzs6Hv6hqQKA9NvHWD?=
 =?us-ascii?Q?ANciQw06WsFgxcapWZEbZF2fZerlpEg8A3iqD6V1v12UIkZBSHIea7jgPI9R?=
 =?us-ascii?Q?7GBawK/maoDsluo3FgYeD61PzdmwAA4J7JbTev2u2mP9xmcr7VCP5bK9y8kx?=
 =?us-ascii?Q?u7XhEi3HNHQbrzKKzoiy6Q0ADeqvN+JStyA7q3GzPdLQQgRGlLZ/hvPNOeTE?=
 =?us-ascii?Q?QhvjRUUQY/Pw6WbF9qUY899Cp7iYwmkUCCo2yBFJFHOMVC9wgS37j4LkxA1p?=
 =?us-ascii?Q?hxB+SEVtAWVVSs6heHqJMq6MJpHU5cG0pXuRWpJF2lwKBS/rzswJVGawUvhZ?=
 =?us-ascii?Q?Rv70uFBEdd/PwtrJ87DGbYZnFvRlj2Ck6EQa4J8zds/r8LAOQEGfsyGiKE1D?=
 =?us-ascii?Q?91Lw1dntGspYve8Xom1XrizPWZ0uK2+UH0RZaAKN5D7bXY2EKyIoRdlXKdgV?=
 =?us-ascii?Q?3LCE8kGwrKHAGKYeauEAhdYJlgSjZwc+wpmRITgGP61R3xhLguZFi3BgYlJh?=
 =?us-ascii?Q?c86/DXV+vUXpGdTsRNuxJOCprD2GVq+HQijfKDHDoTndVa9KyWj2xnJTu/gg?=
 =?us-ascii?Q?WsXSWLS2ulpcwMdgb11s3Q+H0RRPTcv+Pk2PPTCYq+Gh0O+6DpSGTyZf/x/2?=
 =?us-ascii?Q?q8t6yHt2Xj2NJOsXZ0GeDbHFqRYxIn8alTS2QcW3xBL0+qNjHUutt8qO5JSO?=
 =?us-ascii?Q?oAiUEW88Bsm/+rXvRWZzU8govXGgKolYGazpGWlS/wuC4O24RR1ppmtyiqrZ?=
 =?us-ascii?Q?o6OwfAu2J/opAuxSa0EVVkmH5QMabXvIZuby4BOrlzQNDYFIhQ7g0V0L4UuQ?=
 =?us-ascii?Q?mbw6VvrpYiXs/72L2vBGlLlGb4IbFL+RyqVAv/E3n0rsBKs719i9cAUfvX4W?=
 =?us-ascii?Q?TzF9MI4sANTZVBK/67CmGJ8HHr+u6OpQW88igkUZbFp9ckKv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1661d91-bda0-40fe-b5f2-08deb41beba7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:14.4901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mvo6jS/II+ukXWuepIvT+nJQIe5NcWvTuD9NrzBDiWiK+tMUXElHNB53YiAhMOpz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322

collapse_file() is capable of collapsing pagecache folios from writable
files to PMD folios.  Now enable clean pagecache folio collapse in
addition to read-only pagecache folio collapse by removing the
inode_is_open_for_write() from file_thp_enabled() and only performing
filemap_flush() if the file is read-only.

This means userspace needs to explicitly flush the content of pagecache
folios before khugepaged can collapse the folios, or use
madvise(MADV_COLLAPSE), which does the flush in the retry.  The reason is
that blindly enabling dirty pagecache folio from writable files collapse
makes khugepaged flush these folios all the time.  It is undesirable to
cause system level pagecache flushes.

To properly support dirty pagecache folio collapse, filemap_flush() needs
to be avoided.  Potentially, merging associated buffer instead of dropping
it with filemap_release_folio() might be needed.

NOTE: this breaks khugepaged selftests for writable file pagecache
collapse, which is set to fail all the time.  The next commit fixes it.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---
 mm/huge_memory.c |  2 +-
 mm/khugepaged.c  | 15 +++++++++------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d055f53be8502..c565b2a651e06 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -97,7 +97,7 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))
 		return false;
 
-	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
+	return S_ISREG(inode->i_mode);
 }
 
 /* If returns true, we are unable to access the VMA's folios. */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c743ec41a7b8b..395c40c24dbc5 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2342,18 +2342,21 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			} else if (folio_test_dirty(folio)) {
 				/*
 				 * This page is dirty because it hasn't
-				 * been flushed since first write. There
-				 * won't be new dirty pages.
+				 * been flushed since first write.
 				 *
-				 * Trigger async flush here and hope the
-				 * writeback is done when khugepaged
-				 * revisits this page.
+				 * Trigger async flush for read-only files and
+				 * hope the writeback is done when khugepaged
+				 * revisits this page. Writable files can have
+				 * their folios dirty at any time; blindly
+				 * flushing them would cause undesirable
+				 * system-wide writeback.
 				 *
 				 * This is a one-off situation. We are not
 				 * forcing writeback in loop.
 				 */
 				xas_unlock_irq(&xas);
-				filemap_flush(mapping);
+				if (!inode_is_open_for_write(mapping->host))
+					filemap_flush(mapping);
 				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 				goto xa_unlocked;
 			} else if (folio_test_writeback(folio)) {
-- 
2.53.0

