Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012015.outbound.protection.outlook.com [52.101.48.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F2A27A462;
	Sun, 17 May 2026 13:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779026119; cv=fail; b=JpJ8V+4cE2yr02Xfwy9v9JBhOL+J1z4mDTKXYyNFl6Aa6ZzIdJr2DpFZ1QGDWBMV/G8yFa1sUqbtpkdF4t7A+yuBKKIA24+mDUnfjWtH5sSOc7djvUXDSYDJHxhnrd3oHR45QOXoqE976gRhtuxq9DUN3a2svXWdNVpMNMcVjGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779026119; c=relaxed/simple;
	bh=WT5o4GHVwWPQaU+FhtdC3JHNMceWknN5LTKD4FUnuhs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=jEtK6pSWuh6B/c48BY6nG+/5z/vjgq2BKI4JW1CamGfirE7hRQOPa4n1M/3PNwi9E62fdefFRJYO+BiR4aMCp6UYOmGe3hM30ZtF3lUMLPi0cdXEKQ5H/wS1FPc7q4oMpa4BYjP3WCigrILj5JuugyYOk38v9x4YV5F9QL0S6QU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TZIJQJdL; arc=fail smtp.client-ip=52.101.48.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TZIJQJdL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JLG/bx9Y+vJa5wWges33Bu2AgwMM4YuPWuAXUHxLzTB3ckEnT18heBrJmpCXnUsRIoSngNC8vEmwNm6N73J1wcuHmy6LPzsrsGn9dbWeZttsLkSu03IuhGGUKCeYS3zzhc/H1+1LNQaVTGbHdS4CfXTEM58noJOvbCtQJaiu9xg/TYMF+AD8HdWVT/XAzBHZfmlCSEUWtsOojy+muHZXfTyz6RufGVAsnlsHeLUhdZHh6ShPUfpuUfhDKnv+Q70S47iufY5RltbxenU7+UCli6/BlFGDzNrI7Fu4znQSBoqo33Wb7+f8RtvlfatKoMGQSt8czOn+mYpog2LMOqsisQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VLgeGFI+OBOt3UgoH3/OVDAGS8rLUITrJwTJyMRKkQA=;
 b=aj8ubV+Xy2gorJ/+9NGWTlPH4btQ6D/GYOWgQhxQg85gd/NOdlzAKMeugdPqxGMsAre/TUAxWbzKWfpfsoaAzFPm5qMw/fVAcMyYEOHmlvI4d7isA2pIzLQj//2y8EpqT1Pro7Ovrqssf0wE1mnBLU/fzYmsB2REVaqAHXkGd6r5f3I824bskK6fyUrsFSH8vviJEn4Qzu8H5jf41txM3hc2PAMYWoN/+IY5bfaMA2wV6Ht7EFO8Pom0qvWg3RULNcBqOcEXPsgRXj0dxbdfQ7soVPN7ixhAiVzaq1z1+jfH0Go7WQPKVJzQWESbwJGrTYObp0AP2MITaY2HvZEVag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VLgeGFI+OBOt3UgoH3/OVDAGS8rLUITrJwTJyMRKkQA=;
 b=TZIJQJdLVao/hOsRt72HSD6eaTfS2l7IxUrEwW/FHBpNosBzkM/ChQBKlv9ohKdirNaqaniLRtJLHNZ1H/EGZQiHbWGTxgu/gM51I9bn7hq/qrjD7trjUd5at8swaxNjQZUqxjk4qanmAstjJGiK7Fnf8VZYRH1YirhMuuj0VKcqOZoOAG5V+Isvk7+8orcJKYvUqezCtbPQk5nLKW3uTMvopmNT6HMy4DRnbGk5mmkiT0RuL3TqjCaNjo0njcQ1cN7INLOPPGLpblqzJdXakvyHN2V53lfwFYWPXHkUqH/iPNoMLI9kjK1sr+EgUNmPRVITnm2LFaLpp7c1mvDVbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:54:58 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:54:58 +0000
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
	Luiz Capitulino <luizcap@redhat.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Liam Howlett <liam@infradead.org>,
	Mark Brown <broonie@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Li Wang <li.wang@linux.dev>,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v6 00/14] Remove CONFIG_READ_ONLY_THP_FOR_FS and enable file THP for writable files
