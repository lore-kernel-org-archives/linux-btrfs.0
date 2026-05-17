Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011051.outbound.protection.outlook.com [52.101.62.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6AE25B663;
	Sun, 17 May 2026 13:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779026107; cv=fail; b=PKyjdNuSXKbVBxFunubEnFNNm3ZKgOhWsz+Ec2s/k19v1ciBrCbq3moXBRt9+RJ5xni6d204ipCKTR0+GXN2Lyfs98hvxkEb/FTo6VUQaS2Lnf+kw9FC5nECJbhTigJddz+GACWjtevfl56pJZQAgs63Tj4O63ua5/3DOSEgpk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779026107; c=relaxed/simple;
	bh=jOj0MVVaidFDx1FqaAcZglZnJdgpNHTQLd1aKtr7XYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LeX5MZwgUKJs9eD1ym4dyAEE0xlfO9AOM1A4xc1vwPwSv2qfohCaSGWgIyF16NJtlzh1gCbtaox8wRShO3AExNa+lFr90CawgqPQNuHgD4aDGhVBUdS/0MwfJSTVUJ9aQT45lBo13ckPmMfR4C+54EHqsWXrvuxCRd7dOZeNRjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lDuhaQnH; arc=fail smtp.client-ip=52.101.62.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lDuhaQnH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RyxLeKbhXNgqqNd4QQiRYhApl1IINR7ywd4R0KfgIGreyXsexpI4dvfLWfGIEiaIcwk9nl3nh0Bi1pR+pOshnwUTZCTm/xUNBAe6ZvMdys1KjSMPHWwgj5Rskx1+kPZf8BgiRnZsBpb0C1OgEoi+UBiCR2geHBPC+1ZEe+IIDU6DVD5iT7+4OrPqAXqHIEUZRyucBAzDszec5Mkk15w7lNprKN0X/dlgFQycTo2NaacMG6lg+5goQzN4cebQ874/Nsc0WswMvFgpi76mRqS4V0ADhS8QV3yvFtZ3F7c5OBGOCNyb//s0pSY19BIG/M/9A52G4KultZc6VXHapDz/TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bKNKtL3UsTtfMpD+PllYtLxH4Y/lMS/CoXTKFuJOX44=;
 b=fxC7dUYIkfb9tda+qxBBaXT7oDdQ6MYqDRlWo1W2qqE6pOT+/eCzkUwLeHmc9cwY2Qll9Rr2CHJXc6/K8y7Q/xWb/xx4c3hFBE8VTmHFEn6LxTr+CvTTIeSi9TSIgrYlVCwCf7A0JpK0i6kHFgUJutWeCoKxRCpGftlpfKxi7uUExyQIbuUy75NTidBShe31yX5kFOi93u4jfYeX6qFMWsqWWSRkcKD10JGa6jF3sREsB2xvq/m7WUdmbX0vo9weyEVmvfA4wb5endRSkQMcxV81cQXuVzZPUUOzOzAT4mAz87TOZT2FSyaFD+3UGUYmk4hWfhZ/zarEvK19/kC/8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKNKtL3UsTtfMpD+PllYtLxH4Y/lMS/CoXTKFuJOX44=;
 b=lDuhaQnHtpQU07OXpoIvddC/R0dU+lqpjA9pudz6isHtJOmxXnUxPMc7vHF2TWuu3jbE3V9ItrW2IvjMrIZP5TQ674p8JQ/S/Z7s8DrRU14UHljsPLiI/7AIhrqpylBsSBwDniMx1+jSVeL1h0Aw2thhQOHSJir52+yEBZ50011IxXP26wUFm0a7yL+35wueqaK5Ltm8h3B1tZkDCLcdBRdvGE4wbp7BqbXMoI1hBVivjz6s83tBlGXnUo3xmpwSq0bf1PJ4eiTXeF1/OYukHBc5XUC/klY+EI4JWV+yztp+pRpoU0vYYNVtKm2yR7i7dpvLZe0eKGVAxJwKjW1n7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:01 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:01 +0000
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
	Liam Howlett <liam@infradead.org>
Subject: [PATCH v6 03/14] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Sun, 17 May 2026 09:54:05 -0400
Message-ID: <20260517135416.1434539-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0058.namprd13.prod.outlook.com
 (2603:10b6:610:b2::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: e43a53db-4c3a-44c7-83a7-08deb41be3db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	RrTfJ80jx0/44lfEdLpFNsjSMuoP7c5nkxFUtTltP/GwQ1KGDb+f1EONuaN+w08d80FUH9zE3+s5yVARoAS7ssKiQYgMiY5oTxHjk/mjytnVdM1e28g2Zz8DzACzkqDwT3zJd+OAFSryyNSo/ho8GqFa3hkTBNli0+XLEcuKSy0blO6PlZlgwl6Y0q2R6xuL2vvgG47BYWqR5wfCcnlsESV6L/w6w3IbG6zKOaao2RtAwpwlECLRSIg7w55lBoQSOv2HgqO3386KgTBSFLIYEFMoJvswMJrhdMJTmvDaRQB3qqVwWxog7/2FEF1ecgcUk1XDGaRLM0BR69dMy9VGPbFgiBzYuzmsJ41le24MpXea1PnGIANEBJxvTxsqxzA6oQZ0mLGVe25dAQE5oCY3omaBHg9nhftVJWYHNA9S7f18jIyLm3RbvrCTMTpLFNVSdiHL2cN38PCsEZcgmbw261QYUfh71LxIA/vwZs68jOQ2wVyOrzJVuFTFwCCF/uf2ItYCKUgoVakoG/nypW4h+daSrpJFaOF320ZJXbO6mSsL3yeBhD182sbpwCgVaifXHanaMffm+LIeNdh6u8IjyQxzF1oslmXWxJwRNphfWE5l90I/I5tpL7hO5Zg0lnczgKuy4KOmI9jsGjq3157MmS3VIu8UVjg12d85klk5B5CyX3l1ZEHIWUzmpJo3s4UM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IAsJCrOhgkAU8XMRhyISmI8i7k9uLoD9WPaXI4I7hKgChaCJufx45VDdzMXX?=
 =?us-ascii?Q?wRCLI6xBijSIzoteAc7CcMmie4vaWMZbXaz4S5BX3E08/N+gxR4CF1mFrkA2?=
 =?us-ascii?Q?nqy/HqeBENU9az8bkzg1iqlX2a2DPJgltAQSWf7FerpZ6tubNR66aIekzaLD?=
 =?us-ascii?Q?SA1zVGN1DkdaLaBIJ4YJ+lztN8cSRuuDju8oMT81iEQD3q6sTziwzWIgVgog?=
 =?us-ascii?Q?tip6DGAydYtkgdr8vfjCxRRKo46vVwCYdMdAN0spcQGp4NxkyOUJO9GbJoHA?=
 =?us-ascii?Q?SrzCvZVPe+hy5DKr0hWLD7IjTrQXSyVwCN+iqLUEsit5TV7yiZy0D4RkhlbI?=
 =?us-ascii?Q?l65MLaDN6LUuATlrjS2KaeY+fqKk8749tbxMY4pefUqmKMmr5s6wR7IxGQEY?=
 =?us-ascii?Q?dKJF0ZWzWII1Rr3pThMONKt1pNFNbLkdTuLLv1UJjgYTJ1fbQITTzNpJJK+T?=
 =?us-ascii?Q?6QhAsXNNjp21LVChDCuXwlFayi5cT5xO35DKxzOoWwo8UKbW7zimDy6IgrMp?=
 =?us-ascii?Q?NJiiTcwkHrxTzIsv7/4Fwn2FiAelLxjYJLTe0AlyaEjfZ/1rXtrfM8F2NspK?=
 =?us-ascii?Q?XPlCSO+hhSYSz+UPDfk5WiE3MPXa0NcQ5riFc31mBc1RJqPpVrvXPSZtp2ps?=
 =?us-ascii?Q?o7uZIJTUv8kee0tDnoeqcTAG4dJKbPRRXTNNDnQZyX5NUtTuwTS8Z0fQlb+9?=
 =?us-ascii?Q?cwWGDobzFaRPz6iaiKsFyAIVH/WffV4dhloBzsAysy02Mu9pWSqM/rlUbw9i?=
 =?us-ascii?Q?zNtzj5NOv9i1seI40prq06KGZG8yzp/GLnQtvzskmEvKHDM9qwH0dnXI+z5L?=
 =?us-ascii?Q?Fetz9DyGS5huWT9JkRLAxcGZXRolXAIO+6Pk4YR2U/cFWhYeIFgh+C0/kKVf?=
 =?us-ascii?Q?e8ENRjKXL70vWade37YB6Di9Q8rFETBsve2xC7k5oAOAbRzWEmzn1PQAkuCg?=
 =?us-ascii?Q?bEPFFA/ppA5lX2MGg7dEovjrQ3JBP7Vr9GHyeCLdATnviCFazLx2iyC9hpo9?=
 =?us-ascii?Q?cTXLIth4+5n83xSL3t9PM/Tzu+sf2opM9LJm6oa4bjJoDipztfqm/k3IRF33?=
 =?us-ascii?Q?f1MiFdMb7aWCFIXMO/WXzGm5fa9rngFw5jbekGymjNFS5uXjO6HdOOpD9Eqj?=
 =?us-ascii?Q?bxTwgHMuBMruHP+Bgg1k/q1hBCK9KqA0B7mwVdxcnTG7pz/1XwKf1POrpV6f?=
 =?us-ascii?Q?pWhBxF9nD+F0Qi1uE81MB4e5zoY3KwnNbUR36o/Ous0WG3bLg7MsZwM0qqDz?=
 =?us-ascii?Q?tOzkP8OTRrRE1MldCbrLk4lDT2IvVQ6DSG/FstN6KAj/AyCTtrqvIpisW0Lf?=
 =?us-ascii?Q?Scourz12UWy8jUlKatKeSTruA45I8SCpUK9EmFAMh6eR0WGwYIoXxUGdnPTZ?=
 =?us-ascii?Q?JYWnlVXURYmq1FVARrthuSLcIPXf4jni9XksAuRIe4zeuIDeUwha8zA52TDk?=
 =?us-ascii?Q?BkhQUmaTrVbxxEWulIxR7vFdjUTOn0biZ3t0DBOuGTN+sxg/U455QtmEZFny?=
 =?us-ascii?Q?dZNkHwYgkNzMF2+9Kzs3d+qR6cZ13z2kLWdzZ9JYuwhq34w7Crv6dNKXtdKb?=
 =?us-ascii?Q?Lu8sK3jkp/S7jHuhyj4gYpYFp8MWtyG9MLIYgYqLRu3PR2k1JOxQm/9qkNKF?=
 =?us-ascii?Q?NWwFon5P4DfmpAkI2rloS0UVwPAH6VvCrsYx3+YZ4TTGVjtG3VBM8TPIxaW0?=
 =?us-ascii?Q?II8/2MU7hB0Z7e+SMUuak/55qzplZW0pyM9nhoDeJL1XQQ0J?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e43a53db-4c3a-44c7-83a7-08deb41be3db
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:01.4437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4OfjzyRx3qbXGpv51JB+0Y+rvpidCvEZXwagiVhU2qrCDCCsa5KVFsDo72K8cCJe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322

Replace it with a check on the max folio order of the file's address space
mapping, making sure PMD folio is supported.  Keep the inode
open-for-write check, since even if collapse_file() now makes sure all
to-be-collapsed folios are clean and the created PMD file THP can be
handled by FSes properly, the filemap_flush() could perform undesirable
write back.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---
 mm/huge_memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3e9eabc74c6c3..ccd623b9501b5 100644
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

