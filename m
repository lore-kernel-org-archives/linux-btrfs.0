Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010035.outbound.protection.outlook.com [52.101.56.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538A92C026F;
	Fri, 27 Mar 2026 01:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774575790; cv=fail; b=nxdF8RTy01WV3sstRR7NL+Gk7LDXfY5yTBFS6vunzxUARIoxkLN3fXmy0ltKJ8oXGJI52HfMJJnp8l+yRUaoR/EIzkHkj6EyS3x7mXPVNaIM5i+ap/9n7eXbFgR0y/b9s6Ax8mrVfGqfVpEMNrHy8toqqUK1TU7OVRCsE0JZjag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774575790; c=relaxed/simple;
	bh=JI8ebSzpyl7DVb+h2cyBR0qtAQ+niUbHMSKqLI4SEKc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Q0k0MTzC0xAkv2+7Sc7CJQ/JT7SD8a4DHYYGmaPPsjXcgdm3BcSg3hYoACxFhrgLttpRvF1riCaSxwNHF8U+oMHER+R1l91yL9BrDBDTqiNQdUu1kMd6I/y5CthTdVZr0N3w2Tw+I/F69N11rmbKPFWGgJhKayvh78AmRUlLIVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=civwGHie; arc=fail smtp.client-ip=52.101.56.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="civwGHie"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=guH/Dx4S70T+JEQlDem5/k8LGa3tqfrI2PYZ2WqqJ4xTFagotIkFhJDEZmADQqj7hqlNgTYIfP77+kbC2c03xNEHySvn3d+yweVCXcnwVGV3MykdWItXnKGC0iMtqBNj2Dq7Orhgijrhn4ZnNKmfLXl1QROJZ34Yln5wgSIWg17n+tezkHtkWRqizcxJPRLTeNT90ErYxeLeyHnoolPRoZfOA4j9QhWn8dw5ume0pTLtrW7byLVL7usYiA0Uq9lAouinUoIay1E0Y/qhYldLQOaCdNNpsqdDR5pLD+RXqoGUfAW/YtDqeGXyRPgT2JFIosEMoPliP08JsHSHNDMjuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jndxyr84OySgqnCGJcFAqYgq7ZVI2CE+JlFtFYOHm1s=;
 b=UBsunYImbbhULRWWl4Dj1xxxLf8MdlHmhpwu7v0biS+RAZOpesFnc5at3JmzrwK0IZPXTAKZihbX9C2HD/ToixhaOLuqV6k/sShFoKmm7txPVN7RcCFzb4T6omC06D4ejaF8C2pt7nrbmGP0KLFKp/UY9eJG8hUPEf+0AAm1mQhIYJyd8LCkrOM6w8jCATky8rJFfiW1IN75bAeL2yU4o3Ln/mbPdYy0XCqukpmVQt8WiMVA0M5HfdmmOimCDHoOO4+KfTa6ToEsl+0RG4BGOYcI/tqg+zplmbPjS2pU7voqVZj2h35EdyY9GFArEWm4BPkDhEk2/ld3WGVc+jRsgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jndxyr84OySgqnCGJcFAqYgq7ZVI2CE+JlFtFYOHm1s=;
 b=civwGHie+Dku9dsO/0tHh3LXAOVTwUZWYl549B4UweJZYyXTpL9JrzjRHtQwhtHMP2aBjYrF0fzYQbXAr+FGxa/5M8vPVGX+d2soex7B8tJUkzrL2DfKRXiPJlpwAXFYVDevdU9PqwtPiFbDgZ8EFSjwykjr5s4WX/O1Fqsh+zDBfKjOtbeBlYF6nwtXPoAM8+/8975z5X8kybl+MiIV36LIRXsek+ALC4nEBxxBBIiu0XFCUi/jewqvZlrId9CNxDroUOf4c4wumpIkqjH1FOVLjXvlq0oeeZ4kwjYIuBiQAgVIctCPkIq9wpC6N9vgPxtkjikX4yz6dLbb07wecA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9264.namprd12.prod.outlook.com (2603:10b6:408:1e8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Fri, 27 Mar 2026 01:43:05 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 01:43:04 +0000
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
Subject: [PATCH v1 00/10] Remove READ_ONLY_THP_FOR_FS Kconfig
Date: Thu, 26 Mar 2026 21:42:45 -0400
Message-ID: <20260327014255.2058916-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:208:32d::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9264:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ac6bf8c-41bc-492c-4bd8-08de8ba23078
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	QF7hUEu+xO17SNi/6kBeUdiWb1zrGuY/s/jW07AuT63D2O6REKMKlKcbGu/J5i8abH8n+4a0QMBil7TQrB8aqaXFWHu/exm36Nedw19c/zCKYqoBB5Oo9j6FR8neD0PXRkFIHIuUrRTnmQUN1Z+KLYoO+PZQ3CHCpDHcQv9iZ8ExOrAJ/cQNUKXshvUACIXzQWsgWh1JBmzBZP6JC0RnLWQU0MXd0e+fBtU33occLJf3xXOW8ZC2tAcN7tBZZhEP1p8oUl3jrsUjA9PWjZG6nmtWKrt+N82cSEtqHvpi/Ic7beUEojIz0L2Dc03ZZCCrla+J6c3prM5bQfKLt/NlhqXlGsYrFtDSAS00lVvbCGvGsbGo6xAMhOpyMyUxAi4DyJoX2TgbOE3WgR7fnCfBbog0AndWb4NmECI0P+2cRPyXiRU8pU17lFtOmPojRIcZZRZ5qkb2NdEecOebCsSxaEX5bF1m0pf8aa4JD2FZQYFtCHVrzXR0Y+onHoGj3ndvgUppn/o3eIxvdO/1Q066Y6ajPkg7MAY13Rn59smvdMY58auHxUNVPxb1IxI1EfBF7/sOq9iZQlrT/kXR1UMIEtmzdvdJgaIPVbezDgKGYyyDB+vWvADCtjM4wK0XlWlMvTlMlRsMApQKY0e5s/6vAdaWsUnR4IUYAkQoYZdZcxkbm/Ymq0v/kwHCu0rL4nDjqNxvtjz7fyeoO72WOb8Ze0P6cAgsiQpL9q8hYNp6xIE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rTMBUgblmjd6IzNjgZPOY/cdBLQb53ReouEjLUNxwMKUqI6v69ARRt14wtN7?=
 =?us-ascii?Q?6HlRDDeWxW5qU9GwEYoGrzcKJ4XVVhCIrLA3SH8jB4y1vuu/hhnNJTAuDFAk?=
 =?us-ascii?Q?NsW3/wCwyCJIE5/2PsYGtuGNchbpkTZ5UKD8y4uOmoZ09DBDkitO9WflbHnR?=
 =?us-ascii?Q?Wz5ZA/VxOIE+zH14tn24Fe0j/9lAdSavA6VXgZ/3iL8TxmmH7+NNGGByHXtp?=
 =?us-ascii?Q?TaH3T59+aT85SOkSfs49l5q3uFLp4KcfSTlCRp9OS/qYROH5GYFBecJXowlt?=
 =?us-ascii?Q?pitrukRkfjxVkLd8OQFfTFieFooSI79KZ1ItEqQ8KSeFTPPDW10RMDwWtHuN?=
 =?us-ascii?Q?2GtIE8Ox1n972kSfPlME0DavEeO23WNXq86ydHCkgAjgloSX2TvjLP/4bEEy?=
 =?us-ascii?Q?Cc23UCQMDukOgrjP7Rq5H0DknWls7AC96DgaWKeOb5iCN4NYC0fehCSg2Tvz?=
 =?us-ascii?Q?1urUUUbiwXJkz2aREunnbRLXBEl8GYrABRjDWSRwif0SsmAzW6XcVw2W9w7g?=
 =?us-ascii?Q?ChsJ+OTMdqH9pp6G8emrDkyZ+4cPezBXUlgU2e7cZ0EoNLNwa+fWe8byHiR9?=
 =?us-ascii?Q?xG1iDtV757r3XYr++QFWaXYzEzAtysbQH47rV3CUBzqav/c6Z+/J/45CnbFA?=
 =?us-ascii?Q?laV32W44G4s0LB9RdbiziTwN/J+IRPVvOBrpNvgxqSwARWBrH8/GEivl+ju4?=
 =?us-ascii?Q?auJiqQ5c8PvQBfD/Fm/SeMzkAk+bFGYps22+S/ZLKNZNtyqHpw63/SPfONTn?=
 =?us-ascii?Q?DFYro0R280EVO086IFU1vciWwKiq3dACCnWEf/TwnbtvCh9oFfh2jDerCvFA?=
 =?us-ascii?Q?2Qz6L7WbzAheyO8xu1sTyzVVTaFkLhiZP55TJx1NyolWeuxHVcE5+fYlI4AA?=
 =?us-ascii?Q?4VM9tyQwpmmbHdg/Ae1eQNcPBxk4sv9HjkaA1K+24no8ASicRgY52Myhy8tN?=
 =?us-ascii?Q?7Q0mcKkpDcVsqQf4rBMinu2PHmsRR/FkMLBr4CNtxnlr7xpCqKANVjgfwFy8?=
 =?us-ascii?Q?iACQ0m7crK9WRE531oaBHR1J/jiEKC8sclF+vHWF9vuww3NsSqxlw7hlVlCa?=
 =?us-ascii?Q?5y3j9sTsAGjr3VJRgAzsHRknso1THxQJhVROkzaSk2BqMxCuGj9nJTyEIcXS?=
 =?us-ascii?Q?V3xZrTacEdUWDBMGXTViQ73rGI4MgHFa9y1Ye1NPAX6s/pfuw30eSBqh27od?=
 =?us-ascii?Q?Uyc06oUSq0CkfoupEZ8puo8E5I6m2cLOMbaV36X9P1PwmLLdfK1y9YCmCbOv?=
 =?us-ascii?Q?KAoTvq9ggnUnbkqnt8gfCq4CrTmJ9sKWjafHE5ADpT+LKZKMDCo/T5/XwAzY?=
 =?us-ascii?Q?2ZYeYGMt2+SVVp915w4BfUf8ZOtO34ArCrTE6LypeJWtHKmeoqfXSKUvhQXf?=
 =?us-ascii?Q?LP+bMac3CEvYA7Xw4eMFjOl+jPYH6ycex7OTAQWDuK3pu1MuA74d7Zikdh4A?=
 =?us-ascii?Q?SlL5Qwr6Z5c5jx86UE2NNugdVmQudVA/gJqVyld6JFDCyi36goUTiqIrMr44?=
 =?us-ascii?Q?igJoaEfIV/NJpAGpc/o22lfgqc3zXQqHUbCiI205/1dixsvJ47EOOGqD97d+?=
 =?us-ascii?Q?OJw70vqMe/DELQ2tlnn2nAg2a/WbsDX4E8jAn0oL2pGmoXNEmgYbzN3d4/2/?=
 =?us-ascii?Q?Ejm6GmUKHL7C16sW049S5m2LfFBpQGRwoDsu6ytfHEi/SriMjUMy3hHL93Rj?=
 =?us-ascii?Q?Z/NKDR1ZwKCfWN7m6Pix67UirAc+mUYjh2yuWherDtSWevSz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ac6bf8c-41bc-492c-4bd8-08de8ba23078
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 01:43:04.8635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VmBIutBdaOg65e8Y+HXOZyvcmLLAxG5QHPk0AU5nF61h1+VGnIaCUqNGkl/TN/fx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9264

Hi all,

This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
read-only THPs for FSes with large folio support (the supported orders
need to include PMD_ORDER) by default.

The changes are:
1. collapse_file() from mm/khugepaged.c, instead of checking
   CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order()
   of struct address_space of the file is at least PMD_ORDER.
2. file_thp_enabled() also checks mapping_max_folio_order() instead.
3. truncate_inode_partial_folio() calls folio_split() directly instead
   of the removed try_folio_split_to_order(), since large folios can
   only show up on a FS with large folio support.
4. nr_thps is removed from struct address_space, since it is no longer
   needed to drop all read-only THPs from a FS without large folio
   support when the fd becomes writable. Its related filemap_nr_thps*()
   are removed too.
5. folio_check_splittable() no longer checks READ_ONLY_THP_FOR_FS.
6. Updated comments in various places.

Changelog
===
From RFC[1]:
1. instead of removing READ_ONLY_THP_FOR_FS function entirely, turn it
   on by default for all FSes with large folio support and the supported
   orders includes PMD_ORDER.

Suggestions and comments are welcome.

Link: https://lore.kernel.org/all/20260323190644.1714379-1-ziy@nvidia.com/ [1]

Zi Yan (10):
  mm: remove READ_ONLY_THP_FOR_FS Kconfig option
  mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
  mm: fs: remove filemap_nr_thps*() functions and their users
  fs: remove nr_thps from struct address_space
  mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
  mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
  mm/truncate: use folio_split() in truncate_inode_partial_folio()
  fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
  selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
  selftests/mm: remove READ_ONLY_THP_FOR_FS from comments in
    guard-regions

 fs/btrfs/defrag.c                          |  3 --
 fs/inode.c                                 |  3 --
 fs/open.c                                  | 27 ----------------
 include/linux/fs.h                         |  5 ---
 include/linux/huge_mm.h                    | 25 ++-------------
 include/linux/pagemap.h                    | 29 -----------------
 mm/Kconfig                                 | 11 -------
 mm/filemap.c                               |  1 -
 mm/huge_memory.c                           | 29 ++---------------
 mm/khugepaged.c                            | 36 +++++-----------------
 mm/truncate.c                              |  8 ++---
 tools/testing/selftests/mm/guard-regions.c |  9 +++---
 tools/testing/selftests/mm/khugepaged.c    |  4 +--
 13 files changed, 23 insertions(+), 167 deletions(-)

-- 
2.43.0