Date: Sun, 17 May 2026 09:54:02 -0400
Message-ID: <20260517135416.1434539-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR13CA0045.namprd13.prod.outlook.com
 (2603:10b6:610:b2::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d1942e7-a794-429b-6b6c-08deb41be1eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|3023799003|11063799003|18002099003|56012099003|17002099007;
X-Microsoft-Antispam-Message-Info:
	mtmi82BVHQx8GuObIcEZB1NFdXOwVfqSF6s569zOZHY7JfK+cOVLBhI/aolRR4oRkAle7SJbsNO5sY6qgBM2J9u7o4TFLcDF87/A0XRFwLOjqJQOHyaY9uPLbVQu2rm/jLe7GyUgeaEtX/6joSJau8P6/96SG05AW2URMYLSBrhCFOsOT5myuzKrhM7xjV8QekFeLGLK09OzC3ElpBzfszKCR073u3dqpLLSYsim8TPFET6BFEWOBNpdw7p0euFdHAXhw9MfZuhRD662Q+/Wujv6vOIcpqk6+c0XfirfaLtLpUDk/azO/ZQnRmf4HQD+w94KHLY0HO/ry0Z3s6UghX6MRD7qsa6+xJbKUYZ3IBg20OfLaGYE+Ve7ndSnig9xwDwP3awEpCM+gLP89LvI+JSpRalWIMqPSjNIZW2aTeMwB6Ofa7+E1GSQmaCBcvLo2qGBRvREsUlTcG6XXO7LLYUSeFdXq1f7o7jT3SbBwgM0jLPY5amdIV/uGiAdok1yqWUyc+tr4eNTHX4xpKcNIGFhd4YVu9SBY1FI36FnKKjwiwIYTaUA454IvCWGQOGLe7iFzBNZ4pKnAXl/GrLfNShvGqISQMBoVs/Rw8sUUnblLKjytA10i9mScMj9KEAU+bYkTqrijeGnC9xTczUK6VwrBTpHyy2tTYuVIL0QTBZC4Gd9RwULDsjtO4pseqDs73+PKYbhMfJlkCIlVW0MdA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(3023799003)(11063799003)(18002099003)(56012099003)(17002099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cUVQZXJFc3BWdldqRnB0bjEzNFlWWUU2OGZoWWJqUDJXY2lrbGdEZzRTS1pz?=
 =?utf-8?B?eGZaWHFFallLYU5sQ3ZLdUdIMjNrZC9uaUlqZmF0UHAvZmZYU1FmTEpIa0lY?=
 =?utf-8?B?OVVDZlFIT3FLQlg5R1U1S1ZwaHE3aEQyQkhwVEdmci9lelZrU1I1MlhaZnpr?=
 =?utf-8?B?dUlXV21HWHVzTjFCdWp4NndRMitWZVFkc3BvcWNSY1l3Zzd3UXZFQWJ6RmV1?=
 =?utf-8?B?bktyMlZvQmh6b01zdTVDWnEzTGRRQytqeE1nRmQ5K29wWmNZaHBRbzNsdTBw?=
 =?utf-8?B?cm9tK09VeXJndUt4WU0ydEs0MUhHcjVuVVVraTZOeGZ6dGRWK1dUUGdlelpx?=
 =?utf-8?B?QldubjBzR01QdXZZVlJVeUV4aUlDV1owZlI3T2Qxd0t5RHU5anNjb2w2WjJq?=
 =?utf-8?B?dHZWWjg0blJGZktHeUFTUWNUcjU5cTVwU1VhL05NYXd4Q1d0eEM2ZlozT3JQ?=
 =?utf-8?B?VGdJdlR2WjBPK2pSemE0YjdLVGxEbWViTlFSUUJLRDc3SzNmUHN0emY4K2I1?=
 =?utf-8?B?a3RLZFQ0VUdpOWpNQmcrU2FQOFhhVE5sdURGNmVLTElTclFNMlBCTEVDQlEy?=
 =?utf-8?B?OUxHTjVrMGlselVWZmc3RHF1Q0oxL0pudHgxVU4zbTlvV0pQTi93MDBlNEpD?=
 =?utf-8?B?Z2ZtdjQ0WmRrNFlHOHJLVXEwUzRidTZ6TExCVitoWExNR3JFSmUvZlJ6VGVi?=
 =?utf-8?B?Z0VJb3ltVGVpZ2RvdVhZam9od04xZnNmalVpbjNRRWtOL1AzOVdrSXZOdFpF?=
 =?utf-8?B?SE1XdHJmNGF4QXAySGg3NEhiY2FSQ1FTVGIyV1NlTXE4NHc4by85UkNtaWNJ?=
 =?utf-8?B?Zk9SRWp3SnZBT053THpIUk4xbGNaa1NhVlk2bGh0aDZuWHJ6QVMzQm9SUUwy?=
 =?utf-8?B?QURUUEtwM1VIV1NqbEJna0dtK1c5QW1CdVA4eGJQNWxjd1BlMXFHRVQwOFow?=
 =?utf-8?B?eEx3aDVMd1RmeWJtcHRvRDgwSDdNZmo0c25WV2h1MDNXcnhxbHFxQjFUTEpI?=
 =?utf-8?B?VnhCZ3k2M21FTiswcXVnZ2RIa2IzbGdseWlMYkxudGFkVnZnT2tZMUJpUGVh?=
 =?utf-8?B?WlhSU0VGaHBudW1EV1l0dEtSbi85MGRIMXUrWGhWdmVZd0NXUVpSQ2NYc1FO?=
 =?utf-8?B?T0t4U2I3eURyclpDM1UwdzBRUlBWVTFKSE9nNVYxeHdYajBEUUFhSmE0Nkdn?=
 =?utf-8?B?ZGlHRlZvdFprZ1lrWXhlUkU3UFlRN1hwUUFoUHFRMWhIemVjUEZxVE9pN015?=
 =?utf-8?B?VzF4cHZoMnZxb3FVNWNYLzVYWnFXbzE3Z2FBSnJGYlB5c3NYNHppaEJ2aFFq?=
 =?utf-8?B?THUvbEQ0Z1piVy9DQ21ISTF4RWdvVFZBYzNYRGpEVUZiTk9rSnZLVTdIbXcr?=
 =?utf-8?B?bjVQWUZNRHgzeS9xUzlEUlRMeGR5c2N6RXFUa1NPcGtOV25vZHVMZkhYZUxX?=
 =?utf-8?B?VjNxd1lCVXB1Wno4K3FmTU4rNUZ1RG1zRXlHT0VlV0VGQmY2dG9zZmlOQ1NW?=
 =?utf-8?B?elJTeU45NWk5T0VleGxVTkZiUVZmdU1kQUFNODh6WjVnZkZLcTdMWGZpemtq?=
 =?utf-8?B?QUovbFMzU1hBM2Y5OTJ4aWYvQWNhWGRZT0oyaUhDSVFvOU1Qc09vOTA5WnFn?=
 =?utf-8?B?MmRjTEV2OFc0cHFMVUQvakszMzFnTVIrbzJ5cGtjaWNJK2I2TDVqTXp4elVz?=
 =?utf-8?B?SkJSWG9Lak9oR1NZTjNObEd4MnF5M04xR04zRzRWbzJTRXlaVTVCMnp1Qytj?=
 =?utf-8?B?Z0VWYllWbVQ3L1RkYVlHeDVZK3Ayb0xuVFR4UUVJeXFKaUNWRzMzZzlwUHZh?=
 =?utf-8?B?RHQ0U0R2cFpjcDhtSklHSWpxZC9ZUklTaHR3STJmb05jYmxGZVdjeUNRZGp3?=
 =?utf-8?B?SjZFZzNhSUJUem5lRGd5STVYWFRvaUhRck1pa1c3OVJSYkJOM1MxRnBkMVFG?=
 =?utf-8?B?YVUxL0dEa3dad2hJVWVNNFZsdnpkSENmZEQ2VCt6SHpPV0VoNCtTK2lySTQx?=
 =?utf-8?B?Z0RxemxPcWVzZXNEakk2MlBFZ0VJcnBMejVYSWhXN0pBempDcGhKd09za2xU?=
 =?utf-8?B?NjhqWnFwVER3TEhVaHRzc3hiSmVmTWw0Q2NmL0xiRHhjMVFFWlcwR2V6TE9n?=
 =?utf-8?B?TzlONlh0N0VTaUsrZFlKZlpLWHpwS1ZoNU85dFppVzBmRVpmajk1bURpMTlz?=
 =?utf-8?B?dmlLOGVWTnp1WHdockFyK09VSktSZzdTc245WVFtK2Y1YW1Fb2FxRDZlRncr?=
 =?utf-8?B?dkhQS2ZIYzY5cHprdExQS3VIQXF3K1Zad1FKVUpyaHlueW5TTzhIOW1EU2JQ?=
 =?utf-8?Q?oPv6feRwiwsBU+C6WR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d1942e7-a794-429b-6b6c-08deb41be1eb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:54:58.2088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NRU41OBbC0/hnVjX7mmx2UZbUemkjmBZ9wpYZbvn5+MgYmVSHlA+U6QJammu3qpY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322

Hi all,

This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
file-backed THPs for FSes with large folio support (the supported orders
need to include PMD_ORDER) by default, including for writable files. It
is an in-place replacement of V5 in mm-new. It affects Mike Rapoport's
"make MM selftests more CI friendly", since "selftests/mm: khugepaged:
use kselftest framework" needs to be updated. I updated it and put it at
the end of this cover letter.

Before the patchset, the status of creating read-only THPs is below:

                            |    PF     | MADV_COLLAPSE | khugepaged |
                            |-----------|---------------|------------|
 large folio FSes only      |     ✓     |       x       |      x     |
 READ_ONLY_THP_FOR_FS only  |     x     |       ✓       |      ✓     |
 both                       |     ✓     |       ✓       |      ✓     |

where READ_ONLY_THP_FOR_FS implies no large folio FSes.


Now without READ_ONLY_THP_FOR_FS:

                                  |    PF     | MADV_COLLAPSE | khugepaged |
                                  |-----------|---------------|------------|
 large folio FSes (read-only fd)  |     ✓     |       ✓       |      ✓     |
 large folio FSes (read-write fd) |     ✓     |       ✓       |      ✓*    |
 no large folio FSes              |     x     |       x       |      x     |

* khugepaged only collapses clean folios from writable files. Userspace
  must flush dirty folios explicitly before khugepaged can collapse them.
  MADV_COLLAPSE handles the flush automatically via its writeback-and-retry
  path. Collapsing writable MAP_PRIVATE pagecache folios is still not
  supported, since PMD THP CoW only faults in at PTE level to avoid long
  CoW latency, and file_backed_vma_is_retractable() prevents it.

This means no-large-folio FSes need to add large folio support (the
supported orders need to include PMD_ORDER), so that they can leverage
file THP creation.

To prevent breaking file THP support for large folio FSes,
1. first 4 patches enable the support, so that without READ_ONLY_THP_FOR_FS,
   file THP still works for large folio FSes,
2. Patch 5 removes READ_ONLY_THP_FOR_FS Kconfig,
3. patches 6-12 remove code related to READ_ONLY_THP_FOR_FS,
4. patches 13-14 enable clean pagecache folio collapse for writable files.


NOTE: collapsing writable MAP_PRIVATE pagecache folios is not supported,
since:
1. PMD THP CoW only faults in at PTE level to avoid long CoW latency,
2. the first check, due to 1, in file_backed_vma_is_retractable() prevents it.


Overview
===

1. collapse_file() checks for to-be-collapsed folio dirtiness after they
   are locked and unmapped to make sure no new write happens. Before,
   mapping->nr_thps and inode->i_writecount were used to cause read-only
   THP truncation before a fd becomes writable.

2. hugepage_enabled() is true for anon, shmem, and file-backed cases
   if the global khugepaged control is on, otherwise, khugepaged for
   file-backed case is turned off and anon and shmem depend on per-size
   control knobs.

3. collapse_file() from mm/khugepaged.c, instead of checking
   CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order()
   of struct address_space of the file is at least PMD_ORDER.

4. file_thp_enabled() checks mapping_max_folio_order() instead of
   CONFIG_READ_ONLY_THP_FOR_FS and no longer checks if the file is opened
   read-only. The dirty folio check after try_to_unmap() (Change 1)
   handles writable files correctly.

5. truncate_inode_partial_folio() calls folio_split() directly instead
   of the removed try_folio_split_to_order(), since large folios can
   only show up on a FS with large folio support.

6. nr_thps is removed from struct address_space, since it is no longer
   needed to drop all read-only THPs from a FS without large folio
   support when the fd becomes writable. Its related filemap_nr_thps*()
   are removed too.

7. folio_check_splittable() no longer checks READ_ONLY_THP_FOR_FS.

8. collapse_file() only calls filemap_flush() for read-only files.
   Blindly flushing dirty folios from writable files would cause
   undesirable system-wide writeback; userspace is expected to flush
   explicitly, or use MADV_COLLAPSE which handles it via its retry path.

9. Updated comments and selftests in various places.


Changelog
===
From V5[6]:
1. added mapping_min_folio_order(mapping) <= PMD_ORDER check to
   mapping_pmd_folio_support() in Patch 1 to correctly handle
   filesystems whose minimum folio order exceeds PMD_ORDER. Also
   improved the kernel-doc comment per David's suggestions.

2. cleaned up Patch 11 per David's review: use const for open_opt and
   mmap_prot, remove mmap_opt (use MAP_SHARED for both read-only and
   read-write mappings), inline file_fault_common() into separate
   file_fault_read() and file_fault_write() functions, fix "read only"
   typo to "read-only", update usage message to "with PMD-sized large
   folio support". Also fixed run_vmtests.sh to use elif test_selected
   thp for the SKIP case to avoid spurious [SKIP] output per Nico's
   report.

3. revised stale comment in Patch 13: removed "There won't be new dirty
   pages" and updated "khugepaged only works on read-only fd" to reflect
   that writable files are now supported; merged the comment blocks per
   David's suggestion.

From V4[5]:
1. fixed Patch 1's compilation error in !CONFIG_TRANSPARENT_HUGEPAGE

2. changed Patch 3 to no longer enable collapse for read-write fd but only
   allowe read-only fd.

3. added two new patches to enable clean pagecache folio collapse for
   writable files:
   - Patch 13: remove inode_is_open_for_write() from file_thp_enabled()
     so that khugepaged and MADV_COLLAPSE can process writable files.
     filemap_flush() in collapse_file() is now conditionalized on the file
     being read-only, to avoid repeatedly writing back dirty folios from
     writable files.
   - Patch 14: add read_write_file_read_ops and read_write_file_write_ops
     to the khugepaged selftest to cover the new writable-file collapse paths.

From V3[4]:
1. added a TODO comment in patch 1 noting that the is_shmem exception in
   the VM_WARN_ON_ONCE() check can be removed once shmem always calls
   mapping_set_large_folios() on its mapping. Used VM_WARN_ON_ONCE() in
   mapping_pmd_thp_support() instead.

2. fixed the dirty folio bail-out path in patch 2: add xas_unlock_irq()
   and folio_putback_lru() before the goto, which were missing and would
   have left the XA lock held and the LRU isolation ref leaked.

3. renamed hugepage_pmd_enabled() to hugepage_enabled() to reflect it
   controls khugepaged for all transparent hugepage types.

4. reverted the comment in hugepage_enabled() in patch 4 to the original;
   only removed the phrase "when configured in," which referred to
   CONFIG_READ_ONLY_THP_FOR_FS.

5. fixed commit message in patch 6: the dirty folio check is added after
   try_to_unmap() in collapse_file(), not after try_to_unmap_flush().

From V2[3]:
1. removed unnecessary check in collapse_scan_file().

2. removed inode_is_open_for_write() check in file_thp_enabled().

3. changed hugepage_enabled() to return true if khugepaged global
   control is on instead of false. cleaned up anon and shmem code in the
   function.

4. moved folio dirtiness check after try_to_unmap() but before
   try_to_unmap_flush(), since that is sufficient to prevent new writes.

5. reordered patch 4 and 5, so that khugepaged behavior does not change
   after READ_ONLY_THP_FOR_FS is removed.

6. added read-write file test in khugepaged selftest.

7. removed the read-only file restriction from guard-region selftest.

From V1[2]:
1. removed inode_is_open_for_write() check in collapse_file(), since the
   added folio dirtiness check after try_to_unmap_flush() should be
   sufficient to prevent writes to candidate folios.

2. removed READ_ONLY_THP_FOR_FS check in hugepage_enabled(), please
   see Patch 5 and item 2 in the overview for more details.

3. moved the patch removing READ_ONLY_THP_FOR_FS Kconfig after enabling
   khugepaged and MADV_COLLAPSE to create read-only THPs.

4. added mapping_pmd_thp_support() helper function.

5. used VM_WARN_ON_ONCE() in collapse_file() for mapping eligibility check
   and address alignment check instead of if + return error code. Always
   allow shmem, since MADV_COLLAPSE ignore shmem huge config.

6. added mapping eligibility check in collapse_scan_file().

7. removed trailing ; for folio_split() in the !CONFIG_TRANSPARENT_HUGEPAGE.

8. simplified code in folio_check_splittable() after removing
   READ_ONLY_THP_FOR_FS code.

9. clarified that read-only THP works for FSes with PMD THP support by
   default.

From RFC[1]:
1. instead of removing READ_ONLY_THP_FOR_FS function entirely, turn it
   on by default for all FSes with large folio support and the supported
   orders includes PMD_ORDER.

Suggestions and comments are welcome.

Link: https://lore.kernel.org/all/20260323190644.1714379-1-ziy@nvidia.com/ [1]
Link: https://lore.kernel.org/all/20260327014255.2058916-1-ziy@nvidia.com/ [2]
Link: https://lore.kernel.org/all/20260413192030.3275825-1-ziy@nvidia.com/ [3]
Link: https://lore.kernel.org/all/20260418024429.4055056-1-ziy@nvidia.com/ [4]
Link: https://lore.kernel.org/all/20260424024915.28758-1-ziy@nvidia.com/ [5]
Link: https://lore.kernel.org/all/20260429152924.727124-1-ziy@nvidia.com/ [6]

For Andrew to update "selftests/mm: khugepaged: use kselftest framework"
from Mike Rapoport's "make MM selftests more CI friendly" series.
===

From 29f1e70373419e304ba7a69bc78fb43ba40ebfed Mon Sep 17 00:00:00 2001
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 11 May 2026 19:27:58 +0300
Subject: [PATCH] selftests/mm: khugepaged: use kselftest framework

Convert khugepaged tests to use kselftest framework for reporting and
tracking successful and failing runs.

The conversion is mostly about replacing printf()/perror() + exit() pairs
with their ksft_ counterparts.

The nice colored success and failure indications are left intact.

Replace the progress report in collapse_compound_extreme() with a single
ksft_print_msg() to avoid headache with formatting and make the test
output more concise.

Link: https://lore.kernel.org/20260511162840.375890-15-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Li Wang <li.wang@linux.dev>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 tools/testing/selftests/mm/khugepaged.c | 321 ++++++++++--------------
 1 file changed, 132 insertions(+), 189 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 7f61bfa455e96..a2a3a52031031 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -86,17 +86,19 @@ static int exit_status;
 static void success(const char *msg)
 {
    printf(" \e[32m%s\e[0m\n", msg);
+	exit_status = KSFT_PASS;
 }
 
 static void fail(const char *msg)
 {
    printf(" \e[31m%s\e[0m\n", msg);
-	exit_status++;
+	exit_status = KSFT_FAIL;
 }
 
 static void skip(const char *msg)
 {
    printf(" \e[33m%s\e[0m\n", msg);
+	exit_status = KSFT_SKIP;
 }
 
 static void restore_settings_atexit(void)
@@ -104,22 +106,24 @@ static void restore_settings_atexit(void)
    if (skip_settings_restore)
        return;
 
-	printf("Restore THP and khugepaged settings...");
+	ksft_print_msg("Restore THP and khugepaged settings...");
    thp_restore_settings();
    success("OK");
 
    skip_settings_restore = true;
+	ksft_print_cnts();
+	exit(exit_status);
 }
 
 static void restore_settings(int sig)
 {
    /* exit() will invoke the restore_settings_atexit handler. */
-	exit(sig ? EXIT_FAILURE : exit_status);
+	exit(sig ? KSFT_FAIL : exit_status);
 }
 
 static void save_settings(void)
 {
-	printf("Save THP and khugepaged settings...");
+	ksft_print_msg("Save THP and khugepaged settings...");
    if ((read_only_file_ops || read_write_file_read_ops ||
         read_write_file_write_ops) &&
        finfo.type == VMA_FILE)
@@ -145,19 +149,13 @@ static void get_finfo(const char *dir)
 
    finfo.dir = dir;
    stat(finfo.dir, &path_stat);
-	if (!S_ISDIR(path_stat.st_mode)) {
-		printf("%s: Not a directory (%s)\n", __func__, finfo.dir);
-		exit(EXIT_FAILURE);
-	}
+	if (!S_ISDIR(path_stat.st_mode))
+		ksft_exit_fail_msg("%s: Not a directory (%s)\n", __func__, finfo.dir);
    if (snprintf(finfo.path, sizeof(finfo.path), "%s/" TEST_FILE,
-		     finfo.dir) >= sizeof(finfo.path)) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-	if (statfs(finfo.dir, &fs)) {
-		perror("statfs()");
-		exit(EXIT_FAILURE);
-	}
+		     finfo.dir) >= sizeof(finfo.path))
+		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
+	if (statfs(finfo.dir, &fs))
+		ksft_exit_fail_perror("statfs()");
    finfo.type = fs.f_type == TMPFS_MAGIC ? VMA_SHMEM : VMA_FILE;
    if (finfo.type == VMA_SHMEM)
        return;
