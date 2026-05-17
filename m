Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011051.outbound.protection.outlook.com [52.101.62.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2348B27603F;
	Sun, 17 May 2026 13:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779026108; cv=fail; b=hLnWYozifcsNGQeecFpg+sN59+z6WxxTMtkDL7quuIxKfteCRBE1D0gobeXhs0scpPAeo3BB8TPwh/jwgvLoMrexFw7BKslexEEWVF7Ap6ZvkvwH4Img7dDD27RoD+NI1tapPKFEM1V7g4jIP5yqjO8cSX9B5oytiZacCsLdfi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779026108; c=relaxed/simple;
	bh=bXzvUCUR3MQqI2N1R6TzfyBRhD0MsASdjAzXUZraWLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k8Nkonv+tdiGQGvPBJ00lxb+oU6DNWoFWM3WUkf6ycuUSF9cp57Pn+UmiwfuRsdAEKEbzNPOdlxRsKY/yLUtlSqzjA4v1msgD2I16jViuxfolzeBJt4L+DKYX357SlTTFTKDUm49ulOBwU7atrUdocZs6JgxoKbuar7tkZZFq3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UwrHRd03; arc=fail smtp.client-ip=52.101.62.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UwrHRd03"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BuKK7TqALBKTVC9CtVqwQnbN+IsMtIQvd4zTVedbiiovFRtL+96OvIr3GLqr+Gp4u+7kQtnCIfUeScFCwxASppgRHIUsbjakWR53Qe7fG89Jkr5DVW8hPxubat4XDyBmmIHLwgcVAAKSLId0ZYoBZJOFTGiQGr/x98U7Iu9i695y8x97knRJZEsP2SVfk2ArhKWDDPtUESx/4cjA34Yg5Koae7iJ503ZnXhcwNBZSI9YKbWMZPO7e4+nbu7Uxi17LtnkizXVdd2pG8pj/7OtRxb7FPR8tZ0xYEOTA2kRKb8F1pTIPoh+cbavF+I0tqM+FcvsdNviAex50rgfGNPbRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wdAnhhGQCKtP6uLscReKzuaq4q+Z4vegDXV1Vf0PZ7o=;
 b=annlrUpN7sBpe7SNXwW5ODf1agPtfNv8dsEjcHwd2sxeWEcHU0lzDj3eGiXnfWAGl2ZRvN0z6yHe0dk4eAj+FfjBWi2uVJ71TaYqKeiLO2gk+n0Vx5LND3YLpWbYqhntW38BkBpgsor51s4+fmxL7WmbfjG7fzUPQpMTBjAD2W8MzJSV+EVOmiUMhq2vteStm6l1GVDCIT1mzpXr75/PR5mhH0jaOp5jYw0D7H2J0UG9o6wW9oblYZsJlnwbapMJxzLrM6jmc1j6qwX13mCzRsKCUc4EF0t+qq+TdQzzWxMGk2nWQdMEyzCaxOjcp11IgMoflQOyHZgKAM2s7ogyXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdAnhhGQCKtP6uLscReKzuaq4q+Z4vegDXV1Vf0PZ7o=;
 b=UwrHRd03bHAOABnlCPv0mDwy0zNTYR5Qiff1zCc0g9EXrx4kDVCeIV7yMg7e+Q0lpBzJjcv7dARfBxpPB0CRtUG7GHA8sGC5uNZzFshRJYf9CqwhiGUIHSSTMZ5kxUsec+DNGRlZpUiCjYpHzRFX1acIoz9AWv9tVMhaFUMyw9OXzw13UfgYEi7a08pxyB1/AucJvfwB5SivRvsmlFAGeHnirj8VK5Ax4Eycb26ldbZYikIXkR7vGX+PduWhBWqOh/kFyxrN9zCf3NyVzIM2HQScAaS97hnBKCh8iI04Y8C0Kat28yfafKr0olYmNlEvwK8eBj1x0Ri24OWEz4leyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:54:59 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:54:59 +0000
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
Subject: [PATCH v6 01/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Sun, 17 May 2026 09:54:03 -0400
Message-ID: <20260517135416.1434539-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0385.namprd03.prod.outlook.com
 (2603:10b6:610:119::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: c341083b-62b8-4e14-54ca-08deb41be296
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Ws2rKf3W3TfW20eQSYF3GHDGM8dvUQ7Fvobk35xEQ21STycC7cpqFuqEI3jzqMsrGOS0kJWKtEK8qQOOQfvp58uHu/2uF139FOyNWwm6GQ1NH8MWg5mXWv/pF7LWwH3j3qIFMRcYIItq/7os/Xcvv+zi0kSc7HKkGcAI/zQhbE5KHcNeOnB1f6lVhyh9vQ9MZNABUCrREicgzAD5ZaB+mwKjcx28KCGMuzHNUbXajs4rO6rvgpAvE5k4WlQTIROChnXNKTFCUSEzriIRIBhh3gvroI1+Y4DGovSnj3ltNVfiOtI3i5YB9TyolXU9kGmzPzKaWlDHBrLVrh7urgI/bowVPVsnR9qWZiuqMT9D9j5Hj8xXdjVSVDI35D2JZI6BEoQQq5cPdnCL0mqVuJylJIAjXs6iKCQH4v2JmMYJodZGQMxiOvJfh62NaGchvcEi/y0CqaUvfHgYiTQjjlpvMg/QWAHW2PeiQilPrtiqxjupQAv+PvdqJhFKnQaFBXn6o6N4UTJiq5g/IOLAmqiCbU2xV1bSF7qDA07fpOfvIm4wVKSYVXaLTOplXMAsaDt60S5tfFTv3/qEsI84axEVTciZYL+S6MBIm7q0x81NWhEYPfAmwcy5EjioxAEsdnSVlkfE3h1872SoRJt0l0ETHJw/Y8Uqt4ftgCT14ElCripzOFvpEBA2JfBYqIG0t9bT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S61YaOWcXFBa+pqSFBSt0BXaQ6S4JVBLDCiUtzaIC0aBIoWg7Zmf1EueN2Xj?=
 =?us-ascii?Q?+KxCEsMWsZo89nM5XWp9fPLkso29gz+Bb/QWWPjtUk96OE+iW04MH97i9auo?=
 =?us-ascii?Q?sjKvy32Bl/eJhSxJLqFOC5GPsnxdGVZrBL7JYIER5x+Uzjd/SiuMWlT85iri?=
 =?us-ascii?Q?CqHkpR4oJcUuA+y5birRFuqdLeeKZVcfkTHVq5pBxSNTDq/WNvqivGzpYT+q?=
 =?us-ascii?Q?ONPXEM7nRFXIpRdI/uiQM5K+hVCO7JjvETEq5KhuhZ6n8J8sWwpzXqXXCU64?=
 =?us-ascii?Q?VOKINo7RcW/OKIC5wz53GYbzE3GRrhaeOEy9BKkERbblyvO0P2qoqby34YCx?=
 =?us-ascii?Q?5BMKAQFJXGSJtZbIcT6VODZTk5DnnTffFoykS77rD7jeQ7YzNjm391SCtFsY?=
 =?us-ascii?Q?lDug6AHsI1e8E7RaN6yb8A94t5AZNzMRoeTKXo6BqaNblOzCaPOJt+nFuwpk?=
 =?us-ascii?Q?5mtqnXOK0eP8ZRiZa2+2SSLKIMwtdUKrBmd4dHyvkcK57ubp5jT2QihfZE74?=
 =?us-ascii?Q?JUhf+roVRUcAaVvGqds40qKR/E+D3N8yQHrfBI1Zynu88KXOM89Nx/GswfiQ?=
 =?us-ascii?Q?ZBUYzpUgdn+zgrA+FoogO99zheiEqVELGXdCM7oAnyXHJsW3LpEVTXo7wK4l?=
 =?us-ascii?Q?alWxruGu3gr/5u95KbvntVeiEiZIab99njrMIw7NsfMS77/4GNFFgj3Gtzl8?=
 =?us-ascii?Q?D69N0Cb6WXSxeIuhDtRI0vS0WAoEz3p5FCot+wOh7fqEqI61+oHceou8LCgA?=
 =?us-ascii?Q?4ZSEGIVdGGFuNOCoPc84iW6anwjVWCaitH4N/ttHHhWOsfHcB1DRR/AMMcbN?=
 =?us-ascii?Q?TmfIPN5rBbKFpAJwVXajJf0zAXt+HKNLe7rYO3CtFGRDEgsGRld2s5YySC/B?=
 =?us-ascii?Q?3SXaIC+nxNu/ikF++Ur0LNLYHbUp/lrMIY/mZ8kId5kOvhoDg5OpyMT94v/7?=
 =?us-ascii?Q?wQKLQRK2LSmde+x9+jIQ7xbpCDlWmetGcApUZy8l0/JKVq2W2WQH9WN4jeZI?=
 =?us-ascii?Q?pwL5S8ekxxv+UpY7fRof3m+YGgA8dRjspLP+sw7wQeQz5Ii+Pra5fULNGkNI?=
 =?us-ascii?Q?D9vNTJsrreuWKp6idaYC6vwPMhLsK/nl4OlGJIm0bztD+nmein4pDKJTAgbD?=
 =?us-ascii?Q?mYmcuIxCPrh8Bp4zIkfumdSZAwVZihMIWUpBOiiAyv3bYs/6QrYjcpG6KBDW?=
 =?us-ascii?Q?8ECXN+5ENvWcY7lt4nBHrRXopYxwCeOL13WJtwufJz+NKWDjjBdc3oLesuFs?=
 =?us-ascii?Q?vm+jyuAiuGDBBECOMEJkrR8yh0FwiIQndeQBuyhgCiMBJjGF/E6ToTcPlyFG?=
 =?us-ascii?Q?vp4GT3IHL6qhY1VoJuqK9zHceEgA+6rr54AHejdwMzhEOE4XOyELwQnp4Mjp?=
 =?us-ascii?Q?2sXCSvC+LM2z3oEuZX6dzBMObXfvRF72Bphd5oN+wDgopG/SWQKAgPqsYR8x?=
 =?us-ascii?Q?Yo4QF+JYg3IxZJ8Bwjwx4zmOph3K43EP2JeyxcyoNVZlIZS8TmnaFqpJyHnr?=
 =?us-ascii?Q?vaKEDnEpNO4dMk8TB34FMyT9sROarvTelLJtPS3GrBqIkCDj38XNR2yGQzAC?=
 =?us-ascii?Q?qafe4xySkScoyN212TxrAh7R6tbotR7EHG6wGap/bkY79TKEbeCKTtH3h9TN?=
 =?us-ascii?Q?9LOVemW2wS3c1P/+wmYuBO5d0rfXf9fhVOxXlBZoaMGEZG4Xoypoq/5KyIwD?=
 =?us-ascii?Q?4JfnfwnEG5pqsbHySeyH9qC9eTu8gWy+lk4YsLJvEcjJxbK8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c341083b-62b8-4e14-54ca-08deb41be296
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:54:59.2546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GEJULxnCZ+uU6CVvrTx+WILr6UnH8MV8+5i1dJc+8eIrYpSGk5kHw20M2BoJKi+X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322

collapse_file() requires FSes supporting large folio with at least
PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.

While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.

Add a helper function mapping_pmd_folio_support() for FSes supporting
large folio with at least PMD_ORDER.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---
 include/linux/pagemap.h | 27 +++++++++++++++++++++++++++
 mm/khugepaged.c         | 10 ++++++++--
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 1f50991b43e3b..308d846531d03 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -513,6 +513,33 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
 	return mapping_max_folio_order(mapping) > 0;
 }
 
+/**
+ * mapping_pmd_folio_support() - Check if a mapping supports PMD-sized folio
+ * @mapping: The address_space
+ *
+ * While some mappings support large folios, they might not support PMD-sized
+ * folios. This function checks whether a mapping supports PMD-sized folios.
+ * For example, khugepaged needs this information before attempting to
+ * collapsing THPs.
+ *
+ * Return: True if PMD-sized folios are supported, otherwise false.
+ */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
+{
+	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
+	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
+
+	return mapping_min_folio_order(mapping) <= PMD_ORDER &&
+	       mapping_max_folio_order(mapping) >= PMD_ORDER;
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
index 5ba298d420b74..afd61168d915c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2243,8 +2243,14 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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

