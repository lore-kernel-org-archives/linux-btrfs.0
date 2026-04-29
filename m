Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013024.outbound.protection.outlook.com [40.93.196.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2BE1448D5;
	Wed, 29 Apr 2026 15:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476630; cv=fail; b=G/w/CsEvxq6rQTI/TR4bugxyMQmh+l/ciTmMLSr+V1qLWVIIdOeYGJv9L5ZG+SezRjqZLKd73XK8cqkwQtnkBPHjNlx3MnTPA/eoUewtrHJV6Vzmq+MTwMbxEs7JvnwdCK6BwmgBJixIMbfY/6AVKi1apvUCRuVGZYYwu/KdDm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476630; c=relaxed/simple;
	bh=7gReYoBc/e0KzE4bsExXnd4yPUaQyMS88xXyAFPSjMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B9C4/teCA3MAJ5hk+R9mAUjc4bPotpcdpeB6PEF7Fiu1tylAY14kWkg2lXOfuLQXPoz+3EZYucADHdwxXMJeQs4Fq3XbJYlLwy5ea/FW+ZaIIGK1HSbmgj/W4WRCmfIGU1AERQ38y3ac8dqLPqQqKohmIBdpACVvQrKS90+541w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kN6jsFbg; arc=fail smtp.client-ip=40.93.196.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kN6jsFbg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AAylOUSsOaom2NUDzeV4TnOhl23Yv8Sk3XXOvJHZi4MlfMmhg/jLhVdUlKTZwJQqoG7jqCwUy/IXMqxShMu0/cwv/T8ckR8ve1BHi/mgDCu81l/7B713PdeldXBpfQvgdiig8CydgrMWMdh6/pHkGjOvhla9xTSncuXJc9KeJ1bdfY0WhJYZGI6JNyOFeIOYM//3hg/0/bjLUi3FU6zoL5ZJHS210vxosSmhLqzvV4aHCMu4y9s4udRdhUhVi+9VAXk2gDSTx0ka+dWFD2i0o3q6XvZ8Dq/pvA8TR075Pm5t/C+0v5pt/MtdCEmn0WU18Cb2PaHmQaBO/FC0t0vE8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFchUM7QX4VXW89gRfZEkKRr8wffG2akKfynjCS3YMo=;
 b=TtleL1+cwfQtJTcxSf+3pKng3CnZ/VGBndWLh3ZQNZJZ72vmDW792mBDxDggM3PUZGSjUMiITkfGyIushPhr8sK4mZt6UzCCFSF6ANox4uSd8sdkXYChKHhG5fhIVttlSsDvIuHB/F8LPizuKabM+c5w0U2zKbeqrWzX4P6QwJf4EkZE1bUS2t6uAlzTbWzKOvD3MlWl5a6/yfQ3d0apkRbOS4nbzjLyiE+mnSsEiZtYy3HlPi4i6UYPRPNJRzutTYr/fqvxM/FaYhamI8TjYeTVZ0qUumyorO1EZSO+lnpXDOG0DYZBYAL9/6Uqx2wIBv6bRuyKX5es9q+lHFa3OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFchUM7QX4VXW89gRfZEkKRr8wffG2akKfynjCS3YMo=;
 b=kN6jsFbgDkmWTKfl1uAIYPvRRo1Mg+vkVTmvWx/75z1QjP2cyDIb1VT/UXBhjC9nvy1kNbBk4gdsAC+oIMmf05YnNMaA5XXxitNk5cCWP5+Z5jej5pWQxpW64g3xZ398pggwFiIbmCH1C6tmJn6a6oXOEuP8boBRPaLgvnn6bjvs/ZOhEwl9CXNT8ndna+Ff96pAvn4uixPmvK61CqKONwjh12MN0fE+Wet2Eyhf6JGcI9ipU4u6/JXGvRglSGnIK+SqPY3jMG19sA0S7bEYz61B5RZugOunYrfkMuajjGTBDq5QQ9FA1dWkQDDhgZgJFp0YzuIM1SGCofxAPpAqzQ==
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
Subject: [PATCH v5 03/14] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Wed, 29 Apr 2026 11:29:13 -0400
Message-ID: <20260429152924.727124-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0127.namprd07.prod.outlook.com
 (2603:10b6:5:330::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PPF12042BF6F:EE_
X-MS-Office365-Filtering-Correlation-Id: dffb3afd-2e47-4a3f-4fdc-08dea604363a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bxMoqum+d0s+JTQT/tFbwo06enrAoWAe7cefJVpaA7c8kJGNWUfoHgb4t9mcbppoXJkr3FE+Man0oHs1PCVBX97X4wg0OsZ1dFkVNdBoaLCGZQIJAt+sfnMByGIK29H4rQWWkoCYEsiX0pZPx4k+rWzNaS0cDKgeUCmi6Arwxbnhyq+anjnKXLs7syRpNDyha8tqObinkNtm6bEnREjjG25GzrfQxpVMA1PBgHkD/hfpKcZiFx4m8sSsblkpgTBIOEn83bIX6pWi60Kgoj+cDYEGeyCwZ4siasaoC4n74gpLpSyYNFq2WxvsbBDq52zr3rq8AhgDoy5u0wE3OQyF9L8LkUA1wF0bfPBtLIEuu9ci0//9hX4CB10Mq4bE49hyRKf4ZdM6FjUecmZV4Uu8MgM3r9TRhrnfznau2rOsKjlxzMG3CBOeIoF0lqeI/LYIDGlv3jNFzdBewThqcds2tsqCh3kgw+1flDKK9nark+dobp3jj4Xj0ctiIuu8jvKQ1n+kWJ58vayl1P3FKgwWN3ARxxCK7uy6tM42dL8+q+KO7fs3cZHcVrjvisYBzPKHtaIYU7ybUtTv+2P4bA5ZlgUYyPdbo7N1UqD3nWLnDt+KqEVINDMIj9JoFOUkuycWjQrp9ZA7H9UMX+GsNUZG9fnNGZPzzDxvobTIxJnytxIETInrjtrTb5CqibsOhlTPGFCFY6fdQamzTTS/4k9mkoWa0P+Ru747GCk4xZV4fkM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bPMNR48vYuMiKpMbJQTkXuIQz0FYdjBi8k2uL6Xv6Us1E+OBPGicKBUJjmD1?=
 =?us-ascii?Q?BnFJclFZXEfwaYJz3C+Py6bCGlRX3x+9V/f2lRIZ9IXfw99PUuSWMJBW3RpN?=
 =?us-ascii?Q?efdLhUlqZAtYX5NjFfZ+8wiHeNGzNEGcLmrSkzjnaTVwKF29hK25mupQeR5h?=
 =?us-ascii?Q?W/Dm5Q8nFuPNSPYFecEYjbyHnkdA7SD1MFgcbw7Odkuvbrd7oxFQVJ8++BzK?=
 =?us-ascii?Q?mHg+AlEJtL5mbfSXpHoeArMz8NXgaWrjFCt59xmLvzCOx3cLdc47fxihejC0?=
 =?us-ascii?Q?uB6Lg1wicxv4Q7s7wACOgh7hyd1ntwvgS3zU9+ydAa8tt0zOJg2rRMjBKdBG?=
 =?us-ascii?Q?/oZpdBdxOUMa7eKmapylEKet0r4xHWL8ZyYpL2ZP6PZNzYXo7ILfGpzyr/bb?=
 =?us-ascii?Q?i5kABhoYi4mkjjsaGDPvsVJfig4fsARcPnD7cbD7d7yt63232ozA7VQbdt9o?=
 =?us-ascii?Q?9c9gdgyHU/mB9DR1TzveyqnS+2ZueSWF74prTeLO6RSFL30exVZIvIFzPo7z?=
 =?us-ascii?Q?cy3GpFdeEYRXEijck37irorCBKeY+zSmRLE1HU3cI8UAysWUi8U0ipm5kPQG?=
 =?us-ascii?Q?yqay6Jw7MWHE/UaK/CTD7NaVPqfaQPxcINeMWn41Y+CCPQ1BNhEu3LM0ZjzH?=
 =?us-ascii?Q?rnxi96ZhTTYsDqm7XfDD5QR0qVpHud5UjNzL3+6kMRv/RIOJNH/wKyLAI/Eo?=
 =?us-ascii?Q?z2/vlOcJlmFLdjJbprhLrs3IeiudopgH0eawHg63zl1qsMPsuh7j4HFfZof4?=
 =?us-ascii?Q?24DSOBWhML/EjWK5MCHodIzM6cMtMKDckRBrGFndJTcN/vEPbIrf0QequZPC?=
 =?us-ascii?Q?X6hq0Sivt6r5Ap5VHBDVIpfGwYhMC1jVmpAOJ1IS61eDbkoPKV28UXTf/FS+?=
 =?us-ascii?Q?5ZK/Kkua/TArGPPvd2CLr1/w5xxB/AsdBaW8BZ8p06+alPumcppJkqEantH2?=
 =?us-ascii?Q?XM25mn1DWpOcBGNeD5emHQSRVTtVYMul0vPRGy4c82ndaU3+R0ohoePuhHLB?=
 =?us-ascii?Q?1nE1BQ8FFjP1zWparfPYdzhcvWEz1hkmIECgHaAyb13aD0yllRs17qILptlt?=
 =?us-ascii?Q?NPTy2Fsbjp3iyNBMJokR5X6qk6Cy3PWP7eBMqRTr1nQ+v8ZoHIIL0vqaOnx8?=
 =?us-ascii?Q?EHTp+dyhz5EAAMioaY8OJMv9u672J/e4A03wzwbpXE0rXU0r1EWDnQc5VoF6?=
 =?us-ascii?Q?5uqDCtAycBmg+r/Jr0HS0Rc2m9geX7FqRgis+oDhYHJDLSTTenvmDiKY0eJL?=
 =?us-ascii?Q?WPhWI+8MFp6TD9EtOZ/X3HkHpNjXuoHS7kuAnyUKWqtEwlL6ktD77l8DG2uD?=
 =?us-ascii?Q?3awYNt50JLTBVEuQS6HOawbi3oNBNR0kueRRW31rJCcvvxe088nqQFccJIj8?=
 =?us-ascii?Q?0U6AX13KnkE0l+Fjj5APGTWvJOxIGcpov8b2Zuq7ccIS9vGGTB5fRIt6oXNG?=
 =?us-ascii?Q?wUvZEEG0x8mFei/mtRTSC8egyzdUdzcuZeWJ8AKXTrSPFBgI2OsM8a3hhBa/?=
 =?us-ascii?Q?A2csHuyuFVCLKEfu3NNkSR6cH5XOLJ6XY9KEdhgBwbeFsfCGRMu5JcRSlVzH?=
 =?us-ascii?Q?zDJToX4bFBCcl4nUyy5VBy3psTpInl0/BAM9N7YdH5xAWPOZ52n0Ng20YjKr?=
 =?us-ascii?Q?Y8aLaCY1imsCWvDY1e1sXq4rB896Tl9Usk7hkGFkur87qI58axs8dtutMKxw?=
 =?us-ascii?Q?o4a9dd9KAu1J5Y7zpWqIic0bl98FdyoVebPbWzUPFBZXD5l6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dffb3afd-2e47-4a3f-4fdc-08dea604363a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:30:15.4492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DV+eaws54vY0pWPOVcFLqbriDEjNmTlC21omGhCtioc7XgTd/iH4quXlWlMhvile
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF12042BF6F

Replace it with a check on the max folio order of the file's address space
mapping, making sure PMD folio is supported. Keep the inode open-for-write
check, since even if collapse_file() now makes sure all to-be-collapsed
folios are clean and the created PMD file THP can be handled by FSes
properly, the filemap_flush() could perform undesirable write back.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2f3fcb4dd1ef8..3b324f03e9283 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -86,9 +86,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 {
 	struct inode *inode;
 
-	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
-		return false;
-
 	if (!vma->vm_file)
 		return false;
 
@@ -97,6 +94,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 	if (IS_ANON_FILE(inode))
 		return false;
 
+	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))
+		return false;
+
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
-- 
2.53.0

