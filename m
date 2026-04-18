Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011029.outbound.protection.outlook.com [40.93.194.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA93331A6E;
	Sat, 18 Apr 2026 02:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776480294; cv=fail; b=ep8o4yAqWIN7mYEgMxjXp3QPQiL4gtUeElWlQVQFWuvbjUU2OaBTxhjZbbFeCT5+M+MA9TovkUV1nwkhj5CW9XVByDwmKSO/8yF2TDt9eNEnbyW2PpLLBKrigIBmvbSGbH9n4L6WW5efu8fExmF/0Xe941snEUBYasfDnzRYnHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776480294; c=relaxed/simple;
	bh=4LFjaYbsvjloysTEybfjXD9Q05sP/8VpfUIoHZDiA5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RinA/f4oqmsPvIpzGyNke04yx97xolbiodDD3OzOY7XmjPO0MAoa6ZNjr6EQCfZFZwZouq5UVvZynKPHrMT6z7YeGOdgjDhUQTwtjZtUq5xmhZmTmAbKiLG0a/MjShwMBQtffjlzlw0VE6x/g8I7gP+lPEe1W1AZoz8k11ubFFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uXB7joPH; arc=fail smtp.client-ip=40.93.194.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uXB7joPH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pd6QuTKH8bsSklsex/al9Q4h6ZMDJ/cqarROsCE31bPvopkWxgYaiKrSQ5A60iQvOrZQL1DNSoICZ54nbEcxenFmJrckyGIaoXkr8WDAlUojzdR6cbRQ9NLDyzoTorAGBCZpiXPoBoMJ/Fnp05ypu84B5cJUP384H30tIOetsp0CkWZddznOT+cE7Qb5fhXfxNldMWWdbO74sOo8yMpIUep1pW2yj5SVdOqZvAXZBb/LVBvzJdOhR7q+yNMqK5u4CNFKuUJKocne8oGENIx2EaAINOHxw6W8Nz7raESKHNfE19VSz6T1+WLNU2SVsPy5sDEu9BFbVnj5PGs9Uug9Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnlnaP8b4VVDCFdGJn3Fuf32eVk9FmQJ0OYvzW8/xjU=;
 b=ctHPMMnNdr3d04JGNz9c5V8KtE1TTAWzrRWJX7cfB7lp7PCeRYrI0plbZzD2dfjNX9mrCErny4z3C+sMqdSyfE9PeT7EP+wISA8H4usvy9KxUA8AalHWWy2tgbfCQ+YZvrKzkT1s8vZW8RYZjLI0yDhxm8hQcYvXRLi3Ux6RPeK1P4nmXB2Cgy2+SX0r8W5/uNyndlZ/vzLmdWGj2qltdTiaKy+RFPka89SpH4pjW4/rsiZoLrkS6m/jDALy9pQn2a3AhSH9aPYIxACntbzfDXU1Mg79SEta7oCHZ7OO5ZwuHmwh/JGjas7f6cAoYNgf/xIVCT67oAqlSJD5lH4CGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnlnaP8b4VVDCFdGJn3Fuf32eVk9FmQJ0OYvzW8/xjU=;
 b=uXB7joPHE40VU/m+7xeMbzvqRmlSR9MRAd6fpEyAxrBMBu3PXiJ/vllocClVfHQeYrwU71UE8sQghEUp48b6ARS4rJt0bh+7YLahZHo5mqYRI3ToiopexKMBMOEAGs9PR8Iznbh06EsQXy5FUaFfl8urKpQj+E1BIKWF74iNoJdgMr0mscguTAKPY6OmBCHi7vMHcwDLc1jWSMfoki/U2jbmWQ00VBM/0ajxl68lLeRjp42FIu2d9iRMa/ZSadBo65VDMcFc2Mg6o9yyyQ5YK/CC+TMuiGT6mq4HniLXy8jQzJU6GfmpadtVD2Sw7TMti7hE6F9zK1x+iF5vzbVStA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Sat, 18 Apr
 2026 02:44:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Sat, 18 Apr 2026
 02:44:40 +0000
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
Subject: [PATCH 7.2 v3 04/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in hugepage_pmd_enabled()
Date: Fri, 17 Apr 2026 22:44:21 -0400
Message-ID: <20260418024429.4055056-5-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418024429.4055056-1-ziy@nvidia.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0003.namprd18.prod.outlook.com
 (2603:10b6:208:23c::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a448dd2-9429-4ad5-7001-08de9cf46f27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Pqn+ojz7jEp0L2YNR24ADuXbLgI9/xy/GSOmvPhXzzMEr2GLV1mXK7OsVsmbQBxWkS0WM+foA1aH0KLjRntvPddZIoZeyWsRKfE5cFp6V7DxN9rTs8ZHMQ6ARhNk56Pp7NsNz+13SeLpEbC0Gqpk/T/RvkH5zNhjRho957fBbl3o0lNXMTCeTDFpXtkP2G9TrEBJ9hdea2mNd5JN0UXnFO5juA9RmwtoXxT3nkkR+EMfcVzzXE3opHcpU8U69o1JgKAoP7joK0AzvmPOa7cVX76LEyOcGeuJEqwGrKd+m6S9Mz137TqQjsZnwwIpop3GvNCxkKNMZiFGpswgrsZEXxCEKnYAEDS440f8ONJ+15xKjbCAo6JmBoUq8+9SXseK0CViMhbTLjWwQK5UvWpkd6KwkroZ4SK9xfEgBA+WokvLy95l1DyI9DBxN/lISGKVksemdjpcu0mHphPvnv1BNzrzwRwP0iezXQfOOneLH1SVaR55b7RoIJvE37LbabzFFX+95WwMCFfJTywjH0s/HMVgwQ+X1ScIhQ7uzXAY/Zj4Yky3LVvSXXFKWsV6K1+38SXaR+G5qwMz9Le+tbK44pv1TEkHu4L3OxOIZw43bjZAQ1ZR4p4zJN/LOWxkP8dnwoFB4g3zv4KURm7no3ibRaiwIsqzrzcY8D9PiDc0teri1T6uRLtNgvOYA5WDKwxkEJZm03oO7zO+FWhRZ8OczqrHBjq2jN2ZhiTLxk4drwo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xukUgXGHHZmspi6Rf33izUj6sF5WIZfYCgAvO4M+VvDLMXzTgebSoawwQ77J?=
 =?us-ascii?Q?QqBCK+1rU4S+TpVaqdX/NULoI7yqNU/UCCcb8YEfQhor0tRm0Fxn7fGjp4+j?=
 =?us-ascii?Q?dQVDUl0xx1QDIn4eASlmTo3zhAoC/GSm8Wx7sgsmPDqkzKkyWsjfXrTgpAJ+?=
 =?us-ascii?Q?sDloS2vLm5gsMR5vLzCRfBxsPlGv61YlJMf++OigIbcpNdi7W1a9W+O3b5Qm?=
 =?us-ascii?Q?EhCwG1PZlNZciiy9TMkEw5MXiSO8xafL9BHxn5ZX0KzrP5oDg8OwvjpOKr+N?=
 =?us-ascii?Q?3ZFY2Z57HN23JtobCwjh4o9Fac4za/Xd5Wh41fMZcXVPGilxSBxXQLOMJGXU?=
 =?us-ascii?Q?GtkmfqYFpqTr3hv/qogFY2Cs9DS7zapAe3hPs6zrFLWAFkhutZZlgsNSrQgK?=
 =?us-ascii?Q?lQJKiMJVeVETTiWWqoqK3yB9n+wjHlvXBtLJWL8m5ih3hMbAo/vqtdC/Zmg9?=
 =?us-ascii?Q?jAeMb8xOYQ2vRxzsqgwpBE3IqsK9zQIZoWkGN2PuGFBbWnD9bSx4cfCU29CM?=
 =?us-ascii?Q?uMQmoBuwJz4kcHRALKt+b3SNPlEET9L3YRKE75qwyXnGH2zIIeLPsA1rHUar?=
 =?us-ascii?Q?SbLsPjI5U0NaE5owN3KoSeTscdm5gy1Ze/AjxXOZepAjnUF6aQWX8Z23zCqP?=
 =?us-ascii?Q?rxyHuKo0w7AUY5dK1PuzGj9oGL21sb97P1RUrggnUnLM2+WSdgnDU0oegZcR?=
 =?us-ascii?Q?5UFKstETTl/E3oKAn5383nOmkzZb7CBcw9lw3mJn9mcYKjoJJRQSQuv4WIrc?=
 =?us-ascii?Q?ouqbeqtenPQjgEChy48tDqUHqADhXwhajE4V613PR6HsAbEKnfe0n+/ogjWg?=
 =?us-ascii?Q?bogkcWVDVLmJgFl+ZkBJlMz9NwrBjqL+K/Teq5Yn3hcRCLZDAqeIzJLfazXt?=
 =?us-ascii?Q?ZkwBsDt1dNajUWWf71XLtXcF2tgQPmapeabOUSElDZOsIbkOio6f4yexVK0K?=
 =?us-ascii?Q?+1ONlP4KvikTn71PllLRHFGl/5ke1yxgBIeitbkxPLTRR99sybDkLcPrwmfU?=
 =?us-ascii?Q?jceOl/8Eyf3Na9dMC34V94RgVI0HnEuc61Ij9vW5KP2pEClv9KpDpK5jNUF/?=
 =?us-ascii?Q?ft9tXQYVlVz86O/cIRWH3IptuVue+wMAmU28Hti+yd/r1Szp9QI+w4K8o2DF?=
 =?us-ascii?Q?0541rG3/NSmZFy5jm6nFgky2a64t/5EtZfcAUlCrKULxKaErBzrX02yFncnu?=
 =?us-ascii?Q?LIrhjg7y/mx8PHf70ZH3KzyyG812jDKbVHCtSbPHYg8JDgFEL1sqzuzSqPik?=
 =?us-ascii?Q?m4VhPxNdwa/xfMcA+u/xT4vOvw+/X3nrzYJJ521xHskZn2a6ld5cIe2Vu3Cq?=
 =?us-ascii?Q?mjn/8f5mjoD8mUEtlUJBM9A4J5w5EHpOFu9ubf3H18pMockvp5Oiu9aP78o6?=
 =?us-ascii?Q?kkdF1wk5Kwg3mAy4c6YE/iwUc/KH2C3YHoaN6ug3mqsVrbavmuaQSVX9Zqcr?=
 =?us-ascii?Q?aGB5Z+0w2KFvuDnveAu3Y14OjdEy8KTcREClxZjEmRd8JXXvEbusZbJOiCwf?=
 =?us-ascii?Q?+9sDYHhU3jVRRdsbodox4erP2LfZe3NwTZB5kuFqoD3vKDYr6nXUvbUQgIjU?=
 =?us-ascii?Q?TJOHT6aMlOBX0OCfcjbCNxuMzR052A9l/RMjxb0YMU9gjJ02R4r4/ViReAnr?=
 =?us-ascii?Q?C2y9F7jsV7NlxEylvfWvkAapGhEx+TDcjv76Z0lU9xUp1ZZlga/Kp4cdThUT?=
 =?us-ascii?Q?vWGiXDcMg38TGGkoOU0ZMi/VgfvaixOtRSuyJiv91ONNZ10D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a448dd2-9429-4ad5-7001-08de9cf46f27
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2026 02:44:38.5124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xEfU9Aq3P5bxulXAMUE+LhsF5l8hMbif9AQWl11suIsfGdnsOPg9MAs8EkFX+Pgq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650

Remove READ_ONLY_THP_FOR_FS and khugepaged for file-backed pmd-sized
hugepages are enabled by the global transparent hugepage control.
khugepaged can still be enabled by per-size control for anon and shmem when
the global control is off.

Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
IS_ENABLED(SHMEM) in hugepage_pmd_enabled().

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/shmem_fs.h |  2 +-
 mm/khugepaged.c          | 28 ++++++++++++++++------------
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 1a345142af7d..dff8fb6ddac0 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -127,7 +127,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
 int shmem_unuse(unsigned int type);
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				loff_t write_end, bool shmem_huge_force);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1c0fdc81d276..718a2d06d1e6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -406,18 +406,8 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
-static bool hugepage_pmd_enabled(void)
+static inline bool anon_hpage_pmd_enabled(void)
 {
-	/*
-	 * We cover the anon, shmem and the file-backed case here; file-backed
-	 * hugepages, when configured in, are determined by the global control.
-	 * Anon pmd-sized hugepages are determined by the pmd-size control.
-	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
-	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
-	 */
-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	    hugepage_global_enabled())
-		return true;
 	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
 		return true;
 	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
@@ -425,7 +415,21 @@ static bool hugepage_pmd_enabled(void)
 	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
 	    hugepage_global_enabled())
 		return true;
-	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
+	return false;
+}
+
+static bool hugepage_pmd_enabled(void)
+{
+	/*
+	 * Anon, shmem and file-backed pmd-size hugepages are all determined by
+	 * the global control. If the global control is off, anon and shmem
+	 * pmd-sized hugepages are also determined by its per-size control.
+	 */
+	if (hugepage_global_enabled())
+		return true;
+	if (anon_hpage_pmd_enabled())
+		return true;
+	if (shmem_hpage_pmd_enabled())
 		return true;
 	return false;
 }
-- 
2.43.0

