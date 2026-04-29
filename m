Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013024.outbound.protection.outlook.com [40.93.196.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A9B37996C;
	Wed, 29 Apr 2026 15:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476626; cv=fail; b=LY6MU1bHnM3DNS4cM8oo9BXemKX5L9jL65cbyNUJzVe3O3uF+UNN9VM9kBD5HMSqPJdoUGZsAFz2bV08umkXlKZR4SD4+mLG/zoMzngD6GhZXVabE9HybPn/CsADm7PzefNsckbKR89vqToRw5u43yPrMfjP0vz+sOoca6dP1qg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476626; c=relaxed/simple;
	bh=ee2WXpDWsioZKjNm4khCaYOqY4Yn0E/b+TR3U8931xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TCCDnQilU0jLQcszw+8ICV+wBJzxmYM9NNzPWLQGmgsjdxSu5RHEf68il3LsCISRoDGgD1cTdVxWGPJ0iuo9w8YnPMuL3EtUyrbirbt1+cBRTsv7+M8OlYq+WEDnzMSHMNJdODxlYgimv6lbDSD7isHtfI7AOD+x9uHhg/oGgRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S46o80z1; arc=fail smtp.client-ip=40.93.196.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S46o80z1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rR/5Qk/DcDT/X8h/JGQ37xL9lTS4RnkbNAZKlB6OkUus+dRx7Vgjli+b+yqu5UQPZKqpo4WaWP0FCoaLlU2kTGAHC1IXaCFCxCeVvu6TIcdoC2eKCQyXVvIBJvefuHo/1lHtDRC8RitiSxUw8E+uGJnl6oGlRqFi//rM6A0dH8MBOTfn07PfAfREjaJV6wOAHhXMOM6UrsZTlgC2Nf8GCcJpbl+SRLLPAD1Zu/lKUJzrk37M8c7zhTNs+qPE6TOma/GM/KD9Hm4Btx+8AVYv9qKT3a+/lY41KHGypzvzjmwa7bG8wpSIjK3wrU2pu6/jldPklt2Mr4B56lu/OEpzZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2U3MyOyb+/8Mesc45GpQY1PCKVga32ujGRMCwkcZtas=;
 b=FCzYY8g4VGKhK1KfZ7FJ709xhKBo17bUvvqHlNNe3m73y6/MVEjEedm8imgdHuktIuDSuAIIW9jI6RHP0REzIMvY8wVbLvh2DvOzffsd0w0UAkqOIzkg/t4kTw78Dw/GqmUA8WhgYyBclh42ISxKU9VGRDbbn8+xoPdJAs2e50og2be5ZJN8wISJ6adXNn7/xNsvRRMa7dvnwphGNw/uVAbyYmwjOqvMdwEtJosh5bbs2KOq2CDChRWkCTAmhacqZQyT9VKU8zE8MTjXgaDrTCY9uIWoc1roc55fALRBtJcMGi6I/h31j4g4VVbQ0jMXxOZuWb7qsj7RCP+yKxRLmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2U3MyOyb+/8Mesc45GpQY1PCKVga32ujGRMCwkcZtas=;
 b=S46o80z1CkTzl7QSrHeUFclU4ksZtKC2DAQ23/+vUvP2yYHlW8LuT6CUPJmfPkzIH1BVaUjDBWStZAjHCf0sezY104K2vYRvlfrDZDYH8OPTHj3pAe/9Q0MQa/CO/bUBeI3mKWg+L2PG4wFGBfKJkZQ66Emucb3HXJllGYcnT1WuV8PkoQv548GCpwXcHkjbPZEo0Z47gi/eTV9lQWnTp1zyyesFiia0Nbj53J4kGVOUqPr6Qr8X2HL0z6x7GjnfdDPr/S25tovOjfNaRzzsP9JpS2zpyndYsixy3Ianl5vmxCsgYo0MJ4eJjnHWUlZuFzYE7aB9w3tIbK/yakZaVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PPF12042BF6F.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bc8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Wed, 29 Apr
 2026 15:30:15 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:30:15 +0000
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
Subject: [PATCH v5 02/14] mm/khugepaged: add folio dirty check after try_to_unmap()
Date: Wed, 29 Apr 2026 11:29:12 -0400
Message-ID: <20260429152924.727124-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0108.namprd04.prod.outlook.com
 (2603:10b6:408:ec::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PPF12042BF6F:EE_
X-MS-Office365-Filtering-Correlation-Id: 08203d36-d65e-4943-47ce-08dea604356a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	1dFO+nlXxpWWlT1YsZn7M4WCT2tcwcajYgaU8fTIi0sZCWC4wXKC7XQ85+z7JbGdKwnnaLSlkfnAsLtObnbIhvCYwJhqwWBeDV11DJzXjVhceyHEA762zEvb8RY7KaTidloxbpI5M9AQPZZIKYi++iRK1fj+Z0SoNzuVjg5zaOA43HMQCO9actgKld1xN0XkZL5A+qsoMCVOyfOvPCdsuZHsyuvoh/j+0tT8ydI6RghF4J+RTW4BdA1wVmkjJBqrpgmEhF+X2LYt1R+C0jnBYGKbh+pN9AWO0VEZJc4xbTru0nPSA9TYwllwgWNvr+GuSNzWet+Q7I2jCMkcajvjvPx3MZAYPpWELsSY9FbdvgWClF/2m5ip2Baj7tMmgcB2jCH27KSRfRisZRsipxjyodtR4F/0BKebUAUUByWOEzBPtqOmomru+2nuRVb4xsstj/SezCTDQ0Q7IVxRgkHouz/kp6jawXUqNFgO8UGLR//KylLS+ljk8NHv3F/tCIegfa4h5nEzbgHiOI7BS7Wd6yPI9TTEuDGWtRvVgPguHo4rvheF2kXiU72UdroAuwwc2hA5cauf4xe0fm24AD/xsY5mpYIbJ1Hho5So8SfZrBDQoKKEPwU0PPT4+uvMrf5gbXwyJXaDFKk52UoauOqJjaLQJUqlOrTcqYn5YQ/WodHxFoEuZJOQiXdxigcfgl/xvQWaTFXkfXV3z7FKQo2cYOIw+MojikDcakJKieKFmbQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LloPMyzjXTEeHhCZWn+PA3zHHWvREQWLUvGNbxK6cETYBTzCGuAVMlQUKFSU?=
 =?us-ascii?Q?9LCZ6RzGYTs+1H+0PETY/klTImibm1fxg01o4okOZM6aDUGO3mDwMYwkM/lJ?=
 =?us-ascii?Q?VjWXEjgHdsO6M33CtyS7TciUDYfp65l1Bh9j+gxgs6R45pFsLC0IKs+FW4ca?=
 =?us-ascii?Q?t8dUI/ammkUmwyuevovxWxtLCo0ApPJvphfPUxdJ5Jv+UoXvWbkNv+T2g8oS?=
 =?us-ascii?Q?1rmfqTzOeRqJW/WPBBoKq5TSs1sa6TJCQtXLuIwHebswdZhS9QTkdiEmenIt?=
 =?us-ascii?Q?fUhxqbPZwtOzNd178Xj7yNrfwkmEqJI5XRXgMV1h7uNm+tgDZu6B5mKGheFs?=
 =?us-ascii?Q?FQ8wCFUZeMhQFrJ0RfeQDY9PQgdUfDYVsSl7IKkdCB9y+DnlChLXv3xJNU/H?=
 =?us-ascii?Q?4reZs2Lwc+NK2LQ1iXKx6qijIGdPOQXhNLvFQ+ytr9xXRoQxLGBLD3nl65bZ?=
 =?us-ascii?Q?/4eEyCmADrRtHDJMBRN8Cndv8/9EKtm7KJpH6mOd0bnRaLWMm2FaxBp/KVI4?=
 =?us-ascii?Q?27mvrkuVs64ENn1HBzeD5Es4VTCUqEVt3BTUaxQNUWYcWdGGzutOBzhrXmnv?=
 =?us-ascii?Q?kULNzY8uuGcuTfBfq8ZEHe2L3nO/2SsAnSAXP2TfwK9LLkGcoB6FknZkeKmc?=
 =?us-ascii?Q?AjHWefaf7iHMMZOvJsIHuGF9r0XtyFlRg7LHP/Ia4/5UqhVQfzUR9mtfsi5Q?=
 =?us-ascii?Q?NYJBJJmikoeC0oP5Li/EtCWKvcj48i7RhC0TvHBICEEXYEAybg33XAV3YagI?=
 =?us-ascii?Q?QDU3oaDYsak2X4Gm0MtsT0xLifsDrKRGa/JjvP4f8n4+RqqHo+1jTQEwvfxm?=
 =?us-ascii?Q?x+L10ai9TLTIanBpthbZXRQlZjurjBJ2MAdlxXqVyfg3pRtDvnLVqDehlZNa?=
 =?us-ascii?Q?E+ihf1z6HtL+XHoyx9Vgv9oOArz+XhIM6U7z8ZoOCjfel9hc1lPKCI6T7y5W?=
 =?us-ascii?Q?XyiNfnO12b8rkfql1CxPE3fpxRC6khd9kej3tjmDyB8z+VqEarJREZtstamB?=
 =?us-ascii?Q?NBXW5OUZnTEH6/gfS4MM+cF8Jm9VvYGjXM4XzKG/QHYKHwdYndT8wWp6WHbj?=
 =?us-ascii?Q?bR6BcQgPh6plFRYM6dHygRf5KWNu8j18NUle+isQ/CKwO4MgbiHpJngiJrjO?=
 =?us-ascii?Q?aODsIufuULhu6QrA3h+JXtPHGiaw2WKY/rvE7yuY4WcXjcIPzMQ/xbfWknUd?=
 =?us-ascii?Q?W3FnPMXIs+Ljz8iPq6hViXR/VXiyFrLzr/NL3kXh7gDNL+5ESGiLk8xXATTL?=
 =?us-ascii?Q?nMFKPIHZBXOGvFrYMpRx+/RN2Rb6Qj0M716p9zzCD/Wu29ARrLeboFwbV3qH?=
 =?us-ascii?Q?BBsteDTZl5wG7y58gETNmLK+00t6XZpEKr0k8mHsh6rdYTSV0j4VoEVFF5Bw?=
 =?us-ascii?Q?/Ie6zDtTwu0X5T5qkEZiIy8v5tMThXSnvB/83m4kLkf0xhfNT8sEOILy84Ca?=
 =?us-ascii?Q?al6tHgt7U8sPeboqqhuNyXfMJUJEexzWagU4r5aamvV8QUDFARjejLPuJIr1?=
 =?us-ascii?Q?1LbZOY51YUrCB9nTLSOFbXQNAkU5iB9MDhVCjriShb0ILgX5EBaEBzN9yQX2?=
 =?us-ascii?Q?XK67TaPW4PIp+vhIrPyBMkn3ZtDBfrAN+O5J7F0CMT3M6ycy2xyH5ygWzppB?=
 =?us-ascii?Q?OgASr8WPHkK8LYCqGYMR4qMx0MLUCCDF0lmRA27bVMYTLwilygsLzatgoKZs?=
 =?us-ascii?Q?kfgh/r9cL2+pemNGdykGbkYY5Pl+ZXvPJb+jLr/p0bCk6Gkz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08203d36-d65e-4943-47ce-08dea604356a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:30:14.0369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U78LTz8WpnH3LaTCBS5/JKxz+CWHUibcwQGl6YQ/vC0a9xPO/SKo/h1AmHajHY+P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF12042BF6F

This check ensures the correctness of read-only PMD folio collapse
after it is enabled for all FSes supporting PMD pagecache folios and
replaces READ_ONLY_THP_FOR_FS.

READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
and inode->i_writecount to prevent any write to read-only to-be-collapsed
folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
aforementioned mechanism will go away too. To ensure khugepaged functions
as expected after the changes, skip if any folio is dirty after
try_to_unmap(), since a dirty folio at that point means this read-only
folio can get writes between try_to_unmap() and try_to_unmap_flush() via
cached TLB entries and khugepaged does not support writable pagecache folio
collapse yet.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/khugepaged.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6808f2b48d864..71209a72195ab 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2327,8 +2327,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 				}
 			} else if (folio_test_dirty(folio)) {
 				/*
-				 * khugepaged only works on read-only fd,
-				 * so this page is dirty because it hasn't
+				 * This page is dirty because it hasn't
 				 * been flushed since first write. There
 				 * won't be new dirty pages.
 				 *
@@ -2386,8 +2385,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		if (!is_shmem && (folio_test_dirty(folio) ||
 				  folio_test_writeback(folio))) {
 			/*
-			 * khugepaged only works on read-only fd, so this
-			 * folio is dirty because it hasn't been flushed
+			 * khugepaged only works on clean file-backed folios,
+			 * so this folio is dirty because it hasn't been flushed
 			 * since first write.
 			 */
 			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
@@ -2431,6 +2430,27 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			goto out_unlock;
 		}
 
+		/*
+		 * At this point, the folio is locked and unmapped. If the PTE
+		 * was dirty, try_to_unmap() has transferred the dirty bit to
+		 * the folio and we must not collapse it into a clean
+		 * file-backed folio.
+		 *
+		 * If the folio is clean here, no one can write it until we
+		 * drop the folio lock. A write through a stale TLB entry came
+		 * from a clean PTE and must fault because the PTE has been
+		 * cleared; the fault path has to take the folio lock before
+		 * installing a writable mapping. Buffered write paths also
+		 * have to take the folio lock before modifying file contents
+		 * without a mapping, typically via write_begin_get_folio().
+		 */
+		if (!is_shmem && folio_test_dirty(folio)) {
+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+			xas_unlock_irq(&xas);
+			folio_putback_lru(folio);
+			goto out_unlock;
+		}
+
 		/*
 		 * Accumulate the folios that are being collapsed.
 		 */
-- 
2.53.0

