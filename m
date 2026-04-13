Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010065.outbound.protection.outlook.com [52.101.61.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81091314D07;
	Mon, 13 Apr 2026 19:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776108049; cv=fail; b=Dwj7C7a3s5PYSjNHQvbxvxVe00ayRFYj93ur/8RaSGvCGm8A1OthNXyh5yY8ULfS4wpd9yZLZnHJ8vKxm2FpNxZ+x8HTUpp2UWckX+x5THDllro2SB624tvRYrfksYEBZJm1NRfVEYbdIWcXaBIg9dCWeZlHgobPjuc4fgJHgOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776108049; c=relaxed/simple;
	bh=9PJjWEKEijD+4G3ClMk4bI0elYGkJa+i0mhz23cjGF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WPrvYMknj/0WDR08hq/P/KIbKokxxLMMQoRYUtq14SQk+axKB0LgPgUJdjd3/F8c/CftFF48cmcejScQYQsOWj3GM0hINcDXo4bAUEYBT+h5PZoQGQQmkm2I0fIjZx+emFJhDFrWaoiNaD9aZPi3Q60yemn7TVm5fxPCOMyxbTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e68eF1VP; arc=fail smtp.client-ip=52.101.61.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e68eF1VP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UXXtlMSDrIOWIMqj3B2N1rcUPFGfoa/wbUPAhFg/ADCSXZ+3KymAdQvbur2rDFk7GuVf4ICp+y0jbLlMnz81DAcFtb+eHgWZZk5L/P8sFYyo/7La0oXp+SX8hVPXUFVBvW6+LptJR3HhTJgubbFE/fFH4QHYjzgTpun+QJs8C71PFJG8OQan0WZZ8OnRoH5YmEJn7AJcfYwRXzS8umTomWxAM3xozNAjm5uBIaVyydM/6nciZxmHMgIRglba1KYe0HT/PYIpn3klv0sSVS3b3hWmClgbSQbc/d3W8RX9AjVA7RtCHlrh/R+lVw0doqylYphFxqi7mkuY+o/HT7IlYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+5z+liynp469aw3FnXdrr/mMQViI+U3MfIRO5hKMWo=;
 b=cZEXP400N9/EjlgSMh4tR5yCBXf0hiNsM08Rn+xE5g6whjCNpQOhJAD7otUzicT0ofYVQBEakJO7bFOu4yH95mYV1HcEwouIwtLV+QIlWgJBe/UGsNtDZILiF0Hkd9Wiu35NUp9EdoW20wD8L3tCucNh0VXoh7JO7issexdEdAEepT0IS9h101+CKXV1w9nJA4fxGJaxWRT6QSY8UlREJSqf5jFr+MAi7VeD0/oItf/VJB1TeVxO3agkwRLc/tnbdY9cvUBgQVdtHTLBsG+MK7Y13daJqGlvDUlWde7b9YgcCNHZTgRsLlwvNyKFrJxhTZveSdFT+D1Cfqi3R9TRoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+5z+liynp469aw3FnXdrr/mMQViI+U3MfIRO5hKMWo=;
 b=e68eF1VPQQggWJn6X2TL+sYM1Auk7BQtX0Oshl0SQVjcV86mjESjrx9A3QW14k3cof2EnoIrajrto4tIJ2uDycvCXCn9YeTZGS/XAsaukln95o762cKfBmhOGSypqnN8/amx+AiCr6b2qcEtBLR0mGdUtL1W8pJF+pM1Q5XsQAY6JwYiruzO7/E6VnyN3fjp+AsDXu43xF9xa5Y3diXhO/35qp5Aa29T8T7izf34QrOGiQs+fU3kEySXwYztLPYDJGpp/kiYIY34zPjeildxWvAXqpKuxX53+4Z+vOvU3OrBjFdO0YYHGMaQ7kp3zo3ZHguF3XQLGhb4J5zHGpU9Gg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7986.namprd12.prod.outlook.com (2603:10b6:510:27d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Mon, 13 Apr
 2026 19:20:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:41 +0000
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
Subject: [PATCH 7.2 v2 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Mon, 13 Apr 2026 15:20:19 -0400
Message-ID: <20260413192030.3275825-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413192030.3275825-1-ziy@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:208:23d::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7986:EE_
X-MS-Office365-Filtering-Correlation-Id: fd6e2755-5b6f-436a-8d0b-08de9991c04b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	/D682BQFPE2fJKybPmFMU0tr+Ouc+PrXtT8oWGHRH3hVlJSWJ35RL6jGXBy+2Z30aCuTZiVPs8d/kMg69eI4H+owNqgrlSG2kDgeGi41+LxgpuGi/xgZqnGuJEnat7QY99r5foBCe0o6aXjDf5W+q0YGD3eCMoN9ifEkjgtBdgRukY1QxYOBb5VVHgNbtSJc/hJEj34eLt0g755OvA0U9+bU+sCbZmGGchNDgRey0mu7SxkvERJg9X6Xz78Rm9oEe5wdJA21blH7EJBL2c7z9aUvSm9jJTcKYDjqEWHe0erFeCBvaIjepxktaecicbcVxmrx1Dn4QMYqQz8Sw/X2Xgz03dH/CvbmIoaHX2v7gSwzIo6/ds4z+dRuhAvWVl5q2bRfiw7aTuEn+e2KIV2C7Vvd4bxd1b9HZ4E43VJx1OM1pkrCJfhAVGcMwr5Hd7o99+5OZrxnwV1KJbz3ziDYpv4P6lOqhshCm3KIANBwcN3pmQCRtCMq2kT9Zsp3pDAzpAI1kEeBvr+1QAsg61B3NtQaO1MorkA8qIS2pxq9pNt5m3SjfxagGmFctlw+oFE3AYz9mT9c0gkHc5sbRzOilbynnR1sE9uTO/4dUxZ0R0RkNOU8cmTZEYGHEpljRKHCnA9/RMs32YAgJPQICkv3x6gsMGFrrFkj+wIxIv/+oHDwb1hObDL9UXEWij7BWkT6pKzaOAElVD3xUx5MkY3BmZ4DqJQFwNoI+pfGu6aeueg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZtFacIShghHgjEzajCY5sKldXpfpJExC1oqk70V3EH1y1MRjSJ+OvPnKssLM?=
 =?us-ascii?Q?7DTqmgeuDrwHf1t75Fp8aoUNsU/xGspEfNdRIjcmM/Ch3hRLBzMGpLls6Ems?=
 =?us-ascii?Q?ftX0hNTectOU0HOgS3xnqzYAf6JOQ+RPdkKK2Tw+f1d7Pkz+nYaVnZYRmJAv?=
 =?us-ascii?Q?ihIEVoLEWOp0K3UrYnRfae74hu6Evs7z5TTdUE7j+sXD6UwJqx7BBf0wBIXD?=
 =?us-ascii?Q?1N241i5qrR0hGE2x/TYmNfv2IGnkBTNl3j3F1tp34PD3WYFvai9THMzZC37L?=
 =?us-ascii?Q?uh5IVhydiM3Coswbzh+6tFCsrXcHwk6L6zPSbNYqqF+LF8P6M9NWsaz5Xr6q?=
 =?us-ascii?Q?7VwdZHPMzEesuzYhX1wSmdlxyCCGdTh46bFbwezVG+VmMZBJvxXraqp1ZyhX?=
 =?us-ascii?Q?cpEIIFym59yp6nXD+CRlV6wuAUJreq2OyZIkD37/7NnSJFeX0zLR4ZwAL8c4?=
 =?us-ascii?Q?CjQtWgkEDwxcnD9CTZ//rjRWfOCs31fI97zN97KrtQLb4yKxLpwLOSBO1Sfg?=
 =?us-ascii?Q?EJiQe5s52/m5CiEwz0v5NXV7R9ujworRXeuGhiVcWTqg24OEf6RDc54mHRTc?=
 =?us-ascii?Q?blXUHRvT89Pk/eYNdeqv1FUd3NJGg2oyHzGN2AJYjnUzqCpGDfZEXGeMimwQ?=
 =?us-ascii?Q?bczB1yM5NTberJBm+trocaoE8Z8zPaCMSyPJ5I1Pb29DNA0fbhrj1UDI/wd1?=
 =?us-ascii?Q?FvzULixvqfgyQtq2Agk0CHs6dH8ip/3I4apH4VbO6pploQJRZgVJ3cUnZ+aW?=
 =?us-ascii?Q?7HhDbK8dDcLxSLIJFBATLhZUzq/q97dmbtF40MnmjbHKhTAXP+U758ZEF9LD?=
 =?us-ascii?Q?vtFIcLJ0vCTtGZMrMVevZelHzX9yry39qAOYKyPk2cGkaMDwSvuP8L1QcZuz?=
 =?us-ascii?Q?fcHv47wxgDSMwn9z6pBOKfvTFjvh1SoS09VsgvpOmdhA4VlyVhr2waBW1jkl?=
 =?us-ascii?Q?5wtTcNUjdBmMJ7lc74BsPOeMwvAvTk3ugrJ9PoE+mwc+MQj7H1dfMpEF53qO?=
 =?us-ascii?Q?6xHhDlz+DUX6NShc/RK7sRIHS9bP38ZtYK8wNuQW2E/2j+LJyJ6ne4k3AOIn?=
 =?us-ascii?Q?6fHedKl/fP6KgLQWmFUPwbxSweMDaxi/EiBoHIW1qCAL0EN1gd4XFIhpTuxe?=
 =?us-ascii?Q?SF66Moa+vigHS+GaqW1mMo4bfdbA3llRXtSTGr3FYVDdo9vi8zFA/6wD5+wE?=
 =?us-ascii?Q?JriwN8jYqjP0zNCPbsAI3FJKhPMwiFRXhQo3XVQ5OOMhdPdmLNBO80yCEkEY?=
 =?us-ascii?Q?a6HrV8WFTG8GHI+59QG7JLaTwlvlom2gzCVvtbS4Rw3+5hZMvmX817pgk547?=
 =?us-ascii?Q?wPIa1zTf2E19nE6F9pgifgE89EFD+NhHTDK3tOYbIX2xhMxC6qKcZWe3wxvn?=
 =?us-ascii?Q?CgxnfhCeZUDX7IXA+FjL7hs3o4oWC97vdjm68GfGwd9V2c5NkBT5aiolihsd?=
 =?us-ascii?Q?5FPELVs1gX29DmZzqI8Tcm4mbhz+O8F3J3AkLFNAF0CPFSWnO/5c7NANuXg5?=
 =?us-ascii?Q?YyX8AsZMbIkBcuIvgK7CLJ+ysvSxSqrlHQGM6o+LPjlqlfViOggbIvHR+glo?=
 =?us-ascii?Q?z/9q+wAfMvtuuHPiApjWnZcXETUWUC0nsI7V7p8oKuCZkSMcUUW3/VodePQW?=
 =?us-ascii?Q?P/4L1lE1ArXlzYX7qJFLG8B8iAUE9XrOLrp51iYK3p9yfsUhD02g9RNpsqVw?=
 =?us-ascii?Q?pm6d2wcK7iJajjZ7nCfFD7YcG3/Uyj5WIjREMe8WZ8PDQpL5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd6e2755-5b6f-436a-8d0b-08de9991c04b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:40.9736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Osjic9wG0tzCl0RhRM9SUd8cE00d0dnUzSsqNR4WfZfASGHGFK94X8KxQDBYw/wS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7986

collapse_file() requires FSes supporting large folio with at least
PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.

While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.

In collapse_scan_file(), add FS eligibility check to avoid redundant scans.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/khugepaged.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..d2f0acd2dac2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1892,8 +1892,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
 
-	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
-	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
+	/* MADV_COLLAPSE ignores shmem huge config, so do not check shmem */
+	VM_WARN_ON_ONCE(!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER);
+	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
 
 	result = alloc_charge_folio(&new_folio, mm, cc);
 	if (result != SCAN_SUCCEED)
@@ -2321,6 +2322,13 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	int node = NUMA_NO_NODE;
 	enum scan_result result = SCAN_SUCCEED;
 
+	/*
+	 * skip files without PMD-order folio support
+	 * do not check shmem, since MADV_COLLAPSE ignores shmem huge config
+	 */
+	if (!shmem_file(file) && mapping_max_folio_order(mapping) < PMD_ORDER)
+		return SCAN_FAIL;
+
 	present = 0;
 	swap = 0;
 	memset(cc->node_load, 0, sizeof(cc->node_load));
-- 
2.43.0

