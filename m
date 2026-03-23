Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010065.outbound.protection.outlook.com [52.101.193.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABA332BF5D;
	Mon, 23 Mar 2026 19:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774292821; cv=fail; b=n4aLv2b4CADI1/S2/HZNqgiYpx+gASKxDuZcymiGO7NmM3wZ8u3UJJ+ZQ5OWc4Wn1JQttmvLqm/6Ei35lLeasP5OJdbl9xFUqPcOHTuIha4fy3gSaEe4wrW7ymw4lb3hAZEVPZbFcF7/p6iRRDoBMlL9CmCIKBQf4Ztud8NDTtY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774292821; c=relaxed/simple;
	bh=1Am4cw50bH6DZpQZCPajuZeg0E6MTF7HXNnr7WHx9Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MYWjfsxRxFJLX0EDsdFJ0wVKetyX5Wwwgy8JtsS9DiVIdYl09g3B6GXYWYwiRDbdJLditV+/tenl3K3ivDl+mQvMTAildZbfHfy/n5etL4ukpzz/DzrbntV0cc/JrtrDox61qQ2QK3RTmKs84l4Scm7Tf+TjtZlV36AAjSaB2nE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JNPp2Tyb; arc=fail smtp.client-ip=52.101.193.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JNPp2Tyb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gXdCTxReQoHDW7l56a0C6pNw8L1AM6KShGlu68H4QMTMP+mBDxV3/2HwhHxBjBJZOzEVAc87j+PNk+vQnLRigpx2juVhIuBwvlyZHRnh3IeJcOU27NTke4qTILXiEzN8KryS3LLL+8PYqzLprUbH51+V7xrSXbpSFvNhGKnvchHxKcnoAIUAa7QV0cWQ+5H2Fic7Gn2hqq0635NHA/J9WWtr046yUHish7hNJfMLsTUAxIdlca858TDstRa6j0doT2C+XIprpmRT4EwplEDtG+Bfw6+JEgyOTfN4dTc2KHofJ80dZ5snPxSv3Bor8RvK2wgyDPWi9QygIDtpmCAMoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKVZq+48ENzpu/a5GNrU8VvF93DyOtGyWGCG0/fa254=;
 b=pHEKCKJuSEILyKDQ092yzGAh51aVRpgiaRbe+lE5sOo/L6TLGPq+nN4S7lb5H7N143r/7QJAbGr3k9QKHvmeJS5iR94YvUQd3WMzSY08o3auSQXYKjsvTY1sSteuULoOEeuBwpM4u7lE9VoGB9OqeDjXR2672cQAcEn2MfIfkntVNUaRe7AJdYY1PUJZpMLPlLhC+h9gQWVYizUQiNACAjHbXaaTiOcVDrOoftOauYQRhK7qOErEc+3qWfU//43kWVkpF+Hq2Rirbhv+mukpPL7qWMMqxLSFURzuFkV0bNJ7mqIfn4IINoqaqquuMy2TvR4oih3oo2h3JYK98VOIbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKVZq+48ENzpu/a5GNrU8VvF93DyOtGyWGCG0/fa254=;
 b=JNPp2TybszR+535x5Gk2WKMyH9/BWdzTesOvZ6ficXsEHQGwslvPN+GmRYh8KLVdzrCr51K5lda0BKG6n4Z6mBXX5hQGsI317dACxijnf8RqFXJiXSGH59FK/89FGn8GKyWjqKq1UcDp+7NmxcgToKhjOvA/wjqLYV53ragLkjaAVlw03LLWJzF80HTLgSqa5nur34KTogwhU/lniuz+VJC8TW//10nPpmbqzwZ9cRKiJ8Ol6PI2Edg8FI8M+p5kcWQU6lsjbyg49IVJlSyruc1TPevV1aFBSwLTaJJvpW5cGWDVSiwJCLLYRVYkCzESAn8cjb9HCgITL0lgBeiudg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 19:06:52 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:06:52 +0000
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
Subject: [RFC PATCH 02/11] mm/khugepaged: remove READ_ONLY_THP_FOR_FS code in collapse_file()
Date: Mon, 23 Mar 2026 15:06:35 -0400
Message-ID: <20260323190644.1714379-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323190644.1714379-1-ziy@nvidia.com>
References: <20260323190644.1714379-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0078.namprd03.prod.outlook.com
 (2603:10b6:208:329::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: 91c85a81-71b5-45d6-a4a3-08de890f5713
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	OEkd6IQizMIexP1q5J5eIOL+Qs9lKtwIfjMeXaCVOUYciIYmxUmTHUP/gYfJ/09v9mzbKa8gBUi8ukMes0jh1n3fi+ysOtsYPPb54mbzxFQtpj627y8+elm+CxXTIf1S/PFLW7GHCxVXh3dVGWddSrZpWzdMWy8cgJZq8IIBl+42tEGbkR05WnlnrmOp12IiTnnMhZa07WgtBM3YdrGgKljE4dQ5Y8lPJ3bIbNomaNlCLTHZ0vBIedWs7WzdjMjSrgKDpvc2FocOZzBgJWRq1WBUCasDX2xls3+pwzXGqmJg8Pqu0kllrRPOp4ppGXibVz29dyvnH4kQfDVcadP2IZyZa1ISNR0A1J5uDoTn083fRT4wkaiQSSZ4zhCAGROZ2yW/MhIaikU2lGk6lwvumGsO/oqV4Fv6UXxGV1Fdd//mKFp5p0fVoLuvxQ9i40AFLz0+naqOz4rOTtNpACHWaOSfScVHDsJUbZ3WXRH56NHC5spq063zKVQpaDGSH2uU5fIoeoEm8JBuV2W5nNFi1sUXhecweP4AzNWFMVcwZtaa3nSFTqlhOmyUoszX28b7w4Sg800MfYmYTmEwlyI7fTbSYOk3bh8DVexNi4tzh33h5ZRqI25l6sMV31plrJ+WjrgnW81c7TFQtWLlPTvqoi1a6hoju/GrWrFkYnTZ07D2xurXqJsiAcStWor1zXQ5HXDc1oZmno1QAdaB7NXNybRHSIgiJvTYyfLvIIiGkDw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HU6xeB7ENeYBpAtx/PfKfFMGPhQJmILT+5CQKPdfEXCqoEGeqsed69mjuoHy?=
 =?us-ascii?Q?jsQkJxUqNPnGB91/Eur1MYZs1dQyTikoDcXCjf3J3Zqt4Ql1JJYkVwUGlhwE?=
 =?us-ascii?Q?EqSmoiZY2luxxHvuRT5350lt/BbGJ7D5Y9ZABcrMkR2qW+EmWKAu7wAso1no?=
 =?us-ascii?Q?V5SmpkFuhXtK3G3ZVEUbqTrJuTGbVPVMmYtg37lxOTjm3SqIyVfZnV18/a+E?=
 =?us-ascii?Q?szPDdAnQyKSvKww78IRfOS1SYxR5TO+y0hBdL6txT4ITSma3KbF4hHqVnxg9?=
 =?us-ascii?Q?3+A1bhE+jN2mHwL3KXRAV+mE9F3wA94ZBpj54xMnO02nLf4FXk4LYSdgWf66?=
 =?us-ascii?Q?/ObqmXf+RA54f7SL7YD7n++ZiHgjYDUTwjxMUFRaPDnEhnqcdJIieRfcBKYy?=
 =?us-ascii?Q?LWwy6fDTaK+vyeDL3R1zbdk041hZBTxJyNYFdt/jNaXmtXf7haA40rgoRE0U?=
 =?us-ascii?Q?PW5I5mZQfxyws1khXrMIK2AsfXm1xQ4eLFn6ozC32ZW7RLeapFrQlcz6Jb2q?=
 =?us-ascii?Q?k34lgkD0Pok893uIo1t7brTa4s2dTG1mQmJu7aDW5Vcc3GO/e6PC2NgoT45j?=
 =?us-ascii?Q?pWh3gkOnpf8I6Co2BJJL91h2nkxYovxK0CHxtqzaYXtNYe+gL8WEYBzfv3kG?=
 =?us-ascii?Q?cQxKjnAi/idikb9ECwlsKgYluzNRGw9/7eZbIE8NDb5vJgUJ39QYd6/JtYfF?=
 =?us-ascii?Q?0PA6TYseCMgU6rSe8GWv0P4ItPT3dzFHFnSIIJqAGJqB8cKzcScHWbIlBEOe?=
 =?us-ascii?Q?98BHUke1cDqwYLCs2sZHIbhg0LGbUPd27+YKYmpc0zCBPz+43zZW/gimLwlP?=
 =?us-ascii?Q?Y5OfsOfZsz5KpN7GF9ncFpnX2ICEVzTRTXnGLUNPUN0bVFffk+oA0EQkMXyg?=
 =?us-ascii?Q?oDUOOmIkR0gEaWX3PRf4PrQZseq8JjBMbjeoiOo/MOGUEYqdkTh1yPUI/1JE?=
 =?us-ascii?Q?2ZEbuTAsHtpGpGuVQT+oa83iEDQbPSCLnzDN8jl2UMl3NBZhOxBSxBndY4Tx?=
 =?us-ascii?Q?vNbCMX992PGQ7PjMCH5SdaU9FJ12U+T1W/6Ow5wIBy4MxK+4YygMb13xw5rS?=
 =?us-ascii?Q?Dj5eUpzc+ZHbvEwAQxztQfCanslmUCJqSIWN6hnb3GJ7DvpJDWu+Tlc20EUL?=
 =?us-ascii?Q?1N11c/Oi0Z3gDAJmPFC4teT06Sc0gu0bDEtrhkmggaCiAhdatCYXH//eZNw3?=
 =?us-ascii?Q?0/By4KErUad7UQMxoD6ZyCYnIfOe/F/HgofcyMyeyt3u+tw/v/gxIrm4cCbJ?=
 =?us-ascii?Q?NsBIBSosuEEdbJMQ9DRZ8WaNyeru0Jo+fW1zq9wACMnZhKPM88x1spJTBFpf?=
 =?us-ascii?Q?wDglI6Qmj+407V6oZ2OKf1sGg3gQN9DstRHn5KRc44mfNJyQ+quvWa/l38YS?=
 =?us-ascii?Q?LCqaBBOJbMJT41oY5Km688aRnff4kTalTETdW13wkSHcB+7lVtcIKcZkcEHP?=
 =?us-ascii?Q?nczMJ2fu51G/cOfV0Sh1+dKzh53Bf3JcqLDYMKuq91DCOWOuvCVDTziDaq6b?=
 =?us-ascii?Q?1nrAmO0JAxUIj20VKjAdXz+ccf0hcoqoVyrzao20oXR4XhOCwcPNkUtyY6dK?=
 =?us-ascii?Q?eCXUlEl9pbVWatV/nrbu/bLn5n7bpOPlBa3ofHVOYsSNcoFaymrvsiqTkH4t?=
 =?us-ascii?Q?v+dJY7zxEEuaCbQoytmmArZ/CSICUUGnQCGAsxbXV97xNVLNl9V2dYVe3B5Y?=
 =?us-ascii?Q?M302fQj1XATaVvhpum7dq98z2InKvF8iaPJucKgK7A4L/pNq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c85a81-71b5-45d6-a4a3-08de890f5713
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:06:51.2921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xvBFF2/KqUyXtN6zHq+PHvph9/fqkEiK2AGwDlCSKxCjoDRjV8fczrIULGI/JbV6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813

READ_ONLY_THP_FOR_FS is no longer present, remove corresponding code.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/khugepaged.c | 159 +++++++++++-------------------------------------
 1 file changed, 34 insertions(+), 125 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b2ac28ddd480..39f0b8959535 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1899,7 +1899,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
 
-	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
+	VM_WARN_ON_ONCE(!is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
 
 	result = alloc_charge_folio(&new_folio, mm, cc);
@@ -1909,8 +1909,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	mapping_set_update(&xas, mapping);
 
 	__folio_set_locked(new_folio);
-	if (is_shmem)
-		__folio_set_swapbacked(new_folio);
+	__folio_set_swapbacked(new_folio);
 	new_folio->index = start;
 	new_folio->mapping = mapping;
 
@@ -1935,83 +1934,39 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		folio = xas_load(&xas);
 
 		VM_BUG_ON(index != xas.xa_index);
-		if (is_shmem) {
-			if (!folio) {
-				/*
-				 * Stop if extent has been truncated or
-				 * hole-punched, and is now completely
-				 * empty.
-				 */
-				if (index == start) {
-					if (!xas_next_entry(&xas, end - 1)) {
-						result = SCAN_TRUNCATED;
-						goto xa_locked;
-					}
+		if (!folio) {
+			/*
+			 * Stop if extent has been truncated or
+			 * hole-punched, and is now completely
+			 * empty.
+			 */
+			if (index == start) {
+				if (!xas_next_entry(&xas, end - 1)) {
+					result = SCAN_TRUNCATED;
+					goto xa_locked;
 				}
-				nr_none++;
-				index++;
-				continue;
 			}
+			nr_none++;
+			index++;
+			continue;
+		}
 
-			if (xa_is_value(folio) || !folio_test_uptodate(folio)) {
-				xas_unlock_irq(&xas);
-				/* swap in or instantiate fallocated page */
-				if (shmem_get_folio(mapping->host, index, 0,
-						&folio, SGP_NOALLOC)) {
-					result = SCAN_FAIL;
-					goto xa_unlocked;
-				}
-				/* drain lru cache to help folio_isolate_lru() */
-				lru_add_drain();
-			} else if (folio_trylock(folio)) {
-				folio_get(folio);
-				xas_unlock_irq(&xas);
-			} else {
-				result = SCAN_PAGE_LOCK;
-				goto xa_locked;
-			}
-		} else {	/* !is_shmem */
-			if (!folio || xa_is_value(folio)) {
-				xas_unlock_irq(&xas);
-				page_cache_sync_readahead(mapping, &file->f_ra,
-							  file, index,
-							  end - index);
-				/* drain lru cache to help folio_isolate_lru() */
-				lru_add_drain();
-				folio = filemap_lock_folio(mapping, index);
-				if (IS_ERR(folio)) {
-					result = SCAN_FAIL;
-					goto xa_unlocked;
-				}
-			} else if (folio_test_dirty(folio)) {
-				/*
-				 * khugepaged only works on read-only fd,
-				 * so this page is dirty because it hasn't
-				 * been flushed since first write. There
-				 * won't be new dirty pages.
-				 *
-				 * Trigger async flush here and hope the
-				 * writeback is done when khugepaged
-				 * revisits this page.
-				 *
-				 * This is a one-off situation. We are not
-				 * forcing writeback in loop.
-				 */
-				xas_unlock_irq(&xas);
-				filemap_flush(mapping);
-				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
-				goto xa_unlocked;
-			} else if (folio_test_writeback(folio)) {
-				xas_unlock_irq(&xas);
-				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+		if (xa_is_value(folio) || !folio_test_uptodate(folio)) {
+			xas_unlock_irq(&xas);
+			/* swap in or instantiate fallocated page */
+			if (shmem_get_folio(mapping->host, index, 0,
+					&folio, SGP_NOALLOC)) {
+				result = SCAN_FAIL;
 				goto xa_unlocked;
-			} else if (folio_trylock(folio)) {
-				folio_get(folio);
-				xas_unlock_irq(&xas);
-			} else {
-				result = SCAN_PAGE_LOCK;
-				goto xa_locked;
 			}
+			/* drain lru cache to help folio_isolate_lru() */
+			lru_add_drain();
+		} else if (folio_trylock(folio)) {
+			folio_get(folio);
+			xas_unlock_irq(&xas);
+		} else {
+			result = SCAN_PAGE_LOCK;
+			goto xa_locked;
 		}
 
 		/*
@@ -2041,17 +1996,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			goto out_unlock;
 		}
 
-		if (!is_shmem && (folio_test_dirty(folio) ||
-				  folio_test_writeback(folio))) {
-			/*
-			 * khugepaged only works on read-only fd, so this
-			 * folio is dirty because it hasn't been flushed
-			 * since first write.
-			 */
-			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
-			goto out_unlock;
-		}
-
 		if (!folio_isolate_lru(folio)) {
 			result = SCAN_DEL_PAGE_LRU;
 			goto out_unlock;
@@ -2101,21 +2045,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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
@@ -2224,12 +2153,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		xas_lock_irq(&xas);
 	}
 
-	if (is_shmem) {
-		lruvec_stat_mod_folio(new_folio, NR_SHMEM, HPAGE_PMD_NR);
-		lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
-	} else {
-		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
-	}
+	lruvec_stat_mod_folio(new_folio, NR_SHMEM, HPAGE_PMD_NR);
+	lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
 	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, HPAGE_PMD_NR);
 
 	/*
@@ -2240,8 +2165,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	folio_mark_uptodate(new_folio);
 	folio_ref_add(new_folio, HPAGE_PMD_NR - 1);
 
-	if (is_shmem)
-		folio_mark_dirty(new_folio);
+	folio_mark_dirty(new_folio);
 	folio_add_lru(new_folio);
 
 	/* Join all the small entries into a single multi-index entry. */
@@ -2266,9 +2190,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		list_del(&folio->lru);
 		lruvec_stat_mod_folio(folio, NR_FILE_PAGES,
 				      -folio_nr_pages(folio));
-		if (is_shmem)
-			lruvec_stat_mod_folio(folio, NR_SHMEM,
-					      -folio_nr_pages(folio));
+		lruvec_stat_mod_folio(folio, NR_SHMEM, -folio_nr_pages(folio));
 		folio->mapping = NULL;
 		folio_clear_active(folio);
 		folio_clear_unevictable(folio);
@@ -2293,19 +2215,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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