@@ -165,40 +163,30 @@ static void get_finfo(const char *dir)
    /* Find owning device's queue/read_ahead_kb control */
    if (snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/uevent",
             major(path_stat.st_dev), minor(path_stat.st_dev))
-	    >= sizeof(path)) {
-		printf("%s: Pathname is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-	if (read_file(path, buf, sizeof(buf)) < 0) {
-		perror("read_file(read_num)");
-		exit(EXIT_FAILURE);
-	}
+	    >= sizeof(path))
+		ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
+	if (read_file(path, buf, sizeof(buf)) < 0)
+		ksft_exit_fail_perror("read_file(read_num)");
    if (strstr(buf, "DEVTYPE=disk")) {
        /* Found it */
        if (snprintf(finfo.dev_queue_read_ahead_path,
                 sizeof(finfo.dev_queue_read_ahead_path),
                 "/sys/dev/block/%d:%d/queue/read_ahead_kb",
                 major(path_stat.st_dev), minor(path_stat.st_dev))
-		    >= sizeof(finfo.dev_queue_read_ahead_path)) {
-			printf("%s: Pathname is too long\n", __func__);
-			exit(EXIT_FAILURE);
-		}
+		    >= sizeof(finfo.dev_queue_read_ahead_path))
+			ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
        return;
    }
