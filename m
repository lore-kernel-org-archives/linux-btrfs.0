Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010067.outbound.protection.outlook.com [40.93.198.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E3A334C39;
	Sat, 18 Apr 2026 02:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776480294; cv=fail; b=OVI4g2DEs3i6Kq/sY2RTmKNn0V/6i+VbYh6Bk042yrN0oA/hRmjbrWBNaPoa1UdgXMMuEcHaC6NgF1i4Uxhh0xBiGODucYa3+ZrkwmN/mbW/d1utFajbUngmapALU9C8H0sDx/fdV57vxoceaQMZyj3kIjBRl8Jpc/fEfO2nTZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776480294; c=relaxed/simple;
	bh=zOhpFryq6KZuw8JHSxKAxs2WTds1NYEakOKHnG9oFIw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=SItbgOZVgZkEQvXVACJN8QZ9ENCn989TRQeHuuKZQU2EXdg4rCtLOfKx9kDbJ66ariDPydUaGs8L5Z83KPUOKgZ5PaZjmb/UNmqfq+8w4FeXlXg0S32c1aEvjS71MCPO/tLnAD2CU4WkafvH72hPMzt9hFeVASlDCFMRjQIWhoA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y6SwOyRL; arc=fail smtp.client-ip=40.93.198.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y6SwOyRL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=juWremLv5GVHm8qQJip4VSTJfySUAwBfEUuDu2tIkJqUFSxFFu1j5t29r30nQ9GsH/ZgYToDvFiUUstbNLoTO9OIBKSfQz37gyBfUKMk+kGmGx1WJc4YoD6lWxmaFjzVDC7EbFTkSLokgH6qjLtka4YscXVQWOGqVIuBDsgRpQLPrlonlAQWupufAjYxoECpAJCQLGwTOzh+in5VtRUf9mQQ8tHKrbuz4I606+FYuB6sEgVSpkiy/OglPsSlLMfL1Q2Qd7YOY3iUzEJ3sT08AMa97SLNSPdclCydsCJqvOwS5gc1V5pbUY321SWTNvqx79EaSJu4sNzSgf+loLZR9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPx2RCfeczoVsE6yMqzxeRzHwu8NfLHfqg0KzPF1Cco=;
 b=aDYl+uIMEeWTaAEzZPgXGyHZXKJNL3gyjQv+GCJxAHuPhUe8+1Z2lUkkSOte9M2MtC2kn2eRoJFEVUYzbF/jJcHhiLiS5AMyE+P8pE3teO7UD5QEhGHgVaKRL3IwyQUkIhlyCOx8xWkgIK2560shSJNgM61FoLPwGfxXo1B7dVeLfAzPfVR+sj91WEd2Ui/MQkDt/+o2g8z2H5YxbjQbgGC91uj8y3Vd0SGrtbXlkZBkx2oLGJUGBj3GkDbGyvYy0lXlF8817oX4fSd79+mxaReQpVR6J/ntUqylTKYh5ZeHrHQIcEnCFy7WuOGhc0yCrXUwqVAxyHpGVO5fziZMAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPx2RCfeczoVsE6yMqzxeRzHwu8NfLHfqg0KzPF1Cco=;
 b=Y6SwOyRLUV5s+4yVRDbQP+RKFeXS+HID7tuh/oJKfWMHQGazpQg/fg+7iWNzkBdCdzCloxw/Jpvnvzp+VTbaOHDTBjuOlh3CGq2twtpFwIR7T6nDPqk0TjPaZXbrYK1MOTO9bAduxcmLZL5qs8IvfLQK5mUjuSzEtp8BQ1qDGyO/FiH6KR1kSSweA05b8vypF3MtZ7kXrqjTmdBatgOylRZU9JZSD/J0QQWrKRkO6I+y9peFMsbUkWwEM2H10+Mxdv5+AcQL5xkdlq1LmOw+mGodXf/3yC6eJ9ljGd4Ut50VyIPkvB8/gnW4qRfBmNhxrRPheath95oU5eHs47ndwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Sat, 18 Apr
 2026 02:44:39 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Sat, 18 Apr 2026
 02:44:32 +0000
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
Subject: [PATCH 7.2 v3 00/12] Remove read-only THP support for FSes without large folio support
Date: Fri, 17 Apr 2026 22:44:17 -0400
Message-ID: <20260418024429.4055056-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0180.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: d99e2a34-4a71-4ae4-9981-08de9cf46b7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	s0ltYWCAjXfDQTSaNSQ9+oyuM3y+C7iSU3Oq8nsTaVAPZ7V6Sh8JGkGM6rf25isBV1J9w3fu5miKZ5/vKDdYkHdTTh9twuJjH3XxQqjdh/OQ6rGNoHLyP0qvvUZ71YBEZR6ooQr+5rwPEd2Szu7d0F97NNL8TulK67zbZgJaGvKGkFSxKjgdtKg3kBo/Q4/oDQGUYOGtQIJyoF4qf1zh5dov6cVjWmnj4grW39VT1dndU3usuXOpLZbpSAXtSjHUix0mgyaNAnhLHtclmdZ15N5HS4SW75T7rL0YyriVYOsWxBjNYa9r0rgtlqUeXJe4IYuWJOGwId/pH0dYDyX+l+PMJwVag3iiTjIbORsET6cNEP+5y5+xra6iKEPAPCgcYhyBcp+qTOv8wP37jqlYtemv3NQzzSyk4ORYvSJEjqEJ9Epn4185FYUbjwpmh4Cpc4k4YX4Q7zL3LnwueU0+TN0Q+R9bgIQS/SVZ/S+SVRZEw6UHwL/t98CfTyw92wWDGApQKPF4a6IMAIINrQtxJlhwgZejGwpBx+dGjJ0OP6zky/w/7igVRE5SNAtAtXS7whA+dqmn0AyKOmDbSXnTtKaoWbXXgxafeXs35G5Ll6HOABZ18BsGSXeyqJZoKU7NnO1yS8Fq/8p9LzyEm4YFmSSlTiXhb3+mQ9ntUuMBKlMKARtzwOsmN0f6lIWd2sUeKATOCQDCiALbpuLgwM4BvsC52fZOs1vO355gtZ7L+xo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTJoVVB4ZUgvOEt6TFROT3E5bHFIQ2lxRUQ2OFdxanA3U1NoZEJCOGpVOXdl?=
 =?utf-8?B?QXBYTi9KTnlDZklzSDg4bXpBVVc3M1FKL1d2MnZ2RGhuMGI2aVdLaDFicmpz?=
 =?utf-8?B?cTVFUDBIbEpDUG5BWW5HZ3Jua2RSejdPK1U1YVZzLzBhTXh3a1RwT3hBczVL?=
 =?utf-8?B?OElVV0pZQko2eDl6QTRTYUJmNzh6TU8yaWx6Z2t4NGx4RVozL1BkUkZlTEpR?=
 =?utf-8?B?eVRncWEyTWNjK3FUd3BNOVBIY1F1aTYxNUpVMk4vYXVYbFZQdVI5WnJVd1Fp?=
 =?utf-8?B?NEdIOFhoL0lOSjlJNUd3L2VDOEZqdzdYTXgrZEJtNGs5ZXlRNW9oN1UreXEr?=
 =?utf-8?B?MTFIa2lwUzBFS1o4RjJtWGIxbWZzb0UzZ05JeEZTMFJuQ0R0cG9oclRXNTVT?=
 =?utf-8?B?NUFHcnBGemJNTW15aGkyNFpoYmNwaTNwYTdLVmdmQnBGeHV2QkFlTlZRL1BT?=
 =?utf-8?B?Ty8yRUpnMmQ1MEM3WTBHdHpjK0E1TGlHblRJZkgyeXhqRytuajZmV3hNZ0FV?=
 =?utf-8?B?RnJzaWtiWThhT0kvUXcwdnF5MXEyUkVnOXVXWHJSc1pmVVN2WDhkZk1SN0cx?=
 =?utf-8?B?VjlhYTQvWHliUDd6THdpbGwwNHJHZmtWU24zYXp4cXlFVXJ5ME9NL0orMXhj?=
 =?utf-8?B?TGRtVTFMeGFLd1llOW0vbm5rQ2hkT0lodWhzaWRBTlFZbno2NTBwUTRJSkwy?=
 =?utf-8?B?RjNFcm01YU1OWGh2WmJMUktnR3hWL1NIZEwxajRiZ25DZmpNQlR4anZ5VUpy?=
 =?utf-8?B?S3N2SFY0NDhkbExhYzB0eHBRUVBBZUU4eEdwOEo0cllKbDM2QVpwMjIrR21R?=
 =?utf-8?B?Z1lrdm5KL0JxcWJhRk45ZUFwUWFmUG9ic0h5OWtPaTEwemJOK25nNU4xWjFo?=
 =?utf-8?B?NGVFNUJ2N0UwbzRSSUVpcmVDbXI5TGF4MkpRVWhtZ2NHb0lCSkVLeXB0emcy?=
 =?utf-8?B?U0g5ZWxjMVBHT2hjc09qaDZiRUJWS3hrQUVmdE80emZ1YkZUb0haTDRSNUNP?=
 =?utf-8?B?ZDdGM0k5UHovVkNkT0tDbkpDWWtVVnF0K3J0RjViSHVkYzhiTnRYR3B4dlYy?=
 =?utf-8?B?aWdrTVQyK2FaS0hqdVQ5NmxpNmlUOVJKeDVqclloZGs3T0Y2bmtvYVM2dSsw?=
 =?utf-8?B?RXFlVlltMzBPS0l6WWVlKzBQNldkbGpwOEdxM1ZYMmhmbUlEZ2VGenBRN2tE?=
 =?utf-8?B?aHFLcEZmM3hTK2x5L0Y1MzFUdUkyUnd1RDV5QU1qdGRhc1V5V2ZyWVdxRFBv?=
 =?utf-8?B?Z05DcTZvTVV1R3d0Ny95Ylc3N0g2ZFZVSGVJTXRabWZQSGZPUkdnQ0c0WG1N?=
 =?utf-8?B?UHlCalhadXcwQ1o3bXg4U3VaRFRKQkRWamZ4Q3JVdW1TL2FRL2xFZXhpWUNI?=
 =?utf-8?B?YlNGUU9TUnZyRGVwRWlJK0NsR3Z3eEpRNGZQREgyR0pZTVk4TVhNTnhUclRI?=
 =?utf-8?B?ZGhtMVhrYWlsZkNhcHdXZjRZbE4veFk3dXh0bTlGd3JuU0MxbE5CbnVQVEhE?=
 =?utf-8?B?VzlpaEJJWE9LWjN3N1NaanQ1U1h6LzFYL0ViakpERHFKcEtYdXArRFIvR0gz?=
 =?utf-8?B?UUIyd2I1V2N6YWNFcVBJbUdoZC9zZ2RudWpTYkpjbFpLL1dpc2ZnY3czQTlK?=
 =?utf-8?B?amFuNzJiOFFVNmhUNDlwZFBrcitxTzJIc1JPNXljdDhqRjhlaTNkN0NOdUt4?=
 =?utf-8?B?UklyaDVHM05jdHhKeWVpdmN4V0tRZ0oxblYrMTY0THNqb2NKUDJORVZZSnNw?=
 =?utf-8?B?dUVFVCtmaTFTMmtaSytGVGRackNLV2tRempkVHg2d1ZzRkE5VjJ6Sm9BV04r?=
 =?utf-8?B?T1lrRDRWSEhGbE9XaHRpYXcyQTFnaEhHUTh6SlBZOGY4cm40TUhDNzVjUzBi?=
 =?utf-8?B?K1JCbGJlWk4wa0pOejRyQ3JsVklJcHdTdmMzMnZURmxKUFNTaUtJblZ3TW4r?=
 =?utf-8?B?a0YzQlFucnVuUHZOUWpydm93enE4dGZYYTVYT0hRb1VuV24ySEpsVjM3THl5?=
 =?utf-8?B?MFQxZ1V6dzhnS0ZIRWNzbkdjdlc2T2pUdHBYTlgzZmZKOTRGeEh1ZmpiTFZq?=
 =?utf-8?B?eWdyVmNqZGdzaXN1SmZmVXA3bnNzZyt4RXpDTkc2RE1MMjkyYytzSUVHY1Rh?=
 =?utf-8?B?Nmw1L0dGWlZEUFkva2VWZk5MWjdIMGRLbE16V2xJVmprb0JLRmxZL3h3SGtP?=
 =?utf-8?B?dXlWZnllMDdMVGlIaGo2d3pvM2NHS3VPQkxFOXBkSzh6bmxhUEI1VlFEY3dT?=
 =?utf-8?B?RXRhcFFuOExqWFN6M2FQTlBkWWplRGpwTFo1V0ludEg4OVBhSXg0TURpRDZl?=
 =?utf-8?Q?teyQbSd1yecgqfIUA7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d99e2a34-4a71-4ae4-9981-08de9cf46b7b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2026 02:44:32.3842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ecsXSaa2q2REQ0GIfaK0mX0lxg+Q8OZN3cKUI3SAdoAgoxEB53xb022e9OzVpAwm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650

Hi all,

This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
read-only THPs for FSes with large folio support (the supported orders
need to include PMD_ORDER) by default.

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
 large folio FSes          |     ✓     |       ✓       |      ✓     |
 no large folio FSes       |     x     |       x       |      x     |

This means no large folio FSes need to add large folio support (the
supported orders need to include PMD_ORDER), so that they can leverage
read-only THP creation function.

To prevent breaking read-only THP support for large folio FSes,
1. first 4 patches enables the support, so that without READ_ONLY_THP_FOR_FS,
   read-only THP still works for large folio FSes,
2. Patch 5 removes READ_ONLY_THP_FOR_FS Kconfig,
3. the rest of patches remove code related to READ_ONLY_THP_FOR_FS.


The overview of the changes is:

1. collapse_file() checks for to-be-collapsed folio dirtiness after they
   are locked, unmapped to make sure no new write happens. Before,
   mapping->nr_thps and inode->i_writecount are used to cause read-only
   THP truncation before a fd becomes writable.

2. hugepage_pmd_enabled() is true for anon, shmem, and file-backed cases
   if the global khugepaged control is on, otherwise, khugepaged for
   file-backed case is turned off and anon and shmem depend on per-size
   control knobs.

3. collapse_file() from mm/khugepaged.c, instead of checking
   CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order()
   of struct address_space of the file is at least PMD_ORDER.

4. file_thp_enabled() also checks mapping_max_folio_order() instead and
   no longer checks if the input file is opened as read-only (Change 1
   handles read-write files).

5. truncate_inode_partial_folio() calls folio_split() directly instead
   of the removed try_folio_split_to_order(), since large folios can
   only show up on a FS with large folio support.

6. nr_thps is removed from struct address_space, since it is no longer
   needed to drop all read-only THPs from a FS without large folio
   support when the fd becomes writable. Its related filemap_nr_thps*()
   are removed too.

7. folio_check_splittable() no longer checks READ_ONLY_THP_FOR_FS.

8. Updated comments in various places.


Changelog
===
From V2[3]:
1. removed unnecessary check in collapse_scan_file().

2. removed inode_is_open_for_write() check in file_thp_enabled().

3. changed hugepage_pmd_enabled() to return true if khugepaged global
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

2. removed READ_ONLY_THP_FOR_FS check in hugepage_pmd_enabled(), please
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

Zi Yan (12):
  mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
  mm/khugepaged: add folio dirty check after try_to_unmap()
  mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
  mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in
    hugepage_pmd_enabled()
  mm: remove READ_ONLY_THP_FOR_FS Kconfig option
  mm: fs: remove filemap_nr_thps*() functions and their users
  fs: remove nr_thps from struct address_space
  mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
  mm/truncate: use folio_split() in truncate_inode_partial_folio()
  fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
  selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
  selftests/mm: remove READ_ONLY_THP_FOR_FS code from guard-regions

 fs/btrfs/defrag.c                          |   3 -
 fs/inode.c                                 |   3 -
 fs/open.c                                  |  27 -----
 include/linux/fs.h                         |   5 -
 include/linux/huge_mm.h                    |  25 +----
 include/linux/pagemap.h                    |  35 ++-----
 include/linux/shmem_fs.h                   |   2 +-
 mm/Kconfig                                 |  11 ---
 mm/filemap.c                               |   1 -
 mm/huge_memory.c                           |  39 ++------
 mm/khugepaged.c                            |  86 ++++++++--------
 mm/truncate.c                              |   8 +-
 tools/testing/selftests/mm/guard-regions.c |  18 +---
 tools/testing/selftests/mm/khugepaged.c    | 110 +++++++++++++++------
 tools/testing/selftests/mm/run_vmtests.sh  |  12 ++-
 15 files changed, 156 insertions(+), 229 deletions(-)

-- 
2.43.0

