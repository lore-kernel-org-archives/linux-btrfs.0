Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012019.outbound.protection.outlook.com [40.107.209.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAF22FDC38;
	Fri, 24 Apr 2026 02:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776999163; cv=fail; b=Tkqcfs8S+Kw1EaT5soVzU/M9yDTRNdFa2lbx7fejivpfafstKLljfx+GYK45YxVN0GrcnQp+MY2a3mnOaPQBjzle4h5/SKR2WL0wIONnB+z/vpqoKAi+js38HQzNmryrd6tkTHX08Vkx3FBXqE/KW6YO2qlWtU5Emx5R5iobrdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776999163; c=relaxed/simple;
	bh=Apvf6RUNCsJYqOaD5QjZO0Eh5r4My2ROkehxhtfv3Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qL8MHuChhxEB5RDtWpRCtN+5EagtaHblRTRN/Ch1hfADA2VnpFHYhmpgVTrPMaAHyzQeHJnsp6vLnSsTJoUrAQ3z6/FmzuSZkncW7afYvRvUNCFJF+PUfFVgHF69OcvXJg3Fb67xXYHPclqHBO5lPEV51mkCPmcHsG7zhWS/jYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GTlTN81a; arc=fail smtp.client-ip=40.107.209.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GTlTN81a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e4+bqIa/G+fXf6y/nhZKvsJIorbA/l1Hi8/0QA9p7e1EJsC3ZZ5K4yzD+iTp7/9P+z4ju5Cxqoe9M287Yv2R2dpXDrYIMlJC+jIqdyCv2XIBenZopA+yfvDtuQCzk7QMVqLwBfoftG0U0vEsN6zaTu9uoEWZzT2SGssC6bNi7GPvlxnNPro0nq1ub9/pvozIax0SJ03CB7ApFW+EL/3PykPeqjpBMOVgTcSevPoTV4NTuf+KXo6fBrY9dib9+VxnrFEh68pO6QUOems+CIytdouvf+S3yHp9AQDBSI2ktArDfL2omHUc9UW09B6LE9Tw3BUGlV4dnXHq5G9wLs0dPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JFntIgk9uj3iXP7kiSDYhEA9wFOSYyCiLjWj2zSH/JA=;
 b=s5xYDdoKEKY7WpVazswcJs6DR7myQ1hjC7A/Q2QTQGk07RH0RKSbvigxl+t/Va4L2PmPJfcA3Z408YUm7HyMbJXYXldAjw7rfrUyZwph5R7cC5NpcXUPHLmiNBnHUXM2Lj3p9ZPrrK+1WdwPwgAEd1ohUU1OPPWTNNdybXycW/aPtUPjSjzxM1Nk1uj/BMfmTqvXbzRypG6uWSJibMWeUrMIQQBTT4TLsxictND0+oMOvqq8+Gf1UOoolEt+D8cw12Y1f4XnZ2rf73ENdBGcMss6+6GBeBbGIwskPoGi7IGOMte8vOQM2YNXK2VI74LVH2adCAQTxaz/B9MEX9eSPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFntIgk9uj3iXP7kiSDYhEA9wFOSYyCiLjWj2zSH/JA=;
 b=GTlTN81a99Bn5xxqmE4jkJVMyIayLO65hApgcO4miCsfgbvX2aa6MPFD/SPJ5CErKG1zhfn5QZWU0vvPq9FRzyqLDR1q8yTXfYOHsOzwN/++g1tr911cuH+b58e2DWjy3kUBur/gJAkLQoZko5z7S8rsWHSFLXw1gmnWnF/BIXCxs2Vj4Z7qDNjOFFQiV9Uj4swroQDJUTa7gbwm84JRccv/UqEgAbbAP0htK6sKm1fWORLpqoT3j8L8fSlV67JcIfgXwfAQ+2/Q8wCKAdX/sQxYjJhaN1SiPYf3l7Eg4kNVLkuM1ixTRVIZBM8qAV5662l2Get0WFupbnJ0J0lA/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9588.namprd12.prod.outlook.com (2603:10b6:8:282::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.16; Fri, 24 Apr 2026 02:52:13 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 02:52:13 +0000
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
Subject: [PATCH 7.2 v4 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Thu, 23 Apr 2026 22:49:06 -0400
Message-ID: <20260424024915.28758-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260424024915.28758-1-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9588:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d0ea972-8211-49e4-47fb-08dea1ac7cb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Sm6GOF1wNHGh7ef+6rtIywDrqJ4ly/+X3Sw+hJgG00D3e2YNFhLdhMD6i4c9AuExGwMtHVgsntgHe8s5PN5dcSdbijbmvw4a9wG2xQq19fqC7N4zRKbhOrvJmdN/FQJ4qNeWt8BUttUOfj9VTV3YT07me9w5GsLuIjyx+iXPpz/9cjOdkVTwjplKuNh3T5SR2eECgaKaHrYCoob0Y/sjuijbpVo4V6A2+9W5XRxBoULmb3EF7VbtOWhW9BTZVr+WH2msBeYg34q0P8mjck2NqS0uqU3vWvcpj5HqxltOpdtBBg19NTGB2MwXUTWlKHVjlZCBYQ6T7SuOKSbLnp9CD3FWW3ZiqgH5T6vc5XaTaK7XoICVgTTVL1BdBDLJuK0wcIJxv78rNOLLRW0CPqBRwvg6OdS/lslRuTla23H7LI4SN/uE/YfioPw1DrqOxGAD2MNJFTNFacaPyRgh7o5h6ha/cfwm0jKIE+WOCfRp50m/GqqvcXS4HZAavVCc8CiKEsVw9Hz3n/om3R/LoJpd9v9oGhwPlAnO29lcYxDQDbe0k4hCZ0msMvpozYviL6adPYIgvaUsNTdqskJM4xA/t6/PfMXmykxt6vvGLxarZ/V35lnmyL2NB5O9208jt1Q6bYRkay1Z5ztxx2HwVwGUnTo8HGRa6KwI74TxFyoyNJhLuGb7ODhRGR5p0AuFDFBuOj8hqCX3LYo2+m2BuUSQC4gXPY11rkk83gM1fwTSd/0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a/FnK/EQtyn185dJjsW4yAbwZ/CXrjuQSXJx0M+qWRFuuRwdTuZ1Vdb7lkwJ?=
 =?us-ascii?Q?CmHF8DAbnxIRviK/xZNx23lwRlxobxfUr4bzrEJxs2QVO1+YrguCA8c2KZB7?=
 =?us-ascii?Q?OFrD+paHnaTWg21N2bSBLWAhPHOtv7FRZFoUJp17GkjOAa4XL0mAIb5Tw9m8?=
 =?us-ascii?Q?PC2JMARFVEaAnWDcpkD6bReG6UA7ScSB71rZk2O5apyKCy5gwtOvfJIueePy?=
 =?us-ascii?Q?LaepQ9aYecOrVxEx3+hzWO34TYllQcTz5tbcbPGRGLjjg9Jf51W08o05IYso?=
 =?us-ascii?Q?Tfn0pNicfpFvZt6qyj64jCS2UodtVkmy8SZAy1S7l+3GShbxrHTT7On+/2/s?=
 =?us-ascii?Q?77BeY0pUB9IkwrS0XZ3AHlTXCvumIPJOpkwfQ2HF31DXWfDTdDa+8AKgQ4hK?=
 =?us-ascii?Q?rr4q6uyZc66kh/oTjkoGr/R09/W49FdvHIVAjFRYiMaVw0q3O1B0Dz0NQZ5F?=
 =?us-ascii?Q?AEyimTJ++sopteXtnFlrCYtliQ2Hm365taRoAxOQIiyomaM7wdSvczMgkSbM?=
 =?us-ascii?Q?V4711l8YU0WdOkN8W3tK9+UunE7Ip3BJCYJbtf6EPx0PEifykWetlggFVYv/?=
 =?us-ascii?Q?ErhZIY6yGfMOMQ+C5q8OvjhowjOpvvN+uVPeDOvK4+OMyjVRoDxAzfXLPGTW?=
 =?us-ascii?Q?gov11O1sSR+PvdzOsn9SkevQlCmPzxdGo1XOzMU546nxjc7iVtmSfpQWR0ot?=
 =?us-ascii?Q?fq6sOzbS/6JIkRDJ9zVrEusyLR24m6Mi5oey1ckLAy5YVYzUA4aVF+sJidqB?=
 =?us-ascii?Q?YAdQt8ovPdEB0hDxy16okX+i/13YKgA+gzz9Ax4/Epf+g5if6eubNB7UPd9p?=
 =?us-ascii?Q?9qHIRIks1Fp6QAqDWbRnxgHbQK+o5lj7DzfEmS2p9gOQ5Qq61ynBAjvTfcCU?=
 =?us-ascii?Q?h9WK81W0ueMiDY34VXlgkvh5hwcrwZYgELqx6PMD7gOTjgTOB2Lc2aYpy+HW?=
 =?us-ascii?Q?Fv6RZpNcxS3pbVazPdaMWw+u5gFp+QI2m7UIsktMhQOdh/hqwdeZjEQ+TAU7?=
 =?us-ascii?Q?knRKdVAtktDQz0/JgOLA2iIW95bpBYnuvRxvOUZa0W5M5GT4Rjo94A+wIIWp?=
 =?us-ascii?Q?vHf5LqQadZwfKzxjdpATd94pR+/Iz1d7mCAJS0aQ353kwoJQw8HzrMtca4i8?=
 =?us-ascii?Q?fVMJk4WlkaTa9wYsv8Es63BA7CGCOX6tJurYWNpejkksGAuolV56ac7Sl7U6?=
 =?us-ascii?Q?b/OrB6ZbjV11Q4RfGNfOckfdgGz/7DNthOG+cmpoYR8b6SRezykVEfj0xUXv?=
 =?us-ascii?Q?fGXLUucCalNzr+ac7KVLGUNYUs9WxjzCKUZeAooSTbBrfiBPjWcg7J4VrZ+c?=
 =?us-ascii?Q?wTlycEqaC6sVRP8e7TqPHxN9ToLKpYSOe3EeL8LRHjHICpCKPcTQd4gk8rIj?=
 =?us-ascii?Q?ssGB8IhCumULgt17YaR8WjXiyb0MssaF9GEN1WvSEitm/teLap++7MtRfzb3?=
 =?us-ascii?Q?g3Tagirj0x+V4/7DE0/OLyw4nry+YCNwiJ3rjbmKtYywwajV8/8QqiuJM2Cl?=
 =?us-ascii?Q?0dUGlQqFUACriFFNw+S4Osx9HnB1C2DvqfoxYl7NGxpT5TZmMl+yeAFL7Q9Y?=
 =?us-ascii?Q?tWaUPCffEeifNMQzqC268fO+kBqJAIa/BjUtI2zPq4G+AwdVxpwOdOmlxLkO?=
 =?us-ascii?Q?3J8UWU/f8cpvzkUoN0BYFwSQWdRUDMcQUZvLDXcQB+WzNp8mStRl4uOWwn4S?=
 =?us-ascii?Q?vmPnxDmxEtEqY8I61nQ8FDX+pVhUn0t75gdbcAFSSWRlPhAu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d0ea972-8211-49e4-47fb-08dea1ac7cb7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 02:52:13.2806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mCZgH5JhZWO4Wd6lySJD1dsnT+HFipnblSWG9Ovcp3pJ/HhJ9sxDaoY+bMLhioZq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9588

Replace it with a check on the max folio order of the file's address space
mapping, making sure PMD THP is supported. Also remove the read-only fd
check, since collapse_file() now makes sure all to-be-collapsed folios are
clean and the created PMD file THP can be handled by FSes properly.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/huge_memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1f0d0b780943..f0db1390a18f 100644
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
 
@@ -97,7 +94,10 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 	if (IS_ANON_FILE(inode))
 		return false;
 
-	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
+	if (!mapping_pmd_thp_support(inode->i_mapping))
+		return false;
+
+	return S_ISREG(inode->i_mode);
 }
 
 /* If returns true, we are unable to access the VMA's folios. */
-- 
2.43.0