-	if (!strstr(buf, "DEVTYPE=partition")) {
-		printf("%s: Unknown device type: %s\n", __func__, path);
-		exit(EXIT_FAILURE);
-	}
+	if (!strstr(buf, "DEVTYPE=partition"))
+		ksft_exit_fail_msg("%s: Unknown device type: %s\n", __func__, path);
    /*
     * Partition of block device - need to find actual device.
     * Using naming convention that devnameN is partition of
     * device devname.
     */
    str = strstr(buf, "DEVNAME=");
-	if (!str) {
-		printf("%s: Could not read: %s", __func__, path);
-		exit(EXIT_FAILURE);
-	}
+	if (!str)
+		ksft_exit_fail_msg("%s: Could not read: %s", __func__, path);
    str += 8;
    end = str;
    while (*end) {
@@ -207,16 +195,13 @@ static void get_finfo(const char *dir)
            if (snprintf(finfo.dev_queue_read_ahead_path,
                     sizeof(finfo.dev_queue_read_ahead_path),
                     "/sys/block/%s/queue/read_ahead_kb",
-				     str) >= sizeof(finfo.dev_queue_read_ahead_path)) {
-				printf("%s: Pathname is too long\n", __func__);
-				exit(EXIT_FAILURE);
-			}
+				     str) >= sizeof(finfo.dev_queue_read_ahead_path))
+				ksft_exit_fail_msg("%s: Pathname is too long\n", __func__);
            return;
        }
        ++end;
    }
