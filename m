Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013046.outbound.protection.outlook.com [40.93.196.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E74537F01D;
	Wed, 29 Apr 2026 15:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476613; cv=fail; b=R+j4biAa+UIW984lIwpnfuiz5ArSDjqRR1h6TGSRgCEjFjQih2Jg1nBZHQR2h2HfNwGmppQF5I09g3KBn62jCLSQT1ffZBAXGWebtaiUuYSCNp0vaOYdppirav0Od5v2PO3CNOOTC0Pcq4TXdw5oB5k11pSu19bmep66ML827Xw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476613; c=relaxed/simple;
	bh=ikHfpnb938tZuM1NviPdJPJtu8IKFaxFHNA8CPidAqk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Y5gJ2AGZukkyRSP7xOPumVxPtyLJ/4vcaiErHXo/YJF6lJUCHjHy6cYaiDFWoz4E5EYTJBSq7ebBAv3kEFQIInWgTH3FqQZZlo3p92YeMwfMKy2bo2NXdAvL65kyBOY/rjIubYv1AjQb7NmyHe8yynorzxwdaFiljmaIyBaVqwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IU+N+SUS; arc=fail smtp.client-ip=40.93.196.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IU+N+SUS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TMxkDE4ghUl+EZcL9QXBVvOfyWXm3sCElUu07zyteiG9lC+QtkW/4d6PxMtvCUUN2sH6FHKSQhRxgdwoFZhYPG+SZvwvbRlUgxLSOmLwrVKkfSYPJUfaUOnfiiXj9nLUXVLLfxQQcAEnqLj+xc/6jChRTc19R3g6ruMEuXEvZIirE09LsMNfBZgkOf+JAXKKBBcb1M6D9gBBMEJ0jEyb4uQK7Sa/006w8XMgl4rWgFcAKDGFymphuWIyFyMHG5I7+oXBAcBBoBaSPinGeadiiXso4KxZrqie4dBLXwQN0HbN7alD/lH/PzDoICisotT/YyBD296PEv2vV4OcRNlHJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIVGfma5Ogep+ZCFIOw6b7NbONyTcWoWANVMxd0JYHo=;
 b=CtaxKyMFI8Kim2nbJmAyTE/ikPj/k5r/DHK5V0qYvsc36dS9SYtKTbR5wdovPmN3bX13/qVAtQbuKTWRL36DDkBSYS87OxeSXPkImul6dLtIsej9M7a+PiqjtK+C1oiHpGB2pwJ5YNdTNy7leI4/yrfMsaFd675/VigtE7JFyTAfDuXyiNPk4jaEdHk/x4zXd8i9r+lUhkr9Ouvlslxho4o3eewfDydGv0ajvSfCSiArQuEWJYKAXj4RkrZ4IOnPFyw8SSWRGwu9+OtaRfY6K89vrjKsRImNSVGSBeew0vtEHMlnp6CTz+1NNTdIBdqSfDd+eXJBcMTMfjzESf65XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qIVGfma5Ogep+ZCFIOw6b7NbONyTcWoWANVMxd0JYHo=;
 b=IU+N+SUSugF0E1Md935FwW0T7s1oib96X2JcQalF8C4VwYrDA68z6XOcEFjsbraxZofns3cD5EgQ8WqJURwxx7MI9Fk/fjnNJGQQMcNLol2ZlQ3O2+LUDKBQ5E0xKgJeCCksVvezkXJQyOoTc/Yr52hsigamcJ8Ghyt1p8megqTLVEcyCwziGf0qr1sExpMuGD/4Iidvp0SCg0UYCtvt+1AqGH4tAjGrA802+ZXrBtsGebzuisLB4h8hqRQZPe3VGwS5Mgnj/gsLq12KVzpRN+VO7HO/nUfuV2MWxVbis2CkvTssD+y4Z9MSuOOZVpKt97Dil2sCnGu7qHAK3KNycw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PPF12042BF6F.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bc8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Wed, 29 Apr
 2026 15:30:05 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:30:04 +0000
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
Subject: [PATCH v5 00/14] Remove CONFIG_READ_ONLY_THP_FOR_FS and enable file THP for writable files
Date: Wed, 29 Apr 2026 11:29:10 -0400
Message-ID: <20260429152924.727124-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS0PR17CA0014.namprd17.prod.outlook.com
 (2603:10b6:8:191::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PPF12042BF6F:EE_
X-MS-Office365-Filtering-Correlation-Id: b3811e00-3ff7-496d-5407-08dea6042fe2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Mn81EhrdiWLIFKOwPJhyKrrRMAcCU5DdlCOpIAW8RNbnou3OFEaOOQHnsRA0H397uWmZeyIG5amszDjr5al+x1uL0E6zJ0WYDQ0lPfg4M2J/Ux60vP7HXKpOapg2xSrpqBBrzKwOcku9p8MQWvyAA/ELgvHVmZbFUM36w72QX36xmLL47T9Ow1A7I5rCuKWZZfbHwKy0FszQw4Tbq7p3iyJMB26yiwDXZjsc5jm0FMvUI/VAVRlv3QS0SUjOqCjzvydjnoXyimk4mrjAGIa/X/idwfhqVjRMoum8wDugY7mt2Ic0XwNuN80R7EyHHRTB+v+lrZYDv1g92vTRtoc/ECSPG0rNF46bbl4ssbBkjk6qYWqYNPZOGzt0utUs4oFyp76KygIVvj6Qn+eav+rIcde1eAQBhZ9ROPxc8/ZIZ27ReW3z64PsQcU3MTodAdfU2jhaQDMjbtI4CDzMHXojnPUlKRp2Ws7CObqU7jyxhXLkf84N+StHuFnRVTw30QHDPe/pf+mZM+D31ogYOj4o8T5oHrvf+orYGSwD8kGtm97v0YIm6irIE4GkcIwOtrxwNRXrbHZpaU7aTgrn8TbvAx19f3p0JTjo1sznuwGcZwu5UeUlIul+MtPNuUFRktyeFgw0GmUNZJj0M6628JohwyyU2/DlPFdxOMgPUOY2cDUUncQh3R/6Hbj5DUJIylweor9n/xB5nudTisOiutL5x+Care5wVuwjWej8JSrnenLkASXvtdgQ071J7La+La71
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWRVck0zaHVZT3NEYklUbnN3V2s1eU1FMURwTmdQRG1aWWlWTnVBTEZ6VDhF?=
 =?utf-8?B?RTgxOEF6UzV1RzlYK0s4enVHQXZnSmdpZERFVW5qaExhQmdsUmxMeUJWYjln?=
 =?utf-8?B?ZnEwekl6M3BSTnRnTWhhaC9ST2tmSmhMcUhwdHNDQXNoVml3TmN2QWV4TW14?=
 =?utf-8?B?YnJpU1NUVktHZEw1NlhucHVWTGQyY2pocHo3eFNJNlpTTkdrZ09DaW1ZNk5q?=
 =?utf-8?B?TzdkdmRQRmplbnJnOXB5ZkhuendCSEhWMVdnYzZKTGxkZFRmcHp3MWlYSDdY?=
 =?utf-8?B?M0wxV3lCUU9YT1g0bnllV1NXbTZJTlBzUUtKNEVEUXFtOEhBSGZ0bXlFclll?=
 =?utf-8?B?Z1hZKzNFS3d6eTJvSmhydlU5TWhVRkJBeURoT1NSTmFjSXFhN1VrUmI0eDJO?=
 =?utf-8?B?WGFCUzd2Z3dQZUozWkduMXFzd210MHZYYnIxWG5UeERtUFY1ZE5icXA3ZkJq?=
 =?utf-8?B?ZHZmWW45a2o1LzFGaE5PYVU0azlWSVJ1RWdqajc4d1g0eGlrSzE4YWlGZkh1?=
 =?utf-8?B?SWRZdDY3R0dsZi9rdnp6eDBNcy9raVRORlkzQ1Z1UWxqeTZ2ZEpWSlBpVG50?=
 =?utf-8?B?SjRIdXQ3dDN0cEZIdDJXZWdLV2wwTE9zNWpka2xGSzBLK3B1d1BKLzIxSjll?=
 =?utf-8?B?SjVsK3dHckRNWFNNcThycXhQdEpQZnFSNTl6N25ac2hFeVJIRXhjNCtmbjVI?=
 =?utf-8?B?M0F3L0g4TVVDTEtiMnplZmlCb2dOcUYyMnNOd3R2L2NNYi80QlpsV1hrdWZT?=
 =?utf-8?B?L3JmZ2J6LzgwV0ZLTmVxelNzVmZ2REwycnIzc2FxR3d1MXFGTnY4NkNTWjhY?=
 =?utf-8?B?WWxHU01LcXJ4ejNBbGxQcTg4OXk4akpWMmxWM1RxL2svZVV5WXRJMnNJK3Rp?=
 =?utf-8?B?aE9uRGxsZWwxMCt0cGlQUUhQLzJpNjhNTEx3YXJvaStuMGpWWHlENHZHS0tI?=
 =?utf-8?B?TmdRZ2hiV2dzMlhSS0tGbE5aNEdnT2lydHpKWDY3SllGcHdjK3JYcFJLZGlh?=
 =?utf-8?B?TFdXdE5MUXBFUDIwOHhxZkhZS2QzM3RycTJMb0diQmtIU0luTHQranlIb0JJ?=
 =?utf-8?B?Q2NlWXZtamlMSThRbTJCTHlockd0cVVqRm9IUzVoYUduN3ZIK3QyVW42RVg3?=
 =?utf-8?B?Wnl6bkVsUnUwNWEzZnc4bXpGNVhXVDFTd29DODMrSk14WW13TGdicEk1b2Vo?=
 =?utf-8?B?UEgyanQ5aHg3Zm4rR09zUmFQeWt1d1VuRk40VVdic0RyOS9PcG9TTVdyM1I4?=
 =?utf-8?B?SnRxK0dDSjdyV2JYOHduQVhiMThWUHU2dVBoWDkxUVZaK2xrd0k1c3RVTkFS?=
 =?utf-8?B?UjdMWjIzWHVoMFBsMi9zVUdNai94c3pYVFdGTmxPN3hJVU5wZ09iNHVZbGJG?=
 =?utf-8?B?enVQTzI2ZjF5VWJ0ZUhPYlJLM2dnM2o5aldITVNPeHowaTcvd21pbVVBa3Bt?=
 =?utf-8?B?Q2RCZGt4M1B3MWlvVHI3K0g2OEtEVkQ3WEhRZFlRbVpEamFzeDZEZzZwQjJx?=
 =?utf-8?B?dVo2UlNJTG4rbWlyN3BITDREblRtbmcwS2dBbm5pZDJTamd5aHFORWY3bzRF?=
 =?utf-8?B?Q0IxREFrYzZDOEYvUHQxVTVoZVlRQVFadXZOTS9zQTQ3Snk4RGYreXlkMEpP?=
 =?utf-8?B?ZWVCMWM4UnFScy8xS0UxakthR093VUNuTWpyRGdQOVFjaE5sd1Q0ZGl6OEg0?=
 =?utf-8?B?eGpYYkQ3UG1IUWxZdmZWQjlDR0ZxVG5LVFhVTE5NQWV0MEZCRFhidmdlbWtn?=
 =?utf-8?B?UzFMM3ZtdUJmQysxSGhNSWJKeXUzM0pLLzJOMzFZTUs1RjJXNXFTN3R6VUs4?=
 =?utf-8?B?RjVjeFI5WGs1QzBQcmNkaURMUkZUZmsrMDMvT0dXWlNzbjd3NFFYVHpBUmV1?=
 =?utf-8?B?YkRjaXJoMGpoSE1tbTJSRS9LLzR1MGtWSFVnMVVYZWtMakdMSHkzbUxZdGJK?=
 =?utf-8?B?VExveUk1N2VDV0YwNWZXZDlJeG1JbVVZS1hJNjY3aHlpcUc5QU5nR0ZFT1d3?=
 =?utf-8?B?RTlnUFh2aWo0ek9XK3YzcmcyZTlad1VtaTJPSHFpNVVwN3BoVloxQ1NOdVJ0?=
 =?utf-8?B?citWZzVBN2VwRGlUdVN5Znc0bTd0NytlLzZBWWRGVnRiVVpRS2VmYzRIVHlz?=
 =?utf-8?B?SkVPZS90OEZhTUhLdEdGVmFYeGpGV1ZlNThzY0tlYW5Ca3lpdFdySmJ5SGZP?=
 =?utf-8?B?elRlb0ZZcnh3L3Qzd1hQZ1Y1WXRFMU1JYWttVVZDQ252Y2tPdDJMMjhMM3RO?=
 =?utf-8?B?TnpGaXZ4aEh0UERkVC9JVEtCNnkzajVCNUxDeHQ5cXJ5eXVyNm5tOGJGcTVG?=
 =?utf-8?Q?9XToRl6q8EKV3dpx5o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3811e00-3ff7-496d-5407-08dea6042fe2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:30:04.8128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K1Zes3buWrldEX5nM9f9tVmfF20J6Zd1q5/Bbl09+JaEcP87rs6POjU/1LNyXppG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF12042BF6F

I will be AFK in May most of the time, so my response might be delayed.

Hi all,

This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
file-backed THPs for FSes with large folio support (the supported orders
need to include PMD_ORDER) by default, including for writable files.
It is on top of mm-new.


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
 include/linux/pagemap.h                    |  49 +++---
 include/linux/shmem_fs.h                   |   2 +-
 mm/Kconfig                                 |  11 --
 mm/filemap.c                               |   1 -
 mm/huge_memory.c                           |  39 +----
 mm/khugepaged.c                            | 101 ++++++-----
 mm/truncate.c                              |   8 +-
 tools/testing/selftests/mm/guard-regions.c |  18 +-
 tools/testing/selftests/mm/khugepaged.c    | 190 ++++++++++++++++-----
 tools/testing/selftests/mm/run_vmtests.sh  |  12 +-
 15 files changed, 258 insertions(+), 236 deletions(-)

-- 
2.53.0

