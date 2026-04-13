Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010065.outbound.protection.outlook.com [52.101.61.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19E120ED;
	Mon, 13 Apr 2026 19:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776108048; cv=fail; b=V24mUZttvOdOheMzYbUzjY8UHEZk+2v7PUDBmqg1OKMUYiTQGdg7IZXLGN1t8Yj0wwmTT9v81/hYO3wxMnCbT2+y7025Ihgr6/8IQXgDvwnVOU+bouzT3G987S6fv61T3ki+NBiMt6/K7v39oUFu8ZCUp6T3Tg9s+aLJ93wU3RI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776108048; c=relaxed/simple;
	bh=VmG1IBCm2KfHscaMP10M/qB/A9Urw7RfMOgcpuYCXQs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=nDAELmus6M3kpx86zr5zr2MqN7JQFeRn9jKdRGRwh/Sswv6wNMUBg7LGnzrFOilO+oeOPmIMiI8xKmGBZ+DxqwI06cd5Hg+tTaeo+qJQPQMZ0BhxfOczPk6gMHnXkrrYM43WeLzjmepqpZvSwbe9DaqkJi15czkKSyf2Sqt+CyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xv2UMWLL; arc=fail smtp.client-ip=52.101.61.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xv2UMWLL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zJ399AN1/NDQ/YGycCLEVWUs0Bea+c8rnG6LavNAVTn6xcaSSiUekP5AzngDakkMoRQ04nBd5wCAGzYdUMn0Mypr0rqWfgu2HA//0Y7ya18wIo7vO9/wu+q66LZIx9LCT12MB545cLdyppHzaH3wK/j7ovfgs+RfmLK6JsJqW+11Rvmvm6oOrp9Izu9e3DjSKNVvU2UiuvjPwS7HwZNUkZIXU9e+Q04GBkPekjly9K5BSbsSRrVkIj0uEpwXekKrIifrrdj1xXI1C6bh+tMYI8OhEpBbD1k/M/K1xgVQtWE/gZcJQhpSk2BkH2vqeEM9Js47ycTKOw33DzL3T91j9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/u4nYp+ho5bxb+rtFi1CEH9z4W2MfFMZgwB2c9fHc4Y=;
 b=CnaVnfGaeUimRejQVjNXF9HQqvbieE05bpZRQKwshaHj5qjN0IaDdgh9qHoEF2vIhLa9YRlTRpdG/yP3XJ4u2WpcBG4okWGF72WqUbxefd4UX9T+zCf4b0TG7RfjNv+LHZ0W49tbmQOSdPAm+zO6sFhv0JtSHyQ9YS3WhmGbL5VU0PGPsFAJnT+kT8H1MqM7aTaEajsgYchF83aF9IyU03nVTBf3+xV0P0cwNJ27LItpVNjUtZ8xM1j7IqmB+lzQoK9d7iBvUWSE3VdpAyRvqquIkERMvMvtY8COMx1zXDFXRy14dX8g3pXXtRvLwrFjeaeSiBpSbIvg3kzAs8Auow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/u4nYp+ho5bxb+rtFi1CEH9z4W2MfFMZgwB2c9fHc4Y=;
 b=Xv2UMWLL/1AITC2THDdMXr50TRd7MaXFSQfyOiRoNohVLIAL471PkHQ8GknP1kidAJTHbptEQQhYiAOTkypGlZq9GDCWKSQrjTV+g+G8gSMTj7WSBZLm3YnVOtLGVtH6VBaZlPR3ulcEGpITR6HBiFw0SUxaRUKczrz8M9N9cMK1EgIaRWYP4pXJlUDhXVDTRrzntvDzlQkpAY1kk4jrudodigidAtKh01mkYgwFSeW5fWNFHNAlnGhJ0t3N63TdgZQP31o7PE4dFPxGL104xFIas6/71ZvCm4ro1hVAgr21P/FQxckckfTYeQqKRfiC6r8UgMqPRp4NWp7l3G14EA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7986.namprd12.prod.outlook.com (2603:10b6:510:27d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Mon, 13 Apr
 2026 19:20:39 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:39 +0000
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
Subject: [PATCH 7.2 v2 00/12] Remove read-only THP support for FSes without large folio support
Date: Mon, 13 Apr 2026 15:20:18 -0400
Message-ID: <20260413192030.3275825-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P223CA0028.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7986:EE_
X-MS-Office365-Filtering-Correlation-Id: 001a8312-be1c-4dc5-190b-08de9991bf80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	qfKZjmJ+Lo9XyMPCH72QN6QeH4vf2ejZoscSDESK5ZYDtzAGwCzkwu1eDtlksRNnUdBHP1QcVwMtibH9uwwqum56oiEJoC8jvvuCX6wV096kbWl9QF+con3qO3CTBNj0sYwxxsgCAPxHvSXxBzwjbLhAoPa67snkcStbFJ418qYtgYNXXr5sSh1oNRArACTNLsau/nNgbqlzhOuRI5duLSMUvmzQ98kREqIpxyMtAgZnns3+aDfo/ro8vQpP+5P/+6gag/dc0qvAJsIl5ipuVf+OOz9buB7vwpKtXcZ0Pu5o2C6d2wUmeu/bkHz4fWjDt/4JwPjYE//UWCjj/YRwsSPNnMlxZdVEFO2MebQO4x32xS6O9xI1+J9qCpOQL+NKzjhOrqbfKJyyovXs2JMi4TDstCWtWBH/fntlT2Jcq1sXk170uTC8dJnXisoO71EM7nzJDdO1YoUnMBK2cgRs06LJeqkoeemVRKsX0gbrLtD7keUOr89kfqvH6wdCmYXUhkfESNiQayQreekViwj9e2ZO/u5xKAwIGiIpxdos2a35ukzgtQcZlLm7Mz8SdjpddqzElfC6g/hVUje9tSzR3b/PzQJkuUixvbnlgFmJQRyIzhBMRRUCSubVRxUwwm3LzfndV13nEjcVpwfFvJZmTJMxMhJyWNUclGVboc3Ka1Dk72onpFWeTSCFy5CbNIDzMmrV7lp3P6NJtFRdspc3P8UJyRgGRO3yA1patk2J1gQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZWYvM013Q0g1b3BrYW5pV1F0T0VyRllDNjc1Y3FpK0sxSjZqcHp2OUZ3SmEy?=
 =?utf-8?B?MFJleGhuaFhZL0doTmVWaVFtT1RxRStpREwzSWdMK1FNbUx3aEUrVW5sSzZZ?=
 =?utf-8?B?cTF4aUF4ZjJjMWc5cGdtQWhqSUd0WnpqeGs2SHhzM0NaVlRyNGFJRXdPZHFq?=
 =?utf-8?B?R1c3UjVjZnlHbUFMdkFRYklGVFhqWEFFSFJuRWpSZG9EeUZXTmlXU0JCY2lD?=
 =?utf-8?B?eFVWeDRNWGNRNnh4VU50THpoSW1QdGYrTTNlaWF0YWNkZERDdEpGMlVyU3NE?=
 =?utf-8?B?Z0h4U3ZDVFBoVnVrclhXZGEvU1ptYVJZTi9qanVFekRnTmJxTEJXODN6c0hK?=
 =?utf-8?B?S0tiTis2aDNwcXRXeDRudDZkMVh0bm5xVnhOR0g2UmN1dGZ4K1N0V0Q0TWhy?=
 =?utf-8?B?ZHNDeWdaWit5RS9Fa2NORU5CNGg4MGxwcUl2YTRIaTJRWmpqUFZ0NXdMS2N2?=
 =?utf-8?B?OHFvalFEemlTbHd0SnRNclB2TTVBR3hnRjZaY1BTUVdDL1lsdGN3R2w4OWFk?=
 =?utf-8?B?SEdwend6SEZIL1ZrL0F3bHZYNUd4UGtXa00rOWZJRzJkV1ZyL2htSzhUTGdC?=
 =?utf-8?B?bVAwNlVkT3Y5ZFVHb0REQnFqYWh4aEZMN1grdDZLOENJVGlpZXpPSkhtNDI4?=
 =?utf-8?B?R25CSWZORmpJdW1EdTYrRmR6THlaRUV2bktDT3oyZEVEbGYxZGFwa3JENUs3?=
 =?utf-8?B?WW9lZkNFUjF6VmNMa01wNkREVVd3bkJ2TU03bWxkM0d1dEUxMHQvSUJzSnJX?=
 =?utf-8?B?VzM5eHBWalpiT3F3SVMvUzIzcjF2SzZCbjN4cWpDdkZkMUtNVWlvd2lZUFVY?=
 =?utf-8?B?VEFWSVFxSmNIeGNNU21XdGZuSkZTTzBzRGZYRWo5MWpMRXdCWEdEbWNEQTQ0?=
 =?utf-8?B?WGkrb0pDN2FkWnNUWWhGbVJyTk0wMSs3Mlp5VkZJRVNHQ25idVJndVBub1kv?=
 =?utf-8?B?b3R4d09Cck94MlQ1TWVlWm00MzBHdGdCNThqN2RrMEZVOFVlM3VPWXQvbEdQ?=
 =?utf-8?B?b0hzNndmWXM1ZlJBRnJMVW5hQXE5VnZKZmY1UDV2Q0VGeXVlbjNqeVVOckFS?=
 =?utf-8?B?UlFqMVZreUpGN1puLzk3MStreWNhbmt6VWd3dW5BUjlDQ3pTNXJIdS9ocVNC?=
 =?utf-8?B?TnRyRUJENlU3OHBrWVM2WFo2VWxubTRLVC8yOVk0M2R1NTFCbU5MTWVybkVa?=
 =?utf-8?B?cGJQU1BRNVozaHU3TE8xYisyYmNaKy9GV2FUTGN5RFpGMUEva2M2SGxWT0s2?=
 =?utf-8?B?ZlpzcmpyNU5IVFQ0djNqak14NVZBOWk4NldlNzZ2Q1NYZU1ZTFp6ZVpiaHNk?=
 =?utf-8?B?NlAvbmxWblVMR3NMeTBTRnd3UVd4cmhnVng2QTZhUkI2bUNnck1Ddjh0Z0N3?=
 =?utf-8?B?cENCVkhPL1E3MUdCY3FwclNiTEl5SEw1ZW13aHhNQ2VubmgyTVBPL3JkMkw3?=
 =?utf-8?B?bGtOMTI2VFA2eUIvN1NzVkFrUTlhVjVNU1B0bGJGVGVZYUpLV0FBZUNiK1Jq?=
 =?utf-8?B?ZFcyRHMwNnJsM1FhRkxjbkhTQVRseHBHTmUyNjhWSC94UHhRaWEyQnlyUEJa?=
 =?utf-8?B?M0xpdTVPNG1VT2hwZlA4aW1yWm16aHNBdzdUS1FhU2tVR3VVYnpQbU5hS0Q1?=
 =?utf-8?B?TTNVWU1QaW5memhvNG9jSE9obFRYaUl6ZVJWbXpoOVJHdVJ4VHdPZEl5aW9M?=
 =?utf-8?B?R252ZmpJOUtSU0VpM3h6M0hvWW1zamRoSHZNM3pGVkthVElCK2V3YXBJd1lI?=
 =?utf-8?B?dCtrMTI2VWNpU3pVY0Z1bklwb0hBL1IxcERwZG0rUS9ScDZURExUNUxybTEv?=
 =?utf-8?B?bjdGYlNaMWErV2JKUElTcDVHalRSK1pzNTVyVVRISmF6TnNKbE5hTFVFLytH?=
 =?utf-8?B?MFpWMzJ6TGxkNFlLT2ZSM2RLbmM0N3hNTUpTRXhqaTlwWTJhMFFNOUJIYjFm?=
 =?utf-8?B?MndvNEpNa3lITDdBQnVuL0RCU3FiKzYwQVpiU25yNythN3c0VTlYUXVjeXUx?=
 =?utf-8?B?bzhOYWRYbkgybHE1WDFLWndvcUNINlNMWGs4VlV4U05uRnJTZFZzTG1XWVV0?=
 =?utf-8?B?YXU4U1htcTFUOEJTL005SnJQS2YwSjJTb09sTFhwbUtpcjNIRUI0MmhtcktI?=
 =?utf-8?B?WHM1ay9qblpPQWxYMVBjZENvRU5KVzd0Z2o3ZEpQSDFmckhDTFVlM0R2bCtx?=
 =?utf-8?B?TGhXN0ZUT0hSTGVkOWVWaEUwM3FTaVhUbHBOd2them80Ym9BeVp5TjNGL2hV?=
 =?utf-8?B?WmpEUEt0UXBsblYrMWQ4OW1PUitNUEw2cG5mVldTeHVkOFloKzhjL1RnWDJS?=
 =?utf-8?Q?94kgcw70N1y1Be7kWl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 001a8312-be1c-4dc5-190b-08de9991bf80
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:39.6623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BVNf84NRvgdfg6Lf4LFcePjGw0YeBSEchEJBjixBr2yDeNS/7MEOB9JTwv6L0eFP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7986

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
1. first 3 patches enables the support, so that without READ_ONLY_THP_FOR_FS,
   read-only THP still works for large folio FSes,
2. Patch 4 removes READ_ONLY_THP_FOR_FS Kconfig,
3. the rest of patches remove code related to READ_ONLY_THP_FOR_FS.


The overview of the changes is:

1. collapse_file() checks for to-be-collapsed folio dirtiness after they
   are locked, unmapped, and corresponding mappings are flushed from
   TLBs to prevent writes to candidate folios. Before, mapping->nr_thps
   and inode->i_writecount are used to cause read-only THP truncation
   before a fd becomes writable.

2. hugepage_pmd_enabled() no longer always returned true if
   CONFIG_READ_ONLY_THP_FOR_FS was enabaled. This affects whether
   khugepaged will be on or not. It now depends on anon and shmem
   configurations. Namely, if a user who has set
   /sys/kernel/mm/transparent_hugepage/enabled to always or madvise but
   explicitly disabled anon PMD THP and shmem THP via the per-order
   sysfs controls, read-only THP support will be disabled.

3. collapse_file() from mm/khugepaged.c, instead of checking
   CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order()
   of struct address_space of the file is at least PMD_ORDER.

4. file_thp_enabled() also checks mapping_max_folio_order() instead.

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

Zi Yan (12):
  mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
  mm/khugepaged: add folio dirty check after try_to_unmap_flush()
  mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
  mm: remove READ_ONLY_THP_FOR_FS Kconfig option
  mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in
    hugepage_pmd_enabled()
  mm: fs: remove filemap_nr_thps*() functions and their users
  fs: remove nr_thps from struct address_space
  mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
  mm/truncate: use folio_split() in truncate_inode_partial_folio()
  fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
  selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
  selftests/mm: remove READ_ONLY_THP_FOR_FS from comments in
    guard-regions

 fs/btrfs/defrag.c                          |  3 -
 fs/inode.c                                 |  3 -
 fs/open.c                                  | 27 ---------
 include/linux/fs.h                         |  5 --
 include/linux/huge_mm.h                    | 25 +--------
 include/linux/pagemap.h                    | 29 ----------
 mm/Kconfig                                 | 11 ----
 mm/filemap.c                               |  1 -
 mm/huge_memory.c                           | 37 ++----------
 mm/khugepaged.c                            | 65 ++++++++++------------
 mm/truncate.c                              |  8 +--
 tools/testing/selftests/mm/guard-regions.c |  9 +--
 tools/testing/selftests/mm/khugepaged.c    |  4 +-
 13 files changed, 49 insertions(+), 178 deletions(-)

-- 
2.43.0