-	printf("%s: Could not read: %s\n", __func__, path);
-	exit(EXIT_FAILURE);
+	ksft_exit_fail_msg("%s: Could not read: %s\n", __func__, path);
 }
 
 static bool check_swap(void *addr, unsigned long size)
@@ -229,26 +214,19 @@ static bool check_swap(void *addr, unsigned long size)
 
    ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "%08lx-",
               (unsigned long) addr);
-	if (ret >= MAX_LINE_LENGTH) {
-		printf("%s: Pattern is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
-
+	if (ret >= MAX_LINE_LENGTH)
+		ksft_exit_fail_msg("%s: Pattern is too long\n", __func__);
 
    fp = fopen(PID_SMAPS, "r");
-	if (!fp) {
-		printf("%s: Failed to open file %s\n", __func__, PID_SMAPS);
-		exit(EXIT_FAILURE);
-	}
+	if (!fp)
+		ksft_exit_fail_msg("%s: Failed to open file %s\n", __func__, PID_SMAPS);
    if (!check_for_pattern(fp, addr_pattern, buffer, sizeof(buffer)))
        goto err_out;
 
    ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "Swap:%19ld kB",
               size >> 10);
-	if (ret >= MAX_LINE_LENGTH) {
-		printf("%s: Pattern is too long\n", __func__);
-		exit(EXIT_FAILURE);
-	}
+	if (ret >= MAX_LINE_LENGTH)
+		ksft_exit_fail_msg("%s: Pattern is too long\n", __func__);
    /*
     * Fetch the Swap: in the same block and check whether it got
     * the expected number of hugeepages next.
@@ -271,10 +249,8 @@ static void *alloc_mapping(int nr)
 
    p = mmap(BASE_ADDR, nr * hpage_pmd_size, PROT_READ | PROT_WRITE,
         MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-	if (p != BASE_ADDR) {
-		printf("Failed to allocate VMA at %p\n", BASE_ADDR);
-		exit(EXIT_FAILURE);
-	}
+	if (p != BASE_ADDR)
+		ksft_exit_fail_msg("Failed to allocate VMA at %p\n", BASE_ADDR);
 
    return p;
 }
@@ -324,19 +300,13 @@ static void *alloc_hpage(struct mem_ops *ops)
     * khugepaged on low-load system (like a test machine), which
     * would cause MADV_COLLAPSE to fail with EAGAIN.
     */
-	printf("Allocate huge page...");
-	if (madvise_collapse_retry(p, hpage_pmd_size)) {
-		perror("madvise(MADV_COLLAPSE)");
-		exit(EXIT_FAILURE);
-	}
-	if (!ops->check_huge(p, 1)) {
-		perror("madvise(MADV_COLLAPSE)");
-		exit(EXIT_FAILURE);
-	}
-	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE)) {
-		perror("madvise(MADV_HUGEPAGE)");
-		exit(EXIT_FAILURE);
-	}
+	ksft_print_msg("Allocate huge page...");
+	if (madvise_collapse_retry(p, hpage_pmd_size))
+		ksft_exit_fail_perror("madvise(MADV_COLLAPSE)");
+	if (!ops->check_huge(p, 1))
+		ksft_exit_fail_perror("madvise(MADV_COLLAPSE)");
+	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
    success("OK");
    return p;
 }
@@ -346,11 +316,9 @@ static void validate_memory(int *p, unsigned long start, unsigned long end)
    int i;
 
    for (i = start / page_size; i < end / page_size; i++) {
-		if (p[i * page_size / sizeof(*p)] != i + 0xdead0000) {
-			printf("Page %d is corrupted: %#x\n",
-					i, p[i * page_size / sizeof(*p)]);
-			exit(EXIT_FAILURE);
-		}
+		if (p[i * page_size / sizeof(*p)] != i + 0xdead0000)
+			ksft_exit_fail_msg("Page %d is corrupted: %#x\n",
+					   i, p[i * page_size / sizeof(*p)]);
    }
 }
 
@@ -383,14 +351,12 @@ static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
    unsigned long size;
 
    unlink(finfo.path);  /* Cleanup from previous failed tests */
