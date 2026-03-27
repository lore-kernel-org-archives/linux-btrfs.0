Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010035.outbound.protection.outlook.com [52.101.56.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC12C3128D9;
	Fri, 27 Mar 2026 01:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774575792; cv=fail; b=bCRUnOotwj1ZWb5Nx2eIVYR297Q2K7BqhIfc4V4b7Fi8O+ajyGeBRSEXnvUYDSENXpmloK7/ojk2etBaFL+2B604s5tCPFltxWyLDdUCgx1uA1ip5u2OEJT4GKqCsrINZy99YarGoooXsBQXcQrPKrWa9t2jifJ7+B/mp+9AiQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774575792; c=relaxed/simple;
	bh=2ZK+I1QUNlvdXZ+KuPfOpRDbCFlsmezOhD8RTWnqbPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FckpVZGfAlEv3Kc7Wgv5cQtnTJAJacxYWtDxLndnqeGe0TwAnlJRcMtekCKk5KSxpdj+/8aCRAEPYuBMHRM0nnuKEMZnMWWHI/V/zQPdGNXHNYiVaSPhTbk757TQQT5vPbjAzFFayhhidqQ3TMMSmVBlAhMi7SP0dgdPSYsr+ug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WMirXuoc; arc=fail smtp.client-ip=52.101.56.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WMirXuoc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hHm00YlGaktiH8QEe8haK3gQb2suyoXTvrm3pyZJuupS1Fl/GIENLSt8kfMmz9Nayj/1kTl2M/2tKtIejvYf+CUz7viQaZQt5Pp8WDekYuiPeZj41Z1d6H6nLgHh8nomf5nTgkuV8nCEC+id2Qr9EfEraeZ70JB3mmVcTLKSmKeH/eJTZ6y6iFcm3m6JJ74GTEa9UhpiWIexBI48RJC5ewmH6pJVgcUNEF+nJdErQ9o+QtHdd3YQ8cu1k+4xVmm2moJiyrUGkUpBx7bIX+lW0Joshg4H9ZddFII07hUNC5RnAM4u3dmKjsJWmaHPZxtjhtrzZi9dvDCJMs3ZaGI7DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IHrWTxcvcz/ah0eCjmkygDNgSOCoI0wu2JxMZZ29qB4=;
 b=lemlaJg/mjbXu7OYumCFMr3cFdhxI4xqQ24cL/jE1M7ZTegVBq067MFqNKwhqcPehwHSF8c4fPnfzzAg8K0Gkz5r7Q+uPa+iJKVGt3Hmp4ZstSvlCcbYSb8a7HfXrH07QI4sJZyfLJ6+awec6BGGDONf88H1yJKcONFZYCxukaGSb8fXT4WT00u8dBzefkwSeYtoU5imbdFs8cpVYH9EVf6Urh45QTRMcvaCmHi9wQh6muZRtodnodiPq2v6gr2HRxiJ3hfK/oXK6k27YXESFmXOe8Ez2WYaVL7kiclVMrN9/SnJWf7pyUfGed20Fgn7KZnBmoR6NA2ZrRntKw17hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHrWTxcvcz/ah0eCjmkygDNgSOCoI0wu2JxMZZ29qB4=;
 b=WMirXuochUqR9RoVHTtWQDAsHDTOWpM4BY3B4VRghWWrwENVx7UCeGY03dCw1o27bwtew4c7f56raTJv6Hc9pMRRbllMvKLigtR10Z4UJ9oFy1axgzagnSJmMpA6UXBt5wxt0sUyqP0uVFaFkiB4glr3wmf/0MsAIfCnSJl9f+06J/q2+pL/u+x0JcmYK3kpuDh9/SCqmqUJIzPmdNbzSQKQFWkRI5zKG8QFpMBgsTy2Kz5DNbZ2DSFpNH6jqKcYecuySkY9fNHN1SeAhMO63P+HlPSzgqwoGQwJl2Kqruel1jlK4kDA5E4fNrLBhx96AjzA0Zw9ez0zhRMHHnVg9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9264.namprd12.prod.outlook.com (2603:10b6:408:1e8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Fri, 27 Mar 2026 01:43:06 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 01:43:06 +0000
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
Subject: [PATCH v1 01/10] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Thu, 26 Mar 2026 21:42:46 -0400
Message-ID: <20260327014255.2058916-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327014255.2058916-1-ziy@nvidia.com>
References: <20260327014255.2058916-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0361.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::6) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9264:EE_
X-MS-Office365-Filtering-Correlation-Id: cc2b3601-15d3-4018-e749-08de8ba23123
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	b+edGsDDRmxB9JAnBizMSizOq1eX1KgXAC9KIXEvbvKg1RKvpocskVu6+FBom1l3sQC5upZUYhSv0bW2LMqYYz2zDSdI19nDL20LDlZkLuT74/upQTrtueBvsMqmZ0uMQxfe7B1/JPh+JpKtIhbxPb0eqk2inV19iSJyA5aQB2i5UdbysHlujTWH+iQIxXCUn7dYv2pLOe8EeP7E9IWkblDwEqA9J+v9SFZGABg6e3IKKiVag9sCPZGnjKDKIIq3ZypL8c3QVpaULvLmKLP1PFlbs6vDJLX2aQq7ZdAKBtsIUf+HvF2t00f2NJaS1daiNnEPT8fE38lsRP1FQA/UM8/DOb423vqqLs4vVAb73BIrUKBxxiS7R3pb2l58RvXaDx0Lb6rVet993CdJBX3B1QwesZXaF9NwI7qlINHZOQsQJKYoOod2+6Mkw7R5KB8n+6w7J7zv8fSGJD5OnOb9ERXeT5i7W6d5+ekANv5CJBR/SQYsn2K7FIN6PomnIX7OMpshLJt7j/yvRZXf4XBSnFqXgK2XZHOJK1OF1+TZWWYyUGH9Susfk2IlgIKgcrxLc7bJuN3eNOxmsz0g3hHeDBZ9V0Jm0u3Wbg5xRGJvurEUaVy7eCEBWxHV06D2ByIuFFVCx11qUYU+/XLcZjqnh0En+a4Rbl+LWX3tXfCLrlFr6fZQqd3NrBkJmSqUqsU8UMk1XaO7LufdSOleoRIj0oAPpTmBVcttyKIV0Fg4qQc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yfvtZ2olPJ7ZG/YgcPd1DLcFJhd1IBxyizFW+sRBZQsKGbwsNhiToS+Achmf?=
 =?us-ascii?Q?IG4Tb2DLG5DqS212AYqWl69YQvFnxCk1qevN9wlqi1MZ3Nhf48CmsEXSeGFl?=
 =?us-ascii?Q?lNCGd/scByE2T7R9+TmkI+mFBYeXb2LlLrEs4WoGSLYrrpFSHN/GEDShYTkA?=
 =?us-ascii?Q?5pfAgtPgi8dpzH7BYJ7shLSXnm1YmYWTgig+2Sc2RAZOX0DSlNEH13Wy6SAx?=
 =?us-ascii?Q?K4rpHzjA41bXlFBRhCQT7FPT0Dh/t2jvyqXp1gQ59oJayi5ZIHDixbv37Di8?=
 =?us-ascii?Q?BGIe6YFLaRL60u3IAQd16FZM/jSYCrDlBKLmm6JfMgxz+pE1PDFDSAoL5o/a?=
 =?us-ascii?Q?AZ8Ao8PS0Y32xrFsJ04L7Dx/T3Auty4GVFnYcDLG0jzZ+TrDGd8BuVqZFXOX?=
 =?us-ascii?Q?W8zlaNd1nS1nXEnAbUtSaoQ5GgGOKa8IAaF8B9W7+kXo3Ycq7UhE4U8uyZ6K?=
 =?us-ascii?Q?9qjNdTU45fMnq/DJB1YXUHJuoDIKXTK/32uHuWqfzuHm5CbsFyw/3OBMKhzG?=
 =?us-ascii?Q?pGMuBD9QV3Kav3tQrzj1yW7wbeXvO+E9QZqDWqXPCes8XrbrOiDeNfqu37I8?=
 =?us-ascii?Q?2PoIktIzWaAYEqYaZP/gHk6stMkbj5lVFgXWDLyKBD6ufVpQZYDGqIHJS/KG?=
 =?us-ascii?Q?ygoibbyo+PSa1V3NZeFhLTeWzvjaoOVeEYzhkUAT6lt4WV8VYMCcMi2yWfEf?=
 =?us-ascii?Q?/iEYI5ER9P33t1Jmbg8lwYU/zlx9gbXMJKm0lhuHWgT5g/xtsBIElsGfQs1h?=
 =?us-ascii?Q?asNCOZb+kUT+3vuxeHHFb3Vx7lUFWqgU4zvSGIUZIOY7eleOmqh3AWlYM19p?=
 =?us-ascii?Q?2pVXKC1Yc92CfbkKhRfDFukk6bLbFAECdJC1oktrPENjxjbThHM7fFAWI899?=
 =?us-ascii?Q?uN7lbuwjmHc157R+MhsMxXYswxH9XB3ettwoE1fYL4AYeftM1HSbBBhJmB2v?=
 =?us-ascii?Q?zVTomgMqXoQEZiBBIZOTzadILZk6J3qfrIoCohAY5tva2OCQYHu3Bo5G50Gp?=
 =?us-ascii?Q?NtCMUVWd+WM0XR5GsszWdBx8BTwvIS+gwcilmCrHsts6+/xxc7MyQ8ObolDf?=
 =?us-ascii?Q?b4MAf+X0k4+RJ2PHbSS6YE56O9h0NuqSkWsPSxLgo3TgNmDJ6YNoKfgUcoPf?=
 =?us-ascii?Q?zhCi8e8xl2cUY6W+UPRGowsbid7/iPAGUQOFz0DYWYbJOZ/mQCFKoO5R/H0l?=
 =?us-ascii?Q?vYxTcE6YMcxSeisYxkXmwUJ2qbYRnXCZunWKkPycnoxCiPRCnqwyUuw5Zsvq?=
 =?us-ascii?Q?IhJl1bYyzIzJgB9O9Vk3DIcEplFZZOMIujMXoZmduBuaX3207qHp2rXozb65?=
 =?us-ascii?Q?DZyLcsx3+WMneB4bGdvFuajEIaju9UTDMsBhp8CM1/yoqyKxC+can/8cbWRD?=
 =?us-ascii?Q?w5yqk7Kpq9RrAeFXbVTe7H6a/arUd6xNM/e+NJnCujGcCdPIzjyAcF72deAe?=
 =?us-ascii?Q?pmnLeFnXo5h6oeTPGLW2nQzoaNG1/a97wRILLT4QjRprIvevbh+VXmIldptI?=
 =?us-ascii?Q?SNBWC5twiLrezBt3rR9Z3aXkk1Izx4rVjW5JgoWlUSN/8Tpp0pjgyy7u6Ltr?=
 =?us-ascii?Q?BFXDWVQqdRzAOv+vVQytUumG+9DiY+1hHMG0ZtiBug3cP1Fp81Raf8vXoGgi?=
 =?us-ascii?Q?fshORGxaocbi8fKsTq171Fk3MwxxpiEGVBYamQfCXcNVXBMLNB13nlJfFNlc?=
 =?us-ascii?Q?WU164pxinmm6rcPoaukDv6NowblXKwJYm4ACeffaiam8j9Bn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc2b3601-15d3-4018-e749-08de8ba23123
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 01:43:05.9479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v5eleq0P7XcRMZC+vtRHOpr67Qn3ka7oaIHWSQ7NPtLs4xLZ37NPFUEI90RXi+tX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9264

No one will be able to use it, so the related code can be removed in the
coming commits.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/Kconfig | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index bd283958d675..408fc7b82233 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -937,17 +937,6 @@ config THP_SWAP
 
 	  For selection by architectures with reasonable THP sizes.
 
-config READ_ONLY_THP_FOR_FS
-	bool "Read-only THP for filesystems (EXPERIMENTAL)"
-	depends on TRANSPARENT_HUGEPAGE
-
-	help
-	  Allow khugepaged to put read-only file-backed pages in THP.
-
-	  This is marked experimental because it is a new feature. Write
-	  support of file THPs will be developed in the next few release
-	  cycles.
-
 config NO_PAGE_MAPCOUNT
 	bool "No per-page mapcount (EXPERIMENTAL)"
 	help
-- 
2.43.0

