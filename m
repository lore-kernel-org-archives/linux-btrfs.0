Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010035.outbound.protection.outlook.com [52.101.56.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9042318140;
	Fri, 27 Mar 2026 01:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774575798; cv=fail; b=Foid3YtV2mF2ODKnT0XAHSoBLVxIzg04JSE4mFQCdaZ12ihiRjvwL8nBWH2dk6uAOl11KJRKrOu1Uk7udjsv99YLeXKpCWn7GoUO8k5fRq7/ty12l9FLrBasFh7pvB6sfacx7m54AbrH3RQrGWvxG7FBRfThJN4UbmRAt7Tcc8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774575798; c=relaxed/simple;
	bh=rXC0JHI39eZltG97tBA2UjB5XXBNKSnOpV0mBekO8G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hpRPGp/3D+YYIAizszh3JtGfthLcgGw9S2fSntcNID1eJUPDRZWs7NHn7M6wDPGLNFO08frS8nH9RwSdF32myamLrW+MCcZxQKix1/65eMDJ1ETZ29AuUx4MCSVyMoXlTS8kTzcxDC7yvGPpREA8wEBR73WrUBb7fyU/T4Z5Nwc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WPlaD5oy; arc=fail smtp.client-ip=52.101.56.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WPlaD5oy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G5J5xd7lt4l6t0tMA5iyhvUQN/f0JSQXisNd2sJ78zlnaGv3hFN/0fFqsc4UO66DZnSX8/AZ2pVQkQ44K/JTPexYwcMzbDQdVMBXjI2kbbY4AZ98dsfsjbSDF1gAbCRBgx+UXxZhh2yw7WgWZdP0DeRxFkQNgGoIGoK4uURpLxXFwPLcEwsTV6uMYxDreVn3X/YOwPIBWS4Qf1KjhDgN11qELkTih+awRnHr4jLjB8nyRjUiNM7yXeOWVEaWagqbKIFBe09XI1bU/X/QaAlDT//7eY9E9N42+LMoWNPKZ/wkJ1Z10XTc/jVo4t7vSpNYgYRoNLVv6W2iXQ1r8uRi+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vyKTgQ83LLLb6ncoRmDmURZxAiCIJUZ9eOAD9u3gWE8=;
 b=jOPwcrIf69SsXmnvtVClAxXYD/apzY6DzzwYZ/r8Ys4NvRVepjWT7WlxSZRLbVBl7ElsDW9Rfh5k7N0swcUxDOiCxNR4qa5k/f69WR5YxpjedeGyTDATm2oCPuK50qOGqhJXCpCmZV6LmEI8kIZxu3ITtPgoOajJDg61mWtHfE8P32TiUqoig9S0SvjKCCAsYBEvc5EbpH4kdLnN83ie0in6XFoDdHA90UTZ/ripM+TQ7Z0hdbt9WEAHjwoxKF3dxX716cyWPh44o8yUMq0AwBlSJ+8Vbs4z4qXfhDiVD+aNGiZnkJINE5I31j0+/FKaUlklAYrZuQkPZYGyB9zuUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vyKTgQ83LLLb6ncoRmDmURZxAiCIJUZ9eOAD9u3gWE8=;
 b=WPlaD5oyj/X9S/hWosOvnKLlUWpOdt76yKXoUidiU8uyJrbjc46Cf6lGvFpiiyMyOgjwbSOwoMyxTQ7YBwdNN1b6L0obLLAtCOut3UE2/YbguChjhJIrELC5QSQ4dhPtgl3c22fdHGlVh3Jgp2XtZJV56f3OwVD48WfoE7w0+CH9TK0AiEyUZWnsooSWDgOIczBVQQxH1P44scosfrAGZQWoEQWuOOzK59AGeWG3DmgGkZM/xlBKsDjD4zlBiwjhUawY2cFsyEmekuoWy1a8aWJnRhMQ35KO9DuUFMj8mm8JtxDCm+NOVt5RT5pOMMy5RDcD585jGqGRTXYO7xsbbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9264.namprd12.prod.outlook.com (2603:10b6:408:1e8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Fri, 27 Mar 2026 01:43:11 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 01:43:11 +0000
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
Subject: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Thu, 26 Mar 2026 21:42:50 -0400
Message-ID: <20260327014255.2058916-6-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327014255.2058916-1-ziy@nvidia.com>
References: <20260327014255.2058916-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0153.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9264:EE_
X-MS-Office365-Filtering-Correlation-Id: 87d06398-3d63-43fa-2cf1-08de8ba23454
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	uyTOVabxsCcg1//nS23wi0RRUpHwJZzUGzj8i+5F5yFi8R80p9XCvuhMkhKFxE+ffSykcvoGWc/+OfxfM2ZyQZSNVJuj4M/ma/Rw4EWSQ2kymRop5rtDA217Bl35I7mvZ3dKEmClcwilixwDoSuhl4tr2cJMZNoqHtHj1aY+FDvGHulb8vxeOMuBcsXMB1xRXq4Ja3b+vUR/uKbN2QcPlmbLFavdolhNwmXhJPHRNC64LXYkLVrQCbGpxCqAyHxrqVKTA376N92j1Ak147+mGBCh+Pn2YDuUWnH7qeiGm3+yyNPDAUDaY+Am34U/LNvvkqKl2bqI5rCKaVI/Dpt7SXqvAl6JOxqbv8AvDAArZklxr5MbS9/sSUBkVfgmpgy5oPsBGqUYeguxs519MpmqXF2u/PFDloUSKy7DqtWu5rwp6oh2xK1dy3cxeCh8Wa5DW6PzqGY0uCNYEQsRxgHodkZ1Tl4PqvtEppQIlQbHiO0sNdjJNocrHrFltKot/kT1np9b25bb2/5nhaaAdo935aNKII/AU5aUEE4DYvB8cPu4/V+Id824vCeo283rRslibrRBZeZemfYtYon79ft+IzyMnsqnFO5sVxI6nkb3sTbbIkYwRY+koFMKaSJmbPunFjhp+l0sqR0YDqu0oTzyqDd+J8IKG8X7X6/2v+XfPrht5d+wA4N+dw4d8NHkVwEcJSrLxBRNIKlYajZSGRT3aAkJkTYWg3oQ94wl9B/Vav4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vGndVa/eBqc+etG88qnAoPFs0giUbpT1luq/Yo5IU2aevjm0qT6YIhduHQ7r?=
 =?us-ascii?Q?dCuY3KFNxqNXoR80Wqg6DcHnS8087/+LQNO+ncF/R1E3/mpUQ4DrDTEOBQ9w?=
 =?us-ascii?Q?0P4stXwIlcnteAkRYXmRjGT8XR8XEfVfM0ox2DekFOMmKm/jY1RrJ+Ub0zAU?=
 =?us-ascii?Q?NDC4L/AAfrip8CaefGihE1rADAAwi3yZwYJXVMwGFB50H/WG68yPDf1vPlNJ?=
 =?us-ascii?Q?h24pGLc0vu+yenu8FUX7gew/oY2mMZ8bR+eN81ZjiHMvn4Xj9o2fJ/O+NKUR?=
 =?us-ascii?Q?wTWXQBRcxJHuhOUPtdeMzG2/KBssPn3h56h/xWoDRSNXu2hNp4DMIrkTt0zM?=
 =?us-ascii?Q?G0yY+4jbwiOrJtKvEfuej8AD6jHHqQtn7F0oEF2mSVafBpSC712tlMNLXILK?=
 =?us-ascii?Q?jVeVpbBXjne/RN60juebas9Pws2mRJ5D+PtrTpwgDfFP/mOHEFSNaH18+ESA?=
 =?us-ascii?Q?t4VS+LKb4V/l4VQai6FHv3gSjbB/LQAH5Yfv+uFfDqkLtCumLFxStKPDbygX?=
 =?us-ascii?Q?0Jr04NJbYuPuobjPugucM+a4MpRBFRsjPH7ZjdQJ7d4Hd4qZARBS6a6BqFiy?=
 =?us-ascii?Q?Fd8jejusvLtDHB/p6LJ5hvfmitgwt35vwILz5/D/sHbWmyt19Pz2t7xH6BZE?=
 =?us-ascii?Q?nrZRDTMCCJeB3OQ7EpeXAAMXRElObmnNj9T13ymWRjupjlEeI3dIUPI+Flt+?=
 =?us-ascii?Q?AdXU/5BSrhG5Tn12xC59vIoEDx+26zbjzlxkkEMzavnl/KrP1ctvGIcGc2MQ?=
 =?us-ascii?Q?6pZmGUaXQ+l3ojTCuY2ldJlvWB/paGk5WM3uI9L3sZPbDYQ5m6Liu0ErHaKG?=
 =?us-ascii?Q?T2YlvsBoB8mOfIfx57ErsHfIb8itqHts79CGVCP4rCMkyq/Y5LR3/OH6unyX?=
 =?us-ascii?Q?YaTCnRHNc43VPXOgxC6Iyfi++/2oxQgaW5S3PH/n6flhtCbKcxI+vUCoUbNY?=
 =?us-ascii?Q?t60WmvefZxFg5NZPgN3fiwTac5MWzZkLUii9r5Ea/8BSy8tsurLAf6y7koDO?=
 =?us-ascii?Q?KNxOzuhyn8YbRdfuGXAWvC3B3i/dwr1f5Y9TjPVAhojv9u3K94Nifbzm8E/s?=
 =?us-ascii?Q?Wi3QOzO/DfUMLh3dp60d11RMYPfY3AyJyXofcXohvYaXdrmEP12apUNfwlms?=
 =?us-ascii?Q?8dMMTlVZkeYuT3dDzP1+WRwSkV7Knp4+E3M4V8L9Dz4A3L3bf2EbOGLoSdC2?=
 =?us-ascii?Q?fcAb08uhJUKYQO51DQDheTZKW+8sXgcRL5czi80rdrmK0koSCnTG2zaUuVRk?=
 =?us-ascii?Q?Odm3glEWmagLK70wbnsPzy8Ry+8kiocMW0CUtbEH5G7NgrTje8eXMBSGg+NT?=
 =?us-ascii?Q?PvVLnuvt66ZSa1fegtMJmZKFiY5r2tHhuJh2INUS8ZxnM4C+NNCgXnrVfn0a?=
 =?us-ascii?Q?m0eyeY3XAutVH8aLqd6wuJBWT5m/gKuZToKPUV3j1PAZljIYemBCUAMbNubb?=
 =?us-ascii?Q?u1YY9zjTO+8Wt2Q48LErpv8USCWE/oA45FiwLfQR0Ho2H5lKKNKb0NHlK17q?=
 =?us-ascii?Q?jRJPMQjVi1atMB1J/Rw02Nf1DyNi0fBu5bbumrYwu2oYusaG+FveL8ZR41of?=
 =?us-ascii?Q?qaAq/+i/M/fHdBQ4Gp6zDBjv6RvzNlF+TE1YXM2a6J02HWUoUI1yWlVECM80?=
 =?us-ascii?Q?kX7UpO3CnMqJ4tjnDFO4zmI0fPuXAl02vqAQ2Wf0BVlQn+E4uASKARO09lcz?=
 =?us-ascii?Q?Hls/zpqAerni4oHnlUcFTVQTRpDn4g11VVT3D4TMNVfsn69q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87d06398-3d63-43fa-2cf1-08de8ba23454
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 01:43:11.3512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VFekZCG7ZVFfiM6akiIBo9NXALPTLeMxLgxPJXmDHLcN1+jy0i7bLGCMQI57LqCU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9264

Replace it with a check on the max folio order of the file's address space
mapping, making sure PMD_ORDER is supported.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c7873dbdc470..1da1467328a3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -89,9 +89,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 {
 	struct inode *inode;
 
-	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
-		return false;
-
 	if (!vma->vm_file)
 		return false;
 
@@ -100,6 +97,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 	if (IS_ANON_FILE(inode))
 		return false;
 
+	if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
+		return false;
+
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
-- 
2.43.0