-	printf("Creating %s for collapse%s...", finfo.path,
-	       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
+	ksft_print_msg("Creating %s for collapse%s...", finfo.path,
+		       finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
    fd = open(finfo.path, O_CREAT | O_RDWR | O_TRUNC | O_EXCL,
          777);
-	if (fd < 0) {
-		perror("open()");
-		exit(EXIT_FAILURE);
-	}
+	if (fd < 0)
+		ksft_exit_fail_perror("open()");
 
    size = nr_hpages * hpage_pmd_size;
    if (ftruncate(fd, size)) {
@@ -411,22 +377,17 @@ static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
    close(fd);
    munmap(p, size);
    success("OK");
-
-	printf("Opening %s %s for collapse...", finfo.path,
+	ksft_print_msg("Opening %s %s for collapse...", finfo.path,
           setup == FILE_SETUP_READ_ONLY_FS ? "read-only" :
           setup == FILE_SETUP_READ_WRITE_FS_READ_DATA ?
                          "read-write (read)" :
                          "read-write (write)");
    finfo.fd = open(finfo.path, open_opt, 777);
-	if (finfo.fd < 0) {
-		perror("open()");
-		exit(EXIT_FAILURE);
-	}
+	if (finfo.fd < 0)
+		ksft_exit_fail_perror("open()");
    p = mmap(BASE_ADDR, size, mmap_prot, MAP_SHARED, finfo.fd, 0);
-	if (p == MAP_FAILED || p != BASE_ADDR) {
-		perror("mmap()");
-		exit(EXIT_FAILURE);
-	}
+	if (p == MAP_FAILED || p != BASE_ADDR)
+		ksft_exit_fail_perror("mmap()");
 
    /* Drop page cache */
    write_file("/proc/sys/vm/drop_caches", "3", 2);
@@ -458,10 +419,8 @@ static void file_cleanup_area(void *p, unsigned long size)
 
 static void file_fault_read(void *p, unsigned long start, unsigned long end)
 {
-	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {
-		perror("madvise(MADV_POPULATE_READ)");
-		exit(EXIT_FAILURE);
-	}
+	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ))
+		ksft_exit_fail_perror("madvise(MADV_POPULATE_READ)");
 }
 
 static void file_fault_read_and_flush(void *p, unsigned long start, unsigned long end)
@@ -476,10 +435,8 @@ static void file_fault_read_and_flush(void *p, unsigned long start, unsigned lon
 
 static void file_fault_write(void *p, unsigned long start, unsigned long end)
 {
-	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_WRITE)) {
-		perror("madvise(MADV_POPULATE_WRITE)");
-		exit(EXIT_FAILURE);
-	}
+	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_WRITE))
+		ksft_exit_fail_perror("madvise(MADV_POPULATE_WRITE)");
 }
 
 static bool file_check_huge(void *addr, int nr_hpages)
@@ -501,20 +458,14 @@ static void *shmem_setup_area(int nr_hpages)
    unsigned long size = nr_hpages * hpage_pmd_size;
 
    finfo.fd = memfd_create("khugepaged-selftest-collapse-shmem", 0);
-	if (finfo.fd < 0)  {
-		perror("memfd_create()");
-		exit(EXIT_FAILURE);
-	}
-	if (ftruncate(finfo.fd, size)) {
-		perror("ftruncate()");
-		exit(EXIT_FAILURE);
-	}
+	if (finfo.fd < 0)
+		ksft_exit_fail_perror("memfd_create()");
+	if (ftruncate(finfo.fd, size))
+		ksft_exit_fail_perror("ftruncate()");
    p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE, MAP_SHARED, finfo.fd,
         0);
-	if (p != BASE_ADDR) {
-		perror("mmap()");
-		exit(EXIT_FAILURE);
-	}
+	if (p != BASE_ADDR)
+		ksft_exit_fail_perror("mmap()");
    return p;
 }
 
@@ -588,7 +539,7 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
    int ret;
    struct thp_settings settings = *thp_current_settings();
 
-	printf("%s...", msg);
+	ksft_print_msg("%s...", msg);
 
    /*
     * read&write file collapse succeeds for MADV_COLLAPSE because dirty
@@ -621,10 +572,8 @@ static void madvise_collapse(const char *msg, char *p, int nr_hpages,
                 struct mem_ops *ops, bool expect)
 {
    /* Sanity check */
-	if (!ops->check_huge(p, 0)) {
-		printf("Unexpected huge page\n");
-		exit(EXIT_FAILURE);
-	}
+	if (!ops->check_huge(p, 0))
+		ksft_exit_fail_msg("Unexpected huge page\n");
    __madvise_collapse(msg, p, nr_hpages, ops, expect);
 }
 
@@ -636,17 +585,15 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
    int timeout = 6; /* 3 seconds */
 
    /* Sanity check */
-	if (!ops->check_huge(p, 0)) {
-		printf("Unexpected huge page\n");
-		exit(EXIT_FAILURE);
-	}
+	if (!ops->check_huge(p, 0))
+		ksft_exit_fail_msg("Unexpected huge page\n");
 
    madvise(p, nr_hpages * hpage_pmd_size, MADV_HUGEPAGE);
 
    /* Wait until the second full_scan completed */
    full_scans = thp_read_num("khugepaged/full_scans") + 2;
 
-	printf("%s...", msg);
+	ksft_print_msg("%s...", msg);
    while (timeout--) {
        if (ops->check_huge(p, nr_hpages))
            break;
@@ -713,7 +660,7 @@ static void alloc_at_fault(void)
 
    p = alloc_mapping(1);
    *p = 1;
-	printf("Allocate huge page on fault...");
+	ksft_print_msg("Allocate huge page on fault...");
    if (check_huge_anon(p, 1, hpage_pmd_size))
        success("OK");
    else
@@ -722,12 +669,14 @@ static void alloc_at_fault(void)
    thp_pop_settings();
 
    madvise(p, page_size, MADV_DONTNEED);
-	printf("Split huge PMD on MADV_DONTNEED...");
+	ksft_print_msg("Split huge PMD on MADV_DONTNEED...");
    if (check_huge_anon(p, 0, hpage_pmd_size))
        success("OK");
    else
        fail("Fail");
    munmap(p, hpage_pmd_size);
+
+	ksft_test_result_report(exit_status, "allocate on fault and split\n");
 }
 
 static void collapse_full(struct collapse_context *c, struct mem_ops *ops)
@@ -742,6 +691,8 @@ static void collapse_full(struct collapse_context *c, struct mem_ops *ops)
            ops, true);
    validate_memory(p, 0, size);
    ops->cleanup_area(p, size);
+
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_empty(struct collapse_context *c, struct mem_ops *ops)
@@ -751,6 +702,7 @@ static void collapse_empty(struct collapse_context *c, struct mem_ops *ops)
    p = ops->setup_area(1);
    c->collapse("Do not collapse empty PTE table", p, 1, ops, false);
    ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_single_pte_entry(struct collapse_context *c, struct mem_ops *ops)
