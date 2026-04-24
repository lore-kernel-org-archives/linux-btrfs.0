Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011048.outbound.protection.outlook.com [40.93.194.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA51282F2E;
	Fri, 24 Apr 2026 02:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776999005; cv=fail; b=Efsz0D3LqGSeNmKqVjDVjC55XedRk3lQlZo3x+KYN/qvfLflBVjvidrRCC+HI/KVi9rvDWB5O1nZ/9UVfuw0YnrwTiN+9cBWNHmEmDoeJmJdPVOiw/GTnizhemgBdiqstttZRj9KuuLbohgOs8YOF2mj9FBWmZ2kPAexmJXW/kM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776999005; c=relaxed/simple;
	bh=pfqzoxKmoOIyQAJ2lxyobiRLhvoxC9FVmBb0XzTHWvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=cG7ji0YyHUY7fm4AUSinY4ZZbksE7WCPXXh34Tvn2Ywtd8IkaOu8tu2RtEg1LK4yNQAasd/IJZ5Hl/LX1eYrARVuvy7a7Imjnj33mgbxAqaUd1aMsJtEPOleLviVmskA1e7Pf/y9tF99I1Ga1RFztLMOFS2yMuN8cOUJk01F5bU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TVesvqC3; arc=fail smtp.client-ip=40.93.194.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TVesvqC3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QFQfTEDWYcCaOLooEF8l30otme9ekVxRyhH9rwY5KXpsbfZXDRZ4H9cEAV/gMezK9+ecO05bCBeQjJP1wHOCOdZhQMleW+vzeSSn4AZWyNFCIyZMW1vwmos766FYlDEuEKrUDrThNgzO8btSn7Exvb898uQlQvqm2r9wVoqap1La+pqD0ujl+R7+XwuRN/yj8gym7fHVPvUDCLI36TVT+8+1Lf6sIZx/BEmhdNcZcegrwuwNHuYJWYIvsJSBufki8mwzmSPJmdR+1KJ3KlUJ2heerlfinQ7g5TVNZ/Xwsf9GXGYIi5A9RIQIKD95JOnbr3+zZigtuZ1WhtLo6AiXDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I/5izaT+f2mYrPTBPN8+ZApukXtFr9fKFOyq17ktj7I=;
 b=p/zzpTVUfGZMTu1MSR+4OwvKVDhiCIFvBLwWx4JXifuQ8CEF/AgUoc9493c4SIZJQlSrVxpnBWDEMDyL+GaYeL8765WbQt1fX0WRHIDaD5P8Xy/IIK/GEi30iLfAVu2oOQH+E/MUv2eA9WburAdhy8siwGjPSqu0FaAnrcrpulpO4qzxalh4IcfjZkhmBNpy48JI4gmfE2Ew4ZfpFeMNJZBJXKh8l9tBe09hsEGFzu50P3MrCHWE7RFWyXE0l2ma4U3OLIRn6V5cmPun/ZxciTdFz+H5gvgpIybe6CHx0FIYy+U9GIXptSqCf4zUmDcIh+uBU75TOSyPnJfE+vZbdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/5izaT+f2mYrPTBPN8+ZApukXtFr9fKFOyq17ktj7I=;
 b=TVesvqC3Sta8Cwcut1Z7mexr/Hanyqugw+Sei6A3zO/uverVzPawKgaycG3QsTib2VGzQK3kkkJ1OypFWJnAhCkdg/zx8iff+GXRD3oi/EXo70wJBZ2WWhHXwZg9+2ZRJQ6oRaeGmP0dO4m/rIGqFo/9C01XjLMkvDlhjKEwrpzKePk2aHYUb1GYi4db0cy4TzhlHcnVc+yrvtAhtASZx9QfQOTrrnpfieJtq76kNgc+6drpyofZ3q7ZyTTYFae7gKYN5210ZK+qgatGRZauQT+4UbsmhsoXIJtWpxBv3+MlmKL7HW0dmj5CSPqxqmjxNBcbeCWnLHCC5uCUQ2v6LQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9588.namprd12.prod.outlook.com (2603:10b6:8:282::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.16; Fri, 24 Apr 2026 02:49:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 02:49:56 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
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
Subject: [PATCH 7.2 v4 00/12] Remove read-only THP support for FSes without large folio support
Date: Thu, 23 Apr 2026 22:49:03 -0400
Message-ID: <20260424024915.28758-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P222CA0001.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::6) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9588:EE_
X-MS-Office365-Filtering-Correlation-Id: ca6a3cb2-4834-4a6a-84f2-08dea1ac2b2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|7416014|376014|366016|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+gucY0tg52PZCEn+sJ/Q96basB8x3y3xEPSF6/2YY87Trw/M73aDiDuY1Wr77jlW5i8/7fCNYZW2kkvAgB49B8yjTFVoFE5ku7X8hZXHfXyMldp1RblhuGMHe9uCib7tr9iW9Lb9mFIfqMmri9fkFuF/Kl8uQn5UwZoDFjPAXa4p3xlWsURhOBodGmQjo5bBIMeSx+IH99ny7l+Avbr6Gn+sVSZIa8lXEqfeq9XJG17m7QBTkAF/kiT6FFJCVwofRw1hRobQIl7ECKlGztI989Yszd40WxhuGPUbYfwM2LMpiRkfb9s0XptEtrJGbyV5ppEx5M95H8lCWebPRHm+6L1Pmru5CDcEEMTRqPVJmERcTtNEO/JVw8+CdaYCVJeuH46/oFDeSKXlMvQenvzzswK/idh9ePbE++smEzXbqt4buRUHchX1YEZFCKw8gyIn9s5VzYsXnvEsqhrNqKy2uf669zs3XFGODpJ5bdm8QrU7EHTCOAwgLUkctXzsgm0CZQ4Maua5v3UTTQ7XwjswDpIWZJYxvbEFLEYWmMva5v+qigmfI4TFTXppXGRSBPZGVtuv9WhurfwySoF5TcuGU6uIZDm9z9cXXwFFGltHsLrumP+FjTp7w7hUQu9c95wZH8scE8YdI67yTht3wbfAWEsEkeztO8uxNBhfEeAzXfbv26Ogtnw0U8V9q5DFN7F2DSL/7DJvlec3GonU2aE4lXt0/5QGLQ7iItoj48DvJVs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(7416014)(376014)(366016)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzN1SUxmZHo0ZWdFdFFGd3FDUTh2WFNIaDBxYmlDeElvajFSaW8wNU5PRlZy?=
 =?utf-8?B?TGo4NExEMU81MUdoTEdvdmsrRTk0MXFVd05DZmVrOG13WmxwdklNaXl4UkpJ?=
 =?utf-8?B?TFpXa2dPV2NMNE4vcjVwQndGVlJmUnF3eGllWXY1bzVEdWt6NDNnUVNKNDQr?=
 =?utf-8?B?OEtHNmtvUWtjZitzSEJuOGY4MFdXR0dxUFB1NnBnT0RnNFliYmZlYk1UcVhX?=
 =?utf-8?B?eXlqdENUTzZvU2E5NW5oc0NUS1ZSU2thSUVsNUp0eUtpOENoZXhZS0dwL0FD?=
 =?utf-8?B?eGkvQmFabHcraHJIdW5xMjRLOWhSNjE3RVNYZGM4YWdTa3daUzAyUUYva3B6?=
 =?utf-8?B?cElDaFQwc2dTeGZycCtYMTd6aExORHRqVzNSeGhwWmlkNDNDbld1TGRvY1Q0?=
 =?utf-8?B?NEk3ZmRwcXdPZFJiV2ExUExxWjk0OGFNby84MGNhUWxhSExTNkV3TUE4c3Yr?=
 =?utf-8?B?WFgyMzZCdjZ4L016VWtQTWtLVlUyZW4rMTJHN0dGeDdjTDVqMHdDQzZKTUhC?=
 =?utf-8?B?dUs0eEs5K3lYcXNXZVR4TnlMaERIbTUvRkVrUTZGMmJoT1QvU3BFSzB1THZY?=
 =?utf-8?B?bDEydTkrNTdqQ3YzNEErZktZVURWQWNZK29LTHN4UXhZV0F2emNwTE9Zd0Rt?=
 =?utf-8?B?a1lNY3lwcGxwbytzSmx3dm81TjRrU3VBcXJhNHRPYW9jQm5lOXRCQmcyTzB0?=
 =?utf-8?B?cFdKdXRVL1Y2dHFZcUtWU1BrL1lSZFpMN05KTjVLazlMRG5OT2ZtdDZOaXhp?=
 =?utf-8?B?Wi81ZzdERnZpclFubjBtM0lVeUtGaFVkUjcyNnM4dmhRK0RaaysvRndOZkFC?=
 =?utf-8?B?MlZqbTFaS0h5cWpxVHhPL25lallITk5FRUoyTUNseXpGQ201LzJPdlA3dTFI?=
 =?utf-8?B?OXhTZGVab0RoU0daTmhhS0pWQjI1SGQxUWlhcHR4andpUkJOUWlwdlhMV1JS?=
 =?utf-8?B?ekZVZnBJMVZMc2tobVN6Um9kN0cvWEFZbXlLdTdETjh5SGNYOEVLMFQvK08z?=
 =?utf-8?B?djQ4RTB1RzhoZGJOWjdiMnkxN1R2UlBDa2RteXo2VnZ5djNGQmNXZGxwYW9V?=
 =?utf-8?B?SXhiNEpSdXMrcWk1cHVjUDE2L0YvTHZjU3hSQnFpSnZ6dGFweGVjakt3NUNR?=
 =?utf-8?B?dDEyTUhneUtXamNVV2ZHblIzTlhHS1A2aloyRDVaTXRVbnpZaDR5MUtsZm5j?=
 =?utf-8?B?VVkzQ0dHQldnQUFtaXQ4dVNJQTZrN0V5TDM4a1dMZlVKeUZYOFd0cWh4eUcy?=
 =?utf-8?B?cmpreEpIdWhOZ2txYXlwQTFFOS9yMTRxNHRDWlY0cDY5NUxDTUJqbUltOHRk?=
 =?utf-8?B?bmhUUDQzRlAzNlppNkM4a0REdWltaHJFaURtL1dtS05tYi9DTTlBTmZyM0E2?=
 =?utf-8?B?SnlHV0lBR25IdkdnMytzUlhFOGgyWnpyTXR5MHJzOXhOMHpvRHowWERDQkcr?=
 =?utf-8?B?bHpZb2l4bk52OExZdE02d1kxQjlaYTZHaEZtK2NXT1phYkczZzJRVzVhUWVJ?=
 =?utf-8?B?MlRZWndlcTNwcGlLMGFvdGxOblpuQm1jNUVwRTVkRGpuYzZPQzUyNUQ0QXQx?=
 =?utf-8?B?ZHVQTldjT3BTazNRZ0JIeVpoQTlBYy9MSnp3WkhPL0t4V214dEV2ZWxzcGwz?=
 =?utf-8?B?eXhKakhJUVdhODJrT1ZjVUtJVnJjTXYvZmhEUkc0aTF4eW0zbkxxbTVVQndK?=
 =?utf-8?B?YU11d3pJS3B2YWRjcTQzOHVzOWk5RGVEVzgvT1d2a3VJdEtXVVNFcjNHd0Jh?=
 =?utf-8?B?NFRGakl3NVJZY2hzaG0rS2p5KzBiVzA5NWpqZWZENGVxQ2NqM0RWTnArNHRh?=
 =?utf-8?B?eERnSnRrenZTQ2lpRTd0RUNBVEYyMEdHSm9GUjBSTnNLeGVuWTlnSm84NVRa?=
 =?utf-8?B?MFRuUTBhWnBPK1VTZDZKV2ZvaDZ2dGpYYUo0SHU4eGFtTkJqMS9qUmc1ZnBo?=
 =?utf-8?B?VEt2cGVuaG9GL0s0eS9xdkdWYk5jUGxTRWpVMDc3bEYwWVQ5TkpqVGZFK2lk?=
 =?utf-8?B?TUZ4N2ZCMngvNm5mR3dJYXNEZTA2N1IvbGk5VnVMZ2JOK2t1VG1ScDQ4bnhP?=
 =?utf-8?B?YjVwYW16dGs4Wlh3Uk51UEpCN2R2VEFqS2E2YWFHeGFIREdNbEpmTWxDYjVO?=
 =?utf-8?B?Tm5yV01VSjF2QlNtNFJMRjN6UXBKbE80U1lHcWhNQkMwUXMxWkVJN2tBY1VE?=
 =?utf-8?B?SGdMaStDdzBLakNyRGZ1YXBEYVFWa2RoMUFxSVNxaXYxUzBvSm9nbU5KSjRD?=
 =?utf-8?B?ODdhOW9kUTQydGVUMm5iaGdTZ0swMTYycU9HQXZkT3JJcWZ3Q2x3cVVRT3NZ?=
 =?utf-8?B?OXgzMTV4NlYyc3dURjZXYWRGeDJOU2ZXVWYrTmpPaEQ5anAyL3FnRlA2TXky?=
 =?utf-8?Q?HTTQM4sr1pI98jxFo/OqoM/kspiWWPNDCkuLH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca6a3cb2-4834-4a6a-84f2-08dea1ac2b2b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 02:49:56.5168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kolDOsn7dZ+NYMP611QSnn8jkNz0Z6sEORg9ivE91GEEhyRSoPNM2z4Lyp8FaSdc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9588

Hi all,

This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
read-only THPs for FSes with large folio support (the supported orders
need to include PMD_ORDER) by default. It is on top of mm-new.

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

NOTE: collapsing writable MAP_PRIVATE pagecache folios is not supported,
since:
1. PMD THP CoW only faults in at PTE level to avoid long CoW latency,
2. the first check, due to 1, in file_backed_vma_is_retractable() prevents it.


The overview of the changes is:

1. collapse_file() checks for to-be-collapsed folio dirtiness after they
   are locked, unmapped to make sure no new write happens. Before,
   mapping->nr_thps and inode->i_writecount are used to cause read-only
   THP truncation before a fd becomes writable.

2. hugepage_enabled() is true for anon, shmem, and file-backed cases
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

Zi Yan (12):
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

 fs/btrfs/defrag.c                          |   3 -
 fs/inode.c                                 |   3 -
 fs/open.c                                  |  27 -----
 include/linux/fs.h                         |   5 -
 include/linux/huge_mm.h                    |  25 +----
 include/linux/pagemap.h                    |  34 ++-----
 include/linux/shmem_fs.h                   |   2 +-
 mm/Kconfig                                 |  11 ---
 mm/filemap.c                               |   1 -
 mm/huge_memory.c                           |  39 ++------
 mm/khugepaged.c                            |  92 ++++++++---------
 mm/truncate.c                              |   8 +-
 tools/testing/selftests/mm/guard-regions.c |  18 +---
 tools/testing/selftests/mm/khugepaged.c    | 110 +++++++++++++++------
 tools/testing/selftests/mm/run_vmtests.sh  |  12 ++-
 15 files changed, 163 insertions(+), 227 deletions(-)

-- 
2.43.0

