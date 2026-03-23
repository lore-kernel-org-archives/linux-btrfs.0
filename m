Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010065.outbound.protection.outlook.com [52.101.193.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB2B335066;
	Mon, 23 Mar 2026 19:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774292823; cv=fail; b=GBqItWc+4O6eDV0XSXqTDq+oWNq1JT9r7whz6HuB/hcanbnIPpAnt9DPKGf3ygu4MSpTFMAaup13CtyldtqqL4scrYnFMWcCu8MW2Dzv8H0m6CVqdHjkwp0S8U+KWjHIfq6zQsh1EeN0QjkcS7EyqItB9rH55gteWpaQTUawY94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774292823; c=relaxed/simple;
	bh=xzP6dnYNKCaAPYd6qDH6qxU/Q9M//j/Fd8Y2O7pyUMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kH+FSumks7J5pd4quusWmQHtCpuAXB5mq2mZFuMXlxNvKiVQnRAeNsq0o7MfwHtIYjT+kcb/jXSYidI80KfWIMRw7O/cuDDqU87XYBQnV43cIPT3MuXF6Bw+kuUKKqWYMe/xzKVu0gkSk1glsXnJGb8JTjs+V4BpAIvUvan2d5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D5BMohQF; arc=fail smtp.client-ip=52.101.193.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D5BMohQF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gbhrpS4RP5mSP1kcYxwyUnecEBXnIece5MD2T8J3dVo6KSgDNWz2TNfwSWgduXgjWsYJRS1+/G/KDR7bLj+BWyoEhFSeQF3vqJbNSB6N/k1icwBhd1cAW1gpt4oACo5eLxlXeXi4CEVhRhF+fwlPpESZefh4kXpY9S6qFqUQKh0HWbtIVUtbtz1BhR4aaaSThci+tsaoUWIG+nVWpcQjrM1gJB50/NUJejioWbU0j40htQkBmHzK8FnBO6aVSbJntxByaaeke0E/W9/iasci9Li/Z8UceR82iUJJpf6rMMS0KaAWPIj0YauMpci5oMYc7B5VRjse3PsHoeFr1s8psg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LHR1TMF7RnPBJKP58PdFFFmtsYveJ2teBIQQDxcTryY=;
 b=w8mpkHdaHtBKK9PpZg0W1yTOEQvRvdhLAomsjq/b8WlygB/rARE77ZHePjXCgKH9+F8QI1FYOfydAxrfPjvlasgxBbsO2uPckU3rorRJir1hVwQNKCTxjI2EMvxHMwLzO+D6GnrFPtlAoxCjPh5O7j56BAXcGTDgtR9fCTVWFpQFpD0gvVXPwhC8QHwfKfRIyonctp+1YOVcoM7zMJL+p02WVl2Zk4F5AoO7rm6142KPfRJINgFTj/0tg+WMBAcv2Dpx/5rCbIRgtDJJrO6hPlsO6l1kBOVAmaD1OSwUjYYE+/NGNQcWEvvPBFHQtTO0KI/U38Ld+H8s6xk0I0ph+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LHR1TMF7RnPBJKP58PdFFFmtsYveJ2teBIQQDxcTryY=;
 b=D5BMohQF5eO5MrHAQaOx756FuIu1qX0TDYi50zuVRnkqyjJtwbPapOCqg/Go6gggSTDXVIzWO8r6Hv8kJ07HAJJg6pDzgeStqibh2YiqS05RQ9nwgKbfGY8EuGEK0UJ7+ge1j4pf59m6BPjV6SpS52lUF1JieOOyuSJGRnEW9GwOSFHQhGR6k6EZwY6Kp/hFZOwfWGOoZm8PppN2xKVIUoZUPiSn102Vk9LyU7slmPujxsbxx08NsuRp6F5D8iq97zlZ9ngs/+aw+bPAx8D5fMuzB0zDZw86TtWbPJMLsPcxSG85KpSUgxYvizOsAaYYHu1EKJQWdXYCIBNoIGDweA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 19:06:54 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:06:54 +0000
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
Subject: [RFC PATCH 04/11] mm/huge_memory: remove file_thp_enabled() and its caller.
Date: Mon, 23 Mar 2026 15:06:37 -0400
Message-ID: <20260323190644.1714379-5-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323190644.1714379-1-ziy@nvidia.com>
References: <20260323190644.1714379-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:208:d4::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: f6bbf14d-e605-49d9-9698-08de890f58b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	VKkLhW7BshBjUn53ZwItXttGhgiyXmczVdF5GGxb1ePuBVJjjJCCt8fkrvYnzdC0JnB8IxlUkO4OEGSWXaw8UtbukIqPHkAtc0JqBOKklv/8f2YlkcBa3Iac9p4RpzLyKtaMgcL87INjXA89LRyRqM8fczhaeNNUPpP7IUJZ6lAJ0F3Wi0TeEhlPsQNUEoAgPqgHWrMhqUhFJdbLEzVUdI7h/thdE5NhQjGBm8EP8yD6VOBAdyaqd2xwA+TVs40HW7wWu53j3cuMN5hv+k483rrkacpYzdHtYiSopm+p+wH8wZA0iDaS5Olj5UfPKw3w355j+4TEdHqNhAtCOibsLaexq4XeVUSZopGIfi6E/Orw/d4mfcQGR9no/oC4y7hrRQCYbjwGmqgHgyC0utoTp9us9CcRVDZOvQKrBIRyfNCt4ETTH/l7wIvhtMZWzJWGmMFgJDucM3c0YsVj+sKeqfFDPdZWvCMU25Isx7s7DYMDEEEDYqGbmx2OreAbBDWwlUvRGN0naoNXWPDl7nC+JK3+sdWvTl6RtFj9jbt6vUx8umlUYECKZN/VzmUg2EhxOS54j7VFvZrRxmQMfh3QE8peyiROjVlF7RUOWTQdGj6TvOYSaurzYP1G68Jck6X5Rsnb5kOPmfMloXpvLJkwZLd2FvRxc8j9AvR0FZN3pYMttepFDe7YLZeLxTUKLNjHl66SbA+ej/gcT8SHj+joLacSSW+XpGVCrCDdneIPujs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iepoZgp7HUBP6bKnrv62JcLN/Z3IkcefkL7j+ycFSUCEnWXSuzxOgAihO4df?=
 =?us-ascii?Q?5UYQ+Ov5dDqQCRCRO7QCG5rwClklZ9rnnRS/3EfC4vb1qPou2B82LMgKbTLt?=
 =?us-ascii?Q?1fEDSKd0hl5gL04BT3Ese3dh/vFJxby51DyAfdt90jSbmem6JFtXMqrgaRJh?=
 =?us-ascii?Q?DHfmSpf+J6XWGYgUso3C9xQpr7ycwnxzwLZ1irNhSLv39sKanM5dzpHZG4jp?=
 =?us-ascii?Q?i+jpMPmEGzjyH3SMeDCSxsR7AOD9D/h1HINkox9v7O8d8oHunYvR9YkUnmMh?=
 =?us-ascii?Q?QTyCxWexciPz2+4m0vwFMrMsj/62syVFdXYA63nx8QfZafgHXoxnRyWwhKTr?=
 =?us-ascii?Q?jvPpsiu7mlHxFk+CgBJPW3VcqGfxUVF0didqE9nI+698kbJuFLoIna8+++Bv?=
 =?us-ascii?Q?DEuM6sUIgC1JesrSWCBMmPnSDyNSTR9UeEMkkbF9+z9gbaPDTttIcAKb/roe?=
 =?us-ascii?Q?zOG6SSCXxUd+gjevmm3i/vbSxziG497kybcV3fdrXrLWNE49/Dgz1xskAggC?=
 =?us-ascii?Q?N/+DX9WA74RKPfpRE6yC0iicBwH59eNmIYZHRG1LjapQK/FpGKLTBEc3t5c4?=
 =?us-ascii?Q?EbHio1d9FwW/3T9QRBas+bAe95YT4yLRgnQP27XBwBYLKC165scRddCIWJU1?=
 =?us-ascii?Q?QkKs5crcIgysE6f1zr/DNaUU+cUtY23KbO5RwgpzUd0tOcUi0PvO54bL74zz?=
 =?us-ascii?Q?DnsaYGx5A95SWDbu+/aCQ45TV+O/9zsKg6KosWAs0DWPK/qKoU0SLCBn39xV?=
 =?us-ascii?Q?GhgyzKP9ATt6U6wZUFdpIZhDt/UX23DrotNc92KbuRvVtUbxz+nqicZdpmoP?=
 =?us-ascii?Q?3R5o6C4O91c39Pk8ySTOhAc7BtOZcdZzXs1GHGEbezOgNHyV8tftbfBfxGdb?=
 =?us-ascii?Q?SydG7+rlDkDUjvim3VC8iP+XmI4NTV4PLGsJSFdY80X+hVAeuWOzgUYiGv+7?=
 =?us-ascii?Q?Uz6EtNQ/Q4mSxbtq45PIPf58y5cFmbhFCxPbDH4Va19lE1/yprAT7RQxP6dX?=
 =?us-ascii?Q?aZghYDtcOASfdlS+2ATXyz/n3y9k3MajgZZ+sDe1IAsw1aKf/VOkuZfrOjMn?=
 =?us-ascii?Q?lqMbgfp7zhW64vzSEF9GNbK7ehZfrdj3JwQf53JCu3eG0Ug5v8lJRfDXAT1p?=
 =?us-ascii?Q?cPODnk36yDwlx54mgpDVzPtMCcVdpbjLdy/Kj77jpsZc5oZrIL9yDsUmqq6b?=
 =?us-ascii?Q?nSV23oEd/JJqtVyqvMB1gjWBOYfYujhTo3knRz+LxudY19IFWaZSm47DSBDa?=
 =?us-ascii?Q?xrrccUt70QtSSC8otNNN9HVpsKQYSMtL3DWhbsJt4Rx6fypDfyvG6AY2aaV7?=
 =?us-ascii?Q?lqxJSt+YlXE+mDsZwEH8mWR4uZcbnyLLVMTT18fDBBu4F786HRuwnpH6mqaI?=
 =?us-ascii?Q?uoSMGcztLD1lt9GMaSPPpLK/GU1soahuwuV9/gpBVERLFnOG3oYT/koI5HLh?=
 =?us-ascii?Q?9pW2SByUL1CQStpzMC7b9WW5/hsuj4xCBUFpREGz6ZDZ9blQKIxdy/6xGusc?=
 =?us-ascii?Q?sN3tzlkch43TYxXdSShtmte7n8vU1OzNUbcJvyrIca28Q2C04+rSMS6zi6uB?=
 =?us-ascii?Q?GH3GvI0HmTymAWug/0ZOokTe96natQ1ObuRRrajfisTITVGDkAg1Jdpxdn9N?=
 =?us-ascii?Q?OBeBjP5h0mSOqOeBkdWvJ+M+4nqcoO+qq25lE+ofh8dlDkjTzfA+vMmsLJyz?=
 =?us-ascii?Q?07N2seP133RGuGvWsINIBuTq89FYigUta2VBoV/B6Psz0yLo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6bbf14d-e605-49d9-9698-08de890f58b0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:06:54.0173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vxYIHJhmOAE/bTtP70khXGFjwewncPRIawBR4j/L59pYDOxNQ0XmwaazcJruNGaJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813

It is used by no-long-exist READ_ONLY_THP_FOR_FS.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 54b3d21e4cbb..de4a1e6ce376 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -85,24 +85,6 @@ unsigned long huge_anon_orders_madvise __read_mostly;
 unsigned long huge_anon_orders_inherit __read_mostly;
 static bool anon_orders_configured __initdata;
 
-static inline bool file_thp_enabled(struct vm_area_struct *vma)
-{
-	struct inode *inode;
-
-	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
-		return false;
-
-	if (!vma->vm_file)
-		return false;
-
-	inode = file_inode(vma->vm_file);
-
-	if (IS_ANON_FILE(inode))
-		return false;
-
-	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
-}
-
 /* If returns true, we are unable to access the VMA's folios. */
 static bool vma_is_special_huge(const struct vm_area_struct *vma)
 {
@@ -199,9 +181,6 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 		 */
 		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
 			return orders;
-		/* Only regular file is valid in collapse path */
-		if (((!in_pf || smaps)) && file_thp_enabled(vma))
-			return orders;
 		return 0;
 	}
 
-- 
2.43.0