@@ -762,6 +714,7 @@ static void collapse_single_pte_entry(struct collapse_context *c, struct mem_ops
    c->collapse("Collapse PTE table with single PTE entry present", p,
            1, ops, true);
    ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_max_ptes_none(struct collapse_context *c, struct mem_ops *ops)
@@ -801,6 +754,7 @@ static void collapse_max_ptes_none(struct collapse_context *c, struct mem_ops *o
 skip:
    ops->cleanup_area(p, hpage_pmd_size);
    thp_pop_settings();
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_ops *ops)
@@ -810,11 +764,9 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
    p = ops->setup_area(1);
    ops->fault(p, 0, hpage_pmd_size);
 
-	printf("Swapout one page...");
-	if (madvise(p, page_size, MADV_PAGEOUT)) {
-		perror("madvise(MADV_PAGEOUT)");
-		exit(EXIT_FAILURE);
-	}
+	ksft_print_msg("Swapout one page...");
+	if (madvise(p, page_size, MADV_PAGEOUT))
+		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
    if (check_swap(p, page_size)) {
        success("OK");
    } else {
@@ -827,6 +779,7 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
    validate_memory(p, 0, hpage_pmd_size);
 out:
    ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *ops)
@@ -837,11 +790,9 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
    p = ops->setup_area(1);
    ops->fault(p, 0, hpage_pmd_size);
 
-	printf("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
-	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT)) {
-		perror("madvise(MADV_PAGEOUT)");
-		exit(EXIT_FAILURE);
-	}
+	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
+	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT))
+		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
    if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
        success("OK");
    } else {
@@ -855,12 +806,10 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 
    if (c->enforce_pte_scan_limits) {
        ops->fault(p, 0, hpage_pmd_size);
-		printf("Swapout %d of %d pages...", max_ptes_swap,
+		ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap,
               hpage_pmd_nr);
-		if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT)) {
-			perror("madvise(MADV_PAGEOUT)");
-			exit(EXIT_FAILURE);
-		}
+		if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT))
+			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
        if (check_swap(p, max_ptes_swap * page_size)) {
            success("OK");
        } else {
@@ -874,6 +823,7 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
    }
 out:
    ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_single_pte_entry_compound(struct collapse_context *c, struct mem_ops *ops)
@@ -890,7 +840,7 @@ static void collapse_single_pte_entry_compound(struct collapse_context *c, struc
    }
 
    madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
-	printf("Split huge page leaving single PTE mapping compound page...");
+	ksft_print_msg("Split huge page leaving single PTE mapping compound page...");
    madvise(p + page_size, hpage_pmd_size - page_size, MADV_DONTNEED);
    if (ops->check_huge(p, 0))
        success("OK");
@@ -902,6 +852,7 @@ static void collapse_single_pte_entry_compound(struct collapse_context *c, struc
    validate_memory(p, 0, page_size);
 skip:
    ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_full_of_compound(struct collapse_context *c, struct mem_ops *ops)
@@ -909,7 +860,7 @@ static void collapse_full_of_compound(struct collapse_context *c, struct mem_ops
    void *p;
 
    p = alloc_hpage(ops);
-	printf("Split huge page leaving single PTE page table full of compound pages...");
+	ksft_print_msg("Split huge page leaving single PTE page table full of compound pages...");
    madvise(p, page_size, MADV_NOHUGEPAGE);
    madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
    if (ops->check_huge(p, 0))
@@ -921,6 +872,7 @@ static void collapse_full_of_compound(struct collapse_context *c, struct mem_ops
            true);
    validate_memory(p, 0, hpage_pmd_size);
    ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops *ops)
@@ -929,16 +881,12 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
    int i;
 
    p = ops->setup_area(1);
+	ksft_print_msg("Construct PTE page table full of different PTE-mapped compound pages\n");
    for (i = 0; i < hpage_pmd_nr; i++) {
-		printf("\rConstruct PTE page table full of different PTE-mapped compound pages %3d/%d...",
-				i + 1, hpage_pmd_nr);
-
        madvise(BASE_ADDR, hpage_pmd_size, MADV_HUGEPAGE);
        ops->fault(BASE_ADDR, 0, hpage_pmd_size);
-		if (!ops->check_huge(BASE_ADDR, 1)) {
-			printf("Failed to allocate huge page\n");
-			exit(EXIT_FAILURE);
-		}
+		if (!ops->check_huge(BASE_ADDR, 1))
+			ksft_exit_fail_msg("Failed to allocate huge page\n");
        madvise(BASE_ADDR, hpage_pmd_size, MADV_NOHUGEPAGE);
 
        p = mremap(BASE_ADDR - i * page_size,
@@ -946,20 +894,16 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
                (i + 1) * page_size,
                MREMAP_MAYMOVE | MREMAP_FIXED,
                BASE_ADDR + 2 * hpage_pmd_size);
-		if (p == MAP_FAILED) {
-			perror("mremap+unmap");
-			exit(EXIT_FAILURE);
-		}
+		if (p == MAP_FAILED)
+			ksft_exit_fail_perror("mremap+unmap");
 
        p = mremap(BASE_ADDR + 2 * hpage_pmd_size,
                (i + 1) * page_size,
                (i + 1) * page_size + hpage_pmd_size,
                MREMAP_MAYMOVE | MREMAP_FIXED,
                BASE_ADDR - (i + 1) * page_size);
-		if (p == MAP_FAILED) {
-			perror("mremap+alloc");
-			exit(EXIT_FAILURE);
-		}
+		if (p == MAP_FAILED)
+			ksft_exit_fail_perror("mremap+alloc");
    }
 
    ops->cleanup_area(BASE_ADDR, hpage_pmd_size);
@@ -974,6 +918,7 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
 
    validate_memory(p, 0, hpage_pmd_size);
    ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
@@ -983,18 +928,17 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 
    p = ops->setup_area(1);
 
-	printf("Allocate small page...");
+	ksft_print_msg("Allocate small page...");
    ops->fault(p, 0, page_size);
    if (ops->check_huge(p, 0))
        success("OK");
    else
        fail("Fail");
 
-	printf("Share small page over fork()...");
+	ksft_print_msg("Share small page over fork()...");
    if (!fork()) {
        /* Do not touch settings on child exit */
        skip_settings_restore = true;
-		exit_status = 0;
 
        if (ops->check_huge(p, 0))
            success("OK");
@@ -1011,15 +955,16 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
    }
 
    wait(&wstatus);
-	exit_status += WEXITSTATUS(wstatus);
+	exit_status = WEXITSTATUS(wstatus);
 
-	printf("Check if parent still has small page...");
+	ksft_print_msg("Check if parent still has small page...");
    if (ops->check_huge(p, 0))
        success("OK");
    else
        fail("Fail");
    validate_memory(p, 0, page_size);
    ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *ops)
@@ -1028,18 +973,17 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
    void *p;
 
    p = alloc_hpage(ops);
-	printf("Share huge page over fork()...");
+	ksft_print_msg("Share huge page over fork()...");
    if (!fork()) {
        /* Do not touch settings on child exit */
        skip_settings_restore = true;
-		exit_status = 0;
 
        if (ops->check_huge(p, 1))
            success("OK");
        else
            fail("Fail");
 
-		printf("Split huge page PMD in child process...");
+		ksft_print_msg("Split huge page PMD in child process...");
        madvise(p, page_size, MADV_NOHUGEPAGE);
        madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
        if (ops->check_huge(p, 0))
@@ -1060,15 +1004,16 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
    }
 
    wait(&wstatus);
