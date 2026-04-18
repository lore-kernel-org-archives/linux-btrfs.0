Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011029.outbound.protection.outlook.com [40.93.194.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505CC330B09;
	Sat, 18 Apr 2026 02:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776480291; cv=fail; b=H7rgM20Jrpguw+yN/QP5WTSa1HH2X+VtsrW15plxm6kqs4PUvoCKH4Cgw+9IWbwfb97oU3UEvKJVoz8H+F1IAHBxblCZB9f3TaMnBHT67g/2arMY7OAmbxBWmihnXsMSvW4tipqfxK/PnT+X6p42Ki/vpEWC7SZOCDFF/PAfprg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776480291; c=relaxed/simple;
	bh=S9GPjPmBAdAd0Jr8iRSTEHPGid2GTR3R1tqQcDd02CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hWLSaogv+pr/2nfHAsJvP2MQmG3eCYSc9kINaEulDSCv/WaCay5utQwczZlT3jEeD8gnNUmTMFbLD1sDl8PliTkoHXEagwqOcaDIXMnk6f3ZiiJMJdHkkOjxOS8GIL59d1nk7P++OElf9CEpRGwFF2ragIYpar7CJG9dwhOcHRw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aDLyPsYo; arc=fail smtp.client-ip=40.93.194.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aDLyPsYo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bXU58avLH0f46bvQDN64ZB0rzFIkbrI/bzrzasaXUl1LebMyb55eichPHgUWW9N6dp0qHeccj7ReTgr7TdRasgwAlumeQJ0W0w/6OVRrjNhXyZ/VVGCi7bvE7R9lgF3aYsvjIDOJ19d7JotowKJRWu2NG/8Ohcx36GK5tCESdGoVbST76smgkq1L7FvVFMNJp2EvFCNHELA598AnC+vAbXLhMUAR2wFxS9Y2QCjUAc+q9D4t/aaafx6CKGa5H4mwt/VD1ryN0x8de+OoUt1klM5+zgVdnGA3Y/Cdf5QeSgqhTSdZUbAEW3G/xr5dm28t4Uqkebalxb/LEyzEkEOb+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mI3SI1+sbYWto+5gEkLLZ3c73o6GNJLpaeEazVaQezg=;
 b=icWVLVSqTF2w0GJ21ijnZO7ROpenTvn3xzMJ0ZHCzv5uilirpRru4Yk3iky7E48KN1nYIqbxPz1X7UxxG2zsWq2Amb3iGdoFIrdAVziv2Xm+LzqbqILGo1PN6xsCDcdkEWCgUC72RrLgsi9gdAmii3u8T9FIc3+1NSWlxQBvN+U+ytUTCEd0xpE2HHSXdTU55O5G+ZERzTBnE/OgqFnHyKZSBoCxwyrKkqHAA2GlhZFEIUot4MnbQ0Af5IlJren6DuLkxCS29xDWua28FR1dCEH9rntPuztv+UslWoPoE5zpY7LBF8ntAP4z7Le9KfOsm2y5k6yTGbiR39o1v5rPwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mI3SI1+sbYWto+5gEkLLZ3c73o6GNJLpaeEazVaQezg=;
 b=aDLyPsYoZvJ5D4Ztyf0/c01mfULjkKdIj3HKAYH29s45r0IgrMYlZLAWaGPr6F6/BPHHed+1a4GDnrcoaBShf85HPEtUo2Sb1EDaNV+Gv8jEHcXJBltk5VWEk+kurCCl7nyCrs6qdmDA1OUiQJiHvCHLru2p7n6k5WWxsQ8eAnOtdIXiHKXgSleK9Shy3WyjSxpk+6/UuS9n62GPrbwQ4ztgOVL7UTjBBYhfwFURkkfdmdqV+sb3Q3e0oJHxOQ/KVxdfLVmlOPmIYlxOEFTULv5yAh+3By7WFtV1YKOGssftzvUGRtIZs+XwTRwlIzu7coKhLZMW+3hYajZ1sG1rfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Sat, 18 Apr
 2026 02:44:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Sat, 18 Apr 2026
 02:44:40 +0000
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
Subject: [PATCH 7.2 v3 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Fri, 17 Apr 2026 22:44:20 -0400
Message-ID: <20260418024429.4055056-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418024429.4055056-1-ziy@nvidia.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
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
X-MS-Office365-Filtering-Correlation-Id: 4dfd4201-64ea-4c8f-09e4-08de9cf46e43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	dCOGerV/PR4ArnaHk/oW5xRiZp+64x7pipMvYL0oCxfmkZHrmOvP/k5f7ejKWpXULaoU4DCyhLODubDFyQcPwiz7fstf+zWRlpojYWN2hqJ7Tl0aa2XFtGYugXGFJAEZEpiFD9vd9Qa3Y2oh60WuaShsTcn0P89LU83jCK8/2euULOouDXCHM2dr/l0WCIX2ECANOGiAVhZd1QTYcXM+IqGgTIZ77pCv1/ss1M2atTHTKE4TN50of5ZNI4zY0DCNlaB6bwh8yRfzz0R9oOuLfjztF+sRl4dI3MvzY+F5nnPsJ+TyOLnBblG7SreXOH2CRbTBokeIVbdHATAi4d455XMPwWZ65myBlD6Lgha3Vj0oD12RbSU7XjxerJaVy6fw/A1yiH3ULN0K8oLu5IXnSNNf5/bBuz2Dnxzl3VhMEf8y+p5y5mD3pv/xkIB2SC2ReON6HF7geJqX5gUO7BxbYob5/qC5pQKVg9KJeeOzSbMPaw1xvHb/QKjdSEzhFycdKrp3qkmSsYRNIwS+2wJaYW3/s0gSRo71V1wf9S3NdoQ55Hlx3V4H3NfyFgPzw/lfQRNKCL7zpjDYZ9DhA+3SNHv1CgG2Xbug9E17xksdT8qhdTst/SFqFArz4E5Z7ihvRIepRwD7SRK8VIEckxD4ZtxoMbxKKmSRxqIG/hcoiSNvkjj0CBh+WRZWErTGCnaZNsuKjGSOj7KBPso16pBwLL1lxUpJGWUjNwCdVbEvUfo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?prDjDYgJw1sckYd2hrIj0iV/DB7nwa1NGgqVvdLIuU6psQVT0tTGnXqXkZkm?=
 =?us-ascii?Q?moxRIfrhwEZ1STc+hgx3Wd8BW78dTN1JX21ipvXvMlhA8PvdRV9eikFeIFLJ?=
 =?us-ascii?Q?ngJvuVC7cZ+XTf3WLN93d08ubIgKU+U6vpahkQDSOZteyirYRVA+4RQZI9q9?=
 =?us-ascii?Q?MjshR4WdDY4bwjUT4BKCt1wpizRJix0rWZmUfepfMFsrHzMTAO2NcKK0NivL?=
 =?us-ascii?Q?5FpAcXj+jww270q8vN09Zpoj4mYIRD3AsCNC7AD6VcN0FtdqsnFTXqzFF6hz?=
 =?us-ascii?Q?ugYBWmCNFuU8qXJDKrfvV0qxS5W/Ezca5yI5X6kHHc6Pqz1LDxK5s7beL2o3?=
 =?us-ascii?Q?8o7+DbnIfwgDCrIHKA3ogfPrwGgZ4zNULi+GKMbqJ7acdHI1unVIfSCoXqxs?=
 =?us-ascii?Q?/tDxbqsbDixzQ6jK60vrRXYqnmxQxg/2rvcHliAgde3lIIyk5FYy6Ws2iLbu?=
 =?us-ascii?Q?JSwkKfxovL9U44kp13REAczjZv/aL29x9zzUcPOJJCctjOhP3f4K748Fe+9S?=
 =?us-ascii?Q?8iInqEyi46t3vXxGmZ+gz2Q19mnCAKvs0FlybFHFqgO6z91OHdF9uaUBW5+t?=
 =?us-ascii?Q?lz6BxkkZEj5AbG+kvb8euAFLz8lbulwGxHhNNtWjpruUnwI/fF/qlLDjYwNP?=
 =?us-ascii?Q?TNB992wr2s+ILLncCC2b9A0ViHJ8czxscL0flNTTzoU1m8pkSaWC1UCtOinK?=
 =?us-ascii?Q?5tSug78N6tThp2Jid7WeL08sRpco306cCy/ui+jIWMMemf1wDFcc45AHsr4E?=
 =?us-ascii?Q?Vj8eVxb1zHwOC1SSMdO2KrxDoT5c0dUKd8XCxbY7t8CvgSjPb4CQIlm7JPwS?=
 =?us-ascii?Q?VouZoDALkTKT+5/ar1N9Cgj5PLu7Xt9hq6XqaU+Sz5Jk5lvbIHDO6Q0ExdPp?=
 =?us-ascii?Q?KaK0pNoYaPAc/VGRUKIM3Q7Z+IsNQlgcaQ42k+HygqvKGnxJthHbMHQY0DjU?=
 =?us-ascii?Q?Ne220iMocRJ4H4+JoW9ZHaDkz9reYlwa6KVVp/FdGRgb1pGaf/+N4jLFrh/+?=
 =?us-ascii?Q?e0owHwcJHrTuvAitkFP5zhtDvoZMe7QZxsa//TKMcaH2RasF+LIn2XFOzeWW?=
 =?us-ascii?Q?rVbAqcGdcwmioPIPSp1VMkXk8RKyLP2yMxx0w0jEo8v2QhIKnsxL8RupMkg1?=
 =?us-ascii?Q?NIwsrabblHhpzBB8LJEzMJZ6cR0QwJQSZCNkaLgLizxeuddOkA/qIt1dtFrH?=
 =?us-ascii?Q?br1ihm/lh+0xrHcG7BNZFXk/CKneP2KFILl6Kwjimn+nHMu1nYifWAC/y6SX?=
 =?us-ascii?Q?G0hVB3SaiKNeCSuWdBQc96d8ZKUtd8+QURzX4Kg+fQt/TwYY6u1/UtQx+XjF?=
 =?us-ascii?Q?HdkZqFGpGl4R5WlaXvSYT+xiSvqHkAw58AQTlywNGSVzqlTVjAhjDDklv0UA?=
 =?us-ascii?Q?QARMKmm3ItrPPJQtHuVVdy5Xd/ARzB4R5/k5ErVzrP1XS0FjOJhZDlSBWQ/f?=
 =?us-ascii?Q?X1aGAhj55gURmN+u364s4qNWM3xf4plGyYE2qR8nFAnpI8GIGCVQ6LVjirRL?=
 =?us-ascii?Q?+iBQQ9rw7VeJ1BodxVdwySY4k1mitS6rCpLnMWq0I2RSluJ7nfRXAGgD0JPE?=
 =?us-ascii?Q?fn2i8xabzqzLBnvDSA1g/4EEAjW68uOFt5VNRbxXOVoyHlXJsGCqRcoReILD?=
 =?us-ascii?Q?ZdI7DA3qikO+8vdDOlBsjKVBMIRIMKXsBsgHrMCH6m3M/AhU6pCxt6mJi4S4?=
 =?us-ascii?Q?L9g3IJVzfzz4IpFET1rr+J5vdNus+almhvq7+vi3Sny2sp0a?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dfd4201-64ea-4c8f-09e4-08de9cf46e43
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2026 02:44:36.9859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kUAjD39Y9CtCQBGyCax/GMpjXTBPOS0mzyl8EC0bBHzDKnLKrqF7oa6vfWhvpDdi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650

Replace it with a check on the max folio order of the file's address space
mapping, making sure PMD THP is supported. Also remove the read-only fd
check, since collapse_file() now makes sure all to-be-collapsed folios are
clean and the created PMD file THP can be handled by FSes properly.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..7e9cf8c0985f 100644
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

