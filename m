Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013024.outbound.protection.outlook.com [40.93.196.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2214F37FF42;
	Wed, 29 Apr 2026 15:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476628; cv=fail; b=Ujget7ioZ1zyFhNWvsbHPQO6uJ1qmFUu7avduFDRM4XyzYU3l7f7BGVsbkKN2NE0TmxCVP6BtqQdg7aKGNBMtjh+Jz/wsaqppauQ3+AT/38EWKEPKH8Ce5I52BYGlV8xonQz994nib/u+yOswcmjFcCSCjWaH/STy2AM1kR8Ntw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476628; c=relaxed/simple;
	bh=W+bR99WLDpGWQH3S9b2r5cBgAqLDbWeIPHrFgHHwScA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hF4TzkmNkpuiZWaNUzKGOWLvdq4I9SziTY6z1YfNEuonI4VBx/VBL52sZw5HNEMplum8fW6j/+3/CeVO9+E9hAIBXFrHe0hkwYUsZ7D3HEzzyPTuvB2zD0rLEegEUERfo1s2rSDYvdiZNibh8uEOzNowlYIy0SqOMA8cn7bub8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dZOtrz/J; arc=fail smtp.client-ip=40.93.196.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dZOtrz/J"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=etuZhMA4Rnx9SBIt0qVISUJY2jHDfH0yXTkQoqVVnOoxRUpgUgKG28n/G9YCFX72h+HZ5VAySBSqFa4NvgTfcdxpiwBjaYgR1NR0t40YKfllHnA6FosPFryCiLTbhaA0WWdwkoiYq3sYSzUgQZjC6xUa51C7h4L1Ne5iuu/FKf2g+v+/76Go80dIDE8rP6uvyYGgFIx7+XldWpEdaL307z2BPJ5Pi0pHtlM5rl+Lk3x/bcfqsH1QLsD9SLEw9q8cpdVos+ZGzUaWl1h1Y0JvnnisQMZiqvoiiZgRwkjXikw98sXQNdhrlqywyovt6Kh1egL6dHVoC0EIGD7slHHQrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u14BzMTXOtdjVUVuelexl69vYDmW9ZMAahmapfjiZOE=;
 b=RuUlYNQipEr1wdp021f5SHG9RAZaCmvLSOClODi4/5GeKd3vEMVAu6ZAdJzmn7YKfHeaB4JilwIqCFWoN0VHdD9P/nJwC57q+HiLEsIkMY6GSkCXUel3GxWLmws7EKb+piW9kKkzS+VV7LtWCfCSx5ZUTAxmds4gi9uHZrvmQQly09KGWECTSc7/xtc0z77xSA0QI9qjVeBH080QYq9Pvix15Sfg7SmVtDlL5nmiWsfUffglbuWR7G2zqymwIYfPICi40KYLvlSZbWEBi5SflAls98/iOw7q7iVcOqgS8qp3egLnI+JyBuC15pU37fJaPHOBSGvF7R2oGCKzWQIG1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u14BzMTXOtdjVUVuelexl69vYDmW9ZMAahmapfjiZOE=;
 b=dZOtrz/Jp7rU0uCi2rIVeB8p5TYOtGKW3Oq2HKdw/WwwCGv5Z88qkqQvN0QNW8bI0cxY/QazQV9dRH5QPvS20FkZ5xxsljZQvX8mDDW1g5r1sM0ha4yPdjrPBdyOOfXTWoEbi6RjVyXjK0UBQoLFjLCK1eHCQc9Z79Ncik1SPwDLKM0bERJZ35qvr+5GeJVQs6iW+Bq/j40WAFwQ2er3I+ew1uZIHoFP2h1maNHKsdYGLbvGqx4cQFsyDMEE/h4nl2jKRFLqokO7iwDiiA3abg2QXmS/NEtj8gYb/8USAiAIQogytKHuE0DBu8S6xM+Q+6wymjpLJFMQmk0AqTCKUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PPF12042BF6F.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bc8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Wed, 29 Apr
 2026 15:30:12 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:30:12 +0000
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
Subject: [PATCH v5 01/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Wed, 29 Apr 2026 11:29:11 -0400
Message-ID: <20260429152924.727124-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR06CA0009.namprd06.prod.outlook.com
 (2603:10b6:8:2a::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PPF12042BF6F:EE_
X-MS-Office365-Filtering-Correlation-Id: f329f1e3-cc6a-41ea-c0c1-08dea6043471
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oBeE7Yn24kPgQWmwKMuIosvcKdPLrKHmd6HM/Iut5QTglgsJvEqIy1T8x9RK9ROEojrerjeoQwNEp2PIpvZUiW+mg8SMv/9Z1xDuBtyiPSz127tvcVrNQnXpqdc54t8ZMaJNyyajUSgzDsUZdiH96S3CCSN/Iiq+o3+IGu87w0nVbBODbOqTxdUZdcZf/0Ays3GVN9xk1cKukbVuQ0yrXOrRNNOZXZRm53YaRrKDrwGAaTnViClMaYfv3kDK7KKC44cZFQ7lWa6KmEwEYt6kuBoE9rUYf7v9pVZLUbzHlZEU4dhlyegQKk+R9NQPY9tVvvSImJDAXh7HOIchpCWHlHUsTpTf2G/ZlQvH0djblcmPJmN3pElJRfc7vNEU8EJfHs9X4jpNGnMICTlM2dNJtaL69w1FPgdTw1fMDl5T8Z6RCDCUH15VwNW6XHZO5LHJQDerLAY8dYP4tknujB03q1qmbpeAFJpSTAZOkaQs8wSih+p8t402H8H7tYrmx/b7K6HOyXn0nabGtj02fPSCv0/6TzMxg1Zi3cAWSrzIiB0pwygAfb1kdBTYOhL6zvrd+sX9i5H5N+Fl442Q5FGKwonL5dq27g3shaUVqEhrcr2PQ6BC9oRA4GmSOPmkVciOOx1+M4BrsbrlnN2nj40SuBRcpZgIBKSus1vaT5eNgoKfR05eye4wTx6r9A8Uxkr/7s/KG2h3Fy5Z8b7hCYYT/0vjdds63uYwNQq79AV6GQY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xJVQZkFkj/ecCdCWhwvPFB3rLUsub8huRtX2RzacQYte5nCT7pqwY+cH8eCE?=
 =?us-ascii?Q?bJsEKVh2vIkbMgARuZbh8ZFD8CwmCTaV2M5HysoYYRxyKAJcftL9pkyb0BHQ?=
 =?us-ascii?Q?Jo9pgJF/V0TvS77xts37XZQvqr9EheCrkEhqtmANdSoSjoeL3sry5HxKic7n?=
 =?us-ascii?Q?K7fPgjl1g07eymk2r213zCd7JrvxTr2u5EHSTCWl5infk+htf/snCrPbO+1E?=
 =?us-ascii?Q?EhzTtDXMGeo1f03Iygt5Tbesb3zgft31DS2PASCR4xoNO6tOPp4PZHqXKPpd?=
 =?us-ascii?Q?bl/+BzK/WcDirMsyBxKNi5eI+CWoSekJQr92OJ3K6ebEWeIrF4hPmUPFxhud?=
 =?us-ascii?Q?rhSB218ENNMswOjFMWPujk6wHYFjVz33QmPT7fy/FsQKUHqkceHoGCkI/nD3?=
 =?us-ascii?Q?0zl8cMY5OH08eOAudAZdbCa7Amo5rlOpYmcyNKQ1jQRoZxUnZrnaGeixeAcs?=
 =?us-ascii?Q?yRimRFTQTSQg2JYaZd4/0hHNrkIVzWsXPryF38spPkCkHcL0pi2pNFHWvh7Y?=
 =?us-ascii?Q?Dpuj+oH0XfaV9NueLI13ltcrrIcfRy1s7u4Jhl/Hyc289RnkLaBf7DN5cO/i?=
 =?us-ascii?Q?tjatBGcli+op/oobnPjtTFlPJDG3GnAduTx49hW7l5tkGCDjEY++YQpmvQye?=
 =?us-ascii?Q?9k3PWm8ooIuDWfZP4NVRlt7ury0b2NanLMP68I18kncZOg60GiBiFPI+Hsds?=
 =?us-ascii?Q?7eC8uhASP/gHIHxq7Euhso5WLzkjtVZZY5bq3qGpdmGzRQBr7GydjCOxMvy5?=
 =?us-ascii?Q?FZvSy18aG76XGufpEw38quAwQ1ACpSUNHIuCuF5mzGCblxrmqQ+DVPeaplV9?=
 =?us-ascii?Q?pytNEolAIAl8r4de1bhENkW8WrjS9lSqcNBqVn8Mk96cARThaeSd1JxZnxji?=
 =?us-ascii?Q?EDDvcwTZMf3thVKDv2XXPrN88Aw/VUOuOPvdu1M5v8g/gzgXm+oPPI7YXNV0?=
 =?us-ascii?Q?wZ2hPJvBVMxXcEFsGjtxqbu3vkGMur8iUMtBZx2WK5IrbZR/q4TIcbTr7NkC?=
 =?us-ascii?Q?wjae15WDVZwGJmvvxpNsYuqcqnRB2yItLqFJAHYxW8YchW2JQCPeHJ0tLYNd?=
 =?us-ascii?Q?Gjfe/iRUY8MUzj7hgY+2zGTYkF3oVWwLoUYL5G+ifs/I1Vdx3lKf5L0uOsQG?=
 =?us-ascii?Q?rlBrlcPqNMzfjp7YHvxT/F9OFs8TWBiXer1fhXqKYyorpDDIUupTpy8buRxh?=
 =?us-ascii?Q?KIq7TB/nONBkAwpFkZHdxmPB7fG2Af+y+pTZ3uodI9Arg0k9d+zd3TkcoKnm?=
 =?us-ascii?Q?+6ibCgD+A8pdxV7J/zI/8DnivQvKvzAi9EoqWNWmyW62WavmCHlztUSh+349?=
 =?us-ascii?Q?dFXhX+79fYmiSczitq2TSP/+pzFlWy7ndDJ5nhqWv7s/vUQuOMDG+8upbKVD?=
 =?us-ascii?Q?UZS27GwD6Cv+jB3mdDDjV+DduBtJsxxKcM8RTLui6HgeFMSWYocUK6Rw4orz?=
 =?us-ascii?Q?GAIx8XjNWZO/gXH6ugIbPm4rtZBxCKGNwbhkOAxHOPDQ9lYJzLFYo9xG5cZB?=
 =?us-ascii?Q?U6FwnOx+Udrw9FxunbXd2bLJG/Sa0sXne5wRQ6p31pvlgC+CsMsPWEq6KtrR?=
 =?us-ascii?Q?EEhibib5H+3K73gEp5dG8nDTUJ7YloLTU48UwIa8qAbPhavmqkx+ocVIWfbR?=
 =?us-ascii?Q?qeOYrvJOwhRZkJMrebP/DE/8aLkj+lpR+x0ZtzxFO0RROzlf8DcsfPPSAFUr?=
 =?us-ascii?Q?GWcKKTiGXrf8c0MEEz9Ua0Fifru/5lrRfvNLTqIx3zbbp7f9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f329f1e3-cc6a-41ea-c0c1-08dea6043471
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:30:12.4631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QIOTvo4eKi2R+PJcOCynBHy249Crs1SWu2o8089ASEi3/ccCLXShq92qN3fyMuXL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF12042BF6F

collapse_file() requires FSes supporting large folio with at least
PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.

While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.

Add a helper function mapping_pmd_folio_support() for FSes supporting large
folio with at least PMD_ORDER.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/pagemap.h | 26 ++++++++++++++++++++++++++
 mm/khugepaged.c         | 10 ++++++++--
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 1f50991b43e3b..1fed3414fe9b8 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -513,6 +513,32 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
 	return mapping_max_folio_order(mapping) > 0;
 }
 
+/**
+ * mapping_pmd_folio_support() - Check if a mapping support PMD-sized folio
+ * @mapping: The address_space
+ *
+ * Some file supports large folio but does not support as large as PMD order.
+ * If a PMD-sized pagecache folio is attempted to be created on a filesystem,
+ * this check needs to be performed first.
+ *
+ * Return: true - PMD-sized folio is supported, false - PMD-sized folio is not
+ * supported.
+ */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
+{
+	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
+	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
+
+	return mapping_max_folio_order(mapping) >= PMD_ORDER;
+}
+#else
+static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
+{
+	return false;
+}
+#endif
+
 /* Return the maximum folio size for this pagecache mapping, in bytes. */
 static inline size_t mapping_max_folio_size(const struct address_space *mapping)
 {
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e112525c4aa9c..6808f2b48d864 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2235,8 +2235,14 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
 
-	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
-	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
+	/*
+	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
+	 *
+	 * TODO: once shmem always calls mapping_set_large_folios() on its
+	 * mapping, the shmem check can be removed.
+	 */
+	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
+	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
 
 	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
-- 
2.53.0