-	exit_status += WEXITSTATUS(wstatus);
+	exit_status = WEXITSTATUS(wstatus);
 
-	printf("Check if parent still has huge page...");
+	ksft_print_msg("Check if parent still has huge page...");
    if (ops->check_huge(p, 1))
        success("OK");
    else
        fail("Fail");
    validate_memory(p, 0, hpage_pmd_size);
    ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops *ops)
@@ -1078,18 +1023,17 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
    void *p;
 
    p = alloc_hpage(ops);
-	printf("Share huge page over fork()...");
+	ksft_print_msg("Share huge page over fork()...");
    if (!fork()) {
        /* Do not touch settings on child exit */
        skip_settings_restore = true;
-		exit_status = 0;
 
        if (ops->check_huge(p, 1))
            success("OK");
        else
            fail("Fail");
 
-		printf("Trigger CoW on page %d of %d...",
+		ksft_print_msg("Trigger CoW on page %d of %d...",
                hpage_pmd_nr - max_ptes_shared - 1, hpage_pmd_nr);
        ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared - 1) * page_size);
        if (ops->check_huge(p, 0))
@@ -1101,7 +1045,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
                1, ops, !c->enforce_pte_scan_limits);
 
        if (c->enforce_pte_scan_limits) {
-			printf("Trigger CoW on page %d of %d...",
+			ksft_print_msg("Trigger CoW on page %d of %d...",
                   hpage_pmd_nr - max_ptes_shared, hpage_pmd_nr);
            ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared) *
                    page_size);
@@ -1120,15 +1064,16 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
    }
 
    wait(&wstatus);
-	exit_status += WEXITSTATUS(wstatus);
+	exit_status = WEXITSTATUS(wstatus);
 
-	printf("Check if parent still has huge page...");
+	ksft_print_msg("Check if parent still has huge page...");
    if (ops->check_huge(p, 1))
        success("OK");
    else
        fail("Fail");
    validate_memory(p, 0, hpage_pmd_size);
    ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void madvise_collapse_existing_thps(struct collapse_context *c,
@@ -1145,6 +1090,7 @@ static void madvise_collapse_existing_thps(struct collapse_context *c,
    __madvise_collapse("Re-collapse PMD-mapped hugepage", p, 1, ops, true);
    validate_memory(p, 0, hpage_pmd_size);
    ops->cleanup_area(p, hpage_pmd_size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 /*
@@ -1172,6 +1118,7 @@ static void madvise_retracted_page_tables(struct collapse_context *c,
            true);
    validate_memory(p, 0, size);
    ops->cleanup_area(p, size);
+	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
 static void usage(void)
@@ -1280,10 +1227,8 @@ static int nr_test_cases;
 
 #define TEST(t, c, o) do {						\
    if (c && o) {							\
-		if (nr_test_cases >= MAX_TEST_CASES) {			\
-			printf("MAX_TEST_CASES is too small\n");	\
-			exit(EXIT_FAILURE);				\
-		}							\
+		if (nr_test_cases >= MAX_TEST_CASES)			\
+			ksft_exit_fail_msg("MAX_TEST_CASES is too small\n"); \
        test_cases[nr_test_cases++] = (struct test_case){	\
            .ctx	= c,					\
            .ops	= o,					\
@@ -1316,10 +1261,10 @@ int main(int argc, char **argv)
        .read_ahead_kb = 0,
    };
 
-	if (!thp_is_enabled()) {
-		printf("Transparent Hugepages not available\n");
-		return KSFT_SKIP;
-	}
+	ksft_print_header();
+
+	if (!thp_is_enabled())
+		ksft_exit_skip("Transparent Hugepages not available\n");
 
    parse_test_type(argc, argv);
 
@@ -1327,10 +1272,8 @@ int main(int argc, char **argv)
 
    page_size = getpagesize();
    hpage_pmd_size = read_pmd_pagesize();
-	if (!hpage_pmd_size) {
-		printf("Reading PMD pagesize failed");
-		exit(EXIT_FAILURE);
-	}
+	if (!hpage_pmd_size)
+		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
    hpage_pmd_nr = hpage_pmd_size / page_size;
    hpage_pmd_order = __builtin_ctz(hpage_pmd_nr);
 
@@ -1346,8 +1289,6 @@ int main(int argc, char **argv)
    save_settings();
    thp_push_settings(&default_settings);
 
-	alloc_at_fault();
-
    TEST(collapse_full, khugepaged_context, anon_ops);
    TEST(collapse_full, khugepaged_context, read_only_file_ops);
    TEST(collapse_full, khugepaged_context, read_write_file_read_ops);
@@ -1425,11 +1366,13 @@ int main(int argc, char **argv)
    TEST(madvise_retracted_page_tables, madvise_context, read_write_file_read_ops);
    TEST(madvise_retracted_page_tables, madvise_context, shmem_ops);
 
-	exit_status = KSFT_PASS;
+	ksft_set_plan(nr_test_cases + 1);
+
+	alloc_at_fault();
    for (int i = 0; i < nr_test_cases; i++) {
        struct test_case *t = &test_cases[i];
 
-		printf("\nRun test: %s (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
+		ksft_print_msg("\nRun test: %s (%s:%s)\n", t->desc, t->ctx->name, t->ops->name);
        t->fn(t->ctx, t->ops);
    }
 
-- 
2.53.0



Zi Yan (14):
  mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
  mm/khugepaged: add folio dirty check after try_to_unmap()
  mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
  mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in hugepage_enabled()
  mm: remove READ_ONLY_THP_FOR_FS Kconfig option
  mm: fs: remove filemap_nr_thps*() functions and their users
  fs: remove nr_thps from struct address_space
  mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
  mm/truncate: use folio_split() in truncate_inode_partial_folio()
  fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
  selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
  selftests/mm: remove READ_ONLY_THP_FOR_FS code from guard-regions
  mm/khugepaged: enable clean pagecache folio collapse for writable
    files
  selftests/mm: add writable-file collapse tests for khugepaged

 fs/btrfs/defrag.c                          |   3 -
 fs/inode.c                                 |   3 -
 fs/open.c                                  |  27 ---
 include/linux/fs.h                         |   5 -
 include/linux/huge_mm.h                    |  25 +--
 include/linux/pagemap.h                    |  50 +++---
 include/linux/shmem_fs.h                   |   2 +-
 mm/Kconfig                                 |  11 --
 mm/filemap.c                               |   1 -
 mm/huge_memory.c                           |  39 +----
 mm/khugepaged.c                            | 107 ++++++------
 mm/truncate.c                              |   8 +-
 tools/testing/selftests/mm/guard-regions.c |  18 +-
 tools/testing/selftests/mm/khugepaged.c    | 184 ++++++++++++++++-----
 tools/testing/selftests/mm/run_vmtests.sh  |  12 +-
 15 files changed, 254 insertions(+), 241 deletions(-)

--
2.53.0

