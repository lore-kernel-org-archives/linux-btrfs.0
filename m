Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010065.outbound.protection.outlook.com [52.101.193.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4963368AD;
	Mon, 23 Mar 2026 19:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774292825; cv=fail; b=n/WLUSXz/XcJdA6sbcmfr8ofBRiM+80fNwM/ca0N54jpz0Xgp3oZCvOydLFDucBxgNpH7JATAweJtr8G/wGRcxgnAij+bLN4t0U/nfLnXx2+6HsdxXK2DZ1LTapwTodwB6h9BkMpef6Gw3l2f2eLCy/T0VxjzD0cuh8mQdJsvWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774292825; c=relaxed/simple;
	bh=cjqG4q4Gps0IIgGkPtrHKjmucrLeVNioajDzDzWB6DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A6CNFYSLJTf5KKquwOf3u3aJo+bgWxmoAwYWae0K9nFif9fSmjL9RPJKGeb+XYWDsBLPKDzHIIap/Y6QkxSySWgd1eZZBl0l/2uWcMXdQQM547z+uKhmrbE3WlH6S03cSo5wbGVc5DUEWy4I6x53N/S4Bu0PC/ZsPuekxIzPTcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SR7kVzOy; arc=fail smtp.client-ip=52.101.193.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SR7kVzOy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z7bqPZtULMxNxSQ6iRfYD/ZitzJZPXp+nIcLBqKH0PAel+68bTMC5+xrOXo47VGJsO+kzxxa/Ou1dJsxhhdxEE9MHf78MFnHXuF1chG8uaqdySCxe0cXFaj9K2alN7ZGqCWA5Zi9hjqDvtf0Idnvp8VOa/SZGBPHnIXG2RZAjHKl2JWGDXv1Cv4cZqElmRAXjoUiSYWp88tb+gfcwcGdQ82lPOHjahnXP0iZPS6SYqAtAk87XbtOBmQqXKxUAkVKcZd/fKKr2+fo35TZ1sy1RTX7UmZgYptiuWPKojH7n2g4d+D3xv/gvOT99g2/y6mIdaZgBwXehyTQCcVQeMaG9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ceP4c4F8tMY+jMuTWAavGqqrJRCSI3h+rBcNc39qDLQ=;
 b=MiMpZaigvQv2no1mXVgjroOffQGw7GG5SPSFfl4bXQ0Ei23Eeo3OXVkj2kJcORQPK5/c0XDHxqml0sYcrUzw7LY9wGEQ/MyuEtHq8hu/JNrljVFEBq3uXrsVWOkn9UdBFadi7joloynGCOajJzY5F9q9eY+xd2FnBzGYZ6TtOKEHdLnn1BEseA1llN92tC3deW5HgtM260YbRXsPu+0rXklWkybbeCf18tvg41gg1GMkeetnRfI30S0OqU+KFt6LkvrwVaDIJ5zuiIthbcc+FKy7dSSBTL5NwYpPDRv3CWIPnJI2Cwik/AG5O48++qb7zvha1IE6aVmkGUHw1250ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ceP4c4F8tMY+jMuTWAavGqqrJRCSI3h+rBcNc39qDLQ=;
 b=SR7kVzOyWqtYsNXa+yajRzCKrs+xOA5ImxzIoEvVsITAZhSzbVrku8PctR5PrsYVcdrF+v4HTCZZmFACoEBuIIXcEib2EMCFdIyFxtjdsaih4v+pJZU7wxn83vIB4i/nCHN6q4+3tJj0Jp4aCmkrph2mTMl2jz4Jcp2oXY36F5zNJQosDQ0jbdRLtmSH/BBL7hKxV+m/lXG5BiLopHcPmB6XBbWhdm2mnCVPlVSqG4/Pz6J9SIqhe5Q4rAWtK67lCTtwIwHWWRZR8+3MS1nFta/vH0koD/yRFNSHBn0GNnlnuVWhyfscmZGSTbVUIkaafm/Py6gOtA9Bwno4OgpTNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 19:06:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:06:55 +0000
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
Subject: [RFC PATCH 05/11] mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
Date: Mon, 23 Mar 2026 15:06:38 -0400
Message-ID: <20260323190644.1714379-6-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323190644.1714379-1-ziy@nvidia.com>
References: <20260323190644.1714379-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0026.namprd14.prod.outlook.com
 (2603:10b6:208:23e::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: 224571ae-d48b-40d9-a342-08de890f59ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	fVfWokWQjmDkGrsIHCBehJlI3zx5DodGKcABKysTGpcXb0NdI8nEIm4VJwf+e681mnxchxu74RwzQFK1ueA2SO3aiw8zdklV2m7/D0SAbb2GlinFgU2jXVmA5aFs+NjHMLyIyXZ6/miXM5IARRIdYlQ1KwiTG9WdC7SAi1rbQ9Rf1meaP0Bood30qgJvrNAFdWXMzaSQJXlAL+6vcwnElm/CqJJMbZEni78Pp3liLI+adS8wHp0VEcoE09FDAQjjvdmN/DiaX4We7YNds3RUYkmrCJtKKmUDtm1phJuryMBgMTTo9vJc7XRcHnFIJuEnCM6yPZQfmDObmpcqBTmJLSr2B5UEe1TAO+6KqHwOPVJpICfLmQCcSMKYpBrIFxdLUe/MCsIVpLI3SYqIFRjs/MEM/aG80UM+TRHgUPLVaKBIAWWTdO4NO5mOYTJxUEeZ5HCZUXFbNkmppqO3b4TNBnM5No6uhjStEyFlS8lw8V3s+t2cjJjLpD5Cz1c4f7ckPO6YgsyPg1VOjVnxpT+1nAPsweVnpZ7yZieYpp8yR47CksPSbb5i7JCyHIQmfZjo2wE734Wf7VyohAWkUJI/GLtZVkoAU00GR/gTlEDwN8hiEG/1jIUX/e4ykGBZNTY+CRMU34V7x8r5DZ+VncC5XqlNbIicDtPjzmUFgHLCcCj52kmanOLjYn/8OHfMMyvSetDWicnPgK7TVaGao/NEclp200LlN7wiy3nzQZcriEQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N1zItPJJSRToN4zwSf9VkMFT9pA1QzucVPKT/5E8Io9W2Q/TPjGYnEHBFE5s?=
 =?us-ascii?Q?iQ4ac+6uVsNwMV7KvjgBM3ZfZ5gAFbZQw0CjPv/NDARAJfHwj0FC9NMArS33?=
 =?us-ascii?Q?FK++ehH1kClMoLbHKUR2GZ1EKdOmbnntsZw+oKybtRKXQ2KWFhEfX7ULwXWz?=
 =?us-ascii?Q?+1/a1V5lfmV3uc2RO867vzYfdnP0L42tdP3AgnRdUA+KylE1h7MuXa3nYfAd?=
 =?us-ascii?Q?akJ03sQsfSQ7kWkX7/0s/SZW9tAGUU6mMB4z6VKa2d2L7ptFumR7ll91aEf1?=
 =?us-ascii?Q?BBRp7AnZkPSt2DrNj/Ch2uM4M9J0FR0YWtWEvuJVWrKaTrm/XeEvb+QJ0Ndg?=
 =?us-ascii?Q?lP5OZpVlSALzEPvRDDBcxaqPwrqvNL6XF4rAYh8Do9H8vI1Qx8EkK9O42OlU?=
 =?us-ascii?Q?VJ2oyNq1VD08oSm7BuI4FwZ4ZdW07UowAH38qrolE4QksiIggPxH9t2AbdwS?=
 =?us-ascii?Q?6k5yxIVcJGkEG3yhliOV7Xar5/gszVyAvsDrJKjlobAcMLSEHl+7KziyocQg?=
 =?us-ascii?Q?/krVChvE8KNWtC1TBzcTR1ohjVKtpWTvnfaxa4wkbxcOFSG8bjmaGEywr9+8?=
 =?us-ascii?Q?CfJFSo0ZgmB+RUvfMzMqvc7V1ykoZAZc+whW/aHron28kxw4qzaSi1gn4OfK?=
 =?us-ascii?Q?VcdV/jc7YSM8agyJzYzcrnqzofQXWs8hvlG2hnAZIrgo7T2UAqWyYUwPgmNx?=
 =?us-ascii?Q?ktmUjoQc3B8T9gv89u7VgkgVeoWs/CmuAnHTDPEpYfU0RSxoEehLc2vDfGyb?=
 =?us-ascii?Q?WsXBSFW78C6/mWFNr4cJEXtREEWh1FTA2k425Sq7gsnS7nxXzV0ckCmVAx13?=
 =?us-ascii?Q?Lxay2UVwDLv73GIWBcj1FLn4B3EOi82dxpOXF0MpoTd9JN3lT4aIpX0wRCJz?=
 =?us-ascii?Q?JMRi8fjs0qLaWYTFeNqOBCFJoDjIj8Nrfyo6Id2NRGaRRxF09u3Yg4mfDiod?=
 =?us-ascii?Q?X3WEct5B3KjDF6+MS6Vqr7pa/yFdFtaxDKsFnK4fuE97bvbn/m+zvWtKmX2A?=
 =?us-ascii?Q?ADdvib9IDMLyTax8+dq9NqvKuKIO3WlwhryUz2pEF2NLv/A/HM0emH0cFdS/?=
 =?us-ascii?Q?9zrXk3JL40m9gsqrvbWJF+OQ7PV4UMT1rXJrEDmj+TyGrM+YxEeQRpfLNigZ?=
 =?us-ascii?Q?9icZLiBi6nLzLR2gOEeY8w2oPzF3F1n7vwfQXESS5VKsTjqBgR8tRBCvXcsj?=
 =?us-ascii?Q?DRQ+1LdTZw1xTjLXaPKs0kUyXlqm6he5kY9FVM0T7h+K87O8A26kyp+gJT8q?=
 =?us-ascii?Q?b3muAh8wf3Z+ah/51fLzPCUhl4n/L+P4m8ZUE6Yrg/FPusdLLPIgPIN+xlux?=
 =?us-ascii?Q?/hgADEKEmdo9ktbIrL5mYpasUz34BdSkmTeh2EUgu/jk3ajXJNA9xaWnVJkr?=
 =?us-ascii?Q?lJ98yj+ROD1dwhqv6AKswMVNUVTUZ7vAvwB1rzyxtSnM5ynMFOqtk9cx2kvs?=
 =?us-ascii?Q?JiKqYrWIZmyojAfWLyLKDn/TLpRPK0UBSeABesjwDefnsDZL/gu8eeNjHD5m?=
 =?us-ascii?Q?vvjJYxM/tcE3XzTTvFdlzdqVMvVsss3oNUrAXlfJQTX7pxiuR0sIhVSkLMzk?=
 =?us-ascii?Q?QlBpWdRMO9EVq06uCr8FvBWlSFrbkO6CgkSdO66ZwI3y9eVo21efwjUOjXVG?=
 =?us-ascii?Q?261t9yyVvVA1CZUxkBOS5uvr2DuGpJ3xhle77ou8iH9Hs6e9LWG7anNvttsu?=
 =?us-ascii?Q?y7owb4IkELu5nzckb9Z1BJf5vDaptHCVHKM1LAS+udJ/cGOr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 224571ae-d48b-40d9-a342-08de890f59ad
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:06:55.6572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jttiNnu6rw7/th6eaLCNnyKPm2qDVyWWQmW80GhCRauIiPiIAfCJk4Z3fiXciYfw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813

Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created by
a FS without large folio support. The check is no longer needed.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index de4a1e6ce376..c7680787409c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3710,28 +3710,6 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 		/* order-1 is not supported for anonymous THP. */
 		if (new_order == 1)
 			return -EINVAL;
-	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-		    !mapping_large_folio_support(folio->mapping)) {
-			/*
-			 * We can always split a folio down to a single page
-			 * (new_order == 0) uniformly.
-			 *
-			 * For any other scenario
-			 *   a) uniform split targeting a large folio
-			 *      (new_order > 0)
-			 *   b) any non-uniform split
-			 * we must confirm that the file system supports large
-			 * folios.
-			 *
-			 * Note that we might still have THPs in such
-			 * mappings, which is created from khugepaged when
-			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
-			 * case, the mapping does not actually support large
-			 * folios properly.
-			 */
-			return -EINVAL;
-		}
 	}
 
 	/*
-- 
2.43.0

