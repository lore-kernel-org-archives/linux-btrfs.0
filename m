Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011051.outbound.protection.outlook.com [52.101.62.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FB1282F08;
	Sun, 17 May 2026 13:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779026127; cv=fail; b=Xg9ILZxaBaMeZRrbn4c+bFhPvCtf4H/uXeISyCiLd5F1uPjs1kcZsASnD93nwFZwPa7fUVAuw01dJ9KsILit40OHJKQDGtJmYDedHTJ7M3AjPY4B8V2zmVmesEalpiq59LGFgm/ymyO20tG0XvI8fGS6IlbUPq9s6fE8Yk4QPi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779026127; c=relaxed/simple;
	bh=dZ37QKhIHn8ivDiVsyYmkDMBL0OV2qerAFITVE0HARU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TpDON+VG3T8QltuPoFlO6SPXmpkqB6NYOL9rzb41uYVGSZzrC4O9941x49eNS5evClXjspN1aRDjRlcA1s43B0tj13ANu8A32rpQwsZkqvVHkhLZsqcuiha1kU7y5UI/mtCFvN57trpifiSiKadXIXcrwqwqIXVGjkTKuJmipcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dKCAVhiS; arc=fail smtp.client-ip=52.101.62.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dKCAVhiS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZY6a6iZpbPl2uFyNpgydO68oMXMBBuxdaEsm5tp9/N2VtTwZxXnIKS5Gxh71YQVGZ1EjE8IhPHxwrfOVFHnGUHr/w+s7uw7RY7XSI62apSvyk5Ku/rNJyMlgZPvMB4n5xZYn8P2YiV/1FRFWIqR3MQTpjlBbQ9DDU4C00QvmjZcKXitsWL5Wzrlx8pzLLupG13f64PO6cw7r9k+OTSYdVjfa3H1o0FTrISQl7Oz+inLBqZfDGqDsjWWM4ev6KEn4KU3/RgjxAAYUBW7eXwWZOKzOtj0OcTvMPL77jchLDQOOW4vYB1hvxgpdijOUI4Sf2J4tenOHQJbb8aerLq4Z3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vSCnRMd4FcVrYz2vCXmH2+9aD3NPH3q9GjbPARil0mo=;
 b=hQ5hG6sp5d1DttCdQFO3Ez/YcMagVZnsoHNWbDY8KzL0/U2akPnkI78LwVr99VJDTa3EHOAQsmLYbQBdZ775OUxCVjt9DAcgTy/UpTcd3ugl08FJsGex9s7zfujgX0o9RkKVXYwlQx+Zyr9lajPrPuWpWJ3gombIurLKOYe176j+ozTcl4s7IBsPa3HAZpUBJTnve0uCukhal/C5mKhPsDr0BYD8IGuXIugJTZWQPOlaCMU09W9djzqfLjERR9q6CZ/J8t85NTaumsa+z0/6POFGNAm+d4owUEEFy6FmSVzJCx9mXeVrlervF5Wh2Hfv5cQfpmrkaYx9VJKYmH6tHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSCnRMd4FcVrYz2vCXmH2+9aD3NPH3q9GjbPARil0mo=;
 b=dKCAVhiSwmPjNz7RI/0A16DM2BcZBSEI+JDSrUPqcBeEelOuf1VXKYytlqNG0xqbgQay/hwFQZ9PTXcTQWwExqn4dootKFHA7Qer/rCtX2G/Qs6aSDvXwl3BcBHwCr0pHkkSBcsLPiSIMlf/hg+92vy7/ZXnvqI7Y5HWAwVVOWTBGsFgBPE33V2E6IjoSBQNgsGK+sR10IVd+dWVMY5VkEJFC7X6citYK+hTtGbGSYQ4oDLh2qIP1jRFbbV/ApJdNgknbrJ6+kIRgx7hlTmg/fLfo4mb1UBViJtJZktkhMqQvzNq6ysNImcfpHJSrxL7yZ6t5GOsewF/Y9l754al2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:10 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:10 +0000
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
Subject: [PATCH v6 10/14] fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
Date: Sun, 17 May 2026 09:54:12 -0400
Message-ID: <20260517135416.1434539-11-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0024.namprd05.prod.outlook.com (2603:10b6:610::37)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: f5ec5afd-dd51-45b3-1669-08deb41be965
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	TMMeH9uZVITkR68xf5Vr16kdmvFdnDK8SIVNZHNE413JDbCAHLwIo0IKwDEYeA3e/jbI2hh+4VuGm2wzfA3Tgxz56Y3FQDKK8c8Cz6Vp4lkfNVOX6XigPCtE3x0Tef6Gu6Y3asYT08KUd3aqFswRNFMiQxYzrlMxAPA2oVrx4Q1JmY8WEeuhVkWetwg5Q+cgS7HTl2HbPP3CS0Iuf5KB4HwFIHufDNGg91VdwFOcW++coEKk9fMGLHCUTo/FCWhbBGeLlkfQ2PPP8HYIzZz78/AjesOVBwdAv99ZTY5+FeuHz4fVi6fkqyJBT/4hoy/SKGqsry7ohlhm46OZBpyQbMvId5U4kC9NTk6p374cPAsevWwy57kIuZkNlwIg9dfw3gZaTeAt8a4/Tnbq3cKfe8vMxXQLPTz1O67NjMcIbiFKtr2+bOO80GubuepF/Nd416sSRAnZyT8i57Dmq4VH4AdfVlJRvmX0jMKtAVuQX51ebRvsT2Hq7cEuA3wyH2HE5fLBrHJMZIrRRglDk5pt7Tu6IgnMDQST0VoJ+68creSEUy9+GfoTqJWPOH9NEuCpUww7sw7YufYfHV1H6PUDve5LxiuNGgJpDKSzkcHzmc9Yckees3r1+piaMEq/J4Tz2fxU2lrbm1dOhw5A15X9uBVhKAq8mIVfYAM7Z9j65GyWeBzVVpbfbit4Z/mSWmXN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4eY96duLljuyFthO147K2GJalhKit/HumsaA3YH07zaanoZA7ERGbx0jgCag?=
 =?us-ascii?Q?R9/tmVWTpZ6sT3MKK69+7fEAhMSZqXQ9ZdWdueObA2oQLU4gX0SxRLC9qyQo?=
 =?us-ascii?Q?nKSU4YtN/Qs6Y2WoveEcGfR3zdQFQHua9nQVKeKED6+46V0RamRSmD/LHEq3?=
 =?us-ascii?Q?Gn/fZDfqZeDmUjwxnIB2+HxUeqD7SvFxa/3V0CNKJUabgawuesyJ8AxkyLjx?=
 =?us-ascii?Q?+Vb/GbC6hbJD8cEMbKhK5WqMBKSJrgmDn1xWe+mWzvN9qvus3rISQBiNJcNh?=
 =?us-ascii?Q?GSnagGAf+D6ok+gEfeQ4b76osjoS9sOlMlJTDC6PGvIfqrBdcBeztizz+tv8?=
 =?us-ascii?Q?zk2vcPZYzzlkJh4QMlZrS39uQlyPTTXJPlftRHE7KD+ZkGGX6LLxjkWebNRC?=
 =?us-ascii?Q?45H4/cjk8yLpOIVfAEHcDP7Z7Z1RqyRXw38O1Y8cZuPTZwicIsstioqgXYKj?=
 =?us-ascii?Q?uPVIKxD0Aq9I8+twg3qHH3Z+PaYR3g8iSE9wKW0bU1N5Jp8nvNFpmovKd/3W?=
 =?us-ascii?Q?0OGZyZ22RPgfbxUpQIXMWFnF3g7xXgppSkZ+8F/C6k8gNI5/xEJyQPSI5s53?=
 =?us-ascii?Q?R1Xfps1j9kzUDjVSOZtPan+guYhhFY0j5ou9KHHVJEDClRB4iYqEg5Y6Tc/h?=
 =?us-ascii?Q?vo8nFtAG3DXu3/1IpNXJ+f2vcLKxYoRo9IuGQuDZ4e18p3Y4QtPG3bRyf88Q?=
 =?us-ascii?Q?1+sMJImOifUMM+WFlv/Nk0e9Gl7rGdNwt28wHr3pomrhMG4TCVsll9FVATgi?=
 =?us-ascii?Q?o2UFu99Mm+D2PWfd24vOb/QV/Uxc1hjUZc8fuNT2GvtHT355trrK+hHw/L5J?=
 =?us-ascii?Q?zDsILXVrOmsAro35DTbpgmTAU+0nC1Yud0hR0QubGpQb6T42GqhOVZbm0NQ2?=
 =?us-ascii?Q?U/7gLYMOhMCxPw6qh9KTTElveU3CpJwPqHy1ENn0bxirzA+3xQr/+OeUDrvf?=
 =?us-ascii?Q?3a3UXG2msRxFLSYQ1un359wuPTX9/LNMyUHO1V49KuD+d9iJGmW71TInh7Xq?=
 =?us-ascii?Q?eGwqpFLLLYQ1Fc/Jurbdeik4wVM4KzRS2GW5gNOoXgEqv0OqCT1Gdm4K2Cdf?=
 =?us-ascii?Q?jYHtnde9x/BeJi5qMeKQw3yrWvf3nmHdfhmdSQssXIY3056wrertZIKeuPZY?=
 =?us-ascii?Q?rDgc3E7ci59S1Xz6G7DF5cSgqrypY6fYb6giFar9yv5CDU+52ZdJ2Ojw1/4V?=
 =?us-ascii?Q?KstB6Iwsq1V1j6SsCHAFiHGGcGP02cd44TuqS78anwUc0EH68ONaRw7rZ0w9?=
 =?us-ascii?Q?Moz+9OibA/jmYLIH8GRPYj/WYkEdBEdv01VfSROGi9SukfMEY7azIOodQtFT?=
 =?us-ascii?Q?xGp7pY1dYj3pEA0RwathQZVVDfYANNxzMrp/fT2dg8omsm4llvesujr5vq7R?=
 =?us-ascii?Q?T+Jsbz84/V86k8YpzEFXG+mRBpLedH/wObP9dkPSsDieES4ZpBALzVMmfo0Z?=
 =?us-ascii?Q?iRYThOIl10EHwDiC9Edy7RFBQKm193I5ciEcesjtXQcZVv+Lq1RSovXfbrOC?=
 =?us-ascii?Q?umBXCVDdds6jSafy7eoZyYuTBh3UrzqFUEoIBFYaWC2FBkR5C/lQ02MxI/H0?=
 =?us-ascii?Q?PTyLo5qVmbqyKhZ48qbsjoC3komDftSzyX0ka0szlJ2/4xJSpLhn487hTCzZ?=
 =?us-ascii?Q?azzl7gzu2S+B3HSeVJNRpKtB9Zhw9IyM4bQpDBALZHMaoR88iPyPmTfq4y06?=
 =?us-ascii?Q?qtXBZskIEr0KNfLqQ/iIsCieKG8jBS89vOcUc49/1TvufMVR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5ec5afd-dd51-45b3-1669-08deb41be965
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:10.6966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NDL+IV+3cD1OMCPkaEi42L1Pp6jO7fFYt8z1Q1xy29PPYpWipyKDqmOTnbJdgTlS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322

READ_ONLY_THP_FOR_FS is no longer present, remove related comment.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Sterba <dsterba@suse.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---
 fs/btrfs/defrag.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 7e2db5d3a4d4c..a8d49d9ca981c 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -860,9 +860,6 @@ static struct folio *defrag_prepare_one_folio(struct btrfs_inode *inode, pgoff_t
 		return folio;
 
 	/*
-	 * Since we can defragment files opened read-only, we can encounter
-	 * transparent huge pages here (see CONFIG_READ_ONLY_THP_FOR_FS).
-	 *
 	 * The IO for such large folios is not fully tested, thus return
 	 * an error to reject such folios unless it's an experimental build.
 	 *
-- 
2.53.0

